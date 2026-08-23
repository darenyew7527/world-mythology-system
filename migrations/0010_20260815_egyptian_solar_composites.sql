BEGIN IMMEDIATE;

-- v0.7.0 expands the two NEW Egyptian composite-deity queue targets without
-- flattening Amun, Ra, Horus, Khepri or their source-specific combinations.

INSERT OR IGNORE INTO relationship_types(
  code,inverse_code,label_en,label_zh,category,is_symmetric,description
) VALUES
('COMPOSITE_EXPRESSION_OF','HAS_COMPOSITE_EXPRESSION','composite expression of','复合／融合表达','IDENTITY',0,'A dated or witness-scoped divine combination. It does not merge the component records.'),
('HAS_COMPOSITE_EXPRESSION','COMPOSITE_EXPRESSION_OF','has composite expression','具有复合表达','IDENTITY',0,'Inverse of COMPOSITE_EXPRESSION_OF.'),
('PART_OF','HAS_PART','part of','属于／构成部分','STRUCTURE',0,'Structural containment; not identity.'),
('HAS_PART','PART_OF','has part','包含组成部分','STRUCTURE',0,'Inverse of PART_OF.');

INSERT OR IGNORE INTO sources(
  id,title,original_title,source_type,evidence_tier,institution,author_or_editor,
  language_id,publication_date,accessed_date,url,stable_url,doi,isbn,
  catalogue_number,manuscript_number,rights_status,source_perspective,
  community_or_lineage,collector_context,living_tradition,
  access_or_reuse_restrictions,community_permission_required,
  same_witness_as_source_id,translation_status,verification_status,notes
) VALUES
('source.egypt.syncretism.uee2008','Anthropomorphic Deities',NULL,'PEER_REVIEWED_REFERENCE',2,'UCLA Encyclopedia of Egyptology','Richard H. Wilkinson','lang.en','2008-04-13','2026-08-15','https://escholarship.org/uc/item/5s54w4tc','https://escholarship.org/uc/item/5s54w4tc',NULL,NULL,'UEE 1003 Version 1',NULL,'Copyright author; metadata, locator and independent summary only','Peer-reviewed Egyptological discussion of deity forms and syncretized identities',NULL,NULL,0,'Do not reproduce the article or figures; retain page locators and a short independent summary',0,NULL,'English scholarly article','URL_SYNTAX_VALID','Pages 4 and 7 discuss Amun-Ra, Ra-Horakhty and the Theban triad. The article cautions that syncretized deities are not adequately modeled as simple aliases.'),
('source.egypt.book_dead17.ucl','Book of the Dead chapter 17','Book of Coming Forth by Day, spell 17','SCHOLARLY_DIGITAL_TEXT',2,'UCL Digital Egypt','Digital Egypt for Universities','lang.en',NULL,'2026-08-15','https://www.ucl.ac.uk/museums-static/digitalegypt/literature/religious/bd17.html',NULL,NULL,NULL,'Book of the Dead spell 17',NULL,'University page and translation rights apply','Academic digital presentation with transliteration, translation and variant glosses',NULL,NULL,0,'Store locators and independent summaries; do not bulk reproduce the translation',0,NULL,'Egyptian transliteration with English translation','URL_SYNTAX_VALID','The registered section identifies Khepri in the boat with Ra-Horakhty in one explanatory gloss while also preserving alternate explanations.'),
('source.egypt.karnak.mota','Karnak','Ipet-Sut','OFFICIAL_ARCHAEOLOGICAL_SITE',3,'Egyptian Ministry of Tourism and Antiquities',NULL,'lang.en',NULL,'2026-08-15','https://egymonuments.gov.eg/en/archaeological-sites/karnak',NULL,NULL,NULL,'Karnak archaeological site',NULL,'Copyright Egyptian Ministry; metadata and link only','Official archaeological-site description',NULL,NULL,0,'Do not package page images; retain metadata, dates and short research summaries',0,NULL,'English official site page','URL_SYNTAX_VALID','Describes the Great Temple of Amun, the Amun precinct, solar orientation and the Opet processional connection to Luxor Temple.'),
('source.egypt.karnak.origins.cfeetk','Karnak des origines: Middle Kingdom court and primeval temple',NULL,'ARCHAEOLOGICAL_PROJECT',2,'CFEETK / CNRS / Egyptian Ministry of Tourism and Antiquities','CFEETK research team','lang.en',NULL,'2026-08-15','https://www.cfeetk.cnrs.fr/travaux/fouilles-cour-du-moyen-empire/',NULL,NULL,NULL,'CFEETK operation OP191',NULL,'CNRS-CFEETK rights; metadata and link only','Active Egyptian-French archaeological project summary',NULL,'Archaeological project context retained',0,'Do not redistribute project images; retain object/site locators',0,NULL,'French and English project summary','URL_SYNTAX_VALID','Reports a column of Intef II and foundations attesting a Middle Kingdom sanctuary dedicated to Amun-Ra.'),
('source.egypt.thebes.unesco87','Ancient Thebes with its Necropolis',NULL,'OFFICIAL_HERITAGE_RECORD',3,'UNESCO World Heritage Centre',NULL,'lang.en','1979','2026-08-15','https://whc.unesco.org/en/list/87/',NULL,NULL,NULL,'World Heritage List 87',NULL,'UNESCO description CC BY-SA IGO 3.0; other media retain separate rights','Official World Heritage property record',NULL,NULL,0,'Follow UNESCO reuse terms; do not package third-party images',0,NULL,'English official heritage record','URL_SYNTAX_VALID','Establishes the real archaeological and protected-property context for Karnak, Luxor and the Theban necropolis.'),
('source.egypt.abu_simbel.mota','Abu Simbel',NULL,'OFFICIAL_ARCHAEOLOGICAL_SITE',3,'Egyptian Ministry of Tourism and Antiquities',NULL,'lang.en',NULL,'2026-08-15','https://egymonuments.gov.eg/archaeological-sites/abu-simbel/',NULL,NULL,NULL,'Abu Simbel Great Temple',NULL,'Copyright Egyptian Ministry; metadata and link only','Official archaeological-site description',NULL,NULL,0,'Do not package page images; retain metadata and short research summaries',0,NULL,'English official site page','URL_SYNTAX_VALID','Dates the Great Temple to Ramesses II and identifies Amun-Ra, Ra-Horakhty, Ptah and deified Ramesses II in the sanctuary.'),
('source.egypt.nubian.unesco88','Nubian Monuments from Abu Simbel to Philae',NULL,'OFFICIAL_HERITAGE_RECORD',3,'UNESCO World Heritage Centre',NULL,'lang.en','1979','2026-08-15','https://whc.unesco.org/en/list/88/',NULL,NULL,NULL,'World Heritage List 88',NULL,'UNESCO site terms apply','Official World Heritage property record',NULL,NULL,0,'Follow UNESCO reuse terms; metadata and link only',0,NULL,'English official heritage record','URL_SYNTAX_VALID','Establishes the real archaeological and conservation context for Abu Simbel and the international relocation campaign.'),
('source.egypt.luxor.mota','Luxor Temple','Ipet-resyt','OFFICIAL_ARCHAEOLOGICAL_SITE',3,'Egyptian Ministry of Tourism and Antiquities',NULL,'lang.en',NULL,'2026-08-15','https://egymonuments.gov.eg/monuments/luxor-temple/',NULL,NULL,NULL,'Luxor Temple',NULL,'Copyright Egyptian Ministry; metadata and link only','Official archaeological-site description',NULL,NULL,0,'Do not package page images; retain metadata and short research summaries',0,NULL,'English official site page','URL_SYNTAX_VALID','Describes the Opet procession of Amun, Mut and Khonsu from Karnak to Luxor and a divine-birth cycle involving Amun-Ra.'),
('source.egypt.amun_re_scarab.met.09_180_953','Scarab Inscribed with the Names of Amun-Re and Neit',NULL,'ARCHAEOLOGICAL',3,'The Metropolitan Museum of Art',NULL,'lang.en','ca. 1300-1080 BCE','2026-08-15','https://www.metmuseum.org/art/collection/search/553402',NULL,NULL,NULL,'09.180.953',NULL,'Object data and public-domain media follow The Met Open Access terms','Official museum catalogue','Lisht North excavation context','MMA excavation; provenance retained',0,'Object metadata may be reused under stated terms; no image is packaged in this release',0,NULL,'English museum catalogue','URL_SYNTAX_VALID','Late New Kingdom scarab whose base bears the name Amun-Re and a sign associated with the lord reading.'),
('source.egypt.ra_horakhty_stela.met.oc81','Stela with man offering to Re-Harakhty, unfinished',NULL,'ARCHAEOLOGICAL',3,'The Metropolitan Museum of Art',NULL,'lang.en','ca. 721-664 BCE','2026-08-15','https://www.metmuseum.org/art/collection/search/553249',NULL,NULL,NULL,'O.C.81',NULL,'Object data and public-domain media follow The Met Open Access terms','Official museum catalogue',NULL,'Gift of James Douglas, 1890; acquisition context retained',0,'Object metadata may be reused under stated terms; no image is packaged in this release',0,NULL,'English museum catalogue','URL_SYNTAX_VALID','Kushite-era stela depicting an offering to Re-Harakhty; the catalogue explicitly describes the composite identity and iconography.'),
('source.egypt.ra_horakhty_amulet.met.74_51_4497','Faience amulet of Ra Horakhty',NULL,'ARCHAEOLOGICAL',3,'The Metropolitan Museum of Art',NULL,'lang.en','664-334 BCE','2026-08-15','https://www.metmuseum.org/art/collection/search/243765',NULL,NULL,NULL,'74.51.4497',NULL,'Object data and public-domain media follow The Met Open Access terms','Official museum catalogue',NULL,'Cesnola Collection acquisition context retained',0,'Object metadata may be reused under stated terms; no image is packaged in this release',0,NULL,'English museum catalogue','URL_SYNTAX_VALID','Faience amulet catalogued as Ra Horakhty, dated to Dynasties 26-30.'),
('source.egypt.khepri_hymn.bm.ea826','Stela with hymn to the sun god Khepri',NULL,'ARCHAEOLOGICAL',3,'British Museum',NULL,'lang.en',NULL,'2026-08-15','https://www.britishmuseum.org/collection/object/Y_EA826',NULL,NULL,NULL,'EA826',NULL,'British Museum collection terms apply; metadata and link only','Official museum catalogue',NULL,'Museum acquisition context retained',0,'Do not package object images; retain catalogue number and short summary',0,NULL,'English museum catalogue','URL_SYNTAX_VALID','The record describes a twenty-one-line hymn addressing Khepri as a self-raising scarab and solar figure.'),
('source.egypt.nauny_book_dead.met.30_3_31','Book of the Dead for the Chantress of Amun, Nauny',NULL,'ARCHAEOLOGICAL',3,'The Metropolitan Museum of Art',NULL,'lang.en','ca. 1050 BCE','2026-08-15','https://www.metmuseum.org/art/collection/search/548344',NULL,NULL,NULL,'30.3.31',NULL,'Object data and public-domain media follow The Met Open Access terms','Official museum catalogue','Theban funerary context','MMA excavation, 1928-29; provenance retained',0,'Object metadata may be reused under stated terms; no image is packaged in this release',0,NULL,'English museum catalogue','URL_SYNTAX_VALID','The catalogue distinguishes Book of the Dead material from a shorter netherworld text and summarizes the sun god''s nightly journey through the underworld.'),
('source.egypt.divine_egypt.met','Divine Egypt: inside the exhibition',NULL,'MUSEUM_CURATORIAL_ESSAY',4,'The Metropolitan Museum of Art','Department of Egyptian Art','lang.en','2025','2026-08-15','https://www.metmuseum.org/exhibitions/divine-egypt/inside-the-exhibition',NULL,NULL,NULL,'Divine Egypt exhibition essay',NULL,'Copyright The Metropolitan Museum of Art; metadata and link only','Museum curatorial synthesis',NULL,NULL,0,'Do not reproduce exhibition text or images; use as contextual scholarship only',0,NULL,'English curatorial essay','URL_SYNTAX_VALID','Contextualizes Amun-Re, Re and the divine court without replacing object- or text-specific evidence.');

