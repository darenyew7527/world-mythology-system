BEGIN IMMEDIATE;

-- v0.11.0 expands the queued Egyptian composite-deity network through four
-- object-level Met witnesses. Components, object typology, contents and
-- curatorial interpretation remain separately queryable.

INSERT OR IGNORE INTO sources(
 id,title,source_type,evidence_tier,institution,language_id,publication_date,
 accessed_date,url,catalogue_number,rights_status,source_perspective,
 access_or_reuse_restrictions,community_permission_required,translation_status,
 verification_status,notes
) VALUES
('source.egypt.pso.met.28_3_48','Ptah-Sokar-Osiris Figure of Pakherenkhonsu','MUSEUM_OBJECT',3,'The Metropolitan Museum of Art','lang.en','ca. 721-664 BCE','2026-08-24','https://www.metmuseum.org/art/collection/search/550795','28.3.48','Object data and public-domain media follow The Met Open Access terms','Official museum object catalogue','Metadata, locator and independent summary; no image packaged',0,'English museum catalogue','URL_SYNTAX_VALID','Dynasty 25 solid wooden figure from Thebes, el-Khokha, Tomb MMA 832; catalogue identifies the three divine components and rebirth symbolism.'),
('source.egypt.pso.met.21_9_1abc','Ptah-Sokar-Osiris Figure of the Temple Musician Ihyt','MUSEUM_OBJECT',3,'The Metropolitan Museum of Art','lang.en','332-30 BCE','2026-08-24','https://www.metmuseum.org/art/collection/search/553823','21.9.1a-c','Object data and public-domain media follow The Met Open Access terms','Official museum object catalogue','Metadata, locator and independent summary; no image packaged',0,'English museum catalogue','URL_SYNTAX_VALID','Ptolemaic hollow mummiform figure; catalogue records offering texts and contents including wheat, sand and linen bundles with mud.'),
('source.egypt.pso.met.21_9_1d','Linen and mud from interior of Ptah-Sokar-Osiris figure','MUSEUM_OBJECT',3,'The Metropolitan Museum of Art','lang.en','305-30 BCE','2026-08-24','https://www.metmuseum.org/art/collection/search/577767','21.9.1d','Object data and public-domain media follow The Met Open Access terms','Official museum object catalogue','Metadata, locator and independent summary; no image packaged',0,'English museum catalogue','URL_SYNTAX_VALID','Separately catalogued linen-and-mud contents from 21.9.1a-c; X-rayed in 2016; wheat and sand were also found in the cavity.'),
('source.egypt.pso.met.34_9','Ptah-Sokar-Osiris Figure inscribed for Pestjauwymin','MUSEUM_OBJECT',3,'The Metropolitan Museum of Art','lang.en','664-332 BCE','2026-08-24','https://www.metmuseum.org/art/collection/search/552635','34.9','Object data and public-domain media follow The Met Open Access terms','Official museum object catalogue','Metadata, locator and independent summary; no image packaged',0,'English museum catalogue','URL_SYNTAX_VALID','Late Period funerary figure with shuty crown, prayer inscription and canopic deities; missing base may once have held funerary material.' );

