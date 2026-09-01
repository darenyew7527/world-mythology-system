BEGIN IMMEDIATE;

-- v0.27 keeps every textual witness independent while adding a durable,
-- section-level comparison layer. Comparison rows are editorial navigation;
-- they never create a synthetic source text or an identity/common-origin claim.
CREATE TABLE IF NOT EXISTS story_witness_profiles (
    story_version_id TEXT PRIMARY KEY REFERENCES story_versions(id) ON DELETE CASCADE,
    work_title_original TEXT NOT NULL,
    work_title_transliteration TEXT,
    witness_label_original TEXT,
    witness_label_transliteration TEXT,
    language_id TEXT NOT NULL REFERENCES languages(id),
    script_name TEXT,
    source_location TEXT NOT NULL,
    editorial_note_zh TEXT NOT NULL,
    editorial_note_en TEXT NOT NULL,
    rights_boundary TEXT NOT NULL,
    created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS story_witness_comparisons (
    id TEXT PRIMARY KEY,
    story_id TEXT NOT NULL REFERENCES stories(id) ON DELETE CASCADE,
    comparison_order INTEGER NOT NULL CHECK(comparison_order >= 1),
    topic_zh TEXT NOT NULL,
    topic_en TEXT NOT NULL,
    comparison_scope TEXT NOT NULL
        CHECK(comparison_scope IN ('SHARED_ELEMENT','DIVERGENT_ACCOUNT','ASYMMETRIC_WITNESS','EXPLICIT_UNKNOWN')),
    synthesis_policy TEXT NOT NULL DEFAULT 'KEEP_SEPARATE'
        CHECK(synthesis_policy IN ('KEEP_SEPARATE','NO_SYNTHESIS')),
    editorial_note_zh TEXT NOT NULL,
    editorial_note_en TEXT NOT NULL,
    created_at TEXT NOT NULL,
    UNIQUE(story_id, comparison_order)
);

CREATE INDEX IF NOT EXISTS idx_story_witness_comparisons_story
    ON story_witness_comparisons(story_id, comparison_order, id);

CREATE TABLE IF NOT EXISTS story_witness_comparison_members (
    comparison_id TEXT NOT NULL REFERENCES story_witness_comparisons(id) ON DELETE CASCADE,
    story_version_id TEXT NOT NULL REFERENCES story_versions(id) ON DELETE CASCADE,
    story_section_id TEXT REFERENCES story_sections(id) ON DELETE SET NULL,
    member_order INTEGER NOT NULL CHECK(member_order >= 1),
    evidence_state TEXT NOT NULL
        CHECK(evidence_state IN ('ATTESTED','NOT_STATED','UNMODELED','DAMAGED','INFERRED')),
    original_form TEXT,
    transliteration TEXT,
    source_location TEXT NOT NULL,
    anchor_claim_id TEXT REFERENCES claims(id),
    summary_zh TEXT NOT NULL,
    summary_en TEXT NOT NULL,
    difference_note_zh TEXT NOT NULL,
    difference_note_en TEXT NOT NULL,
    created_at TEXT NOT NULL,
    PRIMARY KEY(comparison_id, story_version_id)
);

CREATE INDEX IF NOT EXISTS idx_story_witness_members_version
    ON story_witness_comparison_members(story_version_id, comparison_id);

INSERT OR IGNORE INTO story_witness_profiles(
    story_version_id,work_title_original,work_title_transliteration,
    witness_label_original,witness_label_transliteration,language_id,script_name,
    source_location,editorial_note_zh,editorial_note_en,rights_boundary,created_at
) VALUES
('storyver.greek.aphrodite_theogony','Θεογονία','Theogonía','Ἀφροδίτη','Aphrodítē','lang.grc','Greek','lines 188–206','作品名与神名保留希腊文；对读正文只发布独立中文概述。','Greek work and deity names are retained; the comparison publishes independent summaries only.','Perseus 呈现遵循 CC BY-SA；不复制长段现代译文。','2026-08-31T23:05:00Z'),
('storyver.greek.aphrodite_iliad','Ἰλιάς','Iliás','Ἀφροδίτη / Διώνη','Aphrodítē / Diṓnē','lang.grc','Greek','Book 5, lines 370–372; Book 14, line 193','两个定位是亲属称谓见证，不被补写成完整出生场景。','The two locators witness kinship language and are not expanded into a complete birth scene.','仅显示元数据、定位与独立概述；不批量复制译文。','2026-08-31T23:05:00Z'),
('storyver.norse.ask_embla_voluspa','Völuspá','Völuspá','Askr / Embla','Askr / Embla','lang.non','Latin manuscript transcription','Völuspá stanzas 17–18','采用电子校勘版的作品名与规范化古诺斯语人名；不复制完整诗节。','The electronic edition title and normalized Old Norse names are used without reproducing full stanzas.','电子版 CC BY-SA 4.0；手稿图像权利另从馆藏条款。','2026-08-31T23:05:00Z'),
('storyver.norse.ask_embla_gylf','Gylfaginning','Gylfaginning','Askr / Embla','Askr / Embla','lang.non','Latin manuscript transcription','Gylfaginning 8–9','斯诺里散文见证与诗歌见证分开，不把一者当作另一者的翻译。','Snorri’s prose witness remains separate from the poetic witness and is not treated as its translation.','现代校勘与编辑内容受版权保护；仅发布定位、元数据与独立概述。','2026-08-31T23:05:00Z');

INSERT OR IGNORE INTO story_witness_comparisons(
    id,story_id,comparison_order,topic_zh,topic_en,comparison_scope,synthesis_policy,
    editorial_note_zh,editorial_note_en,created_at
) VALUES
('wcomp.aphrodite.01_origin_scene','story.greek.aphrodite_origins',1,'起源／出生场景','Origin or birth scene','ASYMMETRIC_WITNESS','KEEP_SEPARATE','《神谱》提供叙事场景；《伊利亚特》所选定位只提供亲属称谓。','The Theogony provides a narrative scene; the selected Iliad passages provide kinship language only.','2026-08-31T23:05:00Z'),
('wcomp.aphrodite.02_mother_term','story.greek.aphrodite_origins',2,'母亲称谓','Maternal designation','ASYMMETRIC_WITNESS','KEEP_SEPARATE','“未陈述”不是反证，也不等于该文本否定狄俄涅。','Not stated is not counter-evidence and does not mean that the text rejects Dione.','2026-08-31T23:05:00Z'),
('wcomp.aphrodite.03_zeus_daughter','story.greek.aphrodite_origins',3,'宙斯之女称谓','Daughter-of-Zeus designation','ASYMMETRIC_WITNESS','KEEP_SEPARATE','称谓与海中诞生叙事并列保存，不强制统一。','The kinship designation and sea-birth narrative remain side by side without forced harmonization.','2026-08-31T23:05:00Z'),
('wcomp.aphrodite.04_editorial_result','story.greek.aphrodite_origins',4,'当前对读结论','Current comparison result','DIVERGENT_ACCOUNT','NO_SYNTHESIS','当前资料支持两个古代见证并存，不支持合成第三个统一版本。','The current record supports two coexisting ancient witnesses, not a third synthesized account.','2026-08-31T23:05:00Z'),
('wcomp.ask_embla.01_human_pair','story.norse.ask_embla',1,'最初人类姓名','Names of the first human pair','SHARED_ELEMENT','KEEP_SEPARATE','两份见证都明确命名阿斯克与恩布拉。','Both witnesses explicitly name Ask and Embla.','2026-08-31T23:05:00Z'),
('wcomp.ask_embla.02_divine_triad','story.norse.ask_embla',2,'参与的神祇组合','Participating divine triad','DIVERGENT_ACCOUNT','KEEP_SEPARATE','诗歌三神与散文三神分别记录；功能相似不能建立身份等同。','The poetic and prose triads are recorded separately; perceived functional similarity cannot establish identity.','2026-08-31T23:05:00Z'),
('wcomp.ask_embla.03_gift_lexemes','story.norse.ask_embla',3,'赐予项目的逐词层','Gift terms at word level','EXPLICIT_UNKNOWN','NO_SYNTHESIS','本检查点尚未完成两份古诺斯语见证的逐词对齐，故不补写具体赐予项目。','This checkpoint has not completed word-level alignment of the two Old Norse witnesses, so specific gifts are not supplied.','2026-08-31T23:05:00Z');

INSERT OR IGNORE INTO story_witness_comparison_members(
    comparison_id,story_version_id,story_section_id,member_order,evidence_state,
    original_form,transliteration,source_location,anchor_claim_id,
    summary_zh,summary_en,difference_note_zh,difference_note_en,created_at
) VALUES
('wcomp.aphrodite.01_origin_scene','storyver.greek.aphrodite_theogony','storysec.aphro.theogony.2',1,'ATTESTED','Ἀφροδίτη','Aphrodítē','Theogony, lines 188–206','claim.v050.theogony.aphrodite_origin','叙述阿佛洛狄忒在海中形成并显现。','Narrates Aphrodite forming and appearing from the sea.','这是完整叙事段落，而非单一亲属称谓。','This is a narrative passage rather than a single kinship designation.','2026-08-31T23:05:00Z'),
('wcomp.aphrodite.01_origin_scene','storyver.greek.aphrodite_iliad',NULL,2,'NOT_STATED','Ἀφροδίτη','Aphrodítē','Iliad 5.370–372; 14.193',NULL,'当前定位没有叙述完整出生过程。','The selected passages do not narrate a complete birth process.','只保留“当前定位未陈述”；不从沉默推演结论。','Only the absence in the selected locators is recorded; no conclusion is inferred from silence.','2026-08-31T23:05:00Z'),
('wcomp.aphrodite.02_mother_term','storyver.greek.aphrodite_theogony',NULL,1,'NOT_STATED','Ἀφροδίτη','Aphrodítē','Theogony, lines 188–206',NULL,'当前起源段落没有把狄俄涅称为母亲。','The selected origin passage does not call Dione the mother.','未陈述不等于文本否定狄俄涅。','Not stated does not mean that the text rejects Dione.','2026-08-31T23:05:00Z'),
('wcomp.aphrodite.02_mother_term','storyver.greek.aphrodite_iliad','storysec.aphro.iliad.1',2,'ATTESTED','Διώνη','Diṓnē','Iliad, Book 5, lines 370–372','claim.v050.iliad5.aphrodite_child_dione','文本把狄俄涅称为阿佛洛狄忒的母亲。','The passage designates Dione as Aphrodite’s mother.','这是亲属称谓见证，不是完整诞生叙事。','This is kinship evidence, not a complete birth narrative.','2026-08-31T23:05:00Z'),
('wcomp.aphrodite.03_zeus_daughter','storyver.greek.aphrodite_theogony',NULL,1,'NOT_STATED','Ἀφροδίτη','Aphrodítē','Theogony, lines 188–206',NULL,'当前起源段落没有使用“宙斯之女”称谓。','The selected origin passage does not use a daughter-of-Zeus designation.','只记录此段落的文本范围。','Only the scope of this passage is recorded.','2026-08-31T23:05:00Z'),
('wcomp.aphrodite.03_zeus_daughter','storyver.greek.aphrodite_iliad','storysec.aphro.iliad.2',2,'ATTESTED','Διὸς θυγάτηρ','Diòs thugátēr','Iliad, Book 14, line 193','claim.v050.iliad14.aphrodite_child_zeus','文本使用宙斯之女的称谓。','The passage uses a daughter-of-Zeus designation.','称谓不自动提供出生过程。','The designation does not automatically supply a birth process.','2026-08-31T23:05:00Z'),
('wcomp.aphrodite.04_editorial_result','storyver.greek.aphrodite_theogony','storysec.aphro.theogony.3',1,'ATTESTED','Θεογονία','Theogonía','Theogony, lines 188–206','claim.v050.theogony.aphrodite_origin','海中诞生见证独立保留。','The sea-birth witness remains independent.','不由《伊利亚特》称谓改写。','It is not rewritten by Iliadic kinship language.','2026-08-31T23:05:00Z'),
('wcomp.aphrodite.04_editorial_result','storyver.greek.aphrodite_iliad','storysec.aphro.iliad.3',2,'ATTESTED','Ἰλιάς','Iliás','Iliad 5.370–372; 14.193','claim.v050.iliad5.dione_mentioned','宙斯—狄俄涅亲属见证独立保留。','The Zeus-Dione kinship witness remains independent.','不被改写为《神谱》海中诞生。','It is not rewritten as the Theogony sea birth.','2026-08-31T23:05:00Z'),
('wcomp.ask_embla.01_human_pair','storyver.norse.ask_embla_voluspa','storysec.ask.voluspa.1',1,'ATTESTED','Askr / Embla','Askr / Embla','Völuspá 17–18','claim.v0190.voluspa_ask','诗歌见证命名阿斯克与恩布拉。','The poetic witness names Ask and Embla.','两个人名是共享元素；叙述细节仍按见证分开。','The two names are shared elements; narrative details remain witness-specific.','2026-08-31T23:05:00Z'),
('wcomp.ask_embla.01_human_pair','storyver.norse.ask_embla_gylf','storysec.ask.gylf.1',2,'ATTESTED','Askr / Embla','Askr / Embla','Gylfaginning 8–9','claim.v0190.gylf_ask','散文见证同样命名阿斯克与恩布拉。','The prose witness also names Ask and Embla.','同名不使散文成为诗歌的简单复本。','Shared names do not make the prose a simple copy of the poem.','2026-08-31T23:05:00Z'),
('wcomp.ask_embla.02_divine_triad','storyver.norse.ask_embla_voluspa','storysec.ask.voluspa.2',1,'ATTESTED','Óðinn / Hœnir / Lóðurr','Óðinn / Hœnir / Lóðurr','Völuspá 17–18','claim.v0190.voluspa_triad','诗歌列出奥丁、赫尼尔与洛杜尔。','The poem presents Odin, Hoenir, and Lodurr.','不把赫尼尔／洛杜尔自动等同于维利／维。','Hoenir and Lodurr are not automatically equated with Vili and Ve.','2026-08-31T23:05:00Z'),
('wcomp.ask_embla.02_divine_triad','storyver.norse.ask_embla_gylf','storysec.ask.gylf.2',2,'ATTESTED','Óðinn / Vili / Vé','Óðinn / Vili / Vé','Gylfaginning 8–9','claim.v0190.gylf_triad','散文列出奥丁、维利与维。','The prose presents Odin, Vili, and Ve.','神祇组合差异保持为文本版本差异。','The difference in divine groupings remains a textual variant.','2026-08-31T23:05:00Z'),
('wcomp.ask_embla.03_gift_lexemes','storyver.norse.ask_embla_voluspa',NULL,1,'UNMODELED','Völuspá 18','Völuspá 18','Völuspá 17–18',NULL,'具体赐予项目尚未进入逐词对齐表。','Specific gifts have not yet entered the word-level alignment layer.','当前证据未说明于本结构化检查点；保留为研究队列。','The current structured checkpoint does not state them; the gap remains queued.','2026-08-31T23:05:00Z'),
('wcomp.ask_embla.03_gift_lexemes','storyver.norse.ask_embla_gylf',NULL,2,'UNMODELED','Gylfaginning 9','Gylfaginning 9','Gylfaginning 8–9',NULL,'具体赐予项目尚未进入逐词对齐表。','Specific gifts have not yet entered the word-level alignment layer.','不凭现代通俗转述补齐。','Modern popular retellings are not used to fill the gap.','2026-08-31T23:05:00Z');

INSERT OR IGNORE INTO conflicts(
    id,subject_id,variant_group,claim_a_id,claim_b_id,conflict_type,status,summary,resolution_notes
) VALUES
('conflict.v0270.norse.ask_embla_creator_triads','person.norse.ask','norse.ask_embla.creator_triads','claim.v0190.voluspa_triad','claim.v0190.gylf_triad','WITNESS_VARIANT','OPEN','Völuspá 17–18 presents Óðinn, Hœnir and Lóðurr, while Gylfaginning 8–9 presents Óðinn, Vili and Vé in the Ask–Embla creation frame.','Retain the poetic and prose triads as coexisting witnesses. Do not equate the differing deities without separate source-backed identity claims.');

INSERT OR IGNORE INTO story_conflict_links(story_id,conflict_id,notes) VALUES
('story.norse.ask_embla','conflict.v0270.norse.ask_embla_creator_triads','v0.27 section-level witness comparison; no forced equivalence.');

UPDATE stories
   SET editorial_note='两个古代见证逐段并列；“未陈述”与“已见证”分开，不合成统一出生叙事。',
       updated_at='2026-08-31T23:05:00Z'
 WHERE id='story.greek.aphrodite_origins';

UPDATE stories
   SET editorial_note='诗歌与散文见证逐段并列；神祇组合差异进入显式冲突档案，逐词赐予层保持未建模。',
       updated_at='2026-08-31T23:05:00Z'
 WHERE id='story.norse.ask_embla';

INSERT OR IGNORE INTO explorer_feature_registry(
    feature_code,title_zh,title_en,feature_group,data_basis,evidence_caveat,status,
    introduced_in,display_order,updated_at,notes
) VALUES
('story_witness_comparison','原典见证对读','Witness-by-witness comparison','STORY_READING','story_witness_profiles, story_witness_comparisons and comparison members','Alignment is editorial navigation. NOT_STATED and UNMODELED are explicit gaps, not negative claims.','ACTIVE','v0.27.0',280,'2026-08-31T23:05:00Z','First batch covers Aphrodite origins and Ask/Embla creator triads.');

INSERT OR IGNORE INTO collection_queue(
    id,target_label,normalized_label,proposed_entity_type,civilization_id,
    discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,
    discovery_context,priority,status,attempts,last_error,next_action,created_at,updated_at
) VALUES
('queue.v0270.norse.ask_embla_gift_lexemes','Ask and Embla gift-term word alignment','ask embla gift term word alignment','TEXT','civ.norse','text.norse.voluspa.st17_18','claim.v0190.voluspa_triad','source.norse.poetic_edda.gks2365','v0.27 comparison keeps the gift terms UNMODELED until both witnesses can be aligned at word level.',99,'DISCOVERED',0,NULL,'Collate normalized Old Norse forms in Völuspá 18 and Gylfaginning 9 from authorized editions; record lexical uncertainty without copying modern translations.','2026-08-31T23:05:00Z','2026-08-31T23:05:00Z'),
('queue.v0270.ugaritic.baal_witness_alignment','Baal Cycle tablet-by-tablet witness alignment','baal cycle tablet by tablet witness alignment','TEXT','civ.ugaritic','deity.ugaritic.baal',NULL,'source.ugaritic.baal_corpus.goettingen','The v0.27 comparison schema exposes the next roadmap target: damaged and edition-dependent KTU segments.',98,'DISCOVERED',0,NULL,'Align KTU 1.2, 1.5 and 1.6 only where an authorized edition supplies exact columns and damage status; never synthesize a continuous modern narrative.','2026-08-31T23:05:00Z','2026-08-31T23:05:00Z'),
('queue.v0270.japanese.thunder_homonym_alignment','Japanese thunder homonym and local-witness alignment','japanese thunder homonym local witness alignment','DEITY','civ.japanese_shinto','deity.japanese.honoikazuchi_otokuni','claim.v0100.hono_parent_kamo','source.japanese.kamo_genealogy.kokugakuin','The v0.27 comparison schema can expose name matches while preserving Yomi, Kamo and local shrine contexts.',98,'CONFLICT',0,NULL,'Create source-specific witness rows for Kojiki, Yamashiro Fudoki fragments and shrine records; retain separate entity IDs unless explicit identity evidence is found.','2026-08-31T23:05:00Z','2026-08-31T23:05:00Z');

INSERT OR IGNORE INTO queue_discoveries(
    id,queue_id,discovered_from_entity_id,discovered_from_claim_id,
    discovered_from_source_id,discovery_context,discovered_at
) VALUES
('qdisc.v0270.ask_embla_gifts','queue.v0270.norse.ask_embla_gift_lexemes','text.norse.voluspa.st17_18','claim.v0190.voluspa_triad','source.norse.poetic_edda.gks2365','Section alignment is complete, but gift-term philology remains deliberately unmodeled.','2026-08-31T23:05:00Z'),
('qdisc.v0270.baal_alignment','queue.v0270.ugaritic.baal_witness_alignment','deity.ugaritic.baal',NULL,'source.ugaritic.baal_corpus.goettingen','The roadmap target requires damaged-text-aware alignment rather than story synthesis.','2026-08-31T23:05:00Z'),
('qdisc.v0270.thunder_alignment','queue.v0270.japanese.thunder_homonym_alignment','deity.japanese.honoikazuchi_otokuni','claim.v0100.hono_parent_kamo','source.japanese.kamo_genealogy.kokugakuin','Shared written names require local witness comparison without identity collapse.','2026-08-31T23:05:00Z');

INSERT OR IGNORE INTO research_sessions(
    id,started_at,ended_at,scope,strategy,status,agent_or_process,notes
) VALUES
('session.20260831.v0270','2026-08-31T22:40:00Z','2026-08-31T23:05:00Z','v0.27 original-witness comparison for Aphrodite origins and Ask/Embla creation witnesses','Reused already registered primary and scholarly digital witnesses; modeled aligned, not-stated and unmodeled states without reproducing modern translations.','COMPLETED','Codex','Incremental append-only expansion from v0.26.0; Baal and Japanese thunder comparison remain queued.');

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result) VALUES
('session.20260831.v0270','SCHEMA','story_witness_profiles','CREATE','Original titles, transliterations, language metadata and rights boundaries added.'),
('session.20260831.v0270','SCHEMA','story_witness_comparisons','CREATE','Section-level comparison topics and no-synthesis policies added.'),
('session.20260831.v0270','STORY','story.greek.aphrodite_origins','COMPARE','Four asymmetric comparison rows preserve Theogony and Iliad witnesses.'),
('session.20260831.v0270','STORY','story.norse.ask_embla','COMPARE','Shared names, divergent triads and unmodeled gift terms exposed.'),
('session.20260831.v0270','CONFLICT','conflict.v0270.norse.ask_embla_creator_triads','CREATE','Poetic and prose creator triads retained as source-level variants.');

INSERT OR IGNORE INTO schema_migrations(version,name,applied_at) VALUES
(36,'20260831_v0270_witness_comparison','2026-08-31T23:05:00Z');

INSERT OR IGNORE INTO dataset_releases(
    id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes
) VALUES
('release.v0.27.0',36,'0.27.0',NULL,'2026-08-31T23:05:00Z',NULL,'Original-witness comparison checkpoint: four witness profiles, seven section-level comparison topics, fourteen witness members, explicit NOT_STATED and UNMODELED states, and an Ask/Embla creator-triad conflict.');

INSERT INTO project_metadata(key,value,updated_at) VALUES
('project_version','0.27.0-original-witness-comparison','2026-08-31T23:05:00Z'),
('project_status','Sustainable expansion baseline; never ALL COMPLETE','2026-08-31T23:05:00Z'),
('story_witness_policy','Witnesses remain separate; alignments are editorial navigation; NOT_STATED and UNMODELED never become inferred facts','2026-08-31T23:05:00Z')
ON CONFLICT(key) DO UPDATE SET value=excluded.value,updated_at=excluded.updated_at;

COMMIT;
