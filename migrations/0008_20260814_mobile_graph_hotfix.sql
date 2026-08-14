-- v0.5.1 presentation hotfix; mythology claims and evidence are unchanged.
BEGIN IMMEDIATE;

UPDATE project_metadata
SET value = '0.5.1-mobile-graph-hotfix-20260814',
    updated_at = '2026-08-14T04:23:36Z'
WHERE key = 'data_version';

UPDATE project_metadata
SET value = '2026-08-14T04:23:36Z',
    updated_at = '2026-08-14T04:23:36Z'
WHERE key = 'generated_at';

INSERT OR IGNORE INTO dataset_releases(
  id, schema_version, data_version, git_commit, built_at,
  database_sha256, release_notes
) VALUES (
  'release.0.5.1',
  7,
  '0.5.1-mobile-graph-hotfix-20260814',
  NULL,
  '2026-08-14T04:23:36Z',
  NULL,
  'Mobile graph presentation hotfix: dedicated 390px SVG layout, target-relative genealogy labels, selected-entity centering, safe-area spacing, and responsive regression coverage. Mythology claims, evidence and sources are unchanged from v0.5.0.'
);

INSERT INTO schema_migrations(version, name, applied_at)
VALUES (
  8,
  '20260814_v051_mobile_graph_hotfix',
  '2026-08-14T04:23:36Z'
);

COMMIT;
