BEGIN IMMEDIATE;

-- Seal the v0.35 world-epic checkpoint: four new series (the Kojiki, the
-- Kalevala, the Mahabharata and the Shahnameh) made of thirteen new long
-- stories, a new long Izanagi/Izanami version and the existing rock-cave
-- story, plus a standalone reading of thirteen Soushen ji tales. Every
-- section keeps its own evidenced claim; skipped sections are named in the
-- series, never filled in. Earlier batches and releases stay unchanged.
-- A formal release is a reproducible stage, never ALL COMPLETE.
UPDATE story_expansion_batches
   SET status='CHECKPOINT_COMPLETE',
       completed_at='2026-10-24T21:00:00Z'
 WHERE id='storybatch.v0350.07';

UPDATE explorer_feature_registry
   SET updated_at='2026-10-24T21:00:00Z',
       notes='Sealed: 13 series, 46 parts — v0.33 and v0.34 series plus v0.35 the Kojiki (5 parts, 65 chapters), the Kalevala (4 parts, 48), the Mahābhārata (3 parts, 39) and the Shahnameh in Zimmern''s prose retelling (3 parts, 36).'
 WHERE feature_code='story_series';

UPDATE research_sessions
   SET ended_at='2026-10-24T21:00:00Z',
       status='COMPLETED',
       notes='Sealed as v0.35.0: the Kojiki (Chamberlain) Sect. I–X as a new long version and Sect. XX–XLIII and LXXIX–XC as three new parts; the Kalevala (Crawford) Runes I–X, XI–XV, XXXI–XXXVI and XXXIX–XLIII; the Mahābhārata (Ganguli) Nala, Sāvitrī and the war at Kurukṣetra; the Shahnameh in Zimmern''s prose retelling; thirteen Soushen ji tales. 14 new long stories and 1 long version, 186 sections, 186 claims, 97 entities, 4 sources and 2 languages.'
 WHERE id='session.20261024.v0350_world_epics';

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result) VALUES
('session.20261024.v0350_world_epics','RELEASE','release.v0.35.0','SEAL','Formal staged checkpoint: 15 completed targets — 14 series parts in 4 series and 1 standalone reading; no target blocked.');

INSERT OR IGNORE INTO dataset_releases(
    id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes
) VALUES
('release.v0.35.0',52,'0.35.0',NULL,'2026-10-24T21:00:00Z',NULL,'World-epic series: the Kojiki in five parts (Sect. I–XLIII and LXXIX–XC; 65 chapters), the Kalevala in four parts (Runes I–XV, XXXI–XXXVI, XXXIX–XLIII; 48 chapters), the Mahābhārata in three parts (Nala, Sāvitrī and Kurukṣetra; 39 chapters) and the Shahnameh in three parts from Zimmern''s prose retelling (36 chapters), plus thirteen tales from the Soushen ji. Each part follows one located public-domain witness, every section keeps its own evidenced claim, and each series names what it leaves out. Takemikazuchi and twenty-four newly registered deities now open stories from their cards.');

INSERT INTO project_metadata(key,value,updated_at) VALUES
('project_version','0.35.0-world-epics','2026-10-24T21:00:00Z'),
('data_version','0.35.0','2026-10-24T21:00:00Z'),
('schema_version','52','2026-10-24T21:00:00Z'),
('generated_at','2026-10-24T21:00:00Z','2026-10-24T21:00:00Z'),
('project_status','v0.35.0 sealed staged checkpoint: world epic series with part-by-part reading; every section keeps its own evidence, never ALL COMPLETE','2026-10-24T21:00:00Z')
ON CONFLICT(key) DO UPDATE SET value=excluded.value,updated_at=excluded.updated_at;

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(52,'20261024_v0350_world_epics_release','2026-10-24T21:00:00Z');

COMMIT;
