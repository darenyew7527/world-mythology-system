BEGIN IMMEDIATE;

INSERT OR IGNORE INTO entity_redirects(duplicate_entity_id,canonical_entity_id,resolution_basis,resolved_at) VALUES
('concept.chinese.wuxing.shui','element.chinese.shui','Duplicate created in migration 2; identical native system member and original name already existed in the baseline.','2026-08-11T03:22:00Z'),
('concept.chinese.wuxing.huo','element.chinese.huo','Duplicate created in migration 2; identical native system member and original name already existed in the baseline.','2026-08-11T03:22:00Z'),
('concept.chinese.wuxing.mu','element.chinese.mu','Duplicate created in migration 2; identical native system member and original name already existed in the baseline.','2026-08-11T03:22:00Z'),
('concept.chinese.wuxing.jin','element.chinese.jin','Duplicate created in migration 2; identical native system member and original name already existed in the baseline.','2026-08-11T03:22:00Z'),
('concept.chinese.wuxing.tu','element.chinese.tu','Duplicate created in migration 2; identical native system member and original name already existed in the baseline.','2026-08-11T03:22:00Z');

UPDATE claims SET subject_id=CASE subject_id
 WHEN 'concept.chinese.wuxing.shui' THEN 'element.chinese.shui'
 WHEN 'concept.chinese.wuxing.huo' THEN 'element.chinese.huo'
 WHEN 'concept.chinese.wuxing.mu' THEN 'element.chinese.mu'
 WHEN 'concept.chinese.wuxing.jin' THEN 'element.chinese.jin'
 WHEN 'concept.chinese.wuxing.tu' THEN 'element.chinese.tu'
 ELSE subject_id END
WHERE subject_id IN ('concept.chinese.wuxing.shui','concept.chinese.wuxing.huo','concept.chinese.wuxing.mu','concept.chinese.wuxing.jin','concept.chinese.wuxing.tu');

UPDATE names SET source_id='source.china.hong_fan.ctext',notes=COALESCE(notes,'') ||
 CASE WHEN COALESCE(notes,'')='' THEN 'Attested in Hong Fan digital edition.' ELSE ' Attested in Hong Fan digital edition.' END
WHERE id IN ('name.element.chinese.shui.original','name.element.chinese.huo.original','name.element.chinese.mu.original','name.element.chinese.jin.original','name.element.chinese.tu.original');

UPDATE entities SET
 description=CASE id
   WHEN 'element.chinese.shui' THEN 'Water as a native member of the wuxing system; Hong Fan describes it as moistening and descending.'
   WHEN 'element.chinese.huo' THEN 'Fire as a native member of the wuxing system; Hong Fan describes it as blazing and rising.'
   WHEN 'element.chinese.mu' THEN 'Wood as a native member of the wuxing system; Hong Fan describes it through bending and straightening.'
   WHEN 'element.chinese.jin' THEN 'Metal as a native member of the wuxing system; Hong Fan describes it through yielding and change.'
   WHEN 'element.chinese.tu' THEN 'Earth/soil as a native member of the wuxing system; Hong Fan describes it through sowing and gathering.'
 END,
 research_status='PARTIAL',evidence_status='PARTIAL',record_version=record_version+1,
 metadata_json='{"native_system":"concept.chinese.wuxing","dedup_checkpoint":"2026-08-11"}',
 updated_at='2026-08-11T03:22:00Z'
WHERE id IN ('element.chinese.shui','element.chinese.huo','element.chinese.mu','element.chinese.jin','element.chinese.tu');

UPDATE entities SET description='Redirect-only duplicate identifier created during expansion migration 2; use entity_redirects canonical target.',
 research_status='EXPAND_LATER',metadata_json='{"redirect_only":true,"reason":"migration_2_duplicate"}',
 updated_at='2026-08-11T03:22:00Z'
WHERE id IN ('concept.chinese.wuxing.shui','concept.chinese.wuxing.huo','concept.chinese.wuxing.mu','concept.chinese.wuxing.jin','concept.chinese.wuxing.tu');

UPDATE research_sessions SET notes=notes || ' Dedup audit redirected five migration-2 wuxing component IDs to pre-existing baseline canonical IDs; claims and evidence now resolve to the originals.'
WHERE id='research.20260811.expansion1';

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(4,'20260811_wuxing_duplicate_redirects','2026-08-11T03:22:00Z');

COMMIT;
