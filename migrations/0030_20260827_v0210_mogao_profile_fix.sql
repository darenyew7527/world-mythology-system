BEGIN IMMEDIATE;
INSERT OR IGNORE INTO place_profiles(entity_id,place_type,ancient_name,modern_name,country_code,latitude,longitude,date_range,builders,architecture_summary,excavation_summary,major_finds_summary,unesco_status,reality_status,evidence_grade) VALUES
('site.chinese.mogao_cave_249','CAVE_TEMPLE_COMPONENT','莫高窟第249窟','Mogao Cave 249','CN',NULL,NULL,'Western Wei',NULL,'Individual rock-cut cave within the Mogao complex',NULL,'Official Dunhuang Academy public context identifies a thunder-deity mural','Part of Mogao Caves, World Heritage property 440','REAL_ARCHAEOLOGICAL','OFFICIAL_SITE');
UPDATE project_metadata SET value='30',updated_at='2026-08-27T14:05:00Z' WHERE key='schema_version';
UPDATE dataset_releases SET schema_version=30 WHERE id='release.0.21.0';
INSERT INTO schema_migrations(version,name,applied_at) VALUES(30,'20260827_v0210_mogao_profile_fix','2026-08-27T14:05:00Z');
COMMIT;
