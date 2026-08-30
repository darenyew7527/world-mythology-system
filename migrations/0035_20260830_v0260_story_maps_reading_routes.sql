BEGIN IMMEDIATE;

CREATE TABLE IF NOT EXISTS story_event_nodes (
    id TEXT PRIMARY KEY,
    story_version_id TEXT NOT NULL REFERENCES story_versions(id) ON DELETE CASCADE,
    event_order INTEGER NOT NULL CHECK(event_order >= 1),
    title_zh TEXT NOT NULL,
    title_en TEXT NOT NULL,
    summary_zh TEXT NOT NULL,
    summary_en TEXT NOT NULL,
    anchor_claim_id TEXT REFERENCES claims(id),
    event_entity_id TEXT REFERENCES entities(id),
    place_entity_id TEXT REFERENCES entities(id),
    location_kind TEXT NOT NULL DEFAULT 'UNSPECIFIED' CHECK(location_kind IN ('REAL_SITE','MYTHIC_PLACE','TEXTUAL_PLACE','UNSPECIFIED')),
    coordinate_policy TEXT NOT NULL DEFAULT 'NO_COORDINATE' CHECK(coordinate_policy IN ('VERIFIED_COORDINATE','ENTITY_PROFILE_ONLY','NO_COORDINATE','NOT_APPLICABLE')),
    evidence_status TEXT NOT NULL DEFAULT 'SOURCE_BACKED' CHECK(evidence_status IN ('UNVERIFIED','PARTIAL','SOURCE_BACKED','CONFLICTING')),
    uncertainty_note TEXT,
    created_at TEXT NOT NULL,
    UNIQUE(story_version_id,event_order)
);
CREATE INDEX IF NOT EXISTS idx_story_event_nodes_place ON story_event_nodes(place_entity_id,story_version_id,event_order);

