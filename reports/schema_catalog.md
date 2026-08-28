# SQLite Schema 全目录

数据库：`world_mythology.sqlite`。本页由 `scripts/generate_schema_catalog.py` 从实际数据库反射生成。

- 持久表：47
- 只读视图：32

## 对象索引

| 对象 | 类型 | 当前行数 |
|---|---:|---:|
| `aliases` | table | 14 |
| `artifact_profiles` | table | 38 |
| `civilization_languages` | table | 23 |
| `civilizations` | table | 99 |
| `claims` | table | 605 |
| `collection_queue` | table | 109 |
| `comparison_set_members` | table | 16 |
| `comparison_sets` | table | 2 |
| `conflicts` | table | 32 |
| `coverage_metrics` | table | 718 |
| `coverage_reports` | table | 24 |
| `creature_profiles` | table | 17 |
| `cultures` | table | 18 |
| `dataset_releases` | table | 24 |
| `deity_profiles` | table | 177 |
| `entities` | table | 635 |
| `entity_attributes` | table | 0 |
| `entity_civilizations` | table | 580 |
| `entity_classifications` | table | 663 |
| `entity_redirects` | table | 5 |
| `entity_types` | table | 55 |
| `event_participants` | table | 21 |
| `evidence` | table | 601 |
| `explorer_feature_registry` | table | 10 |
| `identity_candidates` | table | 21 |
| `import_errors` | table | 0 |
| `import_runs` | table | 0 |
| `languages` | table | 25 |
| `modern_adaptations` | table | 3 |
| `museum_object_profiles` | table | 24 |
| `myth_event_profiles` | table | 16 |
| `names` | table | 1364 |
| `place_profiles` | table | 91 |
| `project_metadata` | table | 6 |
| `quality_findings` | table | 0 |
| `quality_runs` | table | 1 |
| `queue_discoveries` | table | 99 |
| `queue_status_history` | table | 76 |
| `regions` | table | 22 |
| `relationship_types` | table | 80 |
| `research_session_items` | table | 516 |
| `research_sessions` | table | 23 |
| `schema_migrations` | table | 33 |
| `sources` | table | 203 |
| `text_profiles` | table | 150 |
| `tradition_access_policies` | table | 8 |
| `tradition_links` | table | 6 |
| `archaeological_sites` | view | 79 |
| `artifacts` | view | 38 |
| `claim_evidence_summary` | view | 605 |
| `concepts` | view | 57 |
| `cosmologies` | view | 1 |
| `creatures` | view | 17 |
| `deities` | view | 177 |
| `elements` | view | 32 |
| `events` | view | 14 |
| `festivals` | view | 4 |
| `heroes` | view | 15 |
| `historical_figures` | view | 5 |
| `inscriptions` | view | 18 |
| `manuscripts` | view | 9 |
| `monuments` | view | 6 |
| `museum_objects` | view | 24 |
| `mythical_places` | view | 1 |
| `myths` | view | 0 |
| `oral_traditions` | view | 10 |
| `papyri` | view | 1 |
| `powers` | view | 7 |
| `pyramids` | view | 2 |
| `realms` | view | 4 |
| `relationship_edges_bidirectional` | view | 958 |
| `relationships` | view | 479 |
| `rituals` | view | 6 |
| `sacred_objects` | view | 1 |
| `tablets` | view | 4 |
| `temples` | view | 15 |
| `texts` | view | 150 |
| `tombs` | view | 2 |
| `weapons` | view | 26 |

## `aliases` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `alias_text` | TEXT | 1 |  | 0 |
| 2 | `normalized_text` | TEXT | 1 |  | 0 |
| 3 | `language_id` | TEXT | 0 |  | 0 |
| 4 | `entity_id` | TEXT | 0 |  | 0 |
| 5 | `candidate_entity_id` | TEXT | 0 |  | 0 |
| 6 | `resolution_status` | TEXT | 1 | 'RESOLVED' | 0 |
| 7 | `confidence` | REAL | 0 |  | 0 |
| 8 | `source_id` | TEXT | 0 |  | 0 |
| 9 | `notes` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `source_id` | `sources.id` | NO ACTION | NO ACTION |
| `candidate_entity_id` | `entities.id` | NO ACTION | NO ACTION |
| `entity_id` | `entities.id` | NO ACTION | CASCADE |
| `language_id` | `languages.id` | NO ACTION | NO ACTION |

定义：

```sql
CREATE TABLE aliases (
    id TEXT PRIMARY KEY,
    alias_text TEXT NOT NULL,
    normalized_text TEXT NOT NULL,
    language_id TEXT REFERENCES languages(id),
    entity_id TEXT REFERENCES entities(id) ON DELETE CASCADE,
    candidate_entity_id TEXT REFERENCES entities(id),
    resolution_status TEXT NOT NULL DEFAULT 'RESOLVED'
        CHECK(resolution_status IN ('RESOLVED','CANDIDATE','AMBIGUOUS','DISPUTED','REJECTED')),
    confidence REAL CHECK(confidence IS NULL OR confidence BETWEEN 0 AND 1),
    source_id TEXT REFERENCES sources(id),
    notes TEXT,
    CHECK(entity_id IS NOT NULL OR candidate_entity_id IS NOT NULL)
)
```

## `artifact_profiles` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `entity_id` | TEXT | 0 |  | 1 |
| 1 | `artifact_type` | TEXT | 1 |  | 0 |
| 2 | `material_json` | TEXT | 1 | '[]' | 0 |
| 3 | `appearance_json` | TEXT | 1 | '{}' | 0 |
| 4 | `abilities_json` | TEXT | 1 | '[]' | 0 |
| 5 | `limitations_json` | TEXT | 1 | '[]' | 0 |
| 6 | `usage_conditions_json` | TEXT | 1 | '[]' | 0 |
| 7 | `creation_summary` | TEXT | 0 |  | 0 |
| 8 | `fate_summary` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `entity_id` | `entities.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE artifact_profiles (
    entity_id TEXT PRIMARY KEY REFERENCES entities(id) ON DELETE CASCADE,
    artifact_type TEXT NOT NULL,
    material_json TEXT NOT NULL DEFAULT '[]',
    appearance_json TEXT NOT NULL DEFAULT '{}',
    abilities_json TEXT NOT NULL DEFAULT '[]',
    limitations_json TEXT NOT NULL DEFAULT '[]',
    usage_conditions_json TEXT NOT NULL DEFAULT '[]',
    creation_summary TEXT,
    fate_summary TEXT
)
```

## `civilization_languages` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `civilization_id` | TEXT | 1 |  | 1 |
| 1 | `language_id` | TEXT | 1 |  | 2 |
| 2 | `usage_role` | TEXT | 1 | 'ATTESTED' | 3 |
| 3 | `notes` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `language_id` | `languages.id` | NO ACTION | CASCADE |
| `civilization_id` | `civilizations.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE civilization_languages (
    civilization_id TEXT NOT NULL REFERENCES civilizations(id) ON DELETE CASCADE,
    language_id TEXT NOT NULL REFERENCES languages(id) ON DELETE CASCADE,
    usage_role TEXT NOT NULL DEFAULT 'ATTESTED',
    notes TEXT,
    PRIMARY KEY (civilization_id, language_id, usage_role)
)
```

## `civilizations` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `canonical_name` | TEXT | 1 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `parent_id` | TEXT | 0 |  | 0 |
| 5 | `region_id` | TEXT | 0 |  | 0 |
| 6 | `tradition_type` | TEXT | 1 | 'CIVILIZATION' | 0 |
| 7 | `period_start` | TEXT | 0 |  | 0 |
| 8 | `period_end` | TEXT | 0 |  | 0 |
| 9 | `description` | TEXT | 0 |  | 0 |
| 10 | `research_status` | TEXT | 1 | 'DISCOVERED' | 0 |
| 11 | `evidence_status` | TEXT | 1 | 'UNVERIFIED' | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `region_id` | `regions.id` | NO ACTION | NO ACTION |
| `parent_id` | `civilizations.id` | NO ACTION | NO ACTION |

定义：

```sql
CREATE TABLE civilizations (
    id TEXT PRIMARY KEY,
    canonical_name TEXT NOT NULL,
    name_zh TEXT,
    original_name TEXT,
    parent_id TEXT REFERENCES civilizations(id),
    region_id TEXT REFERENCES regions(id),
    tradition_type TEXT NOT NULL DEFAULT 'CIVILIZATION',
    period_start TEXT,
    period_end TEXT,
    description TEXT,
    research_status TEXT NOT NULL DEFAULT 'DISCOVERED'
        CHECK (research_status IN ('DISCOVERED','COLLECTING','PARTIAL','BASELINE_COMPLETE','NEEDS_REVIEW','CONFLICT','LOW_EVIDENCE','EXPAND_LATER')),
    evidence_status TEXT NOT NULL DEFAULT 'UNVERIFIED'
        CHECK (evidence_status IN ('UNVERIFIED','PARTIAL','SOURCE_BACKED','CONFLICTING')),
    UNIQUE(canonical_name, parent_id)
)
```

