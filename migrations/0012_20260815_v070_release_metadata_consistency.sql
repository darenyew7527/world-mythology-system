PRAGMA foreign_keys = ON;

UPDATE dataset_releases
SET schema_version=12
WHERE id='release.0.7.0';

UPDATE project_metadata
SET value='12'
WHERE key='schema_version';

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(12,'20260815_v070_release_metadata_consistency','2026-08-15T06:45:00Z');
