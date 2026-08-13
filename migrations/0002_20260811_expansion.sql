BEGIN IMMEDIATE;

-- Research checkpoint 2026-08-11: Greek Typhon/Metis, Norse genealogy and
-- smiths, and early Chinese wuxing textual locations.  The migration is
-- intentionally additive and idempotence is provided by schema_migrations.

INSERT OR IGNORE INTO entity_types(code,label_en,label_zh,parent_code,description)
VALUES('DWARF','Dwarf','矮人／侏儒','CREATURE','Culture-specific small supernatural smith or being; do not equate globally by size alone.');

INSERT OR IGNORE INTO sources(
  id,title,original_title,source_type,evidence_tier,institution,author_or_editor,
  language_id,publication_date,accessed_date,url,stable_url,doi,isbn,catalogue_number,
  manuscript_number,rights_status,source_perspective,community_or_lineage,
  collector_context,living_tradition,access_or_reuse_restrictions,
  community_permission_required,same_witness_as_source_id,translation_status,
  verification_status,notes
) VALUES
('source.greek.theogony.perseus_eng1','Hesiod, Theogony, Evelyn-White English text','Θεογονία','PRIMARY_TEXT_DIGITAL_EDITION',2,'Perseus Digital Library, Tufts University','Hesiod; Hugh G. Evelyn-White (translator)','lang.en','1914','2026-08-11','https://www.perseus.tufts.edu/hopper/text?doc=Perseus%3Atext%3A1999.01.0130','http://data.perseus.org/texts/urn:cts:greekLit:tlg0020.tlg001.perseus-eng1',NULL,NULL,'urn:cts:greekLit:tlg0020.tlg001.perseus-eng1',NULL,'CC BY-SA 3.0 US for the Perseus presentation','Ancient Greek poem through a 1914 English translation',NULL,'Digitized scholarly edition; narrative claims remain claims about the text',0,'Observe Perseus attribution and share-alike terms',0,'source.greek.theogony.scaife','English translation of ancient Greek','URL_SYNTAX_VALID','Exact line groups 820-852, 853-885 and 886-900 checked on 2026-08-11.'),
('source.norse.gylfaginning.vsnr2005','Snorri Sturluson: Edda. Prologue and Gylfaginning','Edda: Prologue and Gylfaginning','MEDIEVAL_TEXT_SCHOLARLY_EDITION',3,'Viking Society for Northern Research / University College London','Anthony Faulkes (editor)','lang.non','2005','2026-08-11','https://vsnr.org/editions/snorri-sturluson-edda-prologue-and-gylfaginning/',NULL,NULL,'9780903521642',NULL,NULL,'Edition metadata page; edition copyright applies','Thirteenth-century Icelandic Christian-era compilation in manuscript transmission',NULL,'VSNR scholarly edition, second edition',0,'Do not reproduce substantial modern editorial matter',0,NULL,'Old Norse edition; modern editorial apparatus','URL_SYNTAX_VALID','Official VSNR edition page verified 2026-08-11; claims cite chapter locations and the registered Faulkes translation source.'),
('source.norse.skaldskaparmal.vsnr1998','Snorri Sturluson: Edda. Skáldskaparmál','Edda: Skáldskaparmál','MEDIEVAL_TEXT_SCHOLARLY_EDITION',3,'Viking Society for Northern Research / University College London','Anthony Faulkes (editor)','lang.non','1998','2026-08-11','https://vsnr.org/editions/snorri-sturluson-edda-skaldskaparmal/',NULL,NULL,'9780903521345',NULL,NULL,'Edition metadata page; edition copyright applies','Thirteenth-century Icelandic poetic handbook in manuscript transmission',NULL,'Two-volume VSNR scholarly edition',0,'Do not reproduce substantial modern editorial matter',0,NULL,'Old Norse edition with modern apparatus','URL_SYNTAX_VALID','Official VSNR edition page verified 2026-08-11; forging episode located at Skáldskaparmál 35 in common chapter numbering.'),
('source.china.hong_fan.ctext','Shang Shu, Zhou Documents, Hong Fan','尚書·周書·洪範','PRIMARY_TEXT_DIGITAL_EDITION',2,'Chinese Text Project','Received-text tradition; digital edition by Chinese Text Project','lang.lzh',NULL,'2026-08-11','https://ctext.org/shang-shu/great-plan/zh','urn:ctp:shang-shu/great-plan',NULL,NULL,'ctp:shang-shu/great-plan',NULL,'Site terms apply; ancient text is public-domain cultural heritage','Received text with Legge translation and digital alignment',NULL,'Digital scholarly library',0,'No bulk copying; cite the page and verify edition metadata',0,NULL,'Classical Chinese with English alignment','URL_SYNTAX_VALID','Exact Hong Fan wuxing paragraph found through the CTP page on 2026-08-11.'),
('source.china.han_shu.wuxing_zhi.ctext','Han Shu, Treatise on the Five Phases, first part','漢書·五行志上','PRIMARY_TEXT_DIGITAL_EDITION',2,'Chinese Text Project','Ban Gu tradition; digital edition by Chinese Text Project','lang.lzh',NULL,'2026-08-11','https://ctext.org/han-shu/wu-xing-zhi-shang','urn:ctp:han-shu/wu-xing-zhi-shang',NULL,NULL,'ctp:han-shu/wu-xing-zhi-shang',NULL,'Site terms apply; ancient text is public-domain cultural heritage','Eastern Han historiographical treatise preserving interpretive traditions',NULL,'Digital scholarly library',0,'No bulk copying; cite the page and verify edition metadata',0,NULL,'Classical Chinese with digital alignment','URL_SYNTAX_VALID','Exact opening quotation of the five xing located through CTP on 2026-08-11.');

