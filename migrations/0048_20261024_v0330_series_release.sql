BEGIN IMMEDIATE;

-- Seal the v0.33 story-series checkpoint: three series (Journey to the West
-- in six parts, the Rāmāyaṇa Books I-VI, the Odyssey in two parts) made of
-- thirteen new long stories plus the existing Journey to the West ch. 1-7.
-- Every section keeps its own evidenced claim; skipped chapters are named in
-- the series, never filled in. Earlier batches and releases stay unchanged.
-- A formal release is a reproducible stage, never ALL COMPLETE.
UPDATE story_expansion_batches
   SET status='CHECKPOINT_COMPLETE',
       completed_at='2026-10-24T03:00:00Z'
 WHERE id='storybatch.v0330.05';

UPDATE explorer_feature_registry
   SET updated_at='2026-10-24T03:00:00Z',
       notes='Sealed: 3 series, 14 parts, 210 chapters — Journey to the West (6 parts, 91 chapters), the Rāmāyaṇa Books I-VI (87 chapters) and the Odyssey Books I-XXIV (32 chapters).'
 WHERE feature_code='story_series';

UPDATE research_sessions
   SET ended_at='2026-10-24T03:00:00Z',
       status='COMPLETED',
       notes='Sealed as v0.33.0: Journey to the West ch. 8-12, 13-22, 27-31, 56-58 and 59-61 as parts 2-6 after the existing ch. 1-7; Vālmīki''s Rāmāyaṇa (Griffith) Books I-VI one book per part; Homer''s Odyssey (Butler) in two parts covering all twenty-four books. 13 new long stories, 194 sections, 194 claims, 48 entities and 1 source.'
 WHERE id='session.20261024.v0330_series';

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result) VALUES
('session.20261024.v0330_series','RELEASE','release.v0.33.0','SEAL','Formal staged checkpoint: 13 completed series-part targets in 3 series; no target blocked.');

INSERT OR IGNORE INTO dataset_releases(
    id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes
) VALUES
('release.v0.33.0',48,'0.33.0',NULL,'2026-10-24T03:00:00Z',NULL,'Story series: Journey to the West in six parts (ch. 1-22, 27-31, 56-61; 91 chapters), the Rāmāyaṇa book by book (Books I-VI; 87 chapters) and the Odyssey in two parts (Books I-XXIV; 32 chapters). Each part is a complete long story whose sections follow one located public witness; the series records each part''s source span and names skipped chapters. Readers get a series shelf, part X of N, previous/next part and continue-to-next-part; the part to continue is worked out from existing on-device reading positions.');

INSERT INTO project_metadata(key,value,updated_at) VALUES
('project_version','0.33.0-series','2026-10-24T03:00:00Z'),
('data_version','0.33.0','2026-10-24T03:00:00Z'),
('schema_version','48','2026-10-24T03:00:00Z'),
('generated_at','2026-10-24T03:00:00Z','2026-10-24T03:00:00Z'),
('project_status','v0.33.0 sealed staged checkpoint: story series with part-by-part reading; every section keeps its own evidence, never ALL COMPLETE','2026-10-24T03:00:00Z')
ON CONFLICT(key) DO UPDATE SET value=excluded.value,updated_at=excluded.updated_at;

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(48,'20261024_v0330_series_release','2026-10-24T03:00:00Z');

COMMIT;
