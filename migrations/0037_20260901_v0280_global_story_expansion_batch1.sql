BEGIN IMMEDIATE;

-- v0.28 starts a fault-isolated global story expansion ledger. A blocked
-- permission review never rolls back unrelated, source-backed story targets.
CREATE TABLE IF NOT EXISTS story_expansion_batches (
    id TEXT PRIMARY KEY,
    version_label TEXT NOT NULL,
    title_zh TEXT NOT NULL,
    title_en TEXT NOT NULL,
    scope_note TEXT NOT NULL,
    continuation_policy TEXT NOT NULL,
    status TEXT NOT NULL CHECK(status IN ('IN_PROGRESS','PARTIAL','CHECKPOINT_COMPLETE','FAILED')),
    started_at TEXT NOT NULL,
    completed_at TEXT
);

CREATE TABLE IF NOT EXISTS story_expansion_targets (
    id TEXT PRIMARY KEY,
    batch_id TEXT NOT NULL REFERENCES story_expansion_batches(id) ON DELETE CASCADE,
    target_order INTEGER NOT NULL CHECK(target_order >= 1),
    civilization_id TEXT REFERENCES civilizations(id),
    queue_id TEXT REFERENCES collection_queue(id),
    target_kind TEXT NOT NULL CHECK(target_kind IN ('STORY','SOURCE_AUDIT','PERMISSION_REVIEW')),
    target_label_zh TEXT NOT NULL,
    target_label_en TEXT NOT NULL,
    status TEXT NOT NULL CHECK(status IN ('QUEUED','IN_PROGRESS','COMPLETED','BLOCKED_PERMISSION','DEFERRED','FAILED_VALIDATION')),
    result_story_id TEXT REFERENCES stories(id),
    source_ids_json TEXT NOT NULL DEFAULT '[]',
    blocker_reason TEXT,
    next_action TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    UNIQUE(batch_id,target_order)
);

CREATE INDEX IF NOT EXISTS idx_story_expansion_targets_batch
    ON story_expansion_targets(batch_id,target_order,id);
CREATE INDEX IF NOT EXISTS idx_story_expansion_targets_status
    ON story_expansion_targets(status,civilization_id,id);

INSERT OR IGNORE INTO languages(
    id,canonical_name,name_zh,iso_639_3,script_name,historical_stage,notes
) VALUES
('lang.quc','K''iche''','基切语','quc','Latin','Colonial manuscript witness and living-language continuum','Specific K''iche'' attribution is preferred over the generic Mayan-language umbrella when the source supports it.'),
('lang.khm','Khmer','高棉语','khm','Khmer','Angkorian and modern Khmer continuum','Material witnesses and modern heritage-authority metadata must remain distinct.');

UPDATE sources
   SET language_id=COALESCE(language_id,'lang.en'),
       living_tradition=1,
       source_perspective='Smithsonian public educational synthesis of a K''iche'' Maya creation account',
       community_or_lineage='K''iche'' Maya',
       access_or_reuse_restrictions='Public institutional context and independent summary only; do not generalize one K''iche'' account to all Maya communities or collect restricted community knowledge.',
       community_permission_required=0
 WHERE id='source.maya.creation.nmai';

UPDATE sources
   SET living_tradition=1,
       community_or_lineage='K''iche'' Maya',
       collector_context='Colonial-period K''iche'' transcription and Spanish translation associated with Francisco Ximénez; manuscript history is not a substitute for present-day community authority.',
       access_or_reuse_restrictions='Catalogue metadata, facsimile locator and independent summary only; no bulk manuscript or modern-translation reproduction.',
       community_permission_required=0
 WHERE id='source.maya.popol_vuh.loc';

INSERT OR IGNORE INTO sources(
    id,title,original_title,source_type,evidence_tier,institution,author_or_editor,
    language_id,publication_date,accessed_date,url,rights_status,source_perspective,
    community_or_lineage,living_tradition,access_or_reuse_restrictions,
    community_permission_required,translation_status,verification_status,notes
) VALUES
('source.japanese.kusanagi.yamatanoorochi.kokugakuin','Yamatanoorochi','ヤマタノオロチ','ACADEMIC_REFERENCE',4,'Kokugakuin University Digital Museum','Matsunaga Naomichi','lang.en',NULL,'2026-09-01','https://d-museum.kokugakuin.ac.jp/eos/detail/?id=9729','All rights reserved; metadata, locator and independent summary only','Academic Encyclopedia of Shinto entry summarizing Kojiki and Nihongi narrative layers','Japanese Shinto',1,'No article reproduction; current public summary is not permission for non-public shrine material.',0,'English academic reference entry','URL_SYNTAX_VALID','Used only for the named serpent, sword-discovery and presentation sequence.'),
('source.japanese.kusanagi.atsuta_official','Atsuta Jingu: Introduction','熱田神宮','LIVING_TRADITION_OFFICIAL_SITE',3,'Atsuta Jingu',NULL,'lang.en',NULL,'2026-09-01','https://www.atsutajingu.or.jp/en/intro/','Shrine website rights apply; metadata, locator and independent summary only','Official public shrine account of Kusanagi-no-tsurugi and Atsuta enshrinement tradition','Atsuta Jingu',1,'Public introduction only; no inference about restricted rites, unseen regalia or physical continuity beyond the source statement.',0,'Official English public page','URL_SYNTAX_VALID','Current shrine account is kept separate from ancient-text academic summaries.'),
('source.khmer.angkor_wat.apsara','Angkor Wat','ប្រាសាទអង្គរវត្ត','OFFICIAL_HERITAGE_AUTHORITY',2,'APSARA National Authority',NULL,'lang.en','2021-06-14','2026-09-01','https://apsaraauthority.gov.kh/2021/06/14/angkor-wat/','APSARA National Authority website rights apply; metadata, locator and independent summary only','Official Cambodian heritage-authority description of Angkor Wat galleries','Khmer living heritage context',1,'Describe the public monument and gallery locator only; do not infer current ritual authority or reproduce site media.',0,'Official English public page','URL_SYNTAX_VALID','The southern section of the eastern gallery is the only narrative locator used in this batch.'),
('source.khmer.angkor.unesco668','Angkor — World Heritage property 668',NULL,'OFFICIAL_ARCHAEOLOGICAL_SITE',3,'UNESCO World Heritage Centre',NULL,'lang.en',NULL,'2026-09-01','https://whc.unesco.org/en/list/668/','Description available under CC BY-SA IGO 3.0; other media may have separate rights','Official World Heritage description of Angkor as an archaeological and living heritage site','Khmer living heritage context',1,'Use the licensed site description with attribution; do not generalize living practices or reproduce separately licensed media.',0,'Official multilingual heritage record','URL_SYNTAX_VALID','Property 668 supplies the archaeological-site scope and Angkor Wat membership context.');

INSERT OR IGNORE INTO entities(
    id,canonical_name,name_zh,original_name,transliteration,primary_type,
    primary_civilization_id,historical_period,description,research_status,
    evidence_status,record_version,metadata_json,created_at,updated_at
) VALUES
('monster.kiche.seven_macaw','Seven Macaw','七金刚鹦鹉',NULL,NULL,'MONSTER','civ.maya','Popol Vuh narrative horizon','Named opponent in the public Smithsonian summary of the K''iche'' Maya Hero Twins episode.','PARTIAL','SOURCE_BACKED',1,'{"scope":"NMAI public Hero Twins section"}','2026-09-01T06:30:00Z','2026-09-01T06:30:00Z'),
('event.kiche.hero_twins.seven_macaw','Hero Twins and Seven Macaw episode','英雄双子与七金刚鹦鹉事件',NULL,NULL,'EVENT','civ.maya','Popol Vuh narrative horizon','A bounded episode indexed from a public K''iche''-attributed Smithsonian overview, not a universal Maya master narrative.','PARTIAL','SOURCE_BACKED',1,'{"access":"ATTRIBUTION_REQUIRED"}','2026-09-01T06:30:00Z','2026-09-01T06:30:00Z'),
('monster.japanese.yamata_no_orochi','Yamata no Orochi','八岐大蛇','八岐大蛇','Yamata no Orochi','MONSTER','civ.japanese_shinto','Kojiki and Nihongi narrative layers','The great serpent in the source-scoped Kusanagi discovery account.','PARTIAL','SOURCE_BACKED',1,'{}','2026-09-01T06:30:00Z','2026-09-01T06:30:00Z'),
('event.japanese.kusanagi.discovery','Discovery of Kusanagi in Yamata no Orochi','从八岐大蛇体内发现草薙剑',NULL,NULL,'EVENT','civ.japanese_shinto','Kojiki and Nihongi narrative layers','Academic-reference-scoped event connecting Susanoo, Yamata no Orochi and Kusanagi.','PARTIAL','SOURCE_BACKED',1,'{}','2026-09-01T06:30:00Z','2026-09-01T06:30:00Z'),
('site.japanese.atsuta_jingu','Atsuta Jingu','热田神宫','熱田神宮','Atsuta Jingū','TEMPLE','civ.japanese_shinto','Living shrine with historically layered traditions','Real sacred site represented here only through its official public account.','PARTIAL','SOURCE_BACKED',1,'{"reality":"REAL_SACRED"}','2026-09-01T06:30:00Z','2026-09-01T06:30:00Z'),
('event.japanese.kusanagi.atsuta_enshrinement','Kusanagi enshrinement tradition at Atsuta','草薙剑奉祀热田传统',NULL,NULL,'EVENT','civ.japanese_shinto','Official Atsuta public tradition','A source-scoped living shrine account linked to Yamato Takeru; it does not prove uninterrupted physical custody.','PARTIAL','SOURCE_BACKED',1,'{"scope":"official public shrine account"}','2026-09-01T06:30:00Z','2026-09-01T06:30:00Z'),
('site.khmer.angkor_wat','Angkor Wat','吴哥寺','អង្គរវត្ត','Angkor Wat','ARCHAEOLOGICAL_SITE','civ.khmer','Angkorian period','Real temple within the Angkor World Heritage property; public material-witness claims use official heritage sources.','PARTIAL','SOURCE_BACKED',1,'{"unesco_property":"668"}','2026-09-01T06:30:00Z','2026-09-01T06:30:00Z'),
('monument.khmer.angkor_wat_churning_relief','Angkor Wat Churning of the Sea of Milk relief','吴哥寺“乳海搅拌”浮雕','ចម្លាក់កូរសមុទ្រទឹកដោះ',NULL,'MONUMENT','civ.khmer','Angkorian period','In-situ bas-relief identified by APSARA in the southern section of Angkor Wat''s eastern gallery.','PARTIAL','SOURCE_BACKED',1,'{"witness_kind":"IN_SITU_BAS_RELIEF"}','2026-09-01T06:30:00Z','2026-09-01T06:30:00Z'),
('event.khmer.angkor_wat_churning_scene','Churning of the Sea of Milk scene at Angkor Wat','吴哥寺乳海搅拌图像事件',NULL,NULL,'EVENT','civ.khmer','Angkorian material witness','The scene as represented by the Angkor Wat relief; it is not treated as a complete Sanskrit textual version.','PARTIAL','SOURCE_BACKED',1,'{"knowledge_layer":"ARCHAEOLOGICAL"}','2026-09-01T06:30:00Z','2026-09-01T06:30:00Z');