## `claims` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `subject_id` | TEXT | 1 |  | 0 |
| 2 | `predicate` | TEXT | 1 |  | 0 |
| 3 | `object_entity_id` | TEXT | 0 |  | 0 |
| 4 | `object_literal` | TEXT | 0 |  | 0 |
| 5 | `object_datatype` | TEXT | 0 |  | 0 |
| 6 | `statement` | TEXT | 1 |  | 0 |
| 7 | `variant_group` | TEXT | 0 |  | 0 |
| 8 | `claim_status` | TEXT | 1 | 'SUPPORTED' | 0 |
| 9 | `confidence` | REAL | 1 | 0.5 | 0 |
| 10 | `confidence_level` | TEXT | 1 | 'UNKNOWN' | 0 |
| 11 | `review_status` | TEXT | 1 | 'PROVISIONAL' | 0 |
| 12 | `assertion_scope` | TEXT | 1 | 'IN_TRADITION' | 0 |
| 13 | `knowledge_layer` | TEXT | 1 | 'MYTHIC_NARRATIVE' | 0 |
| 14 | `tradition_scope` | TEXT | 0 |  | 0 |
| 15 | `temporal_scope` | TEXT | 0 |  | 0 |
| 16 | `research_notes` | TEXT | 0 |  | 0 |
| 17 | `created_at` | TEXT | 1 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `object_entity_id` | `entities.id` | NO ACTION | NO ACTION |
| `subject_id` | `entities.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE claims (
    id TEXT PRIMARY KEY,
    subject_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    predicate TEXT NOT NULL,
    object_entity_id TEXT REFERENCES entities(id),
    object_literal TEXT,
    object_datatype TEXT,
    statement TEXT NOT NULL,
    variant_group TEXT,
    claim_status TEXT NOT NULL DEFAULT 'SUPPORTED'
        CHECK(claim_status IN ('ASSERTED','SUPPORTED','DISPUTED','REFUTED','INTERPRETIVE','SPECULATIVE','UNRESOLVED')),
    confidence REAL NOT NULL DEFAULT 0.5 CHECK(confidence BETWEEN 0 AND 1),
    confidence_level TEXT NOT NULL DEFAULT 'UNKNOWN'
        CHECK(confidence_level IN ('HIGH','MEDIUM','LOW','UNKNOWN')),
    review_status TEXT NOT NULL DEFAULT 'PROVISIONAL'
        CHECK(review_status IN ('UNVERIFIED','PROVISIONAL','VERIFIED','DISPUTED','REJECTED')),
    assertion_scope TEXT NOT NULL DEFAULT 'IN_TRADITION'
        CHECK(assertion_scope IN ('IN_TRADITION','TEXT_SAYS','HISTORICAL_REALITY','SCHOLARLY_INTERPRETATION','MODERN_RECEPTION','SPECULATION')),
    knowledge_layer TEXT NOT NULL DEFAULT 'MYTHIC_NARRATIVE'
        CHECK(knowledge_layer IN ('ARCHAEOLOGICAL','TEXTUAL_WITNESS','MYTHIC_NARRATIVE','RITUAL_PRACTICE','SCHOLARLY_INTERPRETATION','LATER_RECEPTION','POPULAR_CULTURE','SPECULATION')),
    tradition_scope TEXT,
    temporal_scope TEXT,
    research_notes TEXT,
    created_at TEXT NOT NULL,
    CHECK((object_entity_id IS NOT NULL AND object_literal IS NULL) OR
          (object_entity_id IS NULL AND object_literal IS NOT NULL))
)
```

## `collection_queue` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `target_label` | TEXT | 1 |  | 0 |
| 2 | `normalized_label` | TEXT | 1 |  | 0 |
| 3 | `proposed_entity_type` | TEXT | 0 |  | 0 |
| 4 | `civilization_id` | TEXT | 0 |  | 0 |
| 5 | `discovered_from_entity_id` | TEXT | 0 |  | 0 |
| 6 | `discovered_from_claim_id` | TEXT | 0 |  | 0 |
| 7 | `discovered_from_source_id` | TEXT | 0 |  | 0 |
| 8 | `discovery_context` | TEXT | 0 |  | 0 |
| 9 | `priority` | INTEGER | 1 | 50 | 0 |
| 10 | `status` | TEXT | 1 | 'NEW' | 0 |
| 11 | `attempts` | INTEGER | 1 | 0 | 0 |
| 12 | `last_error` | TEXT | 0 |  | 0 |
| 13 | `next_action` | TEXT | 0 |  | 0 |
| 14 | `created_at` | TEXT | 1 |  | 0 |
| 15 | `updated_at` | TEXT | 1 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `discovered_from_source_id` | `sources.id` | NO ACTION | NO ACTION |
| `discovered_from_claim_id` | `claims.id` | NO ACTION | NO ACTION |
| `discovered_from_entity_id` | `entities.id` | NO ACTION | NO ACTION |
| `civilization_id` | `civilizations.id` | NO ACTION | NO ACTION |
| `proposed_entity_type` | `entity_types.code` | NO ACTION | NO ACTION |

定义：

```sql
CREATE TABLE collection_queue (
    id TEXT PRIMARY KEY,
    target_label TEXT NOT NULL,
    normalized_label TEXT NOT NULL,
    proposed_entity_type TEXT REFERENCES entity_types(code),
    civilization_id TEXT REFERENCES civilizations(id),
    discovered_from_entity_id TEXT REFERENCES entities(id),
    discovered_from_claim_id TEXT REFERENCES claims(id),
    discovered_from_source_id TEXT REFERENCES sources(id),
    discovery_context TEXT,
    priority INTEGER NOT NULL DEFAULT 50 CHECK(priority BETWEEN 0 AND 100),
    status TEXT NOT NULL DEFAULT 'NEW'
        CHECK(status IN ('NEW','DISCOVERED','SOURCE_FOUND','COLLECTING','PARTIAL','BASELINE_COMPLETE','NEEDS_REVIEW','CONFLICT','LOW_EVIDENCE','EXPAND_LATER')),
    attempts INTEGER NOT NULL DEFAULT 0 CHECK(attempts >= 0),
    last_error TEXT,
    next_action TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
)
```

## `comparison_set_members` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `comparison_set_id` | TEXT | 1 |  | 1 |
| 1 | `entity_id` | TEXT | 1 |  | 2 |
| 2 | `member_role` | TEXT | 1 | 'COMPARAND' | 0 |
| 3 | `native_scope_en` | TEXT | 1 |  | 0 |
| 4 | `native_scope_zh` | TEXT | 1 |  | 0 |
| 5 | `distinction_en` | TEXT | 1 |  | 0 |
| 6 | `distinction_zh` | TEXT | 1 |  | 0 |
| 7 | `sort_order` | INTEGER | 1 | 0 | 0 |
| 8 | `claim_id` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `claim_id` | `claims.id` | NO ACTION | NO ACTION |
| `entity_id` | `entities.id` | NO ACTION | CASCADE |
| `comparison_set_id` | `comparison_sets.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE comparison_set_members (
    comparison_set_id TEXT NOT NULL REFERENCES comparison_sets(id) ON DELETE CASCADE,
    entity_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    member_role TEXT NOT NULL DEFAULT 'COMPARAND',
    native_scope_en TEXT NOT NULL,
    native_scope_zh TEXT NOT NULL,
    distinction_en TEXT NOT NULL,
    distinction_zh TEXT NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    claim_id TEXT REFERENCES claims(id),
    PRIMARY KEY(comparison_set_id, entity_id)
)
```

## `comparison_sets` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `concept_entity_id` | TEXT | 0 |  | 0 |
| 2 | `canonical_name` | TEXT | 1 |  | 0 |
| 3 | `name_zh` | TEXT | 0 |  | 0 |
| 4 | `description_en` | TEXT | 1 |  | 0 |
| 5 | `description_zh` | TEXT | 1 |  | 0 |
| 6 | `methodology_en` | TEXT | 1 |  | 0 |
| 7 | `methodology_zh` | TEXT | 1 |  | 0 |
| 8 | `research_status` | TEXT | 1 | 'PARTIAL' | 0 |
| 9 | `created_at` | TEXT | 1 |  | 0 |
| 10 | `updated_at` | TEXT | 1 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `concept_entity_id` | `entities.id` | NO ACTION | NO ACTION |

