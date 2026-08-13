#!/usr/bin/env python3
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from world_mythology.exporter import export_all


if __name__ == "__main__":
    print(json.dumps(export_all(), ensure_ascii=False, indent=2))
