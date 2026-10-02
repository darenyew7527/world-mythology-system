BEGIN IMMEDIATE;

-- Seal the second fault-isolated global story-expansion checkpoint. The v0.28
-- batch stays unchanged; queued and permission-blocked v0.30 targets remain
-- visible. A formal release is a reproducible stage, never ALL COMPLETE.
UPDATE story_expansion_batches
   SET version_label='0.30.0',
       title_zh='v0.30 全球故事扩张第二批',
       title_en='v0.30 Global Story Expansion — Batch 2',
       status='CHECKPOINT_COMPLETE',
       completed_at='2026-10-02T06:30:00Z'
 WHERE id='storybatch.v0300.02';

UPDATE explorer_feature_registry
   SET introduced_in='v0.30.0',
       updated_at='2026-10-02T06:30:00Z',
       notes='Sealed: the story library switches between the sealed v0.28 and v0.30 batch audits, newest first.'
 WHERE feature_code='story_expansion_batch_history';

UPDATE research_sessions
   SET ended_at='2026-10-02T06:30:00Z',
       status='COMPLETED',
       notes='Sealed as v0.30.0: three textual-witness stories, six versions, two explicit witness conflicts; later reception and apparatus audits queued; Māori and Yorùbá permission reviews remain blocking only for their own targets.'
 WHERE id='session.20261002.v0300_batch2';

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result) VALUES
('session.20261002.v0300_batch2','RELEASE','release.v0.30.0','SEAL','Formal staged checkpoint preserves four completed, two queued and two permission-blocked batch-2 targets.');

INSERT OR IGNORE INTO dataset_releases(
    id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes
) VALUES
('release.v0.30.0',42,'0.30.0',NULL,'2026-10-02T06:30:00Z',NULL,'Global story expansion batch 2: Nüwa and Gonggong stories from Huainanzi and Liezi witnesses, the churning of the ocean from the Mahābhārata critical edition and the Bhāgavata Purāṇa, thirteen witness-comparison topics, two explicit witness conflicts, a textual/material witness reading route, and an eight-target audit retaining queued and permission-blocked work.');

INSERT INTO project_metadata(key,value,updated_at) VALUES
('project_version','0.30.0-global-story-expansion-batch-2','2026-10-02T06:30:00Z'),
('data_version','0.30.0','2026-10-02T06:30:00Z'),
('schema_version','42','2026-10-02T06:30:00Z'),
('generated_at','2026-10-02T06:30:00Z','2026-10-02T06:30:00Z'),
('project_status','v0.30.0 sealed staged checkpoint: global story expansion continues; textual witnesses stay separate and permission blocks are target-local, never ALL COMPLETE','2026-10-02T06:30:00Z')
ON CONFLICT(key) DO UPDATE SET value=excluded.value,updated_at=excluded.updated_at;

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(42,'20261002_v0300_global_story_expansion_batch2_release','2026-10-02T06:30:00Z');

COMMIT;