定义：

```sql
CREATE TABLE comparison_sets (
    id TEXT PRIMARY KEY,
    concept_entity_id TEXT REFERENCES entities(id),
    canonical_name TEXT NOT NULL,
    name_zh TEXT,
    description_en TEXT NOT NULL,
    description_zh TEXT NOT NULL,
    methodology_en TEXT NOT NULL,
    methodology_zh TEXT NOT NULL,
    research_status TEXT NOT NULL DEFAULT 'PARTIAL'
        CHECK(research_status IN ('DISCOVERED','SOURCE_FOUND','COLLECTING','PARTIAL','BASELINE_COMPLETE','NEEDS_REVIEW','CONFLICT','LOW_EVIDENCE','EXPAND_LATER')),
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
)
```

## `conflicts` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `subject_id` | TEXT | 0 |  | 0 |
| 2 | `variant_group` | TEXT | 1 |  | 0 |
| 3 | `claim_a_id` | TEXT | 0 |  | 0 |
| 4 | `claim_b_id` | TEXT | 0 |  | 0 |
| 5 | `conflict_type` | TEXT | 1 |  | 0 |
| 6 | `status` | TEXT | 1 | 'OPEN' | 0 |
| 7 | `summary` | TEXT | 1 |  | 0 |
| 8 | `resolution_notes` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `claim_b_id` | `claims.id` | NO ACTION | NO ACTION |
| `claim_a_id` | `claims.id` | NO ACTION | NO ACTION |
| `subject_id` | `entities.id` | NO ACTION | NO ACTION |

定义：

```sql
CREATE TABLE conflicts (
    id TEXT PRIMARY KEY,
    subject_id TEXT REFERENCES entities(id),
    variant_group TEXT NOT NULL,
    claim_a_id TEXT REFERENCES claims(id),
    claim_b_id TEXT REFERENCES claims(id),
    conflict_type TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'OPEN'
        CHECK(status IN ('OPEN','UNDER_REVIEW','RESOLVED_AS_VARIANTS','RESOLVED','DEFERRED')),
    summary TEXT NOT NULL,
    resolution_notes TEXT
)
```

## `coverage_metrics` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `report_id` | TEXT | 1 |  | 1 |
| 1 | `metric_key` | TEXT | 1 |  | 2 |
| 2 | `metric_value` | REAL | 1 |  | 0 |
| 3 | `denominator` | REAL | 0 |  | 0 |
| 4 | `notes` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `report_id` | `coverage_reports.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE coverage_metrics (
    report_id TEXT NOT NULL REFERENCES coverage_reports(id) ON DELETE CASCADE,
    metric_key TEXT NOT NULL,
    metric_value REAL NOT NULL,
    denominator REAL,
    notes TEXT,
    PRIMARY KEY(report_id, metric_key)
)
```

## `coverage_reports` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `generated_at` | TEXT | 1 |  | 0 |
| 2 | `baseline_label` | TEXT | 1 |  | 0 |
| 3 | `summary` | TEXT | 1 |  | 0 |

定义：

```sql
CREATE TABLE coverage_reports (
    id TEXT PRIMARY KEY,
    generated_at TEXT NOT NULL,
    baseline_label TEXT NOT NULL,
    summary TEXT NOT NULL
)
```

## `creature_profiles` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `entity_id` | TEXT | 0 |  | 1 |
| 1 | `creature_class` | TEXT | 1 |  | 0 |
| 2 | `appearance_json` | TEXT | 1 | '{}' | 0 |
| 3 | `abilities_json` | TEXT | 1 | '[]' | 0 |
| 4 | `weaknesses_json` | TEXT | 1 | '[]' | 0 |
| 5 | `habitat_summary` | TEXT | 0 |  | 0 |
| 6 | `origin_summary` | TEXT | 0 |  | 0 |
| 7 | `fate_summary` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `entity_id` | `entities.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE creature_profiles (
    entity_id TEXT PRIMARY KEY REFERENCES entities(id) ON DELETE CASCADE,
    creature_class TEXT NOT NULL,
    appearance_json TEXT NOT NULL DEFAULT '{}',
    abilities_json TEXT NOT NULL DEFAULT '[]',
    weaknesses_json TEXT NOT NULL DEFAULT '[]',
    habitat_summary TEXT,
    origin_summary TEXT,
    fate_summary TEXT
)
```

## `cultures` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `canonical_name` | TEXT | 1 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `parent_id` | TEXT | 0 |  | 0 |
| 4 | `civilization_id` | TEXT | 0 |  | 0 |
| 5 | `region_id` | TEXT | 0 |  | 0 |
| 6 | `description` | TEXT | 0 |  | 0 |
| 7 | `research_status` | TEXT | 1 | 'DISCOVERED' | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `region_id` | `regions.id` | NO ACTION | NO ACTION |
| `civilization_id` | `civilizations.id` | NO ACTION | NO ACTION |
| `parent_id` | `cultures.id` | NO ACTION | NO ACTION |

定义：

```sql
CREATE TABLE cultures (
    id TEXT PRIMARY KEY,
    canonical_name TEXT NOT NULL,
    name_zh TEXT,
    parent_id TEXT REFERENCES cultures(id),
    civilization_id TEXT REFERENCES civilizations(id),
    region_id TEXT REFERENCES regions(id),
    description TEXT,
    research_status TEXT NOT NULL DEFAULT 'DISCOVERED'
)
```

