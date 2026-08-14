BEGIN IMMEDIATE;

-- v0.4.0 research checkpoint: public feedback exposed a concrete gap in the
-- Greek baseline.  The feedback is retained only as a discovery path; every
-- mythological assertion below is independently tied to a primary-text
-- digital edition and an exact line group.

INSERT OR IGNORE INTO entity_types(code,label_en,label_zh,parent_code,description)
VALUES(
  'TITAN','Titan','提坦神','DEITY',
  'Greek culture-specific divine generation/classification; never use as a cross-cultural synonym for giant.'
);

INSERT OR IGNORE INTO sources(
  id,title,original_title,source_type,evidence_tier,institution,author_or_editor,
  language_id,publication_date,accessed_date,url,stable_url,doi,isbn,catalogue_number,
  manuscript_number,rights_status,source_perspective,community_or_lineage,
  collector_context,living_tradition,access_or_reuse_restrictions,
  community_permission_required,same_witness_as_source_id,translation_status,
  verification_status,notes
) VALUES
('source.greek.homeric_hymn_demeter.scaife','Homeric Hymn 2 to Demeter, Evelyn-White English text',NULL,'PRIMARY_TEXT_DIGITAL_EDITION',2,'Perseus / Scaife, Tufts University','Anonymous; Hugh G. Evelyn-White (editor and translator)','lang.en','1914','2026-08-14','https://scaife.perseus.org/reader/urn%3Acts%3AgreekLit%3Atlg0013.tlg002.perseus-eng2%3A1-135/','urn:cts:greekLit:tlg0013.tlg002.perseus-eng2',NULL,NULL,'urn:cts:greekLit:tlg0013.tlg002.perseus-eng2',NULL,'Public-domain 1914 translation; Scaife presentation terms apply','Ancient Greek hymn through a 1914 English translation',NULL,'Digital scholarly edition; textual claims are not historical facts',0,'Attribute Perseus/Scaife and verify any substantial reuse',0,'source.greek.homeric_hymns.scaife','English translation aligned to an ancient Greek edition','URL_SYNTAX_VALID','Hecate and Helios passage checked at lines 25-62 on 2026-08-14.'),
('source.greek.homeric_hymn_hestia29.scaife','Homeric Hymn 29 to Hestia, Evelyn-White English text',NULL,'PRIMARY_TEXT_DIGITAL_EDITION',2,'Perseus / Scaife, Tufts University','Anonymous; Hugh G. Evelyn-White (editor and translator)','lang.en','1914','2026-08-14','https://scaife.perseus.org/reader/urn%3Acts%3AgreekLit%3Atlg0013.tlg029.perseus-eng2%3A1-14/','urn:cts:greekLit:tlg0013.tlg029.perseus-eng2',NULL,NULL,'urn:cts:greekLit:tlg0013.tlg029.perseus-eng2',NULL,'Public-domain 1914 translation; Scaife presentation terms apply','Ancient Greek hymn through a 1914 English translation',NULL,'Digital scholarly edition; individual hymn dating remains a research question',0,'Attribute Perseus/Scaife and verify any substantial reuse',0,'source.greek.homeric_hymns.scaife','English translation aligned to an ancient Greek edition','URL_SYNTAX_VALID','Complete fourteen-line hymn checked on 2026-08-14.'),
('source.greek.homeric_hymn_helios31.scaife','Homeric Hymn 31 to Helios, Evelyn-White English text',NULL,'PRIMARY_TEXT_DIGITAL_EDITION',2,'Perseus / Scaife, Tufts University','Anonymous; Hugh G. Evelyn-White (editor and translator)','lang.en','1914','2026-08-14','https://scaife.perseus.org/reader/urn%3Acts%3AgreekLit%3Atlg0013.tlg031.perseus-eng2%3A1-15a/','urn:cts:greekLit:tlg0013.tlg031.perseus-eng2',NULL,NULL,'urn:cts:greekLit:tlg0013.tlg031.perseus-eng2',NULL,'Public-domain 1914 translation; Scaife presentation terms apply','Ancient Greek hymn through a 1914 English translation',NULL,'Digital scholarly edition; textual claims are witness-specific',0,'Attribute Perseus/Scaife and verify any substantial reuse',0,'source.greek.homeric_hymns.scaife','English translation aligned to an ancient Greek edition','URL_SYNTAX_VALID','Complete hymn passage checked at lines 1-15a on 2026-08-14.'),
('source.greek.homeric_hymn_selene32.scaife','Homeric Hymn 32 to Selene, Evelyn-White edition and translation',NULL,'PRIMARY_TEXT_DIGITAL_EDITION',2,'Perseus / Scaife, Tufts University','Anonymous; Hugh G. Evelyn-White (editor and translator)','lang.grc','1914','2026-08-14','https://scaife.perseus.org/reader/urn%3Acts%3AgreekLit%3Atlg0013.tlg032.perseus-grc2%3A1-20/','urn:cts:greekLit:tlg0013.tlg032.perseus-grc2',NULL,NULL,'urn:cts:greekLit:tlg0013.tlg032.perseus-grc2',NULL,'Public-domain 1914 edition; Scaife presentation terms apply','Ancient Greek hymn in a 1914 edition',NULL,'Digital scholarly edition; textual claims are witness-specific',0,'Attribute Perseus/Scaife and verify any substantial reuse',0,'source.greek.homeric_hymns.scaife','Ancient Greek edition with aligned English translation available','URL_SYNTAX_VALID','Complete twenty-line hymn checked on 2026-08-14.');

