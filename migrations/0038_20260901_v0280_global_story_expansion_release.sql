BEGIN IMMEDIATE;

-- Seal the first fault-isolated global story-expansion checkpoint without
-- erasing queued or permission-blocked targets. A formal release is a
-- reproducible stage, never an ALL COMPLETE claim.
UPDATE story_expansion_batches
   SET version_label='0.28.0',
       title_zh='v0.28 全球故事扩张',
       title_en='v0.28 Global Story Expansion',
       scope_note='Three source-backed stories form the sealed checkpoint; China and India remain queued, while Māori and Yorùbá content expansion remains permission-gated.',
       status='CHECKPOINT_COMPLETE',
       completed_at='2026-09-01T12:05:39Z'
 WHERE id='storybatch.v0280.01';

UPDATE explorer_feature_registry
   SET introduced_in='v0.28.0',
       updated_at='2026-09-01T12:05:39Z',
       notes='The sealed checkpoint contains Maya, Japanese and Khmer stories; China and India remain queued, while Māori and Yorùbá are permission-gated.'
 WHERE feature_code='global_story_expansion_audit';

UPDATE research_sessions
   SET ended_at='2026-09-01T12:05:39Z',
       status='COMPLETED',
       notes='Three source-backed stories sealed as v0.28.0; China and India remain queued; Māori and Yorùbá permission reviews remain blocking only for their own targets.'
 WHERE id='session.20260901.v0280_batch1';

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result) VALUES
('session.20260901.v0280_batch1','RELEASE','release.v0.28.0','SEAL','Formal staged checkpoint preserves three completed, two queued and two permission-blocked targets.');

INSERT OR IGNORE INTO dataset_releases(
    id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes
) VALUES
('release.v0.28.0',38,'0.28.0',NULL,'2026-09-01T12:05:39Z',NULL,'Global story-expansion checkpoint: three source-backed stories, four independent versions, twelve bilingual sections and event nodes, and a seven-target fault-isolated audit retaining queued and permission-blocked work.');

INSERT INTO project_metadata(key,value,updated_at) VALUES
('project_version','0.28.0-global-story-expansion','2026-09-01T12:05:39Z'),
('data_version','0.28.0','2026-09-01T12:05:39Z'),
('schema_version','38','2026-09-01T12:05:39Z'),
('generated_at','2026-09-01T12:05:39Z','2026-09-01T12:05:39Z'),
('project_status','v0.28.0 sealed staged checkpoint: global story expansion remains open; permission blocks are target-local and never ALL COMPLETE','2026-09-01T12:05:39Z')
ON CONFLICT(key) DO UPDATE SET value=excluded.value,updated_at=excluded.updated_at;

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(38,'20260901_v0280_global_story_expansion_release','2026-09-01T12:05:39Z');

COMMIT;
