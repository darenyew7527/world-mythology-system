BEGIN IMMEDIATE;

-- v0.5.0 turns the first Greek seed list into a source-located reading layer.
-- The ancient texts below are witnesses to particular traditions, not direct
-- evidence that every period or locality held a single uniform pantheon.

INSERT OR IGNORE INTO sources(
  id,title,original_title,source_type,evidence_tier,institution,author_or_editor,
  language_id,publication_date,accessed_date,url,stable_url,catalogue_number,
  rights_status,source_perspective,collector_context,living_tradition,
  access_or_reuse_restrictions,community_permission_required,
  same_witness_as_source_id,translation_status,verification_status,notes
) VALUES
('source.greek.homeric_hymn_apollo3.scaife','Homeric Hymn 3 to Apollo, Evelyn-White English text',NULL,'PRIMARY_TEXT_DIGITAL_EDITION',2,'Perseus / Scaife, Tufts University','Anonymous; Hugh G. Evelyn-White (editor and translator)','lang.en','1914','2026-08-14','https://scaife.perseus.org/library/urn%3Acts%3AgreekLit%3Atlg0013.tlg003.perseus-eng2/','urn:cts:greekLit:tlg0013.tlg003.perseus-eng2','urn:cts:greekLit:tlg0013.tlg003.perseus-eng2','Public-domain 1914 translation; Scaife presentation terms apply','Ancient Greek hymn through a 1914 English translation','Digital scholarly edition; claims remain witness-specific',0,'Attribute Perseus/Scaife and verify any substantial reuse',0,'source.greek.homeric_hymns.scaife','English translation aligned to an ancient Greek edition','URL_SYNTAX_VALID','Apollo, Delos, bow and oracle passages checked at lines 1-20 and 115-132.'),
('source.greek.homeric_hymn_hermes4.scaife','Homeric Hymn 4 to Hermes, Evelyn-White English text',NULL,'PRIMARY_TEXT_DIGITAL_EDITION',2,'Perseus / Scaife, Tufts University','Anonymous; Hugh G. Evelyn-White (editor and translator)','lang.en','1914','2026-08-14','https://scaife.perseus.org/reader/urn%3Acts%3AgreekLit%3Atlg0013.tlg004.perseus-eng2%3A1-140/','urn:cts:greekLit:tlg0013.tlg004.perseus-eng2','urn:cts:greekLit:tlg0013.tlg004.perseus-eng2','Public-domain 1914 translation; Scaife presentation terms apply','Ancient Greek hymn through a 1914 English translation','Digital scholarly edition; claims remain witness-specific',0,'Attribute Perseus/Scaife and verify any substantial reuse',0,'source.greek.homeric_hymns.scaife','English translation aligned to an ancient Greek edition','URL_SYNTAX_VALID','Hermes, Maia, messenger role and lyre-making checked at lines 1-55.'),
('source.greek.homeric_hymn_aphrodite5.scaife','Homeric Hymn 5 to Aphrodite, Evelyn-White English text',NULL,'PRIMARY_TEXT_DIGITAL_EDITION',2,'Perseus / Scaife, Tufts University','Anonymous; Hugh G. Evelyn-White (editor and translator)','lang.en','1914','2026-08-14','https://scaife.perseus.org/library/urn%3Acts%3AgreekLit%3Atlg0013.tlg005/','urn:cts:greekLit:tlg0013.tlg005.perseus-eng2','urn:cts:greekLit:tlg0013.tlg005.perseus-eng2','Public-domain 1914 translation; Scaife presentation terms apply','Ancient Greek hymn through a 1914 English translation','Digital scholarly edition; divine influence is a narrative claim within the hymn',0,'Attribute Perseus/Scaife and verify any substantial reuse',0,'source.greek.homeric_hymns.scaife','English translation aligned to an ancient Greek edition','URL_SYNTAX_VALID','Opening account of Aphrodite and the three exempt goddesses checked.'),
('source.greek.homeric_hymn_dionysus7.scaife','Homeric Hymn 7 to Dionysus, Evelyn-White English text',NULL,'PRIMARY_TEXT_DIGITAL_EDITION',2,'Perseus / Scaife, Tufts University','Anonymous; Hugh G. Evelyn-White (editor and translator)','lang.en','1914','2026-08-14','https://scaife.perseus.org/reader/urn%3Acts%3AgreekLit%3Atlg0013.tlg007.perseus-eng2%3A1-55/','urn:cts:greekLit:tlg0013.tlg007.perseus-eng2','urn:cts:greekLit:tlg0013.tlg007.perseus-eng2','Public-domain 1914 translation; Scaife presentation terms apply','Ancient Greek hymn through a 1914 English translation','Digital scholarly edition; miraculous events are mythic narrative',0,'Attribute Perseus/Scaife and verify any substantial reuse',0,'source.greek.homeric_hymns.scaife','English translation aligned to an ancient Greek edition','URL_SYNTAX_VALID','Dionysus, Semele and the pirate episode checked at lines 1-55.'),
('source.greek.homeric_hymn_ares8.scaife','Homeric Hymn 8 to Ares, Evelyn-White edition',NULL,'PRIMARY_TEXT_DIGITAL_EDITION',2,'Perseus / Scaife, Tufts University','Anonymous; Hugh G. Evelyn-White (editor and translator)','lang.grc','1914','2026-08-14','https://scaife.perseus.org/library/urn%3Acts%3AgreekLit%3Atlg0013.tlg008.perseus-grc2/','urn:cts:greekLit:tlg0013.tlg008.perseus-grc2','urn:cts:greekLit:tlg0013.tlg008.perseus-grc2','Public-domain 1914 edition; Scaife presentation terms apply','Ancient Greek hymn in a 1914 edition','Digital scholarly edition; closing prayer complicates a flat war-god label',0,'Attribute Perseus/Scaife and verify any substantial reuse',0,'source.greek.homeric_hymns.scaife','Ancient Greek edition with aligned English translation available','URL_SYNTAX_VALID','Martial titles and closing prayer checked at lines 1-17.'),
('source.greek.homeric_hymn_hephaestus20.scaife','Homeric Hymn 20 to Hephaestus, Evelyn-White English text',NULL,'PRIMARY_TEXT_DIGITAL_EDITION',2,'Perseus / Scaife, Tufts University','Anonymous; Hugh G. Evelyn-White (editor and translator)','lang.en','1914','2026-08-14','https://scaife.perseus.org/library/urn%3Acts%3AgreekLit%3Atlg0013.tlg020.perseus-eng2/','urn:cts:greekLit:tlg0013.tlg020.perseus-eng2','urn:cts:greekLit:tlg0013.tlg020.perseus-eng2','Public-domain 1914 translation; Scaife presentation terms apply','Ancient Greek hymn through a 1914 English translation','Digital scholarly edition; craft role is restricted to this witness',0,'Attribute Perseus/Scaife and verify any substantial reuse',0,'source.greek.homeric_hymns.scaife','English translation aligned to an ancient Greek edition','URL_SYNTAX_VALID','Hephaestus, Athena and craft instruction checked at lines 1-5.'),
('source.greek.homeric_hymn_poseidon22.scaife','Homeric Hymn 22 to Poseidon, Evelyn-White English text',NULL,'PRIMARY_TEXT_DIGITAL_EDITION',2,'Perseus / Scaife, Tufts University','Anonymous; Hugh G. Evelyn-White (editor and translator)','lang.en','1914','2026-08-14','https://scaife.perseus.org/reader/urn%3Acts%3AgreekLit%3Atlg0013.tlg022.perseus-eng2%3A1-7/','urn:cts:greekLit:tlg0013.tlg022.perseus-eng2','urn:cts:greekLit:tlg0013.tlg022.perseus-eng2','Public-domain 1914 translation; Scaife presentation terms apply','Ancient Greek hymn through a 1914 English translation','Digital scholarly edition; domains are witness-specific poetic attributions',0,'Attribute Perseus/Scaife and verify any substantial reuse',0,'source.greek.homeric_hymns.scaife','English translation aligned to an ancient Greek edition','URL_SYNTAX_VALID','Earth, sea, horses and ships checked at lines 1-7.'),
('source.greek.homeric_hymn_artemis27.scaife','Homeric Hymn 27 to Artemis, Evelyn-White English text',NULL,'PRIMARY_TEXT_DIGITAL_EDITION',2,'Perseus / Scaife, Tufts University','Anonymous; Hugh G. Evelyn-White (editor and translator)','lang.en','1914','2026-08-14','https://scaife.perseus.org/library/urn%3Acts%3AgreekLit%3Atlg0013.tlg027.perseus-eng2/','urn:cts:greekLit:tlg0013.tlg027.perseus-eng2','urn:cts:greekLit:tlg0013.tlg027.perseus-eng2','Public-domain 1914 translation; Scaife presentation terms apply','Ancient Greek hymn through a 1914 English translation','Digital scholarly edition; hunting imagery is witness-specific',0,'Attribute Perseus/Scaife and verify any substantial reuse',0,'source.greek.homeric_hymns.scaife','English translation aligned to an ancient Greek edition','URL_SYNTAX_VALID','Artemis, archery, hounds, deer, Apollo and Delphi checked at lines 1-20.'),
('source.greek.homeric_hymn_athena28.scaife','Homeric Hymn 28 to Athena, Evelyn-White English text',NULL,'PRIMARY_TEXT_DIGITAL_EDITION',2,'Perseus / Scaife, Tufts University','Anonymous; Hugh G. Evelyn-White (editor and translator)','lang.en','1914','2026-08-14','https://scaife.perseus.org/reader/urn%3Acts%3AgreekLit%3Atlg0013.tlg028.perseus-eng2%3A1-18/','urn:cts:greekLit:tlg0013.tlg028.perseus-eng2','urn:cts:greekLit:tlg0013.tlg028.perseus-eng2','Public-domain 1914 translation; Scaife presentation terms apply','Ancient Greek hymn through a 1914 English translation','Digital scholarly edition; birth and armor are mythic narrative',0,'Attribute Perseus/Scaife and verify any substantial reuse',0,'source.greek.homeric_hymns.scaife','English translation aligned to an ancient Greek edition','URL_SYNTAX_VALID','Birth from Zeus and martial equipment checked at lines 1-18.');

