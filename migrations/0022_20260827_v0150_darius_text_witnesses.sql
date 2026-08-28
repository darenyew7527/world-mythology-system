BEGIN IMMEDIATE;

-- v0.15.0 decomposes the Egyptian and cuneiform inscription programmes into
-- editorially scoped witnesses.  Text numbers are modern scholarly locators,
-- not claims that the monument carried ancient document titles.

INSERT OR IGNORE INTO languages(id,canonical_name,name_zh,iso_639_3,script_name,historical_stage,notes) VALUES
('lang.fra','French','法语','fra','Latin','Modern','Added for French archaeological and epigraphic scholarship; not an ancient inscription language.');

UPDATE sources
SET catalogue_number='CRAI 117-2 (1973), pp. 256-259; DOI 10.3406/crai.1973.12879',
    doi='10.3406/crai.1973.12879',
    notes='Persée authority record and article text for Yoyotte''s communication. The longer 1972 Journal asiatique dossier (pp. 253-266) is registered separately; the two pagination systems must not be conflated.'
WHERE id='source.egypt.darius_hieroglyphs.yoyotte1973';

INSERT OR IGNORE INTO sources(
 id,title,source_type,evidence_tier,institution,author_or_editor,language_id,
 publication_date,accessed_date,url,catalogue_number,rights_status,source_perspective,
 access_or_reuse_restrictions,community_permission_required,translation_status,
 verification_status,notes
) VALUES
('source.biblio.tuebingen.darius_dossier1972','Une statue de Darius découverte à Suse — bibliographic record','UNIVERSITY_CATALOGUE',3,'Tübingen University Library, Keilschriftbibliographie','Monique Kervran; David Stronach; François Vallat; Jean Yoyotte','lang.fra','1972','2026-08-27','https://vergil.uni-tuebingen.de/keibi/Record/KEI00077397','KeiBi 38:559; Journal asiatique 260, pp. 235-266','Catalogue metadata rights apply; independent summaries and locators only','University bibliographic partition of the original excavation, object, cuneiform and hieroglyphic reports','Do not treat catalogue summary as a substitute for the underlying article text',0,'French article; English/German catalogue interface','URL_SYNTAX_VALID','Records the dossier divisions: Kervran 235-239, Stronach 241-246, Vallat 247-251 and Yoyotte 253-266.'),
('source.persia.darius_subjects.roaf1974','The Subject Peoples on the Base of the Statue of Darius','SCHOLARLY_ARTICLE',3,'Tübingen University Library bibliographic record','Michael Roaf','lang.en','1974','2026-08-27','https://vergil.uni-tuebingen.de/keibi/Record/KEI00078044','KeiBi 38:1206; DAFI 4, pp. 73-160','Article copyright applies; bibliography and independent summaries only','Specialist study of the labelled figures on the statue base','No page images or extended text are packaged',0,'English scholarly article','URL_SYNTAX_VALID','Authority-level bibliographic anchor for later cartouche-by-cartouche collation; this release does not infer modern ethnic identities.'),
('source.iran.susa_darius_subjects.achemenet','Susa: The Statue of Darius — right side of the base','SCHOLARLY_PROJECT',3,'Achemenet / Musée du Louvre research network','Pierre Briant project','lang.en',NULL,'2026-08-27','https://www.achemenet.com/en/visit/?/susa/the-statue-of-darius/9=','Darius statue, base right side','Project website rights apply; metadata, locators and independent summaries only','Scholarly object presentation of twelve labelled base figures','Do not package page images or extended text',0,'English project presentation','URL_SYNTAX_VALID','Identifies twelve figures on one side and describes their ancient geographic framing; modern ethnicity is not inferred.');