INSERT OR IGNORE INTO entity_classifications(entity_id,type_code,is_primary,notes) VALUES
('monster.kiche.seven_macaw','MONSTER',1,'Source-scoped narrative opponent.'),
('event.kiche.hero_twins.seven_macaw','EVENT',1,'Bounded public story episode.'),
('monster.japanese.yamata_no_orochi','MONSTER',1,'Kojiki/Nihongi academic-reference scope.'),
('event.japanese.kusanagi.discovery','EVENT',1,'Kusanagi discovery narrative.'),
('site.japanese.atsuta_jingu','TEMPLE',1,'Living real sacred site.'),
('event.japanese.kusanagi.atsuta_enshrinement','EVENT',1,'Official shrine tradition event.'),
('site.khmer.angkor_wat','ARCHAEOLOGICAL_SITE',1,'Real site within UNESCO property 668.'),
('monument.khmer.angkor_wat_churning_relief','MONUMENT',1,'In-situ architectural relief.'),
('event.khmer.angkor_wat_churning_scene','EVENT',1,'Materially attested represented scene.');

INSERT OR IGNORE INTO entity_civilizations(entity_id,civilization_id,association_role,certainty,notes) VALUES
('monster.kiche.seven_macaw','civ.maya','KICHE_NARRATIVE','SUPPORTED','K''iche''-attributed public source scope.'),
('event.kiche.hero_twins.seven_macaw','civ.maya','KICHE_NARRATIVE','SUPPORTED','Not generalized to all Maya traditions.'),
('monster.japanese.yamata_no_orochi','civ.japanese_shinto','TEXTUAL_ATTESTATION','SUPPORTED','Academic entry cites Kojiki and Nihongi layers.'),
('event.japanese.kusanagi.discovery','civ.japanese_shinto','TEXTUAL_ATTESTATION','SUPPORTED','Academic source scope.'),
('site.japanese.atsuta_jingu','civ.japanese_shinto','LIVING_SACRED_SITE','CONFIRMED','Official shrine public account.'),
('event.japanese.kusanagi.atsuta_enshrinement','civ.japanese_shinto','LIVING_TRADITION','SUPPORTED','Current official public account.'),
('site.khmer.angkor_wat','civ.khmer','ARCHAEOLOGICAL_CONTEXT','CONFIRMED','UNESCO property 668 and APSARA.'),
('monument.khmer.angkor_wat_churning_relief','civ.khmer','MATERIAL_WITNESS','CONFIRMED','APSARA gallery locator.'),
('event.khmer.angkor_wat_churning_scene','civ.khmer','MATERIAL_WITNESS','SUPPORTED','Khmer representation kept distinct from textual versions.');

INSERT OR IGNORE INTO names(
    id,entity_id,name_text,normalized_text,language_id,script_name,name_type,
    transliteration_scheme,is_preferred,source_id,notes
) VALUES
('name.v0280.hunahpu.quc','hero.kiche.hunahpu','Junajpu','junajpu','lang.quc','Latin','ORIGINAL',NULL,1,'source.maya.creation.nmai','Specific K''iche'' language tag added without deleting the legacy umbrella-language row.'),
('name.v0280.xbalanque.quc','hero.kiche.xbalanque','Xb’alanke','xb’alanke','lang.quc','Latin','ORIGINAL',NULL,1,'source.maya.creation.nmai','Specific K''iche'' language tag added without deleting the legacy umbrella-language row.'),
('name.v0280.seven_macaw.en','monster.kiche.seven_macaw','Seven Macaw','seven macaw','lang.en','Latin','CANONICAL',NULL,1,'source.maya.creation.nmai','Public Smithsonian label.'),
('name.v0280.seven_macaw.zh','monster.kiche.seven_macaw','七金刚鹦鹉','七金刚鹦鹉','lang.zh','Han','TRANSLATION',NULL,1,'source.maya.creation.nmai','Independent Chinese label; no unverified K''iche'' form supplied.'),
('name.v0280.orochi.original','monster.japanese.yamata_no_orochi','八岐大蛇','八岐大蛇','lang.ojp','Kanji','ORIGINAL',NULL,1,'source.japanese.kusanagi.yamatanoorochi.kokugakuin','Academic entry heading and source context.'),
('name.v0280.orochi.en','monster.japanese.yamata_no_orochi','Yamata no Orochi','yamata no orochi','lang.en','Latin','CANONICAL',NULL,1,'source.japanese.kusanagi.yamatanoorochi.kokugakuin','Academic romanization.'),
('name.v0280.orochi.zh','monster.japanese.yamata_no_orochi','八岐大蛇','八岐大蛇','lang.zh','Han','TRANSLATION',NULL,1,'source.japanese.kusanagi.yamatanoorochi.kokugakuin','Chinese label.'),
('name.v0280.atsuta.original','site.japanese.atsuta_jingu','熱田神宮','熱田神宮','lang.jpn','Kanji','ORIGINAL',NULL,1,'source.japanese.kusanagi.atsuta_official','Official shrine name.'),
('name.v0280.atsuta.en','site.japanese.atsuta_jingu','Atsuta Jingu','atsuta jingu','lang.en','Latin','CANONICAL',NULL,1,'source.japanese.kusanagi.atsuta_official','Official English public name.'),
('name.v0280.atsuta.zh','site.japanese.atsuta_jingu','热田神宫','热田神宫','lang.zh','Han','TRANSLATION',NULL,1,'source.japanese.kusanagi.atsuta_official','Chinese label.'),
('name.v0280.angkor_wat.khm','site.khmer.angkor_wat','អង្គរវត្ត','អង្គរវត្ត','lang.khm','Khmer','ORIGINAL',NULL,1,'source.khmer.angkor_wat.apsara','Khmer site name.'),
('name.v0280.angkor_wat.en','site.khmer.angkor_wat','Angkor Wat','angkor wat','lang.en','Latin','CANONICAL',NULL,1,'source.khmer.angkor.unesco668','UNESCO English name.'),
('name.v0280.angkor_wat.zh','site.khmer.angkor_wat','吴哥寺','吴哥寺','lang.zh','Han','TRANSLATION',NULL,1,'source.khmer.angkor.unesco668','Chinese site label.'),
('name.v0280.relief.en','monument.khmer.angkor_wat_churning_relief','Angkor Wat Churning of the Sea of Milk relief','angkor wat churning of the sea of milk relief','lang.en','Latin','CANONICAL',NULL,1,'source.khmer.angkor_wat.apsara','Official subject and site locator combined as a database label.'),
('name.v0280.relief.zh','monument.khmer.angkor_wat_churning_relief','吴哥寺“乳海搅拌”浮雕','吴哥寺乳海搅拌浮雕','lang.zh','Han','TRANSLATION',NULL,1,'source.khmer.angkor_wat.apsara','Material-witness label.');

INSERT OR IGNORE INTO names(
    id,entity_id,name_text,normalized_text,language_id,script_name,name_type,
    transliteration_scheme,is_preferred,source_id,notes
) VALUES
('name.v0280.maya.event.en','event.kiche.hero_twins.seven_macaw','Hero Twins and Seven Macaw episode','hero twins seven macaw episode','lang.en','Latin','DESCRIPTIVE',NULL,1,'source.maya.creation.nmai','Bounded event label for the public K''iche''-attributed overview.'),
('name.v0280.maya.event.zh','event.kiche.hero_twins.seven_macaw','英雄双子与七金刚鹦鹉事件','英雄双子七金刚鹦鹉事件','lang.zh','Han','TRANSLATION',NULL,1,'source.maya.creation.nmai','Independent Chinese event label.'),
('name.v0280.kusanagi.discovery.en','event.japanese.kusanagi.discovery','Discovery of Kusanagi in Yamata no Orochi','discovery kusanagi yamata no orochi','lang.en','Latin','DESCRIPTIVE',NULL,1,'source.japanese.kusanagi.yamatanoorochi.kokugakuin','Source-scoped narrative event label.'),
('name.v0280.kusanagi.discovery.zh','event.japanese.kusanagi.discovery','从八岐大蛇体内发现草薙剑','八岐大蛇草薙剑发现','lang.zh','Han','TRANSLATION',NULL,1,'source.japanese.kusanagi.yamatanoorochi.kokugakuin','Independent Chinese event label.'),
('name.v0280.kusanagi.atsuta.en','event.japanese.kusanagi.atsuta_enshrinement','Kusanagi enshrinement tradition at Atsuta','kusanagi enshrinement tradition atsuta','lang.en','Latin','DESCRIPTIVE',NULL,1,'source.japanese.kusanagi.atsuta_official','Official-public-tradition event label.'),
('name.v0280.kusanagi.atsuta.zh','event.japanese.kusanagi.atsuta_enshrinement','草薙剑奉祀热田传统','草薙剑奉祀热田传统','lang.zh','Han','TRANSLATION',NULL,1,'source.japanese.kusanagi.atsuta_official','Independent Chinese event label.'),
('name.v0280.khmer.event.en','event.khmer.angkor_wat_churning_scene','Angkor Wat Churning of the Sea of Milk scene','angkor wat churning sea milk scene','lang.en','Latin','DESCRIPTIVE',NULL,1,'source.khmer.angkor_wat.apsara','Materially attested scene label.'),
('name.v0280.khmer.event.zh','event.khmer.angkor_wat_churning_scene','吴哥寺乳海搅拌图像事件','吴哥寺乳海搅拌图像事件','lang.zh','Han','TRANSLATION',NULL,1,'source.khmer.angkor_wat.apsara','Independent Chinese event label.');

INSERT OR IGNORE INTO creature_profiles(
    entity_id,creature_class,appearance_json,abilities_json,weaknesses_json,
    habitat_summary,origin_summary,fate_summary
) VALUES
('monster.kiche.seven_macaw','NAMED_MYTHIC_OPPONENT','{}','[]','[]',NULL,'Registered only from the public Smithsonian K''iche''-attributed Hero Twins overview.','The public overview says the Hero Twins defeat Seven Macaw; no larger cycle is inferred here.'),
('monster.japanese.yamata_no_orochi','MYTHIC_SERPENT','{}','[]','[]',NULL,'Registered from the Kokugakuin academic summary of Kojiki and Nihongi narrative layers.','Defeated by Susanoo in the source-scoped narrative; Kusanagi is then found in the serpent''s tail.');

