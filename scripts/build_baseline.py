#!/usr/bin/env python3
import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from world_mythology.builder import build_database
from world_mythology.db import DEFAULT_DB_PATH


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Explicit database initialization/rebuild command.")
    parser.add_argument("--database", type=Path, default=DEFAULT_DB_PATH)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--init", action="store_true", help="create only when no database exists")
    mode.add_argument("--rebuild", action="store_true", help="replace the current database with the seed baseline")
    args = parser.parse_args()
    target = args.database.resolve()
    if args.init and target.exists():
        parser.error(f"database already exists: {target}; use --rebuild explicitly")
    print(build_database(target))
