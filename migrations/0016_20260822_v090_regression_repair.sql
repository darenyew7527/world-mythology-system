PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE;

UPDATE entities SET metadata_json='{"homonym_scope":"Titan son of Crius and Eurybia; father of Hecate","dedup_rule":"do not merge by name","identity_caution":"Ancient Greek sources contain more than one figure named Perses."}'
WHERE id='deity.greek.perses';
UPDATE entities SET evidence_status='SOURCE_BACKED' WHERE id='deity.greek.hecate';
UPDATE project_metadata SET value='16',updated_at='2026-08-22T06:30:00Z' WHERE key='schema_version';
UPDATE dataset_releases SET schema_version=16 WHERE id='release.0.9.0';
INSERT INTO schema_migrations(version,name,applied_at) VALUES
(16,'20260822_v090_regression_repair','2026-08-22T06:30:00Z');

COMMIT;