INSERT OR IGNORE INTO entities(
 id,canonical_name,name_zh,original_name,transliteration,primary_type,
 primary_civilization_id,primary_region_id,historical_period,description,
 research_status,evidence_status,record_version,metadata_json,created_at,updated_at
) VALUES
('deity.egyptian.sokar','Sokar','索卡尔','skr','Sokar','DEITY','civ.egyptian','region.northeast_africa','Pharaonic Egypt; current baseline emphasizes Third Intermediate and Late/Ptolemaic witnesses','与孟斐斯墓地传统相关的神祇；本轮由复合神器物目录建立入口，早期文本与祭祀史仍待扩张。 / Deity associated with the Memphite necropolis; this entry begins from composite-object catalogues and leaves earlier textual and cult history queued.','PARTIAL','UNVERIFIED',1,'{"scope":"component deity; no redirect to Ptah-Sokar-Osiris"}','2026-08-24T00:00:00Z','2026-08-24T00:00:00Z'),
('deity.egyptian.ptah_sokar_osiris','Ptah-Sokar-Osiris','卜塔-索卡尔-奥西里斯','ptḥ-skr-wsjr','Ptah-Sokar-Osiris','DEITY','civ.egyptian','region.northeast_africa','Third Intermediate Period through Ptolemaic object witnesses in this dossier','由卜塔、索卡尔与奥西里斯构成的丧葬复合神档案；三个组成神继续独立存在。 / Funerary composite-deity dossier connecting Ptah, Sokar and Osiris without merging their component records.','PARTIAL','UNVERIFIED',1,'{"entity_model":"composite deity; witness-scoped component edges; no hard merge"}','2026-08-24T00:00:00Z','2026-08-24T00:00:00Z'),
('museum.met.pso_28_3_48','Ptah-Sokar-Osiris Figure of Pakherenkhonsu','帕赫伦孔苏的卜塔-索卡尔-奥西里斯像 28.3.48',NULL,NULL,'MUSEUM_OBJECT','civ.egyptian','region.northeast_africa','Dynasty 25, ca. 721-664 BCE','大都会艺术博物馆藏底比斯木质丧葬小像，来自 el-Khokha 墓 MMA 832。 / Met wooden funerary figure from el-Khokha, Tomb MMA 832.','PARTIAL','UNVERIFIED',1,'{"catalogue_number":"28.3.48","reality_status":"ARCHAEOLOGICAL_OBJECT"}','2026-08-24T00:00:00Z','2026-08-24T00:00:00Z'),
('museum.met.pso_21_9_1abc','Ptah-Sokar-Osiris Figure of the Temple Musician Ihyt','神庙乐师伊希特的卜塔-索卡尔-奥西里斯像 21.9.1a-c',NULL,NULL,'MUSEUM_OBJECT','civ.egyptian','region.northeast_africa','Ptolemaic Period, 332-30 BCE','中空木质丧葬神像；内部材料另建 21.9.1d 档案。 / Hollow funerary figure whose catalogued contents are modeled as separate object 21.9.1d.','PARTIAL','UNVERIFIED',1,'{"catalogue_number":"21.9.1a-c","reality_status":"ARCHAEOLOGICAL_OBJECT"}','2026-08-24T00:00:00Z','2026-08-24T00:00:00Z'),
('museum.met.pso_contents_21_9_1d','Linen and mud from Ptah-Sokar-Osiris figure','卜塔-索卡尔-奥西里斯像内部亚麻与泥 21.9.1d',NULL,NULL,'MUSEUM_OBJECT','civ.egyptian','region.northeast_africa','Ptolemaic Period, 305-30 BCE','从 21.9.1a-c 内部取出的亚麻与泥材料；与同一空腔中的麦粒和沙共同记录。 / Separately catalogued linen and mud removed from 21.9.1a-c; wheat and sand were also recorded in the cavity.','PARTIAL','UNVERIFIED',1,'{"catalogue_number":"21.9.1d","parent_object":"museum.met.pso_21_9_1abc"}','2026-08-24T00:00:00Z','2026-08-24T00:00:00Z'),
('museum.met.pso_34_9','Ptah-Sokar-Osiris Figure for Pestjauwymin','佩斯乔维敏的卜塔-索卡尔-奥西里斯像 34.9',NULL,NULL,'MUSEUM_OBJECT','civ.egyptian','region.northeast_africa','Late Period, 664-332 BCE','具有舒提冠、祈祷铭文和卡诺卜神形象的木质丧葬小像。 / Wooden funerary figure with shuty crown, prayer inscription and canopic-deity imagery.','PARTIAL','UNVERIFIED',1,'{"catalogue_number":"34.9","reality_status":"ARCHAEOLOGICAL_OBJECT"}','2026-08-24T00:00:00Z','2026-08-24T00:00:00Z');