INSERT OR IGNORE INTO entities(
 id,canonical_name,name_zh,original_name,transliteration,primary_type,
 primary_civilization_id,primary_region_id,historical_period,description,
 research_status,evidence_status,record_version,metadata_json,created_at,updated_at
) VALUES
('text.egypt.darius_susa.hieroglyph_text_1','Darius Statue Hieroglyphic Text 1','大流士雕像象形文字文本1',NULL,NULL,'INSCRIPTION','civ.egyptian','region.west_asia','Reign of Darius I','学术版编号的雕像象形文字见证；“文本1”是现代定位符，不是古代题名。 / Editorially numbered hieroglyphic witness; Text 1 is a modern locator, not an ancient title.','PARTIAL','SOURCE_BACKED',1,'{"witness_role":"EDITORIAL_SEGMENT","ancient_title":null,"carrier":"museum.iran.darius_susa_statue"}','2026-08-27T08:00:00Z','2026-08-27T08:00:00Z'),
('text.egypt.darius_susa.hieroglyph_text_2','Darius Statue Hieroglyphic Text 2','大流士雕像象形文字文本2',NULL,NULL,'INSCRIPTION','civ.egyptian','region.west_asia','Reign of Darius I','学术版编号的第二组象形文字见证；与整套铭文及其他编号分开。 / Second editorially numbered hieroglyphic witness, distinct from the programme and other segments.','PARTIAL','SOURCE_BACKED',1,'{"witness_role":"EDITORIAL_SEGMENT","ancient_title":null,"carrier":"museum.iran.darius_susa_statue"}','2026-08-27T08:00:00Z','2026-08-27T08:00:00Z'),
('text.egypt.darius_susa.hieroglyph_text_3','Darius Statue Hieroglyphic Text 3','大流士雕像象形文字文本3',NULL,NULL,'INSCRIPTION','civ.egyptian','region.west_asia','Reign of Darius I','学术版编号的第三组象形文字见证。 / Third editorially numbered hieroglyphic witness.','PARTIAL','SOURCE_BACKED',1,'{"witness_role":"EDITORIAL_SEGMENT","ancient_title":null,"carrier":"museum.iran.darius_susa_statue"}','2026-08-27T08:00:00Z','2026-08-27T08:00:00Z'),
('text.egypt.darius_susa.hieroglyph_text_4','Darius Statue Hieroglyphic Text 4','大流士雕像象形文字文本4',NULL,NULL,'INSCRIPTION','civ.egyptian','region.west_asia','Reign of Darius I','学术版编号的第四组象形文字见证。 / Fourth editorially numbered hieroglyphic witness.','PARTIAL','SOURCE_BACKED',1,'{"witness_role":"EDITORIAL_SEGMENT","ancient_title":null,"carrier":"museum.iran.darius_susa_statue"}','2026-08-27T08:00:00Z','2026-08-27T08:00:00Z'),
('text.egypt.darius_susa.subject_list.left_twelve','Darius Statue Subject List — Left-side Twelve','大流士雕像属民名单左侧十二组',NULL,NULL,'INSCRIPTION','civ.egyptian','region.west_asia','Reign of Darius I','雕像底座一侧十二组跪姿人物与名框的集合见证；不自动映射现代民族。 / One side-set of twelve kneeling figures and labels; no automatic modern ethnic mapping.','PARTIAL','SOURCE_BACKED',1,'{"witness_role":"BASE_SIDE_SET","count":12,"mapping_guard":"ANCIENT_LABELS_FIRST"}','2026-08-27T08:00:00Z','2026-08-27T08:00:00Z'),
('text.egypt.darius_susa.subject_list.right_twelve','Darius Statue Subject List — Right-side Twelve','大流士雕像属民名单右侧十二组',NULL,NULL,'INSCRIPTION','civ.egyptian','region.west_asia','Reign of Darius I','雕像底座另一侧十二组跪姿人物与名框的集合见证；方位词按观察与出版约定保存。 / The other set of twelve figures and labels; side terminology follows the publication/viewing convention.','PARTIAL','SOURCE_BACKED',1,'{"witness_role":"BASE_SIDE_SET","count":12,"mapping_guard":"ANCIENT_LABELS_FIRST"}','2026-08-27T08:00:00Z','2026-08-27T08:00:00Z');

