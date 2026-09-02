BEGIN IMMEDIATE;

-- Seal the v0.29 reader and offline-archive checkpoint. Personal reading
-- activity remains browser-local; the release database records only public
-- content and the zero-collection delivery contract introduced in migration 39.
UPDATE reader_feature_registry
   SET introduced_in='v0.29.0'
 WHERE introduced_in='v0.29.0-dev';

UPDATE explorer_feature_registry
   SET introduced_in='v0.29.0',
       updated_at='2026-09-02T03:15:59Z',
       notes=CASE feature_code
           WHEN 'reader_local_state' THEN 'Sealed on-device reader tools use a versioned localStorage key; no account, telemetry or cloud synchronization is introduced.'
           WHEN 'offline_story_archive' THEN 'Sealed self-contained HTML and JSON remain searchable, bilingual and print-friendly while preserving source and rights boundaries.'
           ELSE notes
       END
 WHERE feature_code IN ('reader_local_state','offline_story_archive');

INSERT OR IGNORE INTO dataset_releases(
    id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes
) VALUES
('release.v0.29.0',40,'0.29.0',NULL,'2026-09-02T03:15:59Z',NULL,'Reader and offline-archive checkpoint: on-device bookmarks, per-witness section progress, accessible presentation settings, glossary/entity quick look, and self-contained bilingual HTML/JSON artifacts. No personal reading state enters SQLite, exports, or the public snapshot.');

INSERT INTO project_metadata(key,value,updated_at) VALUES
('project_version','0.29.0-reader-offline-archive','2026-09-02T03:15:59Z'),
('data_version','0.29.0','2026-09-02T03:15:59Z'),
('schema_version','40','2026-09-02T03:15:59Z'),
('generated_at','2026-09-02T03:15:59Z','2026-09-02T03:15:59Z'),
('project_status','v0.29.0 sealed staged checkpoint: reader state stays on-device and offline artifacts preserve public evidence and permission boundaries','2026-09-02T03:15:59Z')
ON CONFLICT(key) DO UPDATE SET value=excluded.value,updated_at=excluded.updated_at;

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(40,'20260902_v0290_reader_offline_archive_release','2026-09-02T03:15:59Z');

COMMIT;
