BEGIN IMMEDIATE;

-- v0.9.0 resolves the current Perses ambiguity by separating three ancient
-- figures with different parents and narrative roles. No name-only redirect is created.

INSERT OR IGNORE INTO sources(
  id,title,original_title,source_type,evidence_tier,institution,author_or_editor,
  language_id,publication_date,accessed_date,url,stable_url,doi,isbn,
  catalogue_number,manuscript_number,rights_status,source_perspective,
  community_or_lineage,collector_context,living_tradition,
  access_or_reuse_restrictions,community_permission_required,
  same_witness_as_source_id,translation_status,verification_status,notes
) VALUES
('source.greek.apollodorus.library.topostext','Pseudo-Apollodorus, Library','Βιβλιοθήκη','ANCIENT_TEXT',1,'ToposText / Aikaterini Laskaridis Foundation','James George Frazer, translator','lang.en','1921','2026-08-22','https://topostext.org/work/150','urn:cts:greekLit:tlg0548.tlg001',NULL,NULL,'Library 1.2.2-1.2.4; 1.9.1; 1.9.28',NULL,'Ancient work and 1921 translation are public domain; ToposText presentation terms apply','Ancient mythographic compilation in a modern tagged digital presentation',NULL,NULL,0,'Store section locators and independent summaries; do not bulk reproduce the digital presentation',0,NULL,'English public-domain translation with linked Greek text','URL_SYNTAX_VALID','Separately witnesses Crius-Eurybia-Perses-Hecate genealogy and a Colchian Perses who deposes Aeetes and is killed by Medea.'),
('source.greek.diodorus.library4.uchicago','Diodorus Siculus, Library of History, Book 4.45.1','Βιβλιοθήκη Ἱστορική','ANCIENT_TEXT',1,'University of Chicago LacusCurtius','C. H. Oldfather, translator','lang.en','1935','2026-08-22','https://penelope.uchicago.edu/thayer/e/roman/texts/diodorus_siculus/4c%2A.html',NULL,NULL,NULL,'Book 4.45.1',NULL,'Ancient work and registered translation are public domain; site presentation terms apply','Ancient historiographic mythography in an academic digital edition',NULL,NULL,0,'Retain section locator and independent summary; no extended reproduction',0,NULL,'English public-domain translation','URL_SYNTAX_VALID','Section 4.45.1 names Helios as father of Aeetes and Perses and assigns the brothers separate kingdoms.'),
('source.greek.herodotus.histories.scaife','Herodotus, Histories, Greek text','Ἱστορίαι','ANCIENT_TEXT',1,'Perseus Digital Library / Scaife Viewer','Karl Hude, Greek edition','lang.grc','1927','2026-08-22','https://scaife.perseus.org/reader/urn%3Acts%3AgreekLit%3Atlg0016.tlg001.perseus-grc2%3A7.61/','urn:cts:greekLit:tlg0016.tlg001.perseus-grc2:7.61',NULL,NULL,'Histories 7.61',NULL,'Ancient text is public domain; Scaife presentation terms apply','Ancient Greek historiography, source-language witness',NULL,NULL,0,'Store CTS locator and independent summary; do not bulk reproduce',0,NULL,'Ancient Greek edition','URL_SYNTAX_VALID','Section 7.61 presents Perses, son of Perseus and Andromeda, in an aetiological story about the Persian name.'),
('source.greek.herodotus.histories.uchicago','Herodotus, Histories, Book 7.61','Ἱστορίαι','SCHOLARLY_DIGITAL_TEXT',2,'University of Chicago LacusCurtius','A. D. Godley, translator','lang.en','1920','2026-08-22','https://penelope.uchicago.edu/Thayer/E/Roman/Texts/Herodotus/7b%2A.html',NULL,NULL,NULL,'Histories 7.61',NULL,'Ancient work and 1920 translation are public domain; site presentation terms apply','Academic digital translation paired with the source-language record',NULL,NULL,0,'Store section locator and independent summary; no extended reproduction',0,NULL,'English public-domain translation','URL_SYNTAX_VALID','Translation access point for the Perses son of Perseus and Andromeda passage and its Persian-name aition.');

