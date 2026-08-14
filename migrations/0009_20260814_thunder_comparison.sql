BEGIN IMMEDIATE;

-- v0.6.0 introduces evidence-led comparison sets. Membership means that two
-- records are useful comparanda for a documented domain; it never asserts
-- identity, common origin, or direct historical transmission.
CREATE TABLE IF NOT EXISTS comparison_sets (
    id TEXT PRIMARY KEY,
    concept_entity_id TEXT REFERENCES entities(id),
    canonical_name TEXT NOT NULL,
    name_zh TEXT,
    description_en TEXT NOT NULL,
    description_zh TEXT NOT NULL,
    methodology_en TEXT NOT NULL,
    methodology_zh TEXT NOT NULL,
    research_status TEXT NOT NULL DEFAULT 'PARTIAL'
        CHECK(research_status IN ('DISCOVERED','SOURCE_FOUND','COLLECTING','PARTIAL','BASELINE_COMPLETE','NEEDS_REVIEW','CONFLICT','LOW_EVIDENCE','EXPAND_LATER')),
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS comparison_set_members (
    comparison_set_id TEXT NOT NULL REFERENCES comparison_sets(id) ON DELETE CASCADE,
    entity_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    member_role TEXT NOT NULL DEFAULT 'COMPARAND',
    native_scope_en TEXT NOT NULL,
    native_scope_zh TEXT NOT NULL,
    distinction_en TEXT NOT NULL,
    distinction_zh TEXT NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    claim_id TEXT REFERENCES claims(id),
    PRIMARY KEY(comparison_set_id, entity_id)
);

CREATE INDEX IF NOT EXISTS idx_comparison_members_entity
    ON comparison_set_members(entity_id, comparison_set_id);

INSERT OR IGNORE INTO sources(
  id,title,original_title,source_type,evidence_tier,institution,author_or_editor,
  language_id,publication_date,accessed_date,url,stable_url,doi,isbn,
  catalogue_number,manuscript_number,rights_status,source_perspective,
  community_or_lineage,collector_context,living_tradition,
  access_or_reuse_restrictions,community_permission_required,
  same_witness_as_source_id,translation_status,verification_status,notes
) VALUES
('source.marvel.thor.onscreen','Thor: on-screen biography',NULL,'OFFICIAL_MODERN_ADAPTATION',14,'Marvel','Marvel Editorial','lang.en',NULL,'2026-08-14','https://www.marvel.com/characters/thor-thor-odinson/on-screen',NULL,NULL,NULL,NULL,NULL,'Copyright Marvel; metadata and link only','Official modern screen-continuity character biography',NULL,NULL,0,'Do not reproduce page text or images; store a short research summary and link only',0,NULL,'Official English page','URL_SYNTAX_VALID','This source supports MCU continuity only: Loki is an adoptive brother and Hela a half-sister. It is not evidence for Old Norse kinship.'),
('source.vedic.rigveda.1_32.vhp','Rigveda Shakala Samhita, Mandala 1, Sukta 32','ऋग्वेद शाकल संहिता १.३२','PRIMARY_TEXT_OFFICIAL_PORTAL',1,'Vedic Heritage Portal / Indira Gandhi National Centre for the Arts',NULL,'lang.san',NULL,'2026-08-14','https://vedicheritage.gov.in/samhitas/rigveda/shakala-samhita/rigveda-shakala-samhitas-mandal-01-sukta-032/',NULL,NULL,NULL,'RV 1.32',NULL,'Portal content reuse requires permission','Official Sanskrit recitation and text portal',NULL,NULL,0,'Store metadata, verse locators and original research summaries; do not bulk reproduce portal content',0,NULL,'Sanskrit primary text','URL_SYNTAX_VALID','Verses 1-15 witness Indra, vajra, Tvastr, the serpent/Vrtra and released waters.'),
('source.vedic.rigveda.2_12.vhp','Rigveda Shakala Samhita, Mandala 2, Sukta 12','ऋग्वेद शाकल संहिता २.१२','PRIMARY_TEXT_OFFICIAL_PORTAL',1,'Vedic Heritage Portal / Indira Gandhi National Centre for the Arts',NULL,'lang.san',NULL,'2026-08-14','https://vedicheritage.gov.in/samhitas/rigveda/shakala-samhita/rigveda-shakala-samhita-mandal-02-sukta-012/',NULL,NULL,NULL,'RV 2.12',NULL,'Portal content reuse requires permission','Official Sanskrit recitation and text portal',NULL,NULL,0,'Store metadata, verse locators and original research summaries; do not bulk reproduce portal content',0,NULL,'Sanskrit primary text','URL_SYNTAX_VALID','Verses 2-3, 7 and 11-13 situate Indra in atmospheric, water-release and battle imagery.'),
('source.vedic.rigveda.gretIL_padapatha','Rigveda Padapatha, Mandala 1 digital text','Rgveda-Padapatha','SCHOLARLY_DIGITAL_TEXT',2,'GRETIL / University of Goettingen',NULL,'lang.san',NULL,'2026-08-14','https://gretil.sub.uni-goettingen.de/gretil/1_sanskr/1_veda/1_sam/1_rv/rvpp_01u.htm',NULL,NULL,NULL,'RV_1,32.1-15',NULL,'Reference use; source-file rights apply','Academic digital transcription',NULL,NULL,0,'Reference and locator use only; follow GRETIL source-file terms',0,NULL,'Sanskrit padapatha transcription','URL_SYNTAX_VALID','Independent scholarly digital locator for RV 1.32.'),
('source.japanese.raijin.kokugakuin','Raijin','雷神','ACADEMIC_REFERENCE',4,'Kokugakuin University Digital Museum',NULL,'lang.jpn',NULL,'2026-08-14','https://d-museum.kokugakuin.ac.jp/bts/detail/id%3D3892',NULL,NULL,NULL,'Basic Terms of Shinto ID 3892',NULL,'All rights reserved; metadata and link only','Academic overview of Shinto terminology and regional thunder-kami traditions',NULL,NULL,1,'Do not reproduce text or images without permission; store only a short independent summary',0,NULL,'Japanese academic reference','URL_SYNTAX_VALID','Supports treating Raijin as a broad thunder-kami designation with regional manifestations, not a globally fixed single genealogy.'),
('source.japanese.takemikazuchi.kokugakuin','Takemikazuchi','建御雷之男神','ACADEMIC_REFERENCE',4,'Kokugakuin University Encyclopedia of Shinto',NULL,'lang.jpn',NULL,'2026-08-14','https://d-museum.kokugakuin.ac.jp/eos/detail/id%3D9145',NULL,NULL,NULL,'Encyclopedia of Shinto ID 9145',NULL,'All rights reserved; metadata and link only','Academic overview citing Kojiki and Nihon Shoki variants',NULL,NULL,0,'Do not reproduce text or images without permission; store only a short independent summary',0,NULL,'Japanese academic reference','URL_SYNTAX_VALID','Supports martial envoy and land-transfer roles; thunder is retained as a secondary, contested classification.'),
('source.japanese.kojiki_kami_index.kokugakuin','Kojiki divine-name index','古事記神名データベース','SCHOLARLY_DIGITAL_INDEX',3,'Kokugakuin University',NULL,'lang.jpn',NULL,'2026-08-14','https://kojiki.kokugakuin.ac.jp/shinmei/',NULL,NULL,NULL,'Kojiki divine-name database',NULL,'All rights reserved; metadata and link only','Academic name and passage index for Kojiki deities',NULL,NULL,0,'Store names, passage locators and short summaries only',0,NULL,'Japanese scholarly index','URL_SYNTAX_VALID','Indexes the eight thunder kami in the Yomi episode separately; member pages warn against unsupported later identifications.'),
('source.chinese.chuci_yuanyou.ctext','Chu Ci, Yuan You','楚辭·遠遊','PRIMARY_TEXT_DIGITAL_EDITION',3,'Chinese Text Project','Traditional text; digital editor Donald Sturgeon','lang.lzh',NULL,'2026-08-14','https://ctext.org/chu-ci/yuan-you/zh','urn:ctext:chu-ci/yuan-you',NULL,NULL,'CTP Yuan You',NULL,'Text witness may be public domain; site and translations retain separate rights','Digital transcription of a transmitted classical text',NULL,NULL,0,'Cite the URN and short original-language locator; do not bulk copy the site or its translation',0,NULL,'Traditional Chinese text','URL_SYNTAX_VALID','The poem places Leigong to the right of the speaker as a guard, with the Rain Master to the left.'),
('source.chinese.lunheng_leixu.ctext','Lunheng, Lei Xu','論衡·雷虛','ANCIENT_TEXT_DIGITAL_EDITION',3,'Chinese Text Project','Wang Chong; digital editor Donald Sturgeon','lang.lzh',NULL,'2026-08-14','https://ctext.org/lunheng/lei-xu/zh','urn:ctext:lunheng/lei-xu',NULL,NULL,'CTP Lei Xu',NULL,'Text witness may be public domain; site and translations retain separate rights','Han critique recording and rejecting a thunder-god image tradition',NULL,NULL,0,'Cite the URN and short original-language locator; do not bulk copy the site or its translation',0,NULL,'Traditional Chinese text','URL_SYNTAX_VALID','Records linked drums, a mallet and a strongman image called Leigong, then argues against that explanation.'),
('source.chinese.shanhaijing_leize.ctext','Classic of Mountains and Seas, Hai Nei Dong Jing','山海經·海內東經','ANCIENT_TEXT_DIGITAL_EDITION',3,'Chinese Text Project','Traditional text; digital editor Donald Sturgeon','lang.lzh',NULL,'2026-08-14','https://ctext.org/shan-hai-jing/hai-nei-dong-jing/zh','urn:ctext:shan-hai-jing/hai-nei-dong-jing',NULL,NULL,'CTP Hai Nei Dong Jing',NULL,'Text witness may be public domain; site and translations retain separate rights','Digital transcription of a transmitted classical text',NULL,NULL,0,'Cite the URN and short original-language locator; do not bulk copy the site or its translation',0,NULL,'Traditional Chinese text','URL_SYNTAX_VALID','Witnesses an unnamed thunder spirit in Leize with dragon body and human head; it is not automatically merged with later Leigong.'),
('source.chinese.mogao285.dunhuang','Mogao Cave 285','莫高窟第285窟','OFFICIAL_SITE_AND_ART_HISTORY',4,'Dunhuang Academy',NULL,'lang.zh','538-539','2026-08-14','https://www.dha.ac.cn/info/1425/3698.htm',NULL,NULL,NULL,'Mogao Cave 285',NULL,'All rights reserved unless otherwise stated; metadata and link only','Official archaeological-site and art-historical description',NULL,NULL,0,'Do not package images; link to the official page',0,NULL,'Modern Chinese site description','URL_SYNTAX_VALID','Official page dates the Western Wei cave and identifies thunder-deity imagery among the ceiling subjects.'),
('source.slavic.pvl.obdurodon','Tale of Bygone Years digital critical edition','Повѣсть временныхъ лѣтъ','SCHOLARLY_DIGITAL_EDITION',2,'Obdurodon / academic PVL project','Donald Ostrowski and David J. Birnbaum project','lang.en',NULL,'2026-08-14','https://pvl.obdurodon.org/',NULL,NULL,NULL,'PVL digital edition',NULL,'Project terms apply','Critical digital presentation of the Primary Chronicle tradition',NULL,NULL,0,'Store locators and independent summaries; verify manuscript variants before quotation',0,'source.slavic.laurentian.nlr','Critical apparatus with text witnesses','URL_SYNTAX_VALID','Used for entries 907, 945, 971, 980 and 988; Perun/Veles oath and idol claims remain entry-specific.'),
('source.yoruba.sango_festival.unesco','Sango Festival, Oyo','Sango Festival, Oyo','LIVING_TRADITION_OFFICIAL_NOMINATION',3,'UNESCO Intangible Cultural Heritage',NULL,'lang.en','2023','2026-08-14','https://ich.unesco.org/en/RL/sango-festival-oyo-01974?RL=01974',NULL,NULL,NULL,'ICH 01974',NULL,'UNESCO page terms; nomination materials retain their stated rights','Community-backed public nomination dossier','Oyo communities, Alaafin institution and Sango devotees','Community nomination with free, prior and informed consent materials',1,'Do not record initiated-only knowledge, shrine interiors or ritual operating instructions',1,NULL,'English and Yoruba nomination materials','URL_SYNTAX_VALID','Public layer supports the annual festival, Koso association, kingship/ancestor memory and stated access boundaries.'),
('source.yoruba.ose_sango.met.1983_603_5','Ose Sango staff','Ose Sango','MUSEUM_OBJECT',3,'The Metropolitan Museum of Art',NULL,'lang.en','20th century','2026-08-14','https://www.metmuseum.org/art/collection/search/314326',NULL,NULL,NULL,'1983.603.5',NULL,'Collection metadata link only; object image not bundled','Museum catalogue description of a Yoruba Sango staff',NULL,'Collected in a modern museum context; provenance must remain attached',1,'Do not download or redistribute the object image; do not infer restricted ritual procedure',1,NULL,'English museum catalogue','URL_SYNTAX_VALID','Supports the double-axe-topped staff as a sacred/devotional object, not an ancient battlefield weapon.'),
('source.ugaritic.baal_corpus.goettingen','Edition of Ugaritic Poetic Texts: corpus and tablet concordance','Edition der ugaritischen poetischen Texte','SCHOLARLY_PROJECT',2,'University of Goettingen',NULL,'lang.en',NULL,'2026-08-14','https://eupt.uni-goettingen.de/Korpus.html',NULL,NULL,NULL,'KTU 1.1-1.6 corpus concordance',NULL,'Project terms apply','Academic project description and museum/tablet concordance',NULL,NULL,0,'Do not imply that future 2027-2029 editions are already published',0,NULL,'German/English academic project','URL_SYNTAX_VALID','Supports six-tablet Baal Cycle scope, Ilimilku attribution context and museum concordances.'),
('source.ugaritic.hadad.bm','Hadad authority record','Hadad','MUSEUM_AUTHORITY_RECORD',5,'British Museum',NULL,'lang.en',NULL,'2026-08-14','https://www.britishmuseum.org/collection/term/BIOG143718',NULL,NULL,NULL,'BIOG143718',NULL,'Collection metadata link only','Museum authority record distinguishing the title Baal, Lord, from a universal personal name',NULL,NULL,0,'Metadata and link only',0,NULL,'English authority record','URL_SYNTAX_VALID','Supports title caution and Hadad/Baal scope; it does not authorize merging every Baal-named deity.'),
('source.ugaritic.ktu1_2.inventory.uchicago','Ras Shamra tablet inventory record for KTU 1.2',NULL,'SCHOLARLY_TABLET_INVENTORY',2,'University of Chicago OCHRE',NULL,'lang.en',NULL,'2026-08-14','https://pi.lib.uchicago.edu/1001/org/ochre/172a3413-6438-4e53-9629-34f86a0e1fd0',NULL,NULL,NULL,'KTU 1.2 / RS 3.367 + RS 3.346',NULL,'Project terms apply','Academic archaeological and textual inventory record',NULL,NULL,0,'Metadata and locator use only',0,NULL,'English inventory metadata','URL_SYNTAX_VALID','Supports KTU 1.2 tablet identity and the Baal-Yamm combat witness.'),
('source.ugaritic.weapons.die_bibel','Baal weapons Yagrush and Ayyamur in KTU 1.2 IV','Baal-Zyklus: Waffen','ACADEMIC_REFERENCE',4,'German Bible Society',NULL,'lang.en',NULL,'2026-08-14','https://www.die-bibel.de/stichwort/22163',NULL,NULL,NULL,'KTU 1.2 IV 11-26',NULL,'Copyright German Bible Society; metadata and link only','Academic lexical and textual locator',NULL,NULL,0,'Do not reproduce substantial page content',0,NULL,'German academic reference','URL_SYNTAX_VALID','Supports the two named weapons, Kothar-wa-Khasis as maker and the sequence of blows against Yamm.'),
('source.yoruba.sango_decision.unesco','Decision 18.COM 8.b.2: Sango Festival, Oyo',NULL,'OFFICIAL_DECISION',3,'UNESCO Intangible Cultural Heritage Committee',NULL,'lang.en','2023','2026-08-14','https://ich.unesco.org/en/decisions/18.COM/8.B.2',NULL,NULL,NULL,'18.COM 8.b.2',NULL,'UNESCO page terms apply','Official inscription decision and safeguarding/access summary','Oyo communities and Sango devotees','Community nomination and consent reviewed by UNESCO',1,'Keep initiated-only spaces and knowledge restricted; store access classification only',1,'source.yoruba.sango_festival.unesco','English official decision','URL_SYNTAX_VALID','Explicitly records community consent, apprenticeship transmission and restricted shrine spaces.'),
('source.yoruba.ose_sango.smithsonian','Sango staff','Staff for Shango','MUSEUM_OBJECT',3,'Smithsonian National Museum of African Art',NULL,'lang.en',NULL,'2026-08-14','https://africa.si.edu/collection/selected-artwork/1713',NULL,NULL,NULL,'NMAfA selected artwork 1713',NULL,'Smithsonian terms apply; metadata link only','Museum catalogue interpretation of a Yoruba Sango staff',NULL,'Museum collection context',1,'Do not infer secret ritual instructions; do not package media without checking rights',1,NULL,'English museum catalogue','URL_SYNTAX_VALID','Corroborates public iconographic and devotional context for the double-axe staff.'),
('source.slavic.perun.cius','Perun','Перун','ACADEMIC_REFERENCE',5,'Internet Encyclopedia of Ukraine / Canadian Institute of Ukrainian Studies',NULL,'lang.en',NULL,'2026-08-14','https://www.encyclopediaofukraine.com/display.asp?linkpath=pages%5CP%5CE%5CPerun.htm',NULL,NULL,NULL,'Perun authority article',NULL,'Copyright CIUS; metadata and short research summary only','Modern academic reference on East Slavic evidence',NULL,NULL,0,'Do not reproduce article text; use to contextualize primary chronicle evidence',0,NULL,'English academic reference','URL_SYNTAX_VALID','Used only as context; primary claims remain attached to the chronicle edition.'),
('source.japanese.raijin_screen.kyohaku','Wind God and Thunder God screens','風神雷神図屏風','MUSEUM_OBJECT',3,'Kyoto National Museum',NULL,'lang.en','17th century','2026-08-14','https://www.kyohaku.go.jp/eng/collection/meihin/kinsei/item10/',NULL,NULL,NULL,'National Treasure; Kennin-ji pair of screens',NULL,'Museum page and image rights apply','Official museum record for later Raijin iconography',NULL,NULL,0,'Link only; do not package museum images',0,NULL,'English museum catalogue','URL_SYNTAX_VALID','Later visual evidence for Raijin with linked drums; not an ancient textual genealogy or a unique named weapon.'),
('source.chinese.mogao440.unesco','Mogao Caves','莫高窟','OFFICIAL_HERITAGE_RECORD',3,'UNESCO World Heritage Centre',NULL,'lang.en','1987','2026-08-14','https://whc.unesco.org/en/list/440',NULL,NULL,NULL,'World Heritage List 440',NULL,'UNESCO site terms; descriptive text under stated IGO licence','Official World Heritage property record',NULL,NULL,0,'Link and metadata; follow UNESCO reuse terms',0,NULL,'English official heritage record','URL_SYNTAX_VALID','Establishes the real archaeological and heritage context of Mogao; it does not identify every image in Cave 285.'),
('source.japanese.jhti.berkeley','Japanese Historical Text Initiative resources',NULL,'UNIVERSITY_DIGITAL_TEXT_INDEX',3,'University of California, Berkeley',NULL,'lang.en',NULL,'2026-08-14','https://ieas.berkeley.edu/centers/center-japanese-studies-cjs/academic-resources/japanese-historical-text-initiative',NULL,NULL,NULL,'JHTI resources',NULL,'University site and edition rights apply','University-hosted index for Kojiki and Nihon Shoki digital resources',NULL,NULL,0,'Store bibliographic metadata and locators; modern translations may remain copyrighted',0,NULL,'Japanese text resources and English metadata','URL_SYNTAX_VALID','Supports text-registry provenance and source discovery; exact mythic claims use witness-specific locators.'),
('source.japanese.wakaikazuchi.kokugakuin','Wakaikazuchi','若雷','SCHOLARLY_NAME_ENTRY',3,'Kokugakuin University Kojiki Divine-name Database',NULL,'lang.jpn',NULL,'2026-08-14','https://kojiki.kokugakuin.ac.jp/shinmei/wakaikazuchi/',NULL,NULL,NULL,'Kojiki: Upper Scroll, Yomi episode',NULL,'All rights reserved; metadata and link only','Academic entry for one of the eight thunder kami on Izanami',NULL,NULL,0,'Do not reproduce entry text; store name, witness locator and a short summary only',0,'source.japanese.kojiki_kami_index.kokugakuin','Japanese scholarly entry','URL_SYNTAX_VALID','The page treats Wakaikazuchi as one of the eight thunder kami and notes uncertainty about detailed form or character.'),
('source.japanese.naruikazuchi.kokugakuin','Naruikazuchi','鳴雷','SCHOLARLY_NAME_ENTRY',3,'Kokugakuin University Kojiki Divine-name Database',NULL,'lang.jpn',NULL,'2026-08-14','https://kojiki.kokugakuin.ac.jp/shinmei/naruikazuchi/',NULL,NULL,NULL,'Kojiki: Upper Scroll, Yomi episode',NULL,'All rights reserved; metadata and link only','Academic entry for one of the eight thunder kami on Izanami',NULL,NULL,0,'Do not reproduce entry text; store name, witness locator and a short summary only',0,'source.japanese.kojiki_kami_index.kokugakuin','Japanese scholarly entry','URL_SYNTAX_VALID','Warns that identity with a later Naruikazuchi shrine tradition is uncertain.'),
('source.japanese.takemikazuchi_names.kokugakuin','Takemikazuchi-no-o-no-kami divine-name entry','建御雷之男神','SCHOLARLY_NAME_ENTRY',3,'Kokugakuin University Kojiki Divine-name Database',NULL,'lang.jpn',NULL,'2026-08-14','https://kojiki.kokugakuin.ac.jp/shinmei/takemikazuchinoonokami/',NULL,NULL,NULL,'Kojiki divine-name entry',NULL,'All rights reserved; metadata and link only','Academic entry listing Kojiki names and witness variants',NULL,NULL,0,'Do not reproduce entry text; store names, passage locators and a short summary only',0,'source.japanese.takemikazuchi.kokugakuin','Japanese scholarly entry','URL_SYNTAX_VALID','Supports Takefutsu and Toyofutsu as Kojiki names while preserving multiple etymological proposals.'),
('source.ugaritic.canaan.met','The Gods and Goddesses of Canaan',NULL,'MUSEUM_SCHOLARSHIP',5,'The Metropolitan Museum of Art',NULL,'lang.en',NULL,'2026-08-14','https://www.metmuseum.org/essays/the-gods-and-goddesses-of-canaan',NULL,NULL,NULL,'Met Heilbrunn Timeline essay',NULL,'Copyright The Metropolitan Museum of Art; short summary and link only','Museum scholarly essay on Canaanite divine imagery',NULL,NULL,0,'Do not reproduce substantial essay text or images',0,NULL,'English museum scholarship','URL_SYNTAX_VALID','Contextualizes the Baal stele imagery and the storm/fertility layer without replacing tablet evidence.');

INSERT OR IGNORE INTO sources(
  id,title,original_title,source_type,evidence_tier,institution,author_or_editor,
  language_id,publication_date,accessed_date,url,stable_url,isbn,catalogue_number,
  rights_status,source_perspective,collector_context,living_tradition,
  access_or_reuse_restrictions,community_permission_required,
  translation_status,verification_status,notes
) VALUES(
  'source.norse.haustlong.skaldic2017','Thjodolf of Hvinir, Haustlong','Haustlǫng',
  'SCHOLARLY_POETIC_EDITION',2,'Skaldic Poetry of the Scandinavian Middle Ages project',
  'Margaret Clunies Ross; Kari Ellen Gade and Edith Marold, volume editors','lang.non','2017','2026-08-14',
  'https://skaldic.org/db.php?if=default&table=kenning&val=%C3%9E%C3%B3rr&view=name',NULL,
  '9782503518947','SkP III, pp. 431-463','Edition and database terms apply',
  'Academic edition and kenning index for an Old Norse skaldic poem','Modern scholarly edition of a medieval witness',0,
  'Use metadata, stanza locators and short research summaries; do not bulk copy the database',0,
  'Old Norse edition with scholarly apparatus','URL_SYNTAX_VALID',
  'Haustlong 14 and 16 preserve brother terminology relevant to Meili and Baldr; claims remain stanza-specific.'
);

UPDATE sources SET
  publication_date='2024',manuscript_number='GKS 2365 4to',
  rights_status='Electronic edition CC BY-SA 4.0; manuscript-image rights follow repository terms',
  notes='Electronic edition of the circa-1270 manuscript with images and transcription; poem witnesses remain composition- and manuscript-specific. Thrymskvida is at folios 17r12-18r4.'
WHERE id='source.norse.poetic_edda.gks2365';

INSERT OR IGNORE INTO entities(
  id,canonical_name,name_zh,original_name,transliteration,primary_type,
  primary_civilization_id,primary_region_id,historical_period,description,
  research_status,evidence_status,record_version,metadata_json,created_at,updated_at
) VALUES
('deity.norse.jord','Jord','约尔德／大地女神','Jǫrð','Jord','DEITY','civ.norse','region.northern_europe','Medieval Norse textual witness','《散文埃达》所见索尔之母；大地人格层与具体文本见证分开保存。 / Mother of Thor in the registered Prose Edda witness; earth-personification scope remains witness-specific.','PARTIAL','UNVERIFIED',1,'{"scope_caution":"medieval textual genealogy"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.norse.sif','Sif','希芙','Sif','Sif','DEITY','civ.norse','region.northern_europe','Medieval Norse textual witness','《诗语法》所见索尔之妻、乌勒尔之母与斯露德母系见证。 / Wife of Thor, mother of Ullr and mother of Thrud in registered medieval witnesses.','PARTIAL','UNVERIFIED',1,'{"scope_caution":"medieval textual genealogy"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.norse.magni','Magni','马格尼','Magni','Magni','DEITY','civ.norse','region.northern_europe','Medieval Norse textual witness','索尔之子；《诗语法》另称其母为雅恩莎撒。 / Son of Thor; Skaldskaparmal also names Jarnsaxa as his mother.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.norse.modi','Modi','莫迪','Móði','Modi','DEITY','civ.norse','region.northern_europe','Medieval Norse textual witness','索尔之子；当前所用家谱见证没有明确登记其母亲。 / Son of Thor; the registered genealogy witness does not name his mother.','PARTIAL','UNVERIFIED',1,'{"unknown_field":"mother"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.norse.thrud','Thrud','斯露德','Þrúðr','Thrudr','DEITY','civ.norse','region.northern_europe','Medieval Norse textual witness','索尔与希芙之女；不是索尔的姐姐。 / Daughter of Thor and Sif, not Thor’s sister.','PARTIAL','UNVERIFIED',1,'{"disambiguation":"daughter, not sister"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.norse.meili','Meili','梅利','Meili','Meili','DEITY','civ.norse','region.northern_europe','Old Norse poetic and medieval prose witnesses','古诺斯诗语与斯诺里材料称索尔为梅利之兄弟；资料仍极少。 / Thor is called Meili’s brother in registered poetic and Snorrian witnesses; the dossier remains sparse.','PARTIAL','UNVERIFIED',1,'{"coverage_caution":"sparse attestations"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('being.norse.jarnsaxa','Jarnsaxa','雅恩莎撒','Járnsaxa','Jarnsaxa','GIANT','civ.norse','region.northern_europe','Medieval Norse textual witness','《诗语法》所见马格尼之母。 / Mother of Magni in the registered Skaldskaparmal witness.','PARTIAL','UNVERIFIED',1,'{"classification_caution":"jotunn category is culture-specific"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.norse.ullr','Ullr','乌勒尔','Ullr','Ullr','DEITY','civ.norse','region.northern_europe','Medieval Norse textual witness','希芙之子；《诗语法》据此称索尔为其继父。 / Son of Sif; Skaldskaparmal consequently calls Thor his stepfather.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('modern.marvel.mcu.thor','Marvel Studios Thor','漫威电影宇宙版索尔',NULL,NULL,'MODERN_WORK',NULL,NULL,'Marvel screen continuity','现代影视角色版本；与古诺斯索尔分离。 / Modern screen-continuity interpretation, separate from the Old Norse entity.','PARTIAL','UNVERIFIED',1,'{"canonicality_scope":"POPULAR_CULTURE"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('modern.marvel.mcu.loki','Marvel Studios Loki','漫威电影宇宙版洛基',NULL,NULL,'MODERN_WORK',NULL,NULL,'Marvel screen continuity','现代影视角色版本；在该连续性中为索尔的养兄弟。 / Modern screen-continuity interpretation in which Loki is Thor’s adoptive brother.','PARTIAL','UNVERIFIED',1,'{"canonicality_scope":"POPULAR_CULTURE"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('modern.marvel.mcu.hela','Marvel Studios Hela','漫威电影宇宙版海拉',NULL,NULL,'MODERN_WORK',NULL,NULL,'Marvel screen continuity','现代影视角色版本；在该连续性中为索尔的同父异母姐姐。 / Modern screen-continuity interpretation in which Hela is Thor’s half-sister.','PARTIAL','UNVERIFIED',1,'{"canonicality_scope":"POPULAR_CULTURE"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.vedic.tvastr','Tvastr','陀湿多','त्वष्टृ','Tvastr','DEITY','civ.vedic','region.south_asia','Rigvedic textual witness','《梨俱吠陀》1.32 见证中为因陀罗制作金刚杵者。 / Maker of Indra’s vajra in the registered Rigveda 1.32 witness.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('creature.vedic.vritra','Vrtra','弗栗多','वृत्र','Vrtra','MONSTER','civ.vedic','region.south_asia','Rigvedic textual witness','《梨俱吠陀》1.32 中被因陀罗击杀、与受阻水流相连的蛇形对手。 / Serpentine opponent killed by Indra in Rigveda 1.32, linked there to obstructed waters.','PARTIAL','UNVERIFIED',1,'{"variant_name":"ahi; serpent designation in witness"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('event.vedic.indra_vritra_rv132','Indra and Vrtra in Rigveda 1.32','因陀罗与弗栗多之战（《梨俱吠陀》1.32）',NULL,NULL,'EVENT','civ.vedic','region.south_asia','Rigveda Mandala 1, Sukta 32','严格限定于《梨俱吠陀》1.32 的神话叙事事件层。 / Witness-specific event layer for Rigveda 1.32.','PARTIAL','UNVERIFIED',1,'{"witness":"RV 1.32","reality_status":"MYTHIC_NARRATIVE"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.japanese.raijin','Raijin','雷神','雷神','Raijin','DEITY','civ.japanese_shinto','region.east_asia','Diachronic Japanese tradition','“雷神”作为跨时期的雷神称谓／复合入口；地方雷神与古典八雷分别保存。 / Umbrella entry for Japanese thunder-kami traditions; regional deities and the Kojiki eight thunder kami remain distinct.','PARTIAL','UNVERIFIED',1,'{"entity_model":"umbrella deity complex; not a single fixed genealogy"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.japanese.takemikazuchi','Takemikazuchi','建御雷','建御雷之男神','Takemikazuchi-no-o-no-kami','DEITY','civ.japanese_shinto','region.east_asia','Kojiki and Nihon Shoki textual layers','古典叙事主要登记为武神／天神使者；雷电关联为次级且不与“雷神”自动合并。 / Primarily a martial heavenly envoy in registered classical narratives; thunder association remains secondary and does not merge the deity with Raijin.','PARTIAL','UNVERIFIED',1,'{"classification_caution":"martial envoy primary; thunder association secondary"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('group.japanese.eight_thunder_kami','Eight Thunder Kami of the Kojiki','《古事记》八雷神','八雷神','Yakuza no Ikazuchi-gami','CONCEPT','civ.japanese_shinto','region.east_asia','Kojiki Yomi episode','伊邪那美身上的八位雷神群组；不自动等同于后世单一雷神人格。 / Group entity for the eight thunder kami on Izanami in the Kojiki Yomi episode.','PARTIAL','UNVERIFIED',1,'{"group_type":"textual deity group"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.japanese.ooikazuchi','Ooikazuchi','大雷','大雷','Ooikazuchi','DEITY','civ.japanese_shinto','region.east_asia','Kojiki Yomi episode','《古事记》黄泉段八雷神之一。 / One of the eight thunder kami in the Kojiki Yomi episode.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.japanese.honoikazuchi','Honoikazuchi','火雷','火雷','Honoikazuchi','DEITY','civ.japanese_shinto','region.east_asia','Kojiki Yomi episode','《古事记》黄泉段八雷神之一。 / One of the eight thunder kami in the Kojiki Yomi episode.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.japanese.kuroikazuchi','Kuroikazuchi','黑雷','黒雷','Kuroikazuchi','DEITY','civ.japanese_shinto','region.east_asia','Kojiki Yomi episode','《古事记》黄泉段八雷神之一。 / One of the eight thunder kami in the Kojiki Yomi episode.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.japanese.sakuikazuchi','Sakuikazuchi','析雷','析雷','Sakuikazuchi','DEITY','civ.japanese_shinto','region.east_asia','Kojiki Yomi episode','《古事记》黄泉段八雷神之一。 / One of the eight thunder kami in the Kojiki Yomi episode.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.japanese.wakaikazuchi','Wakaikazuchi','若雷','若雷','Wakaikazuchi','DEITY','civ.japanese_shinto','region.east_asia','Kojiki Yomi episode','《古事记》黄泉段八雷神之一；具体形态和性格仍不确定。 / One of the eight thunder kami in the Kojiki Yomi episode; detailed form and character remain uncertain.','PARTIAL','UNVERIFIED',1,'{"uncertainty":"detailed character unknown"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.japanese.tsuchiikazuchi','Tsuchiikazuchi','土雷','土雷','Tsuchiikazuchi','DEITY','civ.japanese_shinto','region.east_asia','Kojiki Yomi episode','《古事记》黄泉段八雷神之一。 / One of the eight thunder kami in the Kojiki Yomi episode.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.japanese.naruikazuchi','Naruikazuchi','鸣雷','鳴雷','Naruikazuchi','DEITY','civ.japanese_shinto','region.east_asia','Kojiki Yomi episode','《古事记》黄泉段八雷神之一；与后世同名神社传统的关系未知。 / One of the Kojiki eight thunder kami; identity with later similarly named shrine traditions is unknown.','PARTIAL','UNVERIFIED',1,'{"identity_caution":"later shrine identity unknown"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.japanese.fusuikazuchi','Fusuikazuchi','伏雷','伏雷','Fusuikazuchi','DEITY','civ.japanese_shinto','region.east_asia','Kojiki Yomi episode','《古事记》黄泉段八雷神之一。 / One of the eight thunder kami in the Kojiki Yomi episode.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.chinese.leigong','Leigong','雷公','雷公','Leigong','DEITY','civ.chinese_folk','region.east_asia','Classical through later Chinese textual and visual layers','跨时期雷神人格入口；先秦诗歌、汉代批判记录、敦煌图像与后世信仰分层登记。 / Diachronic thunder-deity entry with classical poetic, Han critical, Dunhuang visual and later layers kept separate.','PARTIAL','UNVERIFIED',1,'{"diachronic_caution":"do not flatten textual and later cult layers"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.chinese.leize_thunder_spirit','Thunder Spirit of Leize','雷泽雷神','雷神','Leishen','DEITY','civ.chinese_ancient','region.east_asia','Classic of Mountains and Seas textual layer','《山海经·海内东经》的雷泽无名雷神；与后世雷公不自动合并。 / Unnamed thunder spirit of Leize in the Classic of Mountains and Seas; not automatically merged with later Leigong.','PARTIAL','UNVERIFIED',1,'{"identity_caution":"distinct textual entity pending diachronic study"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('text.chinese.lunheng','Lunheng','论衡','論衡','Lunheng','TEXT','civ.chinese_ancient','region.east_asia','Eastern Han transmitted text','王充著作；本批聚焦《雷虚》记录并批判的雷公图像解释。 / Wang Chong’s transmitted work; this checkpoint focuses on Lei Xu recording and criticizing thunder-god imagery.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('site.chinese.mogao_cave_285','Mogao Cave 285','莫高窟第285窟','莫高窟第285窟','Mogao Cave 285','ARCHAEOLOGICAL_SITE','civ.chinese_ancient','region.east_asia','Western Wei, dated 538-539 CE','有明确纪年的真实石窟遗址；雷神图像为图像学识别层，不是神话事件发生地。 / A real, dated cave site; thunder-deity imagery is an iconographic identification, not the location of a mythic event.','PARTIAL','UNVERIFIED',1,'{"reality_status":"REAL_ARCHAEOLOGICAL"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('artifact.yoruba.ose_sango','Ose Sango','尚戈双斧祭仪杖','Oṣé Ṣàngó','Ose Sango','SACRED_OBJECT','civ.yoruba','region.west_africa','Living Yoruba tradition and museum witnesses','带双斧形顶饰的祭仪／舞杖与信众标志；不是古代实战斧。 / Double-axe-topped devotional or dance staff and devotee emblem, not an ancient battlefield axe.','PARTIAL','UNVERIFIED',1,'{"access_caution":"public object metadata only"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('festival.yoruba.sango_oyo','Sango Festival, Oyo','奥约尚戈节','Sango Festival, Oyo',NULL,'FESTIVAL','civ.yoruba','region.west_africa','Living tradition, UNESCO inscription 2023','奥约社群每年举行的活态传统；公开层与仅限入门者内容严格分离。 / Annual Oyo living tradition with public and initiated-only knowledge boundaries kept separate.','PARTIAL','UNVERIFIED',1,'{"community_permission_required":true,"restricted_knowledge":"metadata only"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('site.yoruba.koso_temple','Koso Temple','科索神庙','Koso Temple',NULL,'TEMPLE','civ.yoruba','region.west_africa','Living sacred site','UNESCO 公共档案所联系的奥约尚戈节神圣地点；不登记受限内部空间。 / Sacred site associated with the public UNESCO Sango Festival dossier; restricted interiors are not recorded.','PARTIAL','UNVERIFIED',1,'{"location_precision":"public-level only","restricted_interiors":true}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('concept.ugaritic.baal_title','Ugaritic b-l title lexeme','乌加里特 bʿl“主／领主”头衔','𐎁𐎓𐎍','b-l / Ba-lu','CONCEPT','civ.ugaritic','region.west_asia','Late Bronze Age Ugaritic textual layer','用于记录“Baal”亦可作为“主／领主”头衔；不将所有巴力名称自动合并。 / Lexical record for Baal as a lord/master title; prevents automatic merging of every Baal-named figure.','PARTIAL','UNVERIFIED',1,'{"dedup_rule":"title is not a universal personal identity"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.ugaritic.kothar_wa_khasis','Kothar-wa-Khasis','科塔尔-瓦-哈西斯','Kôṯaru-wa-Ḫasīsu','Kothar-wa-Khasis','DEITY','civ.ugaritic','region.west_asia','Baal Cycle textual layer','KTU 1.2 IV 中为巴力制作两件有名武器的工艺神。 / Craft deity who makes two named weapons for Baal in KTU 1.2 IV.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('weapon.ugaritic.yagrush','Yagrush','亚格鲁什','ygrš','Yagrush','WEAPON','civ.ugaritic','region.west_asia','Baal Cycle KTU 1.2 IV','科塔尔为巴力制作的第一件有名武器；外形译法不一。 / First named weapon made for Baal by Kothar; translated object form varies.','PARTIAL','UNVERIFIED',1,'{"form_variants":["club","mace","axe"],"do_not_force_shape":true}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('weapon.ugaritic.ayyamur','Ayyamur','阿亚穆尔','aymr','Ayyamur','WEAPON','civ.ugaritic','region.west_asia','Baal Cycle KTU 1.2 IV','科塔尔为巴力制作的第二件有名武器；外形译法不一。 / Second named weapon made for Baal by Kothar; translated object form varies.','PARTIAL','UNVERIFIED',1,'{"form_variants":["club","mace","axe"],"do_not_force_shape":true}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('event.ugaritic.baal_yamm_ktu12','Baal and Yamm in KTU 1.2 IV','巴力与雅姆之战（KTU 1.2 IV）',NULL,NULL,'EVENT','civ.ugaritic','region.west_asia','Late Bronze Age Ugaritic textual witness','限定于 KTU 1.2 IV 的神话战斗层。 / Witness-specific mythic combat layer for KTU 1.2 IV.','PARTIAL','UNVERIFIED',1,'{"witness":"KTU 1.2 IV","reality_status":"MYTHIC_NARRATIVE"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z');

INSERT OR IGNORE INTO entities(
  id,canonical_name,name_zh,original_name,transliteration,primary_type,
  primary_civilization_id,primary_region_id,historical_period,description,
  research_status,evidence_status,record_version,metadata_json,created_at,updated_at
) VALUES
('text.slavic.primary_chronicle','Tale of Bygone Years','往年纪事','Повѣсть временныхъ лѣтъ','Povest vremennykh let','TEXT','civ.slavic','region.eastern_europe','Compiled textual tradition with medieval manuscript witnesses','东斯拉夫编年史传统；本批按 907、945、971、980 与 988 年条分别登记佩伦证据。 / East Slavic chronicle tradition; Perun evidence is registered by individual annal entries.','PARTIAL','UNVERIFIED',1,'{"manuscript_caution":"composition and surviving witness dates differ"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z');

INSERT OR IGNORE INTO entity_classifications(entity_id,type_code,is_primary,notes)
SELECT id,primary_type,1,'v0.6.0 thunder and storm comparison checkpoint'
FROM entities WHERE created_at='2026-08-14T00:00:00Z'
  AND id IN (
    'deity.norse.jord','deity.norse.sif','deity.norse.magni','deity.norse.modi','deity.norse.thrud','deity.norse.meili','being.norse.jarnsaxa','deity.norse.ullr',
    'modern.marvel.mcu.thor','modern.marvel.mcu.loki','modern.marvel.mcu.hela','deity.vedic.tvastr','creature.vedic.vritra','event.vedic.indra_vritra_rv132',
    'deity.japanese.raijin','deity.japanese.takemikazuchi','group.japanese.eight_thunder_kami','deity.japanese.ooikazuchi','deity.japanese.honoikazuchi','deity.japanese.kuroikazuchi','deity.japanese.sakuikazuchi','deity.japanese.wakaikazuchi','deity.japanese.tsuchiikazuchi','deity.japanese.naruikazuchi','deity.japanese.fusuikazuchi',
    'deity.chinese.leigong','deity.chinese.leize_thunder_spirit','text.chinese.lunheng','site.chinese.mogao_cave_285','artifact.yoruba.ose_sango','festival.yoruba.sango_oyo','site.yoruba.koso_temple',
    'concept.ugaritic.baal_title','deity.ugaritic.kothar_wa_khasis','weapon.ugaritic.yagrush','weapon.ugaritic.ayyamur','event.ugaritic.baal_yamm_ktu12','text.slavic.primary_chronicle'
  );

INSERT OR IGNORE INTO entity_civilizations(entity_id,civilization_id,association_role,certainty,notes)
SELECT id,primary_civilization_id,'ORIGIN','SUPPORTED','v0.6.0 witness-scoped baseline'
FROM entities WHERE primary_civilization_id IS NOT NULL AND created_at='2026-08-14T00:00:00Z'
  AND id IN (
    'deity.norse.jord','deity.norse.sif','deity.norse.magni','deity.norse.modi','deity.norse.thrud','deity.norse.meili','being.norse.jarnsaxa','deity.norse.ullr',
    'deity.vedic.tvastr','creature.vedic.vritra','event.vedic.indra_vritra_rv132','deity.japanese.raijin','deity.japanese.takemikazuchi','group.japanese.eight_thunder_kami',
    'deity.japanese.ooikazuchi','deity.japanese.honoikazuchi','deity.japanese.kuroikazuchi','deity.japanese.sakuikazuchi','deity.japanese.wakaikazuchi','deity.japanese.tsuchiikazuchi','deity.japanese.naruikazuchi','deity.japanese.fusuikazuchi',
    'deity.chinese.leigong','deity.chinese.leize_thunder_spirit','text.chinese.lunheng','site.chinese.mogao_cave_285','artifact.yoruba.ose_sango','festival.yoruba.sango_oyo','site.yoruba.koso_temple',
    'concept.ugaritic.baal_title','deity.ugaritic.kothar_wa_khasis','weapon.ugaritic.yagrush','weapon.ugaritic.ayyamur','event.ugaritic.baal_yamm_ktu12','text.slavic.primary_chronicle'
  );

INSERT OR IGNORE INTO names(
  id,entity_id,name_text,normalized_text,language_id,script_name,name_type,
  transliteration_scheme,is_preferred,source_id,notes
) VALUES
('name.v060.thor.non','deity.norse.thor','Þórr','thorr','lang.non','Latin','ORIGINAL',NULL,1,'source.norse.skaldskaparmal.vsnr1998','Normalized Old Norse form'),
('name.v060.thrud.non','deity.norse.thrud','Þrúðr','thrudr','lang.non','Latin','ORIGINAL',NULL,1,'source.norse.skaldskaparmal.vsnr1998','Daughter of Thor in this witness layer'),
('name.v060.jord.non','deity.norse.jord','Jǫrð','jord','lang.non','Latin','ORIGINAL',NULL,1,'source.norse.skaldskaparmal.vsnr1998',NULL),
('name.v060.indra.san','deity.vedic.indra','इन्द्र','indra','lang.san','Devanagari','ORIGINAL','IAST',1,'source.vedic.rigveda.1_32.vhp',NULL),
('name.v060.vrtra.san','creature.vedic.vritra','वृत्र','vrtra','lang.san','Devanagari','ORIGINAL','IAST',1,'source.vedic.rigveda.1_32.vhp',NULL),
('name.v060.vrtra.ahi','creature.vedic.vritra','अहि','ahi','lang.san','Devanagari','TEXTUAL_DESIGNATION','IAST',0,'source.vedic.rigveda.1_32.vhp','Serpent designation in RV 1.32; retained as a witness-level name, not a global synonym'),
('name.v060.raijin.jpn','deity.japanese.raijin','雷神','雷神','lang.jpn','Kanji','ORIGINAL',NULL,1,'source.japanese.raijin.kokugakuin','Umbrella designation'),
('name.v060.takemikazuchi.kojiki','deity.japanese.takemikazuchi','建御雷之男神','建御雷之男神','lang.ojp','Kanji','ORIGINAL',NULL,1,'source.japanese.takemikazuchi_names.kokugakuin','Kojiki form'),
('name.v060.takemikazuchi.takefutsu','deity.japanese.takemikazuchi','建布都神','建布都神','lang.ojp','Kanji','TEXTUAL_VARIANT',NULL,0,'source.japanese.takemikazuchi_names.kokugakuin','Kojiki textual name; do not turn etymological proposals into settled fact'),
('name.v060.takemikazuchi.toyofutsu','deity.japanese.takemikazuchi','豊布都神','豊布都神','lang.ojp','Kanji','TEXTUAL_VARIANT',NULL,0,'source.japanese.takemikazuchi_names.kokugakuin','Kojiki textual name; do not turn etymological proposals into settled fact'),
('name.v060.leigong.lzh','deity.chinese.leigong','雷公','雷公','lang.lzh','Han','ORIGINAL',NULL,1,'source.chinese.lunheng_leixu.ctext',NULL),
('name.v060.perun.historical','deity.slavic.perun','Перунъ','перунъ',NULL,'Cyrillic','HISTORICAL_FORM',NULL,1,'source.slavic.pvl.obdurodon','Chronicle-layer form; normalized display remains Perun'),
('name.v060.sango.yrb','deity.yoruba.shango','Ṣàngó','ṣàngó','lang.yrb','Latin','ORIGINAL',NULL,1,'source.yoruba.sango_festival.unesco','Yoruba orthography'),
('name.v060.sango.sango','deity.yoruba.shango','Sango','sango','lang.en','Latin','TRANSLITERATION',NULL,0,'source.yoruba.sango_festival.unesco','Diacritic-free form'),
('name.v060.sango.shango','deity.yoruba.shango','Shango','shango','lang.en','Latin','ENGLISH_VARIANT',NULL,0,'source.yoruba.sango_festival.unesco','Common English spelling'),
('name.v060.baal.ugaritic','deity.ugaritic.baal','𐎁𐎓𐎍','b-l','lang.uga','Ugaritic cuneiform','ORIGINAL',NULL,1,'source.ugaritic.hadad.bm','Consonantal Ugaritic spelling b-l'),
('name.v060.baal.baalu','deity.ugaritic.baal','Baʿlu','baʿlu','lang.uga','Latin','TRANSLITERATION',NULL,0,'source.ugaritic.hadad.bm','Title/name form in Ugaritic context'),
('name.v060.baal.haddu','deity.ugaritic.baal','Haddu','haddu','lang.uga','Latin','TEXTUAL_NAME',NULL,0,'source.ugaritic.hadad.bm','Ugaritic storm-deity name; does not merge every regional Hadad or Baal figure'),
('name.v060.baal.lexeme','concept.ugaritic.baal_title','bʿl','bʿl','lang.uga','Latin','LEXEME',NULL,1,'source.ugaritic.hadad.bm','Lord/master title lexeme'),
('name.v060.ose_sango.yrb','artifact.yoruba.ose_sango','Oṣé Ṣàngó','oṣé ṣàngó','lang.yrb','Latin','ORIGINAL',NULL,1,'source.yoruba.ose_sango.met.1983_603_5','Sacred staff designation');

-- Every entity receives an editorial canonical display name even when the
-- source-specific original/variant name work remains incomplete.  These rows
-- do not claim an ancient-language attestation; they only make the record
-- addressable and keep later source-backed name additions non-destructive.
INSERT OR IGNORE INTO names(
  id,entity_id,name_text,normalized_text,language_id,script_name,name_type,
  transliteration_scheme,is_preferred,source_id,notes
)
SELECT
  'name.v060.canonical.' || replace(id,'.','_'),id,canonical_name,lower(canonical_name),
  NULL,'Latin','EDITORIAL_CANONICAL',NULL,1,NULL,
  'Editorial canonical display label; not asserted as an original-language attestation.'
FROM entities
WHERE id IN (
  'deity.norse.jord','deity.norse.sif','deity.norse.magni','deity.norse.modi','deity.norse.thrud','deity.norse.meili','being.norse.jarnsaxa','deity.norse.ullr',
  'modern.marvel.mcu.thor','modern.marvel.mcu.loki','modern.marvel.mcu.hela','deity.vedic.tvastr','creature.vedic.vritra','event.vedic.indra_vritra_rv132',
  'deity.japanese.raijin','deity.japanese.takemikazuchi','group.japanese.eight_thunder_kami','deity.japanese.ooikazuchi','deity.japanese.honoikazuchi','deity.japanese.kuroikazuchi','deity.japanese.sakuikazuchi','deity.japanese.wakaikazuchi','deity.japanese.tsuchiikazuchi','deity.japanese.naruikazuchi','deity.japanese.fusuikazuchi',
  'deity.chinese.leigong','deity.chinese.leize_thunder_spirit','text.chinese.lunheng','site.chinese.mogao_cave_285','artifact.yoruba.ose_sango','festival.yoruba.sango_oyo','site.yoruba.koso_temple',
  'concept.ugaritic.baal_title','deity.ugaritic.kothar_wa_khasis','weapon.ugaritic.yagrush','weapon.ugaritic.ayyamur','event.ugaritic.baal_yamm_ktu12','text.slavic.primary_chronicle'
);

UPDATE entities SET
  description='索尔／Þórr：古诺斯文本中的锤持有者、巨人对手与家谱节点；本版补齐父母、配偶、子女、梅利与洛基文本关系。洛基并非古诺斯层兄弟。 / Thor in registered Old Norse witnesses, now linked to source-specific parents, spouse, children, Meili and Loki episodes; Loki is not his Old Norse brother.',
  historical_period='Old Norse poetic and medieval prose witnesses',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z'
WHERE id='deity.norse.thor';
UPDATE entities SET
  description='古诺斯文本中的洛基；与索尔在多则叙事中互动，但兄弟关系只登记在现代改编层。古诺斯赫尔为洛基与安格尔波达之女。 / Loki in Old Norse witnesses, interacting with Thor without an ancient sibling claim; Hel is Loki and Angrboda’s daughter in Snorri’s witness.',
  historical_period='Old Norse poetic and medieval prose witnesses',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z'
WHERE id='deity.norse.loki';
UPDATE entities SET
  description='《梨俱吠陀》中的因陀罗：金刚杵持有者，并在 1.32 与 2.12 的具体见证中与蛇敌、受阻水流、大气和战斗相连。 / Indra in registered Rigvedic witnesses, wielder of the vajra and linked to serpent combat, released waters, atmosphere and battle.',
  original_name='इन्द्र',transliteration='Indra',historical_period='Rigvedic textual tradition',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z'
WHERE id='deity.vedic.indra';
UPDATE entities SET
  description='《往年纪事》所见东斯拉夫佩伦：条约誓言、980 年基辅神像与 988 年毁像分别登记；“全斯拉夫唯一主神”与命名神器不作无证断言。 / Perun in East Slavic chronicle witnesses: treaty oaths, the 980 Kyiv idol and its 988 removal are separate claims; no unsupported universal pantheon or named weapon is asserted.',
  original_name='Перунъ',transliteration='Perun',historical_period='East Slavic chronicle and later scholarly layers',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z'
WHERE id='deity.slavic.perun';
UPDATE entities SET
  description='奥约约鲁巴活态传统中的 Ṣàngó：雷、闪电、正义、王权与祖先记忆公共层；受限知识只登记访问边界，不收集秘密内容。 / Sango in the living Oyo Yoruba tradition, with public thunder, justice, kingship and ancestor-memory layers; restricted knowledge is represented only by access metadata.',
  original_name='Ṣàngó',transliteration='Sango',historical_period='Living Yoruba tradition with historical layers',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z'
WHERE id='deity.yoruba.shango';
UPDATE entities SET
  description='乌加里特 Baʿlu／Haddu：风暴、降雨、战士、土地与王权层按 KTU 泥板和图像证据登记。“Baal”亦为头衔，绝不自动合并所有同名神。 / Ugaritic Baʿlu/Haddu in tablet and iconographic witnesses; Baal is also a title, so other Baal-named figures remain separate.',
  original_name='𐎁𐎓𐎍',transliteration='Baʿlu / Haddu',historical_period='Late Bronze Age Ugaritic textual and material witnesses',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z'
WHERE id='deity.ugaritic.baal';

INSERT OR REPLACE INTO deity_profiles(
  entity_id,deity_class,pantheon_or_family,rank_or_status,domains_json,powers_json,
  limitations_json,appearance_json,symbols_json,cult_summary,final_fate_summary
) VALUES
('deity.norse.thor','Norse deity','Aesir / witness-specific Odin genealogy','Hammer-bearing protector and giant-opponent','["雷鸣／风暴关联","保护","与巨人战斗","力量"]','["使用妙尔尼尔；能力仅按具体文本登记"]','["洛基不是古诺斯层兄弟","不同文本家谱不可自动推成唯一神谱"]','{"witness":"Medieval Norse texts and later material culture"}','["Mjolnir","goats and chariot in relevant witnesses"]','Textual and material-culture layers remain separate.','Ragnarok fate remains witness-specific and outside this family-focused batch.'),
('deity.vedic.indra','Vedic deity','Rigvedic','Prominent atmospheric and martial deity in registered hymns','["风暴与大气","雷电","战争","放水"]','["持金刚杵","击杀弗栗多","使受阻水流流出"]','["不得把后世帝释天层直接覆盖吠陀层","颂歌见证不代表单一永久神学"]','{"witness":"Rigveda 1.32 and 2.12"}','["Vajra"]','Only text-level Vedic claims are registered here; later ritual and Buddhist reception remain separate.',NULL),
('deity.japanese.raijin','Japanese thunder-kami umbrella','Multiple regional and diachronic traditions','Umbrella / deity-complex entry','["雷","降雨关联"]','[]','["不是一位拥有固定古典家谱的全球单一人格","地方雷神与八雷神不自动合并"]','{"later_iconography":"linked drums in the Sotatsu screen witness"}','["连鼓（后世图像层）"]','Regional and living traditions require separate local dossiers.',NULL),
('deity.japanese.takemikazuchi','Japanese deity','Kojiki and Nihon Shoki variants','Martial deity and heavenly envoy; thunder secondary','["武力","国让使者","雷电次级关联"]','[]','["不与雷神 Raijin 自动等同","古事记与日本书纪同行者版本并存"]','{"witness":"classical text summaries; no universal fixed iconography asserted"}','[]','Kashima and Kasuga layers remain queued for source-by-source expansion.',NULL),
('deity.chinese.leigong','Chinese thunder deity','Diachronic Chinese traditions','Thunder-personification entry','["雷","闪电","护卫与惩戒的后世层"]','[]','["《论衡》记录并反驳图像信念，不可写成王充确认神话事实","雷泽雷神保持独立"]','{"Han_recorded_image":"strong figure with linked drums and mallet","Western_Wei_image":"Cave 285 iconographic identification"}','["连鼓","椎／槌（图像层）"]','Classical, medieval, visual and living cult layers remain dated separately.',NULL),
('deity.slavic.perun','East Slavic deity','Kyivan Rus and East Slavic chronicle layer','Oath and state-cult deity in registered annals','["雷与闪电（学术语境）","战争／誓言","天空与雨的比较层"]','[]','["没有可靠中世纪来源证明一件有专名的斧或锤","佩伦—维列斯宇宙战是后世重建，不能覆盖条约见证"]','{"980_annal":"wooden idol with silver head and golden moustache"}','[]','Chronicle oath and idol layers are registered separately.',NULL),
('deity.yoruba.shango','Yoruba orisa','Oyo Yoruba living tradition','Thunder, justice, kingship and ancestor-memory figure','["雷","闪电","正义","王权","祖先记忆"]','[]','["仅公开层可进入本库","入门者空间与秘密知识不采集"]','{"public_object_layer":"double-axe-topped Ose Sango staff"}','["Ose Sango","red and red-white public festival symbolism"]','Annual Oyo festival and Koso public association; community authority and access restrictions are preserved.',NULL),
('deity.ugaritic.baal','Ugaritic deity','Ugaritic pantheon','Storm warrior and royal figure in Baal Cycle witnesses','["风暴","降雨","土地丰饶","王权","战斗"]','["使用 Yagrush 与 Ayyamur 对抗 Yamm"]','["Baal 亦是头衔，不自动合并其他同名神","武器外形译法不一"]','{"material_witness":"AO 15775 thunderbolt stele"}','["thunderbolt iconography","Yagrush","Ayyamur"]','Late Bronze Age Ugaritic textual and material layers only.',NULL);

-- Minimal typed profiles are required for every entity carrying a DEITY
-- classification.  Sparse records deliberately keep unknown fields empty;
-- they are not padded with inferred genealogy or iconography.
INSERT OR IGNORE INTO deity_profiles(
  entity_id,deity_class,pantheon_or_family,rank_or_status,domains_json,powers_json,
  limitations_json,appearance_json,symbols_json,cult_summary,final_fate_summary
)
SELECT
  id,
  CASE
    WHEN id LIKE 'deity.japanese.%ikazuchi' THEN 'Kojiki thunder-kami member'
    WHEN id='deity.chinese.leize_thunder_spirit' THEN 'Text-specific thunder spirit'
    WHEN id='deity.ugaritic.kothar_wa_khasis' THEN 'Ugaritic craft deity'
    WHEN id='deity.vedic.tvastr' THEN 'Vedic maker deity'
    ELSE 'Norse deity'
  END,
  CASE
    WHEN id LIKE 'deity.japanese.%ikazuchi' THEN 'Eight Thunder Kami of the Kojiki'
    WHEN id='deity.chinese.leize_thunder_spirit' THEN 'Classic of Mountains and Seas textual layer'
    WHEN id='deity.ugaritic.kothar_wa_khasis' THEN 'Ugaritic pantheon'
    WHEN id='deity.vedic.tvastr' THEN 'Rigvedic textual layer'
    ELSE 'Norse witness-specific genealogy'
  END,
  NULL,
  CASE
    WHEN id LIKE 'deity.japanese.%ikazuchi' THEN '["雷（《古事记》黄泉段群组成员）"]'
    WHEN id='deity.chinese.leize_thunder_spirit' THEN '["雷"]'
    WHEN id='deity.ugaritic.kothar_wa_khasis' THEN '["工艺","神圣制造"]'
    WHEN id='deity.vedic.tvastr' THEN '["制造","工艺"]'
    ELSE '[]'
  END,
  '[]',
  CASE
    WHEN id LIKE 'deity.japanese.%ikazuchi' THEN '["资料限定于《古事记》黄泉段；不与泛称 Raijin 自动合并"]'
    WHEN id='deity.chinese.leize_thunder_spirit' THEN '["不与后世雷公自动合并"]'
    ELSE '["未知字段保持为空；不由共同亲属自动补造关系"]'
  END,
  '{}','[]',NULL,NULL
FROM entities
WHERE id IN (
  'deity.norse.jord','deity.norse.sif','deity.norse.magni','deity.norse.modi','deity.norse.thrud','deity.norse.meili','deity.norse.ullr',
  'deity.japanese.ooikazuchi','deity.japanese.honoikazuchi','deity.japanese.kuroikazuchi','deity.japanese.sakuikazuchi','deity.japanese.wakaikazuchi','deity.japanese.tsuchiikazuchi','deity.japanese.naruikazuchi','deity.japanese.fusuikazuchi',
  'deity.chinese.leize_thunder_spirit','deity.ugaritic.kothar_wa_khasis','deity.vedic.tvastr'
);

INSERT OR REPLACE INTO artifact_profiles(
  entity_id,artifact_type,material_json,appearance_json,abilities_json,
  limitations_json,usage_conditions_json,creation_summary,fate_summary
) VALUES
('artifact.yoruba.ose_sango','SACRED_OBJECT','["木（博物馆见证）"]','{"public_museum_witness":"double-axe-topped staff"}','[]','["不可写成古代实战武器","不得推断受限仪式步骤"]','["活态传统权限与具体语境优先"]','由具体约鲁巴艺术家与传统语境制作；不同物件不是一件唯一神器。 / Made in specific Yoruba artistic and devotional contexts; not one globally unique artifact.',NULL),
('weapon.ugaritic.yagrush','NAMED_MYTHIC_WEAPON','[]','{"translation_variants":["club","mace","axe"]}','["KTU 1.2 IV 中击中雅姆肩背，但第一击未使其倒下"]','["外形不可从译名强制定型"]','["限定于 KTU 1.2 IV 见证"]','KTU 1.2 IV 称科塔尔-瓦-哈西斯为巴力制作。',NULL),
('weapon.ugaritic.ayyamur','NAMED_MYTHIC_WEAPON','[]','{"translation_variants":["club","mace","axe"]}','["KTU 1.2 IV 中击中雅姆头部并使其倒地"]','["外形不可从译名强制定型"]','["限定于 KTU 1.2 IV 见证"]','KTU 1.2 IV 称科塔尔-瓦-哈西斯为巴力制作。',NULL);

INSERT OR REPLACE INTO myth_event_profiles(entity_id,event_type,time_layer,cause_summary,process_summary,result_summary,symbolism_summary) VALUES
('event.vedic.indra_vritra_rv132','DIVINE_COMBAT','Rigveda 1.32 textual layer','颂歌中的弗栗多／蛇敌阻水语境。','因陀罗以金刚杵击杀对手，水流得以流出。','严格作为颂歌叙事结果保存。','不把跨文明“屠龙”相似性自动解释成共同来源。'),
('event.ugaritic.baal_yamm_ktu12','DIVINE_COMBAT','KTU 1.2 IV textual layer','乌加里特神话中的王权与冲突语境。','巴力依次使用 Yagrush 与 Ayyamur 对抗 Yamm。','第二件武器使 Yamm 倒地；后续层须按泥板版本继续扩张。','不以现代“混沌大战”标签覆盖原文与学术争议。');

INSERT OR REPLACE INTO text_profiles(entity_id,text_type,original_language_id,attributed_author,compiler,composition_period,earliest_extant_witness,chapter_structure,repository,shelfmark,copyright_status,summary) VALUES
('text.chinese.lunheng','PHILOSOPHICAL_TEXT','lang.lzh','Wang Chong',NULL,'Eastern Han','Transmitted editions','Thematic chapters including Lei Xu','Chinese Text Project','urn:ctext:lunheng/lei-xu','Traditional witness and site rights differ','Lei Xu records and argues against a thunder-god image explanation.'),
('text.slavic.primary_chronicle','CHRONICLE',NULL,NULL,'Traditionally associated with early Rus chronicle compilation','Early 12th-century compilation layers','Laurentian Codex 1377 among major witnesses','Annal entries','Obdurodon / National Library of Russia','PVL digital edition; Laurentian Codex','Edition and manuscript rights differ','Perun evidence is indexed by the 907, 945, 971, 980 and 988 annal entries.');

INSERT OR REPLACE INTO place_profiles(entity_id,place_type,ancient_name,modern_name,country_code,latitude,longitude,date_range,builders,architecture_summary,excavation_summary,major_finds_summary,unesco_status,reality_status,evidence_grade) VALUES
('site.chinese.mogao_cave_285','CAVE_TEMPLE','莫高窟第285窟','Mogao Cave 285','CN',NULL,NULL,'Western Wei; dated inscriptions 538-539 CE',NULL,'Rock-cut Buddhist cave with a painted ceiling program.','Official Dunhuang Academy site record; excavation history remains queued.','Thunder-deity imagery is an iconographic identification within a wider ceiling program.','Part of Mogao Caves, World Heritage property 440','REAL_ARCHAEOLOGICAL','OFFICIAL_SITE'),
('site.yoruba.koso_temple','LIVING_TEMPLE',NULL,'Koso Temple','NG',NULL,NULL,'Living sacred site',NULL,'Only the public site-level association is registered; restricted interiors are intentionally omitted.',NULL,NULL,'Associated with the UNESCO-inscribed Sango Festival, Oyo','REAL_SACRED','COMMUNITY_BACKED_PUBLIC_SOURCE');

INSERT OR REPLACE INTO creature_profiles(
  entity_id,creature_class,appearance_json,abilities_json,weaknesses_json,
  habitat_summary,origin_summary,fate_summary
) VALUES
('being.norse.jarnsaxa','JOTUNN / witness-specific Norse being','{}','[]','[]',NULL,'Registered through the Skaldskaparmal genealogy witness as Magni’s mother.',NULL),
('creature.vedic.vritra','RIGVEDIC SERPENT OPPONENT','{"witness_designation":"ahi / serpent"}','["阻水语境（RV 1.32）"]','["在 RV 1.32 中被因陀罗以金刚杵击杀"]',NULL,'Witness-specific opponent in Rigveda 1.32.','Killed by Indra in the registered hymn narrative.');

INSERT OR IGNORE INTO relationship_types(code,inverse_code,label_en,label_zh,category,is_symmetric,description) VALUES
('STEP_PARENT_OF','STEP_CHILD_OF','step-parent of','继父母','KINSHIP',0,'Witness-specific social kinship; never normalized into biological parentage.'),
('STEP_CHILD_OF','STEP_PARENT_OF','step-child of','继子女','KINSHIP',0,'Inverse of STEP_PARENT_OF.'),
('CO_INVOKED_WITH','CO_INVOKED_WITH','co-invoked with','共同受誓言援引','RITUAL',1,'Two entities named together in a source; does not imply enmity, identity, or a reconstructed cosmic opposition.');

INSERT OR IGNORE INTO claims(
  id,subject_id,predicate,object_entity_id,object_literal,object_datatype,statement,
  variant_group,claim_status,confidence,confidence_level,review_status,
  assertion_scope,knowledge_layer,tradition_scope,temporal_scope,research_notes,created_at
) VALUES
('claim.v060.norse.thor_child_odin','deity.norse.thor','CHILD_OF','deity.norse.odin',NULL,NULL,'Skaldskaparmal names Thor as a son of Odin.','norse.thor.parentage.snorri','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Skaldskaparmal','Thor kennings section','Medieval witness; not a prehistoric birth record.','2026-08-14T00:00:00Z'),
('claim.v060.norse.thor_child_jord','deity.norse.thor','CHILD_OF','deity.norse.jord',NULL,NULL,'Skaldskaparmal names Thor as a son of Jord.','norse.thor.parentage.snorri','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Skaldskaparmal','Thor kennings section','Earth-personification interpretation remains source-scoped.','2026-08-14T00:00:00Z'),
('claim.v060.norse.thor_consort_sif','deity.norse.thor','CONSORT_OF','deity.norse.sif',NULL,NULL,'Skaldskaparmal calls Thor the husband of Sif.','norse.thor.household.snorri','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Skaldskaparmal','Thor kennings section',NULL,'2026-08-14T00:00:00Z'),
('claim.v060.norse.thor_parent_magni','deity.norse.thor','PARENT_OF','deity.norse.magni',NULL,NULL,'Skaldskaparmal names Magni as a child of Thor.','norse.thor.children.snorri','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Skaldskaparmal','Thor kennings section',NULL,'2026-08-14T00:00:00Z'),
('claim.v060.norse.thor_parent_modi','deity.norse.thor','PARENT_OF','deity.norse.modi',NULL,NULL,'Skaldskaparmal names Modi as a child of Thor.','norse.thor.children.snorri','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Skaldskaparmal','Thor kennings section','The registered witness does not name Modi’s mother.','2026-08-14T00:00:00Z'),
('claim.v060.norse.thor_parent_thrud','deity.norse.thor','PARENT_OF','deity.norse.thrud',NULL,NULL,'Skaldskaparmal names Thrud as a child of Thor.','norse.thor.children.snorri','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Skaldskaparmal','Thor kennings section','Thrud is a daughter, not Thor’s sister.','2026-08-14T00:00:00Z'),
('claim.v060.norse.jarnsaxa_parent_magni','being.norse.jarnsaxa','PARENT_OF','deity.norse.magni',NULL,NULL,'Skaldskaparmal identifies Jarnsaxa as Magni’s mother.','norse.magni.parentage.snorri','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Skaldskaparmal','Hrungnir episode',NULL,'2026-08-14T00:00:00Z'),
('claim.v060.norse.sif_parent_thrud','deity.norse.sif','PARENT_OF','deity.norse.thrud',NULL,NULL,'Skaldskaparmal identifies Thrud through Sif in its kinship terminology.','norse.thrud.parentage.snorri','SUPPORTED',0.96,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Skaldskaparmal','Kinship and kenning lists','Witness-scoped maternal relation.','2026-08-14T00:00:00Z'),
('claim.v060.norse.thor_sibling_meili','deity.norse.thor','SIBLING_OF','deity.norse.meili',NULL,NULL,'Old Norse poetic and Snorrian witness terminology calls Thor the brother of Meili.','norse.thor.siblings.attested','SUPPORTED',0.97,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Skaldskaparmal / skaldic witness','Thor kenning: brother of Meili','Meili’s wider dossier remains sparse.','2026-08-14T00:00:00Z'),
('claim.v060.norse.thor_step_parent_ullr','deity.norse.thor','STEP_PARENT_OF','deity.norse.ullr',NULL,NULL,'Skaldskaparmal calls Thor the stepfather of Ullr.','norse.ullr.household.snorri','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Skaldskaparmal','Thor kennings section','Stored separately from biological parentage.','2026-08-14T00:00:00Z'),
('claim.v060.norse.sif_parent_ullr','deity.norse.sif','PARENT_OF','deity.norse.ullr',NULL,NULL,'Skaldskaparmal names Ullr as Sif’s son.','norse.ullr.parentage.snorri','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Skaldskaparmal','Thor kennings section',NULL,'2026-08-14T00:00:00Z'),
('claim.v060.norse.thor_loki_thrymskvida','deity.norse.thor','ASSOCIATED_WITH','deity.norse.loki',NULL,NULL,'Thrymskvida places Thor and Loki together in the recovery of Mjolnir; the poem does not make them brothers.','norse.thor_loki.poetic_companions','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Thrymskvida','stanzas 1-32','Association records a shared episode, not kinship.','2026-08-14T00:00:00Z'),
('claim.v060.norse.thor_appears_thrymskvida','deity.norse.thor','APPEARS_IN','text.norse.thrymskvida',NULL,NULL,'Thor is the central hammer-seeking figure in Thrymskvida.','norse.thrymskvida.characters','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Thrymskvida','stanzas 1-32',NULL,'2026-08-14T00:00:00Z'),
('claim.v060.norse.loki_appears_thrymskvida','deity.norse.loki','APPEARS_IN','text.norse.thrymskvida',NULL,NULL,'Loki accompanies and advises Thor in Thrymskvida.','norse.thrymskvida.characters','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Thrymskvida','stanzas 1-32','No sibling relation is asserted.','2026-08-14T00:00:00Z'),
('claim.v060.norse.loki_parent_hel','deity.norse.loki','PARENT_OF','deity.norse.hel',NULL,NULL,'Gylfaginning names Hel as a child of Loki and Angrboda.','norse.hel.parentage.snorri','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Gylfaginning','chapter 34','This ancient Hel layer is distinct from MCU Hela’s half-sister role.','2026-08-14T00:00:00Z'),
('claim.v060.norse.thor_thunder_scope','deity.norse.thor','ASSOCIATED_WITH','concept.comparative.thunder',NULL,NULL,'The Swedish History Museum’s public contextual record identifies Thor as a thunder god while presenting hammer amulets as material culture.','comparison.thunder_storm_deities','SUPPORTED',0.91,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Norse textual and material-culture comparison','museum contextual page','The comparison label does not replace Thor’s broader witness-specific roles.','2026-08-14T00:00:00Z'),
('claim.v060.modern.thor_sibling_loki','modern.marvel.mcu.thor','SIBLING_OF','modern.marvel.mcu.loki',NULL,NULL,'Marvel’s official on-screen biography presents Loki as Thor’s adoptive brother in that screen continuity.','marvel.mcu.thor_kinship','SUPPORTED',0.99,'HIGH','VERIFIED','MODERN_RECEPTION','POPULAR_CULTURE','Marvel screen continuity','official on-screen biography','Modern adaptation only; no projection into Old Norse myth.','2026-08-14T00:00:00Z'),
('claim.v060.modern.thor_sibling_hela','modern.marvel.mcu.thor','SIBLING_OF','modern.marvel.mcu.hela',NULL,NULL,'Marvel’s official on-screen biography presents Hela as Thor’s half-sister in that screen continuity.','marvel.mcu.thor_kinship','SUPPORTED',0.99,'HIGH','VERIFIED','MODERN_RECEPTION','POPULAR_CULTURE','Marvel screen continuity','official on-screen biography','Modern adaptation only; Old Norse Hel is Loki’s daughter in the registered Snorri witness.','2026-08-14T00:00:00Z'),

('claim.v060.vedic.indra_thunder_scope','deity.vedic.indra','ASSOCIATED_WITH','concept.comparative.thunder',NULL,NULL,'Rigveda 1.32 places Indra’s combat amid lightning, thunder and rain imagery while preserving its own Vedic vocabulary and narrative.','comparison.thunder_storm_deities','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Rigveda','RV 1.32.13','The comparison set does not reduce Indra to a universal thunder-god template.','2026-08-14T00:00:00Z'),
('claim.v060.vedic.indra_uses_vajra','deity.vedic.indra','USES','weapon.vedic.vajra',NULL,NULL,'Rigveda 1.32 repeatedly presents Indra wielding the vajra against Vrtra.','rigveda.1.32.vajra','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Rigveda','RV 1.32.1-5',NULL,'2026-08-14T00:00:00Z'),
('claim.v060.vedic.tvastr_created_vajra','deity.vedic.tvastr','CREATOR_OF','weapon.vedic.vajra',NULL,NULL,'Rigveda 1.32.2 says Tvastr fashioned the vajra for Indra.','rigveda.1.32.vajra','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Rigveda','RV 1.32.2',NULL,'2026-08-14T00:00:00Z'),
('claim.v060.vedic.indra_killed_vrtra','deity.vedic.indra','KILLED','creature.vedic.vritra',NULL,NULL,'Rigveda 1.32 narrates Indra killing Vrtra, also designated as a serpent in the hymn.','rigveda.1.32.combat','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Rigveda','RV 1.32.1-15','Mythic narrative claim, not historical reality.','2026-08-14T00:00:00Z'),
('claim.v060.vedic.indra_participated_vrtra_event','deity.vedic.indra','PARTICIPATED_IN','event.vedic.indra_vritra_rv132',NULL,NULL,'Indra is the principal agent in the witness-specific RV 1.32 event record.','rigveda.1.32.event','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Rigveda','RV 1.32.1-15',NULL,'2026-08-14T00:00:00Z'),
('claim.v060.vedic.vrtra_participated_event','creature.vedic.vritra','PARTICIPATED_IN','event.vedic.indra_vritra_rv132',NULL,NULL,'Vrtra is Indra’s opponent in the witness-specific RV 1.32 event record.','rigveda.1.32.event','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Rigveda','RV 1.32.1-15',NULL,'2026-08-14T00:00:00Z'),
('claim.v060.vedic.event_appears_rigveda','event.vedic.indra_vritra_rv132','APPEARS_IN','text.vedic.rigveda',NULL,NULL,'The event record indexes the narrative of Rigveda Mandala 1, Sukta 32.','rigveda.1.32.event','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Rigveda','Mandala 1, Sukta 32','Modern event entity used as an index to an ancient witness.','2026-08-14T00:00:00Z'),
('claim.v060.vedic.vajra_appears_rigveda','weapon.vedic.vajra','APPEARS_IN','text.vedic.rigveda',NULL,NULL,'The vajra appears as Indra’s weapon in Rigveda 1.32.','rigveda.1.32.vajra','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Rigveda','RV 1.32.1-5','Later Buddhist ritual vajra reception remains separate.','2026-08-14T00:00:00Z'),

('claim.v060.japanese.raijin_thunder_scope','deity.japanese.raijin','ASSOCIATED_WITH','concept.comparative.thunder',NULL,NULL,'Kokugakuin’s Basic Terms of Shinto treats Raijin as a thunder-kami designation with multiple regional forms and rain associations.','comparison.thunder_storm_deities','SUPPORTED',0.96,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Japanese diachronic traditions','Basic Terms of Shinto ID 3892','Umbrella/deity-complex model, not a single fixed genealogy.','2026-08-14T00:00:00Z'),
('claim.v060.japanese.takemikazuchi_thunder_scope','deity.japanese.takemikazuchi','ASSOCIATED_WITH','concept.comparative.thunder',NULL,NULL,'Takemikazuchi’s name and reception support a secondary thunder association, while the registered classical actions are primarily martial and emissarial.','comparison.thunder_storm_deities','INTERPRETIVE',0.72,'MEDIUM','PROVISIONAL','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Kojiki and Nihon Shoki comparison','Kokugakuin entry ID 9145','Not identified with Raijin.','2026-08-14T00:00:00Z'),
('claim.v060.japanese.takemikazuchi_appears_kojiki','deity.japanese.takemikazuchi','APPEARS_IN','text.japanese.kojiki',NULL,NULL,'Kojiki traditions place Takemikazuchi in divine-generation, land-transfer and imperial-expedition narrative layers.','japanese.takemikazuchi.kojiki_layers','SUPPORTED',0.97,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Kojiki','Upper and Middle Scroll locations indexed by Kokugakuin','Different episode and manuscript/edition layers remain separately locatable.','2026-08-14T00:00:00Z'),
('claim.v060.japanese.eight_thunder_appears_kojiki','group.japanese.eight_thunder_kami','APPEARS_IN','text.japanese.kojiki',NULL,NULL,'The Kojiki Yomi episode presents eight separately named thunder kami on Izanami.','japanese.kojiki.eight_thunder','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Kojiki','Upper Scroll, Yomi episode','The group is not automatically a later single Raijin personality.','2026-08-14T00:00:00Z'),
('claim.v060.japanese.ooikazuchi_member','deity.japanese.ooikazuchi','MEMBER_OF','group.japanese.eight_thunder_kami',NULL,NULL,'Ooikazuchi is indexed as one of the Kojiki eight thunder kami.','japanese.kojiki.eight_thunder','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Kojiki','Upper Scroll, Yomi episode',NULL,'2026-08-14T00:00:00Z'),
('claim.v060.japanese.honoikazuchi_member','deity.japanese.honoikazuchi','MEMBER_OF','group.japanese.eight_thunder_kami',NULL,NULL,'Honoikazuchi is indexed as one of the Kojiki eight thunder kami.','japanese.kojiki.eight_thunder','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Kojiki','Upper Scroll, Yomi episode',NULL,'2026-08-14T00:00:00Z'),
('claim.v060.japanese.kuroikazuchi_member','deity.japanese.kuroikazuchi','MEMBER_OF','group.japanese.eight_thunder_kami',NULL,NULL,'Kuroikazuchi is indexed as one of the Kojiki eight thunder kami.','japanese.kojiki.eight_thunder','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Kojiki','Upper Scroll, Yomi episode',NULL,'2026-08-14T00:00:00Z'),
('claim.v060.japanese.sakuikazuchi_member','deity.japanese.sakuikazuchi','MEMBER_OF','group.japanese.eight_thunder_kami',NULL,NULL,'Sakuikazuchi is indexed as one of the Kojiki eight thunder kami.','japanese.kojiki.eight_thunder','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Kojiki','Upper Scroll, Yomi episode',NULL,'2026-08-14T00:00:00Z'),
('claim.v060.japanese.wakaikazuchi_member','deity.japanese.wakaikazuchi','MEMBER_OF','group.japanese.eight_thunder_kami',NULL,NULL,'Wakaikazuchi is one of the Kojiki eight thunder kami; the scholarly entry leaves detailed character uncertain.','japanese.kojiki.eight_thunder','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Kojiki','Upper Scroll, Yomi episode','Uncertainty about form and character is preserved.','2026-08-14T00:00:00Z'),
('claim.v060.japanese.tsuchiikazuchi_member','deity.japanese.tsuchiikazuchi','MEMBER_OF','group.japanese.eight_thunder_kami',NULL,NULL,'Tsuchiikazuchi is indexed as one of the Kojiki eight thunder kami.','japanese.kojiki.eight_thunder','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Kojiki','Upper Scroll, Yomi episode',NULL,'2026-08-14T00:00:00Z'),
('claim.v060.japanese.naruikazuchi_member','deity.japanese.naruikazuchi','MEMBER_OF','group.japanese.eight_thunder_kami',NULL,NULL,'Naruikazuchi is one of the Kojiki eight thunder kami; identity with a later similarly named shrine tradition is uncertain.','japanese.kojiki.eight_thunder','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Kojiki','Upper Scroll, Yomi episode','Do not auto-merge the later shrine tradition.','2026-08-14T00:00:00Z'),
('claim.v060.japanese.fusuikazuchi_member','deity.japanese.fusuikazuchi','MEMBER_OF','group.japanese.eight_thunder_kami',NULL,NULL,'Fusuikazuchi is indexed as one of the Kojiki eight thunder kami.','japanese.kojiki.eight_thunder','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Kojiki','Upper Scroll, Yomi episode',NULL,'2026-08-14T00:00:00Z'),

('claim.v060.chinese.leigong_thunder_scope','deity.chinese.leigong','ASSOCIATED_WITH','concept.comparative.thunder',NULL,NULL,'Yuan You and Lei Xu provide early textual layers for a figure called Leigong in thunder-related imagery and escort language.','comparison.thunder_storm_deities','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Classical and Han transmitted texts','Chu Ci Yuan You; Lunheng Lei Xu','The witnesses differ in genre and attitude.','2026-08-14T00:00:00Z'),
('claim.v060.chinese.leigong_appears_chuci','deity.chinese.leigong','APPEARS_IN','text.chinese.chuci',NULL,NULL,'Chu Ci, Yuan You places Leigong to the right as a guard while the Rain Master attends on the left.','chinese.leigong.chuci','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Chu Ci','Yuan You','Poetic textual claim only.','2026-08-14T00:00:00Z'),
('claim.v060.chinese.leigong_appears_lunheng','deity.chinese.leigong','APPEARS_IN','text.chinese.lunheng',NULL,NULL,'Lunheng, Lei Xu records an image called Leigong with linked drums and a mallet, then criticizes that explanation as false.','chinese.leigong.lunheng','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Lunheng','Lei Xu','The source records and rejects a belief; it does not endorse it.','2026-08-14T00:00:00Z'),
('claim.v060.chinese.leigong_associated_mogao285','deity.chinese.leigong','ASSOCIATED_WITH','site.chinese.mogao_cave_285',NULL,NULL,'The Dunhuang Academy identifies thunder-deity imagery in the real Western Wei Cave 285 ceiling program.','chinese.thunder_iconography.mogao285','SUPPORTED',0.91,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','ARCHAEOLOGICAL','Mogao art-historical layer','Cave 285 official record','Iconographic identification, not a dedicatory inscription naming Leigong.','2026-08-14T00:00:00Z'),
('claim.v060.chinese.leize_thunder_scope','deity.chinese.leize_thunder_spirit','ASSOCIATED_WITH','concept.comparative.thunder',NULL,NULL,'The Classic of Mountains and Seas describes an unnamed thunder spirit in Leize whose belly-drumming produces thunder.','chinese.leize_thunder_spirit','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Classic of Mountains and Seas','Hai Nei Dong Jing','Kept distinct from later Leigong.','2026-08-14T00:00:00Z'),
('claim.v060.chinese.leize_appears_shanhaijing','deity.chinese.leize_thunder_spirit','APPEARS_IN','text.chinese.shanhaijing',NULL,NULL,'The Leize thunder spirit appears in the Hai Nei Dong Jing section of the Classic of Mountains and Seas.','chinese.leize_thunder_spirit','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Classic of Mountains and Seas','Hai Nei Dong Jing','Original form and location remain text-specific.','2026-08-14T00:00:00Z'),

('claim.v060.slavic.perun_thunder_scope','deity.slavic.perun','ASSOCIATED_WITH','concept.comparative.thunder',NULL,NULL,'Modern academic reference contextualizes the chronicle’s Perun as an East Slavic thunder and lightning deity.','comparison.thunder_storm_deities','SUPPORTED',0.94,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','East Slavic evidence','CIUS Perun article','Primary chronicle entries support the named cult and oaths; domain synthesis remains scholarly.','2026-08-14T00:00:00Z'),
('claim.v060.slavic.perun_appears_pvl','deity.slavic.perun','APPEARS_IN','text.slavic.primary_chronicle',NULL,NULL,'The Primary Chronicle names Perun in treaty-oath entries and in the 980 and 988 Kyiv idol episodes.','slavic.perun.primary_chronicle','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Primary Chronicle','annals 907, 945, 971, 980, 988','Each annal entry must remain separately locatable.','2026-08-14T00:00:00Z'),
('claim.v060.slavic.perun_coinvoked_veles','deity.slavic.perun','CO_INVOKED_WITH','deity.slavic.veles',NULL,NULL,'The 907 and 971 treaty-oath traditions invoke Perun and Veles or Volos together.','slavic.treaty_oaths','SUPPORTED',0.97,'HIGH','VERIFIED','TEXT_SAYS','RITUAL_PRACTICE','Primary Chronicle','annals 907 and 971','Co-invocation is not evidence of a cosmic enemy relation.','2026-08-14T00:00:00Z'),
('claim.v060.slavic.perun_980_image','deity.slavic.perun','DESCRIBED_AS',NULL,'wooden idol with a silver head and golden moustache','text','The 980 annal describes a wooden Perun idol with a silver head and golden moustache on the Kyiv hill.','slavic.perun.980_idol','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Primary Chronicle','annal 980','Textual description; no surviving object is asserted.','2026-08-14T00:00:00Z'),

('claim.v060.yoruba.sango_thunder_scope','deity.yoruba.shango','ASSOCIATED_WITH','concept.comparative.thunder',NULL,NULL,'The community-backed UNESCO Sango Festival dossier publicly identifies Sango with thunder, lightning, justice and Oyo kingship/ancestor memory.','comparison.thunder_storm_deities','SUPPORTED',0.98,'HIGH','VERIFIED','IN_TRADITION','RITUAL_PRACTICE','Oyo Yoruba living tradition','ICH 01974 public dossier','Restricted knowledge is not included.','2026-08-14T00:00:00Z'),
('claim.v060.yoruba.sango_associated_festival','deity.yoruba.shango','ASSOCIATED_WITH','festival.yoruba.sango_oyo',NULL,NULL,'The annual Oyo Sango Festival is a public living-tradition expression centered on Sango.','yoruba.sango_festival.public','SUPPORTED',0.99,'HIGH','VERIFIED','IN_TRADITION','RITUAL_PRACTICE','Oyo Yoruba living tradition','ICH 01974','Only public nomination information is stored.','2026-08-14T00:00:00Z'),
('claim.v060.yoruba.sango_associated_ose','deity.yoruba.shango','ASSOCIATED_WITH','artifact.yoruba.ose_sango',NULL,NULL,'Museum records identify Ose Sango as a double-axe-topped sacred or devotional staff associated with Sango.','yoruba.ose_sango.public_objects','SUPPORTED',0.96,'HIGH','VERIFIED','IN_TRADITION','RITUAL_PRACTICE','Yoruba public material culture','Met object 1983.603.5','A type of sacred object, not one unique weapon.','2026-08-14T00:00:00Z'),
('claim.v060.yoruba.festival_associated_koso','festival.yoruba.sango_oyo','ASSOCIATED_WITH','site.yoruba.koso_temple',NULL,NULL,'The UNESCO public dossier connects the Oyo Sango Festival with Koso Temple.','yoruba.sango_festival.public','SUPPORTED',0.98,'HIGH','VERIFIED','IN_TRADITION','RITUAL_PRACTICE','Oyo Yoruba living tradition','ICH 01974','Restricted shrine interiors and exact internal locations are withheld.','2026-08-14T00:00:00Z'),

('claim.v060.ugaritic.baal_thunder_scope','deity.ugaritic.baal','ASSOCIATED_WITH','concept.comparative.thunder',NULL,NULL,'The Louvre thunderbolt stele and Baal Cycle context support comparing Ugaritic Baalu/Haddu as a storm and lightning figure.','comparison.thunder_storm_deities','SUPPORTED',0.95,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','ARCHAEOLOGICAL','Ugaritic textual and iconographic witnesses','AO 15775 / KTU corpus','Comparison does not merge other Baal-titled deities.','2026-08-14T00:00:00Z'),
('claim.v060.ugaritic.baal_associated_title','deity.ugaritic.baal','ASSOCIATED_WITH','concept.ugaritic.baal_title',NULL,NULL,'Baal is also a lord/master title; the Ugaritic storm deity’s record therefore cannot absorb every Baal-named figure.','ugaritic.baal.title_vs_entity','SUPPORTED',0.96,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Ugaritic and comparative Semitic naming','British Museum Hadad authority record','Deduplication rule, not a claim that the Ugaritic deity lacks individual identity.','2026-08-14T00:00:00Z'),
('claim.v060.ugaritic.kothar_created_yagrush','deity.ugaritic.kothar_wa_khasis','CREATOR_OF','weapon.ugaritic.yagrush',NULL,NULL,'KTU 1.2 IV identifies Kothar-wa-Khasis as maker of Yagrush for Baal.','ugaritic.ktu1_2.weapons','SUPPORTED',0.97,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Baal Cycle','KTU 1.2 IV 11-17',NULL,'2026-08-14T00:00:00Z'),
('claim.v060.ugaritic.kothar_created_ayyamur','deity.ugaritic.kothar_wa_khasis','CREATOR_OF','weapon.ugaritic.ayyamur',NULL,NULL,'KTU 1.2 IV identifies Kothar-wa-Khasis as maker of Ayyamur for Baal.','ugaritic.ktu1_2.weapons','SUPPORTED',0.97,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Baal Cycle','KTU 1.2 IV 18-26',NULL,'2026-08-14T00:00:00Z'),
('claim.v060.ugaritic.baal_uses_yagrush','deity.ugaritic.baal','USES','weapon.ugaritic.yagrush',NULL,NULL,'In KTU 1.2 IV Baal uses Yagrush in the combat with Yamm.','ugaritic.ktu1_2.weapons','SUPPORTED',0.97,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Baal Cycle','KTU 1.2 IV 11-17','First blow does not make Yamm fall in the registered reading.','2026-08-14T00:00:00Z'),
('claim.v060.ugaritic.baal_uses_ayyamur','deity.ugaritic.baal','USES','weapon.ugaritic.ayyamur',NULL,NULL,'In KTU 1.2 IV Baal uses Ayyamur in the combat with Yamm.','ugaritic.ktu1_2.weapons','SUPPORTED',0.97,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Baal Cycle','KTU 1.2 IV 18-26','Second blow makes Yamm fall in the registered reading.','2026-08-14T00:00:00Z'),
('claim.v060.ugaritic.baal_participated_yamm_event','deity.ugaritic.baal','PARTICIPATED_IN','event.ugaritic.baal_yamm_ktu12',NULL,NULL,'Baal is a combatant in the KTU 1.2 IV event layer.','ugaritic.ktu1_2.event','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Baal Cycle','KTU 1.2 IV','Mythic narrative, not historical warfare.','2026-08-14T00:00:00Z'),
('claim.v060.ugaritic.yamm_participated_event','deity.ugaritic.yam','PARTICIPATED_IN','event.ugaritic.baal_yamm_ktu12',NULL,NULL,'Yamm is Baal’s opponent in the KTU 1.2 IV event layer.','ugaritic.ktu1_2.event','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Baal Cycle','KTU 1.2 IV','Stored under the existing Ugaritic Yam entity without merging cross-cultural sea figures.','2026-08-14T00:00:00Z'),
('claim.v060.ugaritic.event_appears_baal_cycle','event.ugaritic.baal_yamm_ktu12','APPEARS_IN','text.ugaritic.baal_cycle',NULL,NULL,'The event record indexes the Baal-Yamm combat in Baal Cycle tablet KTU 1.2 IV.','ugaritic.ktu1_2.event','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Baal Cycle','KTU 1.2 IV','Modern event label indexes a fragmentary ancient witness.','2026-08-14T00:00:00Z'),
('claim.v060.ugaritic.yagrush_appears_baal_cycle','weapon.ugaritic.yagrush','APPEARS_IN','text.ugaritic.baal_cycle',NULL,NULL,'Yagrush appears in KTU 1.2 IV 11-17.','ugaritic.ktu1_2.weapons','SUPPORTED',0.97,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Baal Cycle','KTU 1.2 IV 11-17','Object form remains translation-dependent.','2026-08-14T00:00:00Z'),
('claim.v060.ugaritic.ayyamur_appears_baal_cycle','weapon.ugaritic.ayyamur','APPEARS_IN','text.ugaritic.baal_cycle',NULL,NULL,'Ayyamur appears in KTU 1.2 IV 18-26.','ugaritic.ktu1_2.weapons','SUPPORTED',0.97,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Baal Cycle','KTU 1.2 IV 18-26','Object form remains translation-dependent.','2026-08-14T00:00:00Z'),

('claim.v060.norse.thor_sibling_baldr','deity.norse.thor','SIBLING_OF','deity.norse.baldr',NULL,NULL,'Haustlong stanza 16 uses brother terminology for Thor and Baldr.','norse.thor.siblings.attested','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Haustlong','stanza 16','Direct poetic terminology; later inferred half-sibling analysis remains a separate layer.','2026-08-14T00:00:00Z'),
('claim.v060.greek.zeus_thunder_scope','deity.greek.zeus','ASSOCIATED_WITH','concept.comparative.thunder',NULL,NULL,'Hesiod’s Theogony places thunder, lightning and the thunderbolt among the powers given to Zeus by the Cyclopes.','comparison.thunder_storm_deities','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','Theogony 139-141 and 501-506','Greek witness retained on its own terms.','2026-08-14T00:00:00Z');

INSERT OR IGNORE INTO evidence(
  id,claim_id,source_id,source_location,chapter,verse,line,page,catalogue_number,
  short_quote,evidence_type,direction,strength,research_notes
)
SELECT
  'evidence.' || substr(c.id,7),
  c.id,
  CASE
    WHEN c.id='claim.v060.norse.thor_thunder_scope' THEN 'source.norse.mjolnir_rings.historiska'
    WHEN c.id='claim.v060.norse.thor_sibling_baldr' THEN 'source.norse.haustlong.skaldic2017'
    WHEN c.id LIKE 'claim.v060.modern.%' THEN 'source.marvel.thor.onscreen'
    WHEN c.id='claim.v060.norse.loki_parent_hel' THEN 'source.norse.gylfaginning.vsnr2005'
    WHEN c.id IN ('claim.v060.norse.thor_loki_thrymskvida','claim.v060.norse.thor_appears_thrymskvida','claim.v060.norse.loki_appears_thrymskvida') THEN 'source.norse.poetic_edda.gks2365'
    WHEN c.id LIKE 'claim.v060.norse.%' THEN 'source.norse.skaldskaparmal.vsnr1998'
    WHEN c.id LIKE 'claim.v060.vedic.%' THEN 'source.vedic.rigveda.1_32.vhp'
    WHEN c.id='claim.v060.japanese.raijin_thunder_scope' THEN 'source.japanese.raijin.kokugakuin'
    WHEN c.id LIKE 'claim.v060.japanese.takemikazuchi_%' THEN 'source.japanese.takemikazuchi.kokugakuin'
    WHEN c.id='claim.v060.japanese.wakaikazuchi_member' THEN 'source.japanese.wakaikazuchi.kokugakuin'
    WHEN c.id='claim.v060.japanese.naruikazuchi_member' THEN 'source.japanese.naruikazuchi.kokugakuin'
    WHEN c.id LIKE 'claim.v060.japanese.%' THEN 'source.japanese.kojiki_kami_index.kokugakuin'
    WHEN c.id='claim.v060.chinese.leigong_appears_lunheng' THEN 'source.chinese.lunheng_leixu.ctext'
    WHEN c.id='claim.v060.chinese.leigong_associated_mogao285' THEN 'source.chinese.mogao285.dunhuang'
    WHEN c.id LIKE 'claim.v060.chinese.leize_%' THEN 'source.chinese.shanhaijing_leize.ctext'
    WHEN c.id LIKE 'claim.v060.chinese.%' THEN 'source.chinese.chuci_yuanyou.ctext'
    WHEN c.id='claim.v060.slavic.perun_thunder_scope' THEN 'source.slavic.perun.cius'
    WHEN c.id LIKE 'claim.v060.slavic.%' THEN 'source.slavic.pvl.obdurodon'
    WHEN c.id='claim.v060.yoruba.sango_associated_ose' THEN 'source.yoruba.ose_sango.met.1983_603_5'
    WHEN c.id LIKE 'claim.v060.yoruba.%' THEN 'source.yoruba.sango_festival.unesco'
    WHEN c.id='claim.v060.ugaritic.baal_thunder_scope' THEN 'source.ugaritic.baal_thunder.louvre.ao15775'
    WHEN c.id='claim.v060.ugaritic.baal_associated_title' THEN 'source.ugaritic.hadad.bm'
    WHEN c.id LIKE 'claim.v060.ugaritic.%weapon%' OR c.id LIKE 'claim.v060.ugaritic.kothar_%' OR c.id LIKE 'claim.v060.ugaritic.baal_uses_%' OR c.id LIKE 'claim.v060.ugaritic.yagrush_%' OR c.id LIKE 'claim.v060.ugaritic.ayyamur_%' THEN 'source.ugaritic.weapons.die_bibel'
    WHEN c.id LIKE 'claim.v060.ugaritic.%' THEN 'source.ugaritic.ktu1_2.inventory.uchicago'
    WHEN c.id='claim.v060.greek.zeus_thunder_scope' THEN 'source.greek.theogony.perseus_eng1'
  END,
  c.temporal_scope,
  CASE
    WHEN c.id LIKE 'claim.v060.vedic.%' THEN 'Mandala 1, Sukta 32'
    WHEN c.id LIKE 'claim.v060.norse.%' THEN c.tradition_scope
    WHEN c.id LIKE 'claim.v060.slavic.%' THEN 'annal entry'
    WHEN c.id LIKE 'claim.v060.ugaritic.%' THEN 'KTU 1.2 IV'
    ELSE NULL
  END,
  CASE WHEN c.id LIKE 'claim.v060.vedic.%' THEN replace(c.temporal_scope,'RV ','') ELSE NULL END,
  c.temporal_scope,
  NULL,
  CASE
    WHEN c.id='claim.v060.ugaritic.baal_thunder_scope' THEN 'AO 15775 / RS 4.427'
    WHEN c.id='claim.v060.yoruba.sango_associated_ose' THEN '1983.603.5'
    ELSE NULL
  END,
  NULL,
  CASE
    WHEN c.id LIKE 'claim.v060.modern.%' THEN 'POPULAR_CULTURE'
    WHEN c.id='claim.v060.norse.thor_thunder_scope' THEN 'MUSEUM_OBJECT'
    WHEN c.id LIKE 'claim.v060.norse.%' THEN 'MEDIEVAL_TEXT'
    WHEN c.id LIKE 'claim.v060.vedic.%' THEN 'PRIMARY_TEXT'
    WHEN c.id LIKE 'claim.v060.japanese.%' THEN 'MODERN_SCHOLARSHIP'
    WHEN c.id='claim.v060.chinese.leigong_associated_mogao285' THEN 'ARCHAEOLOGICAL'
    WHEN c.id LIKE 'claim.v060.chinese.%' THEN 'ANCIENT_TEXT'
    WHEN c.id='claim.v060.slavic.perun_thunder_scope' THEN 'MODERN_SCHOLARSHIP'
    WHEN c.id LIKE 'claim.v060.slavic.%' THEN 'MEDIEVAL_TEXT'
    WHEN c.id='claim.v060.yoruba.sango_associated_ose' THEN 'MUSEUM_OBJECT'
    WHEN c.id LIKE 'claim.v060.yoruba.%' THEN 'ORAL_TRADITION'
    WHEN c.id='claim.v060.ugaritic.baal_thunder_scope' THEN 'MUSEUM_OBJECT'
    WHEN c.id IN ('claim.v060.ugaritic.baal_associated_title') OR c.id LIKE 'claim.v060.ugaritic.%weapon%' OR c.id LIKE 'claim.v060.ugaritic.kothar_%' OR c.id LIKE 'claim.v060.ugaritic.baal_uses_%' OR c.id LIKE 'claim.v060.ugaritic.yagrush_%' OR c.id LIKE 'claim.v060.ugaritic.ayyamur_%' THEN 'MODERN_SCHOLARSHIP'
    WHEN c.id LIKE 'claim.v060.ugaritic.%' THEN 'ANCIENT_TEXT'
    WHEN c.id LIKE 'claim.v060.greek.%' THEN 'ANCIENT_TEXT'
  END,
  'SUPPORTS',
  c.confidence,
  'Source and locator checked for the v0.6.0 staged baseline on 2026-08-14; no long quotation is published.'
FROM claims c
WHERE c.id LIKE 'claim.v060.%';

-- A second witness contextualizes the combined early Leigong comparison claim.
INSERT OR IGNORE INTO evidence(
  id,claim_id,source_id,source_location,chapter,verse,line,page,catalogue_number,
  short_quote,evidence_type,direction,strength,research_notes
) VALUES
('evidence.v060.chinese.leigong_thunder_scope.lunheng','claim.v060.chinese.leigong_thunder_scope','source.chinese.lunheng_leixu.ctext','Lunheng, Lei Xu','Lei Xu',NULL,NULL,NULL,'urn:ctext:lunheng/lei-xu',NULL,'ANCIENT_TEXT','CONTEXT',0.95,'Records and rejects a linked-drum Leigong image; this contextual evidence is not an endorsement by Wang Chong.'),
('evidence.v060.yoruba.ose_sango.smithsonian','claim.v060.yoruba.sango_associated_ose','source.yoruba.ose_sango.smithsonian','selected artwork 1713',NULL,NULL,NULL,NULL,'NMAfA selected artwork 1713',NULL,'MUSEUM_OBJECT','CONTEXT',0.9,'Independent museum context for the public material-culture layer; no restricted ritual procedure is inferred.');

INSERT OR IGNORE INTO event_participants(event_id,participant_id,role,outcome,claim_id) VALUES
('event.vedic.indra_vritra_rv132','deity.vedic.indra','COMBATANT','Kills Vrtra in this hymn witness','claim.v060.vedic.indra_participated_vrtra_event'),
('event.vedic.indra_vritra_rv132','creature.vedic.vritra','OPPONENT','Killed in this hymn witness','claim.v060.vedic.vrtra_participated_event'),
('event.ugaritic.baal_yamm_ktu12','deity.ugaritic.baal','COMBATANT','Yamm is made to fall in the registered reading','claim.v060.ugaritic.baal_participated_yamm_event'),
('event.ugaritic.baal_yamm_ktu12','deity.ugaritic.yam','OPPONENT','Falls after the second named weapon blow in the registered reading','claim.v060.ugaritic.yamm_participated_event');

INSERT OR IGNORE INTO modern_adaptations(
  id,ancient_entity_id,modern_entity_id,modern_work_entity_id,medium,
  adaptation_notes,source_id,canonicality_scope
) VALUES
('adaptation.v060.marvel.thor','deity.norse.thor','modern.marvel.mcu.thor',NULL,'FILM_AND_STREAMING_CONTINUITY','Marvel Studios screen Thor is a separate modern interpretation; its family relations do not alter the Old Norse record.','source.marvel.thor.onscreen','POPULAR_CULTURE'),
('adaptation.v060.marvel.loki','deity.norse.loki','modern.marvel.mcu.loki',NULL,'FILM_AND_STREAMING_CONTINUITY','Marvel Studios screen Loki is Thor’s adoptive brother in that continuity, unlike the Old Norse relationship layer.','source.marvel.thor.onscreen','POPULAR_CULTURE'),
('adaptation.v060.marvel.hela','deity.norse.hel','modern.marvel.mcu.hela',NULL,'FILM_AND_STREAMING_CONTINUITY','Marvel Studios Hela is Thor’s half-sister; Snorri’s Hel is Loki and Angrboda’s daughter.','source.marvel.thor.onscreen','POPULAR_CULTURE');

INSERT OR REPLACE INTO comparison_sets(
  id,concept_entity_id,canonical_name,name_zh,description_en,description_zh,
  methodology_en,methodology_zh,research_status,created_at,updated_at
) VALUES(
  'comparison.thunder_storm_deities','concept.comparative.thunder',
  'Thunder, lightning and storm deities','雷神、闪电与风暴神对照',
  'A source-led comparison of thunder, lightning, storm, rain, combat and kingship layers. Membership marks a useful comparison, never identity or common origin.',
  '按来源比较雷、闪电、风暴、降雨、战斗与王权层。进入本表只表示“可比较”，不表示同一神、同一来源或已经证实的传播关系。',
  'Every member requires a located claim. Native scope and comparison boundaries remain explicit; umbrella figures, textual groups, living traditions and modern receptions are not flattened.',
  '每个成员必须连接已定位 Claim，并保留原生范围与比较边界；泛称、文本神群、活态传统和现代改编不会被压成同一套神谱。',
  'PARTIAL','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'
);

INSERT OR REPLACE INTO comparison_set_members(
  comparison_set_id,entity_id,member_role,native_scope_en,native_scope_zh,
  distinction_en,distinction_zh,sort_order,claim_id
) VALUES
('comparison.thunder_storm_deities','deity.norse.thor','COMPARAND','Hammer-bearing protector and giant-opponent with thunder association in Norse textual and material layers.','古诺斯文本与物质文化层中的锤持有者、保护者和巨人对手，并具雷鸣关联。','Loki is a narrative companion/adversary, not an Old Norse brother; Thrud is Thor’s daughter.','洛基是叙事同伴／对手，不是古诺斯层兄弟；斯露德是索尔之女。',10,'claim.v060.norse.thor_thunder_scope'),
('comparison.thunder_storm_deities','deity.greek.zeus','COMPARAND','Thunder, lightning, thunderbolt and divine rule in specific Greek witnesses.','具体希腊文本中的雷、闪电、雷霆武器与神王层。','Greek thunderbolt genealogy and Olympian rule do not define every storm tradition.','希腊雷霆来源与奥林匹斯王权不能用来定义其他文明的风暴神。',20,'claim.v060.greek.zeus_thunder_scope'),
('comparison.thunder_storm_deities','deity.vedic.indra','COMPARAND','Rigvedic atmospheric, thunder/lightning, martial and water-release layers with the vajra.','《梨俱吠陀》中的大气、雷电、战斗、放水与金刚杵层。','Later Buddhist Sakra and ritual vajra reception remain separate from the Rigvedic witness.','后世帝释天与佛教法器金刚杵不得覆盖吠陀文本层。',30,'claim.v060.vedic.indra_thunder_scope'),
('comparison.thunder_storm_deities','deity.japanese.raijin','UMBRELLA_COMPARAND','A broad Japanese thunder-kami designation with regional and diachronic forms.','日本跨时期、跨地方的“雷神”称谓／神祇复合入口。','Not one fixed ancient personality; the Kojiki eight thunder kami remain separate records.','不是一位固定古典人格；《古事记》八雷神保持独立。',40,'claim.v060.japanese.raijin_thunder_scope'),
('comparison.thunder_storm_deities','deity.japanese.takemikazuchi','SECONDARY_COMPARAND','Primarily a martial heavenly envoy in classical narratives, with secondary thunder association.','古典叙事中主要是武神／天神使者，雷电为次级关联。','Not an alias or automatic equivalent of Raijin.','不是 Raijin 的别名，也不自动等同。',45,'claim.v060.japanese.takemikazuchi_thunder_scope'),
('comparison.thunder_storm_deities','deity.chinese.leigong','COMPARAND','Diachronic Leigong layers in classical poetry, Han criticism and later visual traditions.','古典诗歌、汉代批判记录与后世图像传统中的跨时期雷公层。','Wang Chong records and rejects an image explanation; Leize’s thunder spirit stays distinct.','王充记录后加以反驳；雷泽雷神保持独立。',50,'claim.v060.chinese.leigong_thunder_scope'),
('comparison.thunder_storm_deities','deity.chinese.leize_thunder_spirit','TEXTUAL_COMPARAND','Unnamed dragon-bodied thunder spirit of Leize in the Classic of Mountains and Seas.','《山海经》中居于雷泽、龙身人头的无名雷神。','A separate textual entity, not automatically an early name for later Leigong.','独立文本实体，不能自动当作后世雷公的早期名字。',55,'claim.v060.chinese.leize_thunder_scope'),
('comparison.thunder_storm_deities','deity.slavic.perun','COMPARAND','East Slavic oath and state-cult evidence, with thunder/lightning synthesis in scholarship.','东斯拉夫誓言与国家崇拜见证；雷电领域由学术语境综合。','No securely named medieval axe or hammer; co-invocation with Veles is not direct proof of cosmic enmity.','没有可靠中世纪命名斧／锤；与维列斯共同受誓言援引不等于宇宙敌对。',60,'claim.v060.slavic.perun_thunder_scope'),
('comparison.thunder_storm_deities','deity.yoruba.shango','LIVING_TRADITION_COMPARAND','Thunder, lightning, justice, kingship and ancestor memory in the living Oyo Yoruba tradition.','奥约约鲁巴活态传统中的雷、闪电、正义、王权与祖先记忆。','Public community-backed layers only; initiated-only spaces and knowledge are not collected.','仅收录社群授权的公共层；入门者空间与秘密知识不采集。',70,'claim.v060.yoruba.sango_thunder_scope'),
('comparison.thunder_storm_deities','deity.ugaritic.baal','COMPARAND','Ugaritic storm, rain, warrior, fertility and kingship layers in tablets and iconography.','乌加里特泥板与图像中的风暴、降雨、战士、丰饶与王权层。','Baal is also a title; other Baal figures are not merged, and weapon forms remain translation-dependent.','“Baal”亦为头衔；其他巴力不合并，武器外形保留译法差异。',80,'claim.v060.ugaritic.baal_thunder_scope');

INSERT OR IGNORE INTO conflicts(
  id,subject_id,variant_group,claim_a_id,claim_b_id,conflict_type,status,summary,resolution_notes
) VALUES
('conflict.v060.norse.thor_modern_kinship','deity.norse.thor','norse.thor.ancient_vs_modern_kinship','claim.v060.norse.loki_parent_hel','claim.v060.modern.thor_sibling_hela','LAYERED_ADAPTATION','RESOLVED_AS_VARIANTS','Old Norse witnesses make Hel a child of Loki and do not make Loki Thor’s brother; Marvel screen continuity makes Loki an adoptive brother and Hela a half-sister of Thor.','Keep ancient and modern entities separate and connect them only through modern_adaptations.'),
('conflict.v060.japanese.raijin_model','deity.japanese.raijin','japanese.raijin.single_vs_umbrella','claim.v060.japanese.raijin_thunder_scope','claim.v060.japanese.eight_thunder_appears_kojiki','TAXONOMY_AMBIGUITY','OPEN','Raijin can function as a broad thunder-kami designation while classical and regional traditions preserve multiple distinct thunder figures.','Use an umbrella entity plus separate deity/group records; never force a single universal genealogy.'),
('conflict.v060.japanese.takemikazuchi_domain','deity.japanese.takemikazuchi','japanese.takemikazuchi.domain','claim.v060.japanese.takemikazuchi_thunder_scope','claim.v060.japanese.takemikazuchi_appears_kojiki','CLASSIFICATION_AMBIGUITY','OPEN','Modern thunder-god labels can obscure that Takemikazuchi’s principal classical actions are martial and emissarial.','Retain martial/heavenly-envoy as primary and thunder association as medium-confidence secondary classification.'),
('conflict.v060.chinese.leigong_leize_identity','deity.chinese.leigong','chinese.leigong_vs_leize_thunder_spirit','claim.v060.chinese.leigong_thunder_scope','claim.v060.chinese.leize_thunder_scope','IDENTITY_AMBIGUITY','OPEN','The Leize thunder spirit in the Classic of Mountains and Seas and later Leigong layers share a thunder function but differ in name, form and textual setting.','Keep separate canonical entities; future diachronic scholarship may add a qualified relationship without automatic identity.'),
('conflict.v060.slavic.perun_named_weapon','deity.slavic.perun','slavic.perun.named_weapon',NULL,NULL,'POPULAR_RECONSTRUCTION','OPEN','Modern summaries often give Perun a named axe or hammer, but the registered medieval chronicle evidence does not name such a unique divine weapon.','Add archaeological miniature-axe pendants and comparative scholarship only as low-confidence, separately sourced layers.'),
('conflict.v060.ugaritic.baal_title_entity','deity.ugaritic.baal','ugaritic.baal.title_vs_entity','claim.v060.ugaritic.baal_associated_title','claim.v060.ugaritic.baal_thunder_scope','NAME_SCOPE_AMBIGUITY','OPEN','Baal can be a lord/master title while the Ugaritic Baalu/Haddu dossier refers to a particular storm-deity figure in registered witnesses.','Never merge Baal Hammon, Baalshamin, Melqart, biblical Baalim or other regional figures by name alone.');

INSERT OR IGNORE INTO identity_candidates(
  id,entity_a_id,entity_b_id,assessment,confidence,source_id,notes
) VALUES
('identity.v060.chinese.leigong_leize','deity.chinese.leigong','deity.chinese.leize_thunder_spirit','DISPUTED_IDENTITY',0.3,'source.chinese.shanhaijing_leize.ctext','Functional similarity alone is insufficient; names, forms and textual layers differ.'),
('identity.v060.japanese.raijin_takemikazuchi','deity.japanese.raijin','deity.japanese.takemikazuchi','EXPLICITLY_DISTINCT',0.9,'source.japanese.takemikazuchi.kokugakuin','The project treats umbrella Raijin traditions and the classical martial envoy as distinct records; thunder association is not identity.');

UPDATE collection_queue SET
  status='PARTIAL',attempts=attempts+1,last_error=NULL,
  next_action='Extend the title/entity audit to Baal Hammon, Baalshamin, Melqart and biblical Baalim; preserve each regional dossier',
  updated_at='2026-08-14T00:00:00Z'
WHERE id='queue.ugarit.baal_title';

UPDATE collection_queue SET
  status='PARTIAL',attempts=attempts+1,last_error=NULL,
  next_action='Continue source-biased extraction beyond Perun: regional chronicle witnesses, Polabian sources and modern reconstruction boundaries',
  updated_at='2026-08-14T00:00:00Z'
WHERE id='queue.slavic.primary_claims';

INSERT OR IGNORE INTO collection_queue(
  id,target_label,normalized_label,proposed_entity_type,civilization_id,
  discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,
  discovery_context,priority,status,attempts,last_error,next_action,created_at,updated_at
) VALUES
('queue.v060.norse.thor_genealogy_variants','Thor genealogy across Poetic Edda, Prose Edda and skaldic witnesses','thor genealogy across poetic edda prose edda and skaldic witnesses','DEITY','civ.norse','deity.norse.thor','claim.v060.norse.thor_sibling_meili','source.norse.skaldskaparmal.vsnr1998','The family baseline exposes sparse Meili evidence and inferred Odin half-siblings that should not be presented as directly attested Thor-sibling claims.',99,'PARTIAL',1,NULL,'Add exact skaldic stanzas and manuscript variants; distinguish directly attested siblings from shared-parent inference','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('queue.v060.norse.thor_modern_adaptations','Thor, Loki, Hel/Hela and Angela across Norse, comics and screen layers','thor loki hel hela and angela across norse comics and screen layers','MODERN_WORK','civ.norse','deity.norse.thor','claim.v060.modern.thor_sibling_hela','source.marvel.thor.onscreen','The screen half-sister and adoptive-brother model differs from both Old Norse and Marvel comics genealogies.',96,'SOURCE_FOUND',1,NULL,'Add official comics continuity sources for Hela as Loki relation and Angela as Thor sister without mixing screen canon','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('queue.v060.vedic.vajra_reception','Vedic vajra and later Buddhist/Jain ritual-object reception','vedic vajra and later buddhist jain ritual object reception','ARTIFACT','civ.vedic','weapon.vedic.vajra','claim.v060.vedic.vajra_appears_rigveda','source.vedic.rigveda.1_32.vhp','The Rigvedic weapon is source-backed, but later iconographic and ritual objects require a reception chain rather than identity by spelling.',97,'SOURCE_FOUND',1,NULL,'Register dated Buddhist and Jain object types and museum records as reception/variant layers','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('queue.v060.japanese.raijin_regional','Regional Japanese thunder kami and Raijin traditions','regional japanese thunder kami and raijin traditions','DEITY','civ.japanese_shinto','deity.japanese.raijin','claim.v060.japanese.raijin_thunder_scope','source.japanese.raijin.kokugakuin','The umbrella source names multiple regional thunder-kami traditions that must not be collapsed.',99,'SOURCE_FOUND',1,NULL,'Create source-specific dossiers for Kamowakeikazuchi, Karaijin, local rites and the Sotatsu screen object','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('queue.v060.chinese.leigong_diachronic','Leigong from classical texts through Daoist, local and visual traditions','leigong from classical texts through daoist local and visual traditions','DEITY','civ.chinese_folk','deity.chinese.leigong','claim.v060.chinese.leigong_appears_lunheng','source.chinese.lunheng_leixu.ctext','The first pass deliberately separates Chu Ci, Lunheng and Mogao layers and leaves medieval/local cult development open.',98,'PARTIAL',1,NULL,'Add Taiping Guangji, Daoist scriptures, dated temple records and region-specific living traditions with access notes','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('queue.v060.slavic.perun_axe','Perun and early medieval miniature axe pendants','perun and early medieval miniature axe pendants','ARTIFACT','civ.slavic','deity.slavic.perun',NULL,'source.slavic.perun.cius','Popular named-weapon claims exceed the registered medieval text evidence; archaeological pendants need object-level study.',96,'NEEDS_REVIEW',1,NULL,'Add object catalogues and DOI 10.15388/ArchLit.2011.12.5137; retain association as disputed/low confidence','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('queue.v060.yoruba.sango_permissions','Sango living-tradition authority and permission register','sango living tradition authority and permission register','RITUAL','civ.yoruba','deity.yoruba.shango','claim.v060.yoruba.sango_thunder_scope','source.yoruba.sango_decision.unesco','UNESCO documents public community consent and initiated-only spaces; future expansion needs explicit community authority fields.',100,'NEEDS_REVIEW',1,NULL,'Contact or cite authorized Oyo institutions for any non-public layer; never collect secret rites or restricted interior locations','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('queue.v060.ugaritic.baal_parentage','Baalu/Haddu parentage variants: Dagan and El expressions','baalu haddu parentage variants dagan and el expressions','DEITY','civ.ugaritic','deity.ugaritic.baal',NULL,'source.ugaritic.baal_corpus.goettingen','The title audit exposes multiple Ugaritic genealogy expressions that must coexist by tablet witness.',97,'CONFLICT',1,NULL,'Register KTU 1.2 I and 1.3 IV line-located claims; do not merge Dagan and El','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('queue.v060.ugaritic.baal_mot_cycle','Baal and Mot conflict across KTU 1.5-1.6','baal and mot conflict across ktu 1 5 1 6','EVENT','civ.ugaritic','deity.ugaritic.baal',NULL,'source.ugaritic.baal_corpus.goettingen','The Yamm battle pass leaves the later Mot cycle and Shapshu intervention unmodeled.',95,'SOURCE_FOUND',1,NULL,'Add tablet-by-tablet event phases and avoid the false summary that Baal permanently kills Death','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z');

INSERT OR IGNORE INTO queue_discoveries(
  id,queue_id,discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,discovery_context,discovered_at
) VALUES
('discovery.v060.norse.family','queue.v060.norse.thor_genealogy_variants','deity.norse.thor','claim.v060.norse.thor_sibling_meili','source.norse.skaldskaparmal.vsnr1998','Direct Meili terminology revealed the need to separate attested and inferred siblings.','2026-08-14T00:00:00Z'),
('discovery.v060.norse.modern','queue.v060.norse.thor_modern_adaptations','deity.norse.thor','claim.v060.modern.thor_sibling_hela','source.marvel.thor.onscreen','Screen kinship differs from both Old Norse and comics layers.','2026-08-14T00:00:00Z'),
('discovery.v060.vedic.vajra','queue.v060.vedic.vajra_reception','weapon.vedic.vajra','claim.v060.vedic.vajra_appears_rigveda','source.vedic.rigveda.1_32.vhp','The primary-text weapon revealed a large later reception chain.','2026-08-14T00:00:00Z'),
('discovery.v060.japanese.raijin','queue.v060.japanese.raijin_regional','deity.japanese.raijin','claim.v060.japanese.raijin_thunder_scope','source.japanese.raijin.kokugakuin','Umbrella terminology exposed distinct regional figures.','2026-08-14T00:00:00Z'),
('discovery.v060.chinese.leigong','queue.v060.chinese.leigong_diachronic','deity.chinese.leigong','claim.v060.chinese.leigong_appears_lunheng','source.chinese.lunheng_leixu.ctext','Early witnesses expose later textual, ritual and visual layers.','2026-08-14T00:00:00Z'),
('discovery.v060.slavic.axe','queue.v060.slavic.perun_axe','deity.slavic.perun',NULL,'source.slavic.perun.cius','The absence of a named medieval weapon requires an archaeology-first audit of axe pendants.','2026-08-14T00:00:00Z'),
('discovery.v060.yoruba.permissions','queue.v060.yoruba.sango_permissions','deity.yoruba.shango','claim.v060.yoruba.sango_thunder_scope','source.yoruba.sango_decision.unesco','The UNESCO decision explicitly identifies consent and initiated-only access boundaries.','2026-08-14T00:00:00Z'),
('discovery.v060.ugaritic.parentage','queue.v060.ugaritic.baal_parentage','deity.ugaritic.baal',NULL,'source.ugaritic.baal_corpus.goettingen','The corpus audit exposes multiple genealogy witnesses.','2026-08-14T00:00:00Z'),
('discovery.v060.ugaritic.mot','queue.v060.ugaritic.baal_mot_cycle','deity.ugaritic.baal',NULL,'source.ugaritic.baal_corpus.goettingen','Completing the Yamm combat exposes the still-open Mot sequence.','2026-08-14T00:00:00Z');

INSERT OR IGNORE INTO queue_status_history(id,queue_id,old_status,new_status,changed_at,reason) VALUES
('qhist.v060.ugarit.baal_title','queue.ugarit.baal_title','CONFLICT','PARTIAL','2026-08-14T00:00:00Z','Title lexeme and Ugaritic deity record are now separated; regional Baal audit remains open'),
('qhist.v060.slavic.primary','queue.slavic.primary_claims','SOURCE_FOUND','PARTIAL','2026-08-14T00:00:00Z','Perun chronicle claims extracted; wider Slavic dossier remains open'),
('qhist.v060.norse.family','queue.v060.norse.thor_genealogy_variants','SOURCE_FOUND','PARTIAL','2026-08-14T00:00:00Z','First source-located Thor household graph created'),
('qhist.v060.norse.modern','queue.v060.norse.thor_modern_adaptations','DISCOVERED','SOURCE_FOUND','2026-08-14T00:00:00Z','Official Marvel screen source registered'),
('qhist.v060.vedic.vajra','queue.v060.vedic.vajra_reception','DISCOVERED','SOURCE_FOUND','2026-08-14T00:00:00Z','Rigvedic weapon witness registered'),
('qhist.v060.japanese.raijin','queue.v060.japanese.raijin_regional','DISCOVERED','SOURCE_FOUND','2026-08-14T00:00:00Z','Kokugakuin umbrella and name indexes registered'),
('qhist.v060.chinese.leigong','queue.v060.chinese.leigong_diachronic','SOURCE_FOUND','PARTIAL','2026-08-14T00:00:00Z','Chu Ci, Lunheng and Mogao layers separated'),
('qhist.v060.slavic.axe','queue.v060.slavic.perun_axe','DISCOVERED','NEEDS_REVIEW','2026-08-14T00:00:00Z','No named medieval weapon found in the registered chronicle evidence'),
('qhist.v060.yoruba.permissions','queue.v060.yoruba.sango_permissions','SOURCE_FOUND','NEEDS_REVIEW','2026-08-14T00:00:00Z','Community authorization remains required for any non-public expansion'),
('qhist.v060.ugaritic.parentage','queue.v060.ugaritic.baal_parentage','DISCOVERED','CONFLICT','2026-08-14T00:00:00Z','Dagan and El genealogy expressions require witness-level comparison'),
('qhist.v060.ugaritic.mot','queue.v060.ugaritic.baal_mot_cycle','DISCOVERED','SOURCE_FOUND','2026-08-14T00:00:00Z','Corpus and tablet concordance located');

INSERT OR IGNORE INTO research_sessions(
  id,started_at,ended_at,scope,strategy,status,agent_or_process,notes
) VALUES(
  'research.20260814.v060_thunder_comparison','2026-08-14T00:00:00Z','2026-08-14T20:00:00Z',
  'Thor family and Loki reception correction; evidence-led thunder, lightning and storm comparison across Norse, Greek, Vedic, Japanese, Chinese, Slavic, Yoruba and Ugaritic traditions',
  'Use ancient or medieval text witnesses, academic editions, museums, official heritage records and community-backed living-tradition dossiers; require a located claim for every comparison member; preserve titles, umbrella figures, variants, restricted knowledge and modern adaptations as separate layers',
  'CHECKPOINT_COMPLETE','Codex research agents and persistent data pipeline',
  'Expandable staged baseline only. Regional Raijin, Vajra reception, Perun archaeology, Sango permissions, Baal genealogy/Mot cycle and wider Thor sibling variants remain in the permanent queue.'
);

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result)
SELECT 'research.20260814.v060_thunder_comparison','SOURCE',id,'REGISTER','URL_SYNTAX_VALID_WITH_LOCATOR_AND_RIGHTS_NOTE'
FROM sources WHERE id LIKE 'source.%' AND accessed_date='2026-08-14'
  AND id IN (
    'source.marvel.thor.onscreen','source.vedic.rigveda.1_32.vhp','source.vedic.rigveda.2_12.vhp','source.vedic.rigveda.gretIL_padapatha',
    'source.japanese.raijin.kokugakuin','source.japanese.takemikazuchi.kokugakuin','source.japanese.kojiki_kami_index.kokugakuin','source.japanese.wakaikazuchi.kokugakuin','source.japanese.naruikazuchi.kokugakuin','source.japanese.takemikazuchi_names.kokugakuin','source.japanese.raijin_screen.kyohaku','source.japanese.jhti.berkeley',
    'source.chinese.chuci_yuanyou.ctext','source.chinese.lunheng_leixu.ctext','source.chinese.shanhaijing_leize.ctext','source.chinese.mogao285.dunhuang','source.chinese.mogao440.unesco',
    'source.slavic.pvl.obdurodon','source.slavic.perun.cius','source.yoruba.sango_festival.unesco','source.yoruba.sango_decision.unesco','source.yoruba.ose_sango.met.1983_603_5','source.yoruba.ose_sango.smithsonian',
    'source.ugaritic.baal_corpus.goettingen','source.ugaritic.hadad.bm','source.ugaritic.ktu1_2.inventory.uchicago','source.ugaritic.weapons.die_bibel','source.ugaritic.canaan.met','source.norse.haustlong.skaldic2017'
  );

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result)
SELECT 'research.20260814.v060_thunder_comparison','CLAIM',id,'REGISTER','SOURCE_LOCATED'
FROM claims WHERE id LIKE 'claim.v060.%';

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result)
SELECT 'research.20260814.v060_thunder_comparison','ENTITY',id,
  CASE WHEN created_at='2026-08-14T00:00:00Z' THEN 'CREATE' ELSE 'ENRICH' END,
  'COMPARISON_OR_DISCOVERY_PATH_REGISTERED'
FROM entities WHERE id IN (
  'deity.norse.thor','deity.norse.loki','deity.norse.jord','deity.norse.sif','deity.norse.magni','deity.norse.modi','deity.norse.thrud','deity.norse.meili','being.norse.jarnsaxa','deity.norse.ullr',
  'deity.vedic.indra','deity.vedic.tvastr','creature.vedic.vritra','event.vedic.indra_vritra_rv132','weapon.vedic.vajra',
  'deity.japanese.raijin','deity.japanese.takemikazuchi','group.japanese.eight_thunder_kami','deity.chinese.leigong','deity.chinese.leize_thunder_spirit',
  'deity.slavic.perun','deity.yoruba.shango','artifact.yoruba.ose_sango','festival.yoruba.sango_oyo','site.yoruba.koso_temple',
  'deity.ugaritic.baal','concept.ugaritic.baal_title','deity.ugaritic.kothar_wa_khasis','weapon.ugaritic.yagrush','weapon.ugaritic.ayyamur','event.ugaritic.baal_yamm_ktu12'
);

-- Evidence status remains claim-subject based for SOURCE_BACKED. Objects of a
-- located claim become PARTIAL so incoming family and membership edges are
-- visible as evidence-bearing without pretending their whole dossier is done.
UPDATE entities SET evidence_status='PARTIAL',updated_at='2026-08-14T20:00:00Z'
WHERE id IN (SELECT DISTINCT subject_id FROM claims WHERE id LIKE 'claim.v060.%');

UPDATE entities SET evidence_status='PARTIAL',updated_at='2026-08-14T20:00:00Z'
WHERE id IN (
  SELECT DISTINCT c.object_entity_id
  FROM claims c JOIN evidence ev ON ev.claim_id=c.id
  WHERE c.id LIKE 'claim.v060.%' AND c.object_entity_id IS NOT NULL
);

UPDATE entities SET evidence_status='SOURCE_BACKED',updated_at='2026-08-14T20:00:00Z'
WHERE EXISTS (SELECT 1 FROM claims c WHERE c.subject_id=entities.id)
  AND NOT EXISTS (
    SELECT 1 FROM claims c WHERE c.subject_id=entities.id
      AND NOT EXISTS (SELECT 1 FROM evidence ev WHERE ev.claim_id=c.id)
  );

UPDATE entities SET evidence_status='CONFLICTING',research_status='CONFLICT',updated_at='2026-08-14T20:00:00Z'
WHERE id IN (SELECT subject_id FROM conflicts WHERE status='OPEN' AND subject_id IS NOT NULL);

UPDATE civilizations SET research_status='COLLECTING',evidence_status='PARTIAL'
WHERE id IN ('civ.norse','civ.vedic','civ.japanese_shinto','civ.chinese_ancient','civ.chinese_folk','civ.slavic','civ.yoruba','civ.ugaritic');

UPDATE project_metadata SET value='0.6.0-thunder-comparison-20260814',updated_at='2026-08-14T20:00:00Z' WHERE key='data_version';
UPDATE project_metadata SET value='9',updated_at='2026-08-14T20:00:00Z' WHERE key='schema_version';
UPDATE project_metadata SET value='2026-08-14T20:00:00Z',updated_at='2026-08-14T20:00:00Z' WHERE key='generated_at';

INSERT OR IGNORE INTO dataset_releases(
  id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes
) VALUES(
  'release.0.6.0',9,'0.6.0-thunder-comparison-20260814',NULL,'2026-08-14T20:00:00Z',NULL,
  'Evidence-led thunder and storm comparison checkpoint: source-specific Thor family and Loki/Hel versus Marvel reception correction; Vedic Indra and vajra; Japanese Raijin umbrella, Takemikazuchi and eight-thunder group; Chinese Leigong and distinct Leize thunder spirit; East Slavic Perun; community-bounded Oyo Sango; Ugaritic Baalu/Haddu title and Yamm weapon cycle; extensible comparison schema and permanent discovery paths.'
);

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(9,'20260814_v060_thunder_comparison','2026-08-14T20:00:00Z');

COMMIT;
