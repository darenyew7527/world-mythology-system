#!/usr/bin/env python3
import argparse
import json
import sys
from pathlib import Path

PROJECT_DIR = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_DIR))
sys.path.insert(0, str(PROJECT_DIR / "src"))

from world_mythology.builder import build_database
from world_mythology.db import DEFAULT_DB_PATH, PROJECT_ROOT
from world_mythology.exporter import export_all
from world_mythology.maintenance import check_alias_candidates, check_sources, write_alias_report
from world_mythology.migrations import apply_migrations
from world_mythology.reporting import generate_reports
from world_mythology.validation import validate_database, write_validation_report
from scripts.generate_delivery_index import generate as generate_delivery_index
from scripts.generate_offline_archive import DEFAULT_MARKDOWN_DIR, generate as generate_offline_archive
from scripts.generate_schema_catalog import generate as generate_schema_catalog
from scripts.generate_web_data import DEFAULT_OUTPUT as WEB_DATA_OUTPUT, build_snapshot, write_snapshot


def prepare_database(database: Path, *, init: bool = False, rebuild: bool = False) -> Path:
    """Resolve database lifecycle without silently replacing accumulated research."""
    if init and rebuild:
        raise ValueError("--init and --rebuild are mutually exclusive")
    if rebuild:
        return build_database(database)
    if init:
        if database.exists():
            raise FileExistsError(f"database already exists: {database}; use --rebuild explicitly")
        return build_database(database)
    if not database.exists():
        raise FileNotFoundError(f"database not found: {database}; use --init to create it")
    return database


def run_pipeline(database: Path, *, export_root: Path | None = None,
                 generate_reading_outputs: bool = True) -> dict:
    migrations = apply_migrations(database)
    validation = validate_database(database, persist=True)
    write_validation_report(validation, PROJECT_ROOT / "reports" / "data_quality.md")
    if validation["blocking"]:
        raise RuntimeError(json.dumps(validation, ensure_ascii=False, indent=2))
    checkpoint = generate_reports(database) if generate_reading_outputs else None
    # Reporting persists coverage checkpoints, so export only after reports have
    # finished. This keeps JSONL/CSV a complete snapshot of the final database.
    manifest = export_all(database, export_root)
    if generate_reading_outputs:
        generate_schema_catalog(database)
    alias_candidates = check_alias_candidates(database)
    write_alias_report(alias_candidates)
    source_check = check_sources(database)
    if source_check["status"] != "PASS":
        raise RuntimeError(json.dumps(source_check, ensure_ascii=False, indent=2))
    if generate_reading_outputs:
        generate_delivery_index(database)
        write_snapshot(build_snapshot(database), WEB_DATA_OUTPUT)
        offline_archive = generate_offline_archive(database, markdown_dir=DEFAULT_MARKDOWN_DIR)
    else:
        offline_archive = None
    return {"database": str(database), "migrations_applied": migrations,
            "validation": validation["status"],
            "export_counts": manifest["counts"], "checkpoint": checkpoint,
            "alias_candidate_groups": len(alias_candidates), "source_check": source_check["status"],
            "offline_archive": offline_archive}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Validate and export an existing mythology database safely.")
    parser.add_argument("--database", type=Path, default=DEFAULT_DB_PATH)
    parser.add_argument("--export-root", type=Path)
    lifecycle = parser.add_mutually_exclusive_group()
    lifecycle.add_argument("--init", action="store_true", help="create the database only if it does not exist")
    lifecycle.add_argument("--rebuild", action="store_true", help="explicitly replace the database with the seed baseline")
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    try:
        database = prepare_database(args.database.resolve(), init=args.init, rebuild=args.rebuild)
        result = run_pipeline(database, export_root=args.export_root)
    except (FileNotFoundError, FileExistsError, ValueError, RuntimeError) as exc:
        print(str(exc), file=sys.stderr)
        raise SystemExit(1)
    print(json.dumps(result, ensure_ascii=False, indent=2))
