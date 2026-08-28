BEGIN IMMEDIATE;
INSERT OR IGNORE INTO myth_event_profiles(entity_id,event_type,time_layer,cause_summary,process_summary,result_summary,symbolism_summary) VALUES
('event.ugaritic.baal_mot_ktu15_16','TEXT_WITNESSED_MYTHIC_SEQUENCE','Late Bronze Age Ugaritic tablet narrative','Conflict between Baal and Mot in the registered corpus synopsis.','KTU 1.5 and 1.6 preserve fragmentary phases involving Baal, Mot and Anat.','Baal returns within the narrative sequence; the record does not assert that death permanently ceased to exist.','Interpretive symbolism remains edition- and scholar-specific.');
UPDATE project_metadata SET value='28',updated_at='2026-08-27T13:05:00Z' WHERE key='schema_version';
UPDATE dataset_releases SET schema_version=28 WHERE id='release.0.20.0';
INSERT INTO schema_migrations(version,name,applied_at) VALUES(28,'20260827_v0200_event_profile_fix','2026-08-27T13:05:00Z');
COMMIT;
