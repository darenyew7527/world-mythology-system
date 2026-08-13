#!/usr/bin/env python3
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from world_mythology.maintenance import check_alias_candidates, write_alias_report


if __name__ == "__main__":
    candidates = check_alias_candidates()
    report = write_alias_report(candidates)
    print(json.dumps({"candidate_groups": len(candidates), "report": str(report)}, ensure_ascii=False, indent=2))