## `dataset_releases` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `schema_version` | INTEGER | 1 |  | 0 |
| 2 | `data_version` | TEXT | 1 |  | 0 |
| 3 | `git_commit` | TEXT | 0 |  | 0 |
| 4 | `built_at` | TEXT | 1 |  | 0 |
| 5 | `database_sha256` | TEXT | 0 |  | 0 |
| 6 | `release_notes` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE TABLE dataset_releases (
    id TEXT PRIMARY KEY,
    schema_version INTEGER NOT NULL,
    data_version TEXT NOT NULL,
    git_commit TEXT,
    built_at TEXT NOT NULL,
    database_sha256 TEXT,
    release_notes TEXT
)
```

## `deity_profiles` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `entity_id` | TEXT | 0 |  | 1 |
| 1 | `deity_class` | TEXT | 0 |  | 0 |
| 2 | `pantheon_or_family` | TEXT | 0 |  | 0 |
| 3 | `rank_or_status` | TEXT | 0 |  | 0 |
| 4 | `domains_json` | TEXT | 1 | '[]' | 0 |
| 5 | `powers_json` | TEXT | 1 | '[]' | 0 |
| 6 | `limitations_json` | TEXT | 1 | '[]' | 0 |
| 7 | `appearance_json` | TEXT | 1 | '{}' | 0 |
| 8 | `symbols_json` | TEXT | 1 | '[]' | 0 |
| 9 | `cult_summary` | TEXT | 0 |  | 0 |
| 10 | `final_fate_summary` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `entity_id` | `entities.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE deity_profiles (
    entity_id TEXT PRIMARY KEY REFERENCES entities(id) ON DELETE CASCADE,
    deity_class TEXT,
    pantheon_or_family TEXT,
    rank_or_status TEXT,
    domains_json TEXT NOT NULL DEFAULT '[]',
    powers_json TEXT NOT NULL DEFAULT '[]',
    limitations_json TEXT NOT NULL DEFAULT '[]',
    appearance_json TEXT NOT NULL DEFAULT '{}',
    symbols_json TEXT NOT NULL DEFAULT '[]',
    cult_summary TEXT,
    final_fate_summary TEXT
)
```

## `entities` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `canonical_name` | TEXT | 1 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 1 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 1 | 'DISCOVERED' | 0 |
| 12 | `evidence_status` | TEXT | 1 | 'UNVERIFIED' | 0 |
| 13 | `record_version` | INTEGER | 1 | 1 | 0 |
| 14 | `metadata_json` | TEXT | 1 | '{}' | 0 |
| 15 | `created_at` | TEXT | 1 |  | 0 |
| 16 | `updated_at` | TEXT | 1 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `primary_region_id` | `regions.id` | NO ACTION | NO ACTION |
| `primary_culture_id` | `cultures.id` | NO ACTION | NO ACTION |
| `primary_civilization_id` | `civilizations.id` | NO ACTION | NO ACTION |
| `primary_type` | `entity_types.code` | NO ACTION | NO ACTION |

定义：

```sql
CREATE TABLE entities (
    id TEXT PRIMARY KEY,
    canonical_name TEXT NOT NULL,
    name_zh TEXT,
    original_name TEXT,
    transliteration TEXT,
    primary_type TEXT NOT NULL REFERENCES entity_types(code),
    primary_civilization_id TEXT REFERENCES civilizations(id),
    primary_culture_id TEXT REFERENCES cultures(id),
    primary_region_id TEXT REFERENCES regions(id),
    historical_period TEXT,
    description TEXT,
    research_status TEXT NOT NULL DEFAULT 'DISCOVERED'
        CHECK (research_status IN ('DISCOVERED','SOURCE_FOUND','COLLECTING','PARTIAL','BASELINE_COMPLETE','NEEDS_REVIEW','CONFLICT','LOW_EVIDENCE','EXPAND_LATER')),
    evidence_status TEXT NOT NULL DEFAULT 'UNVERIFIED'
        CHECK (evidence_status IN ('UNVERIFIED','PARTIAL','SOURCE_BACKED','CONFLICTING')),
    record_version INTEGER NOT NULL DEFAULT 1 CHECK(record_version >= 1),
    metadata_json TEXT NOT NULL DEFAULT '{}',
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
)
```

## `entity_attributes` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `entity_id` | TEXT | 1 |  | 0 |
| 2 | `attribute_key` | TEXT | 1 |  | 0 |
| 3 | `value_text` | TEXT | 0 |  | 0 |
| 4 | `value_number` | REAL | 0 |  | 0 |
| 5 | `value_entity_id` | TEXT | 0 |  | 0 |
| 6 | `value_json` | TEXT | 0 |  | 0 |
| 7 | `unit` | TEXT | 0 |  | 0 |
| 8 | `claim_id` | TEXT | 0 |  | 0 |
| 9 | `notes` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `claim_id` | `claims.id` | NO ACTION | SET NULL |
| `value_entity_id` | `entities.id` | NO ACTION | NO ACTION |
| `entity_id` | `entities.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE entity_attributes (
    id TEXT PRIMARY KEY,
    entity_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    attribute_key TEXT NOT NULL,
    value_text TEXT,
    value_number REAL,
    value_entity_id TEXT REFERENCES entities(id),
    value_json TEXT,
    unit TEXT,
    claim_id TEXT REFERENCES claims(id) ON DELETE SET NULL,
    notes TEXT,
    CHECK(
        (value_text IS NOT NULL) + (value_number IS NOT NULL) +
        (value_entity_id IS NOT NULL) + (value_json IS NOT NULL) = 1
    )
)
```

## `entity_civilizations` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `entity_id` | TEXT | 1 |  | 1 |
| 1 | `civilization_id` | TEXT | 1 |  | 2 |
| 2 | `association_role` | TEXT | 1 | 'ORIGIN' | 3 |
| 3 | `certainty` | TEXT | 1 | 'SUPPORTED' | 0 |
| 4 | `notes` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `civilization_id` | `civilizations.id` | NO ACTION | CASCADE |
| `entity_id` | `entities.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE entity_civilizations (
    entity_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    civilization_id TEXT NOT NULL REFERENCES civilizations(id) ON DELETE CASCADE,
    association_role TEXT NOT NULL DEFAULT 'ORIGIN',
    certainty TEXT NOT NULL DEFAULT 'SUPPORTED'
        CHECK(certainty IN ('CONFIRMED','SUPPORTED','POSSIBLE','DISPUTED','UNKNOWN')),
    notes TEXT,
    PRIMARY KEY(entity_id, civilization_id, association_role)
)
```

## `entity_classifications` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `entity_id` | TEXT | 1 |  | 1 |
| 1 | `type_code` | TEXT | 1 |  | 2 |
| 2 | `is_primary` | INTEGER | 1 | 0 | 0 |
| 3 | `notes` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `type_code` | `entity_types.code` | NO ACTION | NO ACTION |
| `entity_id` | `entities.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE entity_classifications (
    entity_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    type_code TEXT NOT NULL REFERENCES entity_types(code),
    is_primary INTEGER NOT NULL DEFAULT 0 CHECK(is_primary IN (0,1)),
    notes TEXT,
    PRIMARY KEY(entity_id, type_code)
)
```

## `entity_redirects` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `duplicate_entity_id` | TEXT | 0 |  | 1 |
| 1 | `canonical_entity_id` | TEXT | 1 |  | 0 |
| 2 | `resolution_basis` | TEXT | 1 |  | 0 |
| 3 | `resolved_at` | TEXT | 1 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `canonical_entity_id` | `entities.id` | NO ACTION | NO ACTION |
| `duplicate_entity_id` | `entities.id` | NO ACTION | NO ACTION |

定义：

```sql
CREATE TABLE entity_redirects (
    duplicate_entity_id TEXT PRIMARY KEY REFERENCES entities(id),
    canonical_entity_id TEXT NOT NULL REFERENCES entities(id),
    resolution_basis TEXT NOT NULL,
    resolved_at TEXT NOT NULL,
    CHECK(duplicate_entity_id <> canonical_entity_id)
)
```

## `entity_types` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `code` | TEXT | 0 |  | 1 |
| 1 | `label_en` | TEXT | 1 |  | 0 |
| 2 | `label_zh` | TEXT | 0 |  | 0 |
| 3 | `parent_code` | TEXT | 0 |  | 0 |
| 4 | `description` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `parent_code` | `entity_types.code` | NO ACTION | NO ACTION |

定义：

```sql
CREATE TABLE entity_types (
    code TEXT PRIMARY KEY,
    label_en TEXT NOT NULL,
    label_zh TEXT,
    parent_code TEXT REFERENCES entity_types(code),
    description TEXT
)
```

## `event_participants` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `event_id` | TEXT | 1 |  | 1 |
| 1 | `participant_id` | TEXT | 1 |  | 2 |
| 2 | `role` | TEXT | 1 |  | 3 |
| 3 | `outcome` | TEXT | 0 |  | 0 |
| 4 | `claim_id` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `claim_id` | `claims.id` | NO ACTION | NO ACTION |
| `participant_id` | `entities.id` | NO ACTION | CASCADE |
| `event_id` | `entities.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE event_participants (
    event_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    participant_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    role TEXT NOT NULL,
    outcome TEXT,
    claim_id TEXT REFERENCES claims(id),
    PRIMARY KEY(event_id, participant_id, role)
)
```

## `evidence` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `claim_id` | TEXT | 1 |  | 0 |
| 2 | `source_id` | TEXT | 1 |  | 0 |
| 3 | `source_location` | TEXT | 0 |  | 0 |
| 4 | `chapter` | TEXT | 0 |  | 0 |
| 5 | `verse` | TEXT | 0 |  | 0 |
| 6 | `line` | TEXT | 0 |  | 0 |
| 7 | `page` | TEXT | 0 |  | 0 |
| 8 | `catalogue_number` | TEXT | 0 |  | 0 |
| 9 | `short_quote` | TEXT | 0 |  | 0 |
| 10 | `evidence_type` | TEXT | 1 |  | 0 |
| 11 | `direction` | TEXT | 1 | 'SUPPORTS' | 0 |
| 12 | `strength` | REAL | 1 | 0.5 | 0 |
| 13 | `research_notes` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `source_id` | `sources.id` | NO ACTION | NO ACTION |
| `claim_id` | `claims.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE evidence (
    id TEXT PRIMARY KEY,
    claim_id TEXT NOT NULL REFERENCES claims(id) ON DELETE CASCADE,
    source_id TEXT NOT NULL REFERENCES sources(id),
    source_location TEXT,
    chapter TEXT,
    verse TEXT,
    line TEXT,
    page TEXT,
    catalogue_number TEXT,
    short_quote TEXT,
    evidence_type TEXT NOT NULL
        CHECK(evidence_type IN ('ARCHAEOLOGICAL','PRIMARY_TEXT','ANCIENT_TEXT','MEDIEVAL_TEXT','INSCRIPTION','MANUSCRIPT','ORAL_TRADITION','MUSEUM_OBJECT','MODERN_SCHOLARSHIP','LATER_LITERATURE','POPULAR_CULTURE','MODERN_SPECULATION','OFFICIAL_SITE')),
    direction TEXT NOT NULL DEFAULT 'SUPPORTS'
        CHECK(direction IN ('SUPPORTS','REFUTES','CONTEXT')),
    strength REAL NOT NULL DEFAULT 0.5 CHECK(strength BETWEEN 0 AND 1),
    research_notes TEXT,
    UNIQUE(claim_id, source_id, source_location, direction)
)
```

## `explorer_feature_registry` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `feature_code` | TEXT | 0 |  | 1 |
| 1 | `title_zh` | TEXT | 1 |  | 0 |
| 2 | `title_en` | TEXT | 1 |  | 0 |
| 3 | `feature_group` | TEXT | 1 |  | 0 |
| 4 | `data_basis` | TEXT | 1 |  | 0 |
| 5 | `evidence_caveat` | TEXT | 1 |  | 0 |
| 6 | `status` | TEXT | 1 |  | 0 |
| 7 | `introduced_in` | TEXT | 1 |  | 0 |
| 8 | `display_order` | INTEGER | 1 | 0 | 0 |
| 9 | `updated_at` | TEXT | 1 |  | 0 |
| 10 | `notes` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE TABLE explorer_feature_registry (
    feature_code TEXT PRIMARY KEY,
    title_zh TEXT NOT NULL,
    title_en TEXT NOT NULL,
    feature_group TEXT NOT NULL,
    data_basis TEXT NOT NULL,
    evidence_caveat TEXT NOT NULL,
    status TEXT NOT NULL CHECK(status IN ('ACTIVE','LIMITED','PENDING')),
    introduced_in TEXT NOT NULL,
    display_order INTEGER NOT NULL DEFAULT 0,
    updated_at TEXT NOT NULL,
    notes TEXT
)
```

