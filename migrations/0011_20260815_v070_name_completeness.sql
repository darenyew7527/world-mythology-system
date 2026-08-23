PRAGMA foreign_keys = ON;

INSERT OR IGNORE INTO names(
  id,entity_id,name_text,normalized_text,language_id,script_name,name_type,
  transliteration_scheme,is_preferred,source_id,notes
) VALUES
('name.v070.syncretism.en','concept.egyptian.divine_syncretism','Egyptian divine syncretism','egyptian divine syncretism','lang.en','Latin','EDITORIAL_CANONICAL',NULL,1,'source.egypt.syncretism.uee2008','Project concept label grounded in the registered scholarly discussion.'),
('name.v070.syncretism.zh','concept.egyptian.divine_syncretism','古埃及神祇复合／融合表达','古埃及神祇复合 融合表达','lang.zh','Han','TRANSLATION',NULL,1,'source.egypt.syncretism.uee2008','Chinese project translation.'),
('name.v070.solar_journey.en','event.egyptian.nocturnal_solar_journey','Nocturnal journey of the sun god','nocturnal journey of the sun god','lang.en','Latin','EDITORIAL_CANONICAL',NULL,1,'source.egypt.nauny_book_dead.met.30_3_31','Project event label for a mythic-cosmological sequence.'),
('name.v070.solar_journey.zh','event.egyptian.nocturnal_solar_journey','太阳神夜行冥界','太阳神夜行冥界','lang.zh','Han','TRANSLATION',NULL,1,'source.egypt.nauny_book_dead.met.30_3_31','Chinese project translation.'),
('name.v070.theban_triad.en','group.egyptian.theban_triad','Theban Triad','theban triad','lang.en','Latin','PREFERRED',NULL,1,'source.egypt.syncretism.uee2008','Scholarly grouping label.'),
('name.v070.theban_triad.zh','group.egyptian.theban_triad','底比斯三神组','底比斯三神组','lang.zh','Han','TRANSLATION',NULL,1,'source.egypt.syncretism.uee2008','Chinese project translation.'),
('name.v070.met_scarab.en','museum.met.amun_re_scarab_09_180_953','Scarab inscribed with Amun-Re and Neit','scarab inscribed with amun re and neit','lang.en','Latin','PREFERRED',NULL,1,'source.egypt.amun_re_scarab.met.09_180_953','Museum catalogue-derived title.'),
('name.v070.met_scarab.zh','museum.met.amun_re_scarab_09_180_953','阿蒙-拉与奈特名号圣甲虫 09.180.953','阿蒙 拉与奈特名号圣甲虫 09 180 953','lang.zh','Han','TRANSLATION',NULL,1,'source.egypt.amun_re_scarab.met.09_180_953','Chinese project translation.'),
('name.v070.met_stela.en','museum.met.ra_horakhty_stela_oc81','Stela with man offering to Re-Harakhty','stela with man offering to re harakhty','lang.en','Latin','PREFERRED',NULL,1,'source.egypt.ra_horakhty_stela.met.oc81','Museum catalogue-derived title.'),
('name.v070.met_stela.zh','museum.met.ra_horakhty_stela_oc81','向拉-哈拉赫提献祭未完成木碑 O.C.81','向拉 哈拉赫提献祭未完成木碑 o c 81','lang.zh','Han','TRANSLATION',NULL,1,'source.egypt.ra_horakhty_stela.met.oc81','Chinese project translation.'),
('name.v070.met_amulet.en','museum.met.ra_horakhty_amulet_74_51_4497','Faience amulet of Ra Horakhty','faience amulet of ra horakhty','lang.en','Latin','PREFERRED',NULL,1,'source.egypt.ra_horakhty_amulet.met.74_51_4497','Museum catalogue-derived title.'),
('name.v070.met_amulet.zh','museum.met.ra_horakhty_amulet_74_51_4497','拉-哈拉赫提釉陶护符 74.51.4497','拉 哈拉赫提釉陶护符 74 51 4497','lang.zh','Han','TRANSLATION',NULL,1,'source.egypt.ra_horakhty_amulet.met.74_51_4497','Chinese project translation.'),
('name.v070.bm_stela.en','museum.bm.khepri_hymn_stela_ea826','Stela with hymn to Khepri','stela with hymn to khepri','lang.en','Latin','PREFERRED',NULL,1,'source.egypt.khepri_hymn.bm.ea826','Museum catalogue-derived title.'),
('name.v070.bm_stela.zh','museum.bm.khepri_hymn_stela_ea826','凯布利赞歌石碑 EA826','凯布利赞歌石碑 ea826','lang.zh','Han','TRANSLATION',NULL,1,'source.egypt.khepri_hymn.bm.ea826','Chinese project translation.'),
('name.v070.nauny.en','museum.met.nauny_book_dead_30_3_31','Book of the Dead for Nauny','book of the dead for nauny','lang.en','Latin','PREFERRED',NULL,1,'source.egypt.nauny_book_dead.met.30_3_31','Museum catalogue title.'),
('name.v070.nauny.zh','museum.met.nauny_book_dead_30_3_31','娜乌妮《亡灵书》纸草 30.3.31','娜乌妮 亡灵书 纸草 30 3 31','lang.zh','Han','TRANSLATION',NULL,1,'source.egypt.nauny_book_dead.met.30_3_31','Chinese project translation.'),
('name.v070.spell17.en','text.egypt.book_dead_spell17','Book of the Dead Spell 17','book of the dead spell 17','lang.en','Latin','PREFERRED',NULL,1,'source.egypt.book_dead17.ucl','Section-level English title.'),
('name.v070.spell17.zh','text.egypt.book_dead_spell17','《亡灵书》第17咒文','亡灵书 第17咒文','lang.zh','Han','TRANSLATION',NULL,1,'source.egypt.book_dead17.ucl','Chinese project translation.');

UPDATE project_metadata SET value='11' WHERE key='schema_version';

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(11,'20260815_v070_name_completeness','2026-08-15T06:30:00Z');
