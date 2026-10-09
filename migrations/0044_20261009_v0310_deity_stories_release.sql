BEGIN IMMEDIATE;

-- Seal the v0.31 deity-story checkpoint. Every deity now has a story card;
-- Ogun and Olodumare stay permission-limited until a named community
-- authority grants scope. Earlier batches and releases stay unchanged. A
-- formal release is a reproducible stage, never ALL COMPLETE.
UPDATE story_expansion_batches
   SET status='CHECKPOINT_COMPLETE',
       completed_at='2026-10-09T03:00:00Z'
 WHERE id='storybatch.v0310.03';

UPDATE explorer_feature_registry
   SET updated_at='2026-10-09T03:00:00Z',
       notes='Sealed: 184 deity cards — 111 linked to full stories, 71 evidence cards, 2 permission-limited.'
 WHERE feature_code='deity_story_cards';

UPDATE research_sessions
   SET ended_at='2026-10-09T03:00:00Z',
       status='COMPLETED',
       notes='Sealed as v0.31.0: 26 new stories and one extra public Māori version give every previously claim-less deity a located story or card; Ogun and Olodumare remain permission-limited; Journey to the West stays in the later-reception layer.'
 WHERE id='session.20261009.v0310_deity_stories';

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result) VALUES
('session.20261009.v0310_deity_stories','RELEASE','release.v0.31.0','SEAL','Formal staged checkpoint: 27 completed story targets and one permission-blocked Yorùbá review.');

INSERT OR IGNORE INTO dataset_releases(
    id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes
) VALUES
('release.v0.31.0',44,'0.31.0',NULL,'2026-10-09T03:00:00Z',NULL,'Deity stories: 26 new source-located stories (Egypt, Japan, Norse, Mexica, Maya, Sumer, China, Ireland, Slavic, Zoroastrian, Hawaiʻi) plus a public Te Ara version of the Māori common threads; build-time story cards for all 184 deities; storyteller mode and a deity-story gallery in the web app; Ogun and Olodumare remain permission-limited.');

INSERT INTO project_metadata(key,value,updated_at) VALUES
('project_version','0.31.0-deity-stories','2026-10-09T03:00:00Z'),
('data_version','0.31.0','2026-10-09T03:00:00Z'),
('schema_version','44','2026-10-09T03:00:00Z'),
('generated_at','2026-10-09T03:00:00Z','2026-10-09T03:00:00Z'),
('project_status','v0.31.0 sealed staged checkpoint: every deity has a story card; living-tradition permission limits stay target-local, never ALL COMPLETE','2026-10-09T03:00:00Z')
ON CONFLICT(key) DO UPDATE SET value=excluded.value,updated_at=excluded.updated_at;

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(44,'20261009_v0310_deity_stories_release','2026-10-09T03:00:00Z');

COMMIT;
