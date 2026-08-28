BEGIN IMMEDIATE;

CREATE TABLE IF NOT EXISTS explorer_feature_registry (
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
);
CREATE INDEX IF NOT EXISTS idx_explorer_feature_order
    ON explorer_feature_registry(display_order, feature_code);

INSERT OR IGNORE INTO explorer_feature_registry(
    feature_code,title_zh,title_en,feature_group,data_basis,evidence_caveat,
    status,introduced_in,display_order,updated_at,notes
) VALUES
('WORLD_MAP','证据地图','Evidence map','ORIENTATION','place_profiles latitude/longitude joined to canonical entities','Only real places with explicit coordinates and a non-baseline evidence grade are plotted; missing coordinates are not inferred.','LIMITED','0.24.0',10,'2026-08-27T17:00:00Z','The initial coordinate-backed layer is intentionally sparse.'),
('RELEASE_TIMELINE','版本时间线','Release timeline','TIME','dataset_releases built_at, schema_version and data_version','The timeline dates database releases; free-text mythic periods are not forced onto a modern absolute chronology.','ACTIVE','0.24.0',20,'2026-08-27T17:00:00Z',NULL),
('WITNESS_GRAPH','见证图','Witness graph','NETWORK','claims, evidence and sources connected to canonical entities','A graph edge means an explicit database link, not common origin or identity.','ACTIVE','0.24.0',30,'2026-08-27T17:00:00Z',NULL),
('VERSION_COMPARISON','版本比较','Version comparison','COMPARISON','dataset_releases and conflicts','Release metadata comparison does not imply that historical coverage is complete.','ACTIVE','0.24.0',40,'2026-08-27T17:00:00Z',NULL),
('EVIDENCE_FILTERS','证据层筛选','Evidence-layer filters','EVIDENCE','claims assertion_scope, knowledge_layer, review_status and evidence evidence_type','Filters expose recorded labels; they do not upgrade uncertain evidence.','ACTIVE','0.24.0',50,'2026-08-27T17:00:00Z',NULL),
('CONFLICT_VIEWER','冲突查看器','Conflict viewer','EVIDENCE','conflicts with linked claim statements','Open and resolved-as-variants records remain visible; no forced single answer is produced.','ACTIVE','0.24.0',60,'2026-08-27T17:00:00Z',NULL),
('SOURCE_QUALITY','来源质量面板','Source quality panel','QUALITY','sources evidence_tier, verification_status, source_type and rights_status','Counts describe registered source metadata, not a universal ranking of traditions.','ACTIVE','0.24.0',70,'2026-08-27T17:00:00Z',NULL),
('COVERAGE_HEATMAP','覆盖热图','Coverage heatmap','QUALITY','canonical entities, claims, evidence, conflicts and civilization membership','Coverage is a research-density indicator, never a completeness score or measure of cultural importance.','ACTIVE','0.24.0',80,'2026-08-27T17:00:00Z',NULL),
('QUEUE_PROGRESS','队列进度','Queue progress','WORKFLOW','collection_queue status and priority','BASELINE_COMPLETE marks a bounded target checkpoint, not an all-complete tradition.','ACTIVE','0.24.0',90,'2026-08-27T17:00:00Z',NULL),
('ACCESS_POLICY','活态传统权限','Living-tradition access policy','GOVERNANCE','tradition_access_policies access levels and public governance scope','Public visibility never grants permission to collect restricted or initiatory knowledge.','ACTIVE','0.24.0',100,'2026-08-27T17:00:00Z',NULL);

INSERT OR IGNORE INTO research_sessions(
    id,started_at,ended_at,scope,strategy,status,agent_or_process,notes
) VALUES(
    'research.20260827.v0240_explorer2',
    '2026-08-27T16:05:00Z',
    '2026-08-27T17:00:00Z',
    'Explorer 2.0 evidence workbench and public analytical snapshot',
    'Expose persistent evidence, conflict, source-quality, coverage and queue layers with truthful visual caveats and mobile-accessible fallbacks',
    'CHECKPOINT_COMPLETE',
    'Codex persistent research pipeline',
    'No coordinates, chronology, identity equivalence or completion claims were inferred for presentation.'
);

UPDATE project_metadata
SET value='0.24.0-explorer2-evidence-workbench-20260827',updated_at='2026-08-27T17:00:00Z'
WHERE key='data_version';
UPDATE project_metadata
SET value='33',updated_at='2026-08-27T17:00:00Z'
WHERE key='schema_version';
UPDATE project_metadata
SET value='2026-08-27T17:00:00Z',updated_at='2026-08-27T17:00:00Z'
WHERE key='generated_at';

INSERT OR IGNORE INTO dataset_releases(
    id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes
) VALUES(
    'release.0.24.0',33,'0.24.0-explorer2-evidence-workbench-20260827',NULL,
    '2026-08-27T17:00:00Z',NULL,
    'Explorer 2.0 checkpoint: evidence map, release timeline, witness graph, version comparison, evidence-layer filters, conflict viewer, source-quality panel, coverage heatmap, permanent-queue progress and living-tradition access-policy summary.'
);

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(33,'20260827_v0240_explorer2_evidence_workbench','2026-08-27T17:00:00Z');

COMMIT;