INSERT OR IGNORE INTO entity_classifications(entity_id,type_code,is_primary,notes)
SELECT id,primary_type,1,'v0.11.0 Ptah-Sokar-Osiris object-evidence checkpoint' FROM entities WHERE created_at='2026-08-24T00:00:00Z';
INSERT OR IGNORE INTO entity_civilizations(entity_id,civilization_id,association_role,certainty,notes)
SELECT id,'civ.egyptian','ORIGIN','SUPPORTED','v0.11.0 source-scoped Egyptian dossier' FROM entities WHERE created_at='2026-08-24T00:00:00Z';

INSERT OR IGNORE INTO names(id,entity_id,name_text,normalized_text,language_id,script_name,name_type,is_preferred,source_id,notes) VALUES
('name.v0110.sokar.en','deity.egyptian.sokar','Sokar','sokar','lang.en','Latin','PREFERRED',1,'source.egypt.pso.met.28_3_48','Component name in official catalogue'),
('name.v0110.sokar.egy','deity.egyptian.sokar','skr','skr','lang.egy','Hieroglyphic transliteration','ORIGINAL',1,'source.egypt.pso.met.28_3_48','Conventional Egyptological transliteration'),
('name.v0110.pso.en','deity.egyptian.ptah_sokar_osiris','Ptah-Sokar-Osiris','ptah sokar osiris','lang.en','Latin','PREFERRED',1,'source.egypt.pso.met.28_3_48','Official catalogue form'),
('name.v0110.pso.egy','deity.egyptian.ptah_sokar_osiris','ptḥ-skr-wsjr','ptḥ skr wsjr','lang.egy','Hieroglyphic transliteration','ORIGINAL',1,'source.egypt.pso.met.28_3_48','Conventional Egyptological transliteration'),
('name.v0110.fig28.en','museum.met.pso_28_3_48','Ptah-Sokar-Osiris Figure of Pakherenkhonsu','ptah sokar osiris figure pakherenkhonsu','lang.en','Latin','PREFERRED',1,'source.egypt.pso.met.28_3_48','Official catalogue title'),
('name.v0110.ihyt.en','museum.met.pso_21_9_1abc','Ptah-Sokar-Osiris Figure of the Temple Musician Ihyt','ptah sokar osiris figure temple musician ihyt','lang.en','Latin','PREFERRED',1,'source.egypt.pso.met.21_9_1abc','Official catalogue title'),
('name.v0110.contents.en','museum.met.pso_contents_21_9_1d','Linen and mud from interior of Ptah-Sokar-Osiris figure','linen mud interior ptah sokar osiris figure','lang.en','Latin','PREFERRED',1,'source.egypt.pso.met.21_9_1d','Official catalogue title'),
('name.v0110.fig34.en','museum.met.pso_34_9','Ptah-Sokar-Osiris Figure inscribed for Pestjauwymin','ptah sokar osiris figure pestjauwymin','lang.en','Latin','PREFERRED',1,'source.egypt.pso.met.34_9','Official catalogue title');

INSERT OR IGNORE INTO deity_profiles(entity_id,deity_class,pantheon_or_family,rank_or_status,domains_json,powers_json,limitations_json,appearance_json,symbols_json,cult_summary,final_fate_summary) VALUES
('deity.egyptian.sokar','Necropolis deity','Egyptian','Component deity','["Memphite necropolis","funerary sphere"]','[]','["Current dossier does not yet establish a complete diachronic cult history"]','{"current_witness":"hawk-headed component description in museum catalogue"}','[]','Current evidence is limited to official museum object catalogues; primary textual and temple witnesses remain queued.',NULL),
('deity.egyptian.ptah_sokar_osiris','Composite funerary deity','Egyptian','Composite expression','["funerary protection","rebirth"]','[]','["Object contents and iconography vary by witness","Component identity is not a global alias merge"]','{"common_object_form":"mummiform funerary figure in registered witnesses"}','["shuty crown","solar disk","green face in 28.3.48"]','Registered through dated Third Intermediate, Late and Ptolemaic museum objects.',NULL);

