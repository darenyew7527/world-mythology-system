import json
import re
import sqlite3
import tempfile
import unittest
from pathlib import Path

from scripts.generate_offline_archive import HTML_NAME, generate
from scripts.generate_web_data import build_snapshot


ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "database" / "world_mythology.sqlite"
WEB = ROOT / "web" / "src"

NEW_LONG_VERSIONS = {
    "storyver.chinese.xiyouji_ch1_7": "story.chinese.xiyouji_havoc_in_heaven",
    "storyver.chinese.fengshen_ch12_14": "story.chinese.fengshen_nezha",
    "storyver.greek.theogony_long": "story.greek.theogony_cosmos",
    "storyver.norse.utgard_gylf": "story.norse.thor_utgarda_loki",
    "storyver.babylonian.gilgamesh_sb": "story.babylonian.gilgamesh_epic",
    "storyver.egyptian.plutarch_ch12_20": "story.egyptian.osiris_plutarch",
    "storyver.japanese.kojiki_sect11_19": "story.japanese.iwato_orochi",
    "storyver.hindu.ramayana_griffith_1_6": "story.hindu.ramayana",
}
# Long versions added beside the short versions of existing stories.
EXTRA_LONG_VERSIONS = {
    "storyver.greek.demeter_hymn2_long": ("story.greek.demeter_persephone", "storyver.greek.demeter_hymn2"),
    "storyver.norse.baldr_gylf_long": ("story.norse.frigg_baldr", "storyver.norse.frigg_gylf"),
    "storyver.babylonian.enuma_elish_long": ("story.babylonian.marduk_tiamat", "storyver.babylonian.enuma_elish"),
    "storyver.sumerian.inanna_etcsl_long": ("story.sumerian.inanna_descent", "storyver.sumerian.inanna_etcsl"),
}
LONG_VERSIONS = {**NEW_LONG_VERSIONS, **{key: value[0] for key, value in EXTRA_LONG_VERSIONS.items()}}
LATER_RECEPTION = ("storyver.chinese.xiyouji_ch1_7", "storyver.chinese.fengshen_ch12_14", "storyver.egyptian.plutarch_ch12_20")


class LongStoriesTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.snapshot = build_snapshot(DB)
        cls.stories = {story["id"]: story for story in cls.snapshot["stories"]}
        cls.versions = {version["id"]: version for story in cls.snapshot["stories"] for version in story["versions"]}
        cls.cards = {card["entityId"]: card for card in cls.snapshot["deityStoryCards"]}

    def connect(self):
        connection = sqlite3.connect(DB)
        connection.row_factory = sqlite3.Row
        return connection

    def test_schema_45_and_46_seal_v032_preserved_after_v035(self):
        with self.connect() as connection:
            migrations = dict(connection.execute(
                "SELECT version,name FROM schema_migrations WHERE version IN (45,46)"
            ).fetchall())
            latest = connection.execute(
                "SELECT id,schema_version,data_version FROM dataset_releases ORDER BY built_at DESC,id DESC LIMIT 1"
            ).fetchone()
            v031 = connection.execute(
                "SELECT schema_version FROM dataset_releases WHERE id='release.v0.31.0'"
            ).fetchone()
            v032 = connection.execute(
                "SELECT schema_version,data_version FROM dataset_releases WHERE id='release.v0.32.0'"
            ).fetchone()
            batch = connection.execute(
                "SELECT status,version_label FROM story_expansion_batches WHERE id='storybatch.v0320.04'"
            ).fetchone()
            targets = dict(connection.execute(
                "SELECT status,COUNT(*) FROM story_expansion_targets WHERE batch_id='storybatch.v0320.04' GROUP BY status"
            ).fetchall())
        self.assertEqual(migrations, {45: "20261011_v0320_long_stories", 46: "20261011_v0320_long_stories_release"})
        self.assertEqual(dict(latest), {"id": "release.v0.35.0", "schema_version": 52, "data_version": "0.35.0"})
        self.assertEqual(dict(v032), {"schema_version": 46, "data_version": "0.32.0"})
        self.assertEqual(v031["schema_version"], 44)
        self.assertEqual(tuple(batch), ("CHECKPOINT_COMPLETE", "0.32.0"))
        self.assertEqual(targets, {"COMPLETED": 12})
        meta = self.snapshot["meta"]
        self.assertEqual(meta["projectVersion"], "0.35.0-world-epics")
        self.assertEqual(meta["dataVersion"], "0.35.0")

    def test_long_versions_are_long_and_every_section_is_evidenced(self):
        with self.connect() as connection:
            rows = connection.execute(
                f"""SELECT ss.story_version_id AS version_id, ss.id, ss.body_zh, ss.body_en, ss.anchor_claim_id,
                           sv.source_id AS version_source,
                           (SELECT COUNT(*) FROM evidence e WHERE e.claim_id=ss.anchor_claim_id
                              AND e.direction='SUPPORTS' AND e.source_id=sv.source_id) AS supports
                      FROM story_sections ss JOIN story_versions sv ON sv.id=ss.story_version_id
                     WHERE ss.story_version_id IN ({','.join('?' for _ in LONG_VERSIONS)})""",
                tuple(LONG_VERSIONS),
            ).fetchall()
            nodes = dict(connection.execute(
                f"""SELECT story_version_id,COUNT(*) FROM story_event_nodes
                     WHERE story_version_id IN ({','.join('?' for _ in LONG_VERSIONS)}) GROUP BY story_version_id""",
                tuple(LONG_VERSIONS),
            ).fetchall())
        by_version = {}
        for row in rows:
            by_version.setdefault(row["version_id"], []).append(row)
        self.assertEqual(set(by_version), set(LONG_VERSIONS))
        for version_id, sections in by_version.items():
            self.assertGreaterEqual(len(sections), 12, version_id)
            self.assertLessEqual(len(sections), 20, version_id)
            self.assertEqual(nodes[version_id], len(sections), version_id)
            average = sum(len(row["body_zh"]) for row in sections) / len(sections)
            self.assertGreaterEqual(average, 200, version_id)
            anchors = [row["anchor_claim_id"] for row in sections]
            self.assertEqual(len(anchors), len(set(anchors)), version_id)
            for row in sections:
                self.assertGreaterEqual(len(row["body_zh"]), 150, row["id"])
                self.assertGreaterEqual(len(row["body_en"].split()), 50, row["id"])
                self.assertGreater(row["supports"], 0, row["id"])
        total = sum(len(row["body_zh"]) for row in rows)
        self.assertGreaterEqual(total, 40000)

    def test_long_versions_of_existing_stories_open_first_and_keep_short_ones(self):
        for long_id, (story_id, short_id) in EXTRA_LONG_VERSIONS.items():
            story = self.stories[story_id]
            ids = [version["id"] for version in story["versions"]]
            self.assertEqual(ids[0], long_id, story_id)
            self.assertIn(short_id, ids, story_id)
            self.assertEqual(self.versions[long_id]["versionOrder"], 0)
        for version_id, story_id in NEW_LONG_VERSIONS.items():
            self.assertEqual(self.stories[story_id]["versions"][0]["id"], version_id)

    def test_reading_time_follows_the_text(self):
        for version_id, story_id in LONG_VERSIONS.items():
            chars = sum(len(section["bodyZh"]) for section in self.versions[version_id]["sections"])
            expected = max(1, round(chars / 400))
            minutes = self.stories[story_id]["readingMinutes"]
            if version_id in NEW_LONG_VERSIONS:
                self.assertEqual(minutes, expected, story_id)
            else:
                self.assertGreaterEqual(minutes, expected, story_id)

    def test_later_literature_stays_in_later_reception(self):
        with self.connect() as connection:
            layers = {
                row["story_version_id"]: row["layers"]
                for row in connection.execute(
                    f"""SELECT ss.story_version_id, GROUP_CONCAT(DISTINCT c.knowledge_layer) AS layers
                          FROM story_sections ss JOIN claims c ON c.id=ss.anchor_claim_id
                         WHERE ss.story_version_id IN ({','.join('?' for _ in LONG_VERSIONS)})
                         GROUP BY ss.story_version_id""",
                    tuple(LONG_VERSIONS),
                )
            }
            historical = connection.execute(
                "SELECT COUNT(*) FROM claims WHERE id LIKE 'claim.v0320.%' AND assertion_scope='HISTORICAL_REALITY'"
            ).fetchone()[0]
            sources = connection.execute(
                """SELECT id,url,accessed_date,verification_status FROM sources
                    WHERE id IN ('source.china.xiyouji.wikisource','source.china.fengshen_yanyi.wikisource',
                                 'source.greek.plutarch_isis_osiris.lacuscurtius','source.indian.ramayana_griffith.gutenberg')"""
            ).fetchall()
        for version_id in LATER_RECEPTION:
            self.assertEqual(layers[version_id], "LATER_RECEPTION", version_id)
        for version_id in set(LONG_VERSIONS) - set(LATER_RECEPTION):
            self.assertEqual(layers[version_id], "MYTHIC_NARRATIVE", version_id)
        self.assertEqual(historical, 0)
        self.assertEqual(len(sources), 4)
        for row in sources:
            self.assertTrue(row["url"].startswith("https://"), row["id"])
            self.assertEqual(row["accessed_date"], "2026-10-11")
            self.assertEqual(row["verification_status"], "URL_SYNTAX_VALID")

    def test_deity_cards_carry_every_section_of_their_story(self):
        long_cards = 0
        for card in self.cards.values():
            if card["status"] != "STORY_LINKED":
                continue
            version = self.versions[card["primaryVersionId"]]
            self.assertEqual(len(card["beats"]), len(version["sections"]), card["entityId"])
            if len(card["beats"]) >= 12:
                long_cards += 1
        self.assertGreaterEqual(long_cards, 50)
        for entity_id, version_id in (
            ("deity.hindu.rama", "storyver.hindu.ramayana_griffith_book1"),  # v0.33: first series part
            ("deity.japanese.amaterasu", "storyver.japanese.kojiki_sect11_19"),
            ("deity.greek.demeter", "storyver.greek.demeter_hymn2_long"),
            ("deity.babylonian.marduk", "storyver.babylonian.enuma_elish_long"),
        ):
            self.assertEqual(self.cards[entity_id]["primaryVersionId"], version_id)
        # Claim-only cards stay short.
        self.assertTrue(all(len(card["beats"]) <= 6 for card in self.cards.values() if card["status"] == "CLAIM_CARD"))

    def test_feature_registries_record_long_reading_without_public_writes(self):
        with self.connect() as connection:
            explorer = connection.execute(
                "SELECT status,introduced_in FROM explorer_feature_registry WHERE feature_code='long_form_stories'"
            ).fetchone()
            reader = connection.execute(
                "SELECT storage_scope,public_database_writes,personal_data_collection,introduced_in "
                "FROM reader_feature_registry WHERE feature_code='READING_POSITION'"
            ).fetchone()
        self.assertEqual(tuple(explorer), ("ACTIVE", "v0.32.0"))
        self.assertEqual(tuple(reader), ("LOCAL_ONLY", 0, 0, "v0.32.0"))

    def test_ui_wires_chapter_navigation_and_reading_position(self):
        nav = (WEB / "components" / "ChapterNav.jsx").read_text(encoding="utf-8")
        library = (WEB / "components" / "StoryLibrary.jsx").read_text(encoding="utf-8")
        reader = (WEB / "components" / "DeityStoryReader.jsx").read_text(encoding="utf-8")
        gallery = (WEB / "components" / "DeityGallery.jsx").read_text(encoding="utf-8")
        storage = (WEB / "readerStorage.js").read_text(encoding="utf-8")
        deck = (WEB / "storyDeck.js").read_text(encoding="utf-8")
        styles = (WEB / "styles.css").read_text(encoding="utf-8")
        self.assertIn("aria-label={copy.toc}", nav)
        self.assertIn("prefers-reduced-motion", nav)
        self.assertIn("export function NextChapter", nav)
        for source in (library, reader):
            self.assertIn("<ChapterNav", source)
            self.assertIn("<NextChapter", source)
        self.assertIn("aria-pressed={longOnly}", library)
        self.assertIn("deity-other-stories", reader)
        self.assertIn("saveReadingPosition", reader)
        self.assertIn("'LONG'", gallery)
        self.assertIn("export const saveReadingPosition", storage)
        self.assertIn("mergeProgress", storage)
        self.assertIn("wms-reader-v029", storage)
        self.assertIn("export const LONG_STORY_SECTIONS = 12", deck)
        self.assertIn(".chapter-nav {", styles)
        self.assertIn(".chapter-nav, .chapter-next, .chapter-resume, .deity-other-stories { display: none; }", styles)
        self.assertIn("v0.35", library)
        tiny = [float(value) for value in re.findall(r"font-size:\s*(0?\.\d+)rem", styles) if float(value) < 0.68]
        self.assertEqual(tiny, [])

    def test_offline_archive_and_markdown_print_each_long_story_once(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            generate(DB, root / "offline", root / "manifest.json", markdown_dir=root / "md")
            html_text = (root / "offline" / HTML_NAME).read_text(encoding="utf-8")
            greek = (root / "md" / "greek.md").read_text(encoding="utf-8")
        self.assertEqual(HTML_NAME, "world-mythology-v0.35-story-archive.html")
        self.assertIn('class="long-story-link"', html_text)
        theogony_first = self.versions["storyver.greek.theogony_long"]["sections"][0]["bodyZh"]
        self.assertEqual(greek.count(theogony_first), 1)
        self.assertIn("长篇故事 · 16 章", greek)
        self.assertIn("../story.greek.theogony_cosmos.md", greek)
        # Size guard against printing a long story once per deity; v0.34 adds Heracles and Hera to the Greek file.
        self.assertLess(len(greek.encode("utf-8")), 350_000)


if __name__ == "__main__":
    unittest.main()
