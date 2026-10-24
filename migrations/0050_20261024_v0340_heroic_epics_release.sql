BEGIN IMMEDIATE;

-- Seal the v0.34 heroic-epic checkpoint: six new series (Greek heroes from
-- Apollodorus, the Argonautica, the end of Gylfaginning, the Völsunga saga,
-- the Táin and the Four Branches of the Mabinogi) made of fifteen new long
-- stories, one new long Ragnarök version and the existing long Baldr story.
-- Every section keeps its own evidenced claim; skipped chapters are named in
-- the series, never filled in. Earlier batches and releases stay unchanged.
-- A formal release is a reproducible stage, never ALL COMPLETE.
UPDATE story_expansion_batches
   SET status='CHECKPOINT_COMPLETE',
       completed_at='2026-10-24T15:00:00Z'
 WHERE id='storybatch.v0340.06';

UPDATE explorer_feature_registry
   SET updated_at='2026-10-24T15:00:00Z',
       notes='Sealed: 9 series, 31 parts — v0.33 Journey to the West, Rāmāyaṇa and Odyssey, plus v0.34 Greek heroes (4 parts, 49 chapters), the Argonautica (2 parts, 26), the end of Gylfaginning (2 parts, 25), the Völsunga saga (3 parts, 36), the Táin (2 parts, 25) and the Four Branches of the Mabinogi (4 parts, 48).'
 WHERE feature_code='story_series';

UPDATE research_sessions
   SET ended_at='2026-10-24T15:00:00Z',
       status='COMPLETED',
       notes='Sealed as v0.34.0: Perseus and Heracles in four parts from Apollodorus Library 2.4.1-2.8.1; Apollonius''s Argonautica (Seaton) Books I-IV in two parts; Gylfaginning 49-53 in two parts with a new long Ragnarök version; the Völsunga saga (Morris and Magnússon) ch. 1-32 in three parts; the Táin (Dunn) in two parts; the Four Branches of the Mabinogi (Guest) one branch per part. 15 new long stories and 1 long version, 196 sections, 196 claims, 77 entities and 4 sources.'
 WHERE id='session.20261024.v0340_heroic_epics';

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result) VALUES
('session.20261024.v0340_heroic_epics','RELEASE','release.v0.34.0','SEAL','Formal staged checkpoint: 16 completed series-part targets in 6 series; no target blocked.');

INSERT OR IGNORE INTO dataset_releases(
    id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes
) VALUES
('release.v0.34.0',50,'0.34.0',NULL,'2026-10-24T15:00:00Z',NULL,'Heroic-epic series: Perseus and Heracles in four parts from Apollodorus (Library 2.4.1-2.8.1; 49 chapters), the Argonautica in two parts (Books I-IV; 26 chapters), the death of Baldr and Ragnarök from the end of Gylfaginning (chapters 49-53; 25 chapters), the Völsunga saga in three parts (ch. 1-32; 36 chapters), the Táin in two parts (25 chapters) and the Four Branches of the Mabinogi (48 chapters). Each part follows one located public-domain witness, every section keeps its own evidenced claim, and the series names what it leaves out. Hera, Apollo and six newly registered deities now open stories from their cards.');

INSERT INTO project_metadata(key,value,updated_at) VALUES
('project_version','0.34.0-heroic-epics','2026-10-24T15:00:00Z'),
('data_version','0.34.0','2026-10-24T15:00:00Z'),
('schema_version','50','2026-10-24T15:00:00Z'),
('generated_at','2026-10-24T15:00:00Z','2026-10-24T15:00:00Z'),
('project_status','v0.34.0 sealed staged checkpoint: heroic-epic series with part-by-part reading; every section keeps its own evidence, never ALL COMPLETE','2026-10-24T15:00:00Z')
ON CONFLICT(key) DO UPDATE SET value=excluded.value,updated_at=excluded.updated_at;

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(50,'20261024_v0340_heroic_epics_release','2026-10-24T15:00:00Z');

COMMIT;
