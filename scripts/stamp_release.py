#!/usr/bin/env python3
"""Stamp a built database with its source commit and write an external hash receipt.

The database cannot contain its own final SHA-256 without changing that hash.
Therefore `dataset_releases.database_sha256` records the immediately preceding
unstamped snapshot, while `reports/release_stamp.json` records the final stamped
database artifact hash.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT / "src"))

from world_mythology.db import DEFAULT_DB_PATH, connect, sha256_file


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat(timespec="seconds").replace("+00:00", "Z")


def current_git_commit() -> str:
    return subprocess.run(
        ["git", "rev-parse", "HEAD"], cwd=PROJECT_ROOT, check=True,
        capture_output=True, text=True,
    ).stdout.strip()


def stamp(database: Path, git_commit: str) -> dict:
    input_hash = sha256_file(database)
    stamped_at = utc_now()
    with connect(database) as conn:
        release = conn.execute(
            "SELECT id,release_notes FROM dataset_releases ORDER BY built_at DESC,id DESC LIMIT 1"
        ).fetchone()
        if release is None:
            raise RuntimeError("dataset_releases is empty")
        stamp_note = " Source commit stamped; database_sha256 is the pre-stamp snapshot digest."
        notes = release["release_notes"] or ""
        if stamp_note.strip() not in notes:
            notes += stamp_note
        conn.execute(
            """UPDATE dataset_releases
               SET git_commit=?,database_sha256=?,release_notes=?
               WHERE id=?""",
            (git_commit, input_hash, notes, release["id"]),
        )
        conn.commit()
    final_hash = sha256_file(database)
    receipt = {
        "release_id": release["id"],
        "stamped_at": stamped_at,
        "source_git_commit": git_commit,
        "pre_stamp_database_sha256": input_hash,
        "final_database_sha256": final_hash,
        "hash_semantics": (
            "The in-database digest identifies the immediately preceding snapshot; "
            "this external receipt identifies the final stamped database artifact."
        ),
    }
    report_dir = PROJECT_ROOT / "reports"
    report_dir.mkdir(parents=True, exist_ok=True)
    (report_dir / "release_stamp.json").write_text(
        json.dumps(receipt, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    checkpoint_path = report_dir / "checkpoint.json"
    if checkpoint_path.exists():
        checkpoint = json.loads(checkpoint_path.read_text(encoding="utf-8"))
        checkpoint["database_sha256"] = final_hash
        checkpoint["source_git_commit"] = git_commit
        checkpoint["release_stamped_at"] = stamped_at
        checkpoint_path.write_text(
            json.dumps(checkpoint, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8"
        )
    return receipt


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--database", type=Path, default=DEFAULT_DB_PATH)
    parser.add_argument("--git-commit", default=None)
    args = parser.parse_args()
    result = stamp(args.database.resolve(), args.git_commit or current_git_commit())
    print(json.dumps(result, ensure_ascii=False, indent=2))
