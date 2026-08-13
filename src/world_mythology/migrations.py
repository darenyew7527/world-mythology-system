from __future__ import annotations

import re
from pathlib import Path

from .db import DEFAULT_DB_PATH, PROJECT_ROOT, connect


MIGRATIONS_DIR = PROJECT_ROOT / "migrations"
MIGRATION_RE = re.compile(r"^(\d+)_.*\.sql$")


def apply_migrations(database: Path | str = DEFAULT_DB_PATH) -> list[dict[str, object]]:
    """Apply versioned, self-registering SQL migrations in numeric order.

    Migration files are append-only research checkpoints.  Each file owns its
    transaction and must insert its version into ``schema_migrations`` before
    committing.  This lets a baseline rebuild replay accumulated research
    without silently replacing later work.
    """
    if not MIGRATIONS_DIR.exists():
        return []

    applied: list[dict[str, object]] = []
    with connect(database) as conn:
        known = {int(row[0]) for row in conn.execute("SELECT version FROM schema_migrations")}
        candidates: list[tuple[int, Path]] = []
        for path in MIGRATIONS_DIR.glob("*.sql"):
            match = MIGRATION_RE.match(path.name)
            if match:
                candidates.append((int(match.group(1)), path))

        for version, path in sorted(candidates):
            if version in known:
                continue
            conn.executescript(path.read_text(encoding="utf-8"))
            row = conn.execute(
                "SELECT name, applied_at FROM schema_migrations WHERE version=?", (version,)
            ).fetchone()
            if row is None:
                raise RuntimeError(
                    f"migration {path.name} did not register schema_migrations version {version}"
                )
            known.add(version)
            applied.append({"version": version, "name": row["name"], "path": str(path)})
    return applied