INSERT OR IGNORE INTO entity_classifications(entity_id,type_code,is_primary,notes)
SELECT id,primary_type,1,'v0.15.0 Darius inscription witness decomposition'
FROM entities WHERE created_at='2026-08-27T08:00:00Z';

INSERT OR IGNORE INTO entity_civilizations(entity_id,civilization_id,association_role,certainty,notes)
SELECT id,'civ.egyptian','TEXTUAL_WITNESS','SUPPORTED','Egyptian-language inscription on an Achaemenid royal object'
FROM entities WHERE created_at='2026-08-27T08:00:00Z';

INSERT OR IGNORE INTO names(id,entity_id,name_text,normalized_text,language_id,script_name,name_type,is_preferred,source_id,notes) VALUES
('name.v0150.hiero1.en','text.egypt.darius_susa.hieroglyph_text_1','Darius Statue Hieroglyphic Text 1','darius statue hieroglyphic text 1','lang.en','Latin','DESCRIPTIVE',1,'source.egypt.darius_hieroglyphs.yoyotte1973','Modern editorial locator.'),
('name.v0150.hiero2.en','text.egypt.darius_susa.hieroglyph_text_2','Darius Statue Hieroglyphic Text 2','darius statue hieroglyphic text 2','lang.en','Latin','DESCRIPTIVE',1,'source.egypt.darius_hieroglyphs.yoyotte1973','Modern editorial locator.'),
('name.v0150.hiero3.en','text.egypt.darius_susa.hieroglyph_text_3','Darius Statue Hieroglyphic Text 3','darius statue hieroglyphic text 3','lang.en','Latin','DESCRIPTIVE',1,'source.egypt.darius_hieroglyphs.yoyotte1973','Modern editorial locator.'),
('name.v0150.hiero4.en','text.egypt.darius_susa.hieroglyph_text_4','Darius Statue Hieroglyphic Text 4','darius statue hieroglyphic text 4','lang.en','Latin','DESCRIPTIVE',1,'source.egypt.darius_hieroglyphs.yoyotte1973','Modern editorial locator.'),
('name.v0150.subjectleft.en','text.egypt.darius_susa.subject_list.left_twelve','Darius Statue Subject List — Left-side Twelve','darius statue subject list left side twelve','lang.en','Latin','DESCRIPTIVE',1,'source.persia.darius_subjects.roaf1974','Set-level record pending cartouche-level collation.'),
('name.v0150.subjectright.en','text.egypt.darius_susa.subject_list.right_twelve','Darius Statue Subject List — Right-side Twelve','darius statue subject list right side twelve','lang.en','Latin','DESCRIPTIVE',1,'source.iran.susa_darius_subjects.achemenet','Set-level record pending cartouche-level collation.');

INSERT OR IGNORE INTO text_profiles(entity_id,text_type,original_language_id,attributed_author,compiler,composition_period,earliest_extant_witness,chapter_structure,repository,shelfmark,copyright_status,summary)
SELECT id,'MONUMENTAL_INSCRIPTION','lang.egy',NULL,'Modern segmentation after Yoyotte','Reign of Darius I',
 'The stone carrier itself','One numbered segment within a five-text scholarly programme','National Museum of Iran','Darius statue; exact inventory audit remains open','Ancient inscription is public domain; modern editions retain rights',description
FROM entities WHERE id LIKE 'text.egypt.darius_susa.hieroglyph_text_%';

INSERT OR IGNORE INTO text_profiles(entity_id,text_type,original_language_id,attributed_author,compiler,composition_period,earliest_extant_witness,chapter_structure,repository,shelfmark,copyright_status,summary)
SELECT id,'MONUMENTAL_LABEL_SET','lang.egy',NULL,'Modern grouping after Roaf and object documentation','Reign of Darius I',
 'The stone carrier itself','Twelve figure-label units on one base side','National Museum of Iran','Darius statue base; exact inventory audit remains open','Ancient inscription is public domain; modern editions retain rights',description
FROM entities WHERE id LIKE 'text.egypt.darius_susa.subject_list.%';