## `identity_candidates` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `entity_a_id` | TEXT | 1 |  | 0 |
| 2 | `entity_b_id` | TEXT | 1 |  | 0 |
| 3 | `assessment` | TEXT | 1 |  | 0 |
| 4 | `confidence` | REAL | 0 |  | 0 |
| 5 | `source_id` | TEXT | 0 |  | 0 |
| 6 | `notes` | TEXT | 1 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `source_id` | `sources.id` | NO ACTION | NO ACTION |
| `entity_b_id` | `entities.id` | NO ACTION | NO ACTION |
| `entity_a_id` | `entities.id` | NO ACTION | NO ACTION |

定义：

```sql
CREATE TABLE identity_candidates (
    id TEXT PRIMARY KEY,
    entity_a_id TEXT NOT NULL REFERENCES entities(id),
    entity_b_id TEXT NOT NULL REFERENCES entities(id),
    assessment TEXT NOT NULL CHECK(assessment IN ('POSSIBLY_SAME','DISPUTED_IDENTITY','IDENTIFIED_IN_SOURCE','EXPLICITLY_DISTINCT')),
    confidence REAL CHECK(confidence IS NULL OR confidence BETWEEN 0 AND 1),
    source_id TEXT REFERENCES sources(id),
    notes TEXT NOT NULL,
    CHECK(entity_a_id <> entity_b_id),
    UNIQUE(entity_a_id, entity_b_id, assessment)
)
```

## `import_errors` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | INTEGER | 0 |  | 1 |
| 1 | `import_run_id` | TEXT | 1 |  | 0 |
| 2 | `row_locator` | TEXT | 0 |  | 0 |
| 3 | `error_code` | TEXT | 1 |  | 0 |
| 4 | `message` | TEXT | 1 |  | 0 |
| 5 | `raw_payload` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `import_run_id` | `import_runs.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE import_errors (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    import_run_id TEXT NOT NULL REFERENCES import_runs(id) ON DELETE CASCADE,
    row_locator TEXT,
    error_code TEXT NOT NULL,
    message TEXT NOT NULL,
    raw_payload TEXT
)
```

## `import_runs` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `started_at` | TEXT | 1 |  | 0 |
| 2 | `ended_at` | TEXT | 0 |  | 0 |
| 3 | `source_path` | TEXT | 1 |  | 0 |
| 4 | `source_hash` | TEXT | 0 |  | 0 |
| 5 | `inserted_count` | INTEGER | 1 | 0 | 0 |
| 6 | `updated_count` | INTEGER | 1 | 0 | 0 |
| 7 | `skipped_count` | INTEGER | 1 | 0 | 0 |
| 8 | `error_count` | INTEGER | 1 | 0 | 0 |
| 9 | `status` | TEXT | 1 |  | 0 |

定义：

```sql
CREATE TABLE import_runs (
    id TEXT PRIMARY KEY,
    started_at TEXT NOT NULL,
    ended_at TEXT,
    source_path TEXT NOT NULL,
    source_hash TEXT,
    inserted_count INTEGER NOT NULL DEFAULT 0,
    updated_count INTEGER NOT NULL DEFAULT 0,
    skipped_count INTEGER NOT NULL DEFAULT 0,
    error_count INTEGER NOT NULL DEFAULT 0,
    status TEXT NOT NULL
)
```