INSERT OR IGNORE INTO place_profiles(
    entity_id,place_type,ancient_name,modern_name,country_code,latitude,longitude,
    date_range,builders,architecture_summary,excavation_summary,major_finds_summary,
    unesco_status,reality_status,evidence_grade
) VALUES
('site.japanese.atsuta_jingu','LIVING_SHRINE','熱田神宮','Atsuta Jingu','JP',NULL,NULL,NULL,NULL,'Official public shrine account; no restricted precinct or regalia details collected.',NULL,'Kusanagi enshrinement tradition is recorded only at public-summary level.',NULL,'REAL_SACRED','OFFICIAL_PUBLIC_ACCOUNT'),
('site.khmer.angkor_wat','TEMPLE','អង្គរវត្ត','Angkor Wat','KH',NULL,NULL,'Angkorian period',NULL,'Temple within the Angkor World Heritage property; the v0.28 story uses the eastern-gallery relief locator.',NULL,'In-situ Churning of the Sea of Milk bas-relief.','Part of Angkor World Heritage property 668','REAL_ARCHAEOLOGICAL','OFFICIAL_HERITAGE_AUTHORITY'),
('monument.khmer.angkor_wat_churning_relief','ARCHITECTURAL_RELIEF','ចម្លាក់កូរសមុទ្រទឹកដោះ','Angkor Wat Churning of the Sea of Milk relief','KH',NULL,NULL,'Angkorian period',NULL,'APSARA locates the in-situ relief in the southern section of Angkor Wat''s eastern gallery.',NULL,'Material witness identified as the Churning of the Sea of Milk.','Within Angkor World Heritage property 668','REAL_ARCHAEOLOGICAL','OFFICIAL_HERITAGE_AUTHORITY');

UPDATE place_profiles
   SET date_range='Khmer capitals and monuments, 9th–15th centuries CE',
       architecture_summary='Angkor Archaeological Park includes Angkor Wat and other Khmer monuments within World Heritage property 668.',
       unesco_status='World Heritage property 668',
       evidence_grade='OFFICIAL_UNESCO'
 WHERE entity_id='site.cambodia.angkor';

UPDATE entities
   SET research_status='PARTIAL',evidence_status='SOURCE_BACKED',updated_at='2026-09-01T06:30:00Z'
 WHERE id IN ('hero.kiche.hunahpu','hero.kiche.xbalanque','text.kiche.popol_vuh',
              'weapon.japanese.kusanagi','deity.japanese.susanoo',
              'hero.japanese.yamato_takeru','deity.japanese.amaterasu',
              'site.cambodia.angkor');

UPDATE artifact_profiles
   SET creation_summary='Kokugakuin University''s source-scoped academic entry places the sword''s discovery in the Yamata no Orochi episode.',
       fate_summary='Atsuta Jingu''s official public account links Kusanagi to the shrine through Yamato Takeru; no claim of independently verified physical continuity is made.'
 WHERE entity_id='weapon.japanese.kusanagi';

INSERT OR IGNORE INTO myth_event_profiles(
    entity_id,event_type,time_layer,cause_summary,process_summary,result_summary,symbolism_summary
) VALUES
('event.kiche.hero_twins.seven_macaw','HEROIC_CONFLICT','K''iche''-attributed public Popol Vuh narrative','The public Smithsonian overview introduces Seven Macaw as an opponent in the Hero Twins cycle.','Hunahpu and Xbalanque act together in the bounded episode.','The public overview states that the twins defeat Seven Macaw.','No universal Maya interpretation is inferred from this one public K''iche''-attributed presentation.'),
('event.japanese.kusanagi.discovery','MONSTER_COMBAT_AND_ARTIFACT_DISCOVERY','Kojiki/Nihongi academic-reference scope','Susanoo encounters Yamata no Orochi in the source-scoped narrative.','The serpent is defeated and the sword is found in its tail.','The sword is presented to Amaterasu in the academic summary.','Interpretive river, agriculture or political readings remain separate scholarly hypotheses.'),
('event.japanese.kusanagi.atsuta_enshrinement','SACRED_ARTIFACT_TRANSMISSION','Atsuta Jingu official public tradition','The official shrine history connects Yamato Takeru, the sword and Hikami.','The account says the sword was left behind and Atsuta was chosen as the enshrinement site.','Kusanagi is publicly described as enshrined at Atsuta.','A living shrine account is not treated as proof of every ancient textual or material-continuity claim.'),
('event.khmer.angkor_wat_churning_scene','MATERIAL_MYTHIC_REPRESENTATION','Angkorian in-situ relief','APSARA identifies the gallery subject as the Churning of the Sea of Milk.','The scene is represented in relief on the southern section of the eastern gallery.','A durable Khmer material witness is publicly locatable at Angkor Wat.','The relief is not converted into a complete or universal Sanskrit textual narrative.');

