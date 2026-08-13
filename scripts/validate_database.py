#!/usr/bin/env python3
import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from world_mythology.db import PROJECT_ROOT
from world_mythology.validation import validate_database, write_validation_report


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Validate the mythology database.")
    parser.add_argument("--no-persist", action="store_true", help="do not update quality audit tables")
    args = parser.parse_args()
    result = validate_database(persist=not args.no_persist)
    write_validation_report(result, PROJECT_ROOT / "reports" / "data_quality.md")
    print(json.dumps(result, ensure_ascii=False, indent=2))
    raise SystemExit(1 if result["blocking"] else 0)