INSERT OR IGNORE INTO claims(
 id,subject_id,predicate,object_entity_id,object_literal,object_datatype,statement,
 variant_group,claim_status,confidence,confidence_level,review_status,assertion_scope,
 knowledge_layer,tradition_scope,temporal_scope,research_notes,created_at
) VALUES
('claim.v0150.hiero1_part','text.egypt.darius_susa.hieroglyph_text_1','PART_OF','text.egypt.darius_susa_hieroglyphic_program',NULL,NULL,'Hieroglyphic Text 1 is an editorial segment of the statue inscription programme.','darius.hieroglyphs.editorial_segments','SUPPORTED',0.97,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','TEXTUAL_WITNESS','Darius statue edition','modern edition','Number is a modern locator.','2026-08-27T08:00:00Z'),
('claim.v0150.hiero2_part','text.egypt.darius_susa.hieroglyph_text_2','PART_OF','text.egypt.darius_susa_hieroglyphic_program',NULL,NULL,'Hieroglyphic Text 2 is an editorial segment of the statue inscription programme.','darius.hieroglyphs.editorial_segments','SUPPORTED',0.97,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','TEXTUAL_WITNESS','Darius statue edition','modern edition','Number is a modern locator.','2026-08-27T08:00:00Z'),
('claim.v0150.hiero3_part','text.egypt.darius_susa.hieroglyph_text_3','PART_OF','text.egypt.darius_susa_hieroglyphic_program',NULL,NULL,'Hieroglyphic Text 3 is an editorial segment of the statue inscription programme.','darius.hieroglyphs.editorial_segments','SUPPORTED',0.97,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','TEXTUAL_WITNESS','Darius statue edition','modern edition','Number is a modern locator.','2026-08-27T08:00:00Z'),
('claim.v0150.hiero4_part','text.egypt.darius_susa.hieroglyph_text_4','PART_OF','text.egypt.darius_susa_hieroglyphic_program',NULL,NULL,'Hieroglyphic Text 4 is an editorial segment of the statue inscription programme.','darius.hieroglyphs.editorial_segments','SUPPORTED',0.97,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','TEXTUAL_WITNESS','Darius statue edition','modern edition','Number is a modern locator.','2026-08-27T08:00:00Z'),
('claim.v0150.hiero1_carrier','text.egypt.darius_susa.hieroglyph_text_1','DEPICTED_ON','museum.iran.darius_susa_statue',NULL,NULL,'The stone statue is the physical carrier of Hieroglyphic Text 1.','darius.hieroglyphs.carrier','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Darius statue','reign of Darius I',NULL,'2026-08-27T08:00:00Z'),
('claim.v0150.hiero2_carrier','text.egypt.darius_susa.hieroglyph_text_2','DEPICTED_ON','museum.iran.darius_susa_statue',NULL,NULL,'The stone statue is the physical carrier of Hieroglyphic Text 2.','darius.hieroglyphs.carrier','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Darius statue','reign of Darius I',NULL,'2026-08-27T08:00:00Z'),
('claim.v0150.hiero3_carrier','text.egypt.darius_susa.hieroglyph_text_3','DEPICTED_ON','museum.iran.darius_susa_statue',NULL,NULL,'The stone statue is the physical carrier of Hieroglyphic Text 3.','darius.hieroglyphs.carrier','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Darius statue','reign of Darius I',NULL,'2026-08-27T08:00:00Z'),
('claim.v0150.hiero4_carrier','text.egypt.darius_susa.hieroglyph_text_4','DEPICTED_ON','museum.iran.darius_susa_statue',NULL,NULL,'The stone statue is the physical carrier of Hieroglyphic Text 4.','darius.hieroglyphs.carrier','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Darius statue','reign of Darius I',NULL,'2026-08-27T08:00:00Z'),
('claim.v0150.subject_left_part','text.egypt.darius_susa.subject_list.left_twelve','PART_OF','text.egypt.darius_susa_hieroglyphic_province_list',NULL,NULL,'The left-side set of twelve figure labels is part of the twenty-four-unit subject-peoples list.','darius.subject_list.side_sets','SUPPORTED',0.96,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','TEXTUAL_WITNESS','Darius statue base','modern grouping','Side follows the chosen viewing convention.','2026-08-27T08:00:00Z'),
('claim.v0150.subject_right_part','text.egypt.darius_susa.subject_list.right_twelve','PART_OF','text.egypt.darius_susa_hieroglyphic_province_list',NULL,NULL,'The right-side set of twelve figure labels is part of the twenty-four-unit subject-peoples list.','darius.subject_list.side_sets','SUPPORTED',0.96,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','TEXTUAL_WITNESS','Darius statue base','modern grouping','Side follows the chosen viewing convention.','2026-08-27T08:00:00Z'),
('claim.v0150.subject_left_count','text.egypt.darius_susa.subject_list.left_twelve','ASSOCIATED_WITH',NULL,'twelve labelled kneeling figures','text','One side-set contains twelve labelled kneeling figures.','darius.subject_list.count','SUPPORTED',0.97,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Darius statue base','reign of Darius I',NULL,'2026-08-27T08:00:00Z'),
('claim.v0150.subject_right_count','text.egypt.darius_susa.subject_list.right_twelve','ASSOCIATED_WITH',NULL,'twelve labelled kneeling figures','text','The opposite side-set contains twelve labelled kneeling figures.','darius.subject_list.count','SUPPORTED',0.97,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Darius statue base','reign of Darius I',NULL,'2026-08-27T08:00:00Z'),
('claim.v0150.dsab_parallel_witnesses','text.persia.dsab','HAS_PART',NULL,'three parallel language witnesses: Old Persian, Elamite and Akkadian','text','DSab is preserved as three parallel language witnesses rather than one undifferentiated text string.','darius.dsab.witness_model','SUPPORTED',0.99,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','TEXTUAL_WITNESS','DSab','modern edition','Existing language entities remain distinct.','2026-08-27T08:00:00Z'),
('claim.v0150.dsab_line_gap','text.persia.dsab','ASSOCIATED_WITH',NULL,'exact line-by-line correspondences and edition variants remain queued','text','The public authority records establish the three versions and edition ranges, but this release does not invent line-by-line correspondences not exposed in the checked records.','darius.dsab.line_collation','INTERPRETIVE',1.0,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','DSab editions','2026-08-27','Explicit evidence gap.','2026-08-27T08:00:00Z'),
('claim.v0150.subject_mapping_guard','concept.persia.darius_statue_subject_peoples','ASSOCIATED_WITH',NULL,'cartouche-level ancient labels precede any proposed modern geographic identification','text','Cartouche-level expansion must preserve ancient labels and edition variants before proposing modern geographic correspondences.','darius.subjects.mapping_method','SUPPORTED',1.0,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Project method','current','Prevents modern nation or ethnicity projection.','2026-08-27T08:00:00Z');

INSERT OR IGNORE INTO evidence(id,claim_id,source_id,source_location,catalogue_number,evidence_type,direction,strength,research_notes) VALUES
('evidence.v0150.hiero1_part','claim.v0150.hiero1_part','source.egypt.darius_hieroglyphs.yoyotte1973','Article and edition discussion; CRAI 117-2, pp. 256-259','DOI 10.3406/crai.1973.12879','MODERN_SCHOLARSHIP','SUPPORTS',0.97,'Modern numbering retained as a locator.'),
('evidence.v0150.hiero2_part','claim.v0150.hiero2_part','source.egypt.darius_hieroglyphs.yoyotte1973','Article and edition discussion; CRAI 117-2, pp. 256-259','DOI 10.3406/crai.1973.12879','MODERN_SCHOLARSHIP','SUPPORTS',0.97,'Modern numbering retained as a locator.'),
('evidence.v0150.hiero3_part','claim.v0150.hiero3_part','source.egypt.darius_hieroglyphs.yoyotte1973','Article and edition discussion; CRAI 117-2, pp. 256-259','DOI 10.3406/crai.1973.12879','MODERN_SCHOLARSHIP','SUPPORTS',0.97,'Modern numbering retained as a locator.'),
('evidence.v0150.hiero4_part','claim.v0150.hiero4_part','source.egypt.darius_hieroglyphs.yoyotte1973','Article and edition discussion; CRAI 117-2, pp. 256-259','DOI 10.3406/crai.1973.12879','MODERN_SCHOLARSHIP','SUPPORTS',0.97,'Modern numbering retained as a locator.'),
('evidence.v0150.hiero1_carrier','claim.v0150.hiero1_carrier','source.iran.susa_darius.achemenet','Central statue view: cuneiform and hieroglyphic inscriptions','Darius statue central part','INSCRIPTION','SUPPORTS',0.99,NULL),
('evidence.v0150.hiero2_carrier','claim.v0150.hiero2_carrier','source.iran.susa_darius.achemenet','Central statue view: cuneiform and hieroglyphic inscriptions','Darius statue central part','INSCRIPTION','SUPPORTS',0.99,NULL),
('evidence.v0150.hiero3_carrier','claim.v0150.hiero3_carrier','source.iran.susa_darius.achemenet','Central statue view: cuneiform and hieroglyphic inscriptions','Darius statue central part','INSCRIPTION','SUPPORTS',0.99,NULL),
('evidence.v0150.hiero4_carrier','claim.v0150.hiero4_carrier','source.iran.susa_darius.achemenet','Central statue view: cuneiform and hieroglyphic inscriptions','Darius statue central part','INSCRIPTION','SUPPORTS',0.99,NULL),
('evidence.v0150.subject_left_part','claim.v0150.subject_left_part','source.persia.darius_subjects.roaf1974','DAFI 4, pp. 73-160; set structure only','KeiBi 38:1206','MODERN_SCHOLARSHIP','SUPPORTS',0.96,'Cartouche-level readings remain queued.'),
('evidence.v0150.subject_right_part','claim.v0150.subject_right_part','source.persia.darius_subjects.roaf1974','DAFI 4, pp. 73-160; set structure only','KeiBi 38:1206','MODERN_SCHOLARSHIP','SUPPORTS',0.96,'Cartouche-level readings remain queued.'),
('evidence.v0150.subject_left_count','claim.v0150.subject_left_count','source.iran.susa_darius_subjects.achemenet','Base side presentation; twelve figures','Darius statue base side','ARCHAEOLOGICAL','SUPPORTS',0.97,'Mirrored side terminology is normalized in project notes.'),
('evidence.v0150.subject_right_count','claim.v0150.subject_right_count','source.iran.susa_darius_subjects.achemenet','Base side presentation; twelve figures','Darius statue base side','ARCHAEOLOGICAL','SUPPORTS',0.97,'Mirrored side terminology is normalized in project notes.'),
('evidence.v0150.dsab_parallel_witnesses','claim.v0150.dsab_parallel_witnesses','source.biblio.tuebingen.darius_dossier1972','Vallat section pp. 247-251: translations of three versions','KeiBi 38:559','MODERN_SCHOLARSHIP','SUPPORTS',0.99,'Bibliographic record confirms version count and report partition.'),
('evidence.v0150.dsab_line_gap','claim.v0150.dsab_line_gap','source.persia.dsab.vallat1974','JSTOR metadata and edition range; full line collation not exposed in checked public record','JSTOR 23282203','MODERN_SCHOLARSHIP','SUPPORTS',1.0,'Transparent gap, not a claim about the unpublished content.'),
('evidence.v0150.subject_mapping_guard','claim.v0150.subject_mapping_guard','source.persia.darius_subjects.roaf1974','Specialist study scope and ancient subject-list framing','KeiBi 38:1206','MODERN_SCHOLARSHIP','CONTEXT',1.0,'Project inference: ancient labels first; no modern ethnic equivalence is asserted.');

UPDATE collection_queue SET status='PARTIAL',attempts=attempts+1,last_error=NULL,
 next_action='Add verified transcription, translation and exact carrier position for Texts 1-4 from the full Yoyotte edition; keep editorial numbering visible',
 updated_at='2026-08-27T08:00:00Z' WHERE id='queue.v0130.egypt.darius_hieroglyphic_texts_1_4';
UPDATE collection_queue SET status='PARTIAL',attempts=attempts+1,last_error=NULL,
 next_action='Collate Old Persian, Elamite and Akkadian line correspondences against a fully accessible Vallat or later critical edition',
 updated_at='2026-08-27T08:00:00Z' WHERE id='queue.v0130.persia.dsab_line_editions';
UPDATE collection_queue SET status='PARTIAL',attempts=attempts+1,last_error=NULL,
 next_action='Create all twenty-four cartouche-level witnesses from Roaf or a museum-authorized edition; preserve ancient forms before geographic proposals',
 updated_at='2026-08-27T08:00:00Z' WHERE id='queue.v0130.egypt.darius_subject_cartouches';

INSERT OR IGNORE INTO queue_status_history(id,queue_id,old_status,new_status,changed_at,reason) VALUES
('queuehist.v0150.hieroglyph_texts','queue.v0130.egypt.darius_hieroglyphic_texts_1_4','SOURCE_FOUND','PARTIAL','2026-08-27T08:00:00Z','Created four editorial text witnesses and carrier links without inventing transcriptions.'),
('queuehist.v0150.dsab_lines','queue.v0130.persia.dsab_line_editions','SOURCE_FOUND','PARTIAL','2026-08-27T08:00:00Z','Confirmed three-version edition structure and retained exact line collation as an explicit gap.'),
('queuehist.v0150.subject_cartouches','queue.v0130.egypt.darius_subject_cartouches','DISCOVERED','PARTIAL','2026-08-27T08:00:00Z','Created two twelve-unit side sets and a non-projection rule; individual labels remain queued.');

INSERT OR IGNORE INTO research_sessions(id,started_at,ended_at,scope,strategy,status,agent_or_process,notes) VALUES
('research.20260827.v0150_darius_text_witnesses','2026-08-27T07:05:00Z','2026-08-27T08:00:00Z','Darius statue hieroglyphic editorial segments, DSab three-version structure and subject-list side sets','Use Persée article text, Tübingen scholarly bibliography, Achemenet object presentation and the Roaf bibliographic record; record locators and gaps without reconstructing unavailable readings','CHECKPOINT_COMPLETE','Codex persistent research pipeline','Expandable staged baseline only. Exact transcriptions, line correspondences and all twenty-four cartouche readings remain permanent-queue work.');

INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result)
SELECT 'research.20260827.v0150_darius_text_witnesses','SOURCE',id,'REGISTER','AUTHORITY_AND_RIGHTS_RETAINED' FROM sources WHERE id LIKE 'source.%darius%' AND accessed_date='2026-08-27';
INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result)
SELECT 'research.20260827.v0150_darius_text_witnesses','CLAIM',id,'REGISTER','SOURCE_LOCATED' FROM claims WHERE id LIKE 'claim.v0150.%';

UPDATE project_metadata SET value='0.15.0-darius-text-witnesses-20260827',updated_at='2026-08-27T08:00:00Z' WHERE key='data_version';
UPDATE project_metadata SET value='22',updated_at='2026-08-27T08:00:00Z' WHERE key='schema_version';
UPDATE project_metadata SET value='2026-08-27T08:00:00Z',updated_at='2026-08-27T08:00:00Z' WHERE key='generated_at';
INSERT OR IGNORE INTO dataset_releases(id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes) VALUES
('release.0.15.0',22,'0.15.0-darius-text-witnesses-20260827',NULL,'2026-08-27T08:00:00Z',NULL,'Darius inscription witness checkpoint: four numbered hieroglyphic editorial segments, two twelve-unit subject-list side sets, corrected Yoyotte bibliography, DSab three-language witness structure and explicit line-collation limits.');
INSERT INTO schema_migrations(version,name,applied_at) VALUES
(22,'20260827_v0150_darius_text_witnesses','2026-08-27T08:00:00Z');

COMMIT;