INSERT OR IGNORE INTO entities(
  id,canonical_name,name_zh,original_name,transliteration,primary_type,
  primary_civilization_id,primary_culture_id,primary_region_id,historical_period,
  description,research_status,evidence_status,record_version,metadata_json,created_at,updated_at
) VALUES
('creature.greek.typhon','Typhon','提丰',NULL,'Typhōn','MONSTER','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Serpentine multi-voiced opponent of Zeus in Hesiod; later variants must remain separately sourced.','PARTIAL','PARTIAL',1,'{"variant_caution":"Do not auto-merge Typhon, Typhoeus and Typhaon across witnesses."}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('deity.greek.metis','Metis','墨提斯','Μῆτις','Mētis','DEITY','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Figure of wisdom in Hesiod, first consort of Zeus and mother of Athena in that witness.','PARTIAL','PARTIAL',1,'{}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('realm.greek.tartarus','Tartarus','塔耳塔罗斯','Τάρταρος','Tartaros','REALM','civ.greek',NULL,NULL,'Archaic Greek textual tradition','Mythic underworld depth and personified progenitor in some Greek genealogical passages.','PARTIAL','PARTIAL',1,'{"reality_status":"MYTHICAL"}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('event.greek.zeus_typhon_battle','Battle of Zeus and Typhon','宙斯与提丰之战',NULL,NULL,'EVENT','civ.greek',NULL,NULL,'Mythic time','Combat narrated in Hesiod Theogony 820-868.','PARTIAL','PARTIAL',1,'{}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('deity.norse.buri','Búri','布里','Búri','Búri','ANCESTOR_DEITY','civ.norse',NULL,NULL,'Medieval Icelandic textual witness','Ancestor licked free from rime by Auðhumla in Gylfaginning.','PARTIAL','PARTIAL',1,'{}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('deity.norse.borr','Borr','博尔','Borr','Borr','DEITY','civ.norse',NULL,NULL,'Medieval Icelandic textual witness','Son of Búri and father of Odin, Vili and Vé in Gylfaginning.','PARTIAL','PARTIAL',1,'{}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('being.norse.bestla','Bestla','贝斯特拉','Bestla','Bestla','GIANT','civ.norse',NULL,NULL,'Medieval Icelandic textual witness','Daughter of Bölþorn and mother of Odin, Vili and Vé in Gylfaginning.','PARTIAL','PARTIAL',1,'{}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('deity.norse.vili','Vili','维利','Vili','Vili','DEITY','civ.norse',NULL,NULL,'Medieval Icelandic textual witness','Brother of Odin and Vé; participates in cosmogonic acts in Gylfaginning.','PARTIAL','PARTIAL',1,'{}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('deity.norse.ve','Vé','维','Vé','Vé','DEITY','civ.norse',NULL,NULL,'Medieval Icelandic textual witness','Brother of Odin and Vili; participates in cosmogonic acts in Gylfaginning.','PARTIAL','PARTIAL',1,'{}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('being.norse.mimir','Mímir','密米尔','Mímir','Mímir','CREATURE','civ.norse',NULL,NULL,'Eddic and medieval Icelandic witnesses','Wisdom figure associated with Mímisbrunnr; ontological class remains under review.','PARTIAL','PARTIAL',1,'{"classification_caution":"Source roles do not justify a forced universal species label."}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('place.norse.mimisbrunnr','Mímisbrunnr','密米尔之泉','Mímisbrunnr','Mímisbrunnr','MYTHICAL_PLACE','civ.norse',NULL,NULL,'Eddic and medieval Icelandic witnesses','Wisdom well beneath a root of Yggdrasil in Gylfaginning.','PARTIAL','PARTIAL',1,'{"reality_status":"MYTHICAL"}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('being.norse.brokkr','Brokkr','布洛克','Brokkr','Brokkr','DWARF','civ.norse',NULL,NULL,'Medieval Icelandic textual witness','Dwarf smith who works the bellows in the treasure-forging episode.','PARTIAL','PARTIAL',1,'{}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('being.norse.eitri','Eitri','艾特里','Eitri','Eitri','DWARF','civ.norse',NULL,NULL,'Medieval Icelandic textual witness','Dwarf smith named as Brokkr’s brother in one common naming tradition.','PARTIAL','PARTIAL',1,'{"identity_caution":"Kept separate from Sindri pending witness-specific review."}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('being.norse.sindri','Sindri','辛德里','Sindri','Sindri','DWARF','civ.norse',NULL,NULL,'Eddic and later naming traditions','Name associated in later/reference traditions with Brokkr’s smith brother; not automatically merged with Eitri.','NEEDS_REVIEW','CONFLICTING',1,'{"identity_caution":"Candidate identity with Eitri, not canonical alias."}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('creature.norse.gullinbursti','Gullinbursti','金鬃野猪','Gullinbursti','Gullinbursti','DIVINE_BEAST','civ.norse',NULL,NULL,'Medieval Icelandic textual witness','Golden-bristled boar produced in the smithing contest and given to Freyr.','PARTIAL','PARTIAL',1,'{"hybrid_classification":["DIVINE_BEAST","ARTIFACT"]}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('event.norse.forging_divine_treasures','Forging of the divine treasures','诸神宝物锻造',NULL,NULL,'EVENT','civ.norse',NULL,NULL,'Mythic narrative preserved in medieval text','Smithing contest that produces Gullinbursti, Draupnir and Mjölnir.','PARTIAL','PARTIAL',1,'{}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('text.chinese.shang_shu','Shang Shu','尚书','尚書','Shàngshū','TEXT','civ.chinese_ancient',NULL,NULL,'Layered received textual tradition','Book of Documents; chapter-level dating and witness history must remain explicit.','PARTIAL','PARTIAL',1,'{}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('text.chinese.hong_fan','Hong Fan','洪范','洪範','Hóngfàn','TEXT','civ.chinese_ancient',NULL,NULL,'Received chapter within Shang Shu','Great Plan chapter containing an early received formulation of the five xing.','PARTIAL','PARTIAL',1,'{"parent_work":"text.chinese.shang_shu"}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('text.chinese.han_shu_wuxing_zhi','Han Shu: Wuxing Zhi','汉书·五行志','漢書·五行志','Hànshū Wǔxíngzhì','TEXT','civ.chinese_ancient',NULL,NULL,'Eastern Han historiographical compilation','Treatise that quotes and develops earlier five-xing frameworks in omen historiography.','PARTIAL','PARTIAL',1,'{}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('concept.chinese.wuxing.shui','Shui (wuxing)','五行之水','水','shuǐ','ELEMENT','civ.chinese_ancient',NULL,NULL,'Early Chinese received textual tradition','Water as a native member of the wuxing system, preserving Hong Fan wording and sequence.','PARTIAL','PARTIAL',1,'{"native_system":"concept.chinese.wuxing"}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('concept.chinese.wuxing.huo','Huo (wuxing)','五行之火','火','huǒ','ELEMENT','civ.chinese_ancient',NULL,NULL,'Early Chinese received textual tradition','Fire as a native member of the wuxing system.','PARTIAL','PARTIAL',1,'{"native_system":"concept.chinese.wuxing"}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('concept.chinese.wuxing.mu','Mu (wuxing)','五行之木','木','mù','ELEMENT','civ.chinese_ancient',NULL,NULL,'Early Chinese received textual tradition','Wood as a native member of the wuxing system.','PARTIAL','PARTIAL',1,'{"native_system":"concept.chinese.wuxing"}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('concept.chinese.wuxing.jin','Jin (wuxing)','五行之金','金','jīn','ELEMENT','civ.chinese_ancient',NULL,NULL,'Early Chinese received textual tradition','Metal as a native member of the wuxing system.','PARTIAL','PARTIAL',1,'{"native_system":"concept.chinese.wuxing"}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('concept.chinese.wuxing.tu','Tu (wuxing)','五行之土','土','tǔ','ELEMENT','civ.chinese_ancient',NULL,NULL,'Early Chinese received textual tradition','Earth/soil as a native member of the wuxing system.','PARTIAL','PARTIAL',1,'{"native_system":"concept.chinese.wuxing"}','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z');

INSERT OR IGNORE INTO entity_classifications(entity_id,type_code,is_primary,notes)
SELECT id,primary_type,1,'Primary classification at research checkpoint 2026-08-11'
FROM entities WHERE id IN (
 'creature.greek.typhon','deity.greek.metis','realm.greek.tartarus','event.greek.zeus_typhon_battle',
 'deity.norse.buri','deity.norse.borr','being.norse.bestla','deity.norse.vili','deity.norse.ve',
 'being.norse.mimir','place.norse.mimisbrunnr','being.norse.brokkr','being.norse.eitri','being.norse.sindri',
 'creature.norse.gullinbursti','event.norse.forging_divine_treasures','text.chinese.shang_shu',
 'text.chinese.hong_fan','text.chinese.han_shu_wuxing_zhi','concept.chinese.wuxing.shui',
 'concept.chinese.wuxing.huo','concept.chinese.wuxing.mu','concept.chinese.wuxing.jin','concept.chinese.wuxing.tu'
);
INSERT OR IGNORE INTO entity_classifications VALUES('being.norse.brokkr','CREATURE',0,'DWARF is nested under CREATURE');
INSERT OR IGNORE INTO entity_classifications VALUES('being.norse.eitri','CREATURE',0,'DWARF is nested under CREATURE');
INSERT OR IGNORE INTO entity_classifications VALUES('being.norse.sindri','CREATURE',0,'DWARF is nested under CREATURE');
INSERT OR IGNORE INTO entity_classifications VALUES('creature.norse.gullinbursti','ARTIFACT',0,'Crafted living being in Skáldskaparmál; retain both classes');

INSERT OR IGNORE INTO entity_civilizations(entity_id,civilization_id,association_role,certainty,notes)
SELECT id,primary_civilization_id,'ORIGIN','SUPPORTED','Text-tradition association, not historical existence'
FROM entities WHERE id IN (
 'creature.greek.typhon','deity.greek.metis','realm.greek.tartarus','event.greek.zeus_typhon_battle',
 'deity.norse.buri','deity.norse.borr','being.norse.bestla','deity.norse.vili','deity.norse.ve',
 'being.norse.mimir','place.norse.mimisbrunnr','being.norse.brokkr','being.norse.eitri','being.norse.sindri',
 'creature.norse.gullinbursti','event.norse.forging_divine_treasures','text.chinese.shang_shu',
 'text.chinese.hong_fan','text.chinese.han_shu_wuxing_zhi','concept.chinese.wuxing.shui',
 'concept.chinese.wuxing.huo','concept.chinese.wuxing.mu','concept.chinese.wuxing.jin','concept.chinese.wuxing.tu'
);

INSERT OR IGNORE INTO deity_profiles(entity_id,deity_class,pantheon_or_family,rank_or_status,domains_json,powers_json,limitations_json,appearance_json,symbols_json,cult_summary,final_fate_summary) VALUES
('deity.greek.metis','Goddess','Greek divine genealogy','First consort of Zeus in Hesiod','["wisdom","counsel"]','[]','[]','{}','[]',NULL,'Swallowed by Zeus in Hesiod’s narrative'),
('deity.norse.buri','Ancestor deity','Norse divine genealogy','Ancestor','[]','[]','[]','{}','[]',NULL,NULL),
('deity.norse.borr','Genealogical deity','Norse divine genealogy','Father of Odin, Vili and Vé','[]','[]','[]','{}','[]',NULL,NULL),
('deity.norse.vili','Cosmogonic deity','Norse divine genealogy','Brother of Odin','["cosmogony"]','[]','[]','{}','[]',NULL,NULL),
('deity.norse.ve','Cosmogonic deity','Norse divine genealogy','Brother of Odin','["cosmogony"]','[]','[]','{}','[]',NULL,NULL);

INSERT OR IGNORE INTO creature_profiles(entity_id,creature_class,appearance_json,abilities_json,weaknesses_json,habitat_summary,origin_summary,fate_summary) VALUES
('creature.greek.typhon','MONSTER','{"heads":"one hundred serpent heads in Hesiod 824-835","features":["flashing fire","many voices"]}','["immense strength","fire","terrifying voices"]','[]',NULL,'Child of Gaia and Tartarus in Hesiod','Defeated by Zeus and cast into Tartarus in Hesiod'),
('being.norse.bestla','GIANT','{}','[]','[]',NULL,'Daughter of Bölþorn in Gylfaginning',NULL),
('being.norse.mimir','UNRESOLVED_SUPERNATURAL_BEING','{}','["wisdom","counsel"]','[]','Mímisbrunnr association',NULL,NULL),
('being.norse.brokkr','DWARF','{}','["smithing"]','[]','Smithy in Skáldskaparmál episode',NULL,NULL),
('being.norse.eitri','DWARF','{}','["smithing"]','[]','Smithy in Skáldskaparmál episode',NULL,NULL),
('being.norse.sindri','DWARF','{}','["smithing"]','[]',NULL,NULL,NULL),
('creature.norse.gullinbursti','DIVINE_BEAST','{"bristles":"golden"}','["shines in darkness"]','[]',NULL,'Forged in the treasure contest','Given to Freyr in the narrative');

INSERT OR IGNORE INTO myth_event_profiles(entity_id,event_type,time_layer,cause_summary,process_summary,result_summary,symbolism_summary) VALUES
('event.greek.zeus_typhon_battle','DIVINE_CONFLICT','Mythic time','Typhon threatens divine and mortal rule','Zeus attacks with thunder, lightning and thunderbolt','Typhon is defeated and cast into Tartarus',NULL),
('event.norse.forging_divine_treasures','ARTIFACT_CREATION','Mythic time','Loki’s wager concerning smithcraft','Brokkr tends the bellows while the smith produces three treasures','Gullinbursti, Draupnir and Mjölnir are presented to the gods',NULL);

INSERT OR IGNORE INTO text_profiles(entity_id,text_type,original_language_id,attributed_author,compiler,composition_period,earliest_extant_witness,chapter_structure,repository,shelfmark,copyright_status,summary) VALUES
('text.chinese.shang_shu','RECEIVED_CLASSIC','lang.lzh',NULL,'Layered received compilation','Multiple textual layers; do not assign a single date',NULL,'Canon includes Zhou Documents and Hong Fan',NULL,NULL,'Ancient text public domain; digital edition terms vary','Documents and speeches transmitted in received and excavated traditions.'),
('text.chinese.hong_fan','CHAPTER','lang.lzh',NULL,NULL,'Received chapter with complex dating history',NULL,'Section within Zhou Documents',NULL,NULL,'Ancient text public domain; digital edition terms vary','Enumerates nine divisions including the five xing and their dispositions.'),
('text.chinese.han_shu_wuxing_zhi','HISTORIOGRAPHICAL_TREATISE','lang.lzh','Ban Gu tradition','Eastern Han court historiographical compilation','Eastern Han',NULL,'Treatise on wuxing, multiple parts',NULL,NULL,'Ancient text public domain; digital edition terms vary','Develops omen-historical readings of the five xing and quotes earlier formulations.');

INSERT OR IGNORE INTO names(id,entity_id,name_text,normalized_text,language_id,script_name,name_type,transliteration_scheme,is_preferred,source_id,notes) VALUES
('name.typhon.typhoeus','creature.greek.typhon','Typhoeus','typhoeus','lang.en','Latin','ALIAS',NULL,0,'source.greek.theogony.perseus_eng1','Evelyn-White form in the cited passage; Typhaon remains a separate research problem'),
('name.metis.grc','deity.greek.metis','Μῆτις','μῆτις','lang.grc','Greek','ORIGINAL',NULL,1,'source.greek.theogony.perseus_eng1',NULL),
('name.buri.non','deity.norse.buri','Búri','búri','lang.non','Latin','ORIGINAL',NULL,1,'source.norse.gylfaginning.vsnr2005',NULL),
('name.borr.non','deity.norse.borr','Borr','borr','lang.non','Latin','ORIGINAL',NULL,1,'source.norse.gylfaginning.vsnr2005',NULL),
('name.bestla.non','being.norse.bestla','Bestla','bestla','lang.non','Latin','ORIGINAL',NULL,1,'source.norse.gylfaginning.vsnr2005',NULL),
('name.vili.non','deity.norse.vili','Vili','vili','lang.non','Latin','ORIGINAL',NULL,1,'source.norse.gylfaginning.vsnr2005',NULL),
('name.ve.non','deity.norse.ve','Vé','vé','lang.non','Latin','ORIGINAL',NULL,1,'source.norse.gylfaginning.vsnr2005',NULL),
('name.mimir.non','being.norse.mimir','Mímir','mímir','lang.non','Latin','ORIGINAL',NULL,1,'source.norse.gylfaginning.vsnr2005',NULL),
('name.mimisbrunnr.non','place.norse.mimisbrunnr','Mímisbrunnr','mímisbrunnr','lang.non','Latin','ORIGINAL',NULL,1,'source.norse.gylfaginning.vsnr2005',NULL),
('name.brokkr.non','being.norse.brokkr','Brokkr','brokkr','lang.non','Latin','ORIGINAL',NULL,1,'source.norse.skaldskaparmal.vsnr1998',NULL),
('name.eitri.non','being.norse.eitri','Eitri','eitri','lang.non','Latin','ORIGINAL',NULL,1,'source.norse.skaldskaparmal.vsnr1998',NULL),
('name.sindri.non','being.norse.sindri','Sindri','sindri','lang.non','Latin','ORIGINAL',NULL,1,'source.norse.skaldskaparmal.vsnr1998','Kept as separate candidate identity'),
('name.gullinbursti.non','creature.norse.gullinbursti','Gullinbursti','gullinbursti','lang.non','Latin','ORIGINAL',NULL,1,'source.norse.skaldskaparmal.vsnr1998',NULL),
('name.shangshu.lzh','text.chinese.shang_shu','尚書','尚書','lang.lzh','Han','ORIGINAL',NULL,1,'source.china.hong_fan.ctext',NULL),
('name.hongfan.lzh','text.chinese.hong_fan','洪範','洪範','lang.lzh','Han','ORIGINAL',NULL,1,'source.china.hong_fan.ctext',NULL),
('name.hanshu_wuxing.lzh','text.chinese.han_shu_wuxing_zhi','漢書·五行志','漢書·五行志','lang.lzh','Han','ORIGINAL',NULL,1,'source.china.han_shu.wuxing_zhi.ctext',NULL),
('name.wuxing.lzh','concept.chinese.wuxing','五行','五行','lang.lzh','Han','ORIGINAL',NULL,1,'source.china.hong_fan.ctext','Native term retained; Five Phases is a translation, not a forced substance model'),
('name.wuxing.shui.lzh','concept.chinese.wuxing.shui','水','水','lang.lzh','Han','ORIGINAL',NULL,1,'source.china.hong_fan.ctext',NULL),
('name.wuxing.huo.lzh','concept.chinese.wuxing.huo','火','火','lang.lzh','Han','ORIGINAL',NULL,1,'source.china.hong_fan.ctext',NULL),
('name.wuxing.mu.lzh','concept.chinese.wuxing.mu','木','木','lang.lzh','Han','ORIGINAL',NULL,1,'source.china.hong_fan.ctext',NULL),
('name.wuxing.jin.lzh','concept.chinese.wuxing.jin','金','金','lang.lzh','Han','ORIGINAL',NULL,1,'source.china.hong_fan.ctext',NULL),
('name.wuxing.tu.lzh','concept.chinese.wuxing.tu','土','土','lang.lzh','Han','ORIGINAL',NULL,1,'source.china.hong_fan.ctext',NULL);

INSERT OR IGNORE INTO aliases(id,alias_text,normalized_text,language_id,entity_id,candidate_entity_id,resolution_status,confidence,source_id,notes) VALUES
('alias.typhon.typhoeus','Typhoeus','typhoeus','lang.en','creature.greek.typhon',NULL,'RESOLVED',0.85,'source.greek.theogony.perseus_eng1','Resolved only for this canonical record and cited translation; Typhaon is not merged'),
('alias.borr.bor','Bor','bor','lang.en','deity.norse.borr',NULL,'RESOLVED',0.9,'source.norse.prose_edda.vsnr','Anglicized spelling'),
('alias.mimir.mim','Mim','mim','lang.en','being.norse.mimir',NULL,'RESOLVED',0.8,'source.norse.prose_edda.vsnr','English spelling variant'),
('alias.wuxing.five_phases','Five Phases','five phases','lang.en','concept.chinese.wuxing',NULL,'RESOLVED',0.95,'source.china.hong_fan.ctext','Preferred comparative translation; does not imply identity with Greek elements'),
('alias.wuxing.five_agents','Five Agents','five agents','lang.en','concept.chinese.wuxing',NULL,'RESOLVED',0.8,'source.china.hong_fan.ctext','Alternative translation');

INSERT OR IGNORE INTO claims(id,subject_id,predicate,object_entity_id,object_literal,object_datatype,statement,variant_group,claim_status,confidence,confidence_level,review_status,assertion_scope,knowledge_layer,tradition_scope,temporal_scope,research_notes,created_at) VALUES
('claim.typhon.child_gaia','creature.greek.typhon','CHILD_OF','deity.greek.gaia',NULL,NULL,'Hesiod’s Theogony presents Typhoeus as Gaia’s youngest child.','hesiod.theogony.820','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 820-821','Textual genealogy, not historical fact.','2026-08-11T03:05:26Z'),
('claim.typhon.child_tartarus','creature.greek.typhon','CHILD_OF','realm.greek.tartarus',NULL,NULL,'Hesiod’s Theogony presents Tartarus as the other parent of Typhoeus.','hesiod.theogony.820','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 820-822',NULL,'2026-08-11T03:05:26Z'),
('claim.typhon.appearance','creature.greek.typhon','APPEARANCE',NULL,'One hundred serpent heads, flashing fire and many kinds of voice','text','Theogony 824-835 gives Typhon serpent heads, fire and multiple voices.','hesiod.theogony.824','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 824-835',NULL,'2026-08-11T03:05:26Z'),
('claim.typhon.defeated_zeus','creature.greek.typhon','DEFEATED_BY','deity.greek.zeus',NULL,NULL,'Zeus defeats Typhon with thunder, lightning and thunderbolt in Hesiod.','hesiod.theogony.853','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 853-868',NULL,'2026-08-11T03:05:26Z'),
('claim.typhon.participated_battle','creature.greek.typhon','PARTICIPATED_IN','event.greek.zeus_typhon_battle',NULL,NULL,'Typhon is the defeated opponent in the Hesiodic combat.','hesiod.theogony.820','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 820-868',NULL,'2026-08-11T03:05:26Z'),
('claim.zeus.participated_typhon','deity.greek.zeus','PARTICIPATED_IN','event.greek.zeus_typhon_battle',NULL,NULL,'Zeus is the victorious combatant in the Hesiodic Typhon episode.','hesiod.theogony.820','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 820-868',NULL,'2026-08-11T03:05:26Z'),
('claim.typhon.mentioned_theogony','creature.greek.typhon','MENTIONED_IN','text.greek.theogony',NULL,NULL,'Typhon is narrated in Theogony 820-885.','hesiod.theogony','SUPPORTED',1.0,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Hesiodic','Theogony 820-885',NULL,'2026-08-11T03:05:26Z'),
('claim.metis.consort_zeus','deity.greek.metis','CONSORT_OF','deity.greek.zeus',NULL,NULL,'Theogony calls Metis the first wife of Zeus.','hesiod.theogony.886','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 886-887',NULL,'2026-08-11T03:05:26Z'),
('claim.metis.parent_athena','deity.greek.metis','PARENT_OF','deity.greek.athena',NULL,NULL,'Theogony says Metis was about to give birth to Athena.','hesiod.theogony.888','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 888-895',NULL,'2026-08-11T03:05:26Z'),
('claim.metis.imprisoned_zeus','deity.greek.metis','IMPRISONED_BY','deity.greek.zeus',NULL,NULL,'In Hesiod Zeus deceives Metis and puts her in his belly.','hesiod.theogony.889','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 889-900','IMPRISONED_BY is a graph normalization of the text’s swallowing episode.','2026-08-11T03:05:26Z'),
('claim.metis.wisdom','deity.greek.metis','DOMAIN',NULL,'wisdom and counsel','text','Theogony describes Metis as exceptionally wise and as devising good and evil for Zeus.','hesiod.theogony.886','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 886-900',NULL,'2026-08-11T03:05:26Z'),
('claim.metis.mentioned_theogony','deity.greek.metis','MENTIONED_IN','text.greek.theogony',NULL,NULL,'Metis appears in Theogony 886-900.','hesiod.theogony','SUPPORTED',1.0,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Hesiodic','Theogony 886-900',NULL,'2026-08-11T03:05:26Z'),

('claim.borr.child_buri','deity.norse.borr','CHILD_OF','deity.norse.buri',NULL,NULL,'Gylfaginning presents Borr as Búri’s son.','gylfaginning.6','SUPPORTED',0.97,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Snorri Edda','Gylfaginning 6','Chapter numbering should be checked against each redaction.','2026-08-11T03:05:26Z'),
('claim.borr.consort_bestla','deity.norse.borr','CONSORT_OF','being.norse.bestla',NULL,NULL,'Gylfaginning presents Borr and Bestla as parents together.','gylfaginning.6','SUPPORTED',0.97,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Snorri Edda','Gylfaginning 6',NULL,'2026-08-11T03:05:26Z'),
('claim.borr.parent_odin','deity.norse.borr','PARENT_OF','deity.norse.odin',NULL,NULL,'Borr is father of Odin in Gylfaginning.','gylfaginning.6','SUPPORTED',0.98,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Snorri Edda','Gylfaginning 6',NULL,'2026-08-11T03:05:26Z'),
('claim.borr.parent_vili','deity.norse.borr','PARENT_OF','deity.norse.vili',NULL,NULL,'Borr is father of Vili in Gylfaginning.','gylfaginning.6','SUPPORTED',0.98,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Snorri Edda','Gylfaginning 6',NULL,'2026-08-11T03:05:26Z'),
('claim.borr.parent_ve','deity.norse.borr','PARENT_OF','deity.norse.ve',NULL,NULL,'Borr is father of Vé in Gylfaginning.','gylfaginning.6','SUPPORTED',0.98,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Snorri Edda','Gylfaginning 6',NULL,'2026-08-11T03:05:26Z'),
('claim.bestla.parent_odin','being.norse.bestla','PARENT_OF','deity.norse.odin',NULL,NULL,'Bestla is mother of Odin in Gylfaginning.','gylfaginning.6','SUPPORTED',0.98,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Snorri Edda','Gylfaginning 6',NULL,'2026-08-11T03:05:26Z'),
('claim.bestla.parent_vili','being.norse.bestla','PARENT_OF','deity.norse.vili',NULL,NULL,'Bestla is mother of Vili in Gylfaginning.','gylfaginning.6','SUPPORTED',0.98,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Snorri Edda','Gylfaginning 6',NULL,'2026-08-11T03:05:26Z'),
('claim.bestla.parent_ve','being.norse.bestla','PARENT_OF','deity.norse.ve',NULL,NULL,'Bestla is mother of Vé in Gylfaginning.','gylfaginning.6','SUPPORTED',0.98,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Snorri Edda','Gylfaginning 6',NULL,'2026-08-11T03:05:26Z'),
('claim.vili.sibling_odin','deity.norse.vili','SIBLING_OF','deity.norse.odin',NULL,NULL,'Vili and Odin are brothers in Gylfaginning.','gylfaginning.6','SUPPORTED',0.98,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Snorri Edda','Gylfaginning 6',NULL,'2026-08-11T03:05:26Z'),
('claim.ve.sibling_odin','deity.norse.ve','SIBLING_OF','deity.norse.odin',NULL,NULL,'Vé and Odin are brothers in Gylfaginning.','gylfaginning.6','SUPPORTED',0.98,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Snorri Edda','Gylfaginning 6',NULL,'2026-08-11T03:05:26Z'),
('claim.vili.sibling_ve','deity.norse.vili','SIBLING_OF','deity.norse.ve',NULL,NULL,'Vili and Vé are brothers in Gylfaginning.','gylfaginning.6','SUPPORTED',0.98,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Snorri Edda','Gylfaginning 6',NULL,'2026-08-11T03:05:26Z'),
('claim.vili.cosmogony','deity.norse.vili','ROLE',NULL,'joins Odin and Vé in cosmogonic actions','text','Gylfaginning includes Vili with Odin and Vé in forming the world from Ymir.','gylfaginning.8','SUPPORTED',0.95,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Snorri Edda','Gylfaginning 8-9','Compare separately with the Hœnir/Lóðurr triad in Völuspá.','2026-08-11T03:05:26Z'),
('claim.ve.cosmogony','deity.norse.ve','ROLE',NULL,'joins Odin and Vili in cosmogonic actions','text','Gylfaginning includes Vé with Odin and Vili in forming the world from Ymir.','gylfaginning.8','SUPPORTED',0.95,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Snorri Edda','Gylfaginning 8-9','Compare separately with the Hœnir/Lóðurr triad in Völuspá.','2026-08-11T03:05:26Z'),
('claim.mimir.owns_well','being.norse.mimir','OWNS','place.norse.mimisbrunnr',NULL,NULL,'Gylfaginning associates Mímir as owner/keeper of the wisdom well.','gylfaginning.15','SUPPORTED',0.96,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Snorri Edda','Gylfaginning 15',NULL,'2026-08-11T03:05:26Z'),
('claim.odin.associated_mimisbrunnr','deity.norse.odin','ASSOCIATED_WITH','place.norse.mimisbrunnr',NULL,NULL,'Gylfaginning says Odin gives an eye for a drink from Mímir’s well.','gylfaginning.15','SUPPORTED',0.96,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Snorri Edda','Gylfaginning 15',NULL,'2026-08-11T03:05:26Z'),
('claim.brokkr.sibling_eitri','being.norse.brokkr','SIBLING_OF','being.norse.eitri',NULL,NULL,'The common Eitri naming tradition presents Brokkr and Eitri as brothers.','skaldskaparmal.35','SUPPORTED',0.85,'MEDIUM','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Skáldskaparmál naming tradition','Skáldskaparmál 35','Name varies across references; Sindri remains a separate candidate.','2026-08-11T03:05:26Z'),
('claim.brokkr.creator_mjolnir','being.norse.brokkr','CREATOR_OF','weapon.norse.mjolnir',NULL,NULL,'Brokkr participates in forging Mjölnir by working the bellows.','skaldskaparmal.35','SUPPORTED',0.96,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Skáldskaparmál','Skáldskaparmál 35','CREATOR_OF records collaborative manufacture.','2026-08-11T03:05:26Z'),
('claim.eitri.creator_mjolnir','being.norse.eitri','CREATOR_OF','weapon.norse.mjolnir',NULL,NULL,'Eitri is named as the smith producing Mjölnir in a common translation tradition.','skaldskaparmal.35','SUPPORTED',0.88,'MEDIUM','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Skáldskaparmál naming tradition','Skáldskaparmál 35','Keep separate from Sindri until witness-level collation.','2026-08-11T03:05:26Z'),
('claim.brokkr.creator_draupnir','being.norse.brokkr','CREATOR_OF','artifact.norse.draupnir',NULL,NULL,'Brokkr participates in forging Draupnir by working the bellows.','skaldskaparmal.35','SUPPORTED',0.96,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Skáldskaparmál','Skáldskaparmál 35',NULL,'2026-08-11T03:05:26Z'),
('claim.eitri.creator_draupnir','being.norse.eitri','CREATOR_OF','artifact.norse.draupnir',NULL,NULL,'Eitri is named as smith of Draupnir in a common translation tradition.','skaldskaparmal.35','SUPPORTED',0.88,'MEDIUM','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Skáldskaparmál naming tradition','Skáldskaparmál 35',NULL,'2026-08-11T03:05:26Z'),
('claim.brokkr.creator_gullinbursti','being.norse.brokkr','CREATOR_OF','creature.norse.gullinbursti',NULL,NULL,'Brokkr participates in forging the golden-bristled boar.','skaldskaparmal.35','SUPPORTED',0.96,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Skáldskaparmál','Skáldskaparmál 35',NULL,'2026-08-11T03:05:26Z'),
('claim.eitri.creator_gullinbursti','being.norse.eitri','CREATOR_OF','creature.norse.gullinbursti',NULL,NULL,'Eitri is named as smith of the golden-bristled boar in a common translation tradition.','skaldskaparmal.35','SUPPORTED',0.88,'MEDIUM','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Skáldskaparmál naming tradition','Skáldskaparmál 35',NULL,'2026-08-11T03:05:26Z'),
('claim.brokkr.participated_forging','being.norse.brokkr','PARTICIPATED_IN','event.norse.forging_divine_treasures',NULL,NULL,'Brokkr participates in the divine-treasure forging contest.','skaldskaparmal.35','SUPPORTED',0.96,'HIGH','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Skáldskaparmál','Skáldskaparmál 35',NULL,'2026-08-11T03:05:26Z'),
('claim.eitri.participated_forging','being.norse.eitri','PARTICIPATED_IN','event.norse.forging_divine_treasures',NULL,NULL,'Eitri participates as smith in the divine-treasure forging contest.','skaldskaparmal.35','SUPPORTED',0.88,'MEDIUM','PROVISIONAL','TEXT_SAYS','MYTHIC_NARRATIVE','Skáldskaparmál naming tradition','Skáldskaparmál 35',NULL,'2026-08-11T03:05:26Z'),

('claim.wuxing.mentioned_hongfan','concept.chinese.wuxing','MENTIONED_IN','text.chinese.hong_fan',NULL,NULL,'Hong Fan explicitly enumerates the five xing.','hongfan.wuxing','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Shang Shu received tradition','Hong Fan, first division','The record preserves native terminology rather than forcing Greek-element equivalence.','2026-08-11T03:05:26Z'),
('claim.wuxing.mentioned_hanshu','concept.chinese.wuxing','MENTIONED_IN','text.chinese.han_shu_wuxing_zhi',NULL,NULL,'The Han Shu Wuxing Zhi quotes and develops a five-xing framework.','hanshu.wuxing','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Han historiography','Wuxing Zhi, opening','Later interpretive layer is not collapsed into Hong Fan.','2026-08-11T03:05:26Z'),
('claim.wuxing.shui.member','concept.chinese.wuxing.shui','ELEMENT_OF','concept.chinese.wuxing',NULL,NULL,'Hong Fan lists water first among the five xing.','hongfan.wuxing','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Shang Shu received tradition','Hong Fan, first division',NULL,'2026-08-11T03:05:26Z'),
('claim.wuxing.huo.member','concept.chinese.wuxing.huo','ELEMENT_OF','concept.chinese.wuxing',NULL,NULL,'Hong Fan lists fire second among the five xing.','hongfan.wuxing','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Shang Shu received tradition','Hong Fan, first division',NULL,'2026-08-11T03:05:26Z'),
('claim.wuxing.mu.member','concept.chinese.wuxing.mu','ELEMENT_OF','concept.chinese.wuxing',NULL,NULL,'Hong Fan lists wood third among the five xing.','hongfan.wuxing','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Shang Shu received tradition','Hong Fan, first division',NULL,'2026-08-11T03:05:26Z'),
('claim.wuxing.jin.member','concept.chinese.wuxing.jin','ELEMENT_OF','concept.chinese.wuxing',NULL,NULL,'Hong Fan lists metal fourth among the five xing.','hongfan.wuxing','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Shang Shu received tradition','Hong Fan, first division',NULL,'2026-08-11T03:05:26Z'),
('claim.wuxing.tu.member','concept.chinese.wuxing.tu','ELEMENT_OF','concept.chinese.wuxing',NULL,NULL,'Hong Fan lists earth/soil fifth among the five xing.','hongfan.wuxing','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Shang Shu received tradition','Hong Fan, first division',NULL,'2026-08-11T03:05:26Z'),
('claim.wuxing.shui.disposition','concept.chinese.wuxing.shui','DISPOSITION',NULL,'moistens and descends','text','Hong Fan characterizes water as moistening and descending.','hongfan.wuxing','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Shang Shu received tradition','Hong Fan, first division',NULL,'2026-08-11T03:05:26Z'),
('claim.wuxing.huo.disposition','concept.chinese.wuxing.huo','DISPOSITION',NULL,'blazes and rises','text','Hong Fan characterizes fire as blazing and rising.','hongfan.wuxing','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Shang Shu received tradition','Hong Fan, first division',NULL,'2026-08-11T03:05:26Z'),
('claim.wuxing.mu.disposition','concept.chinese.wuxing.mu','DISPOSITION',NULL,'can be bent and straightened','text','Hong Fan characterizes wood through bending and straightening.','hongfan.wuxing','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Shang Shu received tradition','Hong Fan, first division',NULL,'2026-08-11T03:05:26Z'),
('claim.wuxing.jin.disposition','concept.chinese.wuxing.jin','DISPOSITION',NULL,'yields and changes','text','Hong Fan characterizes metal through yielding and change.','hongfan.wuxing','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Shang Shu received tradition','Hong Fan, first division',NULL,'2026-08-11T03:05:26Z'),
('claim.wuxing.tu.disposition','concept.chinese.wuxing.tu','DISPOSITION',NULL,'supports sowing and harvest','text','Hong Fan characterizes earth/soil through sowing and gathering.','hongfan.wuxing','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Shang Shu received tradition','Hong Fan, first division',NULL,'2026-08-11T03:05:26Z');

INSERT OR IGNORE INTO evidence(id,claim_id,source_id,source_location,chapter,verse,line,page,catalogue_number,short_quote,evidence_type,direction,strength,research_notes)
SELECT 'evidence.' || substr(id,7), id, 'source.greek.theogony.perseus_eng1',
       CASE
         WHEN id LIKE 'claim.metis.%' THEN 'Theogony 886-900'
         WHEN id='claim.typhon.appearance' THEN 'Theogony 824-835'
         ELSE 'Theogony 820-885'
       END,
       'Theogony',NULL,
       CASE
         WHEN id LIKE 'claim.metis.%' THEN '886-900'
         WHEN id='claim.typhon.appearance' THEN '824-835'
         WHEN id IN ('claim.typhon.defeated_zeus','claim.typhon.participated_battle','claim.zeus.participated_typhon') THEN '820-868'
         ELSE '820-885'
       END,NULL,'urn:cts:greekLit:tlg0020.tlg001.perseus-eng1',NULL,'PRIMARY_TEXT','SUPPORTS',0.98,'Line group verified in Perseus digital text 2026-08-11'
FROM claims WHERE id LIKE 'claim.typhon.%' OR id LIKE 'claim.metis.%' OR id='claim.zeus.participated_typhon';

INSERT OR IGNORE INTO evidence(id,claim_id,source_id,source_location,chapter,verse,line,page,catalogue_number,short_quote,evidence_type,direction,strength,research_notes)
SELECT 'evidence.' || substr(id,7), id,
       CASE WHEN id LIKE 'claim.brokkr.%' OR id LIKE 'claim.eitri.%' THEN 'source.norse.skaldskaparmal.vsnr1998' ELSE 'source.norse.prose_edda.vsnr' END,
       CASE
         WHEN id LIKE 'claim.brokkr.%' OR id LIKE 'claim.eitri.%' THEN 'Skáldskaparmál 35'
         WHEN id LIKE 'claim.mimir.%' OR id='claim.odin.associated_mimisbrunnr' THEN 'Gylfaginning 15'
         WHEN id LIKE 'claim.vili.cosmogony' OR id LIKE 'claim.ve.cosmogony' THEN 'Gylfaginning 8-9'
         ELSE 'Gylfaginning 6'
       END,
       CASE WHEN id LIKE 'claim.brokkr.%' OR id LIKE 'claim.eitri.%' THEN 'Skáldskaparmál' ELSE 'Gylfaginning' END,
       NULL,NULL,NULL,NULL,NULL,'MEDIEVAL_TEXT','SUPPORTS',0.88,'Chapter location retained; redaction and naming variants remain provisional'
FROM claims WHERE id LIKE 'claim.borr.%' OR id LIKE 'claim.bestla.%' OR id LIKE 'claim.vili.%'
 OR id LIKE 'claim.ve.%' OR id LIKE 'claim.mimir.%' OR id LIKE 'claim.brokkr.%'
 OR id LIKE 'claim.eitri.%' OR id='claim.odin.associated_mimisbrunnr';

INSERT OR IGNORE INTO evidence(id,claim_id,source_id,source_location,chapter,verse,line,page,catalogue_number,short_quote,evidence_type,direction,strength,research_notes)
SELECT 'evidence.' || substr(id,7), id,
       CASE WHEN id='claim.wuxing.mentioned_hanshu' THEN 'source.china.han_shu.wuxing_zhi.ctext' ELSE 'source.china.hong_fan.ctext' END,
       CASE WHEN id='claim.wuxing.mentioned_hanshu' THEN 'Han Shu, Wuxing Zhi, opening' ELSE 'Shang Shu, Zhou Documents, Hong Fan, first division' END,
       CASE WHEN id='claim.wuxing.mentioned_hanshu' THEN '五行志上' ELSE '洪範' END,
       NULL,NULL,NULL,
       CASE WHEN id='claim.wuxing.mentioned_hanshu' THEN 'ctp:han-shu/wu-xing-zhi-shang' ELSE 'ctp:shang-shu/great-plan' END,
       CASE WHEN id='claim.wuxing.mentioned_hanshu' THEN '初一曰五行' ELSE '一曰水，二曰火，三曰木，四曰金，五曰土' END,
       'PRIMARY_TEXT','SUPPORTS',0.97,'Native terms retained; later semantic layers are not flattened'
FROM claims WHERE id LIKE 'claim.wuxing.%';

INSERT OR IGNORE INTO event_participants(event_id,participant_id,role,outcome,claim_id) VALUES
('event.greek.zeus_typhon_battle','creature.greek.typhon','OPPONENT','Defeated','claim.typhon.participated_battle'),
('event.greek.zeus_typhon_battle','deity.greek.zeus','OPPONENT','Victorious','claim.zeus.participated_typhon'),
('event.norse.forging_divine_treasures','being.norse.brokkr','SMITH_AND_BELLOWS','Treasures completed','claim.brokkr.participated_forging'),
('event.norse.forging_divine_treasures','being.norse.eitri','SMITH','Treasures completed','claim.eitri.participated_forging');

INSERT OR IGNORE INTO identity_candidates(id,entity_a_id,entity_b_id,assessment,confidence,source_id,notes) VALUES
('identity.eitri_sindri','being.norse.eitri','being.norse.sindri','POSSIBLY_SAME',0.55,'source.norse.skaldskaparmal.vsnr1998','Different reference traditions use Eitri or Sindri for Brokkr’s smith brother; preserve separate entities until witness-level collation.');
INSERT OR IGNORE INTO conflicts(id,subject_id,variant_group,claim_a_id,claim_b_id,conflict_type,status,summary,resolution_notes) VALUES
('conflict.eitri_sindri','being.norse.eitri','norse.smith_brother_name',NULL,NULL,'IDENTITY_AMBIGUITY','OPEN','Eitri and Sindri may name the same smith in different textual/reference traditions, but automatic merging would erase witness differences.','Collect manuscript readings and edition apparatus before resolution.');

INSERT OR IGNORE INTO collection_queue(id,target_label,normalized_label,proposed_entity_type,civilization_id,discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,discovery_context,priority,status,attempts,last_error,next_action,created_at,updated_at) VALUES
('queue.greek.typhaon_distinction','Typhaon versus Typhon/Typhoeus witness distinction','typhaon versus typhon/typhoeus witness distinction','MONSTER','civ.greek','creature.greek.typhon','claim.typhon.mentioned_theogony','source.greek.theogony.perseus_eng1','Name and genealogy ambiguity exposed by Hesiodic passages and later mythography',95,'CONFLICT',0,NULL,'Collate Greek forms and genealogies before creating redirects or mergers','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('queue.norse.creation_triad_variants','Odin–Vili–Vé versus Odin–Hœnir–Lóðurr creation triads','odin–vili–vé versus odin–hœnir–lóðurr creation triads','CONCEPT','civ.norse','deity.norse.vili','claim.vili.cosmogony','source.norse.prose_edda.vsnr','Cross-witness cosmogony comparison without assumed identity',94,'NEEDS_REVIEW',0,NULL,'Pin Völuspá stanzas and compare without forced equivalence','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('queue.norse.mimir_head_traditions','Mímir head and counsel traditions','mímir head and counsel traditions','CONCEPT','civ.norse','being.norse.mimir','claim.mimir.owns_well','source.norse.prose_edda.vsnr','Mímir well branch exposes separate severed-head and hostage narratives',91,'SOURCE_FOUND',0,NULL,'Add Völuspá, Sigrdrífumál and Ynglinga saga witness-specific claims','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('queue.norse.sindri_eitri_identity','Sindri–Eitri smith identity by manuscript witness','sindri–eitri smith identity by manuscript witness','DWARF','civ.norse','being.norse.eitri',NULL,'source.norse.skaldskaparmal.vsnr1998','Unresolved name/identity candidate created during smith research',97,'CONFLICT',0,NULL,'Inspect Codex Regius, Uppsala and Wormian readings and edition apparatus','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('queue.china.wuxing_semantic_history','Wuxing semantic development from Hong Fan to Han Shu','wuxing semantic development from hong fan to han shu','CONCEPT','civ.chinese_ancient','concept.chinese.wuxing','claim.wuxing.mentioned_hanshu','source.china.han_shu.wuxing_zhi.ctext','Early formulation and later omen-historical elaboration must remain dated layers',96,'SOURCE_FOUND',0,NULL,'Add pre-Qin and Han textual layers with chapter-level claims and scholarly dating','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z'),
('queue.norse.gullinbursti_variants','Gullinbursti ownership and Baldr funeral variants','gullinbursti ownership and baldr funeral variants','DIVINE_BEAST','civ.norse','creature.norse.gullinbursti','claim.brokkr.creator_gullinbursti','source.norse.skaldskaparmal.vsnr1998','Forged-creature branch from the divine treasures episode',84,'DISCOVERED',0,NULL,'Compare Skáldskaparmál, Gylfaginning and Húsdrápa testimony','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z');

INSERT OR IGNORE INTO queue_discoveries(id,queue_id,discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,discovery_context,discovered_at) VALUES
('discovery.20260811.typhaon','queue.greek.typhaon_distinction','creature.greek.typhon','claim.typhon.mentioned_theogony','source.greek.theogony.perseus_eng1','Typhon naming could not be safely normalized across witnesses','2026-08-11T03:05:26Z'),
('discovery.20260811.creation_triads','queue.norse.creation_triad_variants','deity.norse.vili','claim.vili.cosmogony','source.norse.prose_edda.vsnr','Snorri triad requires comparison with Poetic Edda triad','2026-08-11T03:05:26Z'),
('discovery.20260811.mimir_head','queue.norse.mimir_head_traditions','being.norse.mimir','claim.mimir.owns_well','source.norse.prose_edda.vsnr','Well narrative points to distinct counsel/head traditions','2026-08-11T03:05:26Z'),
('discovery.20260811.eitri_sindri','queue.norse.sindri_eitri_identity','being.norse.eitri',NULL,'source.norse.skaldskaparmal.vsnr1998','Reference-name divergence retained as unresolved identity','2026-08-11T03:05:26Z'),
('discovery.20260811.wuxing_history','queue.china.wuxing_semantic_history','concept.chinese.wuxing','claim.wuxing.mentioned_hanshu','source.china.han_shu.wuxing_zhi.ctext','Later text develops earlier enumeration','2026-08-11T03:05:26Z'),
('discovery.20260811.gullinbursti','queue.norse.gullinbursti_variants','creature.norse.gullinbursti','claim.brokkr.creator_gullinbursti','source.norse.skaldskaparmal.vsnr1998','Forged boar opens ownership and funeral-episode branches','2026-08-11T03:05:26Z');

INSERT OR IGNORE INTO queue_status_history(id,queue_id,old_status,new_status,changed_at,reason) VALUES
('qhist.20260811.typhon','queue.greek.typhon','NEW','PARTIAL','2026-08-11T03:05:26Z','Entity, primary-text claims and evidence added'),
('qhist.20260811.metis','queue.greek.metis','NEW','PARTIAL','2026-08-11T03:05:26Z','Entity, genealogy claims and evidence added'),
('qhist.20260811.borr','queue.norse.borr','NEW','PARTIAL','2026-08-11T03:05:26Z','Entity and Gylfaginning genealogy added'),
('qhist.20260811.bestla','queue.norse.bestla','NEW','PARTIAL','2026-08-11T03:05:26Z','Entity and Gylfaginning genealogy added'),
('qhist.20260811.vili','queue.norse.vili','NEW','PARTIAL','2026-08-11T03:05:26Z','Entity, sibling and cosmogony claims added'),
('qhist.20260811.ve','queue.norse.ve','NEW','PARTIAL','2026-08-11T03:05:26Z','Entity, sibling and cosmogony claims added'),
('qhist.20260811.mimir','queue.norse.mimir','NEW','PARTIAL','2026-08-11T03:05:26Z','Entity and well relationship added; classification remains open'),
('qhist.20260811.brokkr_eitri','queue.norse.brokkr_eitri','SOURCE_FOUND','PARTIAL','2026-08-11T03:05:26Z','Separate smith entities, products and identity conflict recorded'),
('qhist.20260811.wuxing','queue.china.wuxing_sources','SOURCE_FOUND','PARTIAL','2026-08-11T03:05:26Z','Hong Fan and Han Shu source locations and native component entities added');

UPDATE collection_queue SET status='PARTIAL',attempts=attempts+1,last_error=NULL,
 next_action='Expand later variants without overwriting the Hesiodic baseline',updated_at='2026-08-11T03:05:26Z'
WHERE id='queue.greek.typhon';
UPDATE collection_queue SET status='PARTIAL',attempts=attempts+1,last_error=NULL,
 next_action='Add non-Hesiodic genealogy variants as separate claims',updated_at='2026-08-11T03:05:26Z'
WHERE id='queue.greek.metis';
UPDATE collection_queue SET status='PARTIAL',attempts=attempts+1,last_error=NULL,
 next_action='Add manuscript/redaction-specific attestations',updated_at='2026-08-11T03:05:26Z'
WHERE id IN ('queue.norse.borr','queue.norse.bestla','queue.norse.vili','queue.norse.ve','queue.norse.mimir');
UPDATE collection_queue SET status='PARTIAL',attempts=attempts+1,last_error=NULL,
 next_action='Resolve Eitri/Sindri at manuscript-witness level; do not auto-merge',updated_at='2026-08-11T03:05:26Z'
WHERE id='queue.norse.brokkr_eitri';
UPDATE collection_queue SET status='PARTIAL',attempts=attempts+1,last_error=NULL,
 next_action='Build dated semantic layers from pre-Qin through Han sources',updated_at='2026-08-11T03:05:26Z'
WHERE id='queue.china.wuxing_sources';

INSERT OR IGNORE INTO research_sessions(id,started_at,ended_at,scope,strategy,status,agent_or_process,notes) VALUES
('research.20260811.expansion1','2026-08-11T03:05:26Z','2026-08-11T03:05:26Z','Typhon and Metis; Norse genealogy, Mímir and divine smiths; early wuxing text locations','Queue-priority selection; primary and scholarly digital editions; witness-specific claims; no destructive merges','CHECKPOINT_COMPLETE','Codex scheduled research run','Stage baseline only; permanent queue continues.');

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result) VALUES
('research.20260811.expansion1','QUEUE','queue.greek.typhon','EXPAND','PARTIAL'),
('research.20260811.expansion1','QUEUE','queue.greek.metis','EXPAND','PARTIAL'),
('research.20260811.expansion1','QUEUE','queue.norse.borr','EXPAND','PARTIAL'),
('research.20260811.expansion1','QUEUE','queue.norse.bestla','EXPAND','PARTIAL'),
('research.20260811.expansion1','QUEUE','queue.norse.vili','EXPAND','PARTIAL'),
('research.20260811.expansion1','QUEUE','queue.norse.ve','EXPAND','PARTIAL'),
('research.20260811.expansion1','QUEUE','queue.norse.mimir','EXPAND','PARTIAL'),
('research.20260811.expansion1','QUEUE','queue.norse.brokkr_eitri','EXPAND','PARTIAL_WITH_CONFLICT'),
('research.20260811.expansion1','QUEUE','queue.china.wuxing_sources','EXPAND','PARTIAL'),
('research.20260811.expansion1','ENTITY','creature.greek.typhon','CREATE','SOURCE_BACKED_BASELINE'),
('research.20260811.expansion1','ENTITY','deity.greek.metis','CREATE','SOURCE_BACKED_BASELINE'),
('research.20260811.expansion1','ENTITY','being.norse.eitri','CREATE','IDENTITY_NOT_MERGED'),
('research.20260811.expansion1','ENTITY','being.norse.sindri','CREATE','CONFLICT_RETAINED'),
('research.20260811.expansion1','ENTITY','concept.chinese.wuxing','EXPAND','NATIVE_COMPONENTS_ADDED');

INSERT OR IGNORE INTO dataset_releases(id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes) VALUES
('release.0.2.0',2,'0.2.0-expansion-20260811',NULL,'2026-08-11T03:05:26Z',NULL,'Append-only research checkpoint: Greek Typhon/Metis, Norse genealogy/smiths, and early Chinese wuxing text layers.');

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(2,'20260811_expansion_greek_norse_wuxing','2026-08-11T03:05:26Z');

COMMIT;
