BEGIN IMMEDIATE;

CREATE TABLE IF NOT EXISTS stories (
    id TEXT PRIMARY KEY,
    canonical_title TEXT NOT NULL,
    title_zh TEXT NOT NULL,
    story_type TEXT NOT NULL CHECK(story_type IN ('MYTHIC_NARRATIVE','CREATION_ACCOUNT','DIVINE_COMBAT','UNDERWORLD_JOURNEY','GENEALOGICAL_ACCOUNT','RITUAL_ORIGIN','TRADITION_OVERVIEW','TEXT_FRAGMENT')),
    primary_civilization_id TEXT REFERENCES civilizations(id),
    summary_zh TEXT NOT NULL,
    summary_en TEXT NOT NULL,
    themes_json TEXT NOT NULL DEFAULT '[]',
    evidence_status TEXT NOT NULL DEFAULT 'SOURCE_BACKED' CHECK(evidence_status IN ('UNVERIFIED','PARTIAL','SOURCE_BACKED','CONFLICTING')),
    access_level TEXT NOT NULL DEFAULT 'PUBLIC_CONTEXT' CHECK(access_level IN ('PUBLIC_CONTEXT','ATTRIBUTION_REQUIRED','PERMISSION_REQUIRED','DO_NOT_COLLECT')),
    reading_minutes INTEGER NOT NULL DEFAULT 3 CHECK(reading_minutes BETWEEN 1 AND 120),
    featured_order INTEGER,
    editorial_note TEXT NOT NULL,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_stories_civilization ON stories(primary_civilization_id, featured_order, id);

CREATE TABLE IF NOT EXISTS story_versions (
    id TEXT PRIMARY KEY,
    story_id TEXT NOT NULL REFERENCES stories(id) ON DELETE CASCADE,
    version_label_zh TEXT NOT NULL,
    version_label_en TEXT NOT NULL,
    source_id TEXT NOT NULL REFERENCES sources(id),
    source_location TEXT NOT NULL,
    language_id TEXT REFERENCES languages(id),
    witness_scope TEXT NOT NULL,
    narrative_scope TEXT NOT NULL,
    evidence_status TEXT NOT NULL DEFAULT 'SOURCE_BACKED' CHECK(evidence_status IN ('UNVERIFIED','PARTIAL','SOURCE_BACKED','CONFLICTING')),
    access_level TEXT NOT NULL DEFAULT 'PUBLIC_CONTEXT' CHECK(access_level IN ('PUBLIC_CONTEXT','ATTRIBUTION_REQUIRED','PERMISSION_REQUIRED','DO_NOT_COLLECT')),
    version_order INTEGER NOT NULL DEFAULT 0,
    rights_note TEXT,
    created_at TEXT NOT NULL,
    UNIQUE(story_id, source_id, source_location, version_label_en)
);
CREATE INDEX IF NOT EXISTS idx_story_versions_story ON story_versions(story_id, version_order, id);

CREATE TABLE IF NOT EXISTS story_sections (
    id TEXT PRIMARY KEY,
    story_version_id TEXT NOT NULL REFERENCES story_versions(id) ON DELETE CASCADE,
    section_order INTEGER NOT NULL CHECK(section_order >= 1),
    heading_zh TEXT NOT NULL,
    heading_en TEXT NOT NULL,
    body_zh TEXT NOT NULL,
    body_en TEXT NOT NULL,
    anchor_claim_id TEXT REFERENCES claims(id),
    evidence_note TEXT NOT NULL,
    uncertainty_note TEXT,
    UNIQUE(story_version_id, section_order)
);
CREATE INDEX IF NOT EXISTS idx_story_sections_version ON story_sections(story_version_id, section_order);

CREATE TABLE IF NOT EXISTS story_claim_links (
    story_version_id TEXT NOT NULL REFERENCES story_versions(id) ON DELETE CASCADE,
    claim_id TEXT NOT NULL REFERENCES claims(id) ON DELETE CASCADE,
    link_role TEXT NOT NULL DEFAULT 'NARRATIVE_BASIS' CHECK(link_role IN ('NARRATIVE_BASIS','PARTICIPANT','VERSION_CONFLICT','EVIDENCE_LIMIT','CONTEXT')),
    PRIMARY KEY(story_version_id, claim_id, link_role)
);

CREATE TABLE IF NOT EXISTS story_entity_links (
    story_id TEXT NOT NULL REFERENCES stories(id) ON DELETE CASCADE,
    story_version_id TEXT NOT NULL REFERENCES story_versions(id) ON DELETE CASCADE,
    entity_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    role TEXT NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    notes TEXT,
    PRIMARY KEY(story_version_id, entity_id, role)
);
CREATE INDEX IF NOT EXISTS idx_story_entity_links_entity ON story_entity_links(entity_id, story_id, story_version_id);

CREATE TABLE IF NOT EXISTS story_conflict_links (
    story_id TEXT NOT NULL REFERENCES stories(id) ON DELETE CASCADE,
    conflict_id TEXT NOT NULL REFERENCES conflicts(id) ON DELETE CASCADE,
    notes TEXT,
    PRIMARY KEY(story_id, conflict_id)
);

INSERT OR IGNORE INTO stories(
    id,canonical_title,title_zh,story_type,primary_civilization_id,summary_zh,summary_en,
    themes_json,evidence_status,access_level,reading_minutes,featured_order,editorial_note,created_at,updated_at
) VALUES
('story.greek.demeter_persephone','Demeter and Persephone','得墨忒耳寻找珀耳塞福涅','UNDERWORLD_JOURNEY','civ.greek','珀耳塞福涅被带往冥界后，得墨忒耳离开诸神寻找女儿；本页严格以《荷马颂歌·致得墨忒耳》的见证范围叙述。','After Persephone is taken below, Demeter leaves the gods to search for her daughter; this page stays within the witness of the Homeric Hymn to Demeter.','["母女","冥界","厄琉息斯","季节"]','SOURCE_BACKED','PUBLIC_CONTEXT',6,10,'原创中文概述；不复制现代译文，不把后世版本并入本见证。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.greek.titanomachy','Titanomachy in Hesiod','赫西俄德笔下的泰坦战争','DIVINE_COMBAT','civ.greek','宙斯一方与克洛诺斯一方的泰坦交战；本页只呈现《神谱》617–735行的战斗见证。','The gods aligned with Zeus fight the Titans aligned with Cronus; this page presents only Theogony 617–735.','["神战","王权","雷霆","塔耳塔罗斯"]','SOURCE_BACKED','PUBLIC_CONTEXT',5,20,'以当前登记的《神谱》见证为限。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.greek.zeus_typhon','Zeus and Typhon in Hesiod','宙斯与提丰之战','DIVINE_COMBAT','civ.greek','《神谱》中的宙斯以雷霆、闪电和雷电武器迎战提丰；其他作者的版本不在本页自动合并。','In the Theogony, Zeus confronts Typhon with thunder, lightning, and the thunderbolt; versions in other authors are not merged here.','["神战","雷霆","怪物","王权"]','SOURCE_BACKED','PUBLIC_CONTEXT',4,30,'单一见证阅读版；后续版本须另建故事版本。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.greek.medea_restoration','Medea restores Aeetes','美狄亚恢复埃厄忒斯王位','MYTHIC_NARRATIVE','civ.greek','《书库》1.9.28保存美狄亚回到科尔喀斯、杀死夺位者珀耳塞斯并恢复埃厄忒斯王位的短篇结局。','Library 1.9.28 preserves a short ending in which Medea returns to Colchis, kills the usurper Perses, and restores Aeetes.','["王权","归返","美狄亚","科尔喀斯"]','SOURCE_BACKED','PUBLIC_CONTEXT',3,40,'严格区分科尔喀斯的珀耳塞斯与其他同名人物。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.greek.aphrodite_origins','Variant origins of Aphrodite','阿佛洛狄忒的两种出身见证','GENEALOGICAL_ACCOUNT','civ.greek','《神谱》的海中诞生叙事与《伊利亚特》的宙斯—狄俄涅家谱并存；系统不强制选定唯一版本。','The sea-birth account in the Theogony coexists with the Zeus-and-Dione genealogy in the Iliad; the system does not force one version.','["诞生","谱系","版本冲突","海"]','CONFLICTING','PUBLIC_CONTEXT',6,50,'两个古代见证分别保存，并连接现有谱系冲突档案。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.norse.ask_embla','Ask and Embla in two witnesses','阿斯克与恩布拉：两种北欧见证','CREATION_ACCOUNT','civ.norse','《女巫预言》与《欺骗古鲁菲》都记下最初人类阿斯克和恩布拉，却给出不同的神祇组合；两版分开阅读。','Voluspa and Gylfaginning both name Ask and Embla while presenting different divine triads; the two witnesses are read separately.','["人类起源","创世","版本差异","埃达"]','CONFLICTING','PUBLIC_CONTEXT',7,60,'目前只叙述数据库已逐条核对的人物与神祇组合，不补写未登记的赐予细节。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.norse.forging_treasures','Forging the divine treasures','诸神宝物的锻造','MYTHIC_NARRATIVE','civ.norse','《诗语法》保存矮人锻造竞赛的故事层，并把古林博斯帝、德罗普尼尔和妙尔尼尔放在同一宝物序列中。','Skaldskaparmal preserves the smithing-contest layer that places Gullinbursti, Draupnir, and Mjolnir in one treasure sequence.','["锻造","神器","矮人","妙尔尼尔"]','PARTIAL','PUBLIC_CONTEXT',5,70,'现有角色名异文及 Sindri/Eitri 问题保持独立记录。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.norse.hammer_recovery','Thor recovers Mjolnir','索尔寻找被夺走的妙尔尼尔','MYTHIC_NARRATIVE','civ.norse','《索列姆之歌》以索尔寻找锤子为中心，洛基同行并提供协助；本页不把二者误写成兄弟。','Thrymskvida centers on Thor seeking his hammer, with Loki accompanying and advising him; the page does not call them brothers.','["妙尔尼尔","索尔","洛基","寻回"]','PARTIAL','PUBLIC_CONTEXT',4,80,'当前版只呈现已核对的角色与寻回框架，婚礼伪装细节留待逐节校勘。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.norse.ragnarok','Ragnarok witness outline','诸神黄昏见证纲要','MYTHIC_NARRATIVE','civ.norse','现有证据层确认奥丁与芬里尔参加诸神黄昏之战；完整末世与更新段落仍待按不同埃达见证拆分。','The current evidence layer confirms Odin and Fenrir in the Ragnarok battle; the full destruction-and-renewal sequence still requires witness-by-witness expansion.','["终末","更新","奥丁","芬里尔"]','PARTIAL','PUBLIC_CONTEXT',3,90,'这是有意保留缺口的故事纲要，不用流行文化补齐。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.norse.odin_mimir','Odin and Mimirs well','奥丁与密米尔之泉','MYTHIC_NARRATIVE','civ.norse','《欺骗古鲁菲》第15章把密米尔与智慧之泉相连，并说奥丁以一只眼睛换取饮泉的机会。','Gylfaginning 15 associates Mimir with the well of wisdom and says that Odin gives an eye for a drink.','["智慧","牺牲","泉水","奥丁"]','SOURCE_BACKED','PUBLIC_CONTEXT',3,100,'只陈述第15章已登记的两项叙事事实。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.sumerian.inanna_descent','Inanas descent to the netherworld','伊南娜下冥界','UNDERWORLD_JOURNEY','civ.sumerian','苏美尔作品1.4.1叙述伊南娜把心意转向地下世界并展开下降；全文的门、裁决、复生与替代者段落仍需逐行建模。','Sumerian composition 1.4.1 begins with Inana setting her mind on the world below and descending; the gates, judgment, revival, and substitute sequence still need line-level modeling.','["冥界","下降","伊南娜","苏美尔"]','PARTIAL','PUBLIC_CONTEXT',5,110,'采用牛津 ETCSL 的作品编号与公开译文定位，正文为独立概述。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.babylonian.marduk_tiamat','Marduk and Tiamat','马尔杜克与提亚马特','DIVINE_COMBAT','civ.babylonian','《埃努玛·埃利什》的登记层确认马尔杜克与提亚马特参与创世战斗；本版先提供证据导读，不把未逐条录入的战斗细节写成结构化事实。','The registered layer of Enuma elish confirms Marduk and Tiamat in the creation combat; this version is an evidence guide and does not promote unmodeled details to structured fact.','["创世","战斗","巴比伦","王权"]','PARTIAL','PUBLIC_CONTEXT',3,120,'待电子巴比伦图书馆各泥板逐行拆分后扩充。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.akkadian.anzu_tablet','Anzu and the Tablet of Destinies','安祖与命运泥板','MYTHIC_NARRATIVE','civ.akkadian','安祖夺走命运泥板，宁努尔塔在叙事中成为获胜者并取回泥板；依据 ORACC 的学术数字展览纲要。','Anzu steals the Tablet of Destinies; Ninurta becomes the victorious hero and recovers it, according to the registered ORACC scholarly synopsis.','["命运泥板","安祖","宁努尔塔","夺回"]','SOURCE_BACKED','PUBLIC_CONTEXT',4,130,'学术纲要阅读版，不假装是完整泥板翻译。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.ugaritic.baal_yamm','Baal and Yamm in KTU 1.2 IV','巴力与雅姆之战','DIVINE_COMBAT','civ.ugaritic','KTU 1.2 IV 的见证层把巴力、雅姆以及两件有名武器置于同一战斗序列；残缺部分继续标记为缺口。','The KTU 1.2 IV witness places Baal, Yamm, and two named weapons in one combat sequence; damaged or unmodeled parts remain gaps.','["巴力","雅姆","乌加里特","武器"]','PARTIAL','PUBLIC_CONTEXT',4,140,'泥板库存记录与学术武器说明分层使用。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.ugaritic.baal_mot','Baal and Mot in KTU 1.5-1.6','巴力与穆特的残缺事件序列','MYTHIC_NARRATIVE','civ.ugaritic','KTU 1.5–1.6保存巴力、穆特与阿纳特参与的残缺序列；巴力返回不等于“死亡从此消失”。','KTU 1.5–1.6 preserves a fragmentary sequence involving Baal, Mot, and Anat; the return of Baal does not mean that death permanently ceased.','["巴力","穆特","阿纳特","残缺文本"]','PARTIAL','PUBLIC_CONTEXT',4,150,'拒绝把残缺叙事压成普世神学结论。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.vedic.indra_vritra','Indra and Vrtra in Rigveda 1.32','因陀罗与弗栗多之战','DIVINE_COMBAT','civ.vedic','《梨俱吠陀》1.32把因陀罗、弗栗多、金刚杵与水流释放置于同一颂歌叙事。','Rigveda 1.32 places Indra, Vrtra, the vajra, and the release of the waters in one hymn narrative.','["因陀罗","弗栗多","金刚杵","水"]','SOURCE_BACKED','PUBLIC_CONTEXT',5,160,'仅作为RV 1.32的文本见证，不自动并入后期版本。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.japanese.eight_thunder_yomi','Eight thunder kami in Yomi','黄泉中的八雷神','TEXT_FRAGMENT','civ.japanese_shinto','《古事记》黄泉段落在伊邪那美身上列出八位雷神；本页保留八个名称，不把后来同名地方神自动等同。','The Yomi episode of the Kojiki lists eight thunder kami on Izanami; the page preserves the eight names without merging later local deities that sound similar.','["黄泉","雷神","古事记","伊邪那美"]','SOURCE_BACKED','PUBLIC_CONTEXT',5,170,'详细形象与地方同一问题若资料不足即显示未知。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.japanese.kamo_arrow','The Kamo red-arrow genealogy','贺茂红箭与神子谱系','GENEALOGICAL_ACCOUNT','civ.japanese_shinto','《山城国风土记》逸文的学术条目保存玉依姬、红箭与贺茂别雷大神的谱系片段；失传原书不被系统重建。','An academic entry on the surviving Yamashiro Fudoki fragment preserves a genealogy involving Tamayorihime, a red arrow, and Kamo Wakeikazuchi; the lost full text is not reconstructed.','["贺茂","红箭","谱系","风土记逸文"]','PARTIAL','ATTRIBUTION_REQUIRED',5,180,'学术条目保留版权；仅发布独立概述与定位。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.egyptian.solar_night','The nocturnal solar journey','太阳神夜行冥界','UNDERWORLD_JOURNEY','civ.egyptian','登记的丧葬文本与博物馆资料把太阳神描写为夜间穿越冥界的旅行者，并连接太阳舟概念；各墓葬文本版本仍须分别扩张。','The registered funerary and museum record presents the sun god as a traveler through the netherworld at night and connects the journey to the solar barque; individual funerary witnesses still require separate expansion.','["太阳","冥界","太阳舟","重生"]','PARTIAL','PUBLIC_CONTEXT',4,190,'博物馆对象说明、古代文本与现代综合保持分层。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.chinese.leize_thunder','The thunder spirit of Leize','《山海经》雷泽雷神片段','TEXT_FRAGMENT','civ.chinese_ancient','《山海经·海内东经》记下雷泽中的无名雷神，并把雷声与其击腹相连；此形象不自动等同后世雷公。','The Hai Nei Dong Jing records an unnamed thunder spirit in Leize and connects thunder with striking its belly; this figure is not automatically identified with later Leigong.','["山海经","雷泽","雷神","文本片段"]','SOURCE_BACKED','PUBLIC_CONTEXT',3,200,'保留原段落范围与后世身份区分。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z'),
('story.maori.creation_many','Many Maori creation traditions','毛利创世传统：不是单一版本','TRADITION_OVERVIEW','civ.maori','Te Ara明确说明毛利各部族保存多种创世传统，并非所有部族都有Io传统；本页只介绍公开层与访问边界。','Te Ara explicitly states that Maori iwi preserve many creation traditions and that not all iwi have an Io tradition; this page presents only the public layer and its access boundary.','["创世","部族版本","文化权限","毛利"]','SOURCE_BACKED','ATTRIBUTION_REQUIRED',4,210,'不收集或公开未经适当授权的部族专属、非公开或限制性知识。','2026-08-29T10:00:00Z','2026-08-29T10:00:00Z');

INSERT OR IGNORE INTO story_versions(
    id,story_id,version_label_zh,version_label_en,source_id,source_location,language_id,
    witness_scope,narrative_scope,evidence_status,access_level,version_order,rights_note,created_at
) VALUES
('storyver.greek.demeter_hymn2','story.greek.demeter_persephone','《荷马颂歌·致得墨忒耳》版本','Homeric Hymn to Demeter witness','source.greek.homeric_hymn_demeter.scaife','Hymn 2, lines 1–495','lang.grc','古希腊赞歌的数字文本见证','只转述已登记的劫持、寻找、厄琉息斯与回返／仪式框架','SOURCE_BACKED','PUBLIC_CONTEXT',1,'来源页面与现代呈现按其条款使用；本站仅发独立概述。','2026-08-29T10:00:00Z'),
('storyver.greek.titanomachy_theogony','story.greek.titanomachy','《神谱》617–735行','Theogony 617–735','source.greek.theogony.perseus_eng1','lines 617–735','lang.grc','赫西俄德《神谱》的英语数字版定位','神战、百臂巨人介入、雷霆与战败囚禁的本见证框架','SOURCE_BACKED','PUBLIC_CONTEXT',1,'Perseus呈现许可另见来源登记；本站正文为独立概述。','2026-08-29T10:00:00Z'),
('storyver.greek.typhon_theogony','story.greek.zeus_typhon','《神谱》820–885行','Theogony 820–885','source.greek.theogony.perseus_eng1','lines 820–885','lang.grc','赫西俄德提丰战斗段落','宙斯、提丰、雷霆武器与结果','SOURCE_BACKED','PUBLIC_CONTEXT',1,'独立概述。','2026-08-29T10:00:00Z'),
('storyver.greek.medea_library','story.greek.medea_restoration','《书库》1.9.28版本','Library 1.9.28','source.greek.apollodorus.library.topostext','Library 1.9.28','lang.grc','伪阿波罗多洛斯神话汇编见证','美狄亚回返、珀耳塞斯被杀、埃厄忒斯复位','SOURCE_BACKED','PUBLIC_CONTEXT',1,'独立概述。','2026-08-29T10:00:00Z'),
('storyver.greek.aphrodite_theogony','story.greek.aphrodite_origins','《神谱》海中诞生版本','Theogony sea-birth account','source.greek.theogony.perseus_eng1','lines 188–206','lang.grc','赫西俄德谱系诗见证','乌拉诺斯受创后的海中诞生叙事','SOURCE_BACKED','PUBLIC_CONTEXT',1,'独立概述。','2026-08-29T10:00:00Z'),
('storyver.greek.aphrodite_iliad','story.greek.aphrodite_origins','《伊利亚特》宙斯—狄俄涅谱系','Iliad Zeus-Dione genealogy','source.greek.iliad.scaife','Book 5, lines 370–372; Book 14, line 193','lang.grc','史诗中的亲属称谓见证','这不是完整诞生故事，而是父母谱系的文本见证','SOURCE_BACKED','PUBLIC_CONTEXT',2,'独立概述。','2026-08-29T10:00:00Z'),
('storyver.norse.ask_embla_voluspa','story.norse.ask_embla','《女巫预言》17–18节','Voluspa 17–18','source.norse.poetic_edda.gks2365','Völuspá stanzas 17–18','lang.non','《诗体埃达》手稿数字版见证','阿斯克、恩布拉以及奥丁、赫尼尔、洛杜尔的组合','SOURCE_BACKED','PUBLIC_CONTEXT',1,'电子版许可见来源登记；独立概述。','2026-08-29T10:00:00Z'),
('storyver.norse.ask_embla_gylf','story.norse.ask_embla','《欺骗古鲁菲》8–9章','Gylfaginning 8–9','source.norse.gylfaginning.vsnr2005','Gylfaginning 8–9','lang.non','斯诺里《埃达》学术版见证','阿斯克、恩布拉以及奥丁、维利、维的组合','SOURCE_BACKED','PUBLIC_CONTEXT',2,'学术版版权适用；本站仅发独立概述。','2026-08-29T10:00:00Z'),
('storyver.norse.forging_skald','story.norse.forging_treasures','《诗语法》第35章','Skaldskaparmal 35','source.norse.skaldskaparmal.vsnr1998','Skáldskaparmál 35','lang.non','斯诺里《诗语法》学术版见证','布罗克、铁匠及三件宝物的锻造序列','PARTIAL','PUBLIC_CONTEXT',1,'学术版版权适用；独立概述。','2026-08-29T10:00:00Z'),
('storyver.norse.hammer_thrymskvida','story.norse.hammer_recovery','《索列姆之歌》1–32节','Thrymskvida stanzas 1–32','source.norse.poetic_edda.gks2365','Þrymskviða stanzas 1–32','lang.non','《诗体埃达》手稿数字版见证','索尔寻找妙尔尼尔与洛基同行的已登记框架','PARTIAL','PUBLIC_CONTEXT',1,'电子版许可见来源登记；独立概述。','2026-08-29T10:00:00Z'),
('storyver.norse.ragnarok_gylf','story.norse.ragnarok','《欺骗古鲁菲》诸神黄昏段落','Gylfaginning Ragnarok account','source.norse.prose_edda.vsnr','Gylfaginning, Ragnarök account','lang.non','斯诺里《埃达》学术版见证','当前只开放已登记的奥丁与芬里尔参与层','PARTIAL','PUBLIC_CONTEXT',1,'不以现代再创作补齐。','2026-08-29T10:00:00Z'),
('storyver.norse.odin_mimir_gylf','story.norse.odin_mimir','《欺骗古鲁菲》第15章','Gylfaginning 15','source.norse.prose_edda.vsnr','Gylfaginning 15','lang.non','斯诺里《埃达》学术版见证','密米尔之泉与奥丁交换眼睛的段落','SOURCE_BACKED','PUBLIC_CONTEXT',1,'独立概述。','2026-08-29T10:00:00Z'),
('storyver.sumerian.inanna_etcsl','story.sumerian.inanna_descent','ETCSL作品1.4.1','ETCSL composition 1.4.1','source.sumerian.inanna_descent.etcsl','Composition 1.4.1','lang.sux','牛津ETCSL苏美尔复合文本与公开译文','当前登记伊南娜下降事件；细分章节将继续逐行扩张','PARTIAL','PUBLIC_CONTEXT',1,'ETCSL条款适用；本站仅发独立概述。','2026-08-29T10:00:00Z'),
('storyver.babylonian.enuma_elish','story.babylonian.marduk_tiamat','《埃努玛·埃利什》电子版','Electronic Babylonian Library witness','source.babylonian.enuma_elish.ebl','Poem of Creation corpus L/1/2','lang.akk','电子巴比伦图书馆数字校勘语料','当前登记马尔杜克与提亚马特的创世战斗参与层','PARTIAL','PUBLIC_CONTEXT',1,'语料与翻译条款依来源；本站仅发证据导读。','2026-08-29T10:00:00Z'),
('storyver.akkadian.anzu_oracc','story.akkadian.anzu_tablet','ORACC安祖叙事纲要','ORACC Anzu narrative synopsis','source.mesopotamia.anzu_ninurta.oracc','Anzu narrative synopsis','lang.akk','ORACC学术数字展览','安祖夺取泥板、宁努尔塔击败对手并取回泥板','SOURCE_BACKED','PUBLIC_CONTEXT',1,'不是全文译本；独立概述。','2026-08-29T10:00:00Z'),
('storyver.ugaritic.baal_yamm_ktu12','story.ugaritic.baal_yamm','KTU 1.2 IV见证','KTU 1.2 IV witness','source.ugaritic.ktu1_2.inventory.uchicago','KTU 1.2 IV','lang.uga','拉斯沙姆拉泥板库存与已登记学术见证','巴力、雅姆及有名武器的战斗层','PARTIAL','PUBLIC_CONTEXT',1,'库存记录不等于完整翻译；独立概述。','2026-08-29T10:00:00Z'),
('storyver.ugaritic.baal_mot_ktu15_16','story.ugaritic.baal_mot','KTU 1.5–1.6语料见证','KTU 1.5–1.6 corpus witness','source.ugaritic.baal_corpus_ktu15_16.goettingen','KTU 1.5–1.6 corpus overview','lang.uga','哥廷根巴力史诗语料与泥板对照','巴力、穆特、阿纳特参与的残缺事件序列','PARTIAL','PUBLIC_CONTEXT',1,'项目条款适用；独立概述。','2026-08-29T10:00:00Z'),
('storyver.vedic.indra_vritra_rv132','story.vedic.indra_vritra','《梨俱吠陀》1.32','Rigveda 1.32','source.vedic.rigveda.1_32.vhp','Mandala 1, Sukta 32, verses 1–15','lang.san','印度国家英迪拉甘地艺术中心吠陀遗产门户','因陀罗、弗栗多、金刚杵与水流的颂歌叙事','SOURCE_BACKED','PUBLIC_CONTEXT',1,'门户内容再使用须获许可；本站仅发独立概述。','2026-08-29T10:00:00Z'),
('storyver.japanese.eight_thunder_kojiki','story.japanese.eight_thunder_yomi','《古事记》黄泉段落索引','Kojiki Yomi episode index','source.japanese.kojiki_kami_index.kokugakuin','Upper Scroll, Yomi episode','lang.ojp','國學院大学《古事记》神名学术索引','八雷神名称与黄泉段落的见证范围','SOURCE_BACKED','PUBLIC_CONTEXT',1,'学术索引版权适用；元数据、定位与独立概述。','2026-08-29T10:00:00Z'),
('storyver.japanese.kamo_fudoki_fragment','story.japanese.kamo_arrow','《山城国风土记》逸文的学术条目','Academic record of the Yamashiro Fudoki fragment','source.japanese.kamo_genealogy.kokugakuin','Fragmentary Yamashiro no kuni fudoki genealogy discussion','lang.ojp','國學院大学神道百科对逸文的公开学术说明','玉依姬、红箭、火雷神与贺茂别雷大神的片段谱系','PARTIAL','ATTRIBUTION_REQUIRED',1,'保留来源署名；不复制现代条目正文。','2026-08-29T10:00:00Z'),
('storyver.egyptian.solar_met','story.egyptian.solar_night','大都会艺术博物馆馆藏说明层','Met Museum funerary-object context','source.egypt.nauny_book_dead.met.30_3_31','Nauny object catalogue context','lang.egy','娜乌妮《亡灵书》对象与公开馆藏说明','太阳神夜行冥界与太阳舟的博物馆／丧葬文本综合层','PARTIAL','PUBLIC_CONTEXT',1,'对象数据与开放图像遵守大都会条款；独立概述。','2026-08-29T10:00:00Z'),
('storyver.chinese.leize_shanhaijing','story.chinese.leize_thunder','《山海经·海内东经》见证','Hai Nei Dong Jing witness','source.chinese.shanhaijing_leize.ctext','Hai Nei Dong Jing','lang.lzh','传世《山海经》数字文本段落','雷泽地点、无名雷神与击腹发雷的短段','SOURCE_BACKED','PUBLIC_CONTEXT',1,'独立概述。','2026-08-29T10:00:00Z'),
('storyver.maori.creation_teara','story.maori.creation_many','Te Ara公开概述层','Te Ara public overview','source.maori.creation.teara','Māori creation traditions public overview','lang.mai','新西兰政府Te Ara的公开、具原住民语境的策展概述','只介绍多版本事实、Io分布差异和访问边界，不重述受限知识','SOURCE_BACKED','ATTRIBUTION_REQUIRED',1,'必须署名Te Ara；社区专属非公开材料默认不收集。','2026-08-29T10:00:00Z');

INSERT OR IGNORE INTO story_sections(
    id,story_version_id,section_order,heading_zh,heading_en,body_zh,body_en,
    anchor_claim_id,evidence_note,uncertainty_note
) VALUES
('storysec.demeter.1','storyver.greek.demeter_hymn2',1,'女儿被带走','The daughter is taken','赞歌开篇把珀耳塞福涅置于被带往冥界的事件中心，并说哈得斯在本见证中得到宙斯同意。','The hymn opens with Persephone at the center of the taking to the underworld and says that Hades acts with the consent of Zeus in this witness.','claim.v050.h2.hades_participated','《荷马颂歌·致得墨忒耳》1–32行。','这里只陈述本赞歌的叙事，不代表所有希腊版本。'),
('storysec.demeter.2','storyver.greek.demeter_hymn2',2,'得墨忒耳寻找','Demeter searches','得墨忒耳离开诸神寻找女儿。赫卡忒与赫利俄斯出现在寻找段落中，承担的角色以已登记的赞歌行号为限。','Demeter leaves the gods and searches for her daughter. Hecate and Helios appear in the search passage, with their roles limited to the registered hymn lines.','claim.v050.h2.demeter_participated','赞歌1–87行及25–62行的已登记Claims。','未把其他作者的寻找情节混入。'),
('storysec.demeter.3','storyver.greek.demeter_hymn2',3,'厄琉息斯与回返框架','Eleusis and the return framework','事件档案记录得墨忒耳来到厄琉息斯；赞歌继续处理珀耳塞福涅的回返安排及仪式建立。秘密仪式的内部内容没有从公开证据重构。','The event record brings Demeter to Eleusis; the hymn continues with arrangements for Persephone to return and the establishment of rites. The internal content of the mysteries is not reconstructed from public evidence.','claim.v050.h2.event_appears','赞歌事件索引与厄琉息斯资料层。','仪式内部内容明确保留为未知。'),
('storysec.titan.1','storyver.greek.titanomachy_theogony',1,'两方神族','Two divine sides','《神谱》的这一段把与克洛诺斯相连的泰坦置于宙斯及其盟友的对立面。','This passage of the Theogony sets the Titans associated with Cronus against Zeus and his allies.','claim.v050.theogony.cronus_participated_titanomachy','《神谱》617–735行。','“泰坦战争”是现代通行事件名，见证范围仍指向原诗行。'),
('storysec.titan.2','storyver.greek.titanomachy_theogony',2,'雷霆与战斗','Thunder and battle','宙斯是战斗的主要参与者；事件档案把雷、闪电和雷电武器记录为本段战斗手段，并记录百臂巨人的介入。','Zeus is a principal combatant; the event profile records thunder, lightning, and the thunderbolt as weapons in this passage and records the intervention of the Hundred-Handers.','claim.v050.theogony.zeus_participated_titanomachy','《神谱》617–735行的事件与参与者层。','没有把后世图像或现代叙事写入古诗。'),
('storysec.titan.3','storyver.greek.titanomachy_theogony',3,'战败与囚禁','Defeat and confinement','在这一见证中，泰坦战败并被囚入塔耳塔罗斯；这项结果不自动代表所有古代作者的细节完全相同。','In this witness, the Titans are defeated and confined in Tartarus; the result does not imply that every ancient author gives identical details.','claim.v050.theogony.titanomachy_appears','《神谱》617–735行及事件结果档案。','其他见证将在独立版本中比较。'),
('storysec.typhon.1','storyver.greek.typhon_theogony',1,'提丰出现','Typhon appears','赫西俄德的段落把提丰置于宙斯的对手位置，并以一场神圣冲突展开。','The Hesiodic passage places Typhon as the opponent of Zeus and unfolds as a divine conflict.','claim.typhon.participated_battle','《神谱》820–885行。','提丰的出身与形貌只在未来逐行版本中扩充。'),
('storysec.typhon.2','storyver.greek.typhon_theogony',2,'宙斯发动雷霆','Zeus unleashes thunder','事件档案记录宙斯以雷、闪电和雷电武器进攻；此处没有把后世宙斯武器造型反投到赫西俄德文本。','The event profile records Zeus attacking with thunder, lightning, and the thunderbolt; later visual forms of the weapon are not projected back into Hesiod.','claim.zeus.participated_typhon','《神谱》820–885行。','武器名与图像史须另行建模。'),
('storysec.typhon.3','storyver.greek.typhon_theogony',3,'本见证的结局','Outcome in this witness','提丰在赫西俄德的战斗段落中被击败；数据库把这个结局限定在该文本见证。','Typhon is defeated in the Hesiodic combat passage; the database scopes this outcome to that textual witness.','claim.typhon.participated_battle','《神谱》820–885行。','其他作者的结局版本未在本页合并。'),
('storysec.medea.1','storyver.greek.medea_library',1,'回到科尔喀斯','Return to Colchis','《书库》1.9.28把美狄亚写成返回科尔喀斯并采取行动的人物。','Library 1.9.28 presents Medea as the figure who returns to Colchis and acts.','claim.v090.medea_participated_restoration','《书库》1.9.28。','这是汇编中的短序列，不扩写对话或动机。'),
('storysec.medea.2','storyver.greek.medea_library',2,'同名者的结局','The fate of a namesake','在这一段中，被杀并被废黜的是赫利俄斯之子、埃厄忒斯兄弟的珀耳塞斯，而不是赫卡忒之父的泰坦珀耳塞斯。','The Perses killed and deposed here is the son of Helios and brother of Aeetes, not the Titan Perses who is father of Hecate.','claim.v090.perses_participated_restoration','《书库》1.9.28与同名实体审计。','严格防止同名人物合并。'),
('storysec.medea.3','storyver.greek.medea_library',3,'王位恢复','Restoration of the throne','短篇以埃厄忒斯恢复王位结束；当前证据没有为这一结局补写更长的政治过程。','The short sequence ends with Aeetes restored to the kingdom; the current evidence does not invent a longer political process.','claim.v090.aeetes_participated_restoration','《书库》1.9.28。','当前证据未说明的过程保持空缺。'),
('storysec.aphro.theogony.1','storyver.greek.aphrodite_theogony',1,'乌拉诺斯之后','After Uranus','《神谱》的出身叙事把阿佛洛狄忒的出现连接到乌拉诺斯受创后落入海中的身体部分。','The Theogony connects the appearance of Aphrodite to what falls into the sea after the wounding of Uranus.','claim.v050.theogony.aphrodite_origin','《神谱》188–206行。','本站以简洁概述处理古代文本中的身体暴力。'),
('storysec.aphro.theogony.2','storyver.greek.aphrodite_theogony',2,'海中诞生','Birth from the sea','这一见证叙述她从海中形成并显现，因此不使用“宙斯之女”作为此版本的出生框架。','This witness narrates her formation and appearance from the sea and therefore does not use the daughter-of-Zeus genealogy as its birth frame.','claim.v050.theogony.aphrodite_origin','《神谱》188–206行。','只说明此版本，不否定其他古代见证。'),
('storysec.aphro.theogony.3','storyver.greek.aphrodite_theogony',3,'版本边界','Version boundary','海中诞生是《神谱》的故事版本；《伊利亚特》的家谱称谓在下一版本单独阅读。','The sea birth is the Theogony version; the genealogy terms in the Iliad are read separately in the next version.','claim.v050.theogony.aphrodite_origin','冲突档案 conflict.greek.aphrodite_parentage_v050。','系统不裁定唯一正确版本。'),
('storysec.aphro.iliad.1','storyver.greek.aphrodite_iliad',1,'狄俄涅被称为母亲','Dione is called mother','《伊利亚特》第5卷写阿佛洛狄忒来到母亲狄俄涅身边。这是亲属称谓见证，不是完整诞生场景。','Iliad Book 5 presents Aphrodite coming to her mother Dione. This is a kinship witness, not a complete birth scene.','claim.v050.iliad5.aphrodite_child_dione','《伊利亚特》第5卷370–372行。','不要从一处称谓推演未叙述的出生过程。'),
('storysec.aphro.iliad.2','storyver.greek.aphrodite_iliad',2,'宙斯之女','Daughter of Zeus','《伊利亚特》第14卷又把阿佛洛狄忒称为宙斯之女，形成与《神谱》海中诞生不同的家谱层。','Iliad Book 14 also calls Aphrodite a daughter of Zeus, creating a genealogical layer different from the sea-birth account in the Theogony.','claim.v050.iliad14.aphrodite_child_zeus','《伊利亚特》第14卷193行。','“女儿”是文本称谓；本页不补写其出生情节。'),
('storysec.aphro.iliad.3','storyver.greek.aphrodite_iliad',3,'两个古代版本共存','Two ancient versions coexist','数据库保留《神谱》与《伊利亚特》的差异，并通过冲突档案让读者并排查看，而不是按名称或现代常识合并。','The database preserves the difference between the Theogony and the Iliad and exposes it through a conflict record instead of merging the accounts by name or modern convention.','claim.v050.iliad5.dione_mentioned','两个古代文本见证及显式冲突档案。','冲突状态保持开放。'),
('storysec.ask.voluspa.1','storyver.norse.ask_embla_voluspa',1,'阿斯克与恩布拉','Ask and Embla','《女巫预言》17–18节在最初人类段落中分别命名阿斯克与恩布拉。','Voluspa 17–18 names Ask and Embla in its first-human episode.','claim.v0190.voluspa_ask','《女巫预言》17–18节。','当前中文概述不复制现代译文。'),
('storysec.ask.voluspa.2','storyver.norse.ask_embla_voluspa',2,'诗歌中的三位神','The poetic triad','这段诗歌把奥丁、赫尼尔与洛杜尔放在同一创造人类场景中。','The poetic passage places Odin, Hoenir, and Lodurr together in the human-creation scene.','claim.v0190.voluspa_triad','《女巫预言》17–18节。','各神具体赐予项目将在逐词校勘后补充。'),
('storysec.ask.voluspa.3','storyver.norse.ask_embla_voluspa',3,'与散文版不同','Different from the prose account','这里记录的是诗歌三神组合；《欺骗古鲁菲》的奥丁、维利、维组合不会覆盖它。','This is the poetic triad; the Odin, Vili, and Ve grouping in Gylfaginning does not overwrite it.','claim.v0190.voluspa_embla','两个见证的版本对照。','差异保持为版本并存，而非人物自动等同。'),
('storysec.ask.gylf.1','storyver.norse.ask_embla_gylf',1,'散文中的最初人类','First humans in prose','《欺骗古鲁菲》8–9章同样命名阿斯克与恩布拉，构成散文版的人类起源见证。','Gylfaginning 8–9 also names Ask and Embla, forming the prose witness to human origins.','claim.v0190.gylf_ask','《欺骗古鲁菲》8–9章。','不把散文版当作诗歌版的简单翻译。'),
('storysec.ask.gylf.2','storyver.norse.ask_embla_gylf',2,'奥丁、维利与维','Odin, Vili, and Ve','散文序列把奥丁、维利与维列为博尔之子，并放在这一创造框架中。','The prose sequence identifies Odin, Vili, and Ve as sons of Borr and places them in this creation frame.','claim.v0190.gylf_triad','《欺骗古鲁菲》8–9章。','人物组合与《女巫预言》不同。'),
('storysec.ask.gylf.3','storyver.norse.ask_embla_gylf',3,'不强制对应','No forced equivalence','系统不把维利／维与赫尼尔／洛杜尔按功能相似强制合并；当前只呈现两个文本明确给出的名字。','The system does not force Vili and Ve to equal Hoenir and Lodurr by perceived functional similarity; it presents only the names explicit in each text.','claim.v0190.gylf_embla','两个独立来源见证。','身份对应留作研究问题。'),
('storysec.forge.1','storyver.norse.forging_skald',1,'锻造竞赛的参与者','Participants in the contest','《诗语法》第35章把布罗克与铁匠放入诸神宝物的锻造竞赛；名字Sindri/Eitri的关系另有身份审计。','Skaldskaparmal 35 places Brokkr and the smith in the forging contest for divine treasures; the Sindri and Eitri naming issue has a separate identity audit.','claim.brokkr.participated_forging','《诗语法》第35章。','姓名异文不在故事中粗暴合并。'),
('storysec.forge.2','storyver.norse.forging_skald',2,'三件宝物','Three treasures','当前登记的锻造序列产生古林博斯帝、德罗普尼尔和妙尔尼尔，分别连接到创造Claims。','The registered forging sequence produces Gullinbursti, Draupnir, and Mjolnir, each linked to creation claims.','claim.brokkr.creator_mjolnir','《诗语法》第35章与神器关系。','未登记的制造细节不在此补写。'),
('storysec.forge.3','storyver.norse.forging_skald',3,'交付诸神','Presented to the gods','事件档案以三件宝物被展示给诸神作为结果层；本页没有把现代武器能力清单当作中世纪文本。','The event profile ends with the three treasures presented to the gods; modern ability lists are not treated as medieval text.','claim.eitri.creator_draupnir','《诗语法》第35章的事件结果与神器Claims。','更完整竞赛过程仍待逐段证据化。'),
('storysec.hammer.1','storyver.norse.hammer_thrymskvida',1,'索尔寻找锤子','Thor seeks the hammer','《索列姆之歌》把索尔置于寻找妙尔尼尔的中心位置。','Thrymskvida places Thor at the center of the search for Mjolnir.','claim.v060.norse.thor_appears_thrymskvida','《索列姆之歌》1–32节。','当前版不扩写尚未逐节入库的情节。'),
('storysec.hammer.2','storyver.norse.hammer_thrymskvida',2,'洛基同行','Loki accompanies him','洛基在诗中同行并提供建议；这项同伴关系不表示索尔与洛基是兄弟。','Loki accompanies and advises him in the poem; this companionship does not make Thor and Loki brothers.','claim.v060.norse.loki_appears_thrymskvida','《索列姆之歌》1–32节与关系纠错Claim。','保持亲属关系与故事同伴关系分离。'),
('storysec.hammer.3','storyver.norse.hammer_thrymskvida',3,'寻回框架','Recovery frame','当前证据层确认两者共同处于妙尔尼尔寻回故事，但婚礼伪装与逐节行动尚未在本版本拆成独立Claims。','The current evidence layer confirms both figures in the recovery story, while the wedding disguise and stanza-by-stanza actions have not yet been modeled as separate claims.','claim.v060.norse.thor_loki_thrymskvida','诗歌整体定位1–32节。','详情将在后续逐节版本扩充。'),
('storysec.ragnarok.1','storyver.norse.ragnarok_gylf',1,'末世之战的登记层','Registered battle layer','当前数据库把诸神黄昏登记为世界终末与更新类型的神话事件。','The current database registers Ragnarok as a mythic event of world ending and renewal.','claim.norse.odin_participates_ragnarok','《欺骗古鲁菲》诸神黄昏段落。','完整事件阶段仍未全部结构化。'),
('storysec.ragnarok.2','storyver.norse.ragnarok_gylf',2,'奥丁与芬里尔','Odin and Fenrir','已验证的参与Claims把奥丁与芬里尔放入这场战斗。','Verified participant claims place Odin and Fenrir in this battle.','claim.norse.fenrir_participates_ragnarok','《欺骗古鲁菲》诸神黄昏段落。','其他参与者将在逐见证扩张后加入。'),
('storysec.ragnarok.3','storyver.norse.ragnarok_gylf',3,'不以流行文化补齐','No popular-culture completion','毁灭、存活与更新的完整次序仍是研究缺口；网页不会借电影或游戏情节把它补成“完整故事”。','The full order of destruction, survival, and renewal remains a research gap; films and games are not used to fill it into a supposedly complete story.','claim.norse.odin_participates_ragnarok','现有Claims与事件档案的范围限制。','明确标记为PARTIAL。'),
('storysec.mimir.1','storyver.norse.odin_mimir_gylf',1,'智慧之泉','The well of wisdom','《欺骗古鲁菲》第15章把密米尔写成密米尔之泉的主人或守护者，并把泉水与智慧相连。','Gylfaginning 15 presents Mimir as owner or keeper of Mimirs well and associates the well with wisdom.','claim.mimir.owns_well','《欺骗古鲁菲》第15章。','只采用登记到数据库的文本层。'),
('storysec.mimir.2','storyver.norse.odin_mimir_gylf',2,'奥丁的交换','Odins exchange','同一章说奥丁为了饮泉而交出一只眼睛。','The same chapter says that Odin gives an eye in order to drink from the well.','claim.odin.associated_mimisbrunnr','《欺骗古鲁菲》第15章。','不补写文本未登记的对话。'),
('storysec.mimir.3','storyver.norse.odin_mimir_gylf',3,'代价与知识','Cost and knowledge','故事阅读页把这段呈现为有来源的交换事件，而不是对北欧文化作普遍心理学解释。','The reading page presents the passage as a sourced exchange event, not as a universal psychological interpretation of Norse culture.','claim.odin.associated_mimisbrunnr','文本Claim与证据范围。','象征解释须有独立学术来源后才能加入。');

INSERT OR IGNORE INTO story_sections(
    id,story_version_id,section_order,heading_zh,heading_en,body_zh,body_en,
    anchor_claim_id,evidence_note,uncertainty_note
) VALUES
('storysec.inanna.1','storyver.sumerian.inanna_etcsl',1,'把心意转向地下','Turning toward the world below','作品1.4.1开篇说伊南娜把心意转向地下世界，并离开天与地展开下降。','Composition 1.4.1 opens with Inana setting her mind on the world below and leaving heaven and earth to descend.','claim.sumerian.inanna_participates_descent','ETCSL作品1.4.1开篇及事件参与Claim。','中文为独立转述，不复制ETCSL现代译文。'),
('storysec.inanna.2','storyver.sumerian.inanna_etcsl',2,'冥界事件','The netherworld event','数据库目前确认伊南娜是下降事件的参与者，并将其归为冥界旅程；门、裁决与复生阶段仍待逐行Claims。','The database currently confirms Inana as the participant in a descent event classified as an underworld journey; the gates, judgment, and revival still need line-level claims.','claim.sumerian.inanna_participates_descent','ETCSL作品1.4.1与现有事件档案。','细节未完成结构化。'),
('storysec.inanna.3','storyver.sumerian.inanna_etcsl',3,'替代者段落仍待扩张','The substitute sequence remains open','作品后段与伊南娜返回及替代者有关，但v0.25不在没有逐行证据链接时把整段写成已完成版本。','The later composition concerns Inanas return and a substitute, but v0.25 does not present the whole sequence as complete without line-level evidence links.','claim.sumerian.inanna_participates_descent','ETCSL完整作品链接已登记。','明确显示为资料缺口。'),
('storysec.marduk.1','storyver.babylonian.enuma_elish',1,'创世战斗的两方','The two sides of the creation combat','登记的《埃努玛·埃利什》Claims确认马尔杜克与提亚马特都参与这场创世战斗。','Registered Enuma elish claims confirm that both Marduk and Tiamat participate in the creation combat.','claim.babylonian.marduk_participates_combat','电子巴比伦图书馆语料L/1/2。','战斗逐步过程尚未入库。'),
('storysec.marduk.2','storyver.babylonian.enuma_elish',2,'数字校勘语料','A digital critical corpus','故事页直接连接电子巴比伦图书馆的数字语料，而不是引用无出处的现代故事改写。','The story page links directly to the electronic Babylonian Library corpus instead of relying on an unsourced modern retelling.','claim.babylonian.tiamat_participates_combat','电子巴比伦图书馆语料登记。','语料界面与翻译权利按来源条款。'),
('storysec.marduk.3','storyver.babylonian.enuma_elish',3,'当前版本的边界','Boundary of the current version','胜负、世界形成与王权确认的详细次序将在泥板逐行建模后加入；当前不把常见概述冒充已验证Claims。','The detailed order of victory, world formation, and kingship will be added after tablet-level modeling; common summaries are not presented as verified claims here.','claim.babylonian.marduk_participates_combat','当前Claim层与故事版本状态PARTIAL。','当前证据未细分这些阶段。'),
('storysec.anzu.1','storyver.akkadian.anzu_oracc',1,'命运泥板被夺','The Tablet is stolen','ORACC的学术纲要把安祖写成夺走命运泥板的对手。','The ORACC scholarly synopsis presents Anzu as the antagonist who steals the Tablet of Destinies.','claim.v0200.anzu_steals','ORACC Anzu narrative synopsis。','本站不是泥板全文译本。'),
('storysec.anzu.2','storyver.akkadian.anzu_oracc',2,'宁努尔塔出战','Ninurta fights','宁努尔塔在登记的叙事纲要中成为获胜的神圣英雄，并击败安祖。','Ninurta becomes the victorious divine hero in the registered synopsis and defeats Anzu.','claim.v0200.ninurta_defeats','ORACC Anzu narrative synopsis。','战斗动作的逐行细节未在当前层展开。'),
('storysec.anzu.3','storyver.akkadian.anzu_oracc',3,'泥板被取回','The Tablet is recovered','故事以宁努尔塔取回命运泥板作为当前证据层的结果。','The current evidence layer ends with Ninurta recovering the Tablet of Destinies.','claim.v0200.ninurta_recovers','ORACC Anzu narrative synopsis。','不同安祖文本版本将在后续分别建档。'),
('storysec.yamm.1','storyver.ugaritic.baal_yamm_ktu12',1,'泥板中的对手','Opponents on the tablet','KTU 1.2 IV把巴力与雅姆置于同一战斗事件中；库存记录确保故事锚定到具体泥板。','KTU 1.2 IV places Baal and Yamm in the same combat event; the inventory record anchors the story to a specific tablet.','claim.v060.ugaritic.event_appears_baal_cycle','KTU 1.2 IV库存与事件Claim。','库存页本身不是完整译文。'),
('storysec.yamm.2','storyver.ugaritic.baal_yamm_ktu12',2,'两件有名武器','Two named weapons','已登记的学术资料把Yagrush与Ayyamur列为巴力依次使用的有名武器。','Registered scholarship identifies Yagrush and Ayyamur as named weapons used in sequence by Baal.','claim.v060.ugaritic.baal_uses_yagrush','KTU 1.2 IV武器Claims。','武器中文名采用音译，不推定功能相同。'),
('storysec.yamm.3','storyver.ugaritic.baal_yamm_ktu12',3,'倒地与缺口','Fall and textual gaps','事件档案记录第二件武器使雅姆倒地；后续层仍受泥板状态与当前校勘范围限制。','The event profile records the second weapon bringing Yamm down; what follows remains limited by tablet condition and current editorial coverage.','claim.v060.ugaritic.baal_uses_ayyamur','KTU 1.2 IV事件结果与武器Claim。','不把残缺处补成连续对白。'),
('storysec.mot.1','storyver.ugaritic.baal_mot_ktu15_16',1,'巴力与穆特','Baal and Mot','KTU 1.5–1.6的语料登记把巴力与穆特放在同一残缺事件序列。','The KTU 1.5–1.6 corpus record places Baal and Mot in one fragmentary event sequence.','claim.v0200.event_baal','哥廷根语料与泥板对照。','不同泥板栏位尚未逐栏发布到本站。'),
('storysec.mot.2','storyver.ugaritic.baal_mot_ktu15_16',2,'阿纳特参与','Anat participates','阿纳特也被已验证的参与Claim连接到巴力—穆特的恢复序列。','A verified participant claim also links Anat to the Baal-Mot recovery sequence.','claim.v0200.event_anat','KTU 1.5–1.6语料概述。','具体动作等待逐栏校勘。'),
('storysec.mot.3','storyver.ugaritic.baal_mot_ktu15_16',3,'返回不等于死亡消失','Return is not the end of death','巴力在叙事序列中返回，但系统明确不把它解释为“死亡永久被消灭”的普遍命题。','Baal returns within the narrative sequence, but the system explicitly does not interpret this as a universal claim that death was permanently destroyed.','claim.v0200.event_no_permanent_death','解释限制Claim与故事事件档案。','避免把残缺神话普遍化。'),
('storysec.indra.1','storyver.vedic.indra_vritra_rv132',1,'颂歌中的对手','Opponents in the hymn','《梨俱吠陀》1.32把因陀罗列为主要行动者，把弗栗多列为他的对手。','Rigveda 1.32 identifies Indra as the principal agent and Vrtra as his opponent.','claim.v060.vedic.indra_participated_vrtra_event','RV 1.32.1–15。','本页只代表此颂歌见证。'),
('storysec.indra.2','storyver.vedic.indra_vritra_rv132',2,'金刚杵','The vajra','同一颂歌的登记Claims把金刚杵连接到因陀罗，并把其制造连接到陀湿多。','Claims registered from the same hymn connect the vajra to Indra and its making to Tvastr.','claim.v060.vedic.indra_uses_vajra','RV 1.32金刚杵见证。','不把后期佛教或图像版本反投到吠陀颂歌。'),
('storysec.indra.3','storyver.vedic.indra_vritra_rv132',3,'水流释放','Release of the waters','事件档案以对手被击杀、水得以流出作为颂歌叙事结果；它不是现代自然科学陈述。','The event profile records the opponent struck down and the waters flowing out as the narrative result of the hymn; it is not a modern scientific statement.','claim.v060.vedic.event_appears_rigveda','RV 1.32事件索引。','知识层保持为神话叙事／文本见证。'),
('storysec.eightthunder.1','storyver.japanese.eight_thunder_kojiki',1,'黄泉段落','The Yomi passage','学术神名索引把八位雷神定位到《古事记》上卷的黄泉段落，并说他们出现在伊邪那美身上。','The scholarly divine-name index locates the eight thunder kami in the Yomi episode of the upper Kojiki scroll and places them on Izanami.','claim.v060.japanese.eight_thunder_appears_kojiki','《古事记》上卷黄泉段落索引。','只采用公开学术索引范围。'),
('storysec.eightthunder.2','storyver.japanese.eight_thunder_kojiki',2,'八个独立名称','Eight distinct names','数据库为大雷、火雷、黑雷、拆雷、若雷、土雷、鸣雷与伏雷分别建档，不把八名压成一个泛称。','The database keeps Ooikazuchi, Honoikazuchi, Kuroikazuchi, Sakuikazuchi, Wakaikazuchi, Tsuchiikazuchi, Naruikazuchi, and Fusuikazuchi as separate records rather than one generic name.','claim.v060.japanese.ooikazuchi_member','八个成员Claims及神名索引。','部分名称的精细语义仍待校勘。'),
('storysec.eightthunder.3','storyver.japanese.eight_thunder_kojiki',3,'不自动等同地方神','No automatic local identification','鸣雷、若雷等相近名称在后世神社或地方传统中可能出现，但系统不会仅凭名字相似就认定为《古事记》中的同一神。','Similar names such as Naruikazuchi or Wakaikazuchi may occur in later shrine or local traditions, but name similarity alone does not establish identity with the Kojiki figures.','claim.v060.japanese.naruikazuchi_member','成员Claim及身份冲突档案。','身份关系保留为争议或未知。'),
('storysec.kamo.1','storyver.japanese.kamo_fudoki_fragment',1,'逸文而非完整原书','A fragment, not the complete work','资料来自《山城国风土记》逸文的学术说明；原书没有完整保存，因此系统不重建一部想象中的完整《风土记》。','The evidence comes from an academic account of a surviving Yamashiro Fudoki fragment; the full work is not extant, so the system does not reconstruct an imagined complete text.','claim.v0180.fragment_incomplete','國學院大学公开学术条目。','文本状态明确为fragment。'),
('storysec.kamo.2','storyver.japanese.kamo_fudoki_fragment',2,'玉依姬与红箭','Tamayorihime and the red arrow','逸文谱系点名玉依姬，并把红箭解释为乙训地区所祭火雷神的变化形。','The fragmentary genealogy names Tamayorihime and explains the red arrow as a transformed form of Honoikazuchi worshipped in Otokuni.','claim.v0180.fragment_mentions_hono','逸文谱系学术说明。','独立概述，不复制现代条目原文。'),
('storysec.kamo.3','storyver.japanese.kamo_fudoki_fragment',3,'贺茂别雷大神的出生谱系','Birth genealogy of Kamo Wakeikazuchi','现有Claims把玉依姬登记为母亲，把红箭所对应的火雷神登记为父系角色，并把结果连接到贺茂别雷大神。','Existing claims register Tamayorihime as mother, the thunder deity associated with the red arrow as the paternal figure, and Kamo Wakeikazuchi as the resulting child.','claim.v0100.tamayori_parent_kamo','逸文谱系的三个参与者Claims。','地方传统与《古事记》八雷神仍保持分离。'),
('storysec.solar.1','storyver.egyptian.solar_met',1,'夜间旅行者','Traveler by night','馆藏与丧葬文本说明把太阳神登记为夜间穿越冥界循环的旅行者。','The museum and funerary-text context registers the sun god as the traveler through a nocturnal netherworld cycle.','claim.v070.egypt.ra_participates_solar_journey','大都会艺术博物馆娜乌妮《亡灵书》对象说明。','博物馆说明与古代文本本身保持分层。'),
('storysec.solar.2','storyver.egyptian.solar_met',2,'太阳舟概念','The solar barque concept','研究层把夜行事件连接到现有太阳舟神器概念，但这项连接标记为综合解释，而非单件对象的物理属性。','The research layer connects the nocturnal journey to the solar-barque concept, but marks the connection as synthesis rather than a physical property of a single object.','claim.v070.egypt.solar_journey_barque','跨来源综合Claim。','知识层为学术综合／神话叙事。'),
('storysec.solar.3','storyver.egyptian.solar_met',3,'循环与再现','Cycle and re-emergence','事件档案把夜行与太阳再次出现的循环相连，同时说明各文本版本存在差异。','The event profile connects the nocturnal journey with renewed solar emergence while noting that textual versions differ.','claim.v070.egypt.solar_journey_amduat','馆藏说明与事件结果档案。','不同冥界书将在后续独立成版本。'),
('storysec.leize.1','storyver.chinese.leize_shanhaijing',1,'雷泽中的神','A spirit in Leize','《山海经·海内东经》的登记段落在雷泽描写一位无名雷神。','The registered Hai Nei Dong Jing passage describes an unnamed thunder spirit in Leize.','claim.v060.chinese.leize_appears_shanhaijing','《山海经·海内东经》。','“雷泽雷神”是数据库定位名，不是文本给出的专名。'),
('storysec.leize.2','storyver.chinese.leize_shanhaijing',2,'击腹发雷','Thunder from the belly','该段把雷声与神灵击打腹部相连，系统把它保存为文本中的神话叙述。','The passage connects thunder with the spirit striking its belly, and the system preserves this as a mythic statement in the text.','claim.v060.chinese.leize_thunder_scope','《山海经·海内东经》。','不把神话陈述当作自然科学解释。'),
('storysec.leize.3','storyver.chinese.leize_shanhaijing',3,'与后世雷公分开','Separate from later Leigong','因为文本没有给出后世雷公的专名与完整形象，系统不按“雷神”这个共通标签自动合并。','Because the passage does not give the later proper name and full image of Leigong, the system does not merge the figures under the generic label thunder god.','claim.v060.chinese.leize_thunder_scope','身份区分研究备注。','后世接受史将在独立版本中处理。'),
('storysec.maori.1','storyver.maori.creation_teara',1,'多种创世传统','Many creation traditions','Te Ara明确说明毛利拥有多种创世传统，不同部族讲述不同版本；因此本站没有建立单一“标准毛利创世故事”。','Te Ara explicitly states that Maori have many creation traditions and that iwi tell different versions; the site therefore does not create one standard Maori creation story.','claim.v0230.maori_many','Te Ara公开策展概述。','公开页面只处理来源允许的概括层。'),
('storysec.maori.2','storyver.maori.creation_teara',2,'Io传统并非普遍','Io is not universal','同一公开来源指出，并非所有部族都有Io传统；系统将这一差异保存为版本范围，而不是判断某一部族错误。','The same public source notes that not all iwi have an Io tradition; the system records this as version scope rather than judging any iwi to be wrong.','claim.v0230.maori_io','Te Ara公开概述。','不把一个部族版本推广为全体毛利传统。'),
('storysec.maori.3','storyver.maori.creation_teara',3,'权限先于收集','Permission before collection','部族专属、非公开或具限制性的内容默认不收集；只有适当权威给予明确范围许可后，才可建立受控记录。','Iwi-specific, non-public, or restricted material is not collected by default; a controlled record requires scoped permission from an appropriate authority.','claim.v0230.maori_permission','现有活态传统访问策略。','此处不展示受限故事内容。');

-- Connect every story version to the claims that justify its readable summary.
INSERT OR IGNORE INTO story_claim_links(story_version_id,claim_id,link_role)
SELECT 'storyver.greek.demeter_hymn2',id,'NARRATIVE_BASIS' FROM claims WHERE variant_group IN ('homeric_hymn.2.abduction','homeric_hymn.2.25-62','greek.hymn2.rites');
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.greek.titanomachy_theogony',id,'NARRATIVE_BASIS' FROM claims WHERE variant_group='hesiod.theogony.617-735';
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.greek.typhon_theogony',id,'NARRATIVE_BASIS' FROM claims WHERE variant_group='hesiod.theogony.820';
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.greek.medea_library',id,'NARRATIVE_BASIS' FROM claims WHERE variant_group='greek.perses.colchis.restoration';
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.greek.aphrodite_theogony',id,'VERSION_CONFLICT' FROM claims WHERE id='claim.v050.theogony.aphrodite_origin';
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.greek.aphrodite_iliad',id,'VERSION_CONFLICT' FROM claims WHERE id IN ('claim.v050.iliad14.aphrodite_child_zeus','claim.v050.iliad5.aphrodite_child_dione','claim.v050.iliad5.dione_mentioned');
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.norse.ask_embla_voluspa',id,'VERSION_CONFLICT' FROM claims WHERE variant_group IN ('norse.creation.voluspa','norse.creation.triad') AND id LIKE '%voluspa%';
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.norse.ask_embla_gylf',id,'VERSION_CONFLICT' FROM claims WHERE variant_group IN ('norse.creation.gylf','norse.creation.triad') AND id LIKE '%gylf%';
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.norse.forging_skald',id,'NARRATIVE_BASIS' FROM claims WHERE variant_group='skaldskaparmal.35';
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.norse.hammer_thrymskvida',id,'NARRATIVE_BASIS' FROM claims WHERE id IN ('claim.v060.norse.loki_appears_thrymskvida','claim.v060.norse.thor_appears_thrymskvida','claim.v060.norse.thor_loki_thrymskvida');
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.norse.ragnarok_gylf',id,'NARRATIVE_BASIS' FROM claims WHERE id IN ('claim.norse.fenrir_participates_ragnarok','claim.norse.odin_participates_ragnarok');
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.norse.odin_mimir_gylf',id,'NARRATIVE_BASIS' FROM claims WHERE variant_group='gylfaginning.15';
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.sumerian.inanna_etcsl',id,'NARRATIVE_BASIS' FROM claims WHERE id='claim.sumerian.inanna_participates_descent';
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.babylonian.enuma_elish',id,'NARRATIVE_BASIS' FROM claims WHERE id IN ('claim.babylonian.marduk_participates_combat','claim.babylonian.tiamat_participates_combat');
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.akkadian.anzu_oracc',id,'NARRATIVE_BASIS' FROM claims WHERE variant_group='mesopotamia.anzu.sequence';
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.ugaritic.baal_yamm_ktu12',id,'NARRATIVE_BASIS' FROM claims WHERE variant_group IN ('ugaritic.ktu1_2.event','ugaritic.ktu1_2.weapons');
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.ugaritic.baal_mot_ktu15_16',id,CASE WHEN id='claim.v0200.event_no_permanent_death' THEN 'EVIDENCE_LIMIT' ELSE 'NARRATIVE_BASIS' END FROM claims WHERE variant_group='ugarit.baal_mot.event';
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.vedic.indra_vritra_rv132',id,'NARRATIVE_BASIS' FROM claims WHERE variant_group IN ('rigveda.1.32.event','rigveda.1.32.vajra');
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.japanese.eight_thunder_kojiki',id,'NARRATIVE_BASIS' FROM claims WHERE variant_group='japanese.kojiki.eight_thunder';
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.japanese.kamo_fudoki_fragment',id,CASE WHEN id='claim.v0180.fragment_incomplete' THEN 'EVIDENCE_LIMIT' ELSE 'NARRATIVE_BASIS' END FROM claims WHERE variant_group IN ('japan.kamo.fragmentary_genealogy','japan.kamo.fragment_witness','japan.kamo.fragment_status');
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.egyptian.solar_met',id,'NARRATIVE_BASIS' FROM claims WHERE variant_group='egypt.nocturnal_solar_journey';
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.chinese.leize_shanhaijing',id,'NARRATIVE_BASIS' FROM claims WHERE variant_group='chinese.leize_thunder_spirit';
INSERT OR IGNORE INTO story_claim_links SELECT 'storyver.maori.creation_teara',id,CASE WHEN id IN ('claim.v0230.maori_permission','claim.v0230.maori_no_standard') THEN 'EVIDENCE_LIMIT' ELSE 'NARRATIVE_BASIS' END FROM claims WHERE variant_group='living_access.maori';

-- Derive story-to-entity navigation from linked claims while keeping every
-- witness-specific text/entity link explicit and reversible.
INSERT OR IGNORE INTO story_entity_links(story_id,story_version_id,entity_id,role,sort_order,notes)
SELECT sv.story_id,scl.story_version_id,c.subject_id,
       CASE e.primary_type
         WHEN 'DEITY' THEN 'CHARACTER' WHEN 'PRIMORDIAL_DEITY' THEN 'CHARACTER'
         WHEN 'HERO' THEN 'CHARACTER' WHEN 'CREATURE' THEN 'CHARACTER'
         WHEN 'MONSTER' THEN 'CHARACTER' WHEN 'GIANT' THEN 'CHARACTER'
         WHEN 'EVENT' THEN 'EVENT' WHEN 'TEXT' THEN 'TEXT'
         WHEN 'WEAPON' THEN 'ARTIFACT' WHEN 'ARTIFACT' THEN 'ARTIFACT'
         WHEN 'MYTHICAL_PLACE' THEN 'PLACE' WHEN 'ARCHAEOLOGICAL_SITE' THEN 'PLACE'
         ELSE 'RELATED' END,
       10,'Derived from an explicitly linked story claim subject.'
FROM story_claim_links scl
JOIN story_versions sv ON sv.id=scl.story_version_id
JOIN claims c ON c.id=scl.claim_id
JOIN entities e ON e.id=c.subject_id;

INSERT OR IGNORE INTO story_entity_links(story_id,story_version_id,entity_id,role,sort_order,notes)
SELECT sv.story_id,scl.story_version_id,c.object_entity_id,
       CASE e.primary_type
         WHEN 'DEITY' THEN 'CHARACTER' WHEN 'PRIMORDIAL_DEITY' THEN 'CHARACTER'
         WHEN 'HERO' THEN 'CHARACTER' WHEN 'CREATURE' THEN 'CHARACTER'
         WHEN 'MONSTER' THEN 'CHARACTER' WHEN 'GIANT' THEN 'CHARACTER'
         WHEN 'EVENT' THEN 'EVENT' WHEN 'TEXT' THEN 'TEXT'
         WHEN 'WEAPON' THEN 'ARTIFACT' WHEN 'ARTIFACT' THEN 'ARTIFACT'
         WHEN 'MYTHICAL_PLACE' THEN 'PLACE' WHEN 'ARCHAEOLOGICAL_SITE' THEN 'PLACE'
         ELSE 'RELATED' END,
       20,'Derived from an explicitly linked story claim object.'
FROM story_claim_links scl
JOIN story_versions sv ON sv.id=scl.story_version_id
JOIN claims c ON c.id=scl.claim_id
JOIN entities e ON e.id=c.object_entity_id
WHERE c.object_entity_id IS NOT NULL;

INSERT OR IGNORE INTO story_conflict_links(story_id,conflict_id,notes)
VALUES('story.greek.aphrodite_origins','conflict.greek.aphrodite_parentage_v050','The two ancient genealogy/origin witnesses remain visible as variants.');

INSERT OR IGNORE INTO explorer_feature_registry(
    feature_code,title_zh,title_en,feature_group,data_basis,evidence_caveat,
    status,introduced_in,display_order,updated_at,notes
) VALUES(
    'STORY_LIBRARY','神话故事阅读库','Myth story reading library','READING',
    'stories, story_versions, story_sections, story_claim_links, story_entity_links and source metadata',
    'Every section is an independent summary scoped to a named witness; gaps and variants remain visible.',
    'ACTIVE','0.25.0',15,'2026-08-29T10:00:00Z','Initial cross-civilization reading release with 21 stories and 23 witness versions.'
);

INSERT OR IGNORE INTO research_sessions(
    id,started_at,ended_at,scope,strategy,status,agent_or_process,notes
) VALUES(
    'research.20260829.v0250_story_library','2026-08-29T09:10:00Z','2026-08-29T10:00:00Z',
    'Cross-civilization readable story library and witness-specific narrative layer',
    'Turn existing source-backed event and claim clusters into readable Chinese-first stories without inventing missing plot or collapsing variants',
    'CHECKPOINT_COMPLETE','Codex persistent research pipeline',
    'Twenty-one stories, twenty-three witness versions and sixty-nine sections; public summaries omit evidence short quotes and restricted community material.'
);

UPDATE project_metadata SET value='0.25.0-story-reading-library-20260829',updated_at='2026-08-29T10:00:00Z' WHERE key='data_version';
UPDATE project_metadata SET value='34',updated_at='2026-08-29T10:00:00Z' WHERE key='schema_version';
UPDATE project_metadata SET value='2026-08-29T10:00:00Z',updated_at='2026-08-29T10:00:00Z' WHERE key='generated_at';

INSERT OR IGNORE INTO dataset_releases(
    id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes
) VALUES(
    'release.0.25.0',34,'0.25.0-story-reading-library-20260829',NULL,'2026-08-29T10:00:00Z',NULL,
    'Story reading library checkpoint: 21 cross-civilization stories, 23 witness-specific versions, 69 readable sections, explicit claim/entity/source links, variant boundaries and living-tradition access controls.'
);

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(34,'20260829_v0250_story_reading_library','2026-08-29T10:00:00Z');

COMMIT;
