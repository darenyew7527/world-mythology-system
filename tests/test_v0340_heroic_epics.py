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
    "series.greek.heroes_library": [
        "story.greek.perseus_library",
        "story.greek.heracles_birth_labours",
        "story.greek.heracles_far_labours",
        "story.greek.heracles_death_apotheosis",
    ],
    "series.greek.argonautica": [
        "story.greek.argonautica_outward",
        "story.greek.argonautica_fleece_return",
    ],
    "series.norse.gylfaginning_end": [
        "story.norse.frigg_baldr",
        "story.norse.ragnarok",
    ],
    "series.norse.volsunga": [
        "story.norse.volsunga_sigmund",
        "story.norse.volsunga_sigurd_dragon",
        "story.norse.volsunga_sigurd_brynhild",
    ],
    "series.irish.tain": [
        "story.irish.tain_muster_boy_deeds",
        "story.irish.tain_ferdiad_bulls",
    ],
    "series.welsh.mabinogi": [
        "story.welsh.mabinogi_pwyll",
        "story.welsh.mabinogi_branwen",
        "story.welsh.mabinogi_manawydan",
        "story.welsh.mabinogi_math",
    ],
}
SERIES_CHAPTERS = {
    "series.greek.heroes_library": 49,
    "series.greek.argonautica": 26,
    "series.norse.gylfaginning_end": 25,
    "series.norse.volsunga": 36,
    "series.irish.tain": 25,
    "series.welsh.mabinogi": 48,
}
NEW_VERSIONS = {
    "storyver.greek.library_2_4_perseus": "story.greek.perseus_library",
    "storyver.greek.library_2_4_2_5_heracles_1": "story.greek.heracles_birth_labours",
    "storyver.greek.library_2_5_heracles_2": "story.greek.heracles_far_labours",
    "storyver.greek.library_2_6_2_8_heracles_3": "story.greek.heracles_death_apotheosis",
    "storyver.greek.argonautica_seaton_1_2": "story.greek.argonautica_outward",
    "storyver.greek.argonautica_seaton_3_4": "story.greek.argonautica_fleece_return",
    "storyver.norse.ragnarok_gylf_long": "story.norse.ragnarok",
    "storyver.norse.volsunga_morris_1_12": "story.norse.volsunga_sigmund",
    "storyver.norse.volsunga_morris_13_24": "story.norse.volsunga_sigurd_dragon",
    "storyver.norse.volsunga_morris_25_32": "story.norse.volsunga_sigurd_brynhild",
    "storyver.irish.tain_dunn_1": "story.irish.tain_muster_boy_deeds",
    "storyver.irish.tain_dunn_2": "story.irish.tain_ferdiad_bulls",
    "storyver.welsh.mabinogi_guest_branch1": "story.welsh.mabinogi_pwyll",
    "storyver.welsh.mabinogi_guest_branch2": "story.welsh.mabinogi_branwen",
    "storyver.welsh.mabinogi_guest_branch3": "story.welsh.mabinogi_manawydan",
    "storyver.welsh.mabinogi_guest_branch4": "story.welsh.mabinogi_math",
}
NEW_SOURCES = {
    "source.greek.argonautica_seaton.gutenberg": "https://www.gutenberg.org/ebooks/830",
    "source.norse.volsunga_morris.gutenberg": "https://www.gutenberg.org/ebooks/1152",
    "source.irish.tain_dunn.gutenberg": "https://www.gutenberg.org/ebooks/16464",
    "source.welsh.mabinogion_guest.gutenberg": "https://www.gutenberg.org/ebooks/5160",
}
ROMAN = {"I": 1, "II": 2, "III": 3, "IV": 4}


