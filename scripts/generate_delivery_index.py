#!/usr/bin/env python3
"""Generate the top-level delivery map from the current database and files."""

from __future__ import annotations

import sqlite3
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT / "src"))

from world_mythology.db import DEFAULT_DB_PATH


COUNT_OBJECTS = [
    ("文明／传统", "civilizations"),
    ("文化语境", "cultures"),
    ("语言", "languages"),
    ("统一实体", "entities"),
    ("实体重定向／去重审计", "entity_redirects"),
    ("多类型分类", "entity_classifications"),
    ("名称与译名", "names"),
    ("来源", "sources"),
    ("Claims", "claims"),
    ("Evidence", "evidence"),
    ("关系边（直接）", "relationships"),
    ("显式冲突", "conflicts"),
    ("永久研究队列", "collection_queue"),
    ("可阅读故事", "stories"),
    ("故事文本版本", "story_versions"),
    ("故事阅读分段", "story_sections"),
]


def generate(db_path: Path = DEFAULT_DB_PATH) -> Path:
    output = PROJECT_ROOT / "DELIVERY_INDEX.md"
    conn = sqlite3.connect(f"file:{db_path.resolve()}?mode=ro", uri=True)
    rows = [(label, conn.execute(f'SELECT COUNT(*) FROM "{table}"').fetchone()[0]) for label, table in COUNT_OBJECTS]
    source_statuses = conn.execute(
        "SELECT verification_status, COUNT(*) FROM sources GROUP BY verification_status ORDER BY verification_status"
    ).fetchall()
    conn.close()

    profile_indexes = sorted(path.relative_to(PROJECT_ROOT).as_posix() for path in (PROJECT_ROOT / "profiles" / "indexes").glob("*.md"))
    reports = sorted(path.relative_to(PROJECT_ROOT).as_posix() for path in (PROJECT_ROOT / "reports").glob("*.*"))

    lines = [
        "# 世界神话系统：交付总索引",
        "",
        "当前公开可发现资料的阶段性知识基线已经建立，并且系统可以继续扩张。它不是 `ALL COMPLETE`，初始清单也不是范围上限。",
        "",
        "## 当前数据库快照",
        "",
        "| 指标 | 数量 |",
        "|---|---:|",
    ]
    lines.extend(f"| {label} | {count} |" for label, count in rows)
    lines.extend([
        "",
        "来源登记状态：" + "；".join(f"`{status}` {count}" for status, count in source_statuses) + "。",
        "",
        "## 直接打开这些文件",
        "",
        "- `database/world_mythology.sqlite`：事实核心数据库。",
        "- `RELEASE_NOTES_v0.25.0.md`：v0.25 神话故事阅读库、版本分离、证据链接与阅读边界。",
        "- `docs/ROADMAP_v0.26-v0.29.md`：后续故事地图、见证对读、全球扩张与阅读工具路线。",
        "- `RELEASE_NOTES_v0.14.0.md`：v0.14 苏萨大流士雕像发掘、转运、遗址与馆藏来源链。",
        "- `RELEASE_NOTES_v0.13.0.md`：v0.13 苏萨大流士雕像 DSab 三语铭文与象形文字证据层。",
        "- `RELEASE_NOTES_v0.12.0.md`：v0.12 Ra-Atum 分期见证、《亡灵书》第15章与苏萨大流士雕像。",
        "- `RELEASE_NOTES_v0.11.0.md`：v0.11 卜塔-索卡尔-奥西里斯复合神与器物证据层。",
        "- `RELEASE_NOTES_v0.10.0.md`：v0.10 日本地方雷神、贺茂神社、活态祭礼与后世图像证据层。",
        "- `RELEASE_NOTES_v0.9.0.md`：v0.9 Perses 同名实体拆分与古代文本证据审计。",
        "- `RELEASE_NOTES_v0.8.0.md`：v0.8 厄琉息斯仪式、遗址、铭文与馆藏证据层。",
        "- `RELEASE_NOTES_v0.7.0.md`：v0.7 埃及太阳复合神格、神庙与馆藏证据边界。",
        "- `RELEASE_NOTES_v0.6.0.md`：v0.6 雷神对照、Thor／Loki 家谱修正与数据边界。",
        "- `RELEASE_NOTES_v0.5.1.md`：v0.5.1 手机版图谱修复说明与数据边界。",
        "- `RELEASE_NOTES_v0.5.0.md`：v0.5.0 中文发布说明、证据边界与后续队列。",
        "- `schema/schema.sql`：完整 SQLite Schema。",
        "- `reports/schema_catalog.md`：从实际数据库生成的逐表、逐字段、外键与 SQL 定义。",
        "- `reports/source_registry.md`：全部来源、机构、定位符、验证状态和文化／使用限制。",
        "- `exports/jsonl/`、`exports/csv/`：全部持久表的交换导出。",
        "- `exports/graph/`：JSON、CSV、GraphML 知识图谱。",
        "- `profiles/entities/`：每个实体的 Markdown 阅读档案。",
        "- `profiles/stories/index.md`：可下载的完整故事阅读档案索引。",
        "- `visualization/index.html`：静态关系网络基础。",
        "- `web/`：中文优先、可切换英文的 React/Vite 公开探索器。",
        "- `web/public/data/site-data.json`：不含证据短引文的浏览器安全数据快照。",
        "- `docs/design/public-explorer-desktop.png`：公开探索器桌面截图。",
        "- `api/openapi.yaml`：只读 API 契约。",
        "- `assets/world_mythology_system_reference.jpeg`：用户提供的视觉架构参考，不作为事实来源。",
        "",
        "## 阅读索引",
        "",
    ])
    lines.extend(f"- `{path}`" for path in profile_indexes)
    lines.extend(["", "## 审计与研究报告", ""])
    lines.extend(f"- `{path}`" for path in reports)
    lines.extend([
        "",
        "## 核心设计说明",
        "",
        "- `README.md`：用途、快速开始与真实性规则。",
        "- `docs/DATA_DICTIONARY.md`：数据字段与稳定 ID。",
        "- `docs/METHODOLOGY.md`：来源、证据、版本和活态传统方法。",
        "- `docs/ARCHITECTURE.md`：数据流、API、PostgreSQL 与产品架构。",
        "- `docs/ERD.md`：核心实体关系图；完整字段仍以 Schema Catalog 为准。",
        "- `CONTRIBUTING.md`：中文优先的贡献流程与资料要求。",
        "- `DATA_LICENSE.md`：结构化数据许可与第三方／文化权限边界。",
        "",
        "## 复现命令",
        "",
        "```bash",
        "python3 scripts/build_baseline.py --rebuild  # 仅显式重建基线",
        "python3 scripts/run_pipeline.py         # 保留现有研究数据，验证并重生成投影",
        "python3 -m unittest discover -s tests -v",
        "python3 scripts/privacy_release_check.py",
        "python3 scripts/build_release_package.py --output RELEASE.zip --bundle CHECKPOINT.git.bundle",
        "python3 scripts/generate_web_data.py",
        "cd web && npm ci && npm run build",
        "```",
        "",
        "覆盖率只描述当前登记基线；缺失和冲突会回流到永久研究队列。",
    ])
    output.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return output


if __name__ == "__main__":
    print(generate())
