#!/usr/bin/env python3
"""Generate a human-readable catalogue of every SQLite table and view."""

from __future__ import annotations

import sqlite3
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT / "src"))

from world_mythology.db import DEFAULT_DB_PATH


def cell(value: object) -> str:
    if value is None:
        return ""
    return str(value).replace("|", "\\|").replace("\n", " ")


def generate(db_path: Path = DEFAULT_DB_PATH) -> Path:
    output = PROJECT_ROOT / "reports" / "schema_catalog.md"
    output.parent.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(f"file:{db_path.resolve()}?mode=ro", uri=True)
    conn.row_factory = sqlite3.Row
    objects = conn.execute(
        """
        SELECT name, type, sql
        FROM sqlite_master
        WHERE type IN ('table', 'view')
          AND name NOT LIKE 'sqlite_%'
        ORDER BY CASE type WHEN 'table' THEN 0 ELSE 1 END, name
        """
    ).fetchall()

    tables = [row for row in objects if row["type"] == "table"]
    views = [row for row in objects if row["type"] == "view"]
    lines = [
        "# SQLite Schema 全目录",
        "",
        f"数据库：`{db_path.name}`。本页由 `scripts/generate_schema_catalog.py` 从实际数据库反射生成。",
        "",
        f"- 持久表：{len(tables)}",
        f"- 只读视图：{len(views)}",
        "",
        "## 对象索引",
        "",
        "| 对象 | 类型 | 当前行数 |",
        "|---|---:|---:|",
    ]
    for row in objects:
        try:
            count = conn.execute(f'SELECT COUNT(*) FROM "{row["name"]}"').fetchone()[0]
        except sqlite3.DatabaseError:
            count = "n/a"
        lines.append(f'| `{cell(row["name"])}` | {row["type"]} | {count} |')

    for row in objects:
        name = row["name"]
        lines.extend([
            "",
            f'## `{cell(name)}` ({row["type"]})',
            "",
            "| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |",
            "|---:|---|---|---:|---|---:|",
        ])
        for column in conn.execute(f'PRAGMA table_info("{name}")'):
            lines.append(
                "| {cid} | `{name}` | {type} | {notnull} | {default} | {pk} |".format(
                    cid=column["cid"],
                    name=cell(column["name"]),
                    type=cell(column["type"]),
                    notnull=column["notnull"],
                    default=cell(column["dflt_value"]),
                    pk=column["pk"],
                )
            )
        foreign_keys = conn.execute(f'PRAGMA foreign_key_list("{name}")').fetchall()
        if foreign_keys:
            lines.extend([
                "",
                "外键：",
                "",
                "| 字段 | 目标 | ON UPDATE | ON DELETE |",
                "|---|---|---|---|",
            ])
            for fk in foreign_keys:
                lines.append(
                    f'| `{cell(fk["from"])}` | `{cell(fk["table"])}.{cell(fk["to"])}` | '
                    f'{cell(fk["on_update"])} | {cell(fk["on_delete"])} |'
                )
        lines.extend(["", "定义：", "", "```sql", row["sql"] or "", "```"])

    conn.close()
    output.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return output


if __name__ == "__main__":
    print(generate())
