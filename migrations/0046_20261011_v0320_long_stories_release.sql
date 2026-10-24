BEGIN IMMEDIATE;

-- Seal the v0.32 long-form story checkpoint: twelve retellings of 12-20
-- sections each, every section anchored to its own evidenced claim. Short
-- versions stay beside the long ones, later literary layers stay in
-- LATER_RECEPTION, and earlier batches and releases stay unchanged. A formal
-- release is a reproducible stage, never ALL COMPLETE.
UPDATE story_expansion_batches
   SET status='CHECKPOINT_COMPLETE',
       completed_at='2026-10-11T03:00:00Z'
 WHERE id='storybatch.v0320.04';

UPDATE explorer_feature_registry
   SET updated_at='2026-10-11T03:00:00Z',
       notes='Sealed: 12 long-form stories (173 sections) — 8 new stories and long versions of 4 existing ones; 60 deity cards open on a long story.'
 WHERE feature_code='long_form_stories';

UPDATE research_sessions
   SET ended_at='2026-10-11T03:00:00Z',
       status='COMPLETED',
       notes='Sealed as v0.32.0: Journey to the West ch. 1–7, Investiture of the Gods ch. 12–14, the Theogony, Thor and Útgarða-Loki, the Standard Babylonian Gilgamesh, Plutarch on Isis and Osiris, the Kojiki rock-cave and serpent and the Rāmāyaṇa (Books I–VI) as new long stories, plus long versions of the Hymn to Demeter, the death of Baldr, Enūma eliš and Inana''s Descent; 173 sections, each with its own evidenced anchor claim.'
 WHERE id='session.20261011.v0320_long_stories';

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result) VALUES
('session.20261011.v0320_long_stories','RELEASE','release.v0.32.0','SEAL','Formal staged checkpoint: 12 completed long-story targets; no target blocked.');

INSERT OR IGNORE INTO dataset_releases(
    id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes
) VALUES
('release.v0.32.0',46,'0.32.0',NULL,'2026-10-11T03:00:00Z',NULL,'Long-form stories: 12 retellings of 12-20 sections that follow one located public witness in order (Journey to the West, Investiture of the Gods, Theogony, Gylfaginning, Standard Babylonian Gilgamesh, Plutarch, Kojiki, Rāmāyaṇa, and long versions of the Hymn to Demeter, Baldr, Enūma eliš and Inana''s Descent); deity cards carry every section of a linked story; chapter contents, next-chapter links and an on-device reading position in the web app.');

INSERT INTO project_metadata(key,value,updated_at) VALUES
('project_version','0.32.0-long-stories','2026-10-11T03:00:00Z'),
('data_version','0.32.0','2026-10-11T03:00:00Z'),
('schema_version','46','2026-10-11T03:00:00Z'),
('generated_at','2026-10-11T03:00:00Z','2026-10-11T03:00:00Z'),
('project_status','v0.32.0 sealed staged checkpoint: long-form stories with chapter reading; every section keeps its own evidence, never ALL COMPLETE','2026-10-11T03:00:00Z')
ON CONFLICT(key) DO UPDATE SET value=excluded.value,updated_at=excluded.updated_at;

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(46,'20261011_v0320_long_stories_release','2026-10-11T03:00:00Z');

COMMIT;
