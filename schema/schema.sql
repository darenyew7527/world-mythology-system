PRAGMA foreign_keys = ON;
PRAGMA journal_mode = DELETE;

CREATE TABLE IF NOT EXISTS schema_migrations (
    version INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    applied_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS project_metadata (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS dataset_releases (
    id TEXT PRIMARY KEY,
    schema_version INTEGER NOT NULL,
    data_version TEXT NOT NULL,
    git_commit TEXT,
    built_at TEXT NOT NULL,
    database_sha256 TEXT,
    release_notes TEXT
);

CREATE TABLE IF NOT EXISTS regions (
    id TEXT PRIMARY KEY,
    canonical_name TEXT NOT NULL,
    name_zh TEXT,
    parent_id TEXT REFERENCES regions(id),
    region_type TEXT NOT NULL DEFAULT 'CULTURAL',
    notes TEXT
);

CREATE TABLE IF NOT EXISTS civilizations (
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
);

CREATE TABLE IF NOT EXISTS cultures (
    id TEXT PRIMARY KEY,
    canonical_name TEXT NOT NULL,
    name_zh TEXT,
    parent_id TEXT REFERENCES cultures(id),
    civilization_id TEXT REFERENCES civilizations(id),
    region_id TEXT REFERENCES regions(id),
    description TEXT,
    research_status TEXT NOT NULL DEFAULT 'DISCOVERED'
);

CREATE TABLE IF NOT EXISTS languages (
    id TEXT PRIMARY KEY,
    canonical_name TEXT NOT NULL,
    name_zh TEXT,
    iso_639_3 TEXT,
    script_name TEXT,
    historical_stage TEXT,
    notes TEXT
);

CREATE TABLE IF NOT EXISTS civilization_languages (
    civilization_id TEXT NOT NULL REFERENCES civilizations(id) ON DELETE CASCADE,
    language_id TEXT NOT NULL REFERENCES languages(id) ON DELETE CASCADE,
    usage_role TEXT NOT NULL DEFAULT 'ATTESTED',
    notes TEXT,
    PRIMARY KEY (civilization_id, language_id, usage_role)
);

CREATE TABLE IF NOT EXISTS entity_types (
    code TEXT PRIMARY KEY,
    label_en TEXT NOT NULL,
    label_zh TEXT,
    parent_code TEXT REFERENCES entity_types(code),
    description TEXT
);

CREATE TABLE IF NOT EXISTS entities (
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
);

CREATE INDEX IF NOT EXISTS idx_entities_name ON entities(canonical_name);
CREATE INDEX IF NOT EXISTS idx_entities_name_zh ON entities(name_zh);
CREATE INDEX IF NOT EXISTS idx_entities_type ON entities(primary_type);
CREATE INDEX IF NOT EXISTS idx_entities_civilization ON entities(primary_civilization_id);
CREATE INDEX IF NOT EXISTS idx_entities_status ON entities(research_status, evidence_status);

CREATE TABLE IF NOT EXISTS entity_classifications (
    entity_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    type_code TEXT NOT NULL REFERENCES entity_types(code),
    is_primary INTEGER NOT NULL DEFAULT 0 CHECK(is_primary IN (0,1)),
    notes TEXT,
    PRIMARY KEY(entity_id, type_code)
);

CREATE INDEX IF NOT EXISTS idx_entity_classifications_type
    ON entity_classifications(type_code, entity_id);

CREATE TABLE IF NOT EXISTS entity_civilizations (
    entity_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    civilization_id TEXT NOT NULL REFERENCES civilizations(id) ON DELETE CASCADE,
    association_role TEXT NOT NULL DEFAULT 'ORIGIN',
    certainty TEXT NOT NULL DEFAULT 'SUPPORTED'
        CHECK(certainty IN ('CONFIRMED','SUPPORTED','POSSIBLE','DISPUTED','UNKNOWN')),
    notes TEXT,
    PRIMARY KEY(entity_id, civilization_id, association_role)
);

CREATE TABLE IF NOT EXISTS tradition_links (
    source_civilization_id TEXT NOT NULL REFERENCES civilizations(id) ON DELETE CASCADE,
    link_type TEXT NOT NULL
        CHECK(link_type IN ('SUBTRADITION_OF','SUCCESSOR_TO','INFLUENCED_BY','OVERLAPS_WITH','REGIONAL_VARIANT_OF')),
    target_civilization_id TEXT NOT NULL REFERENCES civilizations(id) ON DELETE CASCADE,
    claim_id TEXT,
    notes TEXT,
    PRIMARY KEY(source_civilization_id, link_type, target_civilization_id),
    CHECK(source_civilization_id <> target_civilization_id)
);

CREATE TABLE IF NOT EXISTS sources (
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
);

CREATE INDEX IF NOT EXISTS idx_sources_type ON sources(source_type, evidence_tier);
CREATE INDEX IF NOT EXISTS idx_sources_url ON sources(url);

CREATE TABLE IF NOT EXISTS names (
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
);

CREATE INDEX IF NOT EXISTS idx_names_normalized ON names(normalized_text);

CREATE TABLE IF NOT EXISTS aliases (
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
);

CREATE TABLE IF NOT EXISTS entity_redirects (
    duplicate_entity_id TEXT PRIMARY KEY REFERENCES entities(id),
    canonical_entity_id TEXT NOT NULL REFERENCES entities(id),
    resolution_basis TEXT NOT NULL,
    resolved_at TEXT NOT NULL,
    CHECK(duplicate_entity_id <> canonical_entity_id)
);

CREATE TABLE IF NOT EXISTS identity_candidates (
    id TEXT PRIMARY KEY,
    entity_a_id TEXT NOT NULL REFERENCES entities(id),
    entity_b_id TEXT NOT NULL REFERENCES entities(id),
    assessment TEXT NOT NULL CHECK(assessment IN ('POSSIBLY_SAME','DISPUTED_IDENTITY','IDENTIFIED_IN_SOURCE','EXPLICITLY_DISTINCT')),
    confidence REAL CHECK(confidence IS NULL OR confidence BETWEEN 0 AND 1),
    source_id TEXT REFERENCES sources(id),
    notes TEXT NOT NULL,
    CHECK(entity_a_id <> entity_b_id),
    UNIQUE(entity_a_id, entity_b_id, assessment)
);

CREATE INDEX IF NOT EXISTS idx_aliases_normalized ON aliases(normalized_text, language_id);

CREATE TABLE IF NOT EXISTS claims (
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
);

CREATE INDEX IF NOT EXISTS idx_claims_subject ON claims(subject_id, predicate);
CREATE INDEX IF NOT EXISTS idx_claims_object ON claims(object_entity_id);
CREATE INDEX IF NOT EXISTS idx_claims_variant ON claims(variant_group);

CREATE TABLE IF NOT EXISTS evidence (
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
);

CREATE INDEX IF NOT EXISTS idx_evidence_claim ON evidence(claim_id);
CREATE INDEX IF NOT EXISTS idx_evidence_source ON evidence(source_id);

CREATE TABLE IF NOT EXISTS relationship_types (
    code TEXT PRIMARY KEY,
    inverse_code TEXT REFERENCES relationship_types(code),
    label_en TEXT NOT NULL,
    label_zh TEXT,
    category TEXT,
    is_symmetric INTEGER NOT NULL DEFAULT 0 CHECK(is_symmetric IN (0,1)),
    description TEXT
);

CREATE TABLE IF NOT EXISTS entity_attributes (
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
);

CREATE INDEX IF NOT EXISTS idx_attributes_entity ON entity_attributes(entity_id, attribute_key);

CREATE TABLE IF NOT EXISTS deity_profiles (
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
);

CREATE TABLE IF NOT EXISTS artifact_profiles (
    entity_id TEXT PRIMARY KEY REFERENCES entities(id) ON DELETE CASCADE,
    artifact_type TEXT NOT NULL,
    material_json TEXT NOT NULL DEFAULT '[]',
    appearance_json TEXT NOT NULL DEFAULT '{}',
    abilities_json TEXT NOT NULL DEFAULT '[]',
    limitations_json TEXT NOT NULL DEFAULT '[]',
    usage_conditions_json TEXT NOT NULL DEFAULT '[]',
    creation_summary TEXT,
    fate_summary TEXT
);

CREATE TABLE IF NOT EXISTS creature_profiles (
    entity_id TEXT PRIMARY KEY REFERENCES entities(id) ON DELETE CASCADE,
    creature_class TEXT NOT NULL,
    appearance_json TEXT NOT NULL DEFAULT '{}',
    abilities_json TEXT NOT NULL DEFAULT '[]',
    weaknesses_json TEXT NOT NULL DEFAULT '[]',
    habitat_summary TEXT,
    origin_summary TEXT,
    fate_summary TEXT
);

CREATE TABLE IF NOT EXISTS text_profiles (
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
);

CREATE TABLE IF NOT EXISTS place_profiles (
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
);

CREATE TABLE IF NOT EXISTS myth_event_profiles (
    entity_id TEXT PRIMARY KEY REFERENCES entities(id) ON DELETE CASCADE,
    event_type TEXT NOT NULL,
    time_layer TEXT,
    cause_summary TEXT,
    process_summary TEXT,
    result_summary TEXT,
    symbolism_summary TEXT
);

CREATE TABLE IF NOT EXISTS event_participants (
    event_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    participant_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    role TEXT NOT NULL,
    outcome TEXT,
    claim_id TEXT REFERENCES claims(id),
    PRIMARY KEY(event_id, participant_id, role)
);

CREATE TABLE IF NOT EXISTS museum_object_profiles (
    entity_id TEXT PRIMARY KEY REFERENCES entities(id) ON DELETE CASCADE,
    holding_institution TEXT NOT NULL,
    catalogue_number TEXT NOT NULL,
    object_type TEXT,
    provenance TEXT,
    date_range TEXT,
    acquisition_notes TEXT,
    UNIQUE(holding_institution, catalogue_number)
);

CREATE TABLE IF NOT EXISTS modern_adaptations (
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
);

CREATE TABLE IF NOT EXISTS conflicts (
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
);

CREATE TABLE IF NOT EXISTS collection_queue (
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
);

CREATE INDEX IF NOT EXISTS idx_queue_status ON collection_queue(status, priority DESC);

CREATE TABLE IF NOT EXISTS queue_discoveries (
    id TEXT PRIMARY KEY,
    queue_id TEXT NOT NULL REFERENCES collection_queue(id) ON DELETE CASCADE,
    discovered_from_entity_id TEXT REFERENCES entities(id),
    discovered_from_claim_id TEXT REFERENCES claims(id),
    discovered_from_source_id TEXT REFERENCES sources(id),
    discovery_context TEXT NOT NULL,
    discovered_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS queue_status_history (
    id TEXT PRIMARY KEY,
    queue_id TEXT NOT NULL REFERENCES collection_queue(id) ON DELETE CASCADE,
    old_status TEXT,
    new_status TEXT NOT NULL,
    changed_at TEXT NOT NULL,
    reason TEXT
);

CREATE TABLE IF NOT EXISTS research_sessions (
    id TEXT PRIMARY KEY,
    started_at TEXT NOT NULL,
    ended_at TEXT,
    scope TEXT NOT NULL,
    strategy TEXT,
    status TEXT NOT NULL,
    agent_or_process TEXT,
    notes TEXT
);

CREATE TABLE IF NOT EXISTS research_session_items (
    session_id TEXT NOT NULL REFERENCES research_sessions(id) ON DELETE CASCADE,
    item_kind TEXT NOT NULL,
    item_id TEXT NOT NULL,
    action TEXT NOT NULL,
    result TEXT,
    PRIMARY KEY(session_id, item_kind, item_id, action)
);

CREATE TABLE IF NOT EXISTS import_runs (
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
);

CREATE TABLE IF NOT EXISTS import_errors (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    import_run_id TEXT NOT NULL REFERENCES import_runs(id) ON DELETE CASCADE,
    row_locator TEXT,
    error_code TEXT NOT NULL,
    message TEXT NOT NULL,
    raw_payload TEXT
);

CREATE TABLE IF NOT EXISTS coverage_reports (
    id TEXT PRIMARY KEY,
    generated_at TEXT NOT NULL,
    baseline_label TEXT NOT NULL,
    summary TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS coverage_metrics (
    report_id TEXT NOT NULL REFERENCES coverage_reports(id) ON DELETE CASCADE,
    metric_key TEXT NOT NULL,
    metric_value REAL NOT NULL,
    denominator REAL,
    notes TEXT,
    PRIMARY KEY(report_id, metric_key)
);

CREATE TABLE IF NOT EXISTS quality_runs (
    id TEXT PRIMARY KEY,
    started_at TEXT NOT NULL,
    ended_at TEXT,
    status TEXT NOT NULL,
    summary TEXT
);

CREATE TABLE IF NOT EXISTS quality_findings (
    id TEXT PRIMARY KEY,
    quality_run_id TEXT NOT NULL REFERENCES quality_runs(id) ON DELETE CASCADE,
    severity TEXT NOT NULL CHECK(severity IN ('INFO','LOW','MEDIUM','HIGH','CRITICAL')),
    rule_code TEXT NOT NULL,
    entity_id TEXT REFERENCES entities(id),
    claim_id TEXT REFERENCES claims(id),
    message TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'OPEN' CHECK(status IN ('OPEN','FIXED','ACCEPTED','DEFERRED'))
);

CREATE VIEW IF NOT EXISTS relationships AS
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
  AND c.review_status <> 'REJECTED';

CREATE VIEW IF NOT EXISTS relationship_edges_bidirectional AS
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
  AND (rt.is_symmetric = 1 OR rt.inverse_code IS NOT NULL);

CREATE VIEW IF NOT EXISTS claim_evidence_summary AS
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
GROUP BY c.id;

-- Named entity collections are classification-driven. A secondary classification must
-- be queryable everywhere that a primary classification is queryable.
CREATE VIEW IF NOT EXISTS deities AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code IN ('DEITY','PRIMORDIAL_DEITY','ANCESTOR_DEITY'));
CREATE VIEW IF NOT EXISTS heroes AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code IN ('HERO','DEMIGOD'));
CREATE VIEW IF NOT EXISTS historical_figures AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='HISTORICAL_FIGURE');
CREATE VIEW IF NOT EXISTS creatures AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code IN ('CREATURE','MONSTER','DIVINE_BEAST','DRAGON','GIANT','DEMON','SPIRIT','UNDEAD'));
CREATE VIEW IF NOT EXISTS weapons AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='WEAPON');
CREATE VIEW IF NOT EXISTS artifacts AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code IN ('ARTIFACT','WEAPON','SACRED_OBJECT','ARMOR','RING','CROWN','SCEPTER','SHIP','CHARIOT','MOUNT'));
CREATE VIEW IF NOT EXISTS sacred_objects AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='SACRED_OBJECT');
CREATE VIEW IF NOT EXISTS elements AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='ELEMENT');
CREATE VIEW IF NOT EXISTS powers AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='POWER');
CREATE VIEW IF NOT EXISTS concepts AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='CONCEPT');
CREATE VIEW IF NOT EXISTS myths AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='MYTH');
CREATE VIEW IF NOT EXISTS events AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='EVENT');
CREATE VIEW IF NOT EXISTS cosmologies AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='COSMOLOGY');
CREATE VIEW IF NOT EXISTS realms AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='REALM');
CREATE VIEW IF NOT EXISTS mythical_places AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='MYTHICAL_PLACE');
CREATE VIEW IF NOT EXISTS archaeological_sites AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code IN ('ARCHAEOLOGICAL_SITE','TEMPLE','PYRAMID','TOMB','MONUMENT'));
CREATE VIEW IF NOT EXISTS temples AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='TEMPLE');
CREATE VIEW IF NOT EXISTS pyramids AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='PYRAMID');
CREATE VIEW IF NOT EXISTS tombs AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='TOMB');
CREATE VIEW IF NOT EXISTS monuments AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='MONUMENT');
CREATE VIEW IF NOT EXISTS texts AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code IN ('TEXT','EPIC','SCRIPTURE','MANUSCRIPT','TABLET','INSCRIPTION','PAPYRUS','ORAL_TRADITION'));
CREATE VIEW IF NOT EXISTS manuscripts AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='MANUSCRIPT');
CREATE VIEW IF NOT EXISTS tablets AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='TABLET');
CREATE VIEW IF NOT EXISTS inscriptions AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='INSCRIPTION');
CREATE VIEW IF NOT EXISTS papyri AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='PAPYRUS');
CREATE VIEW IF NOT EXISTS oral_traditions AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='ORAL_TRADITION');
CREATE VIEW IF NOT EXISTS rituals AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code IN ('RITUAL','FESTIVAL'));
CREATE VIEW IF NOT EXISTS festivals AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='FESTIVAL');
CREATE VIEW IF NOT EXISTS museum_objects AS SELECT e.* FROM entities e WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code='MUSEUM_OBJECT');