## `languages` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `canonical_name` | TEXT | 1 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `iso_639_3` | TEXT | 0 |  | 0 |
| 4 | `script_name` | TEXT | 0 |  | 0 |
| 5 | `historical_stage` | TEXT | 0 |  | 0 |
| 6 | `notes` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE TABLE languages (
    id TEXT PRIMARY KEY,
    canonical_name TEXT NOT NULL,
    name_zh TEXT,
    iso_639_3 TEXT,
    script_name TEXT,
    historical_stage TEXT,
    notes TEXT
)
```

## `modern_adaptations` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `ancient_entity_id` | TEXT | 1 |  | 0 |
| 2 | `modern_entity_id` | TEXT | 1 |  | 0 |
| 3 | `modern_work_entity_id` | TEXT | 0 |  | 0 |
| 4 | `medium` | TEXT | 1 |  | 0 |
| 5 | `adaptation_notes` | TEXT | 0 |  | 0 |
| 6 | `source_id` | TEXT | 0 |  | 0 |
| 7 | `canonicality_scope` | TEXT | 1 | 'MODERN_ADAPTATION' | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `source_id` | `sources.id` | NO ACTION | NO ACTION |
| `modern_work_entity_id` | `entities.id` | NO ACTION | NO ACTION |
| `modern_entity_id` | `entities.id` | NO ACTION | CASCADE |
| `ancient_entity_id` | `entities.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE modern_adaptations (
    id TEXT PRIMARY KEY,
    ancient_entity_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    modern_entity_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    modern_work_entity_id TEXT REFERENCES entities(id),
    medium TEXT NOT NULL,
    adaptation_notes TEXT,
    source_id TEXT REFERENCES sources(id),
    canonicality_scope TEXT NOT NULL DEFAULT 'MODERN_ADAPTATION'
        CHECK(canonicality_scope IN ('LATER_LITERATURE','MODERN_ADAPTATION','POPULAR_CULTURE','INTERNET_CULTURE')),
    CHECK(ancient_entity_id <> modern_entity_id)
)
```

## `museum_object_profiles` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `entity_id` | TEXT | 0 |  | 1 |
| 1 | `holding_institution` | TEXT | 1 |  | 0 |
| 2 | `catalogue_number` | TEXT | 1 |  | 0 |
| 3 | `object_type` | TEXT | 0 |  | 0 |
| 4 | `provenance` | TEXT | 0 |  | 0 |
| 5 | `date_range` | TEXT | 0 |  | 0 |
| 6 | `acquisition_notes` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `entity_id` | `entities.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE museum_object_profiles (
    entity_id TEXT PRIMARY KEY REFERENCES entities(id) ON DELETE CASCADE,
    holding_institution TEXT NOT NULL,
    catalogue_number TEXT NOT NULL,
    object_type TEXT,
    provenance TEXT,
    date_range TEXT,
    acquisition_notes TEXT,
    UNIQUE(holding_institution, catalogue_number)
)
```

## `myth_event_profiles` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `entity_id` | TEXT | 0 |  | 1 |
| 1 | `event_type` | TEXT | 1 |  | 0 |
| 2 | `time_layer` | TEXT | 0 |  | 0 |
| 3 | `cause_summary` | TEXT | 0 |  | 0 |
| 4 | `process_summary` | TEXT | 0 |  | 0 |
| 5 | `result_summary` | TEXT | 0 |  | 0 |
| 6 | `symbolism_summary` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `entity_id` | `entities.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE myth_event_profiles (
    entity_id TEXT PRIMARY KEY REFERENCES entities(id) ON DELETE CASCADE,
    event_type TEXT NOT NULL,
    time_layer TEXT,
    cause_summary TEXT,
    process_summary TEXT,
    result_summary TEXT,
    symbolism_summary TEXT
)
```

## `names` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `entity_id` | TEXT | 1 |  | 0 |
| 2 | `name_text` | TEXT | 1 |  | 0 |
| 3 | `normalized_text` | TEXT | 1 |  | 0 |
| 4 | `language_id` | TEXT | 0 |  | 0 |
| 5 | `script_name` | TEXT | 0 |  | 0 |
| 6 | `name_type` | TEXT | 1 | 'ALIAS' | 0 |
| 7 | `transliteration_scheme` | TEXT | 0 |  | 0 |
| 8 | `is_preferred` | INTEGER | 1 | 0 | 0 |
| 9 | `source_id` | TEXT | 0 |  | 0 |
| 10 | `notes` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `source_id` | `sources.id` | NO ACTION | NO ACTION |
| `language_id` | `languages.id` | NO ACTION | NO ACTION |
| `entity_id` | `entities.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE names (
    id TEXT PRIMARY KEY,
    entity_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    name_text TEXT NOT NULL,
    normalized_text TEXT NOT NULL,
    language_id TEXT REFERENCES languages(id),
    script_name TEXT,
    name_type TEXT NOT NULL DEFAULT 'ALIAS',
    transliteration_scheme TEXT,
    is_preferred INTEGER NOT NULL DEFAULT 0 CHECK(is_preferred IN (0,1)),
    source_id TEXT REFERENCES sources(id),
    notes TEXT,
    UNIQUE(entity_id, normalized_text, language_id, name_type)
)
```

## `place_profiles` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `entity_id` | TEXT | 0 |  | 1 |
| 1 | `place_type` | TEXT | 1 |  | 0 |
| 2 | `ancient_name` | TEXT | 0 |  | 0 |
| 3 | `modern_name` | TEXT | 0 |  | 0 |
| 4 | `country_code` | TEXT | 0 |  | 0 |
| 5 | `latitude` | REAL | 0 |  | 0 |
| 6 | `longitude` | REAL | 0 |  | 0 |
| 7 | `date_range` | TEXT | 0 |  | 0 |
| 8 | `builders` | TEXT | 0 |  | 0 |
| 9 | `architecture_summary` | TEXT | 0 |  | 0 |
| 10 | `excavation_summary` | TEXT | 0 |  | 0 |
| 11 | `major_finds_summary` | TEXT | 0 |  | 0 |
| 12 | `unesco_status` | TEXT | 0 |  | 0 |
| 13 | `reality_status` | TEXT | 1 | 'REAL_ARCHAEOLOGICAL' | 0 |
| 14 | `evidence_grade` | TEXT | 1 | 'UNASSESSED' | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `entity_id` | `entities.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE place_profiles (
    entity_id TEXT PRIMARY KEY REFERENCES entities(id) ON DELETE CASCADE,
    place_type TEXT NOT NULL,
    ancient_name TEXT,
    modern_name TEXT,
    country_code TEXT,
    latitude REAL CHECK(latitude IS NULL OR latitude BETWEEN -90 AND 90),
    longitude REAL CHECK(longitude IS NULL OR longitude BETWEEN -180 AND 180),
    date_range TEXT,
    builders TEXT,
    architecture_summary TEXT,
    excavation_summary TEXT,
    major_finds_summary TEXT,
    unesco_status TEXT,
    reality_status TEXT NOT NULL DEFAULT 'REAL_ARCHAEOLOGICAL'
        CHECK(reality_status IN ('REAL_ARCHAEOLOGICAL','REAL_SACRED','REAL_HISTORIC','MYTHICAL','LATER_LEGEND','MODERN_SPECULATION','MIXED')),
    evidence_grade TEXT NOT NULL DEFAULT 'UNASSESSED'
)
```

## `project_metadata` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `key` | TEXT | 0 |  | 1 |
| 1 | `value` | TEXT | 1 |  | 0 |
| 2 | `updated_at` | TEXT | 1 |  | 0 |

定义：

```sql
CREATE TABLE project_metadata (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    updated_at TEXT NOT NULL
)
```

## `quality_findings` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `quality_run_id` | TEXT | 1 |  | 0 |
| 2 | `severity` | TEXT | 1 |  | 0 |
| 3 | `rule_code` | TEXT | 1 |  | 0 |
| 4 | `entity_id` | TEXT | 0 |  | 0 |
| 5 | `claim_id` | TEXT | 0 |  | 0 |
| 6 | `message` | TEXT | 1 |  | 0 |
| 7 | `status` | TEXT | 1 | 'OPEN' | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `claim_id` | `claims.id` | NO ACTION | NO ACTION |
| `entity_id` | `entities.id` | NO ACTION | NO ACTION |
| `quality_run_id` | `quality_runs.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE quality_findings (
    id TEXT PRIMARY KEY,
    quality_run_id TEXT NOT NULL REFERENCES quality_runs(id) ON DELETE CASCADE,
    severity TEXT NOT NULL CHECK(severity IN ('INFO','LOW','MEDIUM','HIGH','CRITICAL')),
    rule_code TEXT NOT NULL,
    entity_id TEXT REFERENCES entities(id),
    claim_id TEXT REFERENCES claims(id),
    message TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'OPEN' CHECK(status IN ('OPEN','FIXED','ACCEPTED','DEFERRED'))
)
```

## `quality_runs` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `started_at` | TEXT | 1 |  | 0 |
| 2 | `ended_at` | TEXT | 0 |  | 0 |
| 3 | `status` | TEXT | 1 |  | 0 |
| 4 | `summary` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE TABLE quality_runs (
    id TEXT PRIMARY KEY,
    started_at TEXT NOT NULL,
    ended_at TEXT,
    status TEXT NOT NULL,
    summary TEXT
)
```

## `queue_discoveries` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `queue_id` | TEXT | 1 |  | 0 |
| 2 | `discovered_from_entity_id` | TEXT | 0 |  | 0 |
| 3 | `discovered_from_claim_id` | TEXT | 0 |  | 0 |
| 4 | `discovered_from_source_id` | TEXT | 0 |  | 0 |
| 5 | `discovery_context` | TEXT | 1 |  | 0 |
| 6 | `discovered_at` | TEXT | 1 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `discovered_from_source_id` | `sources.id` | NO ACTION | NO ACTION |
| `discovered_from_claim_id` | `claims.id` | NO ACTION | NO ACTION |
| `discovered_from_entity_id` | `entities.id` | NO ACTION | NO ACTION |
| `queue_id` | `collection_queue.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE queue_discoveries (
    id TEXT PRIMARY KEY,
    queue_id TEXT NOT NULL REFERENCES collection_queue(id) ON DELETE CASCADE,
    discovered_from_entity_id TEXT REFERENCES entities(id),
    discovered_from_claim_id TEXT REFERENCES claims(id),
    discovered_from_source_id TEXT REFERENCES sources(id),
    discovery_context TEXT NOT NULL,
    discovered_at TEXT NOT NULL
)
```

## `queue_status_history` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `queue_id` | TEXT | 1 |  | 0 |
| 2 | `old_status` | TEXT | 0 |  | 0 |
| 3 | `new_status` | TEXT | 1 |  | 0 |
| 4 | `changed_at` | TEXT | 1 |  | 0 |
| 5 | `reason` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `queue_id` | `collection_queue.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE queue_status_history (
    id TEXT PRIMARY KEY,
    queue_id TEXT NOT NULL REFERENCES collection_queue(id) ON DELETE CASCADE,
    old_status TEXT,
    new_status TEXT NOT NULL,
    changed_at TEXT NOT NULL,
    reason TEXT
)
```

## `regions` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `canonical_name` | TEXT | 1 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `parent_id` | TEXT | 0 |  | 0 |
| 4 | `region_type` | TEXT | 1 | 'CULTURAL' | 0 |
| 5 | `notes` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `parent_id` | `regions.id` | NO ACTION | NO ACTION |

定义：

```sql
CREATE TABLE regions (
    id TEXT PRIMARY KEY,
    canonical_name TEXT NOT NULL,
    name_zh TEXT,
    parent_id TEXT REFERENCES regions(id),
    region_type TEXT NOT NULL DEFAULT 'CULTURAL',
    notes TEXT
)
```

## `relationship_types` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `code` | TEXT | 0 |  | 1 |
| 1 | `inverse_code` | TEXT | 0 |  | 0 |
| 2 | `label_en` | TEXT | 1 |  | 0 |
| 3 | `label_zh` | TEXT | 0 |  | 0 |
| 4 | `category` | TEXT | 0 |  | 0 |
| 5 | `is_symmetric` | INTEGER | 1 | 0 | 0 |
| 6 | `description` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `inverse_code` | `relationship_types.code` | NO ACTION | NO ACTION |

定义：

```sql
CREATE TABLE relationship_types (
    code TEXT PRIMARY KEY,
    inverse_code TEXT REFERENCES relationship_types(code),
    label_en TEXT NOT NULL,
    label_zh TEXT,
    category TEXT,
    is_symmetric INTEGER NOT NULL DEFAULT 0 CHECK(is_symmetric IN (0,1)),
    description TEXT
)
```

