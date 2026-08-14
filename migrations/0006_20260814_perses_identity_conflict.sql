BEGIN IMMEDIATE;

-- A homonym risk is not merely a future task: expose it in the conflict
-- ledger now so downstream clients cannot mistake the current canonical
-- record for every Greek figure named Perses.
INSERT OR IGNORE INTO conflicts(
  id,subject_id,variant_group,claim_a_id,claim_b_id,conflict_type,status,summary,resolution_notes
) VALUES(
  'conflict.greek.perses_homonym','deity.greek.perses','greek.perses_identity',
  'claim.v040.perses.parent_hecate',NULL,'IDENTITY_AMBIGUITY','OPEN',
  'Greek sources preserve more than one figure named Perses; the Hesiodic parent of Hecate must not be automatically merged with homonymous figures.',
  'Create witness-specific candidates and compare parentage, generation and narrative role before any identity resolution.'
);

UPDATE entities
SET evidence_status='CONFLICTING',updated_at='2026-08-14T00:00:00Z'
WHERE id='deity.greek.perses';

UPDATE project_metadata
SET value='6',updated_at='2026-08-14T00:00:00Z'
WHERE key='schema_version';

UPDATE dataset_releases
SET schema_version=6
WHERE id='release.0.4.0';

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(6,'20260814_expose_perses_identity_conflict','2026-08-14T00:00:00Z');

COMMIT;