class HeroicEpicsTests(unittest.TestCase):
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

    def locators(self, version_id):
        with self.connect() as connection:
            return [row[0] for row in connection.execute(
                """SELECT e.source_location FROM story_sections ss JOIN evidence e ON e.claim_id=ss.anchor_claim_id
                    WHERE ss.story_version_id=? ORDER BY ss.section_order""",
                (version_id,),
            )]

    def test_schema_49_and_50_seal_v034_as_latest_release(self):
        with self.connect() as connection:
            migrations = dict(connection.execute(
                "SELECT version,name FROM schema_migrations WHERE version IN (49,50)"
            ).fetchall())
            latest = connection.execute(
                "SELECT id,schema_version,data_version FROM dataset_releases ORDER BY built_at DESC,id DESC LIMIT 1"
            ).fetchone()
            batch = connection.execute(
                "SELECT status,version_label FROM story_expansion_batches WHERE id='storybatch.v0340.06'"
            ).fetchone()
            targets = dict(connection.execute(
                "SELECT status,COUNT(*) FROM story_expansion_targets WHERE batch_id='storybatch.v0340.06' GROUP BY status"
            ).fetchall())
            session = connection.execute(
                "SELECT status FROM research_sessions WHERE id='session.20261024.v0340_heroic_epics'"
            ).fetchone()
        self.assertEqual(migrations, {49: "20261024_v0340_heroic_epics", 50: "20261024_v0340_heroic_epics_release"})
        self.assertEqual(dict(latest), {"id": "release.v0.34.0", "schema_version": 50, "data_version": "0.34.0"})
        self.assertEqual(tuple(batch), ("CHECKPOINT_COMPLETE", "0.34.0"))
        self.assertEqual(targets, {"COMPLETED": 16})
        self.assertEqual(session["status"], "COMPLETED")
        meta = self.snapshot["meta"]
        self.assertEqual(meta["projectVersion"], "0.34.0-heroic-epics")
        self.assertEqual(meta["dataVersion"], "0.34.0")
        self.assertEqual(meta["counts"]["storySeries"], 9)
        self.assertEqual(meta["counts"]["storySeriesParts"], 31)

    def test_six_new_series_are_ordered_linked_and_name_their_gap(self):
        for series_id, story_ids in SERIES.items():
            series = self.series[series_id]
            self.assertEqual([part["storyId"] for part in series["parts"]], story_ids)
            self.assertEqual([part["order"] for part in series["parts"]], list(range(1, len(story_ids) + 1)))
            self.assertEqual(series["totalChapters"], SERIES_CHAPTERS[series_id], series_id)
            self.assertTrue(series["selectionNote"])
            self.assertTrue(all(part["sourceSpan"] for part in series["parts"]), series_id)
            civilizations = {self.stories[story_id]["civilizationId"] for story_id in story_ids}
            self.assertEqual(len(civilizations), 1, series_id)
            for index, story_id in enumerate(story_ids):
                link = self.stories[story_id]["series"]
                self.assertEqual((link["id"], link["partOrder"], link["partCount"]), (series_id, index + 1, len(story_ids)))
                self.assertEqual(link["previousStoryId"], story_ids[index - 1] if index else None)
                self.assertEqual(link["nextStoryId"], story_ids[index + 1] if index + 1 < len(story_ids) else None)
        # The only passage the new series leave out is Library 2.7.4, and it is named, not filled in.
        gaps = {part["storyId"]: part["gapNote"] for series_id in SERIES
                for part in self.series[series_id]["parts"] if part["gapNote"]}
        self.assertEqual(set(gaps), {"story.greek.heracles_death_apotheosis"})
        self.assertIn("2.7.4", gaps["story.greek.heracles_death_apotheosis"])
        self.assertNotIn("2.7.4", " ".join(self.locators("storyver.greek.library_2_6_2_8_heracles_3")))

    def test_new_versions_are_long_and_every_section_is_evidenced(self):
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
            # The Library and the sagas are terse; chapters stay close to what the witness says.
            average = sum(len(row["body_zh"]) for row in sections) / len(sections)
            self.assertGreaterEqual(average, 320, version_id)
            anchors = [row["anchor_claim_id"] for row in sections]
            self.assertEqual(len(anchors), len(set(anchors)), version_id)
            for row in sections:
                self.assertGreaterEqual(len(row["body_zh"]), 280, row["id"])
                self.assertGreaterEqual(len(row["body_en"].split()), 100, row["id"])
                self.assertGreater(row["supports"], 0, row["id"])
        self.assertEqual(len(rows), 196)
        self.assertGreaterEqual(sum(len(row["body_zh"]) for row in rows), 75_000)

    def test_reading_time_follows_the_text(self):
        for version_id, story_id in NEW_VERSIONS.items():
            chars = sum(len(section["bodyZh"]) for section in self.versions[version_id]["sections"])
            self.assertEqual(self.stories[story_id]["readingMinutes"], max(1, round(chars / 400)), story_id)

    def test_epics_follow_public_domain_translations(self):
        with self.connect() as connection:
            layers = dict(connection.execute(
                """SELECT c.knowledge_layer || '/' || e.evidence_type, COUNT(*) FROM claims c
                     JOIN evidence e ON e.claim_id=c.id WHERE c.id LIKE 'claim.v0340.%' GROUP BY 1"""
            ).fetchall())
            sources = {row["id"]: row for row in connection.execute(
                f"SELECT id,evidence_tier,url,source_type FROM sources WHERE id IN ({','.join('?' for _ in NEW_SOURCES)})",
                tuple(NEW_SOURCES),
            )}
            language = connection.execute("SELECT iso_639_3 FROM languages WHERE id='lang.wlm'").fetchone()
            texts = dict(connection.execute(
                """SELECT entity_id,earliest_extant_witness FROM text_profiles WHERE entity_id IN
                   ('text.norse.volsunga_saga','text.irish.tain_bo_cuailnge','text.welsh.four_branches')"""
            ).fetchall())
        self.assertEqual(layers, {"MYTHIC_NARRATIVE/PRIMARY_TEXT": 196})
        self.assertEqual(set(sources), set(NEW_SOURCES))
        for source_id, url in NEW_SOURCES.items():
            self.assertEqual(tuple(sources[source_id])[1:], (3, url, "HISTORICAL_TRANSLATION"), source_id)
        self.assertEqual(language[0], "wlm")
        self.assertIn("NKS 1824 b 4to", texts["text.norse.volsunga_saga"])
        self.assertIn("Peniarth", texts["text.welsh.four_branches"])

    def test_ragnarok_long_version_leads_and_outline_is_kept(self):
        story = self.stories["story.norse.ragnarok"]
        self.assertEqual([version["id"] for version in story["versions"]],
                         ["storyver.norse.ragnarok_gylf_long", "storyver.norse.ragnarok_gylf"])
        self.assertEqual(story["titleZh"], "诸神黄昏：世界的毁灭与重生")
        self.assertEqual(len(self.versions["storyver.norse.ragnarok_gylf"]["sections"]), 3)
        locators = self.locators("storyver.norse.ragnarok_gylf_long")
        self.assertEqual((locators[0], locators[-1]), ("Gylfaginning 51", "Gylfaginning 53–54"))

    def test_parts_follow_their_witness_in_order(self):
        # Argonautica: Books I–II, then III–IV.
        for version_id, books in (("storyver.greek.argonautica_seaton_1_2", {1, 2}),
                                  ("storyver.greek.argonautica_seaton_3_4", {3, 4})):
            cited = [ROMAN[re.match(r"Book ([IV]+),", locator).group(1)] for locator in self.locators(version_id)]
            self.assertEqual(set(cited), books, version_id)
            self.assertEqual(cited, sorted(cited), version_id)
        # Völsunga saga: chapters 1–32 without a hole, in order.
        chapters, starts = set(), []
        for version_id in ("storyver.norse.volsunga_morris_1_12", "storyver.norse.volsunga_morris_13_24",
                           "storyver.norse.volsunga_morris_25_32"):
            for locator in self.locators(version_id):
                match = re.fullmatch(r"Völsunga saga ch\. (\d+)(?:–(\d+))?", locator)
                self.assertIsNotNone(match, locator)
                first, last = int(match.group(1)), int(match.group(2) or match.group(1))
                starts.append(first)
                chapters.update(range(first, last + 1))
        self.assertEqual(chapters, set(range(1, 33)))
        self.assertEqual(starts, sorted(starts))
        # Library Book II: Perseus and Heracles read forward from 2.4.1 to 2.8.1.
        positions = []
        for version_id in ("storyver.greek.library_2_4_perseus", "storyver.greek.library_2_4_2_5_heracles_1",
                           "storyver.greek.library_2_5_heracles_2", "storyver.greek.library_2_6_2_8_heracles_3"):
            for locator in self.locators(version_id):
                match = re.fullmatch(r"Library 2\.(\d+)\.(\d+)(?:–2\.(\d+)\.(\d+))?", locator)
                self.assertIsNotNone(match, locator)
                positions.append((int(match.group(1)), int(match.group(2))))
        self.assertEqual(positions[0], (4, 1))
        self.assertEqual(positions, sorted(positions))
        self.assertTrue(self.locators("storyver.greek.library_2_6_2_8_heracles_3")[-1].endswith("2.8.1"))

    def test_validator_accepts_the_new_series(self):
        source = sqlite3.connect(DB)
        copy = sqlite3.connect(":memory:")
        copy.row_factory = sqlite3.Row
        source.backup(copy)
        source.close()
        findings = [item for item in validate_connection(copy) if item.rule_code.startswith("SERIES_")]
        copy.close()
        self.assertEqual(findings, [])

    def test_deity_cards_open_the_new_epics(self):
        for entity_id, version_id in (
            ("deity.greek.hera", "storyver.greek.library_2_4_2_5_heracles_1"),
            ("hero.greek.heracles", "storyver.greek.library_2_4_2_5_heracles_1"),
            ("deity.greek.apollo", "storyver.greek.library_2_6_2_8_heracles_3"),
            ("deity.greek.atlas", "storyver.greek.library_2_5_heracles_2"),
            ("deity.greek.hebe", "storyver.greek.library_2_6_2_8_heracles_3"),
            ("deity.greek.eros", "storyver.greek.argonautica_seaton_3_4"),
            ("deity.norse.vidar", "storyver.norse.ragnarok_gylf_long"),
            ("deity.norse.odin", "storyver.norse.baldr_gylf_long"),
            ("deity.welsh.arawn", "storyver.welsh.mabinogi_guest_branch1"),
        ):
            self.assertEqual(self.cards[entity_id]["primaryVersionId"], version_id, entity_id)
            self.assertEqual(len(self.cards[entity_id]["beats"]), len(self.versions[version_id]["sections"]))
        self.assertEqual(self.snapshot["meta"]["deityStoryCardStatusCounts"],
                         {"STORY_LINKED": 163, "CLAIM_CARD": 56, "PERMISSION_LIMITED": 2})

    def test_ui_labels_skipped_chapters_generically(self):
        series = (WEB / "components" / "StorySeries.jsx").read_text(encoding="utf-8")
        library = (WEB / "components" / "StoryLibrary.jsx").read_text(encoding="utf-8")
        tools = (WEB / "components" / "StoryReaderTools.jsx").read_text(encoding="utf-8")
        storage = (WEB / "readerStorage.js").read_text(encoding="utf-8")
        styles = (WEB / "styles.css").read_text(encoding="utf-8")
        self.assertIn("skipped: '跳过的章节'", series)
        self.assertNotIn("跳过的回目", series)
        # Nine series stay one swipeable row; only the series being read is unfolded.
        self.assertIn("open={unfold && item.id === currentSeriesId}", series)
        self.assertIn("data-current={item.id === currentSeriesId ? 'true' : undefined}", series)
        self.assertNotIn("localStorage", series)
        self.assertIn("grid-auto-flow: column; grid-auto-columns: minmax(320px, calc((100% - 24px) / 3))", styles)
        self.assertIn("v0.34 · 英雄史诗连载与长篇阅读", library)
        self.assertIn("world-mythology-v0.34-story-archive.html", tools)
        self.assertIn("wms-reader-v029", storage)

    def test_offline_archive_and_markdown_carry_the_new_series(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            manifest = generate(DB, root / "offline", root / "manifest.json")
            html_text = (root / "offline" / HTML_NAME).read_text(encoding="utf-8")
            archive = json.loads((root / "offline" / JSON_NAME).read_text(encoding="utf-8"))
        self.assertEqual(HTML_NAME, "world-mythology-v0.34-story-archive.html")
        self.assertEqual(manifest["counts"]["storySeries"], 9)
        self.assertEqual([series["id"] for series in archive["storySeries"]][3:], list(SERIES))
        for series_id in SERIES:
            self.assertIn(f'id="{series_id}"', html_text)
        index = (ROOT / "profiles" / "stories" / "series.md").read_text(encoding="utf-8")
        self.assertIn("## 马比诺吉昂四支连载 / The Four Branches of the Mabinogi (series)", index)
        self.assertIn("(story.irish.tain_ferdiad_bulls.md)", index)
        self.assertIn("2.7.4", index)
        first = (ROOT / "profiles" / "stories" / "story.greek.perseus_library.md").read_text(encoding="utf-8")
        self.assertIn("> 系列连载：[希腊英雄连载](series.md)", first)
        self.assertIn("继续读下一部：[", first)
        gap = (ROOT / "profiles" / "stories" / "story.greek.heracles_death_apotheosis.md").read_text(encoding="utf-8")
        self.assertIn("> 跳过的章节：本部略去《书库》2.7.4", gap)
        last = (ROOT / "profiles" / "stories" / "story.welsh.mabinogi_math.md").read_text(encoding="utf-8")
        self.assertIn("到此读完", last)


if __name__ == "__main__":
    unittest.main()