INSERT OR IGNORE INTO entities(
  id,canonical_name,name_zh,original_name,transliteration,primary_type,
  primary_civilization_id,primary_region_id,historical_period,description,
  research_status,evidence_status,record_version,metadata_json,created_at,updated_at
) VALUES
('deity.greek.crius','Crius','克利俄斯','Κρεῖος','Kreios','DEITY','civ.greek','region.mediterranean','Archaic Greek genealogical tradition','赫西俄德与《书库》谱系中的提坦神，与欧律比亚生下阿斯特赖俄斯、帕拉斯和提坦珀耳塞斯。 / Titan in Hesiodic and Library genealogies, parent with Eurybia of Astraeus, Pallas and the Titan Perses.','PARTIAL','UNVERIFIED',1,'{}','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('deity.greek.eurybia','Eurybia','欧律比亚','Εὐρυβία','Eurybia','DEITY','civ.greek','region.mediterranean','Archaic Greek genealogical tradition','与克利俄斯生下阿斯特赖俄斯、帕拉斯和提坦珀耳塞斯的女神；与其他同名人物分开。 / Goddess paired with Crius in the genealogy of Astraeus, Pallas and the Titan Perses.','PARTIAL','UNVERIFIED',1,'{}','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('deity.greek.astraeus','Astraeus','阿斯特赖俄斯','Ἀστραῖος','Astraios','DEITY','civ.greek','region.mediterranean','Archaic Greek genealogical tradition','克利俄斯与欧律比亚之子，提坦珀耳塞斯和帕拉斯的兄弟。 / Son of Crius and Eurybia, brother of the Titan Perses and Pallas.','PARTIAL','UNVERIFIED',1,'{}','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('deity.greek.pallas_titan','Pallas (Titan)','帕拉斯（提坦）','Πάλλας','Pallas','DEITY','civ.greek','region.mediterranean','Archaic Greek genealogical tradition','克利俄斯与欧律比亚之子；以限定 ID 与其他名为帕拉斯的神话人物分开。 / Son of Crius and Eurybia; scoped ID prevents merger with other figures named Pallas.','PARTIAL','UNVERIFIED',1,'{"homonym_scope":"Titan son of Crius and Eurybia"}','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('deity.greek.perses_helios','Perses (son of Helios)','珀耳塞斯（赫利俄斯之子）','Πέρσης','Perses','DEITY','civ.greek','region.mediterranean','Diodoran and later Colchian mythography','狄奥多罗斯与《书库》科尔喀斯叙事中的珀耳塞斯，赫利俄斯之子、埃厄忒斯之兄弟；不是赫卡忒之父。 / Colchian Perses, son of Helios and brother of Aeetes; not the father of Hecate.','PARTIAL','UNVERIFIED',1,'{"homonym_scope":"Colchian/Tauric son of Helios"}','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('hero.greek.aeetes','Aeetes','埃厄忒斯','Αἰήτης','Aietes','HERO','civ.greek','region.mediterranean','Argonautic mythography','科尔喀斯神话国王、赫利俄斯之子；本批仅建立与同名审计直接有关的兄弟和王位叙事。 / Mythic king of Colchis and son of Helios; current scope is limited to the Perses identity audit.','PARTIAL','UNVERIFIED',1,'{"role":"mythic king"}','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('hero.greek.medea','Medea','美狄亚','Μήδεια','Medeia','HERO','civ.greek','region.mediterranean','Argonautic and later Greek mythography','埃厄忒斯之女；《书库》叙事中杀死夺位的珀耳塞斯并恢复父亲王位。 / Daughter of Aeetes who in the Library kills the usurping Perses and restores her father.','PARTIAL','UNVERIFIED',1,'{}','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('hero.greek.perses_perseus_son','Perses (son of Perseus)','珀耳塞斯（珀耳修斯之子）','Πέρσης','Perses','HERO','civ.greek','region.mediterranean','Herodotean genealogical aition','希罗多德7.61中的珀耳修斯与安德洛墨达之子，用于解释“波斯人”名称；不是两位同名神祇。 / Son of Perseus and Andromeda in Herodotus 7.61, used in a Persian-name aition; distinct from the homonymous gods.','PARTIAL','UNVERIFIED',1,'{"homonym_scope":"Herodotean son of Perseus and Andromeda"}','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('hero.greek.perseus','Perseus','珀耳修斯','Περσεύς','Perseus','HERO','civ.greek','region.mediterranean','Archaic and Classical Greek heroic tradition','本批仅建立希罗多德7.61所需的父系关系入口；完整英雄事迹仍在队列扩张。 / Current baseline supports the Herodotean parentage claim; the broader heroic dossier remains queued.','PARTIAL','UNVERIFIED',1,'{}','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('hero.greek.andromeda','Andromeda','安德洛墨达','Ἀνδρομέδα','Andromeda','HERO','civ.greek','region.mediterranean','Archaic and Classical Greek heroic tradition','本批仅建立希罗多德7.61所需的母系关系入口；其他版本继续扩张。 / Current baseline supports the Herodotean parentage claim; other narrative versions remain open.','PARTIAL','UNVERIFIED',1,'{}','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('event.greek.medea_restores_aeetes','Medea restores Aeetes','美狄亚恢复埃厄忒斯王位',NULL,NULL,'EVENT','civ.greek','region.mediterranean','Pseudo-Apollodorus Library 1.9.28','《书库》中美狄亚回到科尔喀斯、杀死夺位者珀耳塞斯并恢复埃厄忒斯王位的神话事件。 / Mythic event in which Medea kills the usurping Perses and restores Aeetes.','PARTIAL','UNVERIFIED',1,'{"reality_status":"MYTHIC_NARRATIVE"}','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('concept.greek.persian_name_aition','Greek aition of the Persian name','希腊传统中的“波斯人”名称缘起',NULL,NULL,'CONCEPT','civ.greek','region.mediterranean','Herodotus 7.61','希罗多德所载将波斯族名连接到珀耳修斯之子珀耳塞斯的希腊解释性叙事；不作为现代语言学事实。 / Herodotean Greek explanatory story linking the Persian ethnonym to Perses; not a modern linguistic claim.','PARTIAL','UNVERIFIED',1,'{"scope":"ancient Greek aetiological narrative","not":"modern etymology"}','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('text.greek.apollodorus_library','Pseudo-Apollodorus, Library','伪阿波罗多洛斯《书库》','Βιβλιοθήκη','Bibliotheke','TEXT','civ.greek','region.mediterranean','Imperial-period Greek mythographic compilation','保存多组希腊神话谱系与叙事的古代编纂文本；传统作者归属不当作确定事实。 / Ancient mythographic compilation; traditional attribution is retained without treating authorship as certain.','PARTIAL','UNVERIFIED',1,'{"attribution":"Pseudo-Apollodorus"}','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('text.greek.diodorus_library','Diodorus Siculus, Library of History','狄奥多罗斯《历史文库》','Βιβλιοθήκη Ἱστορική','Bibliotheke Historike','TEXT','civ.greek','region.mediterranean','First century BCE','本批登记第四卷45.1的珀耳塞斯—埃厄忒斯谱系与王权叙事。 / Current scope registers Book 4.45.1 for the Perses-Aeetes genealogy and kingship narrative.','PARTIAL','UNVERIFIED',1,'{}','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('text.greek.herodotus_histories','Herodotus, Histories','希罗多德《历史》','Ἱστορίαι','Historiai','TEXT','civ.greek','region.mediterranean','Fifth century BCE composition tradition','本批登记第7卷61节的珀耳塞斯及波斯族名缘起叙事。 / Current scope registers 7.61 for Perses and the Persian-name aition.','PARTIAL','UNVERIFIED',1,'{}','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z');

UPDATE entities SET canonical_name='Perses (Titan)',name_zh='珀耳塞斯（提坦）',original_name='Πέρσης',transliteration='Perses',
  description='赫西俄德与《书库》中克利俄斯、欧律比亚之子，阿斯特赖俄斯与帕拉斯之兄弟，阿斯忒里亚的配偶及赫卡忒之父。 / Titan son of Crius and Eurybia, brother of Astraeus and Pallas, consort of Asteria and father of Hecate.',
  research_status='PARTIAL',evidence_status='PARTIAL',record_version=record_version+1,
  metadata_json='{"homonym_scope":"Titan son of Crius and Eurybia; father of Hecate","dedup_rule":"do not merge by name","identity_caution":"Ancient Greek sources contain more than one figure named Perses."}',
  updated_at='2026-08-22T00:00:00Z' WHERE id='deity.greek.perses';

INSERT OR IGNORE INTO entity_classifications(entity_id,type_code,is_primary,notes)
SELECT id,primary_type,1,'v0.9.0 Perses homonym audit checkpoint' FROM entities WHERE created_at='2026-08-22T00:00:00Z';
INSERT OR IGNORE INTO entity_civilizations(entity_id,civilization_id,association_role,certainty,notes)
SELECT id,'civ.greek','ORIGIN','SUPPORTED','v0.9.0 source-located Greek baseline' FROM entities WHERE created_at='2026-08-22T00:00:00Z';

INSERT OR IGNORE INTO deity_profiles(entity_id,deity_class,pantheon_or_family,rank_or_status,domains_json,powers_json,limitations_json,appearance_json,symbols_json,cult_summary,final_fate_summary) VALUES
('deity.greek.crius','TITAN','Hesiodic genealogy','Titan','[]','[]','["Profile limited to current genealogy witnesses"]','{}','[]',NULL,NULL),
('deity.greek.eurybia','TITAN_FAMILY','Hesiodic genealogy','Divine figure','[]','[]','["Profile limited to current genealogy witnesses"]','{}','[]',NULL,NULL),
('deity.greek.astraeus','TITAN_FAMILY','Hesiodic genealogy','Divine figure','[]','[]','["Profile limited to current genealogy witnesses"]','{}','[]',NULL,NULL),
('deity.greek.pallas_titan','TITAN','Hesiodic genealogy','Titan','[]','[]','["Must not be merged with other figures named Pallas"]','{}','[]',NULL,NULL),
('deity.greek.perses_helios','DIVINE_KING','Diodoran Colchian/Tauric genealogy','King in an ancient narrative','[]','[]','["Must not be merged with the Titan or Perseus-son homonyms"]','{}','[]',NULL,'Killed by Medea in Pseudo-Apollodorus Library 1.9.28');

INSERT OR IGNORE INTO names(id,entity_id,name_text,normalized_text,language_id,script_name,name_type,is_preferred,source_id,notes) VALUES
('name.v090.perses_titan.en','deity.greek.perses','Perses (Titan)','perses titan','lang.en','Latin','PREFERRED',1,'source.greek.theogony.scaife','Scoped display name; ancient text has Perses.'),
('name.v090.perses_titan.grc','deity.greek.perses','Πέρσης','περσης','lang.grc','Greek','ORIGINAL',1,'source.greek.theogony.scaife',NULL),
('name.v090.perses_titan.zh','deity.greek.perses','珀耳塞斯（提坦）','珀耳塞斯 提坦','lang.zh','Han','TRANSLATION',1,NULL,NULL),
('name.v090.crius.en','deity.greek.crius','Crius','crius','lang.en','Latin','PREFERRED',1,'source.greek.theogony.scaife',NULL),
('name.v090.crius.grc','deity.greek.crius','Κρεῖος','κρειος','lang.grc','Greek','ORIGINAL',1,'source.greek.theogony.scaife',NULL),
('name.v090.eurybia.en','deity.greek.eurybia','Eurybia','eurybia','lang.en','Latin','PREFERRED',1,'source.greek.theogony.scaife',NULL),
('name.v090.eurybia.grc','deity.greek.eurybia','Εὐρυβία','ευρυβια','lang.grc','Greek','ORIGINAL',1,'source.greek.theogony.scaife',NULL),
('name.v090.astraeus.en','deity.greek.astraeus','Astraeus','astraeus','lang.en','Latin','PREFERRED',1,'source.greek.theogony.scaife',NULL),
('name.v090.astraeus.grc','deity.greek.astraeus','Ἀστραῖος','αστραιος','lang.grc','Greek','ORIGINAL',1,'source.greek.theogony.scaife',NULL),
('name.v090.pallas.en','deity.greek.pallas_titan','Pallas (Titan)','pallas titan','lang.en','Latin','PREFERRED',1,'source.greek.theogony.scaife',NULL),
('name.v090.pallas.grc','deity.greek.pallas_titan','Πάλλας','παλλας','lang.grc','Greek','ORIGINAL',1,'source.greek.theogony.scaife',NULL),
('name.v090.perses_helios.en','deity.greek.perses_helios','Perses (son of Helios)','perses son helios','lang.en','Latin','PREFERRED',1,'source.greek.diodorus.library4.uchicago',NULL),
('name.v090.perses_helios.grc','deity.greek.perses_helios','Πέρσης','περσης','lang.grc','Greek','ORIGINAL',1,NULL,'Shared spelling is not identity evidence.'),
('name.v090.aeetes.en','hero.greek.aeetes','Aeetes','aeetes','lang.en','Latin','PREFERRED',1,'source.greek.diodorus.library4.uchicago',NULL),
('name.v090.aeetes.grc','hero.greek.aeetes','Αἰήτης','αιητης','lang.grc','Greek','ORIGINAL',1,NULL,NULL),
('name.v090.medea.en','hero.greek.medea','Medea','medea','lang.en','Latin','PREFERRED',1,'source.greek.apollodorus.library.topostext',NULL),
('name.v090.medea.grc','hero.greek.medea','Μήδεια','μηδεια','lang.grc','Greek','ORIGINAL',1,NULL,NULL),
('name.v090.perses_perseus.en','hero.greek.perses_perseus_son','Perses (son of Perseus)','perses son perseus','lang.en','Latin','PREFERRED',1,'source.greek.herodotus.histories.uchicago',NULL),
('name.v090.perses_perseus.grc','hero.greek.perses_perseus_son','Πέρσης','περσης','lang.grc','Greek','ORIGINAL',1,'source.greek.herodotus.histories.scaife','Shared spelling is not identity evidence.'),
('name.v090.perseus.en','hero.greek.perseus','Perseus','perseus','lang.en','Latin','PREFERRED',1,'source.greek.herodotus.histories.uchicago',NULL),
('name.v090.perseus.grc','hero.greek.perseus','Περσεύς','περσευς','lang.grc','Greek','ORIGINAL',1,'source.greek.herodotus.histories.scaife',NULL),
('name.v090.andromeda.en','hero.greek.andromeda','Andromeda','andromeda','lang.en','Latin','PREFERRED',1,'source.greek.herodotus.histories.uchicago',NULL),
('name.v090.andromeda.grc','hero.greek.andromeda','Ἀνδρομέδα','ανδρομεδα','lang.grc','Greek','ORIGINAL',1,'source.greek.herodotus.histories.scaife',NULL),
('name.v090.event.en','event.greek.medea_restores_aeetes','Medea restores Aeetes','medea restores aeetes','lang.en','Latin','PREFERRED',1,'source.greek.apollodorus.library.topostext',NULL),
('name.v090.aition.en','concept.greek.persian_name_aition','Greek aition of the Persian name','greek aition persian name','lang.en','Latin','PREFERRED',1,'source.greek.herodotus.histories.uchicago',NULL),
('name.v090.apollodorus.en','text.greek.apollodorus_library','Pseudo-Apollodorus, Library','pseudo apollodorus library','lang.en','Latin','PREFERRED',1,'source.greek.apollodorus.library.topostext',NULL),
('name.v090.diodorus.en','text.greek.diodorus_library','Diodorus Siculus, Library of History','diodorus siculus library history','lang.en','Latin','PREFERRED',1,'source.greek.diodorus.library4.uchicago',NULL),
('name.v090.herodotus.en','text.greek.herodotus_histories','Herodotus, Histories','herodotus histories','lang.en','Latin','PREFERRED',1,'source.greek.herodotus.histories.uchicago',NULL);

INSERT OR IGNORE INTO text_profiles(entity_id,text_type,original_language_id,attributed_author,composition_period,chapter_structure,copyright_status,summary) VALUES
('text.greek.apollodorus_library','MYTHOGRAPHIC_COMPILATION','lang.grc','Pseudo-Apollodorus','Commonly dated to the first or second century CE','Books and numbered sections','Ancient text public domain; digital editions retain presentation terms','Genealogical and narrative compendium with separate Perses contexts.'),
('text.greek.diodorus_library','HISTORIOGRAPHY','lang.grc','Diodorus Siculus','First century BCE','Books and numbered sections','Ancient text public domain; modern editions retain presentation terms','Book 4 includes an Argonautic excursus naming Helios, Aeetes and Perses.'),
('text.greek.herodotus_histories','HISTORIOGRAPHY','lang.grc','Herodotus','Fifth century BCE','Nine books and numbered sections','Ancient text public domain; digital editions retain presentation terms','Book 7.61 contains a Greek aition connecting Perses to the Persian name.');

INSERT OR IGNORE INTO myth_event_profiles(entity_id,event_type,time_layer,cause_summary,process_summary,result_summary,symbolism_summary) VALUES
('event.greek.medea_restores_aeetes','DYNASTIC_RESTORATION','Pseudo-Apollodorus Library 1.9.28','Perses has deposed his brother Aeetes in the Library narrative.','Medea returns to Colchis and kills the usurping Perses.','Aeetes is restored to the kingdom.','Registered as narrative sequence, not historical reconstruction.');

INSERT OR IGNORE INTO claims(
 id,subject_id,predicate,object_entity_id,object_literal,object_datatype,statement,variant_group,
 claim_status,confidence,confidence_level,review_status,assertion_scope,knowledge_layer,
 tradition_scope,temporal_scope,research_notes,created_at
) VALUES
('claim.v090.crius_parent_perses','deity.greek.crius','PARENT_OF','deity.greek.perses',NULL,NULL,'Theogony 375-377 and Library 1.2.2 make Crius a parent of the Titan Perses.','greek.perses.titan.genealogy','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic and mythographic genealogy','Theogony 375-377; Library 1.2.2','Two ancient textual access points corroborate the scoped identity.','2026-08-22T00:00:00Z'),
('claim.v090.eurybia_parent_perses','deity.greek.eurybia','PARENT_OF','deity.greek.perses',NULL,NULL,'Theogony 375-377 and Library 1.2.2 make Eurybia a parent of the Titan Perses.','greek.perses.titan.genealogy','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic and mythographic genealogy','Theogony 375-377; Library 1.2.2',NULL,'2026-08-22T00:00:00Z'),
('claim.v090.crius_parent_astraeus','deity.greek.crius','PARENT_OF','deity.greek.astraeus',NULL,NULL,'Theogony 375-377 names Astraeus among the children of Crius and Eurybia.','greek.crius.eurybia.children','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic genealogy','Theogony 375-377',NULL,'2026-08-22T00:00:00Z'),
('claim.v090.eurybia_parent_astraeus','deity.greek.eurybia','PARENT_OF','deity.greek.astraeus',NULL,NULL,'Theogony 375-377 names Astraeus among the children of Crius and Eurybia.','greek.crius.eurybia.children','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic genealogy','Theogony 375-377',NULL,'2026-08-22T00:00:00Z'),
('claim.v090.crius_parent_pallas','deity.greek.crius','PARENT_OF','deity.greek.pallas_titan',NULL,NULL,'Theogony 375-377 names Pallas among the children of Crius and Eurybia.','greek.crius.eurybia.children','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic genealogy','Theogony 375-377','The Titan scope prevents merger with other Pallas figures.','2026-08-22T00:00:00Z'),
('claim.v090.eurybia_parent_pallas','deity.greek.eurybia','PARENT_OF','deity.greek.pallas_titan',NULL,NULL,'Theogony 375-377 names Pallas among the children of Crius and Eurybia.','greek.crius.eurybia.children','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic genealogy','Theogony 375-377','The Titan scope prevents merger with other Pallas figures.','2026-08-22T00:00:00Z'),
('claim.v090.perses_sibling_astraeus','deity.greek.perses','SIBLING_OF','deity.greek.astraeus',NULL,NULL,'Theogony 375-377 lists Perses and Astraeus as children of Crius and Eurybia.','greek.crius.eurybia.children','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic genealogy','Theogony 375-377',NULL,'2026-08-22T00:00:00Z'),
('claim.v090.perses_sibling_pallas','deity.greek.perses','SIBLING_OF','deity.greek.pallas_titan',NULL,NULL,'Theogony 375-377 lists Perses and Pallas as children of Crius and Eurybia.','greek.crius.eurybia.children','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic genealogy','Theogony 375-377',NULL,'2026-08-22T00:00:00Z'),
('claim.v090.perses_consort_asteria','deity.greek.perses','CONSORT_OF','deity.greek.asteria',NULL,NULL,'Theogony 404-410 says Asteria became the wife of this Perses and bore Hecate.','greek.perses.titan.genealogy','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic genealogy','Theogony 404-410','Context connects this Perses to the son of Crius and Eurybia.','2026-08-22T00:00:00Z'),
('claim.v090.perses_parent_hecate_apollodorus','deity.greek.perses','PARENT_OF','deity.greek.hecate',NULL,NULL,'Library 1.2.4 makes Hecate the child of Perses and Asteria.','greek.perses.titan.genealogy','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Pseudo-Apollodoran genealogy','Library 1.2.4','Corroborates the existing Hesiodic claim without replacing it.','2026-08-22T00:00:00Z'),
('claim.v090.perses_theogony','deity.greek.perses','MENTIONED_IN','text.greek.theogony',NULL,NULL,'The Titan Perses appears in the continuous genealogy at Theogony 375-410.','greek.perses.titan.witness','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Hesiodic genealogy','Theogony 375-410',NULL,'2026-08-22T00:00:00Z'),
('claim.v090.perses_apollodorus','deity.greek.perses','MENTIONED_IN','text.greek.apollodorus_library',NULL,NULL,'Library 1.2.2-1.2.4 presents Perses as son of Crius and Eurybia and father of Hecate.','greek.perses.titan.witness','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Pseudo-Apollodoran genealogy','Library 1.2.2-1.2.4',NULL,'2026-08-22T00:00:00Z'),
('claim.v090.helios_parent_perses','deity.greek.helios','PARENT_OF','deity.greek.perses_helios',NULL,NULL,'Diodorus 4.45.1 names Helios as father of a different Perses in the Colchian/Tauric narrative.','greek.perses.helios.genealogy','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Diodoran Argonautic genealogy','Library of History 4.45.1','Different father and narrative role establish a separate entity.','2026-08-22T00:00:00Z'),
('claim.v090.helios_parent_aeetes','deity.greek.helios','PARENT_OF','hero.greek.aeetes',NULL,NULL,'Diodorus 4.45.1 names Helios as father of Aeetes.','greek.perses.helios.genealogy','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Diodoran Argonautic genealogy','Library of History 4.45.1',NULL,'2026-08-22T00:00:00Z'),
('claim.v090.perses_helios_sibling_aeetes','deity.greek.perses_helios','SIBLING_OF','hero.greek.aeetes',NULL,NULL,'Diodorus 4.45.1 presents Aeetes and Perses as sons of Helios.','greek.perses.helios.genealogy','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Diodoran Argonautic genealogy','Library of History 4.45.1',NULL,'2026-08-22T00:00:00Z'),
('claim.v090.perses_rules_tauric','deity.greek.perses_helios','RULES',NULL,'Tauric Chersonese','text','Diodorus 4.45.1 assigns Perses kingship over the Tauric Chersonese.','greek.perses.helios.kingship','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Diodoran narrative','Library of History 4.45.1','Literal retained until the place dossier is source-located.','2026-08-22T00:00:00Z'),
('claim.v090.perses_deposed_aeetes','deity.greek.perses_helios','DEFEATED','hero.greek.aeetes',NULL,NULL,'Library 1.9.28 says Perses had deposed his brother Aeetes.','greek.perses.colchis.restoration','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Pseudo-Apollodoran narrative','Library 1.9.28','DEFEATED models dynastic displacement, not combat detail.','2026-08-22T00:00:00Z'),
('claim.v090.medea_killed_perses','hero.greek.medea','KILLED','deity.greek.perses_helios',NULL,NULL,'Library 1.9.28 says Medea killed the Perses who had deposed Aeetes.','greek.perses.colchis.restoration','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Pseudo-Apollodoran narrative','Library 1.9.28','The narrative context distinguishes this Perses from Hecate’s father.','2026-08-22T00:00:00Z'),
('claim.v090.medea_participated_restoration','hero.greek.medea','PARTICIPATED_IN','event.greek.medea_restores_aeetes',NULL,NULL,'Medea is the acting participant in the restoration sequence of Library 1.9.28.','greek.perses.colchis.restoration','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Pseudo-Apollodoran narrative','Library 1.9.28',NULL,'2026-08-22T00:00:00Z'),
('claim.v090.aeetes_participated_restoration','hero.greek.aeetes','PARTICIPATED_IN','event.greek.medea_restores_aeetes',NULL,NULL,'Aeetes is the restored king in the sequence of Library 1.9.28.','greek.perses.colchis.restoration','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Pseudo-Apollodoran narrative','Library 1.9.28',NULL,'2026-08-22T00:00:00Z'),
('claim.v090.perses_participated_restoration','deity.greek.perses_helios','PARTICIPATED_IN','event.greek.medea_restores_aeetes',NULL,NULL,'The Colchian Perses is the deposed and killed participant in Library 1.9.28.','greek.perses.colchis.restoration','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Pseudo-Apollodoran narrative','Library 1.9.28',NULL,'2026-08-22T00:00:00Z'),
('claim.v090.perses_helios_diodorus','deity.greek.perses_helios','MENTIONED_IN','text.greek.diodorus_library',NULL,NULL,'The Helios-son Perses appears at Diodorus 4.45.1.','greek.perses.helios.witness','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Diodoran narrative','Library of History 4.45.1',NULL,'2026-08-22T00:00:00Z'),
('claim.v090.perses_helios_apollodorus','deity.greek.perses_helios','MENTIONED_IN','text.greek.apollodorus_library',NULL,NULL,'The Colchian Perses appears as Aeetes’ brother in Library 1.9.28.','greek.perses.helios.witness','SUPPORTED',0.97,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Pseudo-Apollodoran narrative','Library 1.9.28','Cross-source identification is based on shared Aeetes sibling and kingship context.','2026-08-22T00:00:00Z'),
('claim.v090.perseus_parent_perses','hero.greek.perseus','PARENT_OF','hero.greek.perses_perseus_son',NULL,NULL,'Herodotus 7.61 makes Perseus the father of a human Perses in its aetiological genealogy.','greek.perses.herodotus.genealogy','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Herodotean aition','Histories 7.61','Not a modern historical genealogy claim.','2026-08-22T00:00:00Z'),
('claim.v090.andromeda_parent_perses','hero.greek.andromeda','PARENT_OF','hero.greek.perses_perseus_son',NULL,NULL,'Herodotus 7.61 makes Andromeda the mother of Perses.','greek.perses.herodotus.genealogy','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Herodotean aition','Histories 7.61','Not a modern historical genealogy claim.','2026-08-22T00:00:00Z'),
('claim.v090.perses_perseus_histories','hero.greek.perses_perseus_son','MENTIONED_IN','text.greek.herodotus_histories',NULL,NULL,'Perses, son of Perseus and Andromeda, appears in Herodotus 7.61.','greek.perses.herodotus.witness','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Herodotean aition','Histories 7.61',NULL,'2026-08-22T00:00:00Z'),
('claim.v090.perses_persian_aition','hero.greek.perses_perseus_son','ASSOCIATED_WITH','concept.greek.persian_name_aition',NULL,NULL,'Herodotus 7.61 connects Perses to an ancient Greek explanation of the Persian name.','greek.perses.herodotus.aition','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Herodotean aition','Histories 7.61','Stored as an ancient explanatory narrative, not accepted as modern etymology.','2026-08-22T00:00:00Z');

INSERT OR IGNORE INTO evidence(
 id,claim_id,source_id,source_location,chapter,verse,line,page,catalogue_number,
 short_quote,evidence_type,direction,strength,research_notes
)
SELECT 'evidence.'||substr(c.id,7),c.id,
 CASE
  WHEN c.id IN ('claim.v090.crius_parent_perses','claim.v090.eurybia_parent_perses','claim.v090.crius_parent_astraeus','claim.v090.eurybia_parent_astraeus','claim.v090.crius_parent_pallas','claim.v090.eurybia_parent_pallas','claim.v090.perses_sibling_astraeus','claim.v090.perses_sibling_pallas','claim.v090.perses_consort_asteria','claim.v090.perses_theogony') THEN 'source.greek.theogony.scaife'
  WHEN c.id IN ('claim.v090.helios_parent_perses','claim.v090.helios_parent_aeetes','claim.v090.perses_helios_sibling_aeetes','claim.v090.perses_rules_tauric','claim.v090.perses_helios_diodorus') THEN 'source.greek.diodorus.library4.uchicago'
  WHEN c.id IN ('claim.v090.perseus_parent_perses','claim.v090.andromeda_parent_perses','claim.v090.perses_perseus_histories','claim.v090.perses_persian_aition') THEN 'source.greek.herodotus.histories.scaife'
  ELSE 'source.greek.apollodorus.library.topostext'
 END,
 c.temporal_scope,NULL,NULL,
 CASE
  WHEN c.id LIKE '%herodotus%' OR c.id LIKE '%perseus_parent%' OR c.id LIKE '%andromeda_parent%' OR c.id LIKE '%persian_aition%' THEN NULL
  WHEN c.id LIKE '%diodorus%' OR c.id LIKE '%helios_parent%' OR c.id LIKE '%sibling_aeetes%' OR c.id LIKE '%rules_tauric%' THEN NULL
  ELSE NULL END,
 NULL,NULL,NULL,'ANCIENT_TEXT','SUPPORTS',c.confidence,
 'Section or line locator checked 2026-08-22; no extended translation is reproduced.'
FROM claims c WHERE c.id LIKE 'claim.v090.%';

INSERT OR IGNORE INTO identity_candidates(id,entity_a_id,entity_b_id,assessment,confidence,source_id,notes) VALUES
('identity.v090.perses_titan_vs_helios','deity.greek.perses','deity.greek.perses_helios','EXPLICITLY_DISTINCT',0.99,'source.greek.diodorus.library4.uchicago','Different parents, siblings, consort/child and narrative roles; identical Greek spelling is not identity evidence.'),
('identity.v090.perses_titan_vs_perseus_son','deity.greek.perses','hero.greek.perses_perseus_son','EXPLICITLY_DISTINCT',0.99,'source.greek.herodotus.histories.scaife','Titan genealogy and Herodotean heroic genealogy are separate source contexts.'),
('identity.v090.perses_helios_vs_perseus_son','deity.greek.perses_helios','hero.greek.perses_perseus_son','EXPLICITLY_DISTINCT',0.99,'source.greek.herodotus.histories.scaife','Helios-son Colchian king and Perseus-son aetiological figure have different parents and roles.');

UPDATE conflicts SET status='RESOLVED_AS_VARIANTS',
 summary='Three major figures named Perses are now stored separately: the Titan father of Hecate, the son of Helios in Colchian/Tauric mythography, and the son of Perseus and Andromeda in Herodotus.',
 resolution_notes='No redirects or alias merges were created. Three EXPLICITLY_DISTINCT identity assessments record the source-bounded separation; additional homonyms may still be discovered.'
WHERE id='conflict.greek.perses_homonym';

UPDATE collection_queue SET status='PARTIAL',attempts=attempts+1,last_error=NULL,
 next_action='Audit additional Perses/Persai spellings, manuscript variants, ancient scholia and later genealogies; preserve all three established entities',
 updated_at='2026-08-22T00:00:00Z' WHERE id='queue.greek.v040.perses_identity';
INSERT OR IGNORE INTO queue_status_history(id,queue_id,old_status,new_status,changed_at,reason) VALUES
('qhist.v090.perses_identity','queue.greek.v040.perses_identity','CONFLICT','PARTIAL','2026-08-22T00:00:00Z','Separated three ancient Perses entities with parentage, narrative-role and witness evidence; broader homonym audit remains open.');

INSERT OR IGNORE INTO collection_queue(
 id,target_label,normalized_label,proposed_entity_type,civilization_id,
 discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,
 discovery_context,priority,status,attempts,last_error,next_action,created_at,updated_at
) VALUES
('queue.v090.greek.perses_scholia','Perses homonyms in scholia and fragmentary genealogies','perses homonyms scholia fragmentary genealogies','CONCEPT','civ.greek','deity.greek.perses',NULL,'source.greek.apollodorus.library.topostext','The three-way audit exposes further name-bearing figures and variant spellings in scholia and fragments.',98,'DISCOVERED',0,NULL,'Register each fragment and scholion with edition, fragment number and uncertain identity candidates','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('queue.v090.greek.pallas_homonyms','Pallas homonym audit across Titan, Athena companion and giant traditions','pallas homonym audit titan athena companion giant traditions','DEITY','civ.greek','deity.greek.pallas_titan','claim.v090.crius_parent_pallas','source.greek.theogony.scaife','Scoping Pallas as the Titan exposes several other ancient figures with the same name.',97,'SOURCE_FOUND',1,NULL,'Create witness-specific Pallas records before any identity or alias relation','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('queue.v090.greek.aeetes_colchis','Aeetes, Colchis and Golden Fleece narrative layers','aeetes colchis golden fleece narrative layers','HERO','civ.greek','hero.greek.aeetes','claim.v090.perses_deposed_aeetes','source.greek.apollodorus.library.topostext','The restoration sequence exposes the wider Argonautic network.',96,'SOURCE_FOUND',1,NULL,'Add Colchis, Golden Fleece, Phrixus, Jason and source-specific Aeetes genealogies','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('queue.v090.greek.medea_versions','Medea narratives and mutually conflicting child/death/return versions','medea narratives conflicting child death return versions','HERO','civ.greek','hero.greek.medea','claim.v090.medea_killed_perses','source.greek.apollodorus.library.topostext','The restoration episode is only one layer in a large multi-author Medea tradition.',96,'SOURCE_FOUND',1,NULL,'Register Euripides, Apollonius, Diodorus and vase evidence as separate dated versions','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('queue.v090.greek.perseus_andromeda','Perseus and Andromeda primary-text and object network','perseus andromeda primary text object network','HERO','civ.greek','hero.greek.perses_perseus_son','claim.v090.perseus_parent_perses','source.greek.herodotus.histories.scaife','The Herodotean genealogy exposes the larger Perseus-Andromeda narrative and material record.',95,'SOURCE_FOUND',1,NULL,'Add primary narratives, regional variants, constellations and museum objects without projecting Herodotus onto all sources','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z'),
('queue.v090.greek.persian_aition_context','Herodotus Persian-name aition and ancient ethnographic context','herodotus persian name aition ancient ethnographic context','CONCEPT','civ.greek','concept.greek.persian_name_aition','claim.v090.perses_persian_aition','source.greek.herodotus.histories.scaife','The name story requires comparison with source-language Iranian evidence and modern historical linguistics.',94,'SOURCE_FOUND',1,NULL,'Add Achaemenid inscriptions and modern linguistic scholarship; do not treat the Greek aition as established etymology','2026-08-22T00:00:00Z','2026-08-22T00:00:00Z');

INSERT OR IGNORE INTO queue_discoveries(id,queue_id,discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,discovery_context,discovered_at)
SELECT 'discovery.'||substr(id,7),id,discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,discovery_context,'2026-08-22T00:00:00Z'
FROM collection_queue WHERE id LIKE 'queue.v090.greek.%';

INSERT OR IGNORE INTO research_sessions(id,started_at,ended_at,scope,strategy,status,agent_or_process,notes) VALUES
('research.20260822.v090_perses_homonym_audit','2026-08-22T00:00:00Z','2026-08-22T06:00:00Z','Perses homonym identity audit across Hesiod, Pseudo-Apollodorus, Diodorus and Herodotus','Advance the highest-priority executable conflict queue target; compare parentage, siblings and narrative role before identity assessment; never merge by spelling','CHECKPOINT_COMPLETE','Codex persistent research pipeline','Three major Perses figures are explicitly separated. Additional scholia, fragments and later witnesses remain queued.');
INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result)
SELECT 'research.20260822.v090_perses_homonym_audit','SOURCE',id,'REGISTER','URL_SYNTAX_VALID_WITH_LOCATOR_AND_RIGHTS_NOTE' FROM sources WHERE accessed_date='2026-08-22';
INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result)
SELECT 'research.20260822.v090_perses_homonym_audit','CLAIM',id,'REGISTER','SOURCE_LOCATED' FROM claims WHERE id LIKE 'claim.v090.%';
INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result)
SELECT 'research.20260822.v090_perses_homonym_audit','ENTITY',id,'CREATE','HOMONYM_SCOPE_AND_DISCOVERY_PATH_REGISTERED' FROM entities WHERE created_at='2026-08-22T00:00:00Z';

UPDATE entities SET evidence_status='PARTIAL',updated_at='2026-08-22T06:00:00Z'
WHERE evidence_status<>'SOURCE_BACKED' AND (id IN (SELECT subject_id FROM claims WHERE id LIKE 'claim.v090.%') OR id IN (SELECT object_entity_id FROM claims WHERE id LIKE 'claim.v090.%' AND object_entity_id IS NOT NULL));
UPDATE entities SET evidence_status='SOURCE_BACKED',updated_at='2026-08-22T06:00:00Z'
WHERE id IN (SELECT subject_id FROM claims WHERE id LIKE 'claim.v090.%')
 AND NOT EXISTS (SELECT 1 FROM claims c WHERE c.subject_id=entities.id AND NOT EXISTS (SELECT 1 FROM evidence e WHERE e.claim_id=c.id));
UPDATE entities SET research_status='PARTIAL',evidence_status='SOURCE_BACKED',updated_at='2026-08-22T06:00:00Z' WHERE id='deity.greek.perses';

UPDATE civilizations SET research_status='COLLECTING',evidence_status='PARTIAL' WHERE id='civ.greek';
UPDATE project_metadata SET value='0.9.0-perses-homonym-audit-20260822',updated_at='2026-08-22T06:00:00Z' WHERE key='data_version';
UPDATE project_metadata SET value='14',updated_at='2026-08-22T06:00:00Z' WHERE key='schema_version';
UPDATE project_metadata SET value='2026-08-22T06:00:00Z',updated_at='2026-08-22T06:00:00Z' WHERE key='generated_at';
INSERT OR IGNORE INTO dataset_releases(id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes) VALUES
('release.0.9.0',14,'0.9.0-perses-homonym-audit-20260822',NULL,'2026-08-22T06:00:00Z',NULL,'Perses homonym audit: Titan father of Hecate, Helios-son Colchian/Tauric king, and Perseus-son Herodotean aetiological figure stored separately; genealogy, texts, restoration event, identity assessments and six discovery branches added.');
INSERT INTO schema_migrations(version,name,applied_at) VALUES
(14,'20260822_v090_perses_homonym_audit','2026-08-22T06:00:00Z');

COMMIT;
