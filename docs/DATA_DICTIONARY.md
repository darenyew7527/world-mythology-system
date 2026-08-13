# 数据字段说明 / Data Dictionary

## 设计原则

系统以稳定 ID 为主键。缺失资料在数据库中使用 `NULL` 和明确的研究状态，不用字符串 `Unknown` 冒充事实。一个实体可通过 `entity_classifications` 同时属于多个类型；例如 Ma'at 同时是神祇和秩序概念，Ymir 以巨人为主类型并保留原初存在分类。

## 核心身份层

| Table | Purpose | Key fields |
|---|---|---|
| `entities` | 神祇、英雄、怪物、神器、元素、事件、地点、文献、藏品等统一身份 | `id`, `canonical_name`, `primary_type`, `research_status`, `evidence_status` |
| `entity_types` | 可扩张的类型树 | `code`, `parent_code` |
| `entity_classifications` | 一个实体的多类型归类 | `entity_id`, `type_code`, `is_primary` |
| `entity_civilizations` | 实体与多个传统的可并存连接 | `association_role`, `certainty` |
| `civilizations` | 文明、宗教、族群、地方传统和史学总称 | `tradition_type`, `parent_id`, `region_id` |
| `cultures` | 文明内部的时期／文化语境 | `civilization_id`, `region_id` |
| `tradition_links` | 传统之间的层级、重叠、继承或影响 | `link_type` |

`SUBTRADITION_OF` 才是严格层级。`OVERLAPS_WITH`、`INFLUENCED_BY` 等不会触发身份合并。

## 来源登记

`sources` 可使用 URL / stable URL、DOI、ISBN、馆藏号或手稿号定位。`verification_status` 不等于学术可信度：`REGISTERED` 是登记，`URL_SYNTAX_VALID` 是结构检查，`WEB_CONFIRMED` 需要在 `notes` 中保存机器可读访问回执。`evidence_tier` 表示来源类型与材料的距离，不替代 claim 级证据判断。

## 名称与身份解析

| Table | Purpose |
|---|---|
| `names` | 原文名、规范名、译名、转写和称号；保存语言与文字信息 |
| `aliases` | 已解析或仍有争议的别名指向 |
| `identity_candidates` | 可能同一、来源内认同、争议身份或明确不同 |
| `entity_redirects` | 只用于已确认的真实重复记录 |

`normalized_text` 只用于搜索候选，不是展示文本，也不允许仅凭它自动 merge。

## Claim 与 Evidence

`claims` 保存可支持或反驳的语义命题：

- `subject_id`：被说明的实体。
- `predicate`：谓词，如 `PARENT_OF`、`USES`、`WORSHIPPED_AT`。
- `object_entity_id` / `object_literal`：严格二选一。
- `assertion_scope`：`IN_TRADITION`、`TEXT_SAYS`、`HISTORICAL_REALITY`、`SCHOLARLY_INTERPRETATION`、`MODERN_RECEPTION` 或 `SPECULATION`。
- `knowledge_layer`：考古、文本见证、神话叙事、仪式实践、学术解释、后世接受、流行文化或猜想。
- `review_status`：`UNVERIFIED`、`PROVISIONAL`、`VERIFIED`、`DISPUTED`、`REJECTED`。
- `variant_group`：把互相竞争或互补的版本放进同一研究问题。

`evidence` 多对一连接 claim，并记录：

- 精确位置：章、节、行、页、馆藏号或手稿号。
- `evidence_type`：原始文本、铭文、考古、手稿、口述传统、博物馆物件、现代研究等。
- `direction`：支持、反驳或仅提供语境。
- `strength`：该证据对当前 claim 的直接程度；不等于来源类型的等级。

`relationships` 是从实体对象 claim 自动投影的只读 view，防止 claim 与图谱边维护两份而漂移。`relationship_edges_bidirectional` 根据 `relationship_types.inverse_code` 动态生成反向边；对称关系也生成反向可查询边，但不会复制物理 claim。

`deities`、`creatures`、`concepts`、`texts`、`archaeological_sites` 等命名集合通过 `entity_classifications` 判断成员资格，不依赖 `primary_type`。因此 Tiamat 的次级 `DRAGON`、Ymir／盘古的次级 `PRIMORDIAL_DEITY` 等分类会进入相应视图、索引和专项档案。

## 专项档案

- `deity_profiles`：神祇类型、领域、能力、限制、形象、象征、崇拜摘要和命运摘要。
- `artifact_profiles`：神器／武器类型、材质、外形、能力、限制、使用条件、创造和去向。
- `creature_profiles`：怪物类别、形象、能力、弱点、栖息、来源和命运。
- `text_profiles`：文献类型、语言、作者／编者、产生期、现存见证、结构、馆藏和版权。
- `place_profiles`：现实遗址、现实圣地、神话地点、后世传说和现代猜想分层。
- `myth_event_profiles` / `event_participants`：事件类型、过程和参与者。
- `museum_object_profiles`：馆藏机构、编号、类型、出土地和取得信息。
- `modern_adaptations`：现代实体与古代原型的独立连接；现代能力不会写回古代实体。

## 研究与质量

- `collection_queue`：永久候选队列。
- `queue_discoveries`：一个候选的所有发现路径。
- `queue_status_history`：状态的追加式历史。
- `research_sessions`：每轮研究范围、策略和结果。
- `conflicts`：互斥 claim 或身份争议。
- `coverage_reports` / `coverage_metrics`：仅衡量当前登记基线。
- `quality_runs` / `quality_findings`：可复现的数据检查记录。
- `dataset_releases`：Schema、数据版本和构建检查点。

## 稳定 ID 约定

ID 采用可读、分层且稳定的字符串，例如：

- `deity.greek.zeus`
- `weapon.norse.mjolnir`
- `text.babylonian.enuma_elish`
- `site.greece.olympia`
- `source.unesco.olympia.517`

显示名可以变化，ID 不随译名变化。确认重复时使用 redirect，不重写历史引用。