INSERT OR IGNORE INTO entities(
  id,canonical_name,name_zh,original_name,transliteration,primary_type,
  primary_civilization_id,primary_culture_id,primary_region_id,historical_period,
  description,research_status,evidence_status,record_version,metadata_json,created_at,updated_at
) VALUES
('deity.greek.chaos','Chaos','卡俄斯','Χάος','Kháos','PRIMORDIAL_DEITY','civ.greek',NULL,NULL,'Archaic Greek textual tradition','The first named cosmogonic condition or being in Hesiod’s Theogony; its ontology should not be flattened into the modern everyday sense of disorder.','PARTIAL','SOURCE_BACKED',1,'{"classification_caution":"Keep Hesiodic Chaos distinct from generic comparative chaos concepts."}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.nyx','Nyx','倪克斯','Νύξ','Nýx','PRIMORDIAL_DEITY','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Night figure in Hesiodic genealogy, born from Chaos and parent of multiple personified powers in that witness.','PARTIAL','SOURCE_BACKED',1,'{"layer_caution":"Genealogies vary by witness; this baseline is Hesiod-specific."}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.erebus','Erebus','厄瑞玻斯','Ἔρεβος','Érebos','PRIMORDIAL_DEITY','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Erebus is born from Chaos in Theogony 123 and joins Nyx in the genealogy of Aether and Hemera.','PARTIAL','SOURCE_BACKED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.aether','Aether','埃忒耳','Αἰθήρ','Aithḗr','PRIMORDIAL_DEITY','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Aether is born from Nyx through union with Erebus in Theogony 124-125.','PARTIAL','SOURCE_BACKED',1,'{"translation_caution":"Do not automatically equate Aether with every culture’s air or sky concept."}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.hemera','Hemera','赫墨拉','Ἡμέρα','Hēméra','PRIMORDIAL_DEITY','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Hemera, Day, is born from Nyx through union with Erebus in Theogony 124-125.','PARTIAL','SOURCE_BACKED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.thanatos','Thanatos','塔纳托斯','Θάνατος','Thánatos','DEITY','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Personified Death among the children of Nyx in Hesiod’s Theogony.','PARTIAL','SOURCE_BACKED',1,'{"layer_caution":"Later literary and visual traditions require separate witness-level claims."}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.hypnos','Hypnos','许普诺斯','Ὕπνος','Hýpnos','DEITY','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Personified Sleep among the children of Nyx in Hesiod’s Theogony.','PARTIAL','SOURCE_BACKED',1,'{"layer_caution":"Later literary and visual traditions require separate witness-level claims."}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.hyperion','Hyperion','许珀里翁','Ὑπερίων','Hyperíōn','DEITY','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Titan child of Gaia and Uranus and parent, with Theia, of Helios, Selene and Eos in Hesiod.','PARTIAL','SOURCE_BACKED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.theia','Theia','忒亚','Θεία','Theía','DEITY','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Titan child of Gaia and Uranus and parent, with Hyperion, of Helios, Selene and Eos in Hesiod.','PARTIAL','SOURCE_BACKED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.helios','Helios','赫利俄斯','Ἥλιος','Hḗlios','DEITY','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Solar deity, child of Hyperion and Theia in Hesiod, celebrated with a chariot in Homeric Hymn 31.','PARTIAL','SOURCE_BACKED',1,'{"identity_caution":"Do not silently merge Helios with Apollo; identifications belong in sourced, dated claims."}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.selene','Selene','塞勒涅','Σελήνη','Selḗnē','DEITY','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Lunar deity, child of Hyperion and Theia in Hesiod and subject of Homeric Hymn 32.','PARTIAL','SOURCE_BACKED',1,'{"identity_caution":"Do not silently merge Selene with Artemis or other lunar figures."}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.eos','Eos','厄俄斯','Ἠώς','Ēṓs','DEITY','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Dawn deity named with Helios and Selene among the children of Hyperion and Theia in Hesiod.','PARTIAL','SOURCE_BACKED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.asteria','Asteria','阿斯忒里亚','Ἀστερία','Astería','DEITY','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Parent of Hecate with Perses in Hesiod’s Theogony.','PARTIAL','SOURCE_BACKED',1,'{"scope_caution":"This record follows the Hesiodic Hecate genealogy only."}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.perses','Perses','珀耳塞斯','Πέρσης','Pérsēs','DEITY','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Parent of Hecate with Asteria in Hesiod’s Theogony.','PARTIAL','SOURCE_BACKED',1,'{"identity_caution":"Greek tradition contains more than one figure named Perses; do not merge by name alone."}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.hecate','Hecate','赫卡忒','Ἑκάτη','Hekátē','DEITY','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Daughter of Asteria and Perses who receives extensive honors in Hesiod; a torch-bearing helper of Demeter in Homeric Hymn 2.','PARTIAL','SOURCE_BACKED',1,'{"layer_caution":"The v0.4 baseline separates early Hesiodic and Hymn-to-Demeter testimony from later magic, crossroads and underworld layers."}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.hestia','Hestia','赫斯提亚','Ἑστία','Hestía','DEITY','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Child of Rhea and Cronus in Hesiod and recipient of first-and-last banquet libations in Homeric Hymn 29.','PARTIAL','SOURCE_BACKED',1,'{"layer_caution":"Cult practice and later civic traditions remain queued for archaeological and epigraphic expansion."}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('concept.comparative.night','Night','夜','夜','Night','CONCEPT','civ.greek',NULL,NULL,'Comparative indexing layer','A cross-record navigation concept for night associations; it is not identical to Nyx or to any other culture-specific being.','PARTIAL','PARTIAL',1,'{"comparison_only":true}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('concept.comparative.sleep','Sleep','睡眠','睡眠','Sleep','CONCEPT','civ.greek',NULL,NULL,'Comparative indexing layer','A cross-record navigation concept for sleep associations; it is not identical to Hypnos or to any other culture-specific being.','PARTIAL','PARTIAL',1,'{"comparison_only":true}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('concept.comparative.hearth','Hearth','炉火／灶火','炉火','Hearth','CONCEPT','civ.greek',NULL,NULL,'Comparative indexing layer','A cross-record navigation concept for hearth associations; it does not erase culture-specific ritual meanings.','PARTIAL','PARTIAL',1,'{"comparison_only":true}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('text.greek.homeric_hymn_demeter','Homeric Hymn 2 to Demeter','《荷马颂歌·致得墨忒耳》',NULL,NULL,'TEXT','civ.greek',NULL,NULL,'Archaic Greek poetic tradition','Long Homeric Hymn to Demeter; v0.4 registers the Hecate and Helios passages at lines 25-62.','PARTIAL','PARTIAL',1,'{"work_number":2,"part_of":"text.greek.homeric_hymns"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('text.greek.homeric_hymn_hestia_29','Homeric Hymn 29 to Hestia','《荷马颂歌·致赫斯提亚》（第29首）',NULL,NULL,'TEXT','civ.greek',NULL,NULL,'Archaic Greek poetic tradition','Fourteen-line hymn honoring Hestia and Hermes; individual composition dating remains under review.','PARTIAL','PARTIAL',1,'{"work_number":29,"part_of":"text.greek.homeric_hymns"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('text.greek.homeric_hymn_helios_31','Homeric Hymn 31 to Helios','《荷马颂歌·致赫利俄斯》（第31首）',NULL,NULL,'TEXT','civ.greek',NULL,NULL,'Archaic Greek poetic tradition','Hymn to Helios describing his genealogy, radiance and chariot.','PARTIAL','PARTIAL',1,'{"work_number":31,"part_of":"text.greek.homeric_hymns"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('text.greek.homeric_hymn_selene_32','Homeric Hymn 32 to Selene','《荷马颂歌·致塞勒涅》（第32首）',NULL,NULL,'TEXT','civ.greek',NULL,NULL,'Archaic Greek poetic tradition','Twenty-line hymn to Selene describing her radiance, horses and monthly sign.','PARTIAL','PARTIAL',1,'{"work_number":32,"part_of":"text.greek.homeric_hymns"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z');

INSERT OR IGNORE INTO entity_classifications(entity_id,type_code,is_primary,notes)
SELECT id,primary_type,1,'Primary classification from v0.4.0 Greek genealogy checkpoint'
FROM entities
WHERE id IN (
  'deity.greek.chaos','deity.greek.nyx','deity.greek.erebus','deity.greek.aether','deity.greek.hemera',
  'deity.greek.thanatos','deity.greek.hypnos','deity.greek.hyperion','deity.greek.theia','deity.greek.helios',
  'deity.greek.selene','deity.greek.eos','deity.greek.asteria','deity.greek.perses','deity.greek.hecate','deity.greek.hestia',
  'concept.comparative.night','concept.comparative.sleep','concept.comparative.hearth',
  'text.greek.homeric_hymn_demeter','text.greek.homeric_hymn_hestia_29',
  'text.greek.homeric_hymn_helios_31','text.greek.homeric_hymn_selene_32'
);

INSERT OR IGNORE INTO entity_classifications(entity_id,type_code,is_primary,notes) VALUES
('deity.greek.chaos','DEITY',0,'Queryable through the deity collection; ontology remains witness-specific'),
('deity.greek.nyx','DEITY',0,'Queryable through the deity collection'),
('deity.greek.erebus','DEITY',0,'Queryable through the deity collection'),
('deity.greek.aether','DEITY',0,'Queryable through the deity collection'),
('deity.greek.hemera','DEITY',0,'Queryable through the deity collection'),
('deity.greek.hyperion','TITAN',0,'Hesiodic divine generation'),
('deity.greek.theia','TITAN',0,'Hesiodic divine generation'),
('deity.greek.asteria','TITAN',0,'Hesiodic divine generation'),
('deity.greek.perses','TITAN',0,'Hesiodic divine generation; identity caution applies'),
('deity.greek.cronus','TITAN',0,'Greek culture-specific classification'),
('deity.greek.rhea','TITAN',0,'Greek culture-specific classification');

INSERT OR IGNORE INTO entity_civilizations(entity_id,civilization_id,association_role,certainty,notes)
SELECT id,'civ.greek','ORIGIN','SUPPORTED','Registered from the Greek textual baseline; comparative concepts remain navigation aids only'
FROM entities
WHERE id IN (
  'deity.greek.chaos','deity.greek.nyx','deity.greek.erebus','deity.greek.aether','deity.greek.hemera',
  'deity.greek.thanatos','deity.greek.hypnos','deity.greek.hyperion','deity.greek.theia','deity.greek.helios',
  'deity.greek.selene','deity.greek.eos','deity.greek.asteria','deity.greek.perses','deity.greek.hecate','deity.greek.hestia',
  'concept.comparative.night','concept.comparative.sleep','concept.comparative.hearth',
  'text.greek.homeric_hymn_demeter','text.greek.homeric_hymn_hestia_29',
  'text.greek.homeric_hymn_helios_31','text.greek.homeric_hymn_selene_32'
);

INSERT OR IGNORE INTO names(
  id,entity_id,name_text,normalized_text,language_id,script_name,name_type,
  transliteration_scheme,is_preferred,source_id,notes
) VALUES
('name.greek.chaos.grc','deity.greek.chaos','Χάος','χάος','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.theogony.scaife','Form at Theogony 116 and 123'),
('name.greek.chaos.en','deity.greek.chaos','Chaos','chaos','lang.en','Latin','TRANSLITERATION','Conventional scholarly Latinization',1,'source.greek.theogony.perseus_eng1',NULL),
('name.greek.chaos.zh','deity.greek.chaos','卡俄斯','卡俄斯','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese transliteration; kept distinct from the generic word 混沌'),
('name.greek.nyx.grc','deity.greek.nyx','Νύξ','νύξ','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.theogony.scaife','Form at Theogony 123-125'),
('name.greek.nyx.en','deity.greek.nyx','Nyx','nyx','lang.en','Latin','TRANSLITERATION','Conventional scholarly Latinization',1,'source.greek.theogony.perseus_eng1',NULL),
('name.greek.nyx.zh','deity.greek.nyx','倪克斯','倪克斯','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese transliteration'),
('name.greek.erebus.grc','deity.greek.erebus','Ἔρεβος','ἔρεβος','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.theogony.scaife','Form at Theogony 123-125'),
('name.greek.erebus.en','deity.greek.erebus','Erebus','erebus','lang.en','Latin','TRANSLITERATION','Conventional scholarly Latinization',1,'source.greek.theogony.perseus_eng1',NULL),
('name.greek.erebus.zh','deity.greek.erebus','厄瑞玻斯','厄瑞玻斯','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese transliteration'),
('name.greek.aether.grc','deity.greek.aether','Αἰθήρ','αἰθήρ','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.theogony.scaife','Form at Theogony 124-125'),
('name.greek.aether.en','deity.greek.aether','Aether','aether','lang.en','Latin','TRANSLITERATION','Conventional scholarly Latinization',1,'source.greek.theogony.perseus_eng1',NULL),
('name.greek.aether.zh','deity.greek.aether','埃忒耳','埃忒耳','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese transliteration'),
('name.greek.hemera.grc','deity.greek.hemera','Ἡμέρα','ἡμέρα','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.theogony.scaife','Form at Theogony 124-125'),
('name.greek.hemera.en','deity.greek.hemera','Hemera','hemera','lang.en','Latin','TRANSLITERATION','Conventional scholarly Latinization',1,'source.greek.theogony.perseus_eng1',NULL),
('name.greek.hemera.zh','deity.greek.hemera','赫墨拉','赫墨拉','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese transliteration'),
('name.greek.thanatos.grc','deity.greek.thanatos','Θάνατος','θάνατος','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.theogony.scaife','Hesiodic name form'),
('name.greek.thanatos.en','deity.greek.thanatos','Thanatos','thanatos','lang.en','Latin','TRANSLITERATION','Conventional scholarly Latinization',1,'source.greek.theogony.perseus_eng1',NULL),
('name.greek.thanatos.zh','deity.greek.thanatos','塔纳托斯','塔纳托斯','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese transliteration'),
('name.greek.hypnos.grc','deity.greek.hypnos','Ὕπνος','ὕπνος','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.theogony.scaife','Hesiodic name form'),
('name.greek.hypnos.en','deity.greek.hypnos','Hypnos','hypnos','lang.en','Latin','TRANSLITERATION','Conventional scholarly Latinization',1,'source.greek.theogony.perseus_eng1',NULL),
('name.greek.hypnos.zh','deity.greek.hypnos','许普诺斯','许普诺斯','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese transliteration'),
('name.greek.hyperion.grc','deity.greek.hyperion','Ὑπερίων','ὑπερίων','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.theogony.scaife','Form at Theogony 134'),
('name.greek.hyperion.en','deity.greek.hyperion','Hyperion','hyperion','lang.en','Latin','TRANSLITERATION','Conventional scholarly Latinization',1,'source.greek.theogony.perseus_eng1',NULL),
('name.greek.hyperion.zh','deity.greek.hyperion','许珀里翁','许珀里翁','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese transliteration'),
('name.greek.theia.grc','deity.greek.theia','Θεία','θεία','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.theogony.scaife','Form at Theogony 135'),
('name.greek.theia.en','deity.greek.theia','Theia','theia','lang.en','Latin','TRANSLITERATION','Conventional scholarly Latinization',1,'source.greek.theogony.perseus_eng1',NULL),
('name.greek.theia.zh','deity.greek.theia','忒亚','忒亚','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese transliteration'),
('name.greek.helios.grc','deity.greek.helios','Ἥλιος','ἥλιος','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.homeric_hymn_helios31.scaife','Name in Hymn 31'),
('name.greek.helios.en','deity.greek.helios','Helios','helios','lang.en','Latin','TRANSLITERATION','Conventional scholarly Latinization',1,'source.greek.homeric_hymn_helios31.scaife',NULL),
('name.greek.helios.zh','deity.greek.helios','赫利俄斯','赫利俄斯','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese transliteration'),
('name.greek.selene.grc','deity.greek.selene','Σελήνη','σελήνη','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.homeric_hymn_selene32.scaife','Name in Hymn 32'),
('name.greek.selene.en','deity.greek.selene','Selene','selene','lang.en','Latin','TRANSLITERATION','Conventional scholarly Latinization',1,'source.greek.homeric_hymn_selene32.scaife',NULL),
('name.greek.selene.zh','deity.greek.selene','塞勒涅','塞勒涅','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese transliteration'),
('name.greek.eos.grc','deity.greek.eos','Ἠώς','ἠώς','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.theogony.scaife','Hesiodic name form'),
('name.greek.eos.en','deity.greek.eos','Eos','eos','lang.en','Latin','TRANSLITERATION','Conventional scholarly Latinization',1,'source.greek.theogony.perseus_eng1',NULL),
('name.greek.eos.zh','deity.greek.eos','厄俄斯','厄俄斯','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese transliteration'),
('name.greek.asteria.grc','deity.greek.asteria','Ἀστερία','ἀστερία','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.theogony.scaife','Hesiodic name form'),
('name.greek.asteria.en','deity.greek.asteria','Asteria','asteria','lang.en','Latin','TRANSLITERATION','Conventional scholarly Latinization',1,'source.greek.theogony.perseus_eng1',NULL),
('name.greek.asteria.zh','deity.greek.asteria','阿斯忒里亚','阿斯忒里亚','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese transliteration'),
('name.greek.perses.grc','deity.greek.perses','Πέρσης','πέρσης','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.theogony.scaife','Hesiodic name form; homonymous figures remain distinct'),
('name.greek.perses.en','deity.greek.perses','Perses','perses','lang.en','Latin','TRANSLITERATION','Conventional scholarly Latinization',1,'source.greek.theogony.perseus_eng1','Identity caution applies'),
('name.greek.perses.zh','deity.greek.perses','珀耳塞斯','珀耳塞斯','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese transliteration'),
('name.greek.hecate.grc','deity.greek.hecate','Ἑκάτη','ἑκάτη','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.theogony.scaife','Hesiodic name form'),
('name.greek.hecate.en','deity.greek.hecate','Hecate','hecate','lang.en','Latin','TRANSLITERATION','Conventional Latinized form',1,'source.greek.theogony.perseus_eng1',NULL),
('name.greek.hecate.zh','deity.greek.hecate','赫卡忒','赫卡忒','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese transliteration'),
('name.greek.hestia.grc','deity.greek.hestia','Ἑστία','ἑστία','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.homeric_hymn_hestia29.scaife','Form in Hymn 29'),
('name.greek.hestia.en','deity.greek.hestia','Hestia','hestia','lang.en','Latin','TRANSLITERATION','Conventional scholarly Latinization',1,'source.greek.homeric_hymn_hestia29.scaife',NULL),
('name.greek.hestia.zh','deity.greek.hestia','赫斯提亚','赫斯提亚','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese transliteration'),
('name.concept.night.en','concept.comparative.night','Night','night','lang.en','Latin','TRANSLATION',NULL,1,NULL,'Comparative navigation label, not an identity assertion'),
('name.concept.night.zh','concept.comparative.night','夜','夜','lang.zh','Han','TRANSLATION',NULL,1,NULL,'比较导航标签'),
('name.concept.sleep.en','concept.comparative.sleep','Sleep','sleep','lang.en','Latin','TRANSLATION',NULL,1,NULL,'Comparative navigation label, not an identity assertion'),
('name.concept.sleep.zh','concept.comparative.sleep','睡眠','睡眠','lang.zh','Han','TRANSLATION',NULL,1,NULL,'比较导航标签'),
('name.concept.hearth.en','concept.comparative.hearth','Hearth','hearth','lang.en','Latin','TRANSLATION',NULL,1,NULL,'Comparative navigation label, not an identity assertion'),
('name.concept.hearth.zh','concept.comparative.hearth','炉火／灶火','炉火／灶火','lang.zh','Han','TRANSLATION',NULL,1,NULL,'比较导航标签'),
('name.text.hh_demeter.en','text.greek.homeric_hymn_demeter','Homeric Hymn 2 to Demeter','homeric hymn 2 to demeter','lang.en','Latin','CANONICAL',NULL,1,'source.greek.homeric_hymn_demeter.scaife','Scaife catalogue title'),
('name.text.hh_demeter.zh','text.greek.homeric_hymn_demeter','《荷马颂歌·致得墨忒耳》','荷马颂歌 致得墨忒耳','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese reading title'),
('name.text.hh_hestia29.en','text.greek.homeric_hymn_hestia_29','Homeric Hymn 29 to Hestia','homeric hymn 29 to hestia','lang.en','Latin','CANONICAL',NULL,1,'source.greek.homeric_hymn_hestia29.scaife','Scaife catalogue title'),
('name.text.hh_hestia29.zh','text.greek.homeric_hymn_hestia_29','《荷马颂歌·致赫斯提亚》（第29首）','荷马颂歌 致赫斯提亚 第29首','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese reading title'),
('name.text.hh_helios31.en','text.greek.homeric_hymn_helios_31','Homeric Hymn 31 to Helios','homeric hymn 31 to helios','lang.en','Latin','CANONICAL',NULL,1,'source.greek.homeric_hymn_helios31.scaife','Scaife catalogue title'),
('name.text.hh_helios31.zh','text.greek.homeric_hymn_helios_31','《荷马颂歌·致赫利俄斯》（第31首）','荷马颂歌 致赫利俄斯 第31首','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese reading title'),
('name.text.hh_selene32.en','text.greek.homeric_hymn_selene_32','Homeric Hymn 32 to Selene','homeric hymn 32 to selene','lang.en','Latin','CANONICAL',NULL,1,'source.greek.homeric_hymn_selene32.scaife','Scaife catalogue title'),
('name.text.hh_selene32.zh','text.greek.homeric_hymn_selene_32','《荷马颂歌·致塞勒涅》（第32首）','荷马颂歌 致塞勒涅 第32首','lang.zh','Han','TRANSLATION',NULL,1,NULL,'Chinese reading title');

INSERT OR IGNORE INTO deity_profiles(
  entity_id,deity_class,pantheon_or_family,rank_or_status,domains_json,powers_json,
  limitations_json,appearance_json,symbols_json,cult_summary,final_fate_summary
) VALUES
('deity.greek.chaos','PRIMORDIAL_DEITY','Hesiodic cosmogony','Primordial','["cosmogonic beginning in the Hesiodic witness"]','[]','["Ontology and translation are witness-dependent"]','{}','[]',NULL,NULL),
('deity.greek.nyx','PRIMORDIAL_DEITY','Hesiodic genealogy','Primordial','["night"]','[]','[]','{}','[]',NULL,NULL),
('deity.greek.erebus','PRIMORDIAL_DEITY','Hesiodic genealogy','Primordial','["Erebus"]','[]','[]','{}','[]',NULL,NULL),
('deity.greek.aether','PRIMORDIAL_DEITY','Hesiodic genealogy','Primordial','["aether / bright upper air"]','[]','[]','{}','[]',NULL,NULL),
('deity.greek.hemera','PRIMORDIAL_DEITY','Hesiodic genealogy','Primordial','["day"]','[]','[]','{}','[]',NULL,NULL),
('deity.greek.thanatos','PERSONIFIED_DEITY','Children of Nyx',NULL,'["death"]','[]','[]','{}','[]',NULL,NULL),
('deity.greek.hypnos','PERSONIFIED_DEITY','Children of Nyx',NULL,'["sleep"]','[]','[]','{}','[]',NULL,NULL),
('deity.greek.hyperion','TITAN','Children of Gaia and Uranus','Titan','["Hesiodic solar genealogy"]','[]','[]','{}','[]',NULL,NULL),
('deity.greek.theia','TITAN','Children of Gaia and Uranus','Titan','["Hesiodic solar genealogy"]','[]','[]','{}','[]',NULL,NULL),
('deity.greek.helios','DEITY','Children of Hyperion and Theia',NULL,'["sun"]','["radiance","celestial chariot journey"]','[]','{"homeric_hymn_31":"golden helmet, radiant hair and garment"}','["chariot","horses","rays"]',NULL,NULL),
('deity.greek.selene','DEITY','Children of Hyperion and Theia',NULL,'["moon"]','["radiance","monthly celestial sign"]','[]','{"homeric_hymn_32":"radiant crown and far-gleaming garments"}','["horses","golden crown","rays"]',NULL,NULL),
('deity.greek.eos','DEITY','Children of Hyperion and Theia',NULL,'["dawn"]','[]','[]','{}','[]',NULL,NULL),
('deity.greek.asteria','TITAN','Hesiodic genealogy','Titan','["Hecate genealogy in Hesiod"]','[]','[]','{}','[]',NULL,NULL),
('deity.greek.perses','TITAN','Hesiodic genealogy','Titan','["Hecate genealogy in Hesiod"]','[]','["Identity must be distinguished from homonymous figures"]','{}','[]',NULL,NULL),
('deity.greek.hecate','DEITY','Hesiodic genealogy',NULL,'["honors in earth, sea and heaven in Hesiod","torch-bearing companion in Hymn 2"]','[]','["Later magic and crossroads layers are not asserted by the early passages alone"]','{"homeric_hymn_2":"torch-bearing"}','["torch in Homeric Hymn 2"]',NULL,NULL),
('deity.greek.hestia','DEITY','Children of Rhea and Cronus',NULL,'["household seat / hearth","banquet libation precedence in Hymn 29"]','[]','[]','{}','["first-and-last libation in Homeric Hymn 29"]',NULL,NULL);

INSERT OR IGNORE INTO text_profiles(
  entity_id,text_type,original_language_id,attributed_author,compiler,
  composition_period,earliest_extant_witness,chapter_structure,repository,
  shelfmark,copyright_status,summary
) VALUES
('text.greek.homeric_hymn_demeter','HYMN','lang.grc','Anonymous Homeric Hymn tradition',NULL,'Archaic Greek poetic tradition; exact dating debated',NULL,'Hymn 2, 495 lines','Perseus / Scaife digital edition','urn:cts:greekLit:tlg0013.tlg002','Ancient text public domain; digital presentation terms apply','Registers Hecate and Helios at lines 25-62 without treating the hymn as historical fact.'),
('text.greek.homeric_hymn_hestia_29','HYMN','lang.grc','Anonymous Homeric Hymn tradition',NULL,'Ancient Greek poetic tradition; exact dating debated',NULL,'Hymn 29, 14 lines','Perseus / Scaife digital edition','urn:cts:greekLit:tlg0013.tlg029','Ancient text public domain; digital presentation terms apply','Honors Hestia and Hermes and records first-and-last libation language.'),
('text.greek.homeric_hymn_helios_31','HYMN','lang.grc','Anonymous Homeric Hymn tradition',NULL,'Ancient Greek poetic tradition; exact dating debated',NULL,'Hymn 31, lines 1-15a plus closing salutation','Perseus / Scaife digital edition','urn:cts:greekLit:tlg0013.tlg031','Ancient text public domain; digital presentation terms apply','Describes Helios’s genealogy, radiance, clothing, horses and chariot.'),
('text.greek.homeric_hymn_selene_32','HYMN','lang.grc','Anonymous Homeric Hymn tradition',NULL,'Ancient Greek poetic tradition; exact dating debated',NULL,'Hymn 32, 20 lines','Perseus / Scaife digital edition','urn:cts:greekLit:tlg0013.tlg032','Ancient text public domain; digital presentation terms apply','Describes Selene’s radiance, horses, monthly sign and Pandia genealogy.');

INSERT OR IGNORE INTO claims(
  id,subject_id,predicate,object_entity_id,object_literal,object_datatype,statement,
  variant_group,claim_status,confidence,confidence_level,review_status,
  assertion_scope,knowledge_layer,tradition_scope,temporal_scope,research_notes,created_at
) VALUES
('claim.v040.chaos.mentioned_theogony','deity.greek.chaos','MENTIONED_IN','text.greek.theogony',NULL,NULL,'Theogony names Chaos first and later names Nyx and Erebus as arising from it.','hesiod.theogony.116-125','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Hesiodic','Theogony 116-125','Ontology remains a textual and interpretive question.','2026-08-14T00:00:00Z'),
('claim.v040.nyx.child_chaos','deity.greek.nyx','CHILD_OF','deity.greek.chaos',NULL,NULL,'Theogony 123 says Nyx arose from Chaos.','hesiod.theogony.123','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 123',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.erebus.child_chaos','deity.greek.erebus','CHILD_OF','deity.greek.chaos',NULL,NULL,'Theogony 123 says Erebus arose from Chaos.','hesiod.theogony.123','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 123',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.aether.child_nyx','deity.greek.aether','CHILD_OF','deity.greek.nyx',NULL,NULL,'Theogony 124-125 presents Aether as a child of Nyx.','hesiod.theogony.124-125','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 124-125',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.aether.child_erebus','deity.greek.aether','CHILD_OF','deity.greek.erebus',NULL,NULL,'Theogony 124-125 presents Erebus as Aether’s other parent.','hesiod.theogony.124-125','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 124-125',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.hemera.child_nyx','deity.greek.hemera','CHILD_OF','deity.greek.nyx',NULL,NULL,'Theogony 124-125 presents Hemera as a child of Nyx.','hesiod.theogony.124-125','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 124-125',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.hemera.child_erebus','deity.greek.hemera','CHILD_OF','deity.greek.erebus',NULL,NULL,'Theogony 124-125 presents Erebus as Hemera’s other parent.','hesiod.theogony.124-125','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 124-125',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.hyperion.child_gaia','deity.greek.hyperion','CHILD_OF','deity.greek.gaia',NULL,NULL,'Theogony 133-136 lists Hyperion among the children of Gaia and Uranus.','hesiod.theogony.133-136','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 133-136',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.hyperion.child_uranus','deity.greek.hyperion','CHILD_OF','deity.greek.uranus',NULL,NULL,'Theogony 133-136 lists Hyperion among the children of Gaia and Uranus.','hesiod.theogony.133-136','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 133-136',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.theia.child_gaia','deity.greek.theia','CHILD_OF','deity.greek.gaia',NULL,NULL,'Theogony 133-136 lists Theia among the children of Gaia and Uranus.','hesiod.theogony.133-136','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 133-136',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.theia.child_uranus','deity.greek.theia','CHILD_OF','deity.greek.uranus',NULL,NULL,'Theogony 133-136 lists Theia among the children of Gaia and Uranus.','hesiod.theogony.133-136','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 133-136',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.thanatos.child_nyx','deity.greek.thanatos','CHILD_OF','deity.greek.nyx',NULL,NULL,'Theogony 211-212 lists Thanatos among the children of Nyx.','hesiod.theogony.211-225','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 211-225',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.hypnos.child_nyx','deity.greek.hypnos','CHILD_OF','deity.greek.nyx',NULL,NULL,'Theogony 211-212 lists Hypnos among the children of Nyx.','hesiod.theogony.211-225','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 211-225',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.thanatos.sibling_hypnos','deity.greek.thanatos','SIBLING_OF','deity.greek.hypnos',NULL,NULL,'Thanatos and Hypnos occur together as children of Nyx in the Hesiodic genealogy.','hesiod.theogony.211-225','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 211-225',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.thanatos.represents_death','deity.greek.thanatos','REPRESENTS','concept.comparative.death',NULL,NULL,'The comparative index connects Thanatos with death while retaining the culture-specific deity record.','hesiod.theogony.211-225','SUPPORTED',0.94,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Comparative navigation','Theogony 211-225','Normalization for navigation, not identity with every death figure.','2026-08-14T00:00:00Z'),
('claim.v040.hypnos.represents_sleep','deity.greek.hypnos','REPRESENTS','concept.comparative.sleep',NULL,NULL,'The comparative index connects Hypnos with sleep while retaining the culture-specific deity record.','hesiod.theogony.211-225','SUPPORTED',0.94,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Comparative navigation','Theogony 211-225','Normalization for navigation, not identity with every sleep figure.','2026-08-14T00:00:00Z'),
('claim.v040.nyx.represents_night','deity.greek.nyx','REPRESENTS','concept.comparative.night',NULL,NULL,'The comparative index connects Nyx with night while retaining the culture-specific deity record.','hesiod.theogony.123-125','SUPPORTED',0.94,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Comparative navigation','Theogony 123-125','Normalization for navigation, not identity with every night figure.','2026-08-14T00:00:00Z'),
('claim.v040.hyperion.parent_helios','deity.greek.hyperion','PARENT_OF','deity.greek.helios',NULL,NULL,'Theogony 371-374 presents Hyperion and Theia as parents of Helios.','hesiod.theogony.371-374','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 371-374',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.hyperion.parent_selene','deity.greek.hyperion','PARENT_OF','deity.greek.selene',NULL,NULL,'Theogony 371-374 presents Hyperion and Theia as parents of Selene.','hesiod.theogony.371-374','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 371-374',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.hyperion.parent_eos','deity.greek.hyperion','PARENT_OF','deity.greek.eos',NULL,NULL,'Theogony 371-374 presents Hyperion and Theia as parents of Eos.','hesiod.theogony.371-374','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 371-374',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.theia.parent_helios','deity.greek.theia','PARENT_OF','deity.greek.helios',NULL,NULL,'Theogony 371-374 presents Theia and Hyperion as parents of Helios.','hesiod.theogony.371-374','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 371-374',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.theia.parent_selene','deity.greek.theia','PARENT_OF','deity.greek.selene',NULL,NULL,'Theogony 371-374 presents Theia and Hyperion as parents of Selene.','hesiod.theogony.371-374','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 371-374',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.theia.parent_eos','deity.greek.theia','PARENT_OF','deity.greek.eos',NULL,NULL,'Theogony 371-374 presents Theia and Hyperion as parents of Eos.','hesiod.theogony.371-374','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 371-374',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.helios.sibling_selene','deity.greek.helios','SIBLING_OF','deity.greek.selene',NULL,NULL,'Helios and Selene occur as children of Hyperion and Theia in Theogony 371-374.','hesiod.theogony.371-374','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 371-374',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.helios.sibling_eos','deity.greek.helios','SIBLING_OF','deity.greek.eos',NULL,NULL,'Helios and Eos occur as children of Hyperion and Theia in Theogony 371-374.','hesiod.theogony.371-374','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 371-374',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.selene.sibling_eos','deity.greek.selene','SIBLING_OF','deity.greek.eos',NULL,NULL,'Selene and Eos occur as children of Hyperion and Theia in Theogony 371-374.','hesiod.theogony.371-374','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 371-374',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.eos.mentioned_theogony','deity.greek.eos','MENTIONED_IN','text.greek.theogony',NULL,NULL,'Eos is named with Selene and Helios in the Hyperion-Theia genealogy.','hesiod.theogony.371-374','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Hesiodic','Theogony 371-374',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.helios.represents_sun','deity.greek.helios','REPRESENTS','concept.comparative.sun',NULL,NULL,'The comparative index connects Helios with the sun while retaining the Greek deity as a distinct entity.','hesiod.theogony.371-374','SUPPORTED',0.95,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Comparative navigation','Theogony 371-374','Do not use this edge to merge Helios with other solar beings.','2026-08-14T00:00:00Z'),
('claim.v040.selene.represents_moon','deity.greek.selene','REPRESENTS','concept.comparative.moon',NULL,NULL,'The comparative index connects Selene with the moon while retaining the Greek deity as a distinct entity.','homeric_hymn.32','SUPPORTED',0.95,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Comparative navigation','Homeric Hymn 32, lines 1-20','Do not use this edge to merge Selene with other lunar beings.','2026-08-14T00:00:00Z'),
('claim.v040.asteria.parent_hecate','deity.greek.asteria','PARENT_OF','deity.greek.hecate',NULL,NULL,'Theogony 404-409 presents Asteria and Perses as parents of Hecate.','hesiod.theogony.404-409','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 404-409',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.perses.parent_hecate','deity.greek.perses','PARENT_OF','deity.greek.hecate',NULL,NULL,'Theogony 404-409 presents Perses and Asteria as parents of Hecate.','hesiod.theogony.404-409','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 404-409','Perses identity is restricted to this witness-level genealogy.','2026-08-14T00:00:00Z'),
('claim.v040.hecate.mentioned_theogony','deity.greek.hecate','MENTIONED_IN','text.greek.theogony',NULL,NULL,'Hecate receives an extended passage in Theogony 404-452.','hesiod.theogony.404-452','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Hesiodic','Theogony 404-452',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.hecate.domain_theogony','deity.greek.hecate','DOMAIN',NULL,'shares in honors on earth, sea and heaven under Zeus in this Hesiodic passage','text','Theogony 411-452 assigns Hecate extensive shares and honors across several spheres.','hesiod.theogony.411-452','SUPPORTED',0.97,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 411-452','This early textual layer does not by itself establish every later magical or crossroads association.','2026-08-14T00:00:00Z'),
('claim.v040.hecate.appears_hymn2','deity.greek.hecate','APPEARS_IN','text.greek.homeric_hymn_demeter',NULL,NULL,'Hecate hears Persephone and later meets Demeter carrying a torch in Homeric Hymn 2.','homeric_hymn.2.25-62','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn to Demeter','Hymn 2, lines 25-62',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.hecate.role_hymn2','deity.greek.hecate','ROLE',NULL,'hears Persephone, meets Demeter with a torch, and accompanies her to Helios','text','Homeric Hymn 2 describes Hecate’s torch-bearing assistance to Demeter.','homeric_hymn.2.25-62','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Homeric Hymn to Demeter','Hymn 2, lines 25-62','Role is restricted to this hymn passage.','2026-08-14T00:00:00Z'),
('claim.v040.hestia.child_cronus','deity.greek.hestia','CHILD_OF','deity.greek.cronus',NULL,NULL,'Theogony 453-458 presents Hestia among the children of Rhea and Cronus.','hesiod.theogony.453-458','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 453-458',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.hestia.child_rhea','deity.greek.hestia','CHILD_OF','deity.greek.rhea',NULL,NULL,'Theogony 453-458 presents Hestia among the children borne by Rhea to Cronus.','hesiod.theogony.453-458','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 453-458',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.hestia.sibling_zeus','deity.greek.hestia','SIBLING_OF','deity.greek.zeus',NULL,NULL,'Hestia and Zeus occur among the children of Rhea and Cronus in Theogony 453-458.','hesiod.theogony.453-458','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 453-458',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.hestia.sibling_hera','deity.greek.hestia','SIBLING_OF','deity.greek.hera',NULL,NULL,'Hestia and Hera occur among the children of Rhea and Cronus in Theogony 453-458.','hesiod.theogony.453-458','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 453-458',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.hestia.sibling_poseidon','deity.greek.hestia','SIBLING_OF','deity.greek.poseidon',NULL,NULL,'Hestia and Poseidon occur among the children of Rhea and Cronus in Theogony 453-458.','hesiod.theogony.453-458','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 453-458',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.hestia.sibling_hades','deity.greek.hestia','SIBLING_OF','deity.greek.hades',NULL,NULL,'Hestia and Hades occur among the children of Rhea and Cronus in Theogony 453-458.','hesiod.theogony.453-458','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 453-458',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.hestia.sibling_demeter','deity.greek.hestia','SIBLING_OF','deity.greek.demeter',NULL,NULL,'Hestia and Demeter occur among the children of Rhea and Cronus in Theogony 453-458.','hesiod.theogony.453-458','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 453-458',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.hestia.appears_hymn29','deity.greek.hestia','APPEARS_IN','text.greek.homeric_hymn_hestia_29',NULL,NULL,'Hestia is the principal addressee of Homeric Hymn 29.','homeric_hymn.29','SUPPORTED',1.0,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 29','Hymn 29, lines 1-14',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.hestia.honors_hymn29','deity.greek.hestia','RITUAL_ROLE',NULL,'receives first-and-last libation at mortal banquets in this hymn','text','Homeric Hymn 29 lines 1-6 describes Hestia’s honored seat and first-and-last libation.','homeric_hymn.29.1-6','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','RITUAL_PRACTICE','Homeric Hymn 29','Hymn 29, lines 1-6','A poetic witness to ritual meaning, not a claim that all Greek practice was uniform.','2026-08-14T00:00:00Z'),
('claim.v040.hestia.represents_hearth','deity.greek.hestia','REPRESENTS','concept.comparative.hearth',NULL,NULL,'The comparative index connects Hestia with the hearth while retaining her Greek ritual meanings.','homeric_hymn.29','SUPPORTED',0.94,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Comparative navigation','Hymn 29, lines 1-6','Navigation edge only; not identity with every hearth tradition.','2026-08-14T00:00:00Z'),
('claim.v040.helios.appears_hymn31','deity.greek.helios','APPEARS_IN','text.greek.homeric_hymn_helios_31',NULL,NULL,'Helios is the principal subject of Homeric Hymn 31.','homeric_hymn.31','SUPPORTED',1.0,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 31','Hymn 31, lines 1-15a',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.helios.chariot_hymn31','deity.greek.helios','ATTRIBUTE',NULL,'radiant deity driving a golden-yoked chariot drawn by stallions','text','Homeric Hymn 31 lines 1-15a describes Helios’s radiance, clothing, horses and chariot.','homeric_hymn.31','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Homeric Hymn 31','Hymn 31, lines 1-15a','Description belongs to this hymn witness.','2026-08-14T00:00:00Z'),
('claim.v040.selene.appears_hymn32','deity.greek.selene','APPEARS_IN','text.greek.homeric_hymn_selene_32',NULL,NULL,'Selene is the principal subject of Homeric Hymn 32.','homeric_hymn.32','SUPPORTED',1.0,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 32','Hymn 32, lines 1-20',NULL,'2026-08-14T00:00:00Z'),
('claim.v040.selene.chariot_hymn32','deity.greek.selene','ATTRIBUTE',NULL,'radiant goddess driving shining horses and serving as a monthly sign','text','Homeric Hymn 32 lines 1-20 describes Selene’s radiance, horses and monthly sign.','homeric_hymn.32','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Homeric Hymn 32','Hymn 32, lines 1-20','Description belongs to this hymn witness.','2026-08-14T00:00:00Z'),
('claim.v040.helios.appears_hymn2','deity.greek.helios','APPEARS_IN','text.greek.homeric_hymn_demeter',NULL,NULL,'Homeric Hymn 2 names Helios as a witness sought by Demeter.','homeric_hymn.2.25-62','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn to Demeter','Hymn 2, lines 25-62',NULL,'2026-08-14T00:00:00Z');

INSERT OR IGNORE INTO evidence(
  id,claim_id,source_id,source_location,chapter,verse,line,page,catalogue_number,
  short_quote,evidence_type,direction,strength,research_notes
)
SELECT
  'evidence.' || substr(id,7),
  id,
  CASE
    WHEN id LIKE 'claim.v040.hecate.%hymn2' OR id='claim.v040.hecate.role_hymn2' OR id='claim.v040.helios.appears_hymn2'
      THEN 'source.greek.homeric_hymn_demeter.scaife'
    WHEN id LIKE 'claim.v040.hestia.%hymn29' OR id='claim.v040.hestia.represents_hearth'
      THEN 'source.greek.homeric_hymn_hestia29.scaife'
    WHEN id LIKE 'claim.v040.helios.%hymn31'
      THEN 'source.greek.homeric_hymn_helios31.scaife'
    WHEN id LIKE 'claim.v040.selene.%hymn32' OR id='claim.v040.selene.represents_moon'
      THEN 'source.greek.homeric_hymn_selene32.scaife'
    ELSE 'source.greek.theogony.perseus_eng1'
  END,
  temporal_scope,
  CASE
    WHEN id LIKE '%hymn2' THEN 'Homeric Hymn 2 to Demeter'
    WHEN id LIKE '%hymn29' OR id='claim.v040.hestia.represents_hearth' THEN 'Homeric Hymn 29 to Hestia'
    WHEN id LIKE '%hymn31' THEN 'Homeric Hymn 31 to Helios'
    WHEN id LIKE '%hymn32' OR id='claim.v040.selene.represents_moon' THEN 'Homeric Hymn 32 to Selene'
    ELSE 'Theogony'
  END,
  NULL,
  CASE
    WHEN id LIKE 'claim.v040.chaos.%' THEN '116-125'
    WHEN id LIKE 'claim.v040.nyx.child_%' OR id LIKE 'claim.v040.erebus.%' OR id LIKE 'claim.v040.aether.%' OR id LIKE 'claim.v040.hemera.%' OR id='claim.v040.nyx.represents_night' THEN '123-125'
    WHEN id LIKE 'claim.v040.hyperion.child_%' OR id LIKE 'claim.v040.theia.child_%' THEN '133-136'
    WHEN id LIKE 'claim.v040.thanatos.%' OR id LIKE 'claim.v040.hypnos.%' THEN '211-225'
    WHEN id LIKE 'claim.v040.hyperion.parent_%' OR id LIKE 'claim.v040.theia.parent_%' OR id LIKE 'claim.v040.helios.sibling_%' OR id LIKE 'claim.v040.selene.sibling_%' OR id='claim.v040.eos.mentioned_theogony' OR id='claim.v040.helios.represents_sun' THEN '371-374'
    WHEN id LIKE 'claim.v040.asteria.%' OR id LIKE 'claim.v040.perses.%' THEN '404-409'
    WHEN id='claim.v040.hecate.mentioned_theogony' THEN '404-452'
    WHEN id='claim.v040.hecate.domain_theogony' THEN '411-452'
    WHEN id LIKE 'claim.v040.hestia.child_%' OR id LIKE 'claim.v040.hestia.sibling_%' THEN '453-458'
    WHEN id='claim.v040.hestia.honors_hymn29' OR id='claim.v040.hestia.represents_hearth' THEN '1-6'
    WHEN id='claim.v040.hestia.appears_hymn29' THEN '1-14'
    WHEN id LIKE 'claim.v040.hecate.%hymn2' OR id='claim.v040.hecate.role_hymn2' OR id='claim.v040.helios.appears_hymn2' THEN '25-62'
    WHEN id LIKE 'claim.v040.helios.%hymn31' THEN '1-15a'
    WHEN id LIKE 'claim.v040.selene.%hymn32' OR id='claim.v040.selene.represents_moon' THEN '1-20'
    ELSE NULL
  END,
  NULL,
  CASE
    WHEN id LIKE '%hymn2' OR id='claim.v040.hecate.role_hymn2' OR id='claim.v040.helios.appears_hymn2' THEN 'urn:cts:greekLit:tlg0013.tlg002.perseus-eng2'
    WHEN id LIKE '%hymn29' OR id='claim.v040.hestia.represents_hearth' THEN 'urn:cts:greekLit:tlg0013.tlg029.perseus-eng2'
    WHEN id LIKE '%hymn31' THEN 'urn:cts:greekLit:tlg0013.tlg031.perseus-eng2'
    WHEN id LIKE '%hymn32' OR id='claim.v040.selene.represents_moon' THEN 'urn:cts:greekLit:tlg0013.tlg032.perseus-grc2'
    ELSE 'urn:cts:greekLit:tlg0020.tlg001.perseus-eng1'
  END,
  NULL,
  'PRIMARY_TEXT','SUPPORTS',
  CASE WHEN assertion_scope='SCHOLARLY_INTERPRETATION' THEN 0.85 ELSE 0.98 END,
  'Exact line group checked against the registered Perseus/Scaife digital text on 2026-08-14; no long modern translation excerpt is republished.'
FROM claims
WHERE id LIKE 'claim.v040.%';

INSERT OR IGNORE INTO collection_queue(
  id,target_label,normalized_label,proposed_entity_type,civilization_id,
  discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,
  discovery_context,priority,status,attempts,last_error,next_action,created_at,updated_at
) VALUES
('queue.greek.v040.community_feedback_gaps','Greek deity gaps raised by public community feedback','greek deity gaps raised by public community feedback','DEITY','civ.greek',NULL,NULL,NULL,'Public feedback identified Thanatos, Hypnos, Nyx, Hecate, Selene, Helios and Hestia as missing. The comment is a discovery lead only and is not used as scholarly evidence.',98,'PARTIAL',1,NULL,'Continue comparing community-reported omissions against primary-text and archaeological evidence before adding claims','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('queue.greek.v040.hecate_later_layers','Hecate later magic, crossroads and underworld layers','hecate later magic crossroads and underworld layers','DEITY','civ.greek','deity.greek.hecate','claim.v040.hecate.mentioned_theogony','source.greek.theogony.perseus_eng1','The early Hesiodic and Hymn-to-Demeter baseline exposes later historical layers that must be separately dated and sourced.',97,'SOURCE_FOUND',0,NULL,'Add dated literary, epigraphic, archaeological and cult layers without projecting them backward into Hesiod','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('queue.greek.v040.nyx_extended_children','Nyx extended Hesiodic genealogy and later variants','nyx extended hesiodic genealogy and later variants','DEITY','civ.greek','deity.greek.nyx','claim.v040.thanatos.child_nyx','source.greek.theogony.perseus_eng1','Thanatos and Hypnos expose the larger catalogue of Nyx’s children and later variants.',94,'SOURCE_FOUND',0,NULL,'Add the remaining children as separate entities and preserve witness-level variant genealogies','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('queue.greek.v040.hestia_cult','Hestia cult, civic hearths and inscriptions','hestia cult civic hearths and inscriptions','RITUAL','civ.greek','deity.greek.hestia','claim.v040.hestia.honors_hymn29','source.greek.homeric_hymn_hestia29.scaife','The hymn’s libation language requires comparison with inscriptions, civic hearths and archaeological contexts.',93,'SOURCE_FOUND',0,NULL,'Collect epigraphic and archaeological evidence with place-specific dates and catalogue numbers','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('queue.greek.v040.celestial_variants','Helios, Selene and Eos later genealogies and identifications','helios selene and eos later genealogies and identifications','CONCEPT','civ.greek','deity.greek.helios','claim.v040.helios.sibling_selene','source.greek.theogony.perseus_eng1','The Hesiodic sibling group opens later Apollo/Artemis identifications and variant genealogies that must not be auto-merged.',92,'NEEDS_REVIEW',0,NULL,'Add dated identity candidates and competing claims from individually registered witnesses','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('queue.greek.v040.perses_identity','Perses homonym and Hecate genealogy witness audit','perses homonym and hecate genealogy witness audit','DEITY','civ.greek','deity.greek.perses','claim.v040.perses.parent_hecate','source.greek.theogony.perseus_eng1','The Hecate genealogy contains a name shared by multiple Greek figures; automatic merging is unsafe.',99,'CONFLICT',0,NULL,'Collate Perses entities, parentage and ancient witnesses before creating any identity relation','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z');

INSERT OR IGNORE INTO queue_discoveries(
  id,queue_id,discovered_from_entity_id,discovered_from_claim_id,
  discovered_from_source_id,discovery_context,discovered_at
) VALUES
('discovery.20260814.public_greek_feedback','queue.greek.v040.community_feedback_gaps',NULL,NULL,NULL,'Public Threads feedback from @lune_limen exposed a measurable coverage gap. It is retained only as provenance for target discovery, never as evidence for mythological claims.','2026-08-14T00:00:00Z'),
('discovery.20260814.hecate_layers','queue.greek.v040.hecate_later_layers','deity.greek.hecate','claim.v040.hecate.domain_theogony','source.greek.theogony.perseus_eng1','Early source scope shows why later magical layers need separate dates and evidence.','2026-08-14T00:00:00Z'),
('discovery.20260814.nyx_children','queue.greek.v040.nyx_extended_children','deity.greek.nyx','claim.v040.thanatos.child_nyx','source.greek.theogony.perseus_eng1','The Nyx genealogy continues beyond the two community-requested children.','2026-08-14T00:00:00Z'),
('discovery.20260814.hestia_cult','queue.greek.v040.hestia_cult','deity.greek.hestia','claim.v040.hestia.honors_hymn29','source.greek.homeric_hymn_hestia29.scaife','Poetic ritual language creates an archaeological and epigraphic follow-up target.','2026-08-14T00:00:00Z'),
('discovery.20260814.celestial_variants','queue.greek.v040.celestial_variants','deity.greek.helios','claim.v040.helios.sibling_selene','source.greek.theogony.perseus_eng1','Sibling genealogy exposes later identity and reception questions.','2026-08-14T00:00:00Z'),
('discovery.20260814.perses_identity','queue.greek.v040.perses_identity','deity.greek.perses','claim.v040.perses.parent_hecate','source.greek.theogony.perseus_eng1','Homonymous Perses figures require witness-level identity review.','2026-08-14T00:00:00Z');

INSERT OR IGNORE INTO queue_status_history(id,queue_id,old_status,new_status,changed_at,reason) VALUES
('qhist.20260814.community_feedback','queue.greek.v040.community_feedback_gaps','DISCOVERED','PARTIAL','2026-08-14T00:00:00Z','Seven requested entities and their first-ring genealogy were added with primary-text evidence; broader coverage remains open'),
('qhist.20260814.hecate_layers','queue.greek.v040.hecate_later_layers','DISCOVERED','SOURCE_FOUND','2026-08-14T00:00:00Z','Early textual baseline established; later layers queued separately'),
('qhist.20260814.nyx_children','queue.greek.v040.nyx_extended_children','DISCOVERED','SOURCE_FOUND','2026-08-14T00:00:00Z','Primary source located; expansion deliberately continues'),
('qhist.20260814.hestia_cult','queue.greek.v040.hestia_cult','DISCOVERED','SOURCE_FOUND','2026-08-14T00:00:00Z','Hymn source registered; archaeological and epigraphic work remains'),
('qhist.20260814.celestial_variants','queue.greek.v040.celestial_variants','DISCOVERED','NEEDS_REVIEW','2026-08-14T00:00:00Z','Later identifications must be dated and must not become automatic merges'),
('qhist.20260814.perses_identity','queue.greek.v040.perses_identity','DISCOVERED','CONFLICT','2026-08-14T00:00:00Z','Homonym requires witness-level identity review');

INSERT OR IGNORE INTO research_sessions(
  id,started_at,ended_at,scope,strategy,status,agent_or_process,notes
) VALUES(
  'research.20260814.v040_greek_genealogy','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z',
  'Community-requested Greek deity gap, first-ring genealogy, Homeric Hymns 2/29/31/32 and family-graph baseline',
  'Treat community feedback as discovery only; verify all claims against primary digital texts; preserve source layers and unresolved identities',
  'CHECKPOINT_COMPLETE','Codex research and data pipeline',
  'Expandable staged baseline only. Hecate later layers, Nyx extended genealogy, cult evidence and Perses identity remain in the permanent queue.'
);

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result)
SELECT 'research.20260814.v040_greek_genealogy','ENTITY',id,'CREATE','SOURCE_BACKED_BASELINE'
FROM entities
WHERE id IN (
  'deity.greek.chaos','deity.greek.nyx','deity.greek.erebus','deity.greek.aether','deity.greek.hemera',
  'deity.greek.thanatos','deity.greek.hypnos','deity.greek.hyperion','deity.greek.theia','deity.greek.helios',
  'deity.greek.selene','deity.greek.eos','deity.greek.asteria','deity.greek.perses','deity.greek.hecate','deity.greek.hestia'
);

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result) VALUES
('research.20260814.v040_greek_genealogy','SOURCE','source.greek.homeric_hymn_demeter.scaife','REGISTER','URL_SYNTAX_VALID_WITH_EXACT_LOCATOR'),
('research.20260814.v040_greek_genealogy','SOURCE','source.greek.homeric_hymn_hestia29.scaife','REGISTER','URL_SYNTAX_VALID_WITH_EXACT_LOCATOR'),
('research.20260814.v040_greek_genealogy','SOURCE','source.greek.homeric_hymn_helios31.scaife','REGISTER','URL_SYNTAX_VALID_WITH_EXACT_LOCATOR'),
('research.20260814.v040_greek_genealogy','SOURCE','source.greek.homeric_hymn_selene32.scaife','REGISTER','URL_SYNTAX_VALID_WITH_EXACT_LOCATOR'),
('research.20260814.v040_greek_genealogy','QUEUE','queue.greek.v040.community_feedback_gaps','EXPAND','PARTIAL'),
('research.20260814.v040_greek_genealogy','QUEUE','queue.greek.v040.hecate_later_layers','DISCOVER','SOURCE_FOUND'),
('research.20260814.v040_greek_genealogy','QUEUE','queue.greek.v040.perses_identity','DISCOVER','CONFLICT_RETAINED');

UPDATE project_metadata
SET value='0.4.0-greek-genealogy-20260814',updated_at='2026-08-14T00:00:00Z'
WHERE key='data_version';
UPDATE project_metadata
SET value='5',updated_at='2026-08-14T00:00:00Z'
WHERE key='schema_version';
UPDATE project_metadata
SET value='2026-08-14T00:00:00Z',updated_at='2026-08-14T00:00:00Z'
WHERE key='generated_at';

INSERT OR IGNORE INTO dataset_releases(
  id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes
) VALUES(
  'release.0.4.0',5,'0.4.0-greek-genealogy-20260814',NULL,'2026-08-14T00:00:00Z',NULL,
  'Community-responsive Greek genealogy checkpoint: 16 deities/primordial figures, four Homeric Hymn subworks, comparative navigation concepts, fifty source-located claims, permanent follow-up queue and genealogy-ready graph data.'
);

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(5,'20260814_v040_greek_genealogy_and_primary_text_layers','2026-08-14T00:00:00Z');

COMMIT;
