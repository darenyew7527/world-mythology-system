BEGIN IMMEDIATE;

INSERT OR IGNORE INTO names(id,entity_id,name_text,normalized_text,language_id,script_name,name_type,transliteration_scheme,is_preferred,source_id,notes) VALUES
('name.typhon_battle.en','event.greek.zeus_typhon_battle','Battle of Zeus and Typhon','battle of zeus and typhon','lang.en','Latin','TRANSLATION',NULL,1,'source.greek.theogony.perseus_eng1','Reading label for the event record'),
('name.tartarus.grc','realm.greek.tartarus','Τάρταρος','τάρταρος','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.theogony.perseus_eng1',NULL),
('name.norse_forging.en','event.norse.forging_divine_treasures','Forging of the divine treasures','forging of the divine treasures','lang.en','Latin','TRANSLATION',NULL,1,'source.norse.skaldskaparmal.vsnr1998','Reading label for the event record');

INSERT OR IGNORE INTO artifact_profiles(entity_id,artifact_type,material_json,appearance_json,abilities_json,limitations_json,usage_conditions_json,creation_summary,fate_summary) VALUES
('creature.norse.gullinbursti','CRAFTED_DIVINE_BEAST','["golden bristles"]','{"form":"boar","bristles":"golden"}','["shines in darkness"]','[]','[]','Produced during the treasure-forging contest in Skáldskaparmál',NULL);

INSERT OR IGNORE INTO place_profiles(entity_id,place_type,ancient_name,modern_name,country_code,latitude,longitude,date_range,builders,architecture_summary,excavation_summary,major_finds_summary,unesco_status,reality_status,evidence_grade) VALUES
('realm.greek.tartarus','MYTHICAL_REALM','Τάρταρος',NULL,NULL,NULL,NULL,'Mythic time',NULL,NULL,NULL,NULL,NULL,'MYTHICAL','TEXTUAL'),
('place.norse.mimisbrunnr','MYTHICAL_WELL','Mímisbrunnr',NULL,NULL,NULL,NULL,'Mythic time',NULL,NULL,NULL,NULL,NULL,'MYTHICAL','TEXTUAL');

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(3,'20260811_profile_repairs_after_validation','2026-08-11T03:05:26Z');

COMMIT;