## `research_session_items` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `session_id` | TEXT | 1 |  | 1 |
| 1 | `item_kind` | TEXT | 1 |  | 2 |
| 2 | `item_id` | TEXT | 1 |  | 3 |
| 3 | `action` | TEXT | 1 |  | 4 |
| 4 | `result` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `session_id` | `research_sessions.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE research_session_items (
    session_id TEXT NOT NULL REFERENCES research_sessions(id) ON DELETE CASCADE,
    item_kind TEXT NOT NULL,
    item_id TEXT NOT NULL,
    action TEXT NOT NULL,
    result TEXT,
    PRIMARY KEY(session_id, item_kind, item_id, action)
)
```

## `research_sessions` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `started_at` | TEXT | 1 |  | 0 |
| 2 | `ended_at` | TEXT | 0 |  | 0 |
| 3 | `scope` | TEXT | 1 |  | 0 |
| 4 | `strategy` | TEXT | 0 |  | 0 |
| 5 | `status` | TEXT | 1 |  | 0 |
| 6 | `agent_or_process` | TEXT | 0 |  | 0 |
| 7 | `notes` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE TABLE research_sessions (
    id TEXT PRIMARY KEY,
    started_at TEXT NOT NULL,
    ended_at TEXT,
    scope TEXT NOT NULL,
    strategy TEXT,
    status TEXT NOT NULL,
    agent_or_process TEXT,
    notes TEXT
)
```

## `schema_migrations` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `version` | INTEGER | 0 |  | 1 |
| 1 | `name` | TEXT | 1 |  | 0 |
| 2 | `applied_at` | TEXT | 1 |  | 0 |

定义：

```sql
CREATE TABLE schema_migrations (
    version INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    applied_at TEXT NOT NULL
)
```

## `sources` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `title` | TEXT | 1 |  | 0 |
| 2 | `original_title` | TEXT | 0 |  | 0 |
| 3 | `source_type` | TEXT | 1 |  | 0 |
| 4 | `evidence_tier` | INTEGER | 1 |  | 0 |
| 5 | `institution` | TEXT | 0 |  | 0 |
| 6 | `author_or_editor` | TEXT | 0 |  | 0 |
| 7 | `language_id` | TEXT | 0 |  | 0 |
| 8 | `publication_date` | TEXT | 0 |  | 0 |
| 9 | `accessed_date` | TEXT | 1 |  | 0 |
| 10 | `url` | TEXT | 0 |  | 0 |
| 11 | `stable_url` | TEXT | 0 |  | 0 |
| 12 | `doi` | TEXT | 0 |  | 0 |
| 13 | `isbn` | TEXT | 0 |  | 0 |
| 14 | `catalogue_number` | TEXT | 0 |  | 0 |
| 15 | `manuscript_number` | TEXT | 0 |  | 0 |
| 16 | `rights_status` | TEXT | 0 |  | 0 |
| 17 | `source_perspective` | TEXT | 0 |  | 0 |
| 18 | `community_or_lineage` | TEXT | 0 |  | 0 |
| 19 | `collector_context` | TEXT | 0 |  | 0 |
| 20 | `living_tradition` | INTEGER | 1 | 0 | 0 |
| 21 | `access_or_reuse_restrictions` | TEXT | 0 |  | 0 |
| 22 | `community_permission_required` | INTEGER | 1 | 0 | 0 |
| 23 | `same_witness_as_source_id` | TEXT | 0 |  | 0 |
| 24 | `translation_status` | TEXT | 0 |  | 0 |
| 25 | `verification_status` | TEXT | 1 | 'REGISTERED' | 0 |
| 26 | `notes` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `same_witness_as_source_id` | `sources.id` | NO ACTION | NO ACTION |
| `language_id` | `languages.id` | NO ACTION | NO ACTION |

定义：

```sql
CREATE TABLE sources (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    original_title TEXT,
    source_type TEXT NOT NULL,
    evidence_tier INTEGER NOT NULL CHECK(evidence_tier BETWEEN 1 AND 15),
    institution TEXT,
    author_or_editor TEXT,
    language_id TEXT REFERENCES languages(id),
    publication_date TEXT,
    accessed_date TEXT NOT NULL,
    url TEXT,
    stable_url TEXT,
    doi TEXT,
    isbn TEXT,
    catalogue_number TEXT,
    manuscript_number TEXT,
    rights_status TEXT,
    source_perspective TEXT,
    community_or_lineage TEXT,
    collector_context TEXT,
    living_tradition INTEGER NOT NULL DEFAULT 0 CHECK(living_tradition IN (0,1)),
    access_or_reuse_restrictions TEXT,
    community_permission_required INTEGER NOT NULL DEFAULT 0 CHECK(community_permission_required IN (0,1)),
    same_witness_as_source_id TEXT REFERENCES sources(id),
    translation_status TEXT,
    verification_status TEXT NOT NULL DEFAULT 'REGISTERED'
        CHECK(verification_status IN ('REGISTERED','URL_SYNTAX_VALID','WEB_CONFIRMED','NEEDS_REVIEW','UNAVAILABLE')),
    notes TEXT,
    CHECK(url IS NOT NULL OR doi IS NOT NULL OR isbn IS NOT NULL OR catalogue_number IS NOT NULL)
)
```

## `text_profiles` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `entity_id` | TEXT | 0 |  | 1 |
| 1 | `text_type` | TEXT | 1 |  | 0 |
| 2 | `original_language_id` | TEXT | 0 |  | 0 |
| 3 | `attributed_author` | TEXT | 0 |  | 0 |
| 4 | `compiler` | TEXT | 0 |  | 0 |
| 5 | `composition_period` | TEXT | 0 |  | 0 |
| 6 | `earliest_extant_witness` | TEXT | 0 |  | 0 |
| 7 | `chapter_structure` | TEXT | 0 |  | 0 |
| 8 | `repository` | TEXT | 0 |  | 0 |
| 9 | `shelfmark` | TEXT | 0 |  | 0 |
| 10 | `copyright_status` | TEXT | 0 |  | 0 |
| 11 | `summary` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `original_language_id` | `languages.id` | NO ACTION | NO ACTION |
| `entity_id` | `entities.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE text_profiles (
    entity_id TEXT PRIMARY KEY REFERENCES entities(id) ON DELETE CASCADE,
    text_type TEXT NOT NULL,
    original_language_id TEXT REFERENCES languages(id),
    attributed_author TEXT,
    compiler TEXT,
    composition_period TEXT,
    earliest_extant_witness TEXT,
    chapter_structure TEXT,
    repository TEXT,
    shelfmark TEXT,
    copyright_status TEXT,
    summary TEXT
)
```

## `tradition_access_policies` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 1 |
| 1 | `entity_id` | TEXT | 1 |  | 0 |
| 2 | `source_id` | TEXT | 0 |  | 0 |
| 3 | `authority_name` | TEXT | 1 |  | 0 |
| 4 | `community_context` | TEXT | 0 |  | 0 |
| 5 | `access_level` | TEXT | 1 |  | 0 |
| 6 | `permitted_scope` | TEXT | 1 |  | 0 |
| 7 | `prohibited_scope` | TEXT | 1 |  | 0 |
| 8 | `attribution_requirement` | TEXT | 0 |  | 0 |
| 9 | `permission_contact_or_process` | TEXT | 0 |  | 0 |
| 10 | `policy_basis` | TEXT | 1 |  | 0 |
| 11 | `reviewed_at` | TEXT | 1 |  | 0 |
| 12 | `notes` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `source_id` | `sources.id` | NO ACTION | NO ACTION |
| `entity_id` | `entities.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE tradition_access_policies (
    id TEXT PRIMARY KEY,
    entity_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    source_id TEXT REFERENCES sources(id),
    authority_name TEXT NOT NULL,
    community_context TEXT,
    access_level TEXT NOT NULL CHECK(access_level IN ('PUBLIC_CONTEXT','ATTRIBUTION_REQUIRED','PERMISSION_REQUIRED','DO_NOT_COLLECT')),
    permitted_scope TEXT NOT NULL,
    prohibited_scope TEXT NOT NULL,
    attribution_requirement TEXT,
    permission_contact_or_process TEXT,
    policy_basis TEXT NOT NULL,
    reviewed_at TEXT NOT NULL,
    notes TEXT
)
```

## `tradition_links` (table)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `source_civilization_id` | TEXT | 1 |  | 1 |
| 1 | `link_type` | TEXT | 1 |  | 2 |
| 2 | `target_civilization_id` | TEXT | 1 |  | 3 |
| 3 | `claim_id` | TEXT | 0 |  | 0 |
| 4 | `notes` | TEXT | 0 |  | 0 |

外键：

| 字段 | 目标 | ON UPDATE | ON DELETE |
|---|---|---|---|
| `target_civilization_id` | `civilizations.id` | NO ACTION | CASCADE |
| `source_civilization_id` | `civilizations.id` | NO ACTION | CASCADE |

定义：

```sql
CREATE TABLE tradition_links (
    source_civilization_id TEXT NOT NULL REFERENCES civilizations(id) ON DELETE CASCADE,
    link_type TEXT NOT NULL
        CHECK(link_type IN ('SUBTRADITION_OF','SUCCESSOR_TO','INFLUENCED_BY','OVERLAPS_WITH','REGIONAL_VARIANT_OF')),
    target_civilization_id TEXT NOT NULL REFERENCES civilizations(id) ON DELETE CASCADE,
    claim_id TEXT,
    notes TEXT,
    PRIMARY KEY(source_civilization_id, link_type, target_civilization_id),
    CHECK(source_civilization_id <> target_civilization_id)
)
```

## `archaeological_sites` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW archaeological_sites AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code IN ('ARCHAEOLOGICAL_SITE','TEMPLE','PYRAMID','TOMB','MONUMENT'))
```

