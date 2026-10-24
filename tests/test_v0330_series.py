import json
import re
import sqlite3
import tempfile
import unittest
from pathlib import Path

from scripts.generate_offline_archive import HTML_NAME, JSON_NAME, generate
from scripts.generate_web_data import build_snapshot
from world_mythology.validation import validate_connection


ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "database" / "world_mythology.sqlite"
WEB = ROOT / "web" / "src"

SERIES = {
    "series.chinese.xiyouji": [
        "story.chinese.xiyouji_havoc_in_heaven",
        "story.chinese.xiyouji_origins",
        "story.chinese.xiyouji_pilgrims_gather",
        "story.chinese.xiyouji_white_bone",
        "story.chinese.xiyouji_two_monkey_kings",
        "story.chinese.xiyouji_flaming_mountains",
    ],
    "series.hindu.ramayana_books": [
        "story.hindu.ramayana_bala",
        "story.hindu.ramayana_ayodhya",
        "story.hindu.ramayana_aranya",
        "story.hindu.ramayana_kishkindha",
        "story.hindu.ramayana_sundara",
        "story.hindu.ramayana_yuddha",
    ],
    "series.greek.odyssey": [
        "story.greek.odyssey_wanderings",
        "story.greek.odyssey_homecoming",
    ],
}
SERIES_CHAPTERS = {"series.chinese.xiyouji": 91, "series.hindu.ramayana_books": 87, "series.greek.odyssey": 32}
NEW_VERSIONS = {
    "storyver.chinese.xiyouji_ch8_12": "story.chinese.xiyouji_origins",
    "storyver.chinese.xiyouji_ch13_22": "story.chinese.xiyouji_pilgrims_gather",
    "storyver.chinese.xiyouji_ch27_31": "story.chinese.xiyouji_white_bone",
    "storyver.chinese.xiyouji_ch56_58": "story.chinese.xiyouji_two_monkey_kings",
    "storyver.chinese.xiyouji_ch59_61": "story.chinese.xiyouji_flaming_mountains",
    "storyver.hindu.ramayana_griffith_book1": "story.hindu.ramayana_bala",
    "storyver.hindu.ramayana_griffith_book2": "story.hindu.ramayana_ayodhya",
    "storyver.hindu.ramayana_griffith_book3": "story.hindu.ramayana_aranya",
    "storyver.hindu.ramayana_griffith_book4": "story.hindu.ramayana_kishkindha",
    "storyver.hindu.ramayana_griffith_book5": "story.hindu.ramayana_sundara",
    "storyver.hindu.ramayana_griffith_book6": "story.hindu.ramayana_yuddha",
    "storyver.greek.odyssey_butler_1_12": "story.greek.odyssey_wanderings",
    "storyver.greek.odyssey_butler_13_24": "story.greek.odyssey_homecoming",
}
ROMAN = {"I": 1, "V": 5, "X": 10}


def roman(value):
    total = 0
    for index, char in enumerate(value):
        number = ROMAN[char]
        total += -number if index + 1 < len(value) and ROMAN[value[index + 1]] > number else number
    return total


class StorySeriesTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.snapshot = build_snapshot(DB)
        cls.stories = {story["id"]: story for story in cls.snapshot["stories"]}
        cls.versions = {version["id"]: version for story in cls.snapshot["stories"] for version in story["versions"]}
        cls.series = {series["id"]: series for series in cls.snapshot["storySeries"]}
        cls.cards = {card["entityId"]: card for card in cls.snapshot["deityStoryCards"]}

    def connect(self):
        connection = sqlite3.connect(DB)
        connection.row_factory = sqlite3.Row
        return connection

    def test_schema_47_and_48_seal_v033_preserved_after_v036(self):
        with self.connect() as connection:
            migrations = dict(connection.execute(
                "SELECT version,name FROM schema_migrations WHERE version IN (47,48)"
            ).fetchall())
            release = connection.execute(
                "SELECT schema_version,data_version FROM dataset_releases WHERE id='release.v0.33.0'"
            ).fetchone()
            latest = connection.execute(
                "SELECT id,schema_version,data_version FROM dataset_releases ORDER BY built_at DESC,id DESC LIMIT 1"
            ).fetchone()
            batch = connection.execute(
                "SELECT status,version_label FROM story_expansion_batches WHERE id='storybatch.v0330.05'"
            ).fetchone()
            targets = dict(connection.execute(
                "SELECT status,COUNT(*) FROM story_expansion_targets WHERE batch_id='storybatch.v0330.05' GROUP BY status"
            ).fetchall())
        self.assertEqual(migrations, {47: "20261024_v0330_series", 48: "20261024_v0330_series_release"})
        self.assertEqual(dict(release), {"schema_version": 48, "data_version": "0.33.0"})
        self.assertEqual(dict(latest), {"id": "release.v0.36.0", "schema_version": 54, "data_version": "0.36.0"})
        self.assertEqual(tuple(batch), ("CHECKPOINT_COMPLETE", "0.33.0"))
        self.assertEqual(targets, {"COMPLETED": 13})
        meta = self.snapshot["meta"]
        self.assertEqual(meta["projectVersion"], "0.36.0-deity-story-upgrade")
        # Later versions only add series; the v0.33 checkpoint remains a lower bound.
        self.assertGreaterEqual(meta["counts"]["storySeries"], 3)
        self.assertGreaterEqual(meta["counts"]["storySeriesParts"], 14)
        schema = (ROOT / "schema" / "schema.sql").read_text(encoding="utf-8")
        self.assertIn("CREATE TABLE IF NOT EXISTS story_series (", schema)
        self.assertIn("CREATE TABLE IF NOT EXISTS story_series_parts (", schema)

    def test_series_parts_are_ordered_and_linked(self):
        self.assertLessEqual(set(SERIES), set(self.series))
        for series_id, story_ids in SERIES.items():
            series = self.series[series_id]
            self.assertEqual([part["storyId"] for part in series["parts"]], story_ids)
            self.assertEqual([part["order"] for part in series["parts"]], list(range(1, len(story_ids) + 1)))
            self.assertEqual(series["totalChapters"], SERIES_CHAPTERS[series_id])
            self.assertEqual(series["totalChapters"], sum(part["chapters"] for part in series["parts"]))
            self.assertTrue(series["selectionNote"])
            for index, story_id in enumerate(story_ids):
                link = self.stories[story_id]["series"]
                self.assertEqual(link["id"], series_id)
                self.assertEqual(link["partOrder"], index + 1)
                self.assertEqual(link["partCount"], len(story_ids))
                self.assertEqual(link["previousStoryId"], story_ids[index - 1] if index else None)
                self.assertEqual(link["nextStoryId"], story_ids[index + 1] if index + 1 < len(story_ids) else None)
        in_series = {part["storyId"] for series in self.series.values() for part in series["parts"]}
        self.assertTrue(all(story["series"] is None for story in self.stories.values() if story["id"] not in in_series))
        # Only the Journey to the West parts that follow skipped chapters name a gap.
        gaps = {part["storyId"] for series_id in SERIES for part in self.series[series_id]["parts"] if part["gapNote"]}
        self.assertEqual(gaps, {"story.chinese.xiyouji_white_bone", "story.chinese.xiyouji_two_monkey_kings"})
        # The earlier whole-epic Rāmāyaṇa overview stays a separate story.
        self.assertIsNone(self.stories["story.hindu.ramayana"]["series"])

    def test_new_parts_are_long_and_every_section_is_evidenced(self):
        with self.connect() as connection:
            rows = connection.execute(
                f"""SELECT ss.story_version_id AS version_id, ss.id, ss.body_zh, ss.body_en, ss.anchor_claim_id,
                           (SELECT COUNT(*) FROM evidence e WHERE e.claim_id=ss.anchor_claim_id
                              AND e.direction='SUPPORTS' AND e.source_id=sv.source_id) AS supports
                      FROM story_sections ss JOIN story_versions sv ON sv.id=ss.story_version_id
                     WHERE ss.story_version_id IN ({','.join('?' for _ in NEW_VERSIONS)})""",
                tuple(NEW_VERSIONS),
            ).fetchall()
            nodes = dict(connection.execute(
                f"""SELECT story_version_id,COUNT(*) FROM story_event_nodes
                     WHERE story_version_id IN ({','.join('?' for _ in NEW_VERSIONS)}) GROUP BY story_version_id""",
                tuple(NEW_VERSIONS),
            ).fetchall())
        by_version = {}
        for row in rows:
            by_version.setdefault(row["version_id"], []).append(row)
        self.assertEqual(set(by_version), set(NEW_VERSIONS))
        for version_id, sections in by_version.items():
            self.assertGreaterEqual(len(sections), 12, version_id)
            self.assertEqual(nodes[version_id], len(sections), version_id)
            average = sum(len(row["body_zh"]) for row in sections) / len(sections)
            self.assertGreaterEqual(average, 450, version_id)
            anchors = [row["anchor_claim_id"] for row in sections]
            self.assertEqual(len(anchors), len(set(anchors)), version_id)
            for row in sections:
                self.assertGreaterEqual(len(row["body_zh"]), 300, row["id"])
                self.assertGreaterEqual(len(row["body_en"].split()), 90, row["id"])
                self.assertGreater(row["supports"], 0, row["id"])
        self.assertGreaterEqual(sum(len(row["body_zh"]) for row in rows), 100_000)

    def test_reading_time_follows_the_text(self):
        for version_id, story_id in NEW_VERSIONS.items():
            chars = sum(len(section["bodyZh"]) for section in self.versions[version_id]["sections"])
            self.assertEqual(self.stories[story_id]["readingMinutes"], max(1, round(chars / 400)), story_id)

    def test_novel_stays_later_reception_and_epics_follow_their_translations(self):
        with self.connect() as connection:
            layers = connection.execute(
                """SELECT sv.id AS version_id, c.knowledge_layer, e.evidence_type
                     FROM story_sections ss JOIN story_versions sv ON sv.id=ss.story_version_id
                     JOIN claims c ON c.id=ss.anchor_claim_id JOIN evidence e ON e.claim_id=c.id
                    WHERE c.id LIKE 'claim.v0330.%'"""
            ).fetchall()
        for row in layers:
            if row["version_id"].startswith("storyver.chinese.xiyouji"):
                self.assertEqual((row["knowledge_layer"], row["evidence_type"]), ("LATER_RECEPTION", "LATER_LITERATURE"))
            else:
                self.assertEqual((row["knowledge_layer"], row["evidence_type"]), ("MYTHIC_NARRATIVE", "PRIMARY_TEXT"))
        with self.connect() as connection:
            source = connection.execute(
                "SELECT evidence_tier,url,source_type FROM sources WHERE id='source.greek.odyssey_butler.gutenberg'"
            ).fetchone()
        self.assertEqual(tuple(source), (3, "https://www.gutenberg.org/ebooks/1727", "HISTORICAL_TRANSLATION"))

    def test_odyssey_parts_cover_all_twenty_four_books(self):
        with self.connect() as connection:
            locators = [row[0] for row in connection.execute(
                """SELECT e.source_location FROM story_sections ss JOIN evidence e ON e.claim_id=ss.anchor_claim_id
                    WHERE ss.story_version_id IN ('storyver.greek.odyssey_butler_1_12','storyver.greek.odyssey_butler_13_24')"""
            )]
        books = set()
        for locator in locators:
            match = re.fullmatch(r"Book ([IVX]+)(?:–([IVX]+))?", locator)
            self.assertIsNotNone(match, locator)
            first = roman(match.group(1))
            last = roman(match.group(2)) if match.group(2) else first
            books.update(range(first, last + 1))
        self.assertEqual(books, set(range(1, 25)))

    def test_validator_flags_a_gap_in_part_order(self):
        source = sqlite3.connect(DB)
        copy = sqlite3.connect(":memory:")
        copy.row_factory = sqlite3.Row
        source.backup(copy)
        source.close()
        self.assertFalse([item for item in validate_connection(copy) if item.rule_code.startswith("SERIES_")])
        copy.execute("UPDATE story_series_parts SET part_order=9 WHERE series_id='series.greek.odyssey' AND part_order=2")
        codes = {item.rule_code for item in validate_connection(copy)}
        copy.close()
        self.assertIn("SERIES_PART_ORDER", codes)

    def test_deity_cards_open_the_first_series_part_they_appear_in(self):
        for entity_id, version_id in (
            ("deity.hindu.rama", "storyver.hindu.ramayana_griffith_book1"),
            ("deity.hindu.hanuman", "storyver.hindu.ramayana_griffith_book4"),
            ("deity.greek.athena", "storyver.greek.odyssey_butler_1_12"),
            ("deity.chinese.guanyin_xiyouji", "storyver.chinese.xiyouji_ch8_12"),
            ("deity.greek.circe", "storyver.greek.odyssey_butler_1_12"),
        ):
            self.assertEqual(self.cards[entity_id]["primaryVersionId"], version_id, entity_id)
            self.assertEqual(len(self.cards[entity_id]["beats"]), len(self.versions[version_id]["sections"]))
        self.assertGreaterEqual(self.snapshot["meta"]["deityStoryCardStatusCounts"]["STORY_LINKED"], 155)

    def test_feature_registries_record_series_without_new_storage(self):
        with self.connect() as connection:
            explorer = connection.execute(
                "SELECT status,introduced_in FROM explorer_feature_registry WHERE feature_code='story_series'"
            ).fetchone()
            reader = connection.execute(
                "SELECT storage_scope,public_database_writes,personal_data_collection,introduced_in "
                "FROM reader_feature_registry WHERE feature_code='SERIES_CONTINUE'"
            ).fetchone()
        self.assertEqual(tuple(explorer), ("ACTIVE", "v0.33.0"))
        self.assertEqual(tuple(reader), ("LOCAL_ONLY", 0, 0, "v0.33.0"))

    def test_ui_wires_series_shelf_bar_and_next_part(self):
        series = (WEB / "components" / "StorySeries.jsx").read_text(encoding="utf-8")
        library = (WEB / "components" / "StoryLibrary.jsx").read_text(encoding="utf-8")
        reader = (WEB / "components" / "DeityStoryReader.jsx").read_text(encoding="utf-8")
        app = (WEB / "App.jsx").read_text(encoding="utf-8")
        styles = (WEB / "styles.css").read_text(encoding="utf-8")
        storage = (WEB / "readerStorage.js").read_text(encoding="utf-8")
        for name in ("export default function SeriesShelf", "export function SeriesBar", "export function SeriesNext",
                     "export const continuePart"):
            self.assertIn(name, series)
        self.assertNotIn("localStorage", series)
        for tag in ("<SeriesShelf", "<SeriesBar", "<SeriesNext"):
            self.assertIn(tag, library)
        self.assertIn("v0.36", library)
        self.assertIn("storySeries={data.storySeries || []}", app)
        self.assertIn("deity-series-part", reader)
        self.assertIn("wms-reader-v029", storage)
        self.assertIn(".story-series-shelf {", styles)
        self.assertIn(".story-series-shelf, .story-series-steps, .story-series-next { display: none; }", styles)
        tiny = [float(value) for value in re.findall(r"font-size:\s*(0?\.\d+)rem", styles) if float(value) < 0.68]
        self.assertEqual(tiny, [])

    def test_offline_archive_and_markdown_carry_series_navigation(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            manifest = generate(DB, root / "offline", root / "manifest.json")
            html_text = (root / "offline" / HTML_NAME).read_text(encoding="utf-8")
            archive = json.loads((root / "offline" / JSON_NAME).read_text(encoding="utf-8"))
        self.assertEqual(HTML_NAME, "world-mythology-v0.36-story-archive.html")
        self.assertGreaterEqual(manifest["counts"]["storySeries"], 3)
        self.assertEqual([series["id"] for series in archive["storySeries"]][:len(SERIES)], list(SERIES))
        self.assertIn('id="series.chinese.xiyouji"', html_text)
        self.assertIn('class="series-nav"', html_text)
        self.assertIn("继续读下一部", html_text)
        index = (ROOT / "profiles" / "stories" / "series.md").read_text(encoding="utf-8")
        self.assertIn("## 西游记连载 / Journey to the West (series)", index)
        self.assertIn("(story.hindu.ramayana_yuddha.md)", index)
        part = (ROOT / "profiles" / "stories" / "story.chinese.xiyouji_white_bone.md").read_text(encoding="utf-8")
        self.assertIn("> 系列连载：[西游记连载](series.md)", part)
        self.assertIn("跳过的章节", part)
        self.assertIn("继续读下一部：[", part)
        last = (ROOT / "profiles" / "stories" / "story.greek.odyssey_homecoming.md").read_text(encoding="utf-8")
        self.assertIn("到此读完", last)


if __name__ == "__main__":
    unittest.main()