INSERT OR IGNORE INTO entities(
  id,canonical_name,name_zh,original_name,transliteration,primary_type,
  primary_civilization_id,primary_region_id,historical_period,description,
  research_status,evidence_status,record_version,metadata_json,created_at,updated_at
) VALUES
('deity.greek.leto','Leto','勒托','Λητώ','Lētō','DEITY','civ.greek','region.europe','Archaic Greek textual tradition','阿波罗与阿耳忒弥斯的母亲；本检查点仅登记赫西俄德与《荷马颂歌》中的见证。 / Mother of Apollo and Artemis in the registered Hesiodic and hymnic witnesses.','PARTIAL','UNVERIFIED',1,'{"scope_caution":"witness-specific genealogy"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.maia','Maia','迈亚','Μαῖα','Maia','DEITY','civ.greek','region.europe','Archaic Greek textual tradition','赫尔墨斯之母；不同传统层需要逐条登记。 / Mother of Hermes in the registered witnesses; later layers remain separate.','PARTIAL','UNVERIFIED',1,'{"scope_caution":"witness-specific genealogy"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.semele','Semele','塞墨勒','Σεμέλη','Semelē','DEITY','civ.greek','region.europe','Archaic Greek textual tradition','狄俄倪索斯的凡人母亲之一种古代叙事见证。 / Mortal mother of Dionysus in the registered ancient witnesses.','PARTIAL','UNVERIFIED',1,'{"scope_caution":"mythic genealogy, not historical biography"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.dione','Dione','狄俄涅','Διώνη','Diōnē','DEITY','civ.greek','region.europe','Archaic Greek textual tradition','《伊利亚特》第5卷称阿佛洛狄忒投入其母狄俄涅怀中；该谱系与赫西俄德起源叙事并存。 / The Iliad names Dione as Aphrodite’s mother; this coexists with the Hesiodic origin account.','PARTIAL','UNVERIFIED',1,'{"variant_caution":"Iliadic Aphrodite genealogy"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('deity.greek.persephone','Persephone','珀耳塞福涅','Περσεφόνη','Persephonē','DEITY','civ.greek','region.europe','Archaic Greek textual tradition','《神谱》与《荷马颂歌·致得墨忒耳》中的得墨忒耳之女；冥界叙事按文本版本保存。 / Daughter of Demeter in the registered Theogony and Hymn to Demeter witnesses.','PARTIAL','UNVERIFIED',1,'{"scope_caution":"abduction and return accounts are witness-specific"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('event.greek.persephone_abduction','Abduction of Persephone','珀耳塞福涅被劫','ἁρπαγὴ Περσεφόνης','harpagē Persephonēs','EVENT','civ.greek','region.europe','Archaic Greek textual tradition','《荷马颂歌·致得墨忒耳》所叙珀耳塞福涅被哈得斯劫往冥界、得墨忒耳寻找女儿的事件层。 / Hymnic event layer for Persephone’s abduction and Demeter’s search.','PARTIAL','UNVERIFIED',1,'{"reality_status":"MYTHIC_NARRATIVE","witness":"Homeric Hymn 2"}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('text.greek.homeric_hymn_apollo_3','Homeric Hymn 3 to Apollo','《荷马颂歌·致阿波罗》（第3首）','Εἰς Ἀπόλλωνα','Eis Apollōna','TEXT','civ.greek','region.europe','Archaic Greek poetic tradition','阿波罗的提洛岛诞生、弓、琴与神谕中心的主要古代文本见证。 / Major ancient witness for Apollo’s Delian birth, bow, lyre and oracle.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('text.greek.homeric_hymn_hermes_4','Homeric Hymn 4 to Hermes','《荷马颂歌·致赫尔墨斯》（第4首）','Εἰς Ἑρμῆν','Eis Hermēn','TEXT','civ.greek','region.europe','Archaic Greek poetic tradition','赫尔墨斯诞生、制琴、盗牛与神使身份的古代文本见证。 / Ancient witness for Hermes’s birth, lyre-making, cattle theft and messenger role.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('text.greek.homeric_hymn_aphrodite_5','Homeric Hymn 5 to Aphrodite','《荷马颂歌·致阿佛洛狄忒》（第5首）','Εἰς Ἀφροδίτην','Eis Aphroditēn','TEXT','civ.greek','region.europe','Archaic Greek poetic tradition','阿佛洛狄忒影响众神与生灵、以及例外范围的古代文本见证。 / Ancient witness for Aphrodite’s influence and its stated exceptions.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('text.greek.homeric_hymn_dionysus_7','Homeric Hymn 7 to Dionysus','《荷马颂歌·致狄俄倪索斯》（第7首）','Εἰς Διόνυσον','Eis Dionyson','TEXT','civ.greek','region.europe','Archaic Greek poetic tradition','狄俄倪索斯与海盗故事的古代文本见证。 / Ancient witness for Dionysus and the pirate episode.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('text.greek.homeric_hymn_ares_8','Homeric Hymn 8 to Ares','《荷马颂歌·致阿瑞斯》（第8首）','Εἰς Ἄρην','Eis Arēn','TEXT','civ.greek','region.europe','Ancient Greek hymn tradition','阿瑞斯的武力称号与克制、和平祈愿并见的短颂歌。 / Short hymn combining martial titles with a prayer for restraint and peace.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('text.greek.homeric_hymn_hephaestus_20','Homeric Hymn 20 to Hephaestus','《荷马颂歌·致赫淮斯托斯》（第20首）','Εἰς Ἥφαιστον','Eis Hēphaiston','TEXT','civ.greek','region.europe','Ancient Greek hymn tradition','赫淮斯托斯、雅典娜与工艺教导的短颂歌见证。 / Short hymnic witness for Hephaestus, Athena and craft instruction.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('text.greek.homeric_hymn_poseidon_22','Homeric Hymn 22 to Poseidon','《荷马颂歌·致波塞冬》（第22首）','Εἰς Ποσειδῶνα','Eis Poseidōna','TEXT','civ.greek','region.europe','Ancient Greek hymn tradition','波塞冬与大地、海洋、马匹和船只的短颂歌见证。 / Short hymnic witness linking Poseidon with earth, sea, horses and ships.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('text.greek.homeric_hymn_artemis_27','Homeric Hymn 27 to Artemis','《荷马颂歌·致阿耳忒弥斯》（第27首）','Εἰς Ἄρτεμιν','Eis Artemin','TEXT','civ.greek','region.europe','Ancient Greek hymn tradition','阿耳忒弥斯的弓箭、猎犬、鹿与阿波罗关系的颂歌见证。 / Hymnic witness for Artemis’s archery, hounds, deer and relation to Apollo.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('text.greek.homeric_hymn_athena_28','Homeric Hymn 28 to Athena','《荷马颂歌·致雅典娜》（第28首）','Εἰς Ἀθηνᾶν','Eis Athēnan','TEXT','civ.greek','region.europe','Ancient Greek hymn tradition','雅典娜从宙斯头部出生并披挂武装的颂歌见证。 / Hymnic witness for Athena’s birth from Zeus’s head and martial equipment.','PARTIAL','UNVERIFIED',1,'{}','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z');

INSERT OR IGNORE INTO entity_classifications(entity_id,type_code,is_primary,notes)
SELECT id,primary_type,1,'v0.5.0 primary-source profile checkpoint'
FROM entities WHERE id IN (
  'deity.greek.leto','deity.greek.maia','deity.greek.semele','deity.greek.dione','deity.greek.persephone',
  'event.greek.persephone_abduction','text.greek.homeric_hymn_apollo_3','text.greek.homeric_hymn_hermes_4',
  'text.greek.homeric_hymn_aphrodite_5','text.greek.homeric_hymn_dionysus_7','text.greek.homeric_hymn_ares_8',
  'text.greek.homeric_hymn_hephaestus_20','text.greek.homeric_hymn_poseidon_22',
  'text.greek.homeric_hymn_artemis_27','text.greek.homeric_hymn_athena_28'
);

INSERT OR IGNORE INTO entity_civilizations(entity_id,civilization_id,association_role,certainty,notes)
SELECT id,'civ.greek','ORIGIN','SUPPORTED','Registered within the ancient Greek textual baseline'
FROM entities WHERE id IN (
  'deity.greek.leto','deity.greek.maia','deity.greek.semele','deity.greek.dione','deity.greek.persephone',
  'event.greek.persephone_abduction','text.greek.homeric_hymn_apollo_3','text.greek.homeric_hymn_hermes_4',
  'text.greek.homeric_hymn_aphrodite_5','text.greek.homeric_hymn_dionysus_7','text.greek.homeric_hymn_ares_8',
  'text.greek.homeric_hymn_hephaestus_20','text.greek.homeric_hymn_poseidon_22',
  'text.greek.homeric_hymn_artemis_27','text.greek.homeric_hymn_athena_28'
);

UPDATE entities SET original_name='Ζεύς',transliteration='Zeus',description='希腊文本传统中的神王；当前页面分别连接雷霆、奥林匹亚、提丰之战和赫西俄德家谱证据。 / Divine ruler in registered Greek textual and cult evidence.',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z' WHERE id='deity.greek.zeus';
UPDATE entities SET original_name='Ἥρα',transliteration='Hēra',description='《神谱》所见克洛诺斯与瑞亚之女，并在该见证中成为宙斯的配偶与阿瑞斯、赫淮斯托斯谱系的一环。 / Hera in the registered Hesiodic genealogy.',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z' WHERE id='deity.greek.hera';
UPDATE entities SET original_name='Ποσειδῶν',transliteration='Poseidōn',description='《神谱》家谱中的克洛诺斯与瑞亚之子；第22首《荷马颂歌》联系大地、海洋、马与船。 / Son of Cronus and Rhea; linked with earth, sea, horses and ships in Hymn 22.',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z' WHERE id='deity.greek.poseidon';
UPDATE entities SET original_name='Ἅιδης',transliteration='Haidēs',description='《神谱》家谱中的克洛诺斯与瑞亚之子；《荷马颂歌·致得墨忒耳》中的冥界统治者与劫掠者。 / Son of Cronus and Rhea and underworld ruler in the Hymn to Demeter.',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z' WHERE id='deity.greek.hades';
UPDATE entities SET original_name='Ἀθηνᾶ',transliteration='Athēna',description='赫西俄德与颂歌传统中从宙斯而生、具武装与城邦守护层面的女神；埃癸斯证据另接《伊利亚特》。 / Armed daughter of Zeus and city guardian in registered witnesses.',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z' WHERE id='deity.greek.athena';
UPDATE entities SET original_name='Ἀπόλλων',transliteration='Apollōn',description='勒托与宙斯之子；第3首《荷马颂歌》连接提洛岛诞生、弓、琴与神谕。 / Son of Leto and Zeus; Hymn 3 connects his Delian birth, bow, lyre and oracle.',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z' WHERE id='deity.greek.apollo';
UPDATE entities SET original_name='Ἄρτεμις',transliteration='Artemis',description='勒托与宙斯之女；第27首《荷马颂歌》描绘其弓箭、猎犬、鹿与阿波罗关系。 / Daughter of Leto and Zeus; Hymn 27 depicts archery, hounds and deer.',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z' WHERE id='deity.greek.artemis';
UPDATE entities SET original_name='Ἑρμῆς',transliteration='Hermēs',description='宙斯与迈亚之子；第4首《荷马颂歌》叙其诞生、制琴、盗牛与神使身份。 / Son of Zeus and Maia; Hymn 4 narrates his birth, lyre-making, cattle theft and messenger role.',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z' WHERE id='deity.greek.hermes';
UPDATE entities SET original_name='Ἄρης',transliteration='Arēs',description='宙斯与赫拉之子；第8首颂歌同时保存武力称号与克制、和平祈愿。 / Son of Zeus and Hera; Hymn 8 combines martial titles with a prayer for restraint.',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z' WHERE id='deity.greek.ares';
UPDATE entities SET original_name='Ἀφροδίτη',transliteration='Aphroditē',description='爱欲女神；赫西俄德起源叙事与《伊利亚特》的宙斯—狄俄涅谱系作为冲突版本并存。 / Goddess of desire; the Hesiodic origin and Iliadic Zeus–Dione genealogy remain coexisting variants.',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z',metadata_json='{"variant_caution":"Hesiodic and Iliadic origins coexist; no automatic resolution"}' WHERE id='deity.greek.aphrodite';
UPDATE entities SET original_name='Ἥφαιστος',transliteration='Hēphaistos',description='赫西俄德家谱中赫拉独自产生之神；第20首颂歌与雅典娜共同关联工艺教导。 / Born from Hera alone in the registered Hesiodic witness; linked with craft instruction in Hymn 20.',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z' WHERE id='deity.greek.hephaestus';
UPDATE entities SET original_name='Δημήτηρ',transliteration='Dēmētēr',description='克洛诺斯与瑞亚之女、珀耳塞福涅之母；第2首颂歌连接寻找女儿与厄琉西斯仪式叙事。 / Daughter of Cronus and Rhea and mother of Persephone in registered witnesses.',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z' WHERE id='deity.greek.demeter';
UPDATE entities SET original_name='Διόνυσος',transliteration='Dionysos',description='宙斯与塞墨勒之子；第7首《荷马颂歌》保存海盗事件的神话叙事。 / Son of Zeus and Semele; Hymn 7 preserves the pirate episode.',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z' WHERE id='deity.greek.dionysus';
UPDATE entities SET original_name='Γαῖα',transliteration='Gaia',description='《神谱》宇宙起源与家谱中的大地神；本版本连接乌拉诺斯与克洛诺斯谱系。 / Earth deity in Hesiodic cosmogony and genealogy.',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z' WHERE id='deity.greek.gaia';
UPDATE entities SET original_name='Οὐρανός',transliteration='Ouranos',description='《神谱》中由盖亚生出的星空之天，并为泰坦谱系的父辈。 / Starry Heaven born from Gaia and parent in the Titan genealogy in the registered Hesiodic witness.',record_version=record_version+1,updated_at='2026-08-14T00:00:00Z' WHERE id='deity.greek.uranus';

INSERT OR IGNORE INTO names(id,entity_id,name_text,normalized_text,language_id,script_name,name_type,is_preferred,source_id,notes) VALUES
('name.v050.zeus.grc','deity.greek.zeus','Ζεύς','ζεύς','lang.grc','Greek','ORIGINAL',1,'source.greek.theogony.perseus_eng1','Ancient Greek name'),
('name.v050.hera.grc','deity.greek.hera','Ἥρα','ἥρα','lang.grc','Greek','ORIGINAL',1,'source.greek.theogony.perseus_eng1','Ancient Greek name'),
('name.v050.poseidon.grc','deity.greek.poseidon','Ποσειδῶν','ποσειδῶν','lang.grc','Greek','ORIGINAL',1,'source.greek.homeric_hymn_poseidon22.scaife','Ancient Greek name'),
('name.v050.hades.grc','deity.greek.hades','Ἅιδης','ἅιδης','lang.grc','Greek','ORIGINAL',1,'source.greek.homeric_hymn_demeter.scaife','Ancient Greek name'),
('name.v050.athena.grc','deity.greek.athena','Ἀθηνᾶ','ἀθηνᾶ','lang.grc','Greek','ORIGINAL',1,'source.greek.homeric_hymn_athena28.scaife','Ancient Greek name'),
('name.v050.apollo.grc','deity.greek.apollo','Ἀπόλλων','ἀπόλλων','lang.grc','Greek','ORIGINAL',1,'source.greek.homeric_hymn_apollo3.scaife','Ancient Greek name'),
('name.v050.artemis.grc','deity.greek.artemis','Ἄρτεμις','ἄρτεμις','lang.grc','Greek','ORIGINAL',1,'source.greek.homeric_hymn_artemis27.scaife','Ancient Greek name'),
('name.v050.hermes.grc','deity.greek.hermes','Ἑρμῆς','ἑρμῆς','lang.grc','Greek','ORIGINAL',1,'source.greek.homeric_hymn_hermes4.scaife','Ancient Greek name'),
('name.v050.ares.grc','deity.greek.ares','Ἄρης','ἄρης','lang.grc','Greek','ORIGINAL',1,'source.greek.homeric_hymn_ares8.scaife','Ancient Greek name'),
('name.v050.aphrodite.grc','deity.greek.aphrodite','Ἀφροδίτη','ἀφροδίτη','lang.grc','Greek','ORIGINAL',1,'source.greek.homeric_hymn_aphrodite5.scaife','Ancient Greek name'),
('name.v050.hephaestus.grc','deity.greek.hephaestus','Ἥφαιστος','ἥφαιστος','lang.grc','Greek','ORIGINAL',1,'source.greek.homeric_hymn_hephaestus20.scaife','Ancient Greek name'),
('name.v050.demeter.grc','deity.greek.demeter','Δημήτηρ','δημήτηρ','lang.grc','Greek','ORIGINAL',1,'source.greek.homeric_hymn_demeter.scaife','Ancient Greek name'),
('name.v050.dionysus.grc','deity.greek.dionysus','Διόνυσος','διόνυσος','lang.grc','Greek','ORIGINAL',1,'source.greek.homeric_hymn_dionysus7.scaife','Ancient Greek name');

INSERT OR IGNORE INTO names(id,entity_id,name_text,normalized_text,language_id,script_name,name_type,is_preferred,source_id,notes)
SELECT 'name.v050.' || replace(id,'.','_') || '.en',id,canonical_name,lower(canonical_name),'lang.en','Latin','CANONICAL',1,NULL,'v0.5.0 canonical reading label'
FROM entities WHERE id IN ('deity.greek.leto','deity.greek.maia','deity.greek.semele','deity.greek.dione','deity.greek.persephone','event.greek.persephone_abduction','text.greek.homeric_hymn_apollo_3','text.greek.homeric_hymn_hermes_4','text.greek.homeric_hymn_aphrodite_5','text.greek.homeric_hymn_dionysus_7','text.greek.homeric_hymn_ares_8','text.greek.homeric_hymn_hephaestus_20','text.greek.homeric_hymn_poseidon_22','text.greek.homeric_hymn_artemis_27','text.greek.homeric_hymn_athena_28');

INSERT OR IGNORE INTO names(id,entity_id,name_text,normalized_text,language_id,script_name,name_type,is_preferred,source_id,notes)
SELECT 'name.v050.' || replace(id,'.','_') || '.zh',id,name_zh,name_zh,'lang.zh','Han','TRANSLATION',1,NULL,'v0.5.0 Chinese reading label'
FROM entities WHERE id IN ('deity.greek.leto','deity.greek.maia','deity.greek.semele','deity.greek.dione','deity.greek.persephone','event.greek.persephone_abduction','text.greek.homeric_hymn_apollo_3','text.greek.homeric_hymn_hermes_4','text.greek.homeric_hymn_aphrodite_5','text.greek.homeric_hymn_dionysus_7','text.greek.homeric_hymn_ares_8','text.greek.homeric_hymn_hephaestus_20','text.greek.homeric_hymn_poseidon_22','text.greek.homeric_hymn_artemis_27','text.greek.homeric_hymn_athena_28');

INSERT OR IGNORE INTO deity_profiles(entity_id,deity_class,pantheon_or_family,rank_or_status,domains_json,powers_json,limitations_json,appearance_json,symbols_json,cult_summary,final_fate_summary) VALUES
('deity.greek.leto','DEITY','Hesiodic and hymnic genealogy',NULL,'["母系谱系 / maternal genealogy"]','[]','["本检查点不外推全部地方传统 / local variants not generalized"]','{}','[]',NULL,NULL),
('deity.greek.maia','DEITY','Hesiodic and hymnic genealogy',NULL,'["赫尔墨斯母系谱系 / Hermes genealogy"]','[]','["后世层需另证 / later layers require separate evidence"]','{}','[]',NULL,NULL),
('deity.greek.semele','MORTAL_DIVINE_MOTHER','Hesiodic and hymnic genealogy',NULL,'["狄俄倪索斯母系谱系 / Dionysus genealogy"]','[]','["神话叙事不等于历史传记 / mythic narrative is not historical biography"]','{}','[]',NULL,NULL),
('deity.greek.dione','DEITY','Iliadic genealogy',NULL,'["阿佛洛狄忒母系谱系 / Aphrodite genealogy"]','[]','["与赫西俄德起源版本并存 / coexists with Hesiodic origin"]','{}','[]',NULL,NULL),
('deity.greek.persephone','DEITY','Children of Demeter and Zeus in Hesiod',NULL,'["冥界叙事 / underworld narrative","母女关系 / mother–daughter relation"]','[]','["劫掠与归返细节随见证而异 / details vary by witness"]','{}','[]','厄琉西斯关联目前只按颂歌文本范围陈述。 / Eleusinian association is currently scoped to the hymn witness.',NULL);

UPDATE deity_profiles SET pantheon_or_family='Children of Cronus and Rhea',rank_or_status='Divine ruler in registered witnesses',domains_json='["天空与雷霆 / sky and thunder","王权 / divine kingship"]',powers_json='["雷霆武器 / thunderbolt in tradition"]',limitations_json='["不同诗歌和地方传统不构成单一固定神谱 / witnesses do not form one fixed pantheon"]',appearance_json='{}',symbols_json='["雷霆 / thunderbolt"]',cult_summary='奥林匹亚的历史崇拜另由 UNESCO 官方资料支持。 / Historical worship at Olympia is separately supported by UNESCO.' WHERE entity_id='deity.greek.zeus';
UPDATE deity_profiles SET pantheon_or_family='Children of Cronus and Rhea',rank_or_status='Consort of Zeus in the registered Hesiodic witness',domains_json='["婚姻与王后身份（文本传统） / marriage and queenship in textual tradition"]',powers_json='[]',limitations_json='["谱系与亲子版本需按见证区分 / genealogical variants require witness-level records"]',appearance_json='{}',symbols_json='[]',cult_summary=NULL WHERE entity_id='deity.greek.hera';
UPDATE deity_profiles SET pantheon_or_family='Children of Cronus and Rhea',rank_or_status='God of sea and earth in Hymn 22',domains_json='["海洋 / sea","大地 / earth","马匹与船只 / horses and ships"]',powers_json='[]',limitations_json='["三叉戟关系当前主要由图像馆藏证据支持 / trident relation is presently iconographic"]',appearance_json='{}',symbols_json='["三叉戟 / trident","马 / horse","船 / ship"]',cult_summary=NULL WHERE entity_id='deity.greek.poseidon';
UPDATE deity_profiles SET pantheon_or_family='Children of Cronus and Rhea',rank_or_status='Underworld ruler in Hymn 2',domains_json='["冥界 / underworld"]',powers_json='[]',limitations_json='["不可把冥界叙事直接当作历史现实 / mythic event is not historical reality"]',appearance_json='{}',symbols_json='[]',cult_summary=NULL WHERE entity_id='deity.greek.hades';
UPDATE deity_profiles SET pantheon_or_family='Daughter of Zeus; Metis genealogy registered separately',rank_or_status='City guardian and armed goddess in registered hymns',domains_json='["城邦守护 / city protection","战争与救援 / war and protection","工艺 / crafts"]',powers_json='[]',limitations_json='["出生细节在古代见证中需分别保存 / birth details remain witness-specific"]',appearance_json='{"hymn_28":"armed with spear and aegis / 持矛与埃癸斯"}',symbols_json='["埃癸斯 / aegis","长矛 / spear"]',cult_summary=NULL WHERE entity_id='deity.greek.athena';
UPDATE deity_profiles SET pantheon_or_family='Child of Leto and Zeus',rank_or_status=NULL,domains_json='["弓箭 / archery","琴乐 / lyre music","神谕 / oracle"]',powers_json='[]',limitations_json='["本版本不将阿波罗与赫利俄斯自动等同 / not automatically identified with Helios"]',appearance_json='{}',symbols_json='["弓 / bow","琴 / lyre"]',cult_summary='提洛岛诞生与德尔斐崇拜分别由文本和 UNESCO 来源登记。 / Delian birth and Delphic worship use separate textual and official sources.' WHERE entity_id='deity.greek.apollo';
UPDATE deity_profiles SET pantheon_or_family='Child of Leto and Zeus',rank_or_status=NULL,domains_json='["狩猎 / hunting","弓箭 / archery","野生动物 / wild animals"]',powers_json='[]',limitations_json='["本版本不将阿耳忒弥斯与塞勒涅自动等同 / not automatically identified with Selene"]',appearance_json='{"hymn_27":"golden-shafted archer / 金箭女射手"}',symbols_json='["弓 / bow","猎犬 / hounds","鹿 / deer"]',cult_summary=NULL WHERE entity_id='deity.greek.artemis';
UPDATE deity_profiles SET pantheon_or_family='Child of Maia and Zeus',rank_or_status='Messenger in Hymn 4',domains_json='["神使 / messenger role","琴乐发明 / lyre-making"]',powers_json='[]',limitations_json='["神杖传统尚待独立图像与文本证据 / caduceus tradition remains queued"]',appearance_json='{}',symbols_json='["琴 / lyre"]',cult_summary=NULL WHERE entity_id='deity.greek.hermes';
UPDATE deity_profiles SET pantheon_or_family='Child of Hera and Zeus in Hesiod',rank_or_status=NULL,domains_json='["战争与武力称号 / war and martial titles"]',powers_json='[]',limitations_json='["第8首颂歌也祈求克制与和平，不能压平为单一标签 / Hymn 8 also asks for restraint and peace"]',appearance_json='{}',symbols_json='[]',cult_summary=NULL WHERE entity_id='deity.greek.ares';
UPDATE deity_profiles SET pantheon_or_family='Conflicting Hesiodic and Iliadic origins',rank_or_status=NULL,domains_json='["爱欲与结合 / desire and union"]',powers_json='["第5首颂歌中的神与生灵影响范围 / influence over gods and creatures in Hymn 5"]',limitations_json='["颂歌明确列出雅典娜、阿耳忒弥斯、赫斯提亚等例外 / hymn names explicit exceptions","谱系版本不合并 / genealogical variants remain separate"]',appearance_json='{}',symbols_json='[]',cult_summary=NULL WHERE entity_id='deity.greek.aphrodite';
UPDATE deity_profiles SET pantheon_or_family='Child of Hera alone in the registered Hesiodic witness',rank_or_status=NULL,domains_json='["工艺与发明 / crafts and inventions"]',powers_json='[]',limitations_json='["父母版本需要后续逐文本对照 / alternate parentage remains queued"]',appearance_json='{}',symbols_json='[]',cult_summary=NULL WHERE entity_id='deity.greek.hephaestus';
UPDATE deity_profiles SET pantheon_or_family='Child of Cronus and Rhea; mother of Persephone',rank_or_status=NULL,domains_json='["谷物与丰饶叙事 / grain and fertility narrative","母女与寻找叙事 / mother–daughter search"]',powers_json='[]',limitations_json='["厄琉西斯仪式的历史实践需与诗歌叙事分层 / historical ritual must remain separate from poetic witness"]',appearance_json='{}',symbols_json='[]',cult_summary='第2首颂歌记录厄琉西斯仪式传统；考古与铭文证据仍在队列。 / Hymn 2 records an Eleusinian ritual tradition; archaeology and inscriptions remain queued.' WHERE entity_id='deity.greek.demeter';
UPDATE deity_profiles SET pantheon_or_family='Child of Semele and Zeus',rank_or_status=NULL,domains_json='["酒神叙事 / Dionysian narrative"]',powers_json='["第7首颂歌中的海上显现与变形 / maritime epiphany and transformations in Hymn 7"]',limitations_json='["地方酒神传统与仪式尚未由本批覆盖 / local cults and rites are not covered by this batch"]',appearance_json='{}',symbols_json='["藤蔓 / vine in Hymn 7"]',cult_summary=NULL WHERE entity_id='deity.greek.dionysus';
UPDATE deity_profiles SET pantheon_or_family='Hesiodic cosmogony',rank_or_status='Primordial earth deity',domains_json='["大地 / earth","宇宙生成 / cosmogony"]',powers_json='[]',limitations_json='["比较用“大地”标签不表示与其他文明地神同一 / comparative earth label does not imply identity"]',appearance_json='{}',symbols_json='[]',cult_summary=NULL WHERE entity_id='deity.greek.gaia';
UPDATE deity_profiles SET pantheon_or_family='Child of Gaia; parent in the Titan genealogy',rank_or_status='Primordial sky deity',domains_json='["星空之天 / starry heaven"]',powers_json='[]',limitations_json='["拉丁化 Uranus 与希腊 Ouranos 作为同一规范实体的名称层保存 / transliterations are name layers"]',appearance_json='{}',symbols_json='[]',cult_summary=NULL WHERE entity_id='deity.greek.uranus';

UPDATE artifact_profiles SET artifact_type='DIVINE_ARMOR',appearance_json='{"iliad_5":"Athena wears the tasselled aegis / 雅典娜披挂流苏埃癸斯"}',abilities_json='[]',limitations_json='["术语含义与物件形态需按文本和图像分别研究 / form and terminology remain witness-specific"]',usage_conditions_json='[]',creation_summary=NULL,fate_summary=NULL WHERE entity_id='artifact.greek.aegis';
UPDATE artifact_profiles SET artifact_type='DIVINE_BOW',appearance_json='{"hymn_3":"Apollo carries a curved bow / 阿波罗持弯弓"}',abilities_json='[]',limitations_json='["不从一首颂歌外推全部能力 / no unsourced power extrapolation"]',usage_conditions_json='[]' WHERE entity_id='weapon.greek.apollo_bow';
UPDATE artifact_profiles SET artifact_type='DIVINE_BOW',appearance_json='{"hymn_27":"golden shafts / 金箭"}',abilities_json='[]',limitations_json='["不从一首颂歌外推全部能力 / no unsourced power extrapolation"]',usage_conditions_json='[]' WHERE entity_id='weapon.greek.artemis_bow';

INSERT OR IGNORE INTO text_profiles(entity_id,text_type,original_language_id,attributed_author,compiler,composition_period,earliest_extant_witness,chapter_structure,repository,shelfmark,copyright_status,summary)
SELECT id,'HYMN','lang.grc','Anonymous Homeric Hymn tradition',NULL,'Ancient Greek poetic tradition; individual dating debated',NULL,
  CASE id
    WHEN 'text.greek.homeric_hymn_apollo_3' THEN 'Hymn 3'
    WHEN 'text.greek.homeric_hymn_hermes_4' THEN 'Hymn 4'
    WHEN 'text.greek.homeric_hymn_aphrodite_5' THEN 'Hymn 5'
    WHEN 'text.greek.homeric_hymn_dionysus_7' THEN 'Hymn 7, 59 lines'
    WHEN 'text.greek.homeric_hymn_ares_8' THEN 'Hymn 8, 17 lines'
    WHEN 'text.greek.homeric_hymn_hephaestus_20' THEN 'Hymn 20, 8 lines'
    WHEN 'text.greek.homeric_hymn_poseidon_22' THEN 'Hymn 22, 7 lines'
    WHEN 'text.greek.homeric_hymn_artemis_27' THEN 'Hymn 27, 22 lines'
    ELSE 'Hymn 28, 18 lines' END,
  'Perseus / Scaife digital edition',
  CASE id
    WHEN 'text.greek.homeric_hymn_apollo_3' THEN 'urn:cts:greekLit:tlg0013.tlg003'
    WHEN 'text.greek.homeric_hymn_hermes_4' THEN 'urn:cts:greekLit:tlg0013.tlg004'
    WHEN 'text.greek.homeric_hymn_aphrodite_5' THEN 'urn:cts:greekLit:tlg0013.tlg005'
    WHEN 'text.greek.homeric_hymn_dionysus_7' THEN 'urn:cts:greekLit:tlg0013.tlg007'
    WHEN 'text.greek.homeric_hymn_ares_8' THEN 'urn:cts:greekLit:tlg0013.tlg008'
    WHEN 'text.greek.homeric_hymn_hephaestus_20' THEN 'urn:cts:greekLit:tlg0013.tlg020'
    WHEN 'text.greek.homeric_hymn_poseidon_22' THEN 'urn:cts:greekLit:tlg0013.tlg022'
    WHEN 'text.greek.homeric_hymn_artemis_27' THEN 'urn:cts:greekLit:tlg0013.tlg027'
    ELSE 'urn:cts:greekLit:tlg0013.tlg028' END,
  'Ancient text public domain; digital presentation terms apply',description
FROM entities WHERE id LIKE 'text.greek.homeric_hymn_%' AND id IN (
  'text.greek.homeric_hymn_apollo_3','text.greek.homeric_hymn_hermes_4','text.greek.homeric_hymn_aphrodite_5',
  'text.greek.homeric_hymn_dionysus_7','text.greek.homeric_hymn_ares_8','text.greek.homeric_hymn_hephaestus_20',
  'text.greek.homeric_hymn_poseidon_22','text.greek.homeric_hymn_artemis_27','text.greek.homeric_hymn_athena_28'
);

INSERT OR IGNORE INTO myth_event_profiles(entity_id,event_type,time_layer,cause_summary,process_summary,result_summary,symbolism_summary) VALUES
('event.greek.persephone_abduction','UNDERWORLD_JOURNEY','Mythic time in Homeric Hymn 2','Hades takes Persephone with Zeus’s consent in this hymn witness.','Persephone is taken below; Demeter searches, consults Hecate and Helios, and comes to Eleusis.','The hymn continues through return arrangements and the establishment of mysteries; later versions require separate claims.','No single universal interpretation is imposed.');
UPDATE myth_event_profiles SET time_layer='Mythic divine-war time in the Hesiodic witness',cause_summary='Conflict between the younger gods led by Zeus and the Titans associated with Cronus.',process_summary='Theogony 617-735 narrates release of the Hundred-Handers, battle and use of Zeus’s thunder and lightning.',result_summary='The Titans are defeated and confined in Tartarus in this witness.',symbolism_summary='Interpretations remain separate from the text-level event record.' WHERE entity_id='event.greek.titanomachy';

INSERT OR IGNORE INTO claims(
  id,subject_id,predicate,object_entity_id,object_literal,object_datatype,statement,
  variant_group,claim_status,confidence,confidence_level,review_status,
  assertion_scope,knowledge_layer,tradition_scope,temporal_scope,research_notes,created_at
) VALUES
('claim.v050.h3.text_mentions_apollo','text.greek.homeric_hymn_apollo_3','MENTIONS','deity.greek.apollo',NULL,NULL,'Homeric Hymn 3 is addressed to Apollo and narrates major Delian and Pythian episodes.','homeric_hymn.3','SUPPORTED',1.0,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 3','lines 1-20; 115-132','Subwork-level catalogue relation.','2026-08-14T00:00:00Z'),
('claim.v050.h4.text_mentions_hermes','text.greek.homeric_hymn_hermes_4','MENTIONS','deity.greek.hermes',NULL,NULL,'Homeric Hymn 4 is addressed to Hermes and narrates his birth and early deeds.','homeric_hymn.4','SUPPORTED',1.0,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 4','lines 1-55','Subwork-level catalogue relation.','2026-08-14T00:00:00Z'),
('claim.v050.h5.text_mentions_aphrodite','text.greek.homeric_hymn_aphrodite_5','MENTIONS','deity.greek.aphrodite',NULL,NULL,'Homeric Hymn 5 is addressed to Aphrodite.','homeric_hymn.5','SUPPORTED',1.0,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 5','lines 1-33','Subwork-level catalogue relation.','2026-08-14T00:00:00Z'),
('claim.v050.h7.text_mentions_dionysus','text.greek.homeric_hymn_dionysus_7','MENTIONS','deity.greek.dionysus',NULL,NULL,'Homeric Hymn 7 narrates Dionysus’s encounter with pirates.','homeric_hymn.7','SUPPORTED',1.0,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 7','lines 1-55','Subwork-level catalogue relation.','2026-08-14T00:00:00Z'),
('claim.v050.h8.text_mentions_ares','text.greek.homeric_hymn_ares_8','MENTIONS','deity.greek.ares',NULL,NULL,'Homeric Hymn 8 is addressed to Ares.','homeric_hymn.8','SUPPORTED',1.0,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 8','lines 1-17','Subwork-level catalogue relation.','2026-08-14T00:00:00Z'),
('claim.v050.h20.text_mentions_hephaestus','text.greek.homeric_hymn_hephaestus_20','MENTIONS','deity.greek.hephaestus',NULL,NULL,'Homeric Hymn 20 is addressed to Hephaestus and names Athena in connection with crafts.','homeric_hymn.20','SUPPORTED',1.0,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 20','lines 1-5','Subwork-level catalogue relation.','2026-08-14T00:00:00Z'),
('claim.v050.h22.text_mentions_poseidon','text.greek.homeric_hymn_poseidon_22','MENTIONS','deity.greek.poseidon',NULL,NULL,'Homeric Hymn 22 is addressed to Poseidon.','homeric_hymn.22','SUPPORTED',1.0,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 22','lines 1-7','Subwork-level catalogue relation.','2026-08-14T00:00:00Z'),
('claim.v050.h27.text_mentions_artemis','text.greek.homeric_hymn_artemis_27','MENTIONS','deity.greek.artemis',NULL,NULL,'Homeric Hymn 27 is addressed to Artemis.','homeric_hymn.27','SUPPORTED',1.0,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 27','lines 1-20','Subwork-level catalogue relation.','2026-08-14T00:00:00Z'),
('claim.v050.h28.text_mentions_athena','text.greek.homeric_hymn_athena_28','MENTIONS','deity.greek.athena',NULL,NULL,'Homeric Hymn 28 is addressed to Athena and narrates her armed birth.','homeric_hymn.28','SUPPORTED',1.0,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 28','lines 1-18','Subwork-level catalogue relation.','2026-08-14T00:00:00Z'),

('claim.v050.theogony.hera_child_cronus','deity.greek.hera','CHILD_OF','deity.greek.cronus',NULL,NULL,'Theogony 453-458 lists Hera among the children of Rhea and Cronus.','hesiod.theogony.453-458','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 453-458',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.hera_child_rhea','deity.greek.hera','CHILD_OF','deity.greek.rhea',NULL,NULL,'Theogony 453-458 lists Hera among the children borne by Rhea to Cronus.','hesiod.theogony.453-458','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 453-458',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.poseidon_child_cronus','deity.greek.poseidon','CHILD_OF','deity.greek.cronus',NULL,NULL,'Theogony 453-458 lists Poseidon among the children of Rhea and Cronus.','hesiod.theogony.453-458','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 453-458',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.poseidon_child_rhea','deity.greek.poseidon','CHILD_OF','deity.greek.rhea',NULL,NULL,'Theogony 453-458 lists Poseidon among the children borne by Rhea to Cronus.','hesiod.theogony.453-458','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 453-458',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.hades_child_cronus','deity.greek.hades','CHILD_OF','deity.greek.cronus',NULL,NULL,'Theogony 453-458 lists Hades among the children of Rhea and Cronus.','hesiod.theogony.453-458','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 453-458',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.hades_child_rhea','deity.greek.hades','CHILD_OF','deity.greek.rhea',NULL,NULL,'Theogony 453-458 lists Hades among the children borne by Rhea to Cronus.','hesiod.theogony.453-458','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 453-458',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.demeter_child_cronus','deity.greek.demeter','CHILD_OF','deity.greek.cronus',NULL,NULL,'Theogony 453-458 lists Demeter among the children of Rhea and Cronus.','hesiod.theogony.453-458','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 453-458',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.demeter_child_rhea','deity.greek.demeter','CHILD_OF','deity.greek.rhea',NULL,NULL,'Theogony 453-458 lists Demeter among the children borne by Rhea to Cronus.','hesiod.theogony.453-458','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 453-458',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.athena_child_zeus','deity.greek.athena','CHILD_OF','deity.greek.zeus',NULL,NULL,'Theogony 924-926 describes Athena as produced from Zeus’s head.','hesiod.theogony.924-926','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 924-926','Metis genealogy remains separately registered.','2026-08-14T00:00:00Z'),
('claim.v050.theogony.apollo_child_zeus','deity.greek.apollo','CHILD_OF','deity.greek.zeus',NULL,NULL,'Theogony 918-920 presents Apollo as a child of Leto and Zeus.','hesiod.theogony.918-920','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 918-920',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.apollo_child_leto','deity.greek.apollo','CHILD_OF','deity.greek.leto',NULL,NULL,'Theogony 918-920 presents Apollo as a child of Leto and Zeus.','hesiod.theogony.918-920','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 918-920',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.artemis_child_zeus','deity.greek.artemis','CHILD_OF','deity.greek.zeus',NULL,NULL,'Theogony 918-920 presents Artemis as a child of Leto and Zeus.','hesiod.theogony.918-920','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 918-920',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.artemis_child_leto','deity.greek.artemis','CHILD_OF','deity.greek.leto',NULL,NULL,'Theogony 918-920 presents Artemis as a child of Leto and Zeus.','hesiod.theogony.918-920','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 918-920',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.hermes_child_zeus','deity.greek.hermes','CHILD_OF','deity.greek.zeus',NULL,NULL,'Theogony 938-939 presents Hermes as a child of Maia and Zeus.','hesiod.theogony.938-939','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 938-939',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.hermes_child_maia','deity.greek.hermes','CHILD_OF','deity.greek.maia',NULL,NULL,'Theogony 938-939 presents Hermes as a child of Maia and Zeus.','hesiod.theogony.938-939','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 938-939',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.ares_child_zeus','deity.greek.ares','CHILD_OF','deity.greek.zeus',NULL,NULL,'Theogony 921-923 presents Ares among the children of Hera and Zeus.','hesiod.theogony.921-923','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 921-923',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.ares_child_hera','deity.greek.ares','CHILD_OF','deity.greek.hera',NULL,NULL,'Theogony 921-923 presents Ares among the children of Hera and Zeus.','hesiod.theogony.921-923','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 921-923',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.hephaestus_child_hera','deity.greek.hephaestus','CHILD_OF','deity.greek.hera',NULL,NULL,'Theogony 927-929 says Hera bore Hephaestus without union in this witness.','hesiod.theogony.927-929','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 927-929','Other ancient parentage traditions remain queued.','2026-08-14T00:00:00Z'),
('claim.v050.theogony.dionysus_child_zeus','deity.greek.dionysus','CHILD_OF','deity.greek.zeus',NULL,NULL,'Theogony 940-942 presents Dionysus as a child of Semele and Zeus.','hesiod.theogony.940-942','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 940-942',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.dionysus_child_semele','deity.greek.dionysus','CHILD_OF','deity.greek.semele',NULL,NULL,'Theogony 940-942 presents Dionysus as a child of Semele and Zeus.','hesiod.theogony.940-942','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 940-942',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.persephone_child_zeus','deity.greek.persephone','CHILD_OF','deity.greek.zeus',NULL,NULL,'Theogony 912-914 presents Persephone as a child of Demeter and Zeus.','hesiod.theogony.912-914','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 912-914',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.persephone_child_demeter','deity.greek.persephone','CHILD_OF','deity.greek.demeter',NULL,NULL,'Theogony 912-914 presents Persephone as a child of Demeter and Zeus.','hesiod.theogony.912-914','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 912-914',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.leto_mentioned','deity.greek.leto','MENTIONED_IN','text.greek.theogony',NULL,NULL,'Theogony 918-920 names Leto in the genealogy of Apollo and Artemis.','hesiod.theogony.918-920','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Hesiodic','lines 918-920',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.maia_mentioned','deity.greek.maia','MENTIONED_IN','text.greek.theogony',NULL,NULL,'Theogony 938-939 names Maia in the genealogy of Hermes.','hesiod.theogony.938-939','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Hesiodic','lines 938-939',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.semele_mentioned','deity.greek.semele','MENTIONED_IN','text.greek.theogony',NULL,NULL,'Theogony 940-942 names Semele in the genealogy of Dionysus.','hesiod.theogony.940-942','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Hesiodic','lines 940-942',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.gaia_parent_uranus','deity.greek.gaia','PARENT_OF','deity.greek.uranus',NULL,NULL,'Theogony 126-128 says Gaia bore starry Uranus equal to herself.','hesiod.theogony.126-128','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 126-128',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.gaia_parent_cronus','deity.greek.gaia','PARENT_OF','deity.greek.cronus',NULL,NULL,'Theogony 133-138 includes Cronus among the children of Gaia and Uranus.','hesiod.theogony.133-138','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 133-138',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.uranus_parent_cronus','deity.greek.uranus','PARENT_OF','deity.greek.cronus',NULL,NULL,'Theogony 133-138 includes Cronus among the children of Gaia and Uranus.','hesiod.theogony.133-138','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 133-138',NULL,'2026-08-14T00:00:00Z'),

('claim.v050.h22.poseidon_domains','deity.greek.poseidon','DOMAIN',NULL,'earth, sea, horses and ships in Homeric Hymn 22','text','Homeric Hymn 22 links Poseidon with earth, sea, horses and the saving of ships.','homeric_hymn.22.1-7','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Homeric Hymn 22','lines 1-7','Poetic attribution, not a claim of universal Greek uniformity.','2026-08-14T00:00:00Z'),
('claim.v050.iliad5.athena_uses_aegis','deity.greek.athena','USES','artifact.greek.aegis',NULL,NULL,'Iliad 5 depicts Athena putting on the tasselled aegis while arming for battle.','iliad.5.735-745','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Iliadic','Book 5, lines 735-745','Aegis form and terminology remain witness-specific.','2026-08-14T00:00:00Z'),
('claim.v050.h3.apollo_uses_bow','deity.greek.apollo','USES','weapon.greek.apollo_bow',NULL,NULL,'Homeric Hymn 3 repeatedly characterizes Apollo as bearing or delighting in the bow.','homeric_hymn.3.1-20','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Homeric Hymn 3','lines 1-20; 115-132',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.h27.artemis_uses_bow','deity.greek.artemis','USES','weapon.greek.artemis_bow',NULL,NULL,'Homeric Hymn 27 portrays Artemis as a golden-shafted archer hunting deer.','homeric_hymn.27.1-20','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Homeric Hymn 27','lines 1-20',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.h4.hermes_messenger','deity.greek.hermes','ROLE',NULL,'messenger of the gods in Homeric Hymn 4','text','The opening of Homeric Hymn 4 calls Hermes a messenger of the gods.','homeric_hymn.4.1-19','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Homeric Hymn 4','lines 1-19',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.h4.hermes_lyre','deity.greek.hermes','ATTRIBUTE',NULL,'makes and plays a lyre in the hymn narrative','text','Homeric Hymn 4 narrates Hermes constructing and playing a lyre.','homeric_hymn.4.24-55','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Homeric Hymn 4','lines 24-55','This does not establish every later attribute.','2026-08-14T00:00:00Z'),
('claim.v050.h8.ares_martial_prayer','deity.greek.ares','DOMAIN',NULL,'martial force coupled with a closing prayer for restraint and peace','text','Homeric Hymn 8 gives Ares martial titles but closes by asking for courage, restraint and peace.','homeric_hymn.8.1-17','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 8','lines 1-17','Prevents flattening the whole hymn into a one-word domain label.','2026-08-14T00:00:00Z'),
('claim.v050.h5.aphrodite_domain','deity.greek.aphrodite','DOMAIN',NULL,'desire and union among gods and creatures, with named exceptions in Hymn 5','text','The opening of Homeric Hymn 5 describes Aphrodite’s influence and explicitly names goddesses outside it.','homeric_hymn.5.1-33','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Homeric Hymn 5','lines 1-33','Scope is restricted to this hymn.','2026-08-14T00:00:00Z'),
('claim.v050.theogony.aphrodite_origin','deity.greek.aphrodite','ORIGIN_ACCOUNT',NULL,'arises from foam around the severed genitals of Uranus in the Hesiodic narrative','text','Theogony 188-206 narrates Aphrodite arising after the severed genitals of Uranus fall into the sea.','aphrodite.parentage_origin','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 188-206','Not normalized into a simple father-child edge.','2026-08-14T00:00:00Z'),
('claim.v050.iliad5.aphrodite_child_dione','deity.greek.aphrodite','CHILD_OF','deity.greek.dione',NULL,NULL,'Iliad 5 describes Aphrodite falling into the lap of her mother Dione.','aphrodite.parentage_origin','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Iliadic','Book 5, lines 370-372','Coexists with the Hesiodic origin account.','2026-08-14T00:00:00Z'),
('claim.v050.iliad14.aphrodite_child_zeus','deity.greek.aphrodite','CHILD_OF','deity.greek.zeus',NULL,NULL,'Iliad 14 refers to Aphrodite as a daughter of Zeus.','aphrodite.parentage_origin','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Iliadic','Book 14, line 193','Coexists with the Hesiodic origin account.','2026-08-14T00:00:00Z'),
('claim.v050.h20.hephaestus_crafts','deity.greek.hephaestus','DOMAIN',NULL,'inventions and crafts taught to mortals with Athena in Hymn 20','text','Homeric Hymn 20 praises Hephaestus for inventions and links him with Athena in teaching crafts.','homeric_hymn.20.1-5','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 20','lines 1-5',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.h7.dionysus_pirates','deity.greek.dionysus','ROLE',NULL,'divine protagonist of the pirate episode in Homeric Hymn 7','text','Homeric Hymn 7 narrates pirates seizing Dionysus and the ensuing divine epiphany.','homeric_hymn.7.1-55','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Homeric Hymn 7','lines 1-55',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.h2.demeter_associated_eleusis','deity.greek.demeter','ASSOCIATED_WITH','site.greece.eleusis',NULL,NULL,'Homeric Hymn 2 places Demeter’s arrival and the establishment of rites at Eleusis.','homeric_hymn.2.eleusis','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 2','lines 90-304; 470-480','Textual association only; archaeology and historical ritual require separate evidence.','2026-08-14T00:00:00Z'),

('claim.v050.h2.persephone_participated','deity.greek.persephone','PARTICIPATED_IN','event.greek.persephone_abduction',NULL,NULL,'Persephone is the abducted figure in Homeric Hymn 2.','homeric_hymn.2.abduction','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Homeric Hymn 2','lines 1-87',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.h2.demeter_participated','deity.greek.demeter','PARTICIPATED_IN','event.greek.persephone_abduction',NULL,NULL,'Demeter searches for Persephone after the abduction in Homeric Hymn 2.','homeric_hymn.2.abduction','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Homeric Hymn 2','lines 1-87',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.h2.hades_participated','deity.greek.hades','PARTICIPATED_IN','event.greek.persephone_abduction',NULL,NULL,'Hades takes Persephone in Homeric Hymn 2, with Zeus’s consent in this witness.','homeric_hymn.2.abduction','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Homeric Hymn 2','lines 1-32','Restricted to the hymn’s account.','2026-08-14T00:00:00Z'),
('claim.v050.h2.event_appears','event.greek.persephone_abduction','APPEARS_IN','text.greek.homeric_hymn_demeter',NULL,NULL,'The abduction of Persephone and Demeter’s search structure the narrative of Homeric Hymn 2.','homeric_hymn.2.abduction','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 2','lines 1-87','Event entity represents the textual mythic layer.','2026-08-14T00:00:00Z'),
('claim.v050.theogony.titanomachy_appears','event.greek.titanomachy','APPEARS_IN','text.greek.theogony',NULL,NULL,'Theogony 617-735 narrates the divine war conventionally called the Titanomachy.','hesiod.theogony.617-735','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Hesiodic','lines 617-735','Modern event label indexes the ancient passage.','2026-08-14T00:00:00Z'),
('claim.v050.theogony.zeus_participated_titanomachy','deity.greek.zeus','PARTICIPATED_IN','event.greek.titanomachy',NULL,NULL,'Theogony 617-735 makes Zeus a leading participant in the war against the Titans.','hesiod.theogony.617-735','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 617-735',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.theogony.cronus_participated_titanomachy','deity.greek.cronus','PARTICIPATED_IN','event.greek.titanomachy',NULL,NULL,'Theogony’s war passage places the Titans associated with Cronus against Zeus and his allies.','hesiod.theogony.617-735','SUPPORTED',0.95,'HIGH','VERIFIED','TEXT_SAYS','MYTHIC_NARRATIVE','Hesiodic','lines 617-735','Participant role follows the passage and conventional event indexing.','2026-08-14T00:00:00Z'),

('claim.v050.iliad5.aegis_appears','artifact.greek.aegis','APPEARS_IN','text.greek.iliad',NULL,NULL,'The tasselled aegis appears in Athena’s arming scene in Iliad 5.','iliad.5.735-745','SUPPORTED',0.98,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Iliadic','Book 5, lines 735-745','Terminology and object form remain witness-specific.','2026-08-14T00:00:00Z'),
('claim.v050.h3.apollo_bow_appears','weapon.greek.apollo_bow','APPEARS_IN','text.greek.homeric_hymn_apollo_3',NULL,NULL,'Apollo’s bow is a recurring attribute in Homeric Hymn 3.','homeric_hymn.3.1-20','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 3','lines 1-20; 115-132',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.h27.artemis_bow_appears','weapon.greek.artemis_bow','APPEARS_IN','text.greek.homeric_hymn_artemis_27',NULL,NULL,'Artemis’s bow and golden shafts appear in Homeric Hymn 27.','homeric_hymn.27.1-20','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Homeric Hymn 27','lines 1-20',NULL,'2026-08-14T00:00:00Z'),
('claim.v050.iliad5.dione_mentioned','deity.greek.dione','MENTIONED_IN','text.greek.iliad',NULL,NULL,'Iliad 5 names Dione as Aphrodite’s mother.','aphrodite.parentage_origin','SUPPORTED',0.99,'HIGH','VERIFIED','TEXT_SAYS','TEXTUAL_WITNESS','Iliadic','Book 5, lines 370-372','Variant-specific genealogy.','2026-08-14T00:00:00Z');

INSERT OR IGNORE INTO evidence(
  id,claim_id,source_id,source_location,chapter,verse,line,page,catalogue_number,
  short_quote,evidence_type,direction,strength,research_notes
)
SELECT
  'evidence.' || substr(id,7), id,
  CASE
    WHEN id LIKE 'claim.v050.h3.%' THEN 'source.greek.homeric_hymn_apollo3.scaife'
    WHEN id LIKE 'claim.v050.h4.%' THEN 'source.greek.homeric_hymn_hermes4.scaife'
    WHEN id LIKE 'claim.v050.h5.%' THEN 'source.greek.homeric_hymn_aphrodite5.scaife'
    WHEN id LIKE 'claim.v050.h7.%' THEN 'source.greek.homeric_hymn_dionysus7.scaife'
    WHEN id LIKE 'claim.v050.h8.%' THEN 'source.greek.homeric_hymn_ares8.scaife'
    WHEN id LIKE 'claim.v050.h20.%' THEN 'source.greek.homeric_hymn_hephaestus20.scaife'
    WHEN id LIKE 'claim.v050.h22.%' THEN 'source.greek.homeric_hymn_poseidon22.scaife'
    WHEN id LIKE 'claim.v050.h27.%' THEN 'source.greek.homeric_hymn_artemis27.scaife'
    WHEN id LIKE 'claim.v050.h28.%' THEN 'source.greek.homeric_hymn_athena28.scaife'
    WHEN id LIKE 'claim.v050.h2.%' THEN 'source.greek.homeric_hymn_demeter.scaife'
    WHEN id LIKE 'claim.v050.iliad%' THEN 'source.greek.iliad.scaife'
    ELSE 'source.greek.theogony.perseus_eng1'
  END,
  temporal_scope,
  CASE WHEN id LIKE 'claim.v050.iliad5.%' THEN '5' WHEN id LIKE 'claim.v050.iliad14.%' THEN '14' ELSE NULL END,
  NULL,
  CASE
    WHEN id LIKE 'claim.v050.iliad5.athena_%' OR id LIKE 'claim.v050.iliad5.aegis_%' THEN '735-745'
    WHEN id LIKE 'claim.v050.iliad5.%' THEN '370-372'
    WHEN id LIKE 'claim.v050.iliad14.%' THEN '193'
    ELSE replace(temporal_scope,'lines ','')
  END,
  NULL,
  CASE
    WHEN id LIKE 'claim.v050.h3.%' THEN 'urn:cts:greekLit:tlg0013.tlg003.perseus-eng2'
    WHEN id LIKE 'claim.v050.h4.%' THEN 'urn:cts:greekLit:tlg0013.tlg004.perseus-eng2'
    WHEN id LIKE 'claim.v050.h5.%' THEN 'urn:cts:greekLit:tlg0013.tlg005.perseus-eng2'
    WHEN id LIKE 'claim.v050.h7.%' THEN 'urn:cts:greekLit:tlg0013.tlg007.perseus-eng2'
    WHEN id LIKE 'claim.v050.h8.%' THEN 'urn:cts:greekLit:tlg0013.tlg008.perseus-grc2'
    WHEN id LIKE 'claim.v050.h20.%' THEN 'urn:cts:greekLit:tlg0013.tlg020.perseus-eng2'
    WHEN id LIKE 'claim.v050.h22.%' THEN 'urn:cts:greekLit:tlg0013.tlg022.perseus-eng2'
    WHEN id LIKE 'claim.v050.h27.%' THEN 'urn:cts:greekLit:tlg0013.tlg027.perseus-eng2'
    WHEN id LIKE 'claim.v050.h28.%' THEN 'urn:cts:greekLit:tlg0013.tlg028.perseus-eng2'
    WHEN id LIKE 'claim.v050.h2.%' THEN 'urn:cts:greekLit:tlg0013.tlg002.perseus-eng2'
    WHEN id LIKE 'claim.v050.iliad%' THEN 'urn:cts:greekLit:tlg0012.tlg001'
    ELSE 'urn:cts:greekLit:tlg0020.tlg001.perseus-eng1'
  END,
  NULL,'PRIMARY_TEXT','SUPPORTS',
  CASE WHEN confidence >= 0.99 THEN 0.99 ELSE 0.96 END,
  'Exact witness and locator checked against the registered digital edition on 2026-08-14; the public web snapshot omits quotation text.'
FROM claims WHERE id LIKE 'claim.v050.%';

INSERT OR IGNORE INTO event_participants(event_id,participant_id,role,outcome,claim_id) VALUES
('event.greek.persephone_abduction','deity.greek.persephone','ABDUCTED','Taken to the underworld in this hymn witness','claim.v050.h2.persephone_participated'),
('event.greek.persephone_abduction','deity.greek.demeter','SEARCHER','Searches for Persephone','claim.v050.h2.demeter_participated'),
('event.greek.persephone_abduction','deity.greek.hades','ABDUCTOR','Takes Persephone below','claim.v050.h2.hades_participated'),
('event.greek.titanomachy','deity.greek.zeus','LEADER','Victory in the Hesiodic witness','claim.v050.theogony.zeus_participated_titanomachy'),
('event.greek.titanomachy','deity.greek.cronus','TITAN_LEADER','Defeat in the Hesiodic witness','claim.v050.theogony.cronus_participated_titanomachy');

INSERT OR IGNORE INTO conflicts(id,subject_id,variant_group,claim_a_id,claim_b_id,conflict_type,status,summary,resolution_notes) VALUES
('conflict.greek.aphrodite_parentage_v050','deity.greek.aphrodite','aphrodite.parentage_origin','claim.v050.theogony.aphrodite_origin','claim.v050.iliad5.aphrodite_child_dione','GENEALOGY_VARIANT','OPEN','Hesiod’s Theogony narrates Aphrodite arising from the aftermath of Uranus’s castration, while the Iliad names Dione as her mother and elsewhere calls Aphrodite a daughter of Zeus.','Retain the Hesiodic and Iliadic witnesses as coexisting source-level variants; do not force a single normalized parentage.');

INSERT OR IGNORE INTO collection_queue(
  id,target_label,normalized_label,proposed_entity_type,civilization_id,
  discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,
  discovery_context,priority,status,attempts,last_error,next_action,created_at,updated_at
) VALUES
('queue.greek.v050.olympian_membership','Ancient and later lists of the Olympian gods','ancient and later lists of the olympian gods','CONCEPT','civ.greek','deity.greek.zeus',NULL,'source.greek.homeric_hymns.scaife','The core-god profile pass exposes that a fixed modern list of twelve must not be projected onto every Greek source or locality.',98,'NEEDS_REVIEW',0,NULL,'Register separately dated literary, epigraphic and cult groupings; preserve changing membership and avoid a universal fixed list','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('queue.greek.v050.hermes_caduceus','Hermes staff and caduceus textual/iconographic history','hermes staff and caduceus textual iconographic history','ARTIFACT','civ.greek','deity.greek.hermes','claim.v050.h4.hermes_messenger','source.greek.homeric_hymn_hermes4.scaife','Hymn 4 supports messenger and lyre layers but does not by itself establish every later caduceus form.',96,'SOURCE_FOUND',0,NULL,'Collect exact ancient passages, vase catalogues, coins and museum objects; distinguish herald staff from modern medical-symbol reception','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('queue.greek.v050.hades_helm','Hades helm of invisibility witness history','hades helm of invisibility witness history','ARTIFACT','civ.greek','deity.greek.hades','claim.v050.h2.hades_participated','source.greek.homeric_hymn_demeter.scaife','The Hades profile remains incomplete without a separately sourced helm tradition.',95,'DISCOVERED',0,NULL,'Locate exact archaic/classical textual passages and securely catalogued depictions before asserting ownership or powers','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('queue.greek.v050.eleusis_layers','Eleusis archaeology, inscriptions and mystery-cult layers','eleusis archaeology inscriptions and mystery cult layers','ARCHAEOLOGICAL_SITE','civ.greek','deity.greek.demeter','claim.v050.h2.demeter_associated_eleusis','source.greek.homeric_hymn_demeter.scaife','The hymn supplies a textual Eleusinian layer but not a complete archaeological or historical ritual dossier.',99,'SOURCE_FOUND',0,NULL,'Add Greek Ministry, UNESCO or excavation records, dated inscriptions, museum catalogue numbers and ritual scholarship as separate evidence layers','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z'),
('queue.greek.v050.hephaestus_parentage','Hephaestus parentage variants across ancient witnesses','hephaestus parentage variants across ancient witnesses','DEITY','civ.greek','deity.greek.hephaestus','claim.v050.theogony.hephaestus_child_hera','source.greek.theogony.perseus_eng1','The Hesiodic Hera-alone genealogy exposes other ancient parentage accounts that must be compared, not overwritten.',94,'CONFLICT',0,NULL,'Register exact Homeric and later witnesses and create an explicit variant group without merging contradictory claims','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z');

INSERT OR IGNORE INTO queue_discoveries(id,queue_id,discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,discovery_context,discovered_at) VALUES
('discovery.20260814.v050.olympian_membership','queue.greek.v050.olympian_membership','deity.greek.zeus',NULL,'source.greek.homeric_hymns.scaife','Profile comparison revealed that the modern fixed-list framing requires its own historical source audit.','2026-08-14T00:00:00Z'),
('discovery.20260814.v050.hermes_caduceus','queue.greek.v050.hermes_caduceus','deity.greek.hermes','claim.v050.h4.hermes_messenger','source.greek.homeric_hymn_hermes4.scaife','The early hymn supports messenger and lyre claims while leaving the staff tradition open.','2026-08-14T00:00:00Z'),
('discovery.20260814.v050.hades_helm','queue.greek.v050.hades_helm','deity.greek.hades','claim.v050.h2.hades_participated','source.greek.homeric_hymn_demeter.scaife','The Hades mythic profile exposed a seeded artifact with no sufficient outgoing evidence.','2026-08-14T00:00:00Z'),
('discovery.20260814.v050.eleusis_layers','queue.greek.v050.eleusis_layers','deity.greek.demeter','claim.v050.h2.demeter_associated_eleusis','source.greek.homeric_hymn_demeter.scaife','The hymn’s Eleusis passage creates a separate archaeological, epigraphic and ritual research target.','2026-08-14T00:00:00Z'),
('discovery.20260814.v050.hephaestus_parentage','queue.greek.v050.hephaestus_parentage','deity.greek.hephaestus','claim.v050.theogony.hephaestus_child_hera','source.greek.theogony.perseus_eng1','Hesiodic parentage requires comparison with other ancient witnesses.','2026-08-14T00:00:00Z');

INSERT OR IGNORE INTO queue_status_history(id,queue_id,old_status,new_status,changed_at,reason) VALUES
('qhist.20260814.v050.olympian_membership','queue.greek.v050.olympian_membership','DISCOVERED','NEEDS_REVIEW','2026-08-14T00:00:00Z','Fixed membership must be historically sourced'),
('qhist.20260814.v050.hermes_caduceus','queue.greek.v050.hermes_caduceus','DISCOVERED','SOURCE_FOUND','2026-08-14T00:00:00Z','Early Hermes source registered; object history remains open'),
('qhist.20260814.v050.hades_helm','queue.greek.v050.hades_helm','NEW','DISCOVERED','2026-08-14T00:00:00Z','Seeded helm record lacks an adequate exact witness'),
('qhist.20260814.v050.eleusis_layers','queue.greek.v050.eleusis_layers','DISCOVERED','SOURCE_FOUND','2026-08-14T00:00:00Z','Poetic source located; material and historical layers remain open'),
('qhist.20260814.v050.hephaestus_parentage','queue.greek.v050.hephaestus_parentage','DISCOVERED','CONFLICT','2026-08-14T00:00:00Z','Hesiodic genealogy should not overwrite alternate ancient accounts');

INSERT OR IGNORE INTO research_sessions(id,started_at,ended_at,scope,strategy,status,agent_or_process,notes) VALUES(
  'research.20260814.v050_greek_primary_profiles','2026-08-14T00:00:00Z','2026-08-14T00:00:00Z',
  'Greek core deity primary-text profiles, Homeric Hymn subworks, artifacts, mythic events and explicit Aphrodite genealogy variants',
  'Use exact ancient-text locators; distinguish textual witness from historical reality; preserve variants and feed uncovered layers back into the permanent queue',
  'CHECKPOINT_COMPLETE','Codex research and data pipeline',
  'Expandable staged baseline only. Olympian membership, Eleusinian archaeology, Hermes staff history, Hades helm and Hephaestus variants remain open.'
);

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result)
SELECT 'research.20260814.v050_greek_primary_profiles','SOURCE',id,'REGISTER','URL_SYNTAX_VALID_WITH_EXACT_LOCATOR'
FROM sources WHERE id LIKE 'source.greek.homeric_hymn_%' AND accessed_date='2026-08-14';
INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result)
SELECT 'research.20260814.v050_greek_primary_profiles','ENTITY',id,
  CASE WHEN created_at='2026-08-14T00:00:00Z' AND id IN ('deity.greek.leto','deity.greek.maia','deity.greek.semele','deity.greek.dione','deity.greek.persephone','event.greek.persephone_abduction') THEN 'CREATE' ELSE 'ENRICH' END,
  'SOURCE_LOCATED_PROFILE'
FROM entities WHERE id IN ('deity.greek.zeus','deity.greek.hera','deity.greek.poseidon','deity.greek.hades','deity.greek.athena','deity.greek.apollo','deity.greek.artemis','deity.greek.hermes','deity.greek.ares','deity.greek.aphrodite','deity.greek.hephaestus','deity.greek.demeter','deity.greek.dionysus','deity.greek.gaia','deity.greek.uranus','deity.greek.leto','deity.greek.maia','deity.greek.semele','deity.greek.dione','deity.greek.persephone','event.greek.persephone_abduction','event.greek.titanomachy');

-- Evidence status is claim-subject based. Incoming graph edges remain visible but
-- do not by themselves promote an entity to SOURCE_BACKED.
UPDATE entities SET evidence_status='PARTIAL',updated_at='2026-08-14T00:00:00Z'
WHERE id IN (SELECT DISTINCT subject_id FROM claims);
UPDATE entities SET evidence_status='SOURCE_BACKED',updated_at='2026-08-14T00:00:00Z'
WHERE EXISTS (SELECT 1 FROM claims c WHERE c.subject_id=entities.id)
  AND NOT EXISTS (
    SELECT 1 FROM claims c WHERE c.subject_id=entities.id
      AND NOT EXISTS (SELECT 1 FROM evidence e WHERE e.claim_id=c.id)
  );
UPDATE entities SET evidence_status='CONFLICTING',research_status='CONFLICT',updated_at='2026-08-14T00:00:00Z'
WHERE id IN (SELECT subject_id FROM conflicts WHERE status='OPEN');

UPDATE project_metadata SET value='0.5.0-greek-primary-profiles-20260814',updated_at='2026-08-14T00:00:00Z' WHERE key='data_version';
UPDATE project_metadata SET value='7',updated_at='2026-08-14T00:00:00Z' WHERE key='schema_version';
UPDATE project_metadata SET value='2026-08-14T00:00:00Z',updated_at='2026-08-14T00:00:00Z' WHERE key='generated_at';

INSERT OR IGNORE INTO dataset_releases(id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes) VALUES(
  'release.0.5.0',7,'0.5.0-greek-primary-profiles-20260814',NULL,'2026-08-14T00:00:00Z',NULL,
  'Greek primary-profile checkpoint: core deity descriptions and original names, nine Homeric Hymn subworks and sources, five newly discovered genealogy entities, Persephone abduction and Titanomachy event layers, three artifact witnesses, explicit Aphrodite origin conflict, and a permanent follow-up queue.'
);

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(7,'20260814_v050_greek_olympian_primary_profiles','2026-08-14T00:00:00Z');

COMMIT;