## `artifacts` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW artifacts AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code IN ('ARTIFACT','WEAPON','SACRED_OBJECT','ARMOR','RING','CROWN','SCEPTER','SHIP','CHARIOT','MOUNT'))
```

## `claim_evidence_summary` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `claim_id` | TEXT | 0 |  | 0 |
| 1 | `subject_id` | TEXT | 0 |  | 0 |
| 2 | `predicate` | TEXT | 0 |  | 0 |
| 3 | `claim_status` | TEXT | 0 |  | 0 |
| 4 | `confidence` | REAL | 0 |  | 0 |
| 5 | `evidence_count` |  | 0 |  | 0 |
| 6 | `supporting_count` |  | 0 |  | 0 |
| 7 | `refuting_count` |  | 0 |  | 0 |
| 8 | `strongest_evidence` |  | 0 |  | 0 |

定义：

```sql
CREATE VIEW claim_evidence_summary AS
SELECT c.id AS claim_id,
       c.subject_id,
       c.predicate,
       c.claim_status,
       c.confidence,
       COUNT(e.id) AS evidence_count,
       SUM(CASE WHEN e.direction = 'SUPPORTS' THEN 1 ELSE 0 END) AS supporting_count,
       SUM(CASE WHEN e.direction = 'REFUTES' THEN 1 ELSE 0 END) AS refuting_count,
       MAX(e.strength) AS strongest_evidence
FROM claims c
LEFT JOIN evidence e ON e.claim_id = c.id
GROUP BY c.id
```

## `concepts` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW concepts AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='CONCEPT')
```

## `cosmologies` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW cosmologies AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='COSMOLOGY')
```

## `creatures` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW creatures AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code IN ('CREATURE','MONSTER','DIVINE_BEAST','DRAGON','GIANT','DEMON','SPIRIT','UNDEAD'))
```

## `deities` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW deities AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code IN ('DEITY','PRIMORDIAL_DEITY','ANCESTOR_DEITY'))
```

## `elements` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW elements AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='ELEMENT')
```

## `events` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW events AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='EVENT')
```

## `festivals` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW festivals AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='FESTIVAL')
```

## `heroes` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW heroes AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code IN ('HERO','DEMIGOD'))
```

## `historical_figures` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW historical_figures AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='HISTORICAL_FIGURE')
```

## `inscriptions` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW inscriptions AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='INSCRIPTION')
```

## `manuscripts` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW manuscripts AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='MANUSCRIPT')
```

## `monuments` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW monuments AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='MONUMENT')
```

## `museum_objects` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW museum_objects AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='MUSEUM_OBJECT')
```

## `mythical_places` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW mythical_places AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='MYTHICAL_PLACE')
```

## `myths` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW myths AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='MYTH')
```

## `oral_traditions` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW oral_traditions AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='ORAL_TRADITION')
```

## `papyri` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW papyri AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='PAPYRUS')
```

## `powers` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW powers AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='POWER')
```

## `pyramids` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW pyramids AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='PYRAMID')
```

## `realms` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW realms AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='REALM')
```

## `relationship_edges_bidirectional` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `source_entity_id` | TEXT | 0 |  | 0 |
| 2 | `relationship_type` | BLOB | 0 |  | 0 |
| 3 | `target_entity_id` | TEXT | 0 |  | 0 |
| 4 | `claim_id` | TEXT | 0 |  | 0 |
| 5 | `variant_label` |  | 0 |  | 0 |
| 6 | `certainty` |  | 0 |  | 0 |
| 7 | `confidence` | REAL | 0 |  | 0 |
| 8 | `is_inferred_inverse` |  | 0 |  | 0 |

定义：

```sql
CREATE VIEW relationship_edges_bidirectional AS
SELECT r.id,
       r.source_entity_id,
       r.relationship_type,
       r.target_entity_id,
       r.claim_id,
       r.variant_label,
       r.certainty,
       r.confidence,
       0 AS is_inferred_inverse
FROM relationships r
UNION ALL
SELECT r.id || ':inverse',
       r.target_entity_id,
       COALESCE(rt.inverse_code, r.relationship_type),
       r.source_entity_id,
       r.claim_id,
       r.variant_label,
       r.certainty,
       r.confidence,
       1 AS is_inferred_inverse
FROM relationships r
JOIN relationship_types rt ON rt.code = r.relationship_type
WHERE r.source_entity_id <> r.target_entity_id
  AND (rt.is_symmetric = 1 OR rt.inverse_code IS NOT NULL)
```

## `relationships` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `source_entity_id` | TEXT | 0 |  | 0 |
| 2 | `relationship_type` | TEXT | 0 |  | 0 |
| 3 | `target_entity_id` | TEXT | 0 |  | 0 |
| 4 | `claim_id` | TEXT | 0 |  | 0 |
| 5 | `variant_label` |  | 0 |  | 0 |
| 6 | `certainty` |  | 0 |  | 0 |
| 7 | `confidence` | REAL | 0 |  | 0 |
| 8 | `notes` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW relationships AS
SELECT c.id,
       c.subject_id AS source_entity_id,
       c.predicate AS relationship_type,
       c.object_entity_id AS target_entity_id,
       c.id AS claim_id,
       COALESCE(c.variant_group, 'default') AS variant_label,
       CASE c.claim_status
           WHEN 'SUPPORTED' THEN 'SUPPORTED'
           WHEN 'DISPUTED' THEN 'DISPUTED'
           WHEN 'SPECULATIVE' THEN 'POSSIBLE'
           ELSE 'UNKNOWN'
       END AS certainty,
       c.confidence,
       c.research_notes AS notes
FROM claims c
JOIN relationship_types rt ON rt.code = c.predicate
WHERE c.object_entity_id IS NOT NULL
  AND c.review_status <> 'REJECTED'
```

## `rituals` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW rituals AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code IN ('RITUAL','FESTIVAL'))
```

## `sacred_objects` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW sacred_objects AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='SACRED_OBJECT')
```

## `tablets` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW tablets AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='TABLET')
```

## `temples` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW temples AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='TEMPLE')
```

## `texts` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW texts AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code IN ('TEXT','EPIC','SCRIPTURE','MANUSCRIPT','TABLET','INSCRIPTION','PAPYRUS','ORAL_TRADITION'))
```

## `tombs` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW tombs AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='TOMB')
```

## `weapons` (view)

| 序号 | 字段 | SQLite 类型 | NOT NULL | 默认值 | PK 序位 |
|---:|---|---|---:|---|---:|
| 0 | `id` | TEXT | 0 |  | 0 |
| 1 | `canonical_name` | TEXT | 0 |  | 0 |
| 2 | `name_zh` | TEXT | 0 |  | 0 |
| 3 | `original_name` | TEXT | 0 |  | 0 |
| 4 | `transliteration` | TEXT | 0 |  | 0 |
| 5 | `primary_type` | TEXT | 0 |  | 0 |
| 6 | `primary_civilization_id` | TEXT | 0 |  | 0 |
| 7 | `primary_culture_id` | TEXT | 0 |  | 0 |
| 8 | `primary_region_id` | TEXT | 0 |  | 0 |
| 9 | `historical_period` | TEXT | 0 |  | 0 |
| 10 | `description` | TEXT | 0 |  | 0 |
| 11 | `research_status` | TEXT | 0 |  | 0 |
| 12 | `evidence_status` | TEXT | 0 |  | 0 |
| 13 | `record_version` | INTEGER | 0 |  | 0 |
| 14 | `metadata_json` | TEXT | 0 |  | 0 |
| 15 | `created_at` | TEXT | 0 |  | 0 |
| 16 | `updated_at` | TEXT | 0 |  | 0 |

定义：

```sql
CREATE VIEW weapons AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='WEAPON')
```