CREATE TABLE IF NOT EXISTS reading_routes (
    id TEXT PRIMARY KEY,
    title_zh TEXT NOT NULL,
    title_en TEXT NOT NULL,
    route_type TEXT NOT NULL CHECK(route_type IN ('THEME','PLACE','WITNESS','ARTIFACT','CONFLICT')),
    description_zh TEXT NOT NULL,
    description_en TEXT NOT NULL,
    evidence_policy TEXT NOT NULL,
    featured_order INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS reading_route_steps (
    route_id TEXT NOT NULL REFERENCES reading_routes(id) ON DELETE CASCADE,
    step_order INTEGER NOT NULL CHECK(step_order >= 1),
    story_id TEXT NOT NULL REFERENCES stories(id) ON DELETE CASCADE,
    story_version_id TEXT REFERENCES story_versions(id) ON DELETE CASCADE,
    focus_entity_id TEXT REFERENCES entities(id),
    rationale_zh TEXT NOT NULL,
    rationale_en TEXT NOT NULL,
    transition_note TEXT,
    PRIMARY KEY(route_id,step_order),
    UNIQUE(route_id,story_id,story_version_id)
);
CREATE INDEX IF NOT EXISTS idx_reading_route_steps_story ON reading_route_steps(story_id,story_version_id,route_id);

-- Two public ritual narratives selected from the permanent queue. They remain
-- distinct from secret initiation content and from modern imaginative retellings.
INSERT OR IGNORE INTO entities(
    id,canonical_name,name_zh,original_name,transliteration,primary_type,
    primary_civilization_id,historical_period,description,research_status,
    evidence_status,record_version,metadata_json,created_at,updated_at
) VALUES
('site.egypt.karnak_luxor_processional_way','Processional way between Karnak and Luxor','卡纳克—卢克索仪仗道',NULL,NULL,'ARCHAEOLOGICAL_SITE','civ.egyptian','New Kingdom and later','The real processional connection between Karnak and Luxor described by the Egyptian Ministry. It is not treated as a mythical location or assigned inferred coordinates.','BASELINE_COMPLETE','SOURCE_BACKED',1,'{"coordinate_policy":"no_inferred_coordinates","scope":"official site description"}','2026-08-30T03:30:00Z','2026-08-30T03:30:00Z'),
('site.greece.eleusinion_athens','Eleusinion at Athens','雅典厄琉西尼翁圣所',NULL,'Eleusinion','ARCHAEOLOGICAL_SITE','civ.greek','Ancient Greek','The Athenian sanctuary context identified by the Acropolis Museum as the starting setting for the public Eleusinian procession. Exact coordinates are not asserted in this baseline.','BASELINE_COMPLETE','SOURCE_BACKED',1,'{"coordinate_policy":"no_inferred_coordinates","scope":"museum exhibition record"}','2026-08-30T03:30:00Z','2026-08-30T03:30:00Z');

INSERT OR IGNORE INTO names(id,entity_id,name_text,normalized_text,language_id,script_name,name_type,is_preferred,source_id,notes) VALUES
('name.v0260.processional_way.en','site.egypt.karnak_luxor_processional_way','Processional way between Karnak and Luxor','processional way between karnak and luxor','lang.en','Latin','PREFERRED',1,'source.egypt.luxor.mota','Official-site descriptive name; not an ancient proper name.'),
('name.v0260.processional_way.zh','site.egypt.karnak_luxor_processional_way','卡纳克—卢克索仪仗道','卡纳克卢克索仪仗道','lang.zh','Han','TRANSLATION',1,'source.egypt.luxor.mota','Editorial Chinese translation.'),
('name.v0260.eleusinion.en','site.greece.eleusinion_athens','Eleusinion at Athens','eleusinion at athens','lang.en','Latin','PREFERRED',1,'source.greek.eleusis_acropolis_exhibition2018','Museum catalogue wording.'),
('name.v0260.eleusinion.zh','site.greece.eleusinion_athens','雅典厄琉西尼翁圣所','雅典厄琉西尼翁圣所','lang.zh','Han','TRANSLATION',1,'source.greek.eleusis_acropolis_exhibition2018','Editorial Chinese translation.');

INSERT OR IGNORE INTO place_profiles(
    entity_id,place_type,ancient_name,modern_name,country_code,latitude,longitude,
    date_range,architecture_summary,excavation_summary,major_finds_summary,
    unesco_status,reality_status,evidence_grade
) VALUES
('site.egypt.karnak_luxor_processional_way','PROCESSIONAL_WAY',NULL,'Karnak–Luxor processional connection','EG',NULL,NULL,'New Kingdom and later','Official record says the temples were linked by a sphinx-bordered processional way.',NULL,'Opet procession route context',NULL,'REAL_ARCHAEOLOGICAL','OFFICIAL_SITE_RECORD'),
('site.greece.eleusinion_athens','SANCTUARY','Eleusinion','Athens Eleusinion','GR',NULL,NULL,'Ancient Greek',NULL,NULL,'Museum record notes finds from the sanctuary in the route exhibition.',NULL,'REAL_ARCHAEOLOGICAL','OFFICIAL_MUSEUM_RECORD');

INSERT OR IGNORE INTO claims(
    id,subject_id,predicate,object_entity_id,object_literal,object_datatype,statement,
    variant_group,claim_status,confidence,confidence_level,review_status,assertion_scope,
    knowledge_layer,tradition_scope,temporal_scope,research_notes,created_at
) VALUES
('claim.v0260.opet_way_karnak','site.egypt.karnak_luxor_processional_way','ASSOCIATED_WITH','site.egypt.karnak',NULL,NULL,'The official Luxor Temple record identifies a processional way linking Luxor Temple with Karnak.','egypt.opet.route','SUPPORTED',0.96,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Egyptian official monument record','New Kingdom and later','No route geometry or coordinates inferred.','2026-08-30T03:30:00Z'),
('claim.v0260.opet_way_luxor','site.egypt.karnak_luxor_processional_way','ASSOCIATED_WITH','site.egypt.luxor_temple',NULL,NULL,'The official Luxor Temple record identifies Luxor Temple as the southern endpoint of the processional connection with Karnak.','egypt.opet.route','SUPPORTED',0.96,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Egyptian official monument record','New Kingdom and later','No route geometry or coordinates inferred.','2026-08-30T03:30:00Z'),
('claim.v0260.opet_way_sphinxes','site.egypt.karnak_luxor_processional_way','HAS_APPEARANCE_OF',NULL,'a processional way bordered with sphinxes','TEXT', 'The Egyptian Ministry description says the processional way between Karnak and Luxor was bordered with sphinxes.','egypt.opet.route','SUPPORTED',0.94,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Egyptian official monument record','Official page accessed 2026-08-30','Description only; no claim that every surviving segment has the same date.','2026-08-30T03:30:00Z'),
('claim.v0260.opet_visits_amenemopet','festival.egyptian.opet','ASSOCIATED_WITH',NULL,'visit to the god Amenemopet at Luxor Temple','TEXT','The official record explains the procession as bringing the cult images from Karnak to visit Amenemopet at Luxor Temple.','egypt.opet.public_site_record','SUPPORTED',0.94,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Egyptian official monument record','Official page accessed 2026-08-30','Amenemopet remains a literal in this batch; no identity merger is made.','2026-08-30T03:30:00Z'),
('claim.v0260.opet_colonnade_scenes','site.egypt.luxor_temple','DEPICTS','festival.egyptian.opet',NULL,NULL,'The official Luxor Temple record states that the Great Colonnade decoration includes scenes depicting the Opet Festival.','egypt.opet.visual_witness','SUPPORTED',0.96,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Egyptian official monument record','Tutankhamun and Horemheb completion phase','This is a monument-description claim, not a full iconographic edition.','2026-08-30T03:30:00Z'),
('claim.v0260.eleusinion_procession_start','festival.greek.great_eleusinia','ASSOCIATED_WITH','site.greece.eleusinion_athens',NULL,NULL,'The Acropolis Museum record places the beginning of the Mysteries religious procession in Athens and includes the Athenian Eleusinion in the route context.','greek.eleusis.procession','SUPPORTED',0.91,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Acropolis Museum public exhibition record','Museum page accessed 2026-08-30','The page supports the public route context, not reconstruction of secret rites.','2026-08-30T03:30:00Z'),
('claim.v0260.eleusinia_culminates_telesterion','festival.greek.great_eleusinia','ASSOCIATED_WITH','site.greece.eleusis_telesterion',NULL,NULL,'The Acropolis Museum exhibition record says the procession culminated at the Telesterion in the sanctuary of Eleusis.','greek.eleusis.procession','SUPPORTED',0.94,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Acropolis Museum public exhibition record','Museum page accessed 2026-08-30','No secret initiation content is inferred from the route endpoint.','2026-08-30T03:30:00Z');

INSERT OR IGNORE INTO evidence(
    id,claim_id,source_id,source_location,line,evidence_type,direction,strength,research_notes
) VALUES
('evidence.v0260.opet_way_karnak','claim.v0260.opet_way_karnak','source.egypt.luxor.mota','Luxor Temple official page, monument description','web lines 129–132','OFFICIAL_SITE','SUPPORTS',0.96,'Freshly rechecked 2026-08-30.'),
('evidence.v0260.opet_way_luxor','claim.v0260.opet_way_luxor','source.egypt.luxor.mota','Luxor Temple official page, monument description','web lines 129–132','OFFICIAL_SITE','SUPPORTS',0.96,'Freshly rechecked 2026-08-30.'),
('evidence.v0260.opet_way_sphinxes','claim.v0260.opet_way_sphinxes','source.egypt.luxor.mota','Luxor Temple official page, first descriptive paragraph','web line 131','OFFICIAL_SITE','SUPPORTS',0.94,'Metadata and locator only in public snapshot.'),
('evidence.v0260.opet_visits_amenemopet','claim.v0260.opet_visits_amenemopet','source.egypt.luxor.mota','Luxor Temple official page, Opet paragraph','web line 132','OFFICIAL_SITE','SUPPORTS',0.94,'Independent summary; page text is not republished.'),
('evidence.v0260.opet_colonnade_scenes','claim.v0260.opet_colonnade_scenes','source.egypt.luxor.mota','Luxor Temple official page, Great Colonnade paragraph','web line 134','OFFICIAL_SITE','SUPPORTS',0.96,'Freshly rechecked 2026-08-30.'),
('evidence.v0260.eleusinion_procession_start','claim.v0260.eleusinion_procession_start','source.greek.eleusis_acropolis_exhibition2018','Eleusis: The Great Mysteries exhibition description','web lines 23–26','MODERN_SCHOLARSHIP','SUPPORTS',0.91,'Public procession only; secret initiation content excluded.'),
('evidence.v0260.eleusinia_culminates_telesterion','claim.v0260.eleusinia_culminates_telesterion','source.greek.eleusis_acropolis_exhibition2018','Eleusis: The Great Mysteries exhibition description','web line 24','MODERN_SCHOLARSHIP','SUPPORTS',0.94,'Freshly rechecked 2026-08-30.');

INSERT OR IGNORE INTO stories(
    id,canonical_title,title_zh,story_type,primary_civilization_id,summary_zh,summary_en,
    themes_json,evidence_status,access_level,reading_minutes,featured_order,editorial_note,created_at,updated_at
) VALUES
('story.egyptian.opet_procession','Public route of the Opet procession','奥佩特节的公开仪仗路线','TRADITION_OVERVIEW','civ.egyptian','埃及文物主管部门的卢克索神庙档案记录：阿蒙、穆特和孔苏的神像由卡纳克出发，沿仪仗联系抵达卢克索神庙。本页只叙述可公开核对的路线与纪念物层。','The Egyptian antiquities authority records the cult images of Amun, Mut, and Khonsu leaving Karnak and reaching Luxor Temple along a processional connection. This page covers only the public route and monument layer.','["祭典","仪仗路线","卡纳克","卢克索"]','SOURCE_BACKED','PUBLIC_CONTEXT',4,15,'古代祭典、现实遗址与现代官方解释分层；未公开或当前来源未说明的仪式内容不补写。','2026-08-30T03:30:00Z','2026-08-30T03:30:00Z'),
('story.greek.eleusinia_procession','Public route of the Eleusinian procession','厄琉息斯大祭的公开进程','TRADITION_OVERVIEW','civ.greek','雅典卫城博物馆与希腊官方遗产资料共同保存从雅典、圣道到厄琉息斯仪式厅的公开路线层；秘仪内部内容不在此重构。','The Acropolis Museum and Greek official heritage record preserve the public route layer from Athens along the Sacred Way to the Telesterion at Eleusis; the internal mysteries are not reconstructed.','["祭典","圣道","厄琉息斯","文化边界"]','SOURCE_BACKED','PUBLIC_CONTEXT',5,16,'公开进程与保密入会仪式分开；“当前证据未说明”的部分不会以现代想象补齐。','2026-08-30T03:30:00Z','2026-08-30T03:30:00Z');

INSERT OR IGNORE INTO story_versions(
    id,story_id,version_label_zh,version_label_en,source_id,source_location,language_id,
    witness_scope,narrative_scope,evidence_status,access_level,version_order,rights_note,created_at
) VALUES
('storyver.egyptian.opet_mota','story.egyptian.opet_procession','埃及文物主管部门卢克索神庙档案','Egyptian antiquities authority Luxor Temple record','source.egypt.luxor.mota','Official Luxor Temple record, monument description','lang.en','现代埃及官方遗址档案对古代祭典路线与纪念物的公开说明','只概述卡纳克出发、仪仗联系、抵达卢克索和柱廊图像；不声称重建完整祭仪','SOURCE_BACKED','PUBLIC_CONTEXT',1,'版权归埃及主管部门；公开快照只含独立概述、元数据与定位。','2026-08-30T03:30:00Z'),
('storyver.greek.eleusinia_acropolis','story.greek.eleusinia_procession','雅典卫城博物馆展览档案','Acropolis Museum exhibition record','source.greek.eleusis_acropolis_exhibition2018','Exhibition description, route paragraph','lang.en','现代希腊博物馆对古代公开宗教进程及其考古语境的说明','雅典厄琉西尼翁、圣道、厄琉息斯与特勒斯特里翁的公开路线；不进入保密仪式','SOURCE_BACKED','PUBLIC_CONTEXT',1,'博物馆页面受版权保护；本站仅发布独立概述与来源链接。','2026-08-30T03:30:00Z');

INSERT OR IGNORE INTO story_sections(
    id,story_version_id,section_order,heading_zh,heading_en,body_zh,body_en,anchor_claim_id,evidence_note,uncertainty_note
) VALUES
('storysec.opet.1','storyver.egyptian.opet_mota',1,'从卡纳克出发','Departure from Karnak','官方档案将奥佩特节的公开进程起点放在卡纳克诸神庙，并点名阿蒙、穆特与孔苏的神像。','The official record places the public procession’s departure at the Karnak temples and names the cult images of Amun, Mut, and Khonsu.','claim.v070.egypt.opet_associated_karnak','埃及文物主管部门卢克索神庙档案。','当前来源未给出每一尊神像在每一历史时期的完整次序。'),
('storysec.opet.2','storyver.egyptian.opet_mota',2,'仪仗联系','The processional connection','卡纳克与卢克索之间由一条两侧有斯芬克斯像的仪仗道相连；本数据库不凭描述自行绘制精确古路线。','Karnak and Luxor were connected by a sphinx-bordered processional way; the database does not infer an exact ancient route geometry from this description.','claim.v0260.opet_way_sphinxes','官方遗址档案第一个说明段。','当前证据未说明各段统一的建造日期与完整保存状态。'),
('storysec.opet.3','storyver.egyptian.opet_mota',3,'抵达卢克索','Arrival at Luxor','神像被运往卢克索神庙；官方说明把此行解释为拜访当地的阿蒙涅姆奥佩特。','The cult images were transported to Luxor Temple; the official account interprets the visit as directed to Amenemopet there.','claim.v0260.opet_visits_amenemopet','官方卢克索神庙奥佩特段落。','阿蒙涅姆奥佩特本轮只作来源中的名称保存，不与其他阿蒙形态合并。'),
('storysec.opet.4','storyver.egyptian.opet_mota',4,'柱廊保存的图像层','Festival scenes on the colonnade','卢克索大神柱廊的装饰包含奥佩特节场景；这是现实纪念物的图像见证，不等于完整祭典脚本。','The Great Colonnade decoration includes scenes of the Opet Festival; this is a monumental visual witness, not a complete ritual script.','claim.v0260.opet_colonnade_scenes','官方神庙档案的柱廊说明。','完整图像学分段与各场景定位仍待专项研究。'),
('storysec.eleusinia.1','storyver.greek.eleusinia_acropolis',1,'雅典的公开起点','Public beginning in Athens','博物馆档案说宗教进程从雅典开始，并把雅典厄琉西尼翁出土材料纳入路线展览。','The museum record says the religious procession began in Athens and includes material from the Athenian Eleusinion in the route exhibition.','claim.v0260.eleusinion_procession_start','雅典卫城博物馆展览说明。','当前档案不是逐日祭程表。'),
('storysec.eleusinia.2','storyver.greek.eleusinia_acropolis',2,'沿圣道前往厄琉息斯','Along the Sacred Way to Eleusis','公开进程由雅典沿圣道通向厄琉息斯；达夫尼阿佛洛狄忒圣所等地点属于道路考古层，不是虚构的冒险节点。','The public procession moved from Athens along the Sacred Way toward Eleusis; sites such as the Aphrodite sanctuary at Daphne belong to the road’s archaeology, not an invented adventure sequence.','claim.v080.eleusinia_sacredway','卫城博物馆路线说明与既有圣道档案。','每一停驻点与日期尚未在当前来源中完整列出。'),
('storysec.eleusinia.3','storyver.greek.eleusinia_acropolis',3,'进入厄琉息斯遗址','Entering the Eleusinian sanctuary','希腊官方遗产资料说明，圣道在厄琉息斯延续为进程道路，并通向遗址内部。','Greek official heritage information describes the Sacred Way continuing as the Processional Road inside the Eleusinian site.','claim.v080.sacredway_eleusis','希腊官方遗产页的遗址路线说明。','这里只处理可见道路与遗址关系。'),
('storysec.eleusinia.4','storyver.greek.eleusinia_acropolis',4,'在仪式厅结束的公开路线','Public route culminating at the Telesterion','博物馆档案把公开进程的终点置于厄琉息斯圣所的特勒斯特里翁；这不授权重建保密入会仪式。','The museum record places the public procession’s culmination at the Telesterion in the Eleusinian sanctuary; this does not authorize reconstruction of secret initiation rites.','claim.v0260.eleusinia_culminates_telesterion','雅典卫城博物馆展览说明。','秘仪内部内容：当前公开证据未说明，且系统不补写。');

INSERT OR IGNORE INTO story_claim_links(story_version_id,claim_id,link_role) VALUES
('storyver.egyptian.opet_mota','claim.v070.egypt.opet_associated_karnak','NARRATIVE_BASIS'),
('storyver.egyptian.opet_mota','claim.v070.egypt.opet_associated_luxor','NARRATIVE_BASIS'),
('storyver.egyptian.opet_mota','claim.v070.egypt.opet_associated_triad','NARRATIVE_BASIS'),
('storyver.egyptian.opet_mota','claim.v0260.opet_way_sphinxes','NARRATIVE_BASIS'),
('storyver.egyptian.opet_mota','claim.v0260.opet_visits_amenemopet','NARRATIVE_BASIS'),
('storyver.egyptian.opet_mota','claim.v0260.opet_colonnade_scenes','CONTEXT'),
('storyver.greek.eleusinia_acropolis','claim.v0260.eleusinion_procession_start','NARRATIVE_BASIS'),
('storyver.greek.eleusinia_acropolis','claim.v080.eleusinia_sacredway','NARRATIVE_BASIS'),
('storyver.greek.eleusinia_acropolis','claim.v080.sacredway_eleusis','NARRATIVE_BASIS'),
('storyver.greek.eleusinia_acropolis','claim.v0260.eleusinia_culminates_telesterion','NARRATIVE_BASIS'),
('storyver.greek.eleusinia_acropolis','claim.v080.eleusinia_mysteries','EVIDENCE_LIMIT');

INSERT OR IGNORE INTO story_entity_links(story_id,story_version_id,entity_id,role,sort_order,notes) VALUES
('story.egyptian.opet_procession','storyver.egyptian.opet_mota','festival.egyptian.opet','EVENT',1,'Festival dossier.'),
('story.egyptian.opet_procession','storyver.egyptian.opet_mota','group.egyptian.theban_triad','CHARACTER_GROUP',2,'Cult-image group in the official record.'),
('story.egyptian.opet_procession','storyver.egyptian.opet_mota','site.egypt.karnak','PLACE',10,'Public departure setting.'),
('story.egyptian.opet_procession','storyver.egyptian.opet_mota','site.egypt.karnak_luxor_processional_way','PLACE',11,'Real processional connection; no inferred coordinates.'),
('story.egyptian.opet_procession','storyver.egyptian.opet_mota','site.egypt.luxor_temple','PLACE',12,'Public destination and monument witness.'),
('story.greek.eleusinia_procession','storyver.greek.eleusinia_acropolis','festival.greek.great_eleusinia','EVENT',1,'Public festival/procession layer.'),
('story.greek.eleusinia_procession','storyver.greek.eleusinia_acropolis','ritual.greek.eleusinian_mysteries','CONTEXT',2,'Boundary marker; secret contents excluded.'),
('story.greek.eleusinia_procession','storyver.greek.eleusinia_acropolis','site.greece.eleusinion_athens','PLACE',10,'Public Athens setting.'),
('story.greek.eleusinia_procession','storyver.greek.eleusinia_acropolis','site.greece.sacred_way','PLACE',11,'Real route entity.'),
('story.greek.eleusinia_procession','storyver.greek.eleusinia_acropolis','site.greece.sacred_way_aphrodite_daphne','PLACE',12,'Archaeological monument beside the road.'),
('story.greek.eleusinia_procession','storyver.greek.eleusinia_acropolis','site.greece.eleusis','PLACE',13,'Destination sanctuary/site.'),
('story.greek.eleusinia_procession','storyver.greek.eleusinia_acropolis','site.greece.eleusis_telesterion','PLACE',14,'Publicly documented route culmination.');

-- Every readable section becomes a persistent ordered event node. This is a
-- reversible structural layer; it does not turn narrative order into dates.
INSERT OR IGNORE INTO story_event_nodes(
    id,story_version_id,event_order,title_zh,title_en,summary_zh,summary_en,
    anchor_claim_id,event_entity_id,place_entity_id,location_kind,coordinate_policy,
    evidence_status,uncertainty_note,created_at
)
SELECT 'storyevent.' || replace(ss.id,'storysec.',''),ss.story_version_id,ss.section_order,
       ss.heading_zh,ss.heading_en,ss.body_zh,ss.body_en,ss.anchor_claim_id,NULL,NULL,
       'UNSPECIFIED','NO_COORDINATE',sv.evidence_status,ss.uncertainty_note,'2026-08-30T03:30:00Z'
FROM story_sections ss JOIN story_versions sv ON sv.id=ss.story_version_id;

UPDATE story_event_nodes SET place_entity_id='site.egypt.karnak',location_kind='REAL_SITE',coordinate_policy='ENTITY_PROFILE_ONLY'
 WHERE id='storyevent.opet.1';
UPDATE story_event_nodes SET place_entity_id='site.egypt.karnak_luxor_processional_way',location_kind='REAL_SITE',coordinate_policy='NO_COORDINATE'
 WHERE id='storyevent.opet.2';
UPDATE story_event_nodes SET place_entity_id='site.egypt.luxor_temple',location_kind='REAL_SITE',coordinate_policy='ENTITY_PROFILE_ONLY'
 WHERE id IN ('storyevent.opet.3','storyevent.opet.4');
UPDATE story_event_nodes SET place_entity_id='site.greece.eleusinion_athens',location_kind='REAL_SITE',coordinate_policy='NO_COORDINATE'
 WHERE id='storyevent.eleusinia.1';
UPDATE story_event_nodes SET place_entity_id='site.greece.sacred_way',location_kind='REAL_SITE',coordinate_policy='ENTITY_PROFILE_ONLY'
 WHERE id='storyevent.eleusinia.2';
UPDATE story_event_nodes SET place_entity_id='site.greece.eleusis',location_kind='REAL_SITE',coordinate_policy='ENTITY_PROFILE_ONLY'
 WHERE id='storyevent.eleusinia.3';
UPDATE story_event_nodes SET place_entity_id='site.greece.eleusis_telesterion',location_kind='REAL_SITE',coordinate_policy='ENTITY_PROFILE_ONLY'
 WHERE id='storyevent.eleusinia.4';

INSERT OR IGNORE INTO reading_routes(id,title_zh,title_en,route_type,description_zh,description_en,evidence_policy,featured_order,created_at,updated_at) VALUES
('route.creation_accounts','创世与人类起源','Creation and human origins','THEME','比较不同文本与社群如何叙述世界或人类的开始，不拼成单一创世史。','Compare how distinct texts and communities narrate beginnings without combining them into one creation history.','Keep every witness and community scope separate; no universal synthesis.',10,'2026-08-30T03:30:00Z','2026-08-30T03:30:00Z'),
('route.underworld_journeys','冥界之旅','Underworld journeys','THEME','按见证阅读下降、寻找、夜行与黄泉片段；相似主题不等于同一故事。','Read descent, search, nocturnal travel, and Yomi fragments by witness; thematic similarity does not establish identity.','Theme-only comparison; no cross-tradition identity claims.',20,'2026-08-30T03:30:00Z','2026-08-30T03:30:00Z'),
('route.divine_combat','神战与秩序','Divine combat and order','THEME','从希腊、乌加里特、吠陀与巴比伦见证比较神战结构。','Compare divine-combat structures across Greek, Ugaritic, Vedic, and Babylonian witnesses.','Comparable sequence is not shared origin unless separately evidenced.',30,'2026-08-30T03:30:00Z','2026-08-30T03:30:00Z'),
('route.artifact_circulation','神器的制造、夺取与寻回','Making, taking, and recovering artifacts','ARTIFACT','追踪神器在故事中的制造、夺取、使用与寻回，不把同名器物跨传统合并。','Trace the making, taking, use, and recovery of artifacts without merging similarly named objects across traditions.','Artifact identity remains witness-specific.',40,'2026-08-30T03:30:00Z','2026-08-30T03:30:00Z'),
('route.genealogy_conflicts','谱系差异与同名风险','Genealogy variants and homonym risk','CONFLICT','并排阅读互相冲突的出身或亲属见证，并提醒同名人物不能自动合并。','Read conflicting origin and kinship witnesses side by side, with explicit protection against homonym merges.','Conflicts remain unresolved unless evidence supports resolution.',50,'2026-08-30T03:30:00Z','2026-08-30T03:30:00Z'),
('route.sacred_processions','现实遗址中的公开进程','Public processions through real sites','PLACE','沿权威档案可证实的现实遗址顺序阅读奥佩特与厄琉息斯公开进程；不重建受限仪式。','Read the public Opet and Eleusinian processions through authority-backed real-site sequences; restricted rites are not reconstructed.','Only explicit real-site links are shown; missing coordinates remain missing.',60,'2026-08-30T03:30:00Z','2026-08-30T03:30:00Z');

INSERT OR IGNORE INTO reading_route_steps(route_id,step_order,story_id,story_version_id,focus_entity_id,rationale_zh,rationale_en,transition_note) VALUES
('route.creation_accounts',1,'story.norse.ask_embla','storyver.norse.ask_embla_voluspa',NULL,'先看《女巫预言》的神祇组合。','Begin with the divine triad in Voluspa.','Next witness changes the divine triad.'),
('route.creation_accounts',2,'story.norse.ask_embla','storyver.norse.ask_embla_gylf',NULL,'再看《欺骗古鲁菲》的不同组合。','Then read the different Gylfaginning triad.','Same pair of humans, distinct witness.'),
('route.creation_accounts',3,'story.babylonian.marduk_tiamat','storyver.babylonian.enuma_elish',NULL,'转向巴比伦创世战斗纲要。','Move to the Babylonian creation-combat outline.','Partial evidence guide.'),
('route.creation_accounts',4,'story.maori.creation_many','storyver.maori.creation_teara',NULL,'以多部族与权限边界结束。','Close with plurality and permission boundaries among iwi.','No single standard version.'),
('route.underworld_journeys',1,'story.sumerian.inanna_descent','storyver.sumerian.inanna_etcsl',NULL,'苏美尔下降故事的当前可证范围。','Current evidenced scope of the Sumerian descent.','Line-level expansion remains open.'),
('route.underworld_journeys',2,'story.greek.demeter_persephone','storyver.greek.demeter_hymn2','site.greece.eleusis','寻找与厄琉息斯的赞歌版本。','The hymn version of search and Eleusis.','Textual and real-site layers remain distinct.'),
('route.underworld_journeys',3,'story.egyptian.solar_night','storyver.egyptian.solar_met',NULL,'太阳夜行的博物馆与丧葬文本综合层。','Museum and funerary synthesis for the nocturnal solar journey.','Not a unified funerary text.'),
('route.underworld_journeys',4,'story.japanese.eight_thunder_yomi','storyver.japanese.eight_thunder_kojiki',NULL,'以《古事记》黄泉片段结束。','Close with the Kojiki Yomi fragment.','Local names remain separate.'),
('route.divine_combat',1,'story.greek.titanomachy','storyver.greek.titanomachy_theogony',NULL,'赫西俄德的神战段落。','Hesiodic divine-war passage.',NULL),
('route.divine_combat',2,'story.greek.zeus_typhon','storyver.greek.typhon_theogony',NULL,'同一诗作中的提丰战斗。','Typhon combat in the same poem.',NULL),
('route.divine_combat',3,'story.ugaritic.baal_yamm','storyver.ugaritic.baal_yamm_ktu12',NULL,'泥板见证中的巴力与雅姆。','Baal and Yamm in a tablet witness.',NULL),
('route.divine_combat',4,'story.vedic.indra_vritra','storyver.vedic.indra_vritra_rv132',NULL,'《梨俱吠陀》1.32的颂歌序列。','The hymn sequence of Rigveda 1.32.',NULL),
('route.divine_combat',5,'story.babylonian.marduk_tiamat','storyver.babylonian.enuma_elish',NULL,'以仍属纲要层的巴比伦见证结束。','Close with the still-outline Babylonian witness.','Evidence completeness differs across steps.'),
('route.artifact_circulation',1,'story.norse.forging_treasures','storyver.norse.forging_skald',NULL,'从锻造宝物开始。','Begin with the forging of treasures.',NULL),
('route.artifact_circulation',2,'story.norse.hammer_recovery','storyver.norse.hammer_thrymskvida',NULL,'继续到妙尔尼尔被夺与寻回的当前框架。','Continue to the current framework for Mjolnir’s taking and recovery.',NULL),
('route.artifact_circulation',3,'story.akkadian.anzu_tablet','storyver.akkadian.anzu_oracc',NULL,'比较命运泥板的夺取与夺回。','Compare the taking and recovery of the Tablet of Destinies.',NULL),
('route.artifact_circulation',4,'story.ugaritic.baal_yamm','storyver.ugaritic.baal_yamm_ktu12',NULL,'以两件有名武器的顺序使用结束。','Close with the sequential use of two named weapons.','No cross-tradition artifact merger.'),
('route.genealogy_conflicts',1,'story.greek.aphrodite_origins','storyver.greek.aphrodite_theogony',NULL,'先读《神谱》的海中诞生。','First read the Theogony sea-birth account.',NULL),
('route.genealogy_conflicts',2,'story.greek.aphrodite_origins','storyver.greek.aphrodite_iliad',NULL,'再读《伊利亚特》的宙斯—狄俄涅谱系。','Then read the Iliadic Zeus-Dione genealogy.','Conflict is preserved.'),
('route.genealogy_conflicts',3,'story.norse.ask_embla','storyver.norse.ask_embla_voluspa',NULL,'观察同一人物组合的创造者差异。','Observe creator differences for the same human pair.',NULL),
('route.genealogy_conflicts',4,'story.japanese.kamo_arrow','storyver.japanese.kamo_fudoki_fragment',NULL,'以逸文、地方神名与身份边界结束。','Close with fragment transmission, local names, and identity boundaries.','Name similarity is not identity.'),
('route.sacred_processions',1,'story.egyptian.opet_procession','storyver.egyptian.opet_mota','site.egypt.karnak','从卡纳克出发。','Depart from Karnak.','Move along a real processional connection.'),
('route.sacred_processions',2,'story.greek.eleusinia_procession','storyver.greek.eleusinia_acropolis','site.greece.sacred_way','比较雅典至厄琉息斯的公开进程。','Compare the public procession from Athens to Eleusis.','Secret initiation remains outside scope.');

INSERT OR IGNORE INTO explorer_feature_registry(feature_code,title_zh,title_en,feature_group,data_basis,evidence_caveat,status,introduced_in,display_order,updated_at,notes) VALUES
('story_event_timeline','故事事件顺序','Story event timeline','STORY_READING','story_event_nodes anchored to story sections and claims','Sequence is narrative order, not an absolute chronology.','PUBLIC','v0.26.0',250,'2026-08-30T03:30:00Z','Every node keeps witness and uncertainty boundaries.'),
('thematic_reading_routes','主题阅读路线','Thematic reading routes','STORY_READING','reading_routes and reading_route_steps','A route is editorial navigation, not evidence of common origin.','PUBLIC','v0.26.0',260,'2026-08-30T03:30:00Z','Includes creation, underworld, combat, artifact, conflict and real-site routes.'),
('story_place_sequence','故事地点连接','Story place sequence','STORY_READING','explicit story_event_nodes.place_entity_id links','Mythic places are never assigned real coordinates without evidence.','PUBLIC','v0.26.0',270,'2026-08-30T03:30:00Z','Missing coordinates remain explicit.');

UPDATE collection_queue SET status='BASELINE_COMPLETE',attempts=attempts+1,last_error=NULL,
       next_action='Add dated relief-by-relief Opet sequence and period variants; keep ritual reconstruction bounded',
       updated_at='2026-08-30T03:30:00Z'
 WHERE id='queue.v070.egypt.opet_layers';
UPDATE collection_queue SET status='PARTIAL',attempts=attempts+1,last_error=NULL,
       next_action='Add independently verified route segments and coordinates only from official records; preserve public/secret boundary',
       updated_at='2026-08-30T03:30:00Z'
 WHERE id='queue.v080.greek.sacred_way_monuments';

INSERT OR IGNORE INTO queue_status_history(id,queue_id,old_status,new_status,changed_at,reason) VALUES
('qhist.v0260.opet','queue.v070.egypt.opet_layers','SOURCE_FOUND','BASELINE_COMPLETE','2026-08-30T03:30:00Z','Added source-backed public processional narrative, route entity, event sequence and evidence locators.'),
('qhist.v0260.sacredway','queue.v080.greek.sacred_way_monuments','PARTIAL','PARTIAL','2026-08-30T03:30:00Z','Expanded public procession route and Athens/Eleusis event sequence; segment-level archaeology remains open.');

INSERT OR IGNORE INTO collection_queue(id,target_label,normalized_label,proposed_entity_type,civilization_id,discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,discovery_context,priority,status,attempts,last_error,next_action,created_at,updated_at) VALUES
('queue.v0260.egypt.opet_relief_sequence','Opet Festival Great Colonnade relief-by-relief sequence','opet festival great colonnade relief by relief sequence','MUSEUM_OBJECT','civ.egyptian','site.egypt.luxor_temple','claim.v0260.opet_colonnade_scenes','source.egypt.luxor.mota','The official monument page confirms the scene cycle but not a panel-by-panel edition.',97,'DISCOVERED',0,NULL,'Locate authorized high-resolution plates or epigraphic edition; map panels without copying restricted images.','2026-08-30T03:30:00Z','2026-08-30T03:30:00Z'),
('queue.v0260.egypt.amenemopet_identity','Amenemopet at Luxor Temple identity and epithet witnesses','amenemopet at luxor temple identity and epithet witnesses','DEITY','civ.egyptian','site.egypt.luxor_temple','claim.v0260.opet_visits_amenemopet','source.egypt.luxor.mota','The official page names a local divine recipient but does not establish identity relations.',96,'DISCOVERED',0,NULL,'Register primary inscriptions and dated name forms before any identification with Amun or Amun-Ra.','2026-08-30T03:30:00Z','2026-08-30T03:30:00Z'),
('queue.v0260.greek.eleusinion_athens','Athens Eleusinion archaeology and procession dossier','athens eleusinion archaeology and procession dossier','ARCHAEOLOGICAL_SITE','civ.greek','site.greece.eleusinion_athens','claim.v0260.eleusinion_procession_start','source.greek.eleusis_acropolis_exhibition2018','Museum exhibition record identifies the sanctuary and route context but not a full excavation dossier.',96,'DISCOVERED',0,NULL,'Add official excavation reports, securely verified coordinates and dated monument phases.','2026-08-30T03:30:00Z','2026-08-30T03:30:00Z');

INSERT OR IGNORE INTO queue_discoveries(id,queue_id,discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,discovery_context,discovered_at) VALUES
('qdisc.v0260.opet_reliefs','queue.v0260.egypt.opet_relief_sequence','site.egypt.luxor_temple','claim.v0260.opet_colonnade_scenes','source.egypt.luxor.mota','Official site confirms scenes; detailed sequence remains a clear gap.','2026-08-30T03:30:00Z'),
('qdisc.v0260.amenemopet','queue.v0260.egypt.amenemopet_identity','site.egypt.luxor_temple','claim.v0260.opet_visits_amenemopet','source.egypt.luxor.mota','Literal divine name requires identity-safe primary witness work.','2026-08-30T03:30:00Z'),
('qdisc.v0260.eleusinion','queue.v0260.greek.eleusinion_athens','site.greece.eleusinion_athens','claim.v0260.eleusinion_procession_start','source.greek.eleusis_acropolis_exhibition2018','Museum route context exposes an archaeology dossier gap.','2026-08-30T03:30:00Z');

INSERT OR IGNORE INTO research_sessions(id,started_at,ended_at,scope,strategy,status,agent_or_process,notes) VALUES
('session.20260830.v0260','2026-08-30T03:10:00Z','2026-08-30T03:30:00Z','v0.26 story maps, ordered event nodes, reading routes and public processions','Selected high-priority Opet and Sacred Way queue targets; rechecked Egyptian ministry, Acropolis Museum and Greek official heritage records; preserved ritual and coordinate limits.','COMPLETED','Codex','Incremental append-only expansion from v0.25.0.');
INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result) VALUES
('session.20260830.v0260','QUEUE','queue.v070.egypt.opet_layers','EXPAND','Public route baseline and new story added.'),
('session.20260830.v0260','QUEUE','queue.v080.greek.sacred_way_monuments','EXPAND','Public processional sequence expanded; archaeology remains partial.'),
('session.20260830.v0260','STORY','story.egyptian.opet_procession','CREATE','Source-backed public ritual narrative.'),
('session.20260830.v0260','STORY','story.greek.eleusinia_procession','CREATE','Public route narrative with secret-rite boundary.'),
('session.20260830.v0260','SCHEMA','story_event_nodes','CREATE','Ordered narrative nodes with explicit place and coordinate policies.'),
('session.20260830.v0260','SCHEMA','reading_routes','CREATE','Six editorial reading routes with witness-specific steps.');

INSERT OR IGNORE INTO schema_migrations(version,name,applied_at) VALUES
(35,'20260830_v0260_story_maps_reading_routes','2026-08-30T03:30:00Z');

INSERT OR IGNORE INTO dataset_releases(id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes) VALUES
('release.v0.26.0',35,'0.26.0',NULL,'2026-08-30T03:30:00Z',NULL,'Story maps and reading routes checkpoint: two public-procession stories, ordered story event nodes, explicit real/mythic location policy, six witness-safe thematic routes and mobile reading UI.');

INSERT INTO project_metadata(key,value,updated_at) VALUES
('project_version','0.26.0-story-maps-reading-routes','2026-08-30T03:30:00Z'),
('project_status','Sustainable expansion baseline; never ALL COMPLETE','2026-08-30T03:30:00Z'),
('story_route_policy','Reading routes are editorial navigation, not common-origin claims; event order is not absolute chronology','2026-08-30T03:30:00Z')
ON CONFLICT(key) DO UPDATE SET value=excluded.value,updated_at=excluded.updated_at;

COMMIT;