INSERT OR IGNORE INTO museum_object_profiles(entity_id,holding_institution,catalogue_number,object_type,provenance,date_range,acquisition_notes) VALUES
('museum.met.pso_28_3_48','The Metropolitan Museum of Art','28.3.48','Wood, gesso and painted funerary figure','Thebes, el-Khokha, Tomb MMA 832, Pit 1; MMA excavations 1914-15','ca. 721-664 BCE','Rogers Fund, 1928'),
('museum.met.pso_21_9_1abc','The Metropolitan Museum of Art','21.9.1a-c','Hollow wood, paste, gilding and painted funerary figure','Egypt','332-30 BCE','Gift of Edward S. Harkness, 1921'),
('museum.met.pso_contents_21_9_1d','The Metropolitan Museum of Art','21.9.1d','Linen and mud contents','Removed from figure 21.9.1a-c','305-30 BCE','Gift of Edward S. Harkness, 1921'),
('museum.met.pso_34_9','The Metropolitan Museum of Art','34.9','Wood, paint and paste funerary figure','Egypt','664-332 BCE','Gift of W. Ruloff Kip, 1934');

INSERT OR IGNORE INTO claims(
 id,subject_id,predicate,object_entity_id,object_literal,object_datatype,statement,
 variant_group,claim_status,confidence,confidence_level,review_status,assertion_scope,
 knowledge_layer,tradition_scope,temporal_scope,research_notes,created_at
) VALUES
('claim.v0110.pso_component_ptah','deity.egyptian.ptah_sokar_osiris','COMPOSITE_EXPRESSION_OF','deity.egyptian.ptah',NULL,NULL,'The Met catalogue identifies Ptah as one component of Ptah-Sokar-Osiris.','egypt.pso.components','SUPPORTED',0.99,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Museum interpretation','Object 28.3.48','Component edge is not a redirect.','2026-08-24T00:00:00Z'),
('claim.v0110.pso_component_sokar','deity.egyptian.ptah_sokar_osiris','COMPOSITE_EXPRESSION_OF','deity.egyptian.sokar',NULL,NULL,'The Met catalogue identifies Sokar as one component of Ptah-Sokar-Osiris.','egypt.pso.components','SUPPORTED',0.99,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Museum interpretation','Object 28.3.48','Component edge is not a redirect.','2026-08-24T00:00:00Z'),
('claim.v0110.pso_component_osiris','deity.egyptian.ptah_sokar_osiris','COMPOSITE_EXPRESSION_OF','deity.egyptian.osiris',NULL,NULL,'The Met catalogue identifies Osiris as one component of Ptah-Sokar-Osiris.','egypt.pso.components','SUPPORTED',0.99,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Museum interpretation','Object 28.3.48','Component edge is not a redirect.','2026-08-24T00:00:00Z'),
('claim.v0110.fig28_depicts','museum.met.pso_28_3_48','DEPICTS','deity.egyptian.ptah_sokar_osiris',NULL,NULL,'The Met catalogues 28.3.48 as a Ptah-Sokar-Osiris figure.','egypt.pso.object_identity','SUPPORTED',0.99,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','ARCHAEOLOGICAL','Museum object catalogue','ca. 721-664 BCE',NULL,'2026-08-24T00:00:00Z'),
('claim.v0110.fig28_held','museum.met.pso_28_3_48','HELD_BY_MUSEUM','institution.met',NULL,NULL,'The Metropolitan Museum of Art holds object 28.3.48.','egypt.pso.custody','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Modern custody','Current catalogue',NULL,'2026-08-24T00:00:00Z'),
('claim.v0110.fig28_findspot','museum.met.pso_28_3_48','ASSOCIATED_WITH',NULL,'Thebes, el-Khokha, Tomb MMA 832, Pit 1','text','The catalogue records the find context as el-Khokha Tomb MMA 832, Pit 1, excavated in 1914-15.','egypt.pso.provenance','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Excavation provenance','1914-15 excavation','Literal retained until the tomb has a separate site entity.','2026-08-24T00:00:00Z'),
('claim.v0110.fig28_solid','museum.met.pso_28_3_48','ASSOCIATED_WITH',NULL,'solid figure and base','text','Object 28.3.48 is solid rather than hollow, so no contents are inferred for it.','egypt.pso.construction','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Object construction','ca. 721-664 BCE','Guards against copying the contents of later examples onto this object.','2026-08-24T00:00:00Z'),
('claim.v0110.ihyt_depicts','museum.met.pso_21_9_1abc','DEPICTS','deity.egyptian.ptah_sokar_osiris',NULL,NULL,'The Met catalogues 21.9.1a-c as a Ptah-Sokar-Osiris figure dedicated to the temple musician Ihyt.','egypt.pso.object_identity','SUPPORTED',0.99,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','ARCHAEOLOGICAL','Museum object catalogue','332-30 BCE',NULL,'2026-08-24T00:00:00Z'),
('claim.v0110.ihyt_held','museum.met.pso_21_9_1abc','HELD_BY_MUSEUM','institution.met',NULL,NULL,'The Metropolitan Museum of Art holds object 21.9.1a-c.','egypt.pso.custody','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Modern custody','Current catalogue',NULL,'2026-08-24T00:00:00Z'),
('claim.v0110.ihyt_contents','museum.met.pso_21_9_1abc','ASSOCIATED_WITH','museum.met.pso_contents_21_9_1d',NULL,NULL,'The separately catalogued linen-and-mud contents 21.9.1d came from inside figure 21.9.1a-c.','egypt.pso.contents','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Object contents','2016 X-ray record','Association is object-specific.','2026-08-24T00:00:00Z'),
('claim.v0110.contents_held','museum.met.pso_contents_21_9_1d','HELD_BY_MUSEUM','institution.met',NULL,NULL,'The Metropolitan Museum of Art holds object 21.9.1d.','egypt.pso.custody','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Modern custody','Current catalogue',NULL,'2026-08-24T00:00:00Z'),
('claim.v0110.contents_material','museum.met.pso_contents_21_9_1d','REPRESENTS',NULL,'linen bundles containing mud; wheat and sand also recorded in the cavity','text','The catalogue records linen bundles containing mud, with wheat and sand found loose in the parent figure cavity.','egypt.pso.contents','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Object examination','X-rayed in 2016','No generalization to other figures.','2026-08-24T00:00:00Z'),
('claim.v0110.contents_rebirth','museum.met.pso_contents_21_9_1d','ASSOCIATED_WITH',NULL,'agricultural-cycle interpretation of resurrection','text','The Met interprets the contents as probably evoking harvest, new growth and resurrection.','egypt.pso.interpretation','INTERPRETIVE',0.90,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Museum curatorial interpretation','Published object record','Interpretive rather than direct ancient textual statement.','2026-08-24T00:00:00Z'),
('claim.v0110.fig34_depicts','museum.met.pso_34_9','DEPICTS','deity.egyptian.ptah_sokar_osiris',NULL,NULL,'The Met catalogues object 34.9 as a Ptah-Sokar-Osiris figure.','egypt.pso.object_identity','SUPPORTED',0.99,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','ARCHAEOLOGICAL','Museum object catalogue','664-332 BCE',NULL,'2026-08-24T00:00:00Z'),
('claim.v0110.fig34_held','museum.met.pso_34_9','HELD_BY_MUSEUM','institution.met',NULL,NULL,'The Metropolitan Museum of Art holds object 34.9.','egypt.pso.custody','SUPPORTED',0.99,'HIGH','VERIFIED','HISTORICAL_REALITY','ARCHAEOLOGICAL','Modern custody','Current catalogue',NULL,'2026-08-24T00:00:00Z'),
('claim.v0110.fig34_rebirth','museum.met.pso_34_9','ASSOCIATED_WITH',NULL,'rebirth','text','The Met describes the funerary deity represented by 34.9 as embodying rebirth.','egypt.pso.interpretation','INTERPRETIVE',0.95,'HIGH','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Museum curatorial interpretation','Late Period object','Interpretive summary retained at object level.','2026-08-24T00:00:00Z'),
('claim.v0110.fig34_missing_base','museum.met.pso_34_9','ASSOCIATED_WITH',NULL,'missing base may have held papyrus or corn-mummy material','text','The catalogue cautiously suggests that a cavity in the missing base may have held papyrus or a corn-mummy.','egypt.pso.contents','UNRESOLVED',0.70,'MEDIUM','VERIFIED','SCHOLARLY_INTERPRETATION','SCHOLARLY_INTERPRETATION','Museum curatorial hypothesis','Late Period object','Possibility is not converted into an observed content claim.','2026-08-24T00:00:00Z');

INSERT OR IGNORE INTO evidence(id,claim_id,source_id,source_location,catalogue_number,evidence_type,direction,strength,research_notes)
SELECT 'evidence.'||substr(id,7),id,
 CASE WHEN id LIKE 'claim.v0110.fig28_%' OR id LIKE 'claim.v0110.pso_component_%' THEN 'source.egypt.pso.met.28_3_48'
      WHEN id LIKE 'claim.v0110.ihyt_%' THEN 'source.egypt.pso.met.21_9_1abc'
      WHEN id LIKE 'claim.v0110.contents_%' THEN 'source.egypt.pso.met.21_9_1d'
      ELSE 'source.egypt.pso.met.34_9' END,
 'Official online object record',
 CASE WHEN id LIKE 'claim.v0110.fig28_%' OR id LIKE 'claim.v0110.pso_component_%' THEN '28.3.48'
      WHEN id LIKE 'claim.v0110.ihyt_%' THEN '21.9.1a-c'
      WHEN id LIKE 'claim.v0110.contents_%' THEN '21.9.1d'
      ELSE '34.9' END,
 'MUSEUM_OBJECT','SUPPORTS',confidence,'Independent summary; object number and evidence scope retained.'
FROM claims WHERE id LIKE 'claim.v0110.%';

INSERT OR IGNORE INTO identity_candidates(id,entity_a_id,entity_b_id,assessment,confidence,source_id,notes) VALUES
('identity.v0110.pso_ptah','deity.egyptian.ptah_sokar_osiris','deity.egyptian.ptah','IDENTIFIED_IN_SOURCE',0.99,'source.egypt.pso.met.28_3_48','Retain both entities; model as COMPOSITE_EXPRESSION_OF.'),
('identity.v0110.pso_sokar','deity.egyptian.ptah_sokar_osiris','deity.egyptian.sokar','IDENTIFIED_IN_SOURCE',0.99,'source.egypt.pso.met.28_3_48','Retain both entities; model as COMPOSITE_EXPRESSION_OF.'),
('identity.v0110.pso_osiris','deity.egyptian.ptah_sokar_osiris','deity.egyptian.osiris','IDENTIFIED_IN_SOURCE',0.99,'source.egypt.pso.met.28_3_48','Retain both entities; model as COMPOSITE_EXPRESSION_OF.');

INSERT OR IGNORE INTO conflicts(id,subject_id,variant_group,claim_a_id,claim_b_id,conflict_type,status,summary,resolution_notes) VALUES
('conflict.v0110.pso_object_contents_variation','deity.egyptian.ptah_sokar_osiris','egypt.pso.object_contents','claim.v0110.fig28_solid','claim.v0110.ihyt_contents','EVIDENCE_LIMIT','OPEN','Registered figures differ: 28.3.48 is solid, while 21.9.1a-c is hollow and preserves catalogued contents; 34.9 has only a hypothetical missing-base cavity.','Never propagate one object contents to the whole type; continue object-by-object technical study.');

UPDATE collection_queue SET status='PARTIAL',attempts=attempts+1,last_error=NULL,
 next_action='Add primary textual and cult witnesses for Sokar and the composite; expand object typology by dated catalogue and excavation context',
 updated_at='2026-08-24T07:00:00Z' WHERE id='queue.v070.egypt.syncretism_expansion';
INSERT OR IGNORE INTO queue_status_history(id,queue_id,old_status,new_status,changed_at,reason) VALUES
('queuehist.v0110.egypt.syncretism','queue.v070.egypt.syncretism_expansion','SOURCE_FOUND','PARTIAL','2026-08-24T07:00:00Z','Added Ptah-Sokar-Osiris composite components and four object-level Met witnesses; wider composite network remains open.');

INSERT OR IGNORE INTO collection_queue(id,target_label,normalized_label,proposed_entity_type,civilization_id,discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,discovery_context,priority,status,attempts,next_action,created_at,updated_at) VALUES
('queue.v0110.egypt.sokar_primary_witnesses','Sokar primary texts and pre-composite cult witnesses','sokar primary texts pre composite cult witnesses','DEITY','civ.egyptian','deity.egyptian.sokar','claim.v0110.pso_component_sokar','source.egypt.pso.met.28_3_48','Museum component description exposes the need for earlier text and cult evidence.',99,'DISCOVERED',0,'Register dated primary text locators, Memphite cult places and iconographic witnesses','2026-08-24T00:00:00Z','2026-08-24T00:00:00Z'),
('queue.v0110.egypt.pso_typology','Ptah-Sokar-Osiris figure typology by period','ptah sokar osiris figure typology period','MUSEUM_OBJECT','civ.egyptian','deity.egyptian.ptah_sokar_osiris','claim.v0110.fig28_solid','source.egypt.pso.met.28_3_48','Solid and hollow examples show that construction and contents vary.',98,'CONFLICT',0,'Add dated object catalogues and technical studies; never infer unobserved contents','2026-08-24T00:00:00Z','2026-08-24T00:00:00Z'),
('queue.v0110.egypt.pso_inscriptions','Ptah-Sokar-Osiris figure inscriptions and named owners','ptah sokar osiris figure inscriptions named owners','INSCRIPTION','civ.egyptian','museum.met.pso_21_9_1abc','claim.v0110.ihyt_depicts','source.egypt.pso.met.21_9_1abc','Named owners and offering texts open an inscription-level prosopography branch.',97,'DISCOVERED',0,'Register text editions, line locators, names and translation provenance','2026-08-24T00:00:00Z','2026-08-24T00:00:00Z'),
('queue.v0110.egypt.pso_material_analysis','Technical analysis of Ptah-Sokar-Osiris figure contents','technical analysis ptah sokar osiris figure contents','MUSEUM_OBJECT','civ.egyptian','museum.met.pso_contents_21_9_1d','claim.v0110.contents_material','source.egypt.pso.met.21_9_1d','The 2016 X-ray record creates a material-analysis evidence branch.',98,'SOURCE_FOUND',0,'Find technical reports and register observed materials separately from interpretation','2026-08-24T00:00:00Z','2026-08-24T00:00:00Z'),
('queue.v0110.egypt.osiris_grain_rites','Osiris grain figures and annual ritual witnesses','osiris grain figures annual ritual witnesses','RITUAL','civ.egyptian','deity.egyptian.osiris','claim.v0110.contents_rebirth','source.egypt.pso.met.21_9_1d','Museum interpretation links agricultural materials to a wider Osirian ritual corpus.',96,'DISCOVERED',0,'Add primary ritual texts, excavated grain figures and dated festival evidence','2026-08-24T00:00:00Z','2026-08-24T00:00:00Z'),
('queue.v0110.egypt.ra_atum_composite','Ra-Atum composite witnesses by period','ra atum composite witnesses period','DEITY','civ.egyptian','concept.egyptian.divine_syncretism','claim.v0110.pso_component_ptah','source.egypt.syncretism.uee2008','The parent composite-network target still includes Ra-Atum as an unexpanded branch.',99,'SOURCE_FOUND',0,'Use Pyramid/Coffin Text locators and dated objects; preserve Ra and Atum independently','2026-08-24T00:00:00Z','2026-08-24T00:00:00Z');

INSERT OR IGNORE INTO queue_discoveries(id,queue_id,discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,discovery_context,discovered_at)
SELECT 'discovery.'||substr(id,7),id,discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,discovery_context,'2026-08-24T00:00:00Z' FROM collection_queue WHERE id LIKE 'queue.v0110.%';

INSERT OR IGNORE INTO research_sessions(id,started_at,ended_at,scope,strategy,status,agent_or_process,notes) VALUES
('research.20260824.v0110_ptah_sokar_osiris_objects','2026-08-24T00:00:00Z','2026-08-24T07:00:00Z','Ptah-Sokar-Osiris composite identity, dated funerary figures, object contents, custody and interpretive limits','Start from permanent priority-99 Egyptian syncretism queue; use official museum object catalogues; keep components, observed material, hypothesis and modern custody distinct','CHECKPOINT_COMPLETE','Codex persistent research pipeline','Expandable staged baseline only. Primary texts, cult history, typology, inscriptions, technical analysis and Ra-Atum remain queued.');
INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result)
SELECT 'research.20260824.v0110_ptah_sokar_osiris_objects','SOURCE',id,'REGISTER','OFFICIAL_MUSEUM_CATALOGUE_WITH_OBJECT_LOCATOR' FROM sources WHERE id LIKE 'source.egypt.pso.%';
INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result)
SELECT 'research.20260824.v0110_ptah_sokar_osiris_objects','CLAIM',id,'REGISTER','SOURCE_LOCATED' FROM claims WHERE id LIKE 'claim.v0110.%';
INSERT OR IGNORE INTO research_session_items(session_id,item_kind,item_id,action,result)
SELECT 'research.20260824.v0110_ptah_sokar_osiris_objects','ENTITY',id,'CREATE','OBJECT_OR_COMPONENT_DOSSIER_REGISTERED' FROM entities WHERE created_at='2026-08-24T00:00:00Z';

UPDATE entities SET evidence_status='SOURCE_BACKED',updated_at='2026-08-24T07:00:00Z'
WHERE id IN (SELECT subject_id FROM claims WHERE id LIKE 'claim.v0110.%')
AND NOT EXISTS (SELECT 1 FROM claims c WHERE c.subject_id=entities.id AND NOT EXISTS (SELECT 1 FROM evidence e WHERE e.claim_id=c.id));
UPDATE entities SET evidence_status='PARTIAL',updated_at='2026-08-24T07:00:00Z'
WHERE evidence_status<>'SOURCE_BACKED' AND id IN (SELECT object_entity_id FROM claims WHERE id LIKE 'claim.v0110.%' AND object_entity_id IS NOT NULL);
UPDATE civilizations SET research_status='COLLECTING',evidence_status='PARTIAL' WHERE id='civ.egyptian';
UPDATE project_metadata SET value='0.11.0-ptah-sokar-osiris-objects-20260824',updated_at='2026-08-24T07:00:00Z' WHERE key='data_version';
UPDATE project_metadata SET value='18',updated_at='2026-08-24T07:00:00Z' WHERE key='schema_version';
UPDATE project_metadata SET value='2026-08-24T07:00:00Z',updated_at='2026-08-24T07:00:00Z' WHERE key='generated_at';
INSERT OR IGNORE INTO dataset_releases(id,schema_version,data_version,git_commit,built_at,database_sha256,release_notes) VALUES
('release.0.11.0',18,'0.11.0-ptah-sokar-osiris-objects-20260824',NULL,'2026-08-24T07:00:00Z',NULL,'Ptah-Sokar-Osiris object-evidence checkpoint: Sokar and composite deity dossiers, three independent components, four Met catalogue objects, observed contents versus hypotheses, custody, provenance and permanent follow-up paths.');
INSERT INTO schema_migrations(version,name,applied_at) VALUES
(18,'20260824_v0110_ptah_sokar_osiris_objects','2026-08-24T07:00:00Z');

COMMIT;