INSERT OR IGNORE INTO claims(
    id,subject_id,predicate,object_entity_id,object_literal,object_datatype,statement,
    variant_group,claim_status,confidence,confidence_level,review_status,
    assertion_scope,knowledge_layer,tradition_scope,temporal_scope,research_notes,created_at
) VALUES
('claim.v0280.maya.twins_pair','hero.kiche.hunahpu','ASSOCIATED_WITH','hero.kiche.xbalanque',NULL,NULL,'The Smithsonian public K''iche''-attributed overview presents Hunahpu and Xbalanque together as the Hero Twins.','v0280.maya.hero_twins.public_overview','SUPPORTED',0.92,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','K''iche'' Maya public institutional context',NULL,'Does not establish one standard story for all Maya communities.','2026-09-01T06:30:00Z'),
('claim.v0280.maya.hunahpu_defeats_seven_macaw','hero.kiche.hunahpu','DEFEATED','monster.kiche.seven_macaw',NULL,NULL,'The public Smithsonian overview states that Hunahpu and Xbalanque defeated Seven Macaw.','v0280.maya.hero_twins.seven_macaw','SUPPORTED',0.90,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','K''iche'' Maya public institutional context',NULL,'Episode-level summary only.','2026-09-01T06:30:00Z'),
('claim.v0280.maya.xbalanque_defeats_seven_macaw','hero.kiche.xbalanque','DEFEATED','monster.kiche.seven_macaw',NULL,NULL,'The public Smithsonian overview states that Hunahpu and Xbalanque defeated Seven Macaw.','v0280.maya.hero_twins.seven_macaw','SUPPORTED',0.90,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','K''iche'' Maya public institutional context',NULL,'Episode-level summary only.','2026-09-01T06:30:00Z'),
('claim.v0280.maya.hunahpu_participates','hero.kiche.hunahpu','PARTICIPATED_IN','event.kiche.hero_twins.seven_macaw',NULL,NULL,'Hunahpu is a named participant in the bounded Seven Macaw episode.','v0280.maya.hero_twins.seven_macaw','SUPPORTED',0.90,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','K''iche'' Maya public institutional context',NULL,'Participant edge derived only from the same public overview.','2026-09-01T06:30:00Z'),
('claim.v0280.maya.xbalanque_participates','hero.kiche.xbalanque','PARTICIPATED_IN','event.kiche.hero_twins.seven_macaw',NULL,NULL,'Xbalanque is a named participant in the bounded Seven Macaw episode.','v0280.maya.hero_twins.seven_macaw','SUPPORTED',0.90,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','K''iche'' Maya public institutional context',NULL,'Participant edge derived only from the same public overview.','2026-09-01T06:30:00Z'),
('claim.v0280.maya.seven_macaw_participates','monster.kiche.seven_macaw','PARTICIPATED_IN','event.kiche.hero_twins.seven_macaw',NULL,NULL,'Seven Macaw is the named opponent in the bounded public Hero Twins episode.','v0280.maya.hero_twins.seven_macaw','SUPPORTED',0.90,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','K''iche'' Maya public institutional context',NULL,'No unverified K''iche'' name is supplied.','2026-09-01T06:30:00Z'),
('claim.v0280.japan.susanoo_defeats_orochi','deity.japanese.susanoo','DEFEATED','monster.japanese.yamata_no_orochi',NULL,NULL,'The Kokugakuin academic entry summarizes Susanoo defeating Yamata no Orochi.','v0280.japan.kusanagi.orochi','SUPPORTED',0.94,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Kojiki and Nihongi academic-reference scope',NULL,'Interpretive theories on the myth are not promoted as narrative facts.','2026-09-01T06:30:00Z'),
('claim.v0280.japan.susanoo_discovery_event','deity.japanese.susanoo','PARTICIPATED_IN','event.japanese.kusanagi.discovery',NULL,NULL,'Susanoo is the actor who defeats the serpent and finds the sword in the academic summary.','v0280.japan.kusanagi.discovery','SUPPORTED',0.94,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Kojiki and Nihongi academic-reference scope',NULL,'Source-scoped participant edge.','2026-09-01T06:30:00Z'),
('claim.v0280.japan.orochi_discovery_event','monster.japanese.yamata_no_orochi','PARTICIPATED_IN','event.japanese.kusanagi.discovery',NULL,NULL,'Yamata no Orochi is the serpent in whose tail the sword is found in the academic summary.','v0280.japan.kusanagi.discovery','SUPPORTED',0.94,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Kojiki and Nihongi academic-reference scope',NULL,'Source-scoped participant edge.','2026-09-01T06:30:00Z'),
('claim.v0280.japan.kusanagi_discovery_event','weapon.japanese.kusanagi','PARTICIPATED_IN','event.japanese.kusanagi.discovery',NULL,NULL,'Kusanagi is the named sword discovered in the serpent''s tail in the academic summary.','v0280.japan.kusanagi.discovery','SUPPORTED',0.94,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Kojiki and Nihongi academic-reference scope',NULL,'Artifact identity is narrative, not an archaeological find claim.','2026-09-01T06:30:00Z'),
('claim.v0280.japan.kusanagi_presented_amaterasu','weapon.japanese.kusanagi','PRESENTED_TO','deity.japanese.amaterasu',NULL,NULL,'The Kokugakuin entry says Susanoo presented the sword to Amaterasu.','v0280.japan.kusanagi.presentation','SUPPORTED',0.92,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Kojiki and Nihongi academic-reference scope',NULL,'Presentation is retained as a source statement; later custody is a separate layer.','2026-09-01T06:30:00Z'),
('claim.v0280.japan.kusanagi_worshipped_atsuta','weapon.japanese.kusanagi','WORSHIPPED_AT','site.japanese.atsuta_jingu',NULL,NULL,'Atsuta Jingu''s official public introduction describes Kusanagi-no-tsurugi as enshrined at the shrine.','v0280.japan.kusanagi.atsuta','SUPPORTED',0.90,'HIGH','VERIFIED','TEXT_SAYS','RITUAL_PRACTICE','Atsuta Jingu official public account','Current public account','No inference about unseen regalia or restricted rites.','2026-09-01T06:30:00Z'),
('claim.v0280.japan.yamato_atsuta_event','hero.japanese.yamato_takeru','PARTICIPATED_IN','event.japanese.kusanagi.atsuta_enshrinement',NULL,NULL,'The official shrine history links Yamato Takeru''s death after leaving the sword in Hikami to the Atsuta enshrinement account.','v0280.japan.kusanagi.atsuta','SUPPORTED',0.88,'MEDIUM','VERIFIED','TEXT_SAYS','LATER_RECEPTION','Atsuta Jingu official public account','Current public account','This is a living shrine history layer, not a direct ancient-text quotation.','2026-09-01T06:30:00Z'),
('claim.v0280.japan.kusanagi_atsuta_event','weapon.japanese.kusanagi','PARTICIPATED_IN','event.japanese.kusanagi.atsuta_enshrinement',NULL,NULL,'Kusanagi is the sacred artifact at the center of the official Atsuta enshrinement account.','v0280.japan.kusanagi.atsuta','SUPPORTED',0.90,'HIGH','VERIFIED','TEXT_SAYS','LATER_RECEPTION','Atsuta Jingu official public account','Current public account','Source-scoped participant edge.','2026-09-01T06:30:00Z'),
('claim.v0280.japan.kusanagi_source_boundary','weapon.japanese.kusanagi','SOURCE_LAYER_BOUNDARY',NULL,'Academic Kojiki/Nihongi synopsis and current Atsuta shrine account remain separate evidence layers.','STRING','The v0.28 reading layer keeps the academic ancient-text synopsis separate from the current shrine''s public tradition and makes no independent physical-continuity claim.','v0280.japan.kusanagi.source_boundary','INTERPRETIVE',0.98,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Editorial evidence boundary',NULL,'Both sources support the need to label their distinct source perspectives.','2026-09-01T06:30:00Z'),
('claim.v0280.khmer.angkor_unesco','site.cambodia.angkor','WORLD_HERITAGE_STATUS',NULL,'UNESCO World Heritage property 668; archaeological park containing Angkor Wat.','STRING','UNESCO identifies Angkor as a major Southeast Asian archaeological site and includes Angkor Wat within property 668.','v0280.khmer.angkor.heritage','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','UNESCO World Heritage property 668','9th–15th centuries CE for the broader property','Official site context only.','2026-09-01T06:30:00Z'),
('claim.v0280.khmer.angkor_wat_part_of_angkor','site.khmer.angkor_wat','PART_OF','site.cambodia.angkor',NULL,NULL,'Angkor Wat is a named monument within the Angkor World Heritage property.','v0280.khmer.angkor.heritage','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','UNESCO World Heritage property 668','Angkorian period','No broader boundary geometry is inferred.','2026-09-01T06:30:00Z'),
('claim.v0280.khmer.relief_part_of_angkor_wat','monument.khmer.angkor_wat_churning_relief','PART_OF','site.khmer.angkor_wat',NULL,NULL,'APSARA locates the Churning of the Sea of Milk relief within Angkor Wat.','v0280.khmer.angkor_wat.relief','SUPPORTED',0.98,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','APSARA public monument description','Angkorian period','In-situ material-witness relation.','2026-09-01T06:30:00Z'),
('claim.v0280.khmer.relief_depicts_churning','monument.khmer.angkor_wat_churning_relief','DEPICTS','event.khmer.angkor_wat_churning_scene',NULL,NULL,'APSARA identifies the relief subject as the Churning of the Sea of Milk.','v0280.khmer.angkor_wat.relief','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','ARCHAEOLOGICAL','APSARA public monument description','Angkorian period','Material depiction does not by itself determine a complete textual version.','2026-09-01T06:30:00Z'),
('claim.v0280.khmer.relief_gallery_locator','monument.khmer.angkor_wat_churning_relief','LOCATED_IN_GALLERY',NULL,'southern section of Angkor Wat''s eastern gallery','STRING','The APSARA page locates the reliefs on the southern section of the eastern gallery.','v0280.khmer.angkor_wat.relief','SUPPORTED',0.98,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','APSARA public monument description','Current in-situ locator','No coordinates are inferred.','2026-09-01T06:30:00Z'),
('claim.v0280.khmer.material_scope','event.khmer.angkor_wat_churning_scene','EVIDENCE_SCOPE',NULL,'In-situ Khmer material witness; not a complete or universal Sanskrit textual recension.','STRING','The public story treats the Angkor Wat relief as a Khmer material witness and does not reconstruct an unlocated textual version from the image alone.','v0280.khmer.angkor_wat.scope','INTERPRETIVE',0.99,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Material-witness editorial boundary',NULL,'Preserves textual, archaeological and living-heritage layers.','2026-09-01T06:30:00Z');

INSERT OR IGNORE INTO evidence(
    id,claim_id,source_id,source_location,chapter,verse,line,page,catalogue_number,
    short_quote,evidence_type,direction,strength,research_notes
) VALUES
('evidence.v0280.maya.twins_pair','claim.v0280.maya.twins_pair','source.maya.creation.nmai','Creation Story of the Maya — Hero Twins section',NULL,NULL,NULL,NULL,NULL,NULL,'MODERN_SCHOLARSHIP','SUPPORTS',0.92,'Public institutional summary; no long quotation retained.'),
('evidence.v0280.maya.hunahpu_defeats','claim.v0280.maya.hunahpu_defeats_seven_macaw','source.maya.creation.nmai','Creation Story of the Maya — Hero Twins and Seven Macaw section',NULL,NULL,NULL,NULL,NULL,NULL,'MODERN_SCHOLARSHIP','SUPPORTS',0.90,'Episode-level independent summary.'),
('evidence.v0280.maya.xbalanque_defeats','claim.v0280.maya.xbalanque_defeats_seven_macaw','source.maya.creation.nmai','Creation Story of the Maya — Hero Twins and Seven Macaw section',NULL,NULL,NULL,NULL,NULL,NULL,'MODERN_SCHOLARSHIP','SUPPORTS',0.90,'Episode-level independent summary.'),
('evidence.v0280.maya.hunahpu_participates','claim.v0280.maya.hunahpu_participates','source.maya.creation.nmai','Creation Story of the Maya — Hero Twins section',NULL,NULL,NULL,NULL,NULL,NULL,'MODERN_SCHOLARSHIP','SUPPORTS',0.90,'Participant extraction from the same public overview.'),
('evidence.v0280.maya.xbalanque_participates','claim.v0280.maya.xbalanque_participates','source.maya.creation.nmai','Creation Story of the Maya — Hero Twins section',NULL,NULL,NULL,NULL,NULL,NULL,'MODERN_SCHOLARSHIP','SUPPORTS',0.90,'Participant extraction from the same public overview.'),
('evidence.v0280.maya.seven_macaw_participates','claim.v0280.maya.seven_macaw_participates','source.maya.creation.nmai','Creation Story of the Maya — Seven Macaw section',NULL,NULL,NULL,NULL,NULL,NULL,'MODERN_SCHOLARSHIP','SUPPORTS',0.90,'Opponent extraction from the same public overview.'),
('evidence.v0280.japan.susanoo_defeats','claim.v0280.japan.susanoo_defeats_orochi','source.japanese.kusanagi.yamatanoorochi.kokugakuin','Yamatanoorochi — Kojiki/Nihongi narrative summary',NULL,NULL,NULL,NULL,NULL,NULL,'MODERN_SCHOLARSHIP','SUPPORTS',0.94,'Academic entry; no article text reproduced.'),
('evidence.v0280.japan.susanoo_event','claim.v0280.japan.susanoo_discovery_event','source.japanese.kusanagi.yamatanoorochi.kokugakuin','Yamatanoorochi — sword discovery sequence',NULL,NULL,NULL,NULL,NULL,NULL,'MODERN_SCHOLARSHIP','SUPPORTS',0.94,'Source-scoped event index.'),
('evidence.v0280.japan.orochi_event','claim.v0280.japan.orochi_discovery_event','source.japanese.kusanagi.yamatanoorochi.kokugakuin','Yamatanoorochi — sword discovery sequence',NULL,NULL,NULL,NULL,NULL,NULL,'MODERN_SCHOLARSHIP','SUPPORTS',0.94,'Source-scoped event index.'),
('evidence.v0280.japan.kusanagi_event','claim.v0280.japan.kusanagi_discovery_event','source.japanese.kusanagi.yamatanoorochi.kokugakuin','Yamatanoorochi — sword discovery sequence',NULL,NULL,NULL,NULL,NULL,NULL,'MODERN_SCHOLARSHIP','SUPPORTS',0.94,'Narrative artifact, not archaeological find evidence.'),
('evidence.v0280.japan.presented','claim.v0280.japan.kusanagi_presented_amaterasu','source.japanese.kusanagi.yamatanoorochi.kokugakuin','Yamatanoorochi — presentation to Amaterasu',NULL,NULL,NULL,NULL,NULL,NULL,'MODERN_SCHOLARSHIP','SUPPORTS',0.92,'Academic summary scope.'),
('evidence.v0280.japan.atsuta_worship','claim.v0280.japan.kusanagi_worshipped_atsuta','source.japanese.kusanagi.atsuta_official','Introduction — Enshrined Deities and History',NULL,NULL,NULL,NULL,NULL,NULL,'OFFICIAL_SITE','SUPPORTS',0.90,'Official public shrine account.'),
('evidence.v0280.japan.yamato_atsuta','claim.v0280.japan.yamato_atsuta_event','source.japanese.kusanagi.atsuta_official','Introduction — History',NULL,NULL,NULL,NULL,NULL,NULL,'OFFICIAL_SITE','SUPPORTS',0.88,'Living shrine history layer.'),
('evidence.v0280.japan.kusanagi_atsuta','claim.v0280.japan.kusanagi_atsuta_event','source.japanese.kusanagi.atsuta_official','Introduction — History',NULL,NULL,NULL,NULL,NULL,NULL,'OFFICIAL_SITE','SUPPORTS',0.90,'Living shrine history layer.'),
('evidence.v0280.japan.boundary_academic','claim.v0280.japan.kusanagi_source_boundary','source.japanese.kusanagi.yamatanoorochi.kokugakuin','Academic Encyclopedia of Shinto source perspective',NULL,NULL,NULL,NULL,NULL,NULL,'MODERN_SCHOLARSHIP','CONTEXT',0.98,'One of two explicitly separated evidence layers.'),
('evidence.v0280.japan.boundary_shrine','claim.v0280.japan.kusanagi_source_boundary','source.japanese.kusanagi.atsuta_official','Official public shrine source perspective',NULL,NULL,NULL,NULL,NULL,NULL,'OFFICIAL_SITE','CONTEXT',0.98,'One of two explicitly separated evidence layers.'),
('evidence.v0280.khmer.angkor_unesco','claim.v0280.khmer.angkor_unesco','source.khmer.angkor.unesco668','World Heritage property 668 — Brief synthesis',NULL,NULL,NULL,NULL,'668',NULL,'OFFICIAL_SITE','SUPPORTS',0.99,'Official archaeological-property context.'),
('evidence.v0280.khmer.angkor_wat_part','claim.v0280.khmer.angkor_wat_part_of_angkor','source.khmer.angkor.unesco668','World Heritage property 668 — Brief synthesis',NULL,NULL,NULL,NULL,'668',NULL,'OFFICIAL_SITE','SUPPORTS',0.99,'Official site membership context.'),
('evidence.v0280.khmer.relief_part','claim.v0280.khmer.relief_part_of_angkor_wat','source.khmer.angkor_wat.apsara','Angkor Wat — eastern gallery, southern section',NULL,NULL,NULL,NULL,NULL,NULL,'OFFICIAL_SITE','SUPPORTS',0.98,'Official APSARA locator.'),
('evidence.v0280.khmer.relief_depicts','claim.v0280.khmer.relief_depicts_churning','source.khmer.angkor_wat.apsara','Angkor Wat — “Churning of the Sea of Milk” relief',NULL,NULL,NULL,NULL,NULL,NULL,'OFFICIAL_SITE','SUPPORTS',0.98,'Official subject identification.'),
('evidence.v0280.khmer.gallery','claim.v0280.khmer.relief_gallery_locator','source.khmer.angkor_wat.apsara','Angkor Wat — eastern gallery, southern section',NULL,NULL,NULL,NULL,NULL,NULL,'OFFICIAL_SITE','SUPPORTS',0.98,'Public gallery locator; no coordinates inferred.'),
('evidence.v0280.khmer.scope_apsara','claim.v0280.khmer.material_scope','source.khmer.angkor_wat.apsara','Official material-witness description',NULL,NULL,NULL,NULL,NULL,NULL,'OFFICIAL_SITE','CONTEXT',0.99,'Material source layer.'),
('evidence.v0280.khmer.scope_unesco','claim.v0280.khmer.material_scope','source.khmer.angkor.unesco668','World Heritage archaeological and living-site context',NULL,NULL,NULL,NULL,'668',NULL,'OFFICIAL_SITE','CONTEXT',0.95,'Archaeological and living-heritage boundary.');

INSERT OR IGNORE INTO event_participants(event_id,participant_id,role,outcome,claim_id) VALUES
('event.kiche.hero_twins.seven_macaw','hero.kiche.hunahpu','HERO','Acts with Xbalanque in the public episode.','claim.v0280.maya.hunahpu_participates'),
('event.kiche.hero_twins.seven_macaw','hero.kiche.xbalanque','HERO','Acts with Hunahpu in the public episode.','claim.v0280.maya.xbalanque_participates'),
('event.kiche.hero_twins.seven_macaw','monster.kiche.seven_macaw','OPPONENT','Defeated in the public overview.','claim.v0280.maya.seven_macaw_participates'),
('event.japanese.kusanagi.discovery','deity.japanese.susanoo','ACTOR','Defeats the serpent and finds the sword.','claim.v0280.japan.susanoo_discovery_event'),
('event.japanese.kusanagi.discovery','monster.japanese.yamata_no_orochi','OPPONENT','Defeated in the academic narrative summary.','claim.v0280.japan.orochi_discovery_event'),
('event.japanese.kusanagi.discovery','weapon.japanese.kusanagi','DISCOVERED_ARTIFACT','Found in the serpent''s tail in the narrative.','claim.v0280.japan.kusanagi_discovery_event'),
('event.japanese.kusanagi.atsuta_enshrinement','hero.japanese.yamato_takeru','TRANSMISSION_FIGURE','Linked to the official shrine''s account.','claim.v0280.japan.yamato_atsuta_event'),
('event.japanese.kusanagi.atsuta_enshrinement','weapon.japanese.kusanagi','SACRED_ARTIFACT','Central to the public enshrinement account.','claim.v0280.japan.kusanagi_atsuta_event'),
('event.japanese.kusanagi.atsuta_enshrinement','site.japanese.atsuta_jingu','DESTINATION','Officially named shrine context.','claim.v0280.japan.kusanagi_worshipped_atsuta'),
('event.khmer.angkor_wat_churning_scene','monument.khmer.angkor_wat_churning_relief','MATERIAL_WITNESS','In-situ relief representing the scene.','claim.v0280.khmer.relief_depicts_churning'),
('event.khmer.angkor_wat_churning_scene','site.khmer.angkor_wat','REAL_SITE','Holds the material witness in its gallery.','claim.v0280.khmer.relief_part_of_angkor_wat');

INSERT OR IGNORE INTO stories(
    id,canonical_title,title_zh,story_type,primary_civilization_id,summary_zh,summary_en,
    themes_json,evidence_status,access_level,reading_minutes,featured_order,
    editorial_note,created_at,updated_at
) VALUES
('story.maya.hero_twins_seven_macaw','Hero Twins and Seven Macaw — a public K''iche''-attributed overview','英雄双子与七金刚鹦鹉：公开基切语境见证','MYTHIC_NARRATIVE','civ.maya','Smithsonian 的公开页面把胡纳普与伊斯巴兰克作为英雄双子，并叙述他们击败七金刚鹦鹉；本站只建立这一可公开定位的事件，不把它扩写成全体玛雅的标准故事。','A public Smithsonian page presents Hunahpu and Xbalanque as the Hero Twins and says they defeat Seven Macaw; this record models only that locatable episode and does not turn it into a standard story for all Maya communities.','["英雄双子","基切语境","公开机构概述","权限边界"]','SOURCE_BACKED','ATTRIBUTION_REQUIRED',5,220,'必须注明 K''iche'' Maya 语境与 Smithsonian／Library of Congress 来源；殖民时期手稿目录、当代社区权威与公开教育概述保持分层。','2026-09-01T06:30:00Z','2026-09-01T06:30:00Z'),
('story.japanese.kusanagi_transmission','Kusanagi: serpent discovery and Atsuta transmission layers','草薙剑：大蛇发现与热田传承两层见证','MYTHIC_NARRATIVE','civ.japanese_shinto','國學院大学学术条目的大蛇—神剑叙事与热田神宫当代公开传承分成两个版本；叙事呈递、奉祀与物质连续性不被混成一个事实。','The serpent-and-sword narrative in a Kokugakuin academic entry and Atsuta Jingu''s current public tradition are separate versions; narrative presentation, enshrinement and physical continuity are not collapsed into one fact.','["草薙剑","八岐大蛇","热田神宫","来源分层"]','SOURCE_BACKED','PUBLIC_CONTEXT',7,230,'古典文本学术综述与活态神社公开叙述分别标记；不采集非公开仪式或不可见神器信息。','2026-09-01T06:30:00Z','2026-09-01T06:30:00Z'),
('story.khmer.angkor_wat_churning_relief','Churning of the Sea of Milk as an Angkor Wat material witness','吴哥寺乳海搅拌：浮雕物质见证','MYTHIC_NARRATIVE','civ.khmer','APSARA 把吴哥寺东侧回廊南段浮雕标为“乳海搅拌”；本站把它登记为有现实位置的高棉物质见证，不据图像补写一部完整梵文故事。','APSARA identifies the relief in the southern section of Angkor Wat''s eastern gallery as the Churning of the Sea of Milk; the site records it as a locatable Khmer material witness without reconstructing a complete Sanskrit narrative from the image.','["吴哥寺","乳海搅拌","浮雕","物质见证","东南亚"]','SOURCE_BACKED','PUBLIC_CONTEXT',5,240,'现实遗址、浮雕图像、印度文本传统与吴哥当代活态遗产语境分层保存。','2026-09-01T06:30:00Z','2026-09-01T06:30:00Z');

INSERT OR IGNORE INTO story_versions(
    id,story_id,version_label_zh,version_label_en,source_id,source_location,
    language_id,witness_scope,narrative_scope,evidence_status,access_level,
    version_order,rights_note,created_at
) VALUES
('storyver.maya.hero_twins_nmai','story.maya.hero_twins_seven_macaw','Smithsonian 公开基切语境概述','Smithsonian public K''iche''-context overview','source.maya.creation.nmai','Creation Story of the Maya — Hero Twins and Seven Macaw sections','lang.quc','Smithsonian National Museum of the American Indian 的公开教育页面，明确放在 K''iche'' Maya《Popol Vuh》语境中','只登记英雄双子、七金刚鹦鹉与击败关系；不复制全文，不推广为所有玛雅共同版本','SOURCE_BACKED','ATTRIBUTION_REQUIRED',1,'署名 Smithsonian NMAI 与 K''iche'' Maya 语境；不复制页面长文或受限社区内容。','2026-09-01T06:30:00Z'),
('storyver.japanese.kusanagi_orochi','story.japanese.kusanagi_transmission','國學院《八岐大蛇》学术综述层','Kokugakuin Yamatanoorochi academic layer','source.japanese.kusanagi.yamatanoorochi.kokugakuin','Yamatanoorochi — Kojiki/Nihongi narrative summary','lang.ojp','國學院大学神道百科对《古事记》《日本书纪》相关叙事的公开学术综述','须佐之男击败大蛇、发现草薙剑并将剑呈给天照大神','SOURCE_BACKED','PUBLIC_CONTEXT',1,'All rights reserved；只发布元数据、定位与独立概述。','2026-09-01T06:30:00Z'),
('storyver.japanese.kusanagi_atsuta','story.japanese.kusanagi_transmission','热田神宫当代公开传承层','Atsuta Jingu current public tradition layer','source.japanese.kusanagi.atsuta_official','Introduction — Enshrined Deities and History','lang.jpn','热田神宫官方网站的当代公开说明','草薙剑、热田奉祀与日本武尊关联；不延伸到非公开仪式或物质鉴定','SOURCE_BACKED','PUBLIC_CONTEXT',2,'仅依据神社公开网页；隐藏神器、受限仪式和物质连续性均不推断。','2026-09-01T06:30:00Z'),
('storyver.khmer.angkor_churning_apsara','story.khmer.angkor_wat_churning_relief','APSARA 吴哥寺回廊浮雕层','APSARA Angkor Wat gallery relief layer','source.khmer.angkor_wat.apsara','Angkor Wat — southern section of the eastern gallery','lang.khm','APSARA 官方遗产页面对原址浮雕主题与位置的公开说明','只登记“乳海搅拌”主题、东侧回廊南段定位及其作为高棉物质见证的边界','SOURCE_BACKED','PUBLIC_CONTEXT',1,'只发布官方元数据、位置与独立概述；不复制遗产媒体。','2026-09-01T06:30:00Z');

INSERT OR IGNORE INTO story_sections(
    id,story_version_id,section_order,heading_zh,heading_en,body_zh,body_en,
    anchor_claim_id,evidence_note,uncertainty_note
) VALUES
('storysec.v0280.maya.twins.1','storyver.maya.hero_twins_nmai',1,'一对有名的英雄双子','A named pair of Hero Twins','公开 Smithsonian 概述把胡纳普与伊斯巴兰克一起称为英雄双子。','The public Smithsonian overview presents Hunahpu and Xbalanque together as the Hero Twins.','claim.v0280.maya.twins_pair','Smithsonian NMAI 公开页面的 Hero Twins 段。','拼写保留来源范围；不声称存在单一跨社区标准拼写。'),
('storysec.v0280.maya.twins.2','storyver.maya.hero_twins_nmai',2,'七金刚鹦鹉事件','The Seven Macaw episode','同一公开页面说明两位双子击败七金刚鹦鹉；本站只将这一动作建成可回溯事件。','The same public page says the two twins defeat Seven Macaw; the site models only this action as a traceable event.','claim.v0280.maya.hunahpu_defeats_seven_macaw','Smithsonian NMAI 公开页面的 Seven Macaw 段。','未在当前批次加入地下世界、球赛或后续章节。'),
('storysec.v0280.maya.twins.3','storyver.maya.hero_twins_nmai',3,'手稿与社区语境分层','Manuscript and community contexts remain distinct','美国国会图书馆目录记录殖民时期 K''iche''—西班牙语手稿见证；它为见证历史提供定位，却不代替当代 K''iche'' 社区权威。','The Library of Congress catalogue locates a colonial-period K''iche''–Spanish manuscript witness; it documents witness history but does not replace present-day K''iche'' community authority.','claim.popol_vuh.witness_context','Library of Congress 手稿目录与 Smithsonian 公开概述并列。','不从手稿可访问性推断所有社区知识均可复制。'),
('storysec.v0280.japan.orochi.1','storyver.japanese.kusanagi_orochi',1,'须佐之男与八岐大蛇','Susanoo and Yamata no Orochi','國學院学术条目概述须佐之男击败八岐大蛇。','The Kokugakuin academic entry summarizes Susanoo defeating Yamata no Orochi.','claim.v0280.japan.susanoo_defeats_orochi','國學院大学 Encyclopedia of Shinto 的 Yamatanoorochi 条目。','条目列出的象征解释仍属于学术解释，不写入叙事事实。'),
('storysec.v0280.japan.orochi.2','storyver.japanese.kusanagi_orochi',2,'在蛇尾中发现神剑','The sword found in the serpent''s tail','同一学术综述把草薙剑的发现放在大蛇尾部。','The same academic summary places the discovery of Kusanagi in the serpent''s tail.','claim.v0280.japan.kusanagi_discovery_event','Yamatanoorochi 条目的神剑发现段。','这是文本叙事，不是考古出土记录。'),
('storysec.v0280.japan.orochi.3','storyver.japanese.kusanagi_orochi',3,'呈给天照大神','Presented to Amaterasu','该条目说明须佐之男把剑呈给天照大神；后续奉祀另由不同来源版本叙述。','The entry says Susanoo presented the sword to Amaterasu; later enshrinement is handled in a different source version.','claim.v0280.japan.kusanagi_presented_amaterasu','Yamatanoorochi 条目的呈递段。','不以呈递动作自动证明所有后续持有链。'),
('storysec.v0280.japan.atsuta.1','storyver.japanese.kusanagi_atsuta',1,'热田神宫的公开奉祀说明','Atsuta''s public enshrinement account','热田神宫官网把草薙剑称为奉祀于此的神剑，并将其列入三种神圣宝物。','Atsuta Jingu''s official site describes Kusanagi as the sacred sword enshrined there and as one of the three sacred treasures.','claim.v0280.japan.kusanagi_worshipped_atsuta','热田神宫官网 Introduction 的 Enshrined Deities 与 History 段。','这是当代官方公开叙述，不是对不可见实物的独立鉴定。'),
('storysec.v0280.japan.atsuta.2','storyver.japanese.kusanagi_atsuta',2,'日本武尊传承环节','The Yamato Takeru transmission link','官网历史段把日本武尊、冰上留下神剑与热田地点选择连接起来。','The shrine history connects Yamato Takeru, the sword left at Hikami, and the choice of Atsuta as the enshrinement site.','claim.v0280.japan.yamato_atsuta_event','热田神宫官网 Introduction — History。','本批次不补写未在公开页明确说明的中间环节。'),
('storysec.v0280.japan.atsuta.3','storyver.japanese.kusanagi_atsuta',3,'两个来源层不合并','Two source layers are not merged','古典叙事的大学学术综述与活态神社公开传统分别可回溯；系统不从两者合成一条未经证明的物质连续链。','The university synopsis of classical narratives and the living shrine''s public tradition remain separately traceable; the system does not synthesize them into an unproven chain of physical continuity.','claim.v0280.japan.kusanagi_source_boundary','國學院大学与热田神宫两种来源身份并列。','非公开仪式、隐藏神器和实物鉴定均不在当前公开范围。'),
('storysec.v0280.khmer.relief.1','storyver.khmer.angkor_churning_apsara',1,'官方标出的浮雕主题','The officially identified relief subject','APSARA 官方页面把这一组浮雕标为“乳海搅拌”。','The official APSARA page identifies the reliefs as the Churning of the Sea of Milk.','claim.v0280.khmer.relief_depicts_churning','APSARA Angkor Wat 页面第 4 项。','只采用官方主题标签，不扩写人物和动作清单。'),
('storysec.v0280.khmer.relief.2','storyver.khmer.angkor_churning_apsara',2,'东侧回廊南段','Southern section of the eastern gallery','同一页面把浮雕定位到吴哥寺东侧回廊南段；事件地图只连接现实遗址档案，不推测新坐标。','The same page locates the relief in the southern section of Angkor Wat''s eastern gallery; the story map links only to the real-site profile and infers no new coordinates.','claim.v0280.khmer.relief_gallery_locator','APSARA 官方回廊定位。','吴哥寺坐标未在本批次录入，因此坐标策略为 ENTITY_PROFILE_ONLY。'),
('storysec.v0280.khmer.relief.3','storyver.khmer.angkor_churning_apsara',3,'物质见证不等于完整文本','A material witness is not a complete text','浮雕证明吴哥寺存在这一图像叙事主题；它本身不提供一部可逐句重建的完整梵文版本。','The relief attests that this visual narrative subject is present at Angkor Wat; by itself it does not provide a complete Sanskrit recension that can be reconstructed line by line.','claim.v0280.khmer.material_scope','APSARA 物质见证与 UNESCO 遗址语境。','印度文本版本将在后续目标中独立登记。');

INSERT OR IGNORE INTO story_claim_links(story_version_id,claim_id,link_role) VALUES
('storyver.maya.hero_twins_nmai','claim.v0280.maya.twins_pair','NARRATIVE_BASIS'),
('storyver.maya.hero_twins_nmai','claim.v0280.maya.hunahpu_defeats_seven_macaw','NARRATIVE_BASIS'),
('storyver.maya.hero_twins_nmai','claim.v0280.maya.xbalanque_defeats_seven_macaw','PARTICIPANT'),
('storyver.maya.hero_twins_nmai','claim.v0280.maya.hunahpu_participates','PARTICIPANT'),
('storyver.maya.hero_twins_nmai','claim.v0280.maya.xbalanque_participates','PARTICIPANT'),
('storyver.maya.hero_twins_nmai','claim.v0280.maya.seven_macaw_participates','PARTICIPANT'),
('storyver.maya.hero_twins_nmai','claim.popol_vuh.witness_context','CONTEXT'),
('storyver.japanese.kusanagi_orochi','claim.v0280.japan.susanoo_defeats_orochi','NARRATIVE_BASIS'),
('storyver.japanese.kusanagi_orochi','claim.v0280.japan.susanoo_discovery_event','PARTICIPANT'),
('storyver.japanese.kusanagi_orochi','claim.v0280.japan.orochi_discovery_event','PARTICIPANT'),
('storyver.japanese.kusanagi_orochi','claim.v0280.japan.kusanagi_discovery_event','NARRATIVE_BASIS'),
('storyver.japanese.kusanagi_orochi','claim.v0280.japan.kusanagi_presented_amaterasu','NARRATIVE_BASIS'),
('storyver.japanese.kusanagi_atsuta','claim.v0280.japan.kusanagi_worshipped_atsuta','NARRATIVE_BASIS'),
('storyver.japanese.kusanagi_atsuta','claim.v0280.japan.yamato_atsuta_event','PARTICIPANT'),
('storyver.japanese.kusanagi_atsuta','claim.v0280.japan.kusanagi_atsuta_event','PARTICIPANT'),
('storyver.japanese.kusanagi_atsuta','claim.v0280.japan.kusanagi_source_boundary','EVIDENCE_LIMIT'),
('storyver.khmer.angkor_churning_apsara','claim.v0280.khmer.angkor_unesco','CONTEXT'),
('storyver.khmer.angkor_churning_apsara','claim.v0280.khmer.angkor_wat_part_of_angkor','CONTEXT'),
('storyver.khmer.angkor_churning_apsara','claim.v0280.khmer.relief_part_of_angkor_wat','NARRATIVE_BASIS'),
('storyver.khmer.angkor_churning_apsara','claim.v0280.khmer.relief_depicts_churning','NARRATIVE_BASIS'),
('storyver.khmer.angkor_churning_apsara','claim.v0280.khmer.relief_gallery_locator','NARRATIVE_BASIS'),
('storyver.khmer.angkor_churning_apsara','claim.v0280.khmer.material_scope','EVIDENCE_LIMIT');

INSERT OR IGNORE INTO story_entity_links(
    story_id,story_version_id,entity_id,role,sort_order,notes
) VALUES
('story.maya.hero_twins_seven_macaw','storyver.maya.hero_twins_nmai','hero.kiche.hunahpu','CHARACTER',10,'Named Hero Twin in the public K''iche''-attributed overview.'),
('story.maya.hero_twins_seven_macaw','storyver.maya.hero_twins_nmai','hero.kiche.xbalanque','CHARACTER',20,'Named Hero Twin in the public K''iche''-attributed overview.'),
('story.maya.hero_twins_seven_macaw','storyver.maya.hero_twins_nmai','monster.kiche.seven_macaw','CHARACTER',30,'Named opponent in the bounded episode.'),
('story.maya.hero_twins_seven_macaw','storyver.maya.hero_twins_nmai','event.kiche.hero_twins.seven_macaw','EVENT',40,'Source-scoped episode.'),
('story.maya.hero_twins_seven_macaw','storyver.maya.hero_twins_nmai','text.kiche.popol_vuh','TEXT',50,'Colonial manuscript catalogue context; not treated as community permission.'),
('story.japanese.kusanagi_transmission','storyver.japanese.kusanagi_orochi','deity.japanese.susanoo','CHARACTER',10,'Actor in the academic narrative summary.'),
('story.japanese.kusanagi_transmission','storyver.japanese.kusanagi_orochi','monster.japanese.yamata_no_orochi','CHARACTER',20,'Serpent in the academic narrative summary.'),
('story.japanese.kusanagi_transmission','storyver.japanese.kusanagi_orochi','weapon.japanese.kusanagi','ARTIFACT',30,'Narrative artifact.'),
('story.japanese.kusanagi_transmission','storyver.japanese.kusanagi_orochi','deity.japanese.amaterasu','CHARACTER',40,'Recipient named by the academic summary.'),
('story.japanese.kusanagi_transmission','storyver.japanese.kusanagi_orochi','event.japanese.kusanagi.discovery','EVENT',50,'Source-scoped discovery event.'),
('story.japanese.kusanagi_transmission','storyver.japanese.kusanagi_atsuta','weapon.japanese.kusanagi','ARTIFACT',10,'Sacred artifact in the official public account.'),
('story.japanese.kusanagi_transmission','storyver.japanese.kusanagi_atsuta','hero.japanese.yamato_takeru','CHARACTER',20,'Transmission figure in the official public account.'),
('story.japanese.kusanagi_transmission','storyver.japanese.kusanagi_atsuta','site.japanese.atsuta_jingu','PLACE',30,'Real sacred site.'),
('story.japanese.kusanagi_transmission','storyver.japanese.kusanagi_atsuta','event.japanese.kusanagi.atsuta_enshrinement','EVENT',40,'Living shrine public-history layer.'),
('story.khmer.angkor_wat_churning_relief','storyver.khmer.angkor_churning_apsara','site.cambodia.angkor','PLACE',10,'UNESCO World Heritage property context.'),
('story.khmer.angkor_wat_churning_relief','storyver.khmer.angkor_churning_apsara','site.khmer.angkor_wat','PLACE',20,'Real archaeological site.'),
('story.khmer.angkor_wat_churning_relief','storyver.khmer.angkor_churning_apsara','monument.khmer.angkor_wat_churning_relief','ARTIFACT',30,'In-situ bas-relief material witness.'),
('story.khmer.angkor_wat_churning_relief','storyver.khmer.angkor_churning_apsara','event.khmer.angkor_wat_churning_scene','EVENT',40,'Scene as represented by the relief.');

INSERT OR IGNORE INTO story_event_nodes(
    id,story_version_id,event_order,title_zh,title_en,summary_zh,summary_en,
    anchor_claim_id,event_entity_id,place_entity_id,location_kind,coordinate_policy,
    evidence_status,uncertainty_note,created_at
) VALUES
('storyevent.v0280.maya.1','storyver.maya.hero_twins_nmai',1,'英雄双子成对出现','The Hero Twins appear as a pair','公开页面把两位英雄并列。','The public page presents the two heroes together.','claim.v0280.maya.twins_pair','event.kiche.hero_twins.seven_macaw',NULL,'UNSPECIFIED','NO_COORDINATE','SOURCE_BACKED','当前来源没有提供可安全映射的现实地点。','2026-09-01T06:30:00Z'),
('storyevent.v0280.maya.2','storyver.maya.hero_twins_nmai',2,'击败七金刚鹦鹉','Seven Macaw is defeated','双子参与同一有名对手事件。','The twins participate in the same named-opponent episode.','claim.v0280.maya.hunahpu_defeats_seven_macaw','event.kiche.hero_twins.seven_macaw',NULL,'UNSPECIFIED','NO_COORDINATE','SOURCE_BACKED','神话地点不投射为现代坐标。','2026-09-01T06:30:00Z'),
('storyevent.v0280.maya.3','storyver.maya.hero_twins_nmai',3,'见证语境边界','Witness-context boundary','殖民时期手稿目录与当代社区权威保持分开。','The colonial manuscript catalogue remains separate from present-day community authority.','claim.popol_vuh.witness_context','event.kiche.hero_twins.seven_macaw',NULL,'UNSPECIFIED','NOT_APPLICABLE','SOURCE_BACKED','这是来源边界节点，不是新增神话动作。','2026-09-01T06:30:00Z'),
('storyevent.v0280.japan.orochi.1','storyver.japanese.kusanagi_orochi',1,'击败八岐大蛇','Yamata no Orochi is defeated','学术综述中的战斗环节。','Combat episode in the academic summary.','claim.v0280.japan.susanoo_defeats_orochi','event.japanese.kusanagi.discovery',NULL,'TEXTUAL_PLACE','NO_COORDINATE','SOURCE_BACKED','文本地点不映射为未经核验的现实坐标。','2026-09-01T06:30:00Z'),
('storyevent.v0280.japan.orochi.2','storyver.japanese.kusanagi_orochi',2,'发现草薙剑','Kusanagi is discovered','剑在叙事中从大蛇尾部被发现。','The sword is found in the serpent''s tail in the narrative.','claim.v0280.japan.kusanagi_discovery_event','event.japanese.kusanagi.discovery',NULL,'TEXTUAL_PLACE','NO_COORDINATE','SOURCE_BACKED','这不是考古出土事件。','2026-09-01T06:30:00Z'),
('storyevent.v0280.japan.orochi.3','storyver.japanese.kusanagi_orochi',3,'呈给天照大神','Presented to Amaterasu','呈递动作结束当前学术综述版本。','The presentation closes this academic-summary version.','claim.v0280.japan.kusanagi_presented_amaterasu','event.japanese.kusanagi.discovery',NULL,'UNSPECIFIED','NO_COORDINATE','SOURCE_BACKED','后续传承转入独立来源版本。','2026-09-01T06:30:00Z'),
('storyevent.v0280.japan.atsuta.1','storyver.japanese.kusanagi_atsuta',1,'热田奉祀公开说明','Public Atsuta enshrinement account','神社官网公开说明草薙剑与热田的关系。','The shrine''s public site describes the Kusanagi–Atsuta relationship.','claim.v0280.japan.kusanagi_worshipped_atsuta','event.japanese.kusanagi.atsuta_enshrinement','site.japanese.atsuta_jingu','REAL_SITE','ENTITY_PROFILE_ONLY','SOURCE_BACKED','未录入坐标；地点只来自现实圣地档案。','2026-09-01T06:30:00Z'),
('storyevent.v0280.japan.atsuta.2','storyver.japanese.kusanagi_atsuta',2,'日本武尊关联','Yamato Takeru link','官网历史段连接日本武尊与奉祀传承。','The official history links Yamato Takeru to the enshrinement tradition.','claim.v0280.japan.yamato_atsuta_event','event.japanese.kusanagi.atsuta_enshrinement','site.japanese.atsuta_jingu','REAL_SITE','ENTITY_PROFILE_ONLY','SOURCE_BACKED','中间环节不补写。','2026-09-01T06:30:00Z'),
('storyevent.v0280.japan.atsuta.3','storyver.japanese.kusanagi_atsuta',3,'来源层边界','Source-layer boundary','学术文本综述与活态神社公开传统保持独立。','The academic text synopsis and living shrine public tradition remain separate.','claim.v0280.japan.kusanagi_source_boundary','event.japanese.kusanagi.atsuta_enshrinement','site.japanese.atsuta_jingu','REAL_SITE','ENTITY_PROFILE_ONLY','SOURCE_BACKED','不推断实物连续性或受限仪式。','2026-09-01T06:30:00Z'),
('storyevent.v0280.khmer.1','storyver.khmer.angkor_churning_apsara',1,'浮雕主题识别','Relief subject identified','APSARA 把主题标为乳海搅拌。','APSARA identifies the subject as the Churning of the Sea of Milk.','claim.v0280.khmer.relief_depicts_churning','event.khmer.angkor_wat_churning_scene','site.khmer.angkor_wat','REAL_SITE','ENTITY_PROFILE_ONLY','SOURCE_BACKED','无新坐标推断。','2026-09-01T06:30:00Z'),
('storyevent.v0280.khmer.2','storyver.khmer.angkor_churning_apsara',2,'东侧回廊南段定位','Southern eastern-gallery locator','官方页面给出回廊内定位。','The official page supplies the gallery locator.','claim.v0280.khmer.relief_gallery_locator','event.khmer.angkor_wat_churning_scene','site.khmer.angkor_wat','REAL_SITE','ENTITY_PROFILE_ONLY','SOURCE_BACKED','只连接遗址档案，不推测坐标。','2026-09-01T06:30:00Z'),
('storyevent.v0280.khmer.3','storyver.khmer.angkor_churning_apsara',3,'物质见证边界','Material-witness boundary','浮雕不被扩写为完整文本版本。','The relief is not expanded into a complete textual recension.','claim.v0280.khmer.material_scope','event.khmer.angkor_wat_churning_scene','site.khmer.angkor_wat','REAL_SITE','ENTITY_PROFILE_ONLY','SOURCE_BACKED','印度文本对读保留到后续目标。','2026-09-01T06:30:00Z');

INSERT OR IGNORE INTO tradition_access_policies(
    id,entity_id,source_id,authority_name,community_context,access_level,
    permitted_scope,prohibited_scope,attribution_requirement,
    permission_contact_or_process,policy_basis,reviewed_at,notes
) VALUES
('policy.v0280.maya.hero_twins_public','text.kiche.popol_vuh','source.maya.creation.nmai','Smithsonian National Museum of the American Indian public presentation','K''iche'' Maya attribution; a living Indigenous tradition with a colonial-period manuscript transmission history.','ATTRIBUTION_REQUIRED','Public institutional episode summary, catalogue metadata, source locator and independently written bilingual overview.','No claim of one standard Maya version; no restricted community knowledge, bulk text reproduction or inference that a colonial manuscript grants community permission.','Attribute the K''iche'' Maya context and name the Smithsonian NMAI and Library of Congress roles separately.','Future community-specific expansion requires a named community or institutional public authority and scoped reuse terms.','Public NMAI presentation plus WMS living-tradition methodology.','2026-09-01T06:30:00Z','This policy permits only the bounded public Seven Macaw episode in batch 1.'),
('policy.v0280.japan.kusanagi_public','weapon.japanese.kusanagi','source.japanese.kusanagi.atsuta_official','Atsuta Jingu public website','Living shrine tradition linked to Kusanagi-no-tsurugi.','PUBLIC_CONTEXT','Official public history, academic source metadata, source locators and independent summaries.','No non-public rites, hidden regalia details, physical authentication claims or article reproduction.','Name the academic and shrine sources according to their distinct perspectives.','Use the shrine''s published contact process before any expansion beyond its public pages.','Atsuta Jingu official public page and Kokugakuin academic reference.','2026-09-01T06:30:00Z','Public source layers remain separate.'),
('policy.v0280.khmer.angkor_material','site.khmer.angkor_wat','source.khmer.angkor_wat.apsara','APSARA National Authority','Angkor is both an archaeological property and a living Khmer heritage landscape.','PUBLIC_CONTEXT','Public heritage metadata, official gallery locator and independent description of the in-situ relief.','No inference about current ritual authority, no reproduction of separately licensed media and no conversion of the image into a complete textual recension.','Attribute APSARA for the relief locator and UNESCO for property 668 context.','Consult APSARA or another named Khmer authority before adding non-public practices or controlled media.','APSARA public monument page and UNESCO World Heritage record.','2026-09-01T06:30:00Z','Material and living-heritage layers are kept distinct.');

UPDATE collection_queue
   SET status='PARTIAL',attempts=attempts+1,last_error=NULL,
       next_action='Add separately located underworld and ballgame episodes from authorized K''iche''-attributed sources; retain community authority and manuscript-history boundaries.',
       updated_at='2026-09-01T06:30:00Z'
 WHERE id='queue.maya.hero_twins';

UPDATE collection_queue
   SET status='PARTIAL',attempts=attempts+1,last_error=NULL,
       next_action='Add exact Kojiki and Nihon Shoki passage witnesses as separate versions; keep Atsuta public shrine tradition and material-continuity questions distinct.',
       updated_at='2026-09-01T06:30:00Z'
 WHERE id='queue.japan.kusanagi_versions';

INSERT OR IGNORE INTO queue_status_history(id,queue_id,old_status,new_status,changed_at,reason) VALUES
('qhist.v0280.maya.hero_twins','queue.maya.hero_twins','SOURCE_FOUND','PARTIAL','2026-09-01T06:30:00Z','One bounded public episode is source-backed; the larger cycle remains open.'),
('qhist.v0280.japan.kusanagi','queue.japan.kusanagi_versions','SOURCE_FOUND','PARTIAL','2026-09-01T06:30:00Z','Academic origin synopsis and official shrine layer added; primary passage witnesses remain open.');

INSERT OR IGNORE INTO collection_queue(
    id,target_label,normalized_label,proposed_entity_type,civilization_id,
    discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,
    discovery_context,priority,status,attempts,last_error,next_action,created_at,updated_at
) VALUES
('queue.v0280.khmer.churning_text_witnesses','Churning of the Sea of Milk textual witnesses for comparison with Angkor relief','churning sea milk textual witnesses angkor relief','TEXT','civ.khmer','monument.khmer.angkor_wat_churning_relief','claim.v0280.khmer.relief_depicts_churning','source.khmer.angkor_wat.apsara','The material witness is now locatable, but no Sanskrit or regional textual recension is yet aligned to it.',96,'PARTIAL',1,NULL,'Register separately dated Sanskrit and Southeast Asian textual witnesses from authoritative editions; never infer the relief''s exact recension from iconography alone.','2026-09-01T06:30:00Z','2026-09-01T06:30:00Z'),
('queue.v0280.china.nuwa_sky_repair','Nüwa repairs the sky source-specific story witnesses','nuwa repairs sky source specific story witnesses','EVENT','civ.chinese_ancient','deity.chinese.nu_wa',NULL,NULL,'v0.28 global story expansion target; requires exact classical-text locators and version separation.',95,'DISCOVERED',0,NULL,'Compare Huainanzi and other named early witnesses with exact chapter locators; do not merge later retellings.','2026-09-01T06:30:00Z','2026-09-01T06:30:00Z'),
('queue.v0280.india.churning_texts','Indian Churning of the Ocean textual witness set','indian churning ocean textual witness set','TEXT','civ.hindu','deity.hindu.vishnu',NULL,NULL,'The Angkor material witness exposes a cross-region comparison need, but Indian textual versions must be registered independently.',95,'DISCOVERED',0,NULL,'Select one authoritative Sanskrit edition and one clearly dated version; keep participants, sequence and reception layers witness-specific.','2026-09-01T06:30:00Z','2026-09-01T06:30:00Z');

INSERT OR IGNORE INTO queue_discoveries(
    id,queue_id,discovered_from_entity_id,discovered_from_claim_id,
    discovered_from_source_id,discovery_context,discovered_at
) VALUES
('qdisc.v0280.khmer.churning','queue.v0280.khmer.churning_text_witnesses','monument.khmer.angkor_wat_churning_relief','claim.v0280.khmer.material_scope','source.khmer.angkor_wat.apsara','Material-witness story completed while textual recension comparison remains explicitly open.','2026-09-01T06:30:00Z'),
('qdisc.v0280.china.nuwa','queue.v0280.china.nuwa_sky_repair','deity.chinese.nu_wa',NULL,NULL,'Queued from the v0.28 priority-tradition roadmap; no story content added without exact primary locators.','2026-09-01T06:30:00Z'),
('qdisc.v0280.india.churning','queue.v0280.india.churning_texts','deity.hindu.vishnu',NULL,'source.khmer.angkor_wat.apsara','The Khmer relief prompts, but does not itself supply, a source-specific Indian textual comparison.','2026-09-01T06:30:00Z');

INSERT OR IGNORE INTO story_expansion_batches(
    id,version_label,title_zh,title_en,scope_note,continuation_policy,status,started_at,completed_at
) VALUES
('storybatch.v0280.01','0.28.0-dev-global-story-expansion-batch-1','v0.28 全球故事扩张首批','v0.28 Global Story Expansion — Batch 1','Three source-backed stories start the batch; China and India remain queued, while Māori and Yorùbá content expansion is permission-gated.','Each target commits independently. BLOCKED_PERMISSION, DEFERRED or FAILED_VALIDATION rows remain audited and never erase completed targets.','IN_PROGRESS','2026-09-01T06:30:00Z',NULL);

INSERT OR IGNORE INTO story_expansion_targets(
    id,batch_id,target_order,civilization_id,queue_id,target_kind,target_label_zh,
    target_label_en,status,result_story_id,source_ids_json,blocker_reason,next_action,updated_at
) VALUES
('storytarget.v0280.01.maya','storybatch.v0280.01',1,'civ.maya','queue.maya.hero_twins','STORY','玛雅英雄双子公开基切语境事件','Maya Hero Twins public K''iche''-context episode','COMPLETED','story.maya.hero_twins_seven_macaw','["source.maya.creation.nmai","source.maya.popol_vuh.loc"]',NULL,'Continue with separately located episodes and named community/source authority.','2026-09-01T06:30:00Z'),
('storytarget.v0280.01.japan','storybatch.v0280.01',2,'civ.japanese_shinto','queue.japan.kusanagi_versions','STORY','草薙剑来源分层故事','Kusanagi source-layered story','COMPLETED','story.japanese.kusanagi_transmission','["source.japanese.kusanagi.yamatanoorochi.kokugakuin","source.japanese.kusanagi.atsuta_official"]',NULL,'Add exact Kojiki and Nihon Shoki witness locators as separate versions.','2026-09-01T06:30:00Z'),
('storytarget.v0280.01.khmer','storybatch.v0280.01',3,'civ.khmer','queue.v0280.khmer.churning_text_witnesses','STORY','吴哥寺乳海搅拌物质见证','Angkor Wat Churning material witness','COMPLETED','story.khmer.angkor_wat_churning_relief','["source.khmer.angkor_wat.apsara","source.khmer.angkor.unesco668"]',NULL,'Keep future textual witnesses separate from the relief.','2026-09-01T06:30:00Z'),
('storytarget.v0280.01.china','storybatch.v0280.01',4,'civ.chinese_ancient','queue.v0280.china.nuwa_sky_repair','STORY','女娲补天的分见证故事','Source-specific Nüwa sky-repair story','QUEUED',NULL,'[]',NULL,'Locate exact classical passages before authoring story sections.','2026-09-01T06:30:00Z'),
('storytarget.v0280.01.india','storybatch.v0280.01',5,'civ.hindu','queue.v0280.india.churning_texts','SOURCE_AUDIT','印度乳海搅拌文本见证审计','Indian Churning textual-witness audit','QUEUED',NULL,'[]',NULL,'Select authoritative Sanskrit editions and preserve recension boundaries.','2026-09-01T06:30:00Z'),
('storytarget.v0280.01.maori','storybatch.v0280.01',6,'civ.maori','queue.v0230.maori.named_iwi_sources','PERMISSION_REVIEW','毛利具名 iwi／hapū 创世版本权限复核','Māori named iwi/hapū creation-version permission review','BLOCKED_PERMISSION',NULL,'["source.maori.creation.teara"]','The current curated synthesis documents plurality but does not supply a named iwi/hapū publication and scoped reuse authority for a new version.','Require a named iwi/hapū official public source, attribution terms and permitted scope before adding story content.','2026-09-01T06:30:00Z'),
('storytarget.v0280.01.yoruba','storybatch.v0280.01',7,'civ.yoruba','queue.v0230.permissions.review','PERMISSION_REVIEW','约鲁巴／Ifá 叙事扩张权限复核','Yorùbá/Ifá narrative-expansion permission review','BLOCKED_PERMISSION',NULL,'["source.yoruba.ifa.unesco"]','UNESCO safeguarding metadata establishes importance and access sensitivity but is not permission to collect or republish restricted verses or rites.','Keep DO_NOT_COLLECT boundaries; add content only through a named public community-led authority and explicit scope.','2026-09-01T06:30:00Z');

INSERT OR IGNORE INTO explorer_feature_registry(
    feature_code,title_zh,title_en,feature_group,data_basis,evidence_caveat,status,
    introduced_in,display_order,updated_at,notes
) VALUES
('global_story_expansion_audit','全球故事扩张审计','Global story expansion audit','STORY_READING','story_expansion_batches and story_expansion_targets','Target failures and permission blocks remain visible and do not imply failure or completion for another tradition.','ACTIVE','v0.28-dev',290,'2026-09-01T06:30:00Z','Batch 1 begins with Maya, Japanese and Khmer stories; China and India are queued, Māori and Yorùbá are permission-gated.');

INSERT OR IGNORE INTO research_sessions(
    id,started_at,ended_at,scope,strategy,status,agent_or_process,notes
) VALUES
('session.20260901.v0280_batch1','2026-09-01T06:15:00Z',NULL,'v0.28 global story expansion batch 1','Use public authoritative sources, source-layer separation and per-target failure isolation; living-tradition content remains permission-gated.','IN_PROGRESS','Codex','Three stories implemented; China and India queued; Māori and Yorùbá permission reviews remain blocking only for their own targets.');

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result) VALUES
('session.20260901.v0280_batch1','SCHEMA','story_expansion_batches','CREATE','Fault-isolated batch and target audit ledger.'),
('session.20260901.v0280_batch1','STORY','story.maya.hero_twins_seven_macaw','CREATE','Bounded public K''iche''-context episode with attribution and access policy.'),
('session.20260901.v0280_batch1','STORY','story.japanese.kusanagi_transmission','CREATE','Academic ancient-text synopsis and official living-shrine account kept as separate versions.'),
('session.20260901.v0280_batch1','STORY','story.khmer.angkor_wat_churning_relief','CREATE','APSARA-located Khmer material witness with UNESCO site context.'),
('session.20260901.v0280_batch1','PERMISSION_REVIEW','storytarget.v0280.01.maori','BLOCK','No named iwi/hapū publication and scoped authority yet.'),
('session.20260901.v0280_batch1','PERMISSION_REVIEW','storytarget.v0280.01.yoruba','BLOCK','Safeguarding metadata is not permission to collect restricted Ifá content.');

UPDATE project_metadata
   SET value='0.28.0-dev-global-story-expansion-batch-1',updated_at='2026-09-01T06:30:00Z'
 WHERE key IN ('project_version','data_version');
UPDATE project_metadata
   SET value='37',updated_at='2026-09-01T06:30:00Z'
 WHERE key='schema_version';
UPDATE project_metadata
   SET value='2026-09-01T06:30:00Z',updated_at='2026-09-01T06:30:00Z'
 WHERE key='generated_at';
UPDATE project_metadata
   SET value='v0.28 active development: global story expansion batch 1; permission blocks are target-local and never ALL COMPLETE',updated_at='2026-09-01T06:30:00Z'
 WHERE key='project_status';

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(37,'20260901_v0280_global_story_expansion_batch1','2026-09-01T06:30:00Z');

COMMIT;
