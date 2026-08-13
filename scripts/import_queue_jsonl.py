#!/usr/bin/env python3
import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from world_mythology.maintenance import import_queue_jsonl


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Validate or import collection-queue JSONL")
    parser.add_argument("input", type=Path)
    parser.add_argument("--apply", action="store_true", help="Write validated rows; default is dry-run")
    args = parser.parse_args()
    result = import_queue_jsonl(args.input, apply=args.apply)
    print(json.dumps(result, ensure_ascii=False, indent=2))
    raise SystemExit(1 if result["errors"] else 0)
