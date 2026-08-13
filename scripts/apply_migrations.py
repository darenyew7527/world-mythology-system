#!/usr/bin/env python3
import argparse
import json
import sys
from pathlib import Path

PROJECT_DIR = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_DIR / "src"))

from world_mythology.db import DEFAULT_DB_PATH
from world_mythology.migrations import apply_migrations


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Apply append-only research migrations")
    parser.add_argument("--database", type=Path, default=DEFAULT_DB_PATH)
    args = parser.parse_args()
    print(json.dumps(apply_migrations(args.database.resolve()), ensure_ascii=False, indent=2))
