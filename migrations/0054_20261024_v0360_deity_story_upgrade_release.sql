BEGIN IMMEDIATE;

-- Seal the v0.36 deity-story checkpoint: fifteen new long stories and two
-- long versions of existing stories, chosen so that deities that had only
-- evidence cards open a located narrative, plus a Homeric Hymns series that
-- reuses the existing Hymn to Demeter as its first part. Every section keeps
-- its own evidenced claim; broken passages are named, not filled in.
-- Deities without a located public narrative keep their evidence cards, and
-- living-tradition deities keep their access policies. Earlier batches and
-- releases stay unchanged. A formal release is a reproducible stage, never
-- ALL COMPLETE.
UPDATE story_expansion_batches
   SET status='CHECKPOINT_COMPLETE',
       completed_at='2026-10-24T23:30:00Z'
 WHERE id='storybatch.v0360.08';

UPDATE explorer_feature_registry
   SET updated_at='2026-10-24T23:30:00Z',
       notes='Sealed: 14 series, 50 parts — v0.33–v0.35 series plus v0.36 the Homeric Hymns (4 parts, 52 chapters: to Demeter, Apollo, Hermes and Aphrodite).'
 WHERE feature_code='story_series';

UPDATE research_sessions
   SET ended_at='2026-10-24T23:30:00Z',
       status='COMPLETED',
       notes='Sealed as v0.36.0: the Homeric Hymns to Apollo, Hermes and Aphrodite, the Titans'' children in the Theogony, Artemis and Dionysus in Apollodorus, Ares in the Iliad; long Gylfaginning creation and Sif''s hair versions and Thor and Hrungnir; the Bentresh Stela, the Tale of Two Brothers, Hatshepsut''s birth cycle and the Memphite Theology; Baal''s palace (KTU 1.3–1.4); Inana and Ebih; Leigong in the Lunheng. 15 new long stories and 2 long versions, 211 sections, 211 claims, 39 entities and 7 sources; 37 deities that had only evidence cards now open stories.'
 WHERE id='session.20261024.v0360_deity_story_upgrade';

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result) VALUES
('session.20261024.v0360_deity_story_upgrade','RELEASE','release.v0.36.0','SEAL','Formal staged checkpoint: 17 completed targets — 15 new long stories (3 in a new series) and 2 long versions; no target blocked. 18 deities keep evidence cards because no located public narrative was found or a living-tradition policy applies.');

INSERT OR IGNORE INTO dataset_releases(
    id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes
) VALUES
('release.v0.36.0',54,'0.36.0',NULL,'2026-10-24T23:30:00Z',NULL,'Stories for evidence-card deities: the Homeric Hymns to Apollo, Hermes and Aphrodite join the Hymn to Demeter as a four-part series; the Theogony''s families of Night and the Titans, Artemis and Dionysus in Apollodorus and Ares in the Iliad; long versions of the Gylfaginning creation and of Sif''s hair, and Thor and Hrungnir; the Bentresh Stela, the Tale of Two Brothers, Hatshepsut''s divine birth and the Memphite Theology; Baal''s palace; Inana and Ebih; and Wang Chong on Leigong. Thirty-seven deities that had only evidence cards, among them Leto, Artemis, Ares, Dionysus, Hestia, Ptah, Khonsu, Amun, El, Athirat, An and Leigong, now open stories; seven newly registered deities have stories too.');

INSERT INTO project_metadata(key,value,updated_at) VALUES
('project_version','0.36.0-deity-story-upgrade','2026-10-24T23:30:00Z'),
('data_version','0.36.0','2026-10-24T23:30:00Z'),
('schema_version','54','2026-10-24T23:30:00Z'),
('generated_at','2026-10-24T23:30:00Z','2026-10-24T23:30:00Z'),
('project_status','v0.36.0 sealed staged checkpoint: stories for evidence-card deities with section-by-section evidence, never ALL COMPLETE','2026-10-24T23:30:00Z')
ON CONFLICT(key) DO UPDATE SET value=excluded.value,updated_at=excluded.updated_at;

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(54,'20261024_v0360_deity_story_upgrade_release','2026-10-24T23:30:00Z');

COMMIT;
