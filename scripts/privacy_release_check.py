from __future__ import annotations

import argparse
import re
import sqlite3
import sys
from pathlib import Path


PATTERNS = {
    "private_key": re.compile(rb"-----BEGIN [A-Z ]*PRIVATE KEY-----"),
    "github_token": re.compile(rb"gh[pousr]_[A-Za-z0-9_]{20,}"),
    "openai_key": re.compile(rb"sk-[A-Za-z0-9_-]{20,}"),
    "aws_access_key": re.compile(rb"AKIA[0-9A-Z]{16}"),
    "bearer_token": re.compile(rb"Bearer\s+[A-Za-z0-9._~+/-]{20,}"),
    "generation_instance_metadata": re.compile(rb"(?:c2pa|OpenAI Media Service|gpt-image)", re.IGNORECASE),
}
LOCAL_PATH_FRAGMENTS = (
    b"/" + b"workspace" + b"/",
    b"/" + b"root" + b"/",
    b"/" + b"home" + b"/",
    b"/" + b"Users" + b"/",
)
WINDOWS_USER_PATH = re.compile(rb"[A-Za-z]:\\" + b"Users" + rb"\\", re.IGNORECASE)


def _scan(path: Path) -> list[str]:
    data = path.read_bytes()
    matches = [name for name, pattern in PATTERNS.items() if pattern.search(data)]
    if any(fragment in data for fragment in LOCAL_PATH_FRAGMENTS) or WINDOWS_USER_PATH.search(data):
        matches.append("absolute_local_path")
    return matches


def check(paths: list[Path]) -> list[dict[str, object]]:
    problems: list[dict[str, object]] = []
    for path in paths:
        if not path.exists() or not path.is_file():
            continue
        matches = _scan(path)
        if matches:
            problems.append({"path": str(path), "matches": matches})
        if path.suffix == ".sqlite":
            connection = sqlite3.connect(f"file:{path}?mode=ro", uri=True)
            try:
                integrity = connection.execute("PRAGMA integrity_check").fetchone()[0]
                if integrity != "ok":
                    problems.append({"path": str(path), "matches": [f"sqlite:{integrity}"]})
            finally:
                connection.close()
    return problems


def release_files(project_root: Path) -> list[Path]:
    files = [
        project_root / "database" / "world_mythology.sqlite",
        project_root / "docs" / "design" / "public-explorer-desktop.png",
        project_root / "docs" / "design" / "public-explorer-mobile.png",
    ]
    for directory in (project_root / "exports" / "jsonl", project_root / "exports" / "csv"):
        if directory.exists():
            files.extend(path for path in directory.iterdir() if path.is_file())
    return sorted(files)


def main() -> int:
    parser = argparse.ArgumentParser(description="Fail when public data artifacts contain local paths or credential forms")
    parser.add_argument("paths", nargs="*", type=Path)
    args = parser.parse_args()
    project_root = Path(__file__).resolve().parents[1]
    paths = args.paths or release_files(project_root)
    problems = check(paths)
    if problems:
        for problem in problems:
            print(f"BLOCK: {problem['path']}: {', '.join(problem['matches'])}")
        return 1
    print(f"PASS: privacy release gate scanned {len(paths)} files")
    return 0


if __name__ == "__main__":
    sys.exit(main())
