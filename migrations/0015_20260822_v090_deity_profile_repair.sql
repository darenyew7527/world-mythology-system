PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE;

INSERT OR IGNORE INTO deity_profiles(entity_id,deity_class,pantheon_or_family,rank_or_status,domains_json,powers_json,limitations_json,appearance_json,symbols_json,cult_summary,final_fate_summary) VALUES
('deity.greek.crius','TITAN','Hesiodic genealogy','Titan','[]','[]','["Profile limited to current genealogy witnesses"]','{}','[]',NULL,NULL),
('deity.greek.eurybia','TITAN_FAMILY','Hesiodic genealogy','Divine figure','[]','[]','["Profile limited to current genealogy witnesses"]','{}','[]',NULL,NULL),
('deity.greek.astraeus','TITAN_FAMILY','Hesiodic genealogy','Divine figure','[]','[]','["Profile limited to current genealogy witnesses"]','{}','[]',NULL,NULL),
('deity.greek.pallas_titan','TITAN','Hesiodic genealogy','Titan','[]','[]','["Must not be merged with other figures named Pallas"]','{}','[]',NULL,NULL),
('deity.greek.perses_helios','DIVINE_KING','Diodoran Colchian/Tauric genealogy','King in an ancient narrative','[]','[]','["Must not be merged with the Titan or Perseus-son homonyms"]','{}','[]',NULL,'Killed by Medea in Pseudo-Apollodorus Library 1.9.28');

UPDATE dataset_releases SET schema_version=15 WHERE id='release.0.9.0';
INSERT INTO schema_migrations(version,name,applied_at) VALUES
(15,'20260822_v090_deity_profile_repair','2026-08-22T06:20:00Z');

COMMIT;