INSERT OR IGNORE INTO entities(
  id,canonical_name,name_zh,original_name,transliteration,primary_type,
  primary_civilization_id,primary_region_id,historical_period,description,
  research_status,evidence_status,record_version,metadata_json,created_at,updated_at
) VALUES
('concept.egyptian.divine_syncretism','Egyptian divine syncretism','古埃及神祇复合／融合表达',NULL,NULL,'CONCEPT','civ.egyptian','region.northeast_africa','Diachronic Egyptian religious history','用于保存复合神名和“神居于另一神中”的解释层；不把组成神直接合并。 / Models dated composite divine expressions without collapsing their component deities.','PARTIAL','UNVERIFIED',1,'{"dedup_rule":"composite expression is not a global alias merge"}','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('deity.egyptian.amun_ra','Amun-Ra','阿蒙-拉','jmn-rꜥ','Amun-Ra','DEITY','civ.egyptian','region.northeast_africa','Middle Kingdom onward; strongly visible in New Kingdom and later evidence','阿蒙与太阳神拉的复合神祇档案；与阿蒙和拉各自的记录分开。 / Composite deity dossier connecting Amun and Ra while preserving both component records.','PARTIAL','UNVERIFIED',1,'{"entity_model":"syncretized composite; no hard merge"}','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('deity.egyptian.ra_horakhty','Ra-Horakhty','拉-哈拉赫提','rꜥ-ḥr-ꜣḫty','Ra-Horakhty','DEITY','civ.egyptian','region.northeast_africa','New Kingdom and later textual, temple and object witnesses','拉与“双地平线的荷鲁斯”复合表达；不等同于所有荷鲁斯形态。 / Composite solar-horizon deity; not a blanket alias for every Horus form.','PARTIAL','UNVERIFIED',1,'{"entity_model":"syncretized composite; Horus scope is horizon-specific"}','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('deity.egyptian.khepri','Khepri','凯布利／赫普里','ḫprj','Khepri','DEITY','civ.egyptian','region.northeast_africa','Funerary textual and object witnesses across periods','与晨日、生成和圣甲虫意象相关的太阳神形态；具体认同关系按文本登记。 / Solar deity/form associated with becoming, the rising sun and scarab imagery; identifications remain witness-specific.','PARTIAL','UNVERIFIED',1,'{"identity_caution":"text-specific identifications only"}','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('deity.egyptian.mut','Mut','穆特','mwt','Mut','DEITY','civ.egyptian','region.northeast_africa','Theban cult and later witnesses','底比斯神族成员；本批仅建立与阿蒙、孔苏和奥佩特节相关的来源基线。 / Theban deity with a first source-backed triad and Opet baseline.','PARTIAL','UNVERIFIED',1,'{}','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('deity.egyptian.khonsu','Khonsu','孔苏','ḫnsw','Khonsu','DEITY','civ.egyptian','region.northeast_africa','Theban cult and later witnesses','底比斯月神；本批仅建立与阿蒙、穆特和奥佩特节相关的来源基线。 / Theban lunar deity with a first source-backed triad and Opet baseline.','PARTIAL','UNVERIFIED',1,'{}','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('group.egyptian.theban_triad','Theban Triad','底比斯三神组',NULL,NULL,'CONCEPT','civ.egyptian','region.northeast_africa','New Kingdom and later cult organization','阿蒙、穆特、孔苏的底比斯神族组合；成员关系不取代每位神的独立档案。 / Cult grouping of Amun, Mut and Khonsu; membership does not merge the deities.','PARTIAL','UNVERIFIED',1,'{"group_type":"cult triad"}','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('festival.egyptian.opet','Opet Festival','奥佩特节','ḥb nfr n jpt','Opet Festival','FESTIVAL','civ.egyptian','region.northeast_africa','New Kingdom and later Theban festival layers','卡纳克与卢克索之间的节庆与神像巡行传统；当前只保存官方遗址公开层。 / Theban festival and cult-image procession between Karnak and Luxor; current record is limited to public official-site evidence.','PARTIAL','UNVERIFIED',1,'{"reality_status":"historical ritual tradition"}','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('site.egypt.karnak_great_temple_amun_ra','Great Temple of Amun-Ra at Karnak','卡纳克阿蒙-拉大神庙','Ipet-Sut',NULL,'TEMPLE','civ.egyptian','region.northeast_africa','Middle Kingdom foundations through Roman-period additions','卡纳克神庙群内的阿蒙-拉大神庙子实体；与整个卡纳克遗址分开但相连。 / Subsite record for the Great Temple of Amun-Ra within the larger Karnak complex.','PARTIAL','UNVERIFIED',1,'{"reality_status":"REAL_ARCHAEOLOGICAL","part_of":"site.egypt.karnak"}','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('text.egypt.book_dead_spell17','Book of the Dead Spell 17','《亡灵书》第17咒文',NULL,NULL,'TEXT','civ.egyptian','region.northeast_africa','Multiple funerary witnesses and transmitted variants','《亡灵书》中的一组咒文与解释性异文入口；不假定只有一个固定原本。 / Section-level record for Spell 17 and its explanatory variants; not a claim of one fixed original text.','PARTIAL','UNVERIFIED',1,'{"witness_model":"section with multiple variants"}','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('event.egyptian.nocturnal_solar_journey','Nocturnal journey of the sun god','太阳神夜行冥界',NULL,NULL,'EVENT','civ.egyptian','region.northeast_africa','New Kingdom funerary cosmology and later witnesses','太阳神乘舟穿越冥界的神话／宇宙论事件层；不是历史旅行。 / Mythic-cosmological event layer for the sun god''s nocturnal journey through the netherworld.','PARTIAL','UNVERIFIED',1,'{"reality_status":"MYTHIC_COSMOLOGY"}','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('museum.met.amun_re_scarab_09_180_953','Scarab inscribed with Amun-Re and Neit','阿蒙-拉与奈特名号圣甲虫 09.180.953',NULL,NULL,'MUSEUM_OBJECT','civ.egyptian','region.northeast_africa','New Kingdom, ca. 1300-1080 BCE','大都会艺术博物馆藏釉陶圣甲虫；底部铭刻阿蒙-拉名号。 / Met faience scarab bearing the name of Amun-Re.','PARTIAL','UNVERIFIED',1,'{"catalogue_number":"09.180.953"}','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('museum.met.ra_horakhty_stela_oc81','Stela with man offering to Re-Harakhty','向拉-哈拉赫提献祭未完成木碑 O.C.81',NULL,NULL,'MUSEUM_OBJECT','civ.egyptian','region.northeast_africa','Third Intermediate Period, ca. 721-664 BCE','库施时期木碑，描绘人物向拉-哈拉赫提献香。 / Kushite-era wooden stela showing an offering to Re-Harakhty.','PARTIAL','UNVERIFIED',1,'{"catalogue_number":"O.C.81"}','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('museum.met.ra_horakhty_amulet_74_51_4497','Faience amulet of Ra Horakhty','拉-哈拉赫提釉陶护符 74.51.4497',NULL,NULL,'MUSEUM_OBJECT','civ.egyptian','region.northeast_africa','Dynasties 26-30, 664-334 BCE','大都会艺术博物馆藏拉-哈拉赫提釉陶护符。 / Met faience amulet catalogued as Ra Horakhty.','PARTIAL','UNVERIFIED',1,'{"catalogue_number":"74.51.4497"}','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('museum.bm.khepri_hymn_stela_ea826','Stela with hymn to Khepri','凯布利赞歌石碑 EA826',NULL,NULL,'MUSEUM_OBJECT','civ.egyptian','region.northeast_africa',NULL,'大英博物馆目录所载含二十一行凯布利赞歌的石碑。 / British Museum stela catalogued with a twenty-one-line hymn to Khepri.','PARTIAL','UNVERIFIED',1,'{"catalogue_number":"EA826"}','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('museum.met.nauny_book_dead_30_3_31','Book of the Dead for Nauny','娜乌妮《亡灵书》纸草 30.3.31',NULL,NULL,'MUSEUM_OBJECT','civ.egyptian','region.northeast_africa','Dynasty 21, ca. 1050 BCE','底比斯出土的娜乌妮葬仪纸草；目录区分《亡灵书》与冥界太阳旅程材料。 / Theban funerary papyrus whose catalogue distinguishes Book of the Dead and netherworld solar-journey material.','PARTIAL','UNVERIFIED',1,'{"catalogue_number":"30.3.31"}','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z');

INSERT OR IGNORE INTO entity_classifications(entity_id,type_code,is_primary,notes)
SELECT id,primary_type,1,'v0.7.0 Egyptian solar-composite checkpoint'
FROM entities WHERE created_at='2026-08-15T00:00:00Z';

INSERT OR IGNORE INTO entity_civilizations(entity_id,civilization_id,association_role,certainty,notes)
SELECT id,'civ.egyptian','ORIGIN','SUPPORTED','v0.7.0 source-located Egyptian baseline'
FROM entities WHERE created_at='2026-08-15T00:00:00Z';

INSERT OR IGNORE INTO names(
  id,entity_id,name_text,normalized_text,language_id,script_name,name_type,
  transliteration_scheme,is_preferred,source_id,notes
) VALUES
('name.v070.amun_ra.en','deity.egyptian.amun_ra','Amun-Ra','amun ra','lang.en','Latin','PREFERRED',NULL,1,'source.egypt.syncretism.uee2008','English scholarly form'),
('name.v070.amun_re.en','deity.egyptian.amun_ra','Amun-Re','amun re','lang.en','Latin','VARIANT',NULL,0,'source.egypt.amun_re_scarab.met.09_180_953','Museum catalogue form'),
('name.v070.amun_ra.egy','deity.egyptian.amun_ra','jmn-rꜥ','jmn rꜥ','lang.egy','Hieroglyphic transliteration','TRANSCRIPTION','Egyptological',1,'source.egypt.karnak.origins.cfeetk','Conventional Egyptological transliteration'),
('name.v070.amun_ra.zh','deity.egyptian.amun_ra','阿蒙-拉','阿蒙 拉','lang.zh','Han','TRANSLATION',NULL,1,'source.egypt.syncretism.uee2008','Chinese project translation'),
('name.v070.ra_horakhty.en','deity.egyptian.ra_horakhty','Ra-Horakhty','ra horakhty','lang.en','Latin','PREFERRED',NULL,1,'source.egypt.syncretism.uee2008','English scholarly form'),
('name.v070.re_harakhty.en','deity.egyptian.ra_horakhty','Re-Harakhty','re harakhty','lang.en','Latin','VARIANT',NULL,0,'source.egypt.ra_horakhty_stela.met.oc81','Met catalogue form'),
('name.v070.ra_horakhty.egy','deity.egyptian.ra_horakhty','rꜥ-ḥr-ꜣḫty','rꜥ ḥr ꜣḫty','lang.egy','Hieroglyphic transliteration','TRANSCRIPTION','Egyptological',1,'source.egypt.book_dead17.ucl','Conventional Egyptological transliteration'),
('name.v070.ra_horakhty.zh','deity.egyptian.ra_horakhty','拉-哈拉赫提','拉 哈拉赫提','lang.zh','Han','TRANSLATION',NULL,1,'source.egypt.syncretism.uee2008','Chinese transliteration'),
('name.v070.khepri.en','deity.egyptian.khepri','Khepri','khepri','lang.en','Latin','PREFERRED',NULL,1,'source.egypt.book_dead17.ucl','English scholarly form'),
('name.v070.khepri.egy','deity.egyptian.khepri','ḫprj','ḫprj','lang.egy','Hieroglyphic transliteration','TRANSCRIPTION','Egyptological',1,'source.egypt.book_dead17.ucl','Conventional Egyptological transliteration'),
('name.v070.khepri.zh','deity.egyptian.khepri','凯布利','凯布利','lang.zh','Han','TRANSLATION',NULL,1,'source.egypt.khepri_hymn.bm.ea826','Chinese transliteration'),
('name.v070.mut.egy','deity.egyptian.mut','mwt','mwt','lang.egy','Hieroglyphic transliteration','TRANSCRIPTION','Egyptological',1,'source.egypt.syncretism.uee2008','Conventional transliteration'),
('name.v070.khonsu.egy','deity.egyptian.khonsu','ḫnsw','ḫnsw','lang.egy','Hieroglyphic transliteration','TRANSCRIPTION','Egyptological',1,'source.egypt.syncretism.uee2008','Conventional transliteration'),
('name.v070.karnak.egy','site.egypt.karnak_great_temple_amun_ra','Ipet-Sut','ipet sut','lang.egy','Egyptological transliteration','ANCIENT_NAME','Egyptological',1,'source.egypt.karnak.mota','Official site gives The Most Select of Places'),
('name.v070.opet.en','festival.egyptian.opet','Opet Festival','opet festival','lang.en','Latin','PREFERRED',NULL,1,'source.egypt.luxor.mota','English official-site form'),
('name.v070.opet.zh','festival.egyptian.opet','奥佩特节','奥佩特节','lang.zh','Han','TRANSLATION',NULL,1,'source.egypt.luxor.mota','Chinese project translation');

INSERT OR REPLACE INTO deity_profiles(
  entity_id,deity_class,pantheon_or_family,rank_or_status,domains_json,powers_json,
  limitations_json,appearance_json,symbols_json,cult_summary,final_fate_summary
) VALUES
('deity.egyptian.amun_ra','SYNCRETIZED_DEITY','Egyptian; Theban and solar layers','Often styled king of the gods in later evidence','["hiddenness","creation","solar","kingship"]','[]','["Composite scope varies by period and source"]','{"caution":"iconography may stress Amun more than Ra"}','["double-plume crown","sun disk"]','Great Temple at Karnak and other dated cult layers; not every Amun reference is automatically Amun-Ra.',NULL),
('deity.egyptian.ra_horakhty','SYNCRETIZED_DEITY','Egyptian solar and Horus-of-the-horizons layers','Solar-horizon deity','["sun","horizons","kingship"]','[]','["Not equivalent to every Horus form"]','{"form":"falcon-headed, sun disk and uraeus in registered stela"}','["falcon","sun disk","uraeus"]','Textual, temple, funerary and votive-object witnesses.',NULL),
('deity.egyptian.khepri','SOLAR_DEITY_OR_FORM','Egyptian solar cycle','Rising-sun and becoming layer','["rising sun","becoming","renewal"]','[]','["Identity with Ra-Horakhty is witness-specific"]','{"form":"scarab or scarab-headed form in later iconography"}','["scarab","solar barque"]','Funerary texts and object witnesses; cult history remains partial.',NULL),
('deity.egyptian.mut','DEITY','Theban Triad','Consort/mother role in Theban grouping','[]','[]','[]','{}','[]','First baseline limited to Theban triad and Opet public evidence.',NULL),
('deity.egyptian.khonsu','LUNAR_DEITY','Theban Triad','Child member in Theban grouping','["moon"]','[]','[]','{}','[]','First baseline limited to Theban triad and Opet public evidence.',NULL);

INSERT OR REPLACE INTO place_profiles(
  entity_id,place_type,ancient_name,modern_name,country_code,latitude,longitude,date_range,
  builders,architecture_summary,excavation_summary,major_finds_summary,unesco_status,
  reality_status,evidence_grade
) VALUES
('site.egypt.karnak_great_temple_amun_ra','TEMPLE','Ipet-Sut','Great Temple of Amun-Ra, Karnak','EGY',25.7188,32.6573,'Middle Kingdom foundations through Roman-period additions','Successive Egyptian rulers','Large temple within the Karnak complex; east-west solar axis plus north-south link toward Luxor.','CFEETK records Middle Kingdom foundations and an Intef II column.','Architectural, textual, sculptural and ritual remains','Within Ancient Thebes World Heritage List 87','REAL_ARCHAEOLOGICAL','HIGH');

INSERT OR REPLACE INTO museum_object_profiles(
  entity_id,holding_institution,catalogue_number,object_type,provenance,date_range,acquisition_notes
) VALUES
('museum.met.amun_re_scarab_09_180_953','The Metropolitan Museum of Art','09.180.953','Faience scarab','Lisht North cemetery debris; MMA excavations','ca. 1300-1080 BCE','Rogers Fund, 1909'),
('museum.met.ra_horakhty_stela_oc81','The Metropolitan Museum of Art','O.C.81','Wooden stela with gesso and paint','Egypt','ca. 721-664 BCE','Gift of James Douglas, 1890'),
('museum.met.ra_horakhty_amulet_74_51_4497','The Metropolitan Museum of Art','74.51.4497','Faience amulet','Egypt','664-334 BCE','Cesnola Collection, purchased by subscription, 1874-76'),
('museum.bm.khepri_hymn_stela_ea826','British Museum','EA826','Stela with solar hymn','Egypt',NULL,'Catalogue record retained'),
('museum.met.nauny_book_dead_30_3_31','The Metropolitan Museum of Art','30.3.31','Papyrus, paint','Thebes, Deir el-Bahri, Tomb TT358','ca. 1050 BCE','MMA excavations, 1928-29; Rogers Fund, 1930');

INSERT OR REPLACE INTO text_profiles(
  entity_id,text_type,original_language_id,attributed_author,compiler,composition_period,
  earliest_extant_witness,chapter_structure,repository,shelfmark,copyright_status,summary
) VALUES
('text.egypt.book_dead_spell17','FUNERARY_TEXT_SECTION','lang.egy',NULL,NULL,'Developed across multiple funerary witnesses',NULL,'Spell/chapter 17 with explanatory glosses and variants','Multiple repositories; UCL digital study entry',NULL,'Ancient witnesses public domain; modern editions and translations retain separate rights','Section-level index for Khepri, Ra-Horakhty, Atum and variant explanatory identifications.');

INSERT OR REPLACE INTO myth_event_profiles(
  entity_id,event_type,time_layer,cause_summary,process_summary,result_summary,symbolism_summary
) VALUES
('event.egyptian.nocturnal_solar_journey','UNDERWORLD_JOURNEY','FUNERARY_COSMOLOGY',NULL,'The sun god traverses the netherworld in a solar barque through the night.','Renewed solar emergence is implied by the cycle; versions differ.','Cyclical renewal and the ordered passage between day, night and rebirth.');

INSERT OR IGNORE INTO claims(
  id,subject_id,predicate,object_entity_id,object_literal,object_datatype,statement,
  variant_group,claim_status,confidence,confidence_level,review_status,assertion_scope,
  knowledge_layer,tradition_scope,temporal_scope,research_notes,created_at
) VALUES
('claim.v070.egypt.syncretism_model','concept.egyptian.divine_syncretism','MENTIONED_IN',NULL,'UCLA Encyclopedia of Egyptology, Anthropomorphic Deities, p.4','text','Peer-reviewed Egyptology describes Amun-Ra and Ra-Horakhty as syncretized deities whose identities are not adequately reduced to simple aliases.','egypt.divine_syncretism.model','SUPPORTED',0.97,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Egyptian divine identity','UEE 2008 p.4','This is an analytical model, not an ancient Egyptian category label.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.amun_ra_component_amun','deity.egyptian.amun_ra','COMPOSITE_EXPRESSION_OF','deity.egyptian.amun',NULL,NULL,'Amun-Ra is registered as a syncretized expression involving Amun; the Amun entity remains independent.','egypt.amun_ra.components','SUPPORTED',0.97,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Egyptian syncretized deity','UEE 2008 p.4','Do not convert this edge into a redirect.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.amun_ra_component_ra','deity.egyptian.amun_ra','COMPOSITE_EXPRESSION_OF','deity.egyptian.ra',NULL,NULL,'Amun-Ra is registered as a syncretized expression involving Ra; the Ra entity remains independent.','egypt.amun_ra.components','SUPPORTED',0.97,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Egyptian syncretized deity','UEE 2008 p.4','Do not convert this edge into a redirect.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.amun_ra_worshipped_karnak','deity.egyptian.amun_ra','WORSHIPPED_AT','site.egypt.karnak_great_temple_amun_ra',NULL,NULL,'Archaeological project evidence attests a sanctuary dedicated to Amun-Ra at Karnak from the Middle Kingdom onward.','egypt.amun_ra.karnak','SUPPORTED',0.98,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Karnak cult','Middle Kingdom onward','The site developed for many centuries; no single static temple phase is implied.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.great_temple_part_karnak','site.egypt.karnak_great_temple_amun_ra','PART_OF','site.egypt.karnak',NULL,NULL,'The Great Temple of Amun-Ra is modeled as a component of the wider Karnak temple complex.','egypt.karnak.structure','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Karnak site structure','Official current site record','Structural containment only.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.karnak_unesco87','site.egypt.karnak','ATTESTED_BY',NULL,'UNESCO World Heritage List 87, Ancient Thebes with its Necropolis','text','UNESCO includes Karnak within the real protected archaeological property Ancient Thebes with its Necropolis.','egypt.karnak.heritage','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','UNESCO heritage','World Heritage List 87','Heritage status is not evidence for a mythic event.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.scarab_depicts_amun_ra','museum.met.amun_re_scarab_09_180_953','DEPICTS','deity.egyptian.amun_ra',NULL,NULL,'The scarab base is inscribed with the name of Amun-Re in the Met catalogue.','egypt.amun_ra.object.09_180_953','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Late New Kingdom object','Met 09.180.953','Name inscription is not a portrait claim.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.scarab_held_met','museum.met.amun_re_scarab_09_180_953','HELD_BY_MUSEUM','institution.met',NULL,NULL,'The Metropolitan Museum of Art holds object 09.180.953.','egypt.object.custody','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Modern custody','Met 09.180.953',NULL,'2026-08-15T00:00:00Z'),
('claim.v070.egypt.ra_horakhty_component_ra','deity.egyptian.ra_horakhty','COMPOSITE_EXPRESSION_OF','deity.egyptian.ra',NULL,NULL,'Ra-Horakhty is a syncretized expression involving Ra; the Ra record remains independent.','egypt.ra_horakhty.components','SUPPORTED',0.98,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Egyptian syncretized deity','UEE 2008 p.4; Met O.C.81','Do not convert this edge into a redirect.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.ra_horakhty_component_horus','deity.egyptian.ra_horakhty','COMPOSITE_EXPRESSION_OF','deity.egyptian.horus',NULL,NULL,'Ra-Horakhty incorporates Horus specifically in the horizon-protector scope described by the registered catalogue.','egypt.ra_horakhty.components','SUPPORTED',0.96,'HIGH','VERIFIED','HISTORICAL_REALITY','SCHOLARLY_INTERPRETATION','Egyptian syncretized deity','Met O.C.81','Not every Horus manifestation is Ra-Horakhty.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.ra_horakhty_spell17','deity.egyptian.ra_horakhty','APPEARS_IN','text.egypt.book_dead_spell17',NULL,NULL,'Ra-Horakhty appears in an explanatory gloss registered for Book of the Dead Spell 17.','egypt.book_dead17.solar_forms','SUPPORTED',0.97,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Book of the Dead','Spell 17, Allen Part a','The gloss is variant-aware and does not define all periods.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.stela_depicts_ra_horakhty','museum.met.ra_horakhty_stela_oc81','DEPICTS','deity.egyptian.ra_horakhty',NULL,NULL,'Met stela O.C.81 depicts a man offering incense to Re-Harakhty.','egypt.ra_horakhty.object.oc81','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Third Intermediate Period','Met O.C.81',NULL,'2026-08-15T00:00:00Z'),
('claim.v070.egypt.stela_held_met','museum.met.ra_horakhty_stela_oc81','HELD_BY_MUSEUM','institution.met',NULL,NULL,'The Metropolitan Museum of Art holds stela O.C.81.','egypt.object.custody','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Modern custody','Met O.C.81',NULL,'2026-08-15T00:00:00Z'),
('claim.v070.egypt.amulet_depicts_ra_horakhty','museum.met.ra_horakhty_amulet_74_51_4497','DEPICTS','deity.egyptian.ra_horakhty',NULL,NULL,'The Met catalogues faience amulet 74.51.4497 as Ra Horakhty.','egypt.ra_horakhty.object.74_51_4497','SUPPORTED',0.98,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Late Period','Met 74.51.4497','Catalogue identification retained with its period.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.amulet_held_met','museum.met.ra_horakhty_amulet_74_51_4497','HELD_BY_MUSEUM','institution.met',NULL,NULL,'The Metropolitan Museum of Art holds amulet 74.51.4497.','egypt.object.custody','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Modern custody','Met 74.51.4497',NULL,'2026-08-15T00:00:00Z'),
('claim.v070.egypt.khepri_spell17','deity.egyptian.khepri','APPEARS_IN','text.egypt.book_dead_spell17',NULL,NULL,'Khepri appears in the registered Book of the Dead Spell 17 section amid solar-barque explanations.','egypt.book_dead17.solar_forms','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Book of the Dead','Spell 17, Allen Part a','Source-specific textual appearance.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.khepri_solar_barque','deity.egyptian.khepri','ASSOCIATED_WITH','artifact.egyptian.solar_barque',NULL,NULL,'Spell 17 places Khepri amid the divine boat in the registered explanatory passage.','egypt.book_dead17.solar_forms','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Book of the Dead','Spell 17, Allen Part a','Mythic-cosmological association, not an archaeological boat identification.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.khepri_identified_ra_horakhty','deity.egyptian.khepri','IDENTIFIED_WITH','deity.egyptian.ra_horakhty',NULL,NULL,'One Spell 17 explanatory gloss identifies Khepri in the boat as Ra-Horakhty himself.','egypt.book_dead17.khepri_ra_horakhty','SUPPORTED',0.93,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Book of the Dead','Spell 17, explanatory gloss','This relation is strictly witness-scoped and is not a global entity merge.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.khepri_hymn_stela','deity.egyptian.khepri','MENTIONED_IN','museum.bm.khepri_hymn_stela_ea826',NULL,NULL,'British Museum stela EA826 contains a twenty-one-line hymn to Khepri according to the catalogue.','egypt.khepri.object.ea826','SUPPORTED',0.98,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Museum object','BM EA826','Text metadata only; no full transcription is reproduced.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.khepri_stela_held_bm','museum.bm.khepri_hymn_stela_ea826','HELD_BY_MUSEUM','institution.british_museum',NULL,NULL,'The British Museum holds stela EA826.','egypt.object.custody','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Modern custody','BM EA826',NULL,'2026-08-15T00:00:00Z'),
('claim.v070.egypt.spell17_part_book_dead','text.egypt.book_dead_spell17','PART_OF','text.egypt.book_dead',NULL,NULL,'Spell 17 is indexed as a section of the Book of the Dead corpus.','egypt.book_dead.structure','SUPPORTED',0.99,'HIGH','VERIFIED','SCHOLARLY_DIGITAL_TEXT','TEXTUAL_WITNESS','Book of the Dead','Spell 17','Section containment does not imply one fixed manuscript text.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.atum_spell17','deity.egyptian.atum','APPEARS_IN','text.egypt.book_dead_spell17',NULL,NULL,'Atum appears repeatedly in the registered Spell 17 explanations and journey language.','egypt.book_dead17.solar_forms','SUPPORTED',0.96,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Book of the Dead','Spell 17, Allen Part a','No universal equation of Atum and Ra is asserted.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.amun_ra_abu_simbel','deity.egyptian.amun_ra','DEPICTED_ON','site.egypt.abu_simbel',NULL,NULL,'The official Abu Simbel record identifies Amun-Ra among the four seated sanctuary figures.','egypt.abu_simbel.sanctuary','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Abu Simbel Great Temple','Sanctuary','Depiction at a real temple; not a mythic event location.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.ra_horakhty_abu_simbel','deity.egyptian.ra_horakhty','DEPICTED_ON','site.egypt.abu_simbel',NULL,NULL,'The official Abu Simbel record identifies Ra-Horakhty among the four seated sanctuary figures.','egypt.abu_simbel.sanctuary','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Abu Simbel Great Temple','Sanctuary','Depiction at a real temple; not a mythic event location.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.abu_simbel_unesco88','site.egypt.abu_simbel','ATTESTED_BY',NULL,'UNESCO World Heritage List 88, Nubian Monuments from Abu Simbel to Philae','text','UNESCO records Abu Simbel within the real protected Nubian Monuments property.','egypt.abu_simbel.heritage','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','UNESCO heritage','World Heritage List 88','Heritage status remains separate from deity and ritual claims.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.solar_journey_amduat','event.egyptian.nocturnal_solar_journey','APPEARS_IN','text.egypt.amduat',NULL,NULL,'The registered museum summary describes the netherworld book as presenting forms of the sun god during a nightly journey.','egypt.nocturnal_solar_journey','SUPPORTED',0.95,'HIGH','VERIFIED','HISTORICAL_REALITY','TEXTUAL_WITNESS','Amduat / netherworld book','Nauny object catalogue context','A modern event label indexes a mythic-cosmological textual sequence.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.ra_participates_solar_journey','deity.egyptian.ra','PARTICIPATED_IN','event.egyptian.nocturnal_solar_journey',NULL,NULL,'The registered funerary-text summary identifies the sun god as the traveller through the netherworld cycle.','egypt.nocturnal_solar_journey','SUPPORTED',0.95,'HIGH','VERIFIED','HISTORICAL_REALITY','MYTHIC_NARRATIVE','Egyptian funerary cosmology','Nauny object catalogue context','Mythic participant edge, not a historical person or trip.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.solar_journey_barque','event.egyptian.nocturnal_solar_journey','ASSOCIATED_WITH','artifact.egyptian.solar_barque',NULL,NULL,'The nocturnal solar journey is modeled with the existing solar-barque artifact concept.','egypt.nocturnal_solar_journey','SUPPORTED',0.9,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','MYTHIC_NARRATIVE','Egyptian funerary cosmology','Cross-source synthesis','The barque is a mythic/artifactual class entry, not one surviving archaeological ship.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.nauny_witness_book_dead','museum.met.nauny_book_dead_30_3_31','WITNESS_OF','text.egypt.book_dead',NULL,NULL,'Nauny papyrus 30.3.31 is catalogued as a Book of the Dead witness.','egypt.nauny.papyrus','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Dynasty 21 funerary object','Met 30.3.31','Object and textual corpus remain separate entities.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.nauny_held_met','museum.met.nauny_book_dead_30_3_31','HELD_BY_MUSEUM','institution.met',NULL,NULL,'The Metropolitan Museum of Art holds Nauny papyrus 30.3.31.','egypt.object.custody','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Modern custody','Met 30.3.31',NULL,'2026-08-15T00:00:00Z'),
('claim.v070.egypt.amun_member_theban_triad','deity.egyptian.amun','MEMBER_OF','group.egyptian.theban_triad',NULL,NULL,'Amun is the father member of the Theban triad in the registered scholarly synthesis.','egypt.theban_triad','SUPPORTED',0.98,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','RITUAL_PRACTICE','Theban cult','UEE 2008 p.6','Cult grouping; not biological genealogy.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.mut_member_theban_triad','deity.egyptian.mut','MEMBER_OF','group.egyptian.theban_triad',NULL,NULL,'Mut is the mother member of the Theban triad in the registered scholarly synthesis.','egypt.theban_triad','SUPPORTED',0.98,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','RITUAL_PRACTICE','Theban cult','UEE 2008 p.6','Cult grouping; not a universal genealogy.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.khonsu_member_theban_triad','deity.egyptian.khonsu','MEMBER_OF','group.egyptian.theban_triad',NULL,NULL,'Khonsu is the child member of the Theban triad in the registered scholarly synthesis.','egypt.theban_triad','SUPPORTED',0.98,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','RITUAL_PRACTICE','Theban cult','UEE 2008 p.6','Cult grouping; not a universal genealogy.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.opet_associated_triad','festival.egyptian.opet','ASSOCIATED_WITH','group.egyptian.theban_triad',NULL,NULL,'The official Luxor Temple record describes an Opet procession of the cult images of Amun, Mut and Khonsu.','egypt.opet.public_site_record','SUPPORTED',0.98,'HIGH','VERIFIED','HISTORICAL_REALITY','RITUAL_PRACTICE','Theban festival','Official Luxor Temple record','Public historical description only.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.opet_associated_karnak','festival.egyptian.opet','ASSOCIATED_WITH','site.egypt.karnak',NULL,NULL,'The Opet procession departed from the deities'' temples at Karnak in the registered official account.','egypt.opet.public_site_record','SUPPORTED',0.98,'HIGH','VERIFIED','HISTORICAL_REALITY','RITUAL_PRACTICE','Theban festival','Official Luxor Temple record','Route layer remains period-sensitive.','2026-08-15T00:00:00Z'),
('claim.v070.egypt.opet_associated_luxor','festival.egyptian.opet','ASSOCIATED_WITH','site.egypt.luxor_temple',NULL,NULL,'Luxor Temple was a principal destination and venue of the Opet Festival in the registered official account.','egypt.opet.public_site_record','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','RITUAL_PRACTICE','Theban festival','Official Luxor Temple record','Real site and historical ritual layer.','2026-08-15T00:00:00Z');

INSERT OR IGNORE INTO evidence(
  id,claim_id,source_id,source_location,chapter,verse,line,page,catalogue_number,
  short_quote,evidence_type,direction,strength,research_notes
)
SELECT
  'evidence.' || substr(c.id,7), c.id,
  CASE
    WHEN c.id IN ('claim.v070.egypt.syncretism_model','claim.v070.egypt.amun_ra_component_amun','claim.v070.egypt.amun_ra_component_ra','claim.v070.egypt.ra_horakhty_component_ra','claim.v070.egypt.amun_member_theban_triad','claim.v070.egypt.mut_member_theban_triad','claim.v070.egypt.khonsu_member_theban_triad') THEN 'source.egypt.syncretism.uee2008'
    WHEN c.id='claim.v070.egypt.ra_horakhty_component_horus' OR c.id IN ('claim.v070.egypt.stela_depicts_ra_horakhty','claim.v070.egypt.stela_held_met') THEN 'source.egypt.ra_horakhty_stela.met.oc81'
    WHEN c.id LIKE 'claim.v070.egypt.%spell17' OR c.id IN ('claim.v070.egypt.khepri_solar_barque','claim.v070.egypt.khepri_identified_ra_horakhty','claim.v070.egypt.spell17_part_book_dead','claim.v070.egypt.atum_spell17') THEN 'source.egypt.book_dead17.ucl'
    WHEN c.id IN ('claim.v070.egypt.amun_ra_worshipped_karnak') THEN 'source.egypt.karnak.origins.cfeetk'
    WHEN c.id IN ('claim.v070.egypt.great_temple_part_karnak') THEN 'source.egypt.karnak.mota'
    WHEN c.id='claim.v070.egypt.karnak_unesco87' THEN 'source.egypt.thebes.unesco87'
    WHEN c.id IN ('claim.v070.egypt.scarab_depicts_amun_ra','claim.v070.egypt.scarab_held_met') THEN 'source.egypt.amun_re_scarab.met.09_180_953'
    WHEN c.id IN ('claim.v070.egypt.amulet_depicts_ra_horakhty','claim.v070.egypt.amulet_held_met') THEN 'source.egypt.ra_horakhty_amulet.met.74_51_4497'
    WHEN c.id IN ('claim.v070.egypt.khepri_hymn_stela','claim.v070.egypt.khepri_stela_held_bm') THEN 'source.egypt.khepri_hymn.bm.ea826'
    WHEN c.id IN ('claim.v070.egypt.amun_ra_abu_simbel','claim.v070.egypt.ra_horakhty_abu_simbel') THEN 'source.egypt.abu_simbel.mota'
    WHEN c.id='claim.v070.egypt.abu_simbel_unesco88' THEN 'source.egypt.nubian.unesco88'
    WHEN c.id IN ('claim.v070.egypt.solar_journey_amduat','claim.v070.egypt.ra_participates_solar_journey','claim.v070.egypt.solar_journey_barque','claim.v070.egypt.nauny_witness_book_dead','claim.v070.egypt.nauny_held_met') THEN 'source.egypt.nauny_book_dead.met.30_3_31'
    WHEN c.id IN ('claim.v070.egypt.opet_associated_triad','claim.v070.egypt.opet_associated_karnak','claim.v070.egypt.opet_associated_luxor') THEN 'source.egypt.luxor.mota'
  END,
  c.temporal_scope,
  CASE WHEN c.id LIKE '%spell17%' OR c.id IN ('claim.v070.egypt.khepri_solar_barque','claim.v070.egypt.khepri_identified_ra_horakhty','claim.v070.egypt.spell17_part_book_dead','claim.v070.egypt.atum_spell17') THEN 'Spell 17' ELSE NULL END,
  NULL,NULL,
  CASE WHEN c.id LIKE 'claim.v070.egypt.%component%' OR c.id LIKE 'claim.v070.egypt.%theban_triad' OR c.id='claim.v070.egypt.syncretism_model' THEN '4-7' ELSE NULL END,
  CASE
    WHEN c.id LIKE '%scarab%' THEN '09.180.953'
    WHEN c.id LIKE '%stela_%' AND c.id NOT LIKE '%khepri%' THEN 'O.C.81'
    WHEN c.id LIKE '%amulet%' THEN '74.51.4497'
    WHEN c.id LIKE '%khepri_stela%' OR c.id LIKE '%khepri_hymn%' THEN 'EA826'
    WHEN c.id LIKE '%nauny%' THEN '30.3.31'
    ELSE NULL
  END,
  NULL,
  CASE
    WHEN c.knowledge_layer='ARCHAEOLOGICAL' THEN 'ARCHAEOLOGICAL'
    WHEN c.knowledge_layer='ARCHAEOLOGICAL' THEN 'ARCHAEOLOGICAL'
    WHEN c.knowledge_layer='TEXTUAL_WITNESS' THEN 'ANCIENT_TEXT'
    WHEN c.knowledge_layer='MYTHIC_NARRATIVE' THEN 'ANCIENT_TEXT'
    WHEN c.knowledge_layer='RITUAL_PRACTICE' THEN 'ARCHAEOLOGICAL'
    ELSE 'MODERN_SCHOLARSHIP'
  END,
  'SUPPORTS',c.confidence,
  'Source and locator checked for the v0.7.0 staged baseline on 2026-08-15; no long quotation or museum image is published.'
FROM claims c WHERE c.id LIKE 'claim.v070.%';

INSERT OR REPLACE INTO comparison_sets(
  id,concept_entity_id,canonical_name,name_zh,description_en,description_zh,
  methodology_en,methodology_zh,research_status,created_at,updated_at
) VALUES(
  'comparison.egyptian.solar_composite_forms','concept.egyptian.divine_syncretism',
  'Egyptian solar forms and composite deities','古埃及太阳神形态与复合神对照',
  'A source-led comparison of Ra, Atum, Khepri, Amun, Amun-Ra and Ra-Horakhty. Membership records a useful native comparison, never a global merger.',
  '按来源比较拉、阿图姆、凯布利、阿蒙、阿蒙-拉与拉-哈拉赫提。进入本表仅表示原生语境中可比较，不表示全局合并。',
  'Every member is linked to a located claim. Textual equations, cult groupings, temple manifestations and scholarly syncretism models remain separately scoped.',
  '每位成员都连接已定位 Claim；文本中的认同、祭祀组合、神庙显现和学术复合模型分别保存。',
  'PARTIAL','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'
);

INSERT OR REPLACE INTO comparison_set_members(
  comparison_set_id,entity_id,member_role,native_scope_en,native_scope_zh,
  distinction_en,distinction_zh,sort_order,claim_id
) VALUES
('comparison.egyptian.solar_composite_forms','deity.egyptian.ra','SOLAR_CORE','Solar deity and traveller in funerary cosmology','太阳神与葬仪宇宙论中的行旅者','Ra remains an independent deity even where composite expressions invoke him.','即使复合神名含有拉，拉仍保留独立神祇档案。',10,'claim.v070.egypt.ra_participates_solar_journey'),
('comparison.egyptian.solar_composite_forms','deity.egyptian.atum','TEXTUAL_SOLAR_FORM','Creator and solar figure in registered Spell 17 explanations','第17咒文解释层中的创造／太阳神形态','No universal Atum-Ra merger is asserted.','不宣布阿图姆与拉在所有时期都是同一实体。',20,'claim.v070.egypt.atum_spell17'),
('comparison.egyptian.solar_composite_forms','deity.egyptian.khepri','RISING_SOLAR_FORM','Becoming and rising-sun layer in funerary text and hymn evidence','葬仪文本与赞歌证据中的生成／晨日层','A Spell 17 equation with Ra-Horakhty remains witness-specific.','与拉-哈拉赫提的认同只限特定第17咒文解释层。',30,'claim.v070.egypt.khepri_spell17'),
('comparison.egyptian.solar_composite_forms','deity.egyptian.amun','COMPONENT_DEITY','Theban hidden/creator deity and component in Amun-Ra','底比斯隐秘／创造神及阿蒙-拉组成神','Amun is not relabeled as a generic sun god in every source.','不会把所有阿蒙资料都改写成太阳神资料。',40,'claim.v070.egypt.amun_member_theban_triad'),
('comparison.egyptian.solar_composite_forms','deity.egyptian.amun_ra','SYNCRETIZED_DEITY','Theban-solar composite with dated temple and object witnesses','具有明确神庙与器物证据的底比斯—太阳复合神','Stored separately from Amun and Ra; component edges are not redirects.','与阿蒙和拉分别建档，组成关系不是重定向。',50,'claim.v070.egypt.amun_ra_component_ra'),
('comparison.egyptian.solar_composite_forms','deity.egyptian.ra_horakhty','SYNCRETIZED_DEITY','Solar and Horus-of-the-horizons composite','拉与双地平线荷鲁斯的复合表达','Not every Horus form is Ra-Horakhty.','并非所有荷鲁斯形态都等于拉-哈拉赫提。',60,'claim.v070.egypt.ra_horakhty_component_horus');

INSERT OR IGNORE INTO identity_candidates(
  id,entity_a_id,entity_b_id,assessment,confidence,source_id,notes
) VALUES
('identity.v070.amun_ra_amun','deity.egyptian.amun_ra','deity.egyptian.amun','IDENTIFIED_IN_SOURCE',0.97,'source.egypt.syncretism.uee2008','Retain both entities and use COMPOSITE_EXPRESSION_OF.'),
('identity.v070.amun_ra_ra','deity.egyptian.amun_ra','deity.egyptian.ra','IDENTIFIED_IN_SOURCE',0.97,'source.egypt.syncretism.uee2008','Retain both entities and use COMPOSITE_EXPRESSION_OF.'),
('identity.v070.ra_horakhty_ra','deity.egyptian.ra_horakhty','deity.egyptian.ra','IDENTIFIED_IN_SOURCE',0.98,'source.egypt.ra_horakhty_stela.met.oc81','The component relation is source-backed; no redirect is created.'),
('identity.v070.ra_horakhty_horus','deity.egyptian.ra_horakhty','deity.egyptian.horus','IDENTIFIED_IN_SOURCE',0.96,'source.egypt.ra_horakhty_stela.met.oc81','Horus is horizon-specific here; not every Horus manifestation is included.'),
('identity.v070.khepri_ra_horakhty','deity.egyptian.khepri','deity.egyptian.ra_horakhty','IDENTIFIED_IN_SOURCE',0.93,'source.egypt.book_dead17.ucl','One Spell 17 gloss supports identification in that witness only.');

INSERT OR IGNORE INTO conflicts(
  id,subject_id,variant_group,claim_a_id,claim_b_id,conflict_type,status,summary,resolution_notes
) VALUES
('conflict.v070.amun_ra_identity_model','deity.egyptian.amun_ra','egypt.amun_ra.identity_model','claim.v070.egypt.amun_ra_component_amun','claim.v070.egypt.amun_ra_component_ra','COMPOSITE_IDENTITY','RESOLVED_AS_VARIANTS','Amun-Ra involves Amun and Ra but cannot be safely represented as a spelling alias or destructive merge.','Keep a canonical composite entity with two component edges and dated evidence.'),
('conflict.v070.ra_horakhty_horus_scope','deity.egyptian.ra_horakhty','egypt.ra_horakhty.horus_scope','claim.v070.egypt.ra_horakhty_component_ra','claim.v070.egypt.ra_horakhty_component_horus','COMPONENT_SCOPE','RESOLVED_AS_VARIANTS','Ra-Horakhty invokes Horus in a horizon-specific scope; a merge into the general Horus record would erase other Horus forms.','Keep the composite record and explicitly state the horizon limitation.'),
('conflict.v070.khepri_ra_horakhty_scope','deity.egyptian.khepri','egypt.book_dead17.khepri_ra_horakhty','claim.v070.egypt.khepri_identified_ra_horakhty','claim.v070.egypt.khepri_hymn_stela','WITNESS_SCOPE','OPEN','Spell 17 identifies Khepri with Ra-Horakhty in one explanation while other witnesses address Khepri independently.','Preserve both claims and forbid a global redirect pending wider witness study.');

UPDATE collection_queue SET
  status='PARTIAL',attempts=attempts+1,last_error=NULL,
  next_action='Add dated Amun-Ra epithets, temple inscriptions and regional manifestations without merging Amun or Ra',
  updated_at='2026-08-15T00:00:00Z'
WHERE id='queue.egypt.amun_ra';

UPDATE collection_queue SET
  status='PARTIAL',attempts=attempts+1,last_error=NULL,
  next_action='Expand Ra-Horakhty textual and temple witnesses by period; keep other Horus forms distinct',
  updated_at='2026-08-15T00:00:00Z'
WHERE id='queue.egypt.ra_horakhty';

INSERT OR IGNORE INTO collection_queue(
  id,target_label,normalized_label,proposed_entity_type,civilization_id,
  discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,
  discovery_context,priority,status,attempts,last_error,next_action,created_at,updated_at
) VALUES
('queue.v070.egypt.syncretism_expansion','Egyptian composite deity network beyond Amun-Ra and Ra-Horakhty','egyptian composite deity network beyond amun ra and ra horakhty','CONCEPT','civ.egyptian','concept.egyptian.divine_syncretism','claim.v070.egypt.syncretism_model','source.egypt.syncretism.uee2008','The scholarly model names further composites such as Ptah-Sokar-Osiris that require separate dated dossiers.',99,'SOURCE_FOUND',1,NULL,'Add Ptah-Sokar-Osiris, Ra-Atum and other composites only with witness-located component claims','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('queue.v070.egypt.heliopolis_solar_forms','Heliopolitan Ra, Atum and Khepri textual layers','heliopolitan ra atum and khepri textual layers','CONCEPT','civ.egyptian','deity.egyptian.khepri','claim.v070.egypt.atum_spell17','source.egypt.book_dead17.ucl','Spell 17 exposes multiple solar forms but is insufficient for a full Heliopolitan chronology.',98,'SOURCE_FOUND',1,NULL,'Add Pyramid Texts, Coffin Texts and temple witnesses by period; do not force a single triad schema','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('queue.v070.egypt.opet_layers','Opet Festival inscriptions, routes and chronological variants','opet festival inscriptions routes and chronological variants','FESTIVAL','civ.egyptian','festival.egyptian.opet','claim.v070.egypt.opet_associated_triad','source.egypt.luxor.mota','The public official-site summary establishes a route and participants but not the full diachronic ritual dossier.',97,'SOURCE_FOUND',1,NULL,'Add dated reliefs, inscriptions and archaeological phases; preserve route and participant variants','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('queue.v070.egypt.khepri_iconography','Khepri names, scarab iconography and primary inscriptions','khepri names scarab iconography and primary inscriptions','DEITY','civ.egyptian','deity.egyptian.khepri','claim.v070.egypt.khepri_hymn_stela','source.egypt.khepri_hymn.bm.ea826','The hymn and Spell 17 establish a baseline but many scarab objects and periods remain unmodeled.',96,'SOURCE_FOUND',1,NULL,'Add object-level museum catalogues and primary text locators; distinguish scarab symbols from deity depictions','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('queue.v070.egypt.abu_simbel_sanctuary','Abu Simbel sanctuary deities, relocation and conservation evidence','abu simbel sanctuary deities relocation and conservation evidence','TEMPLE','civ.egyptian','site.egypt.abu_simbel','claim.v070.egypt.abu_simbel_unesco88','source.egypt.nubian.unesco88','Official pages establish the sanctuary figures and relocation, leaving monument-level conservation records and inscriptions open.',94,'SOURCE_FOUND',1,NULL,'Add UNESCO campaign documents, inscription locators and monument components without turning solar alignment claims into unsupported ancient intent','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z'),
('queue.v070.egypt.theban_triad_variants','Theban Triad cult, genealogy and regional variants','theban triad cult genealogy and regional variants','CONCEPT','civ.egyptian','group.egyptian.theban_triad','claim.v070.egypt.amun_member_theban_triad','source.egypt.syncretism.uee2008','The baseline records a cult grouping but not every genealogy, epithet or local manifestation.',95,'SOURCE_FOUND',1,NULL,'Add dated temple and textual witnesses; keep cult grouping separate from universal biological genealogy','2026-08-15T00:00:00Z','2026-08-15T00:00:00Z');

INSERT OR IGNORE INTO queue_discoveries(
  id,queue_id,discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,discovery_context,discovered_at
) VALUES
('discovery.v070.egypt.syncretism','queue.v070.egypt.syncretism_expansion','concept.egyptian.divine_syncretism','claim.v070.egypt.syncretism_model','source.egypt.syncretism.uee2008','The Amun-Ra and Ra-Horakhty audit exposes a wider network of composite deities.','2026-08-15T00:00:00Z'),
('discovery.v070.egypt.heliopolis','queue.v070.egypt.heliopolis_solar_forms','deity.egyptian.khepri','claim.v070.egypt.atum_spell17','source.egypt.book_dead17.ucl','Spell 17 juxtaposes Khepri, Ra-Horakhty and Atum and exposes a broader textual-history task.','2026-08-15T00:00:00Z'),
('discovery.v070.egypt.opet','queue.v070.egypt.opet_layers','festival.egyptian.opet','claim.v070.egypt.opet_associated_triad','source.egypt.luxor.mota','The official route summary exposes unresolved chronological and inscription layers.','2026-08-15T00:00:00Z'),
('discovery.v070.egypt.khepri','queue.v070.egypt.khepri_iconography','deity.egyptian.khepri','claim.v070.egypt.khepri_hymn_stela','source.egypt.khepri_hymn.bm.ea826','The museum hymn record opens a larger object and primary-inscription branch.','2026-08-15T00:00:00Z'),
('discovery.v070.egypt.abu_simbel','queue.v070.egypt.abu_simbel_sanctuary','site.egypt.abu_simbel','claim.v070.egypt.abu_simbel_unesco88','source.egypt.nubian.unesco88','The sanctuary-deity pass opens relocation, conservation and inscription evidence branches.','2026-08-15T00:00:00Z'),
('discovery.v070.egypt.triad','queue.v070.egypt.theban_triad_variants','group.egyptian.theban_triad','claim.v070.egypt.amun_member_theban_triad','source.egypt.syncretism.uee2008','The first triad membership claims expose genealogy and local-manifestation variants.','2026-08-15T00:00:00Z');

INSERT OR IGNORE INTO queue_status_history(id,queue_id,old_status,new_status,changed_at,reason) VALUES
('qhist.v070.egypt.amun_ra','queue.egypt.amun_ra','NEW','PARTIAL','2026-08-15T00:00:00Z','Composite entity, Karnak temple and object evidence baseline added'),
('qhist.v070.egypt.ra_horakhty','queue.egypt.ra_horakhty','NEW','PARTIAL','2026-08-15T00:00:00Z','Composite entity, Spell 17, Abu Simbel and museum-object baseline added'),
('qhist.v070.egypt.syncretism','queue.v070.egypt.syncretism_expansion','DISCOVERED','SOURCE_FOUND','2026-08-15T00:00:00Z','Peer-reviewed composite-deity model registered'),
('qhist.v070.egypt.heliopolis','queue.v070.egypt.heliopolis_solar_forms','DISCOVERED','SOURCE_FOUND','2026-08-15T00:00:00Z','Spell 17 digital witness registered'),
('qhist.v070.egypt.opet','queue.v070.egypt.opet_layers','DISCOVERED','SOURCE_FOUND','2026-08-15T00:00:00Z','Official Luxor and Karnak site records registered'),
('qhist.v070.egypt.khepri','queue.v070.egypt.khepri_iconography','DISCOVERED','SOURCE_FOUND','2026-08-15T00:00:00Z','Book of the Dead and British Museum object locators registered'),
('qhist.v070.egypt.abu_simbel','queue.v070.egypt.abu_simbel_sanctuary','DISCOVERED','SOURCE_FOUND','2026-08-15T00:00:00Z','Official monument and UNESCO property records registered'),
('qhist.v070.egypt.triad','queue.v070.egypt.theban_triad_variants','DISCOVERED','SOURCE_FOUND','2026-08-15T00:00:00Z','Theban triad and Opet first-pass evidence registered');

INSERT OR IGNORE INTO research_sessions(
  id,started_at,ended_at,scope,strategy,status,agent_or_process,notes
) VALUES(
  'research.20260815.v070_egyptian_solar_composites','2026-08-15T00:00:00Z','2026-08-15T06:00:00Z',
  'Egyptian solar forms, composite deities, Karnak and Abu Simbel cult-site evidence, museum objects, funerary-text journey and the public Opet layer',
  'Start from permanent NEW queue targets; prioritize peer-reviewed Egyptology, official Egyptian monuments, UNESCO, museum catalogues and a university digital text; preserve components, variants and archaeological reality as separate layers',
  'CHECKPOINT_COMPLETE','Codex persistent research pipeline',
  'Expandable staged baseline only. Wider composite deities, Heliopolitan chronology, Opet inscriptions, Khepri iconography, Abu Simbel conservation and Theban triad variants remain queued.'
);

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result)
SELECT 'research.20260815.v070_egyptian_solar_composites','SOURCE',id,'REGISTER','URL_SYNTAX_VALID_WITH_LOCATOR_AND_RIGHTS_NOTE'
FROM sources WHERE accessed_date='2026-08-15' AND id LIKE 'source.egypt.%';

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result)
SELECT 'research.20260815.v070_egyptian_solar_composites','CLAIM',id,'REGISTER','SOURCE_LOCATED'
FROM claims WHERE id LIKE 'claim.v070.%';

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result)
SELECT 'research.20260815.v070_egyptian_solar_composites','ENTITY',id,'CREATE','DISCOVERY_PATH_AND_SOURCE_LAYER_REGISTERED'
FROM entities WHERE created_at='2026-08-15T00:00:00Z';

UPDATE entities SET evidence_status='PARTIAL',updated_at='2026-08-15T06:00:00Z'
WHERE id IN (SELECT DISTINCT subject_id FROM claims WHERE id LIKE 'claim.v070.%');

UPDATE entities SET evidence_status='PARTIAL',updated_at='2026-08-15T06:00:00Z'
WHERE id IN (
  SELECT DISTINCT c.object_entity_id FROM claims c JOIN evidence ev ON ev.claim_id=c.id
  WHERE c.id LIKE 'claim.v070.%' AND c.object_entity_id IS NOT NULL
);

UPDATE entities SET evidence_status='SOURCE_BACKED',updated_at='2026-08-15T06:00:00Z'
WHERE EXISTS (SELECT 1 FROM claims c WHERE c.subject_id=entities.id)
  AND NOT EXISTS (
    SELECT 1 FROM claims c WHERE c.subject_id=entities.id
      AND NOT EXISTS (SELECT 1 FROM evidence ev WHERE ev.claim_id=c.id)
  );

UPDATE entities SET evidence_status='CONFLICTING',research_status='CONFLICT',updated_at='2026-08-15T06:00:00Z'
WHERE id IN (SELECT subject_id FROM conflicts WHERE status='OPEN' AND subject_id IS NOT NULL);

UPDATE civilizations SET research_status='COLLECTING',evidence_status='PARTIAL'
WHERE id='civ.egyptian';

UPDATE project_metadata SET value='0.7.0-egyptian-solar-composites-20260815',updated_at='2026-08-15T06:00:00Z' WHERE key='data_version';
UPDATE project_metadata SET value='10',updated_at='2026-08-15T06:00:00Z' WHERE key='schema_version';
UPDATE project_metadata SET value='2026-08-15T06:00:00Z',updated_at='2026-08-15T06:00:00Z' WHERE key='generated_at';

INSERT OR IGNORE INTO dataset_releases(
  id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes
) VALUES(
  'release.0.7.0',10,'0.7.0-egyptian-solar-composites-20260815',NULL,'2026-08-15T06:00:00Z',NULL,
  'Egyptian solar-composite checkpoint: Amun-Ra and Ra-Horakhty separated from their component deities; Khepri and Spell 17 witness layer; Karnak Great Temple and Abu Simbel evidence; museum objects; nocturnal solar journey; Theban Triad and public Opet route; permanent follow-up discovery paths.'
);

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(10,'20260815_v070_egyptian_solar_composites','2026-08-15T06:00:00Z');

COMMIT;
