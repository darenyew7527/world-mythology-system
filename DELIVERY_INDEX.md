# 世界神话系统：交付总索引

当前公开可发现资料的阶段性知识基线已经建立，并且系统可以继续扩张。它不是 `ALL COMPLETE`，初始清单也不是范围上限。

## 当前数据库快照

| 指标 | 数量 |
|---|---:|
| 文明／传统 | 95 |
| 文化语境 | 18 |
| 语言 | 21 |
| 统一实体 | 506 |
| 实体重定向／去重审计 | 5 |
| 多类型分类 | 534 |
| 名称与译名 | 1170 |
| 来源 | 129 |
| Claims | 286 |
| Evidence | 282 |
| 关系边（直接） | 257 |
| 显式冲突 | 10 |
| 永久研究队列 | 51 |

来源登记状态：`URL_SYNTAX_VALID` 129。

## 直接打开这些文件

- `database/world_mythology.sqlite`：事实核心数据库。
- `RELEASE_NOTES_v0.6.0.md`：v0.6 雷神对照、Thor／Loki 家谱修正与数据边界。
- `RELEASE_NOTES_v0.5.1.md`：v0.5.1 手机版图谱修复说明与数据边界。
- `RELEASE_NOTES_v0.5.0.md`：v0.5.0 中文发布说明、证据边界与后续队列。
- `schema/schema.sql`：完整 SQLite Schema。
- `reports/schema_catalog.md`：从实际数据库生成的逐表、逐字段、外键与 SQL 定义。
- `reports/source_registry.md`：全部来源、机构、定位符、验证状态和文化／使用限制。
- `exports/jsonl/`、`exports/csv/`：全部持久表的交换导出。
- `exports/graph/`：JSON、CSV、GraphML 知识图谱。
- `profiles/entities/`：每个实体的 Markdown 阅读档案。
- `visualization/index.html`：静态关系网络基础。
- `web/`：中文优先、可切换英文的 React/Vite 公开探索器。
- `web/public/data/site-data.json`：不含证据短引文的浏览器安全数据快照。
- `docs/design/public-explorer-desktop.png`：公开探索器桌面截图。
- `api/openapi.yaml`：只读 API 契约。
- `assets/world_mythology_system_reference.jpeg`：用户提供的视觉架构参考，不作为事实来源。

## 阅读索引

- `profiles/indexes/artifacts.md`
- `profiles/indexes/civilizations.md`
- `profiles/indexes/creatures.md`
- `profiles/indexes/deities.md`
- `profiles/indexes/elements.md`
- `profiles/indexes/events.md`
- `profiles/indexes/sites.md`
- `profiles/indexes/sources.md`
- `profiles/indexes/texts.md`

## 审计与研究报告

- `reports/alias_candidates.md`
- `reports/checkpoint.json`
- `reports/conflicts.md`
- `reports/coverage_report.md`
- `reports/data_quality.md`
- `reports/missing_data.md`
- `reports/release_stamp.json`
- `reports/research_queue.md`
- `reports/research_session_20260811_expansion1.md`
- `reports/schema_catalog.md`
- `reports/source_registry.md`
- `reports/source_validation.md`
- `reports/web_fidelity_0.3.0.md`

## 核心设计说明

- `README.md`：用途、快速开始与真实性规则。
- `docs/DATA_DICTIONARY.md`：数据字段与稳定 ID。
- `docs/METHODOLOGY.md`：来源、证据、版本和活态传统方法。
- `docs/ARCHITECTURE.md`：数据流、API、PostgreSQL 与产品架构。
- `docs/ERD.md`：核心实体关系图；完整字段仍以 Schema Catalog 为准。
- `CONTRIBUTING.md`：中文优先的贡献流程与资料要求。
- `DATA_LICENSE.md`：结构化数据许可与第三方／文化权限边界。

## 复现命令

```bash
python3 scripts/build_baseline.py --rebuild  # 仅显式重建基线
python3 scripts/run_pipeline.py         # 保留现有研究数据，验证并重生成投影
python3 -m unittest discover -s tests -v
python3 scripts/privacy_release_check.py
python3 scripts/build_release_package.py --output RELEASE.zip --bundle CHECKPOINT.git.bundle
python3 scripts/generate_web_data.py
cd web && npm ci && npm run build
```

覆盖率只描述当前登记基线；缺失和冲突会回流到永久研究队列。
