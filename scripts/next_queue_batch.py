#!/usr/bin/env python3
import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from world_mythology.maintenance import next_queue_batch


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Select the next finite batch from the permanent expansion queue")
    parser.add_argument("--limit", type=int, default=20)
    args = parser.parse_args()
    print(json.dumps(next_queue_batch(limit=max(1, min(args.limit, 500))), ensure_ascii=False, indent=2))
