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

SERIES = {
    "series.japanese.kojiki": [
        "story.japanese.izanagi_izanami",
        "story.japanese.iwato_orochi",
        "story.japanese.okuninushi",
        "story.japanese.ninigi_sea_palace",
        "story.japanese.yamato_takeru",
    ],
    "series.finnish.kalevala": [
        "story.finnish.kalevala_sampo_forging",
        "story.finnish.kalevala_lemminkainen",
        "story.finnish.kalevala_kullervo",
        "story.finnish.kalevala_sampo_theft",
    ],
    "series.hindu.mahabharata_tales": [
        "story.hindu.nala_damayanti",
        "story.hindu.savitri_satyavan",
        "story.hindu.kurukshetra_war",
    ],
    "series.persian.shahnameh_rostam": [
        "story.persian.zal_rudabeh_rostam",
        "story.persian.rostam_seven_labours",
        "story.persian.rostam_sohrab",
    ],
}
SERIES_CHAPTERS = {
    "series.japanese.kojiki": 65,
    "series.finnish.kalevala": 48,
    "series.hindu.mahabharata_tales": 39,
    "series.persian.shahnameh_rostam": 36,
}
GAPS = {
    "story.japanese.yamato_takeru",
    "story.finnish.kalevala_kullervo",
    "story.finnish.kalevala_sampo_theft",
    "story.hindu.savitri_satyavan",
    "story.hindu.kurukshetra_war",
    "story.persian.rostam_seven_labours",
}
NEW_VERSIONS = {
    "storyver.japanese.kojiki_sect1_10": "story.japanese.izanagi_izanami",
    "storyver.japanese.kojiki_sect20_32": "story.japanese.okuninushi",
    "storyver.japanese.kojiki_sect33_43": "story.japanese.ninigi_sea_palace",
    "storyver.japanese.kojiki_sect79_90": "story.japanese.yamato_takeru",
    "storyver.finnish.kalevala_crawford_1_10": "story.finnish.kalevala_sampo_forging",
    "storyver.finnish.kalevala_crawford_11_15": "story.finnish.kalevala_lemminkainen",
    "storyver.finnish.kalevala_crawford_31_36": "story.finnish.kalevala_kullervo",
    "storyver.finnish.kalevala_crawford_39_43": "story.finnish.kalevala_sampo_theft",
    "storyver.hindu.mahabharata_ganguli_nala": "story.hindu.nala_damayanti",
    "storyver.hindu.mahabharata_ganguli_savitri": "story.hindu.savitri_satyavan",
    "storyver.hindu.mahabharata_ganguli_kurukshetra": "story.hindu.kurukshetra_war",
    "storyver.persian.zimmern_zal_rostam": "story.persian.zal_rudabeh_rostam",
    "storyver.persian.zimmern_mazinderan": "story.persian.rostam_seven_labours",
    "storyver.persian.zimmern_rustem_sohrab": "story.persian.rostam_sohrab",
    "storyver.chinese.soushenji_selected_13": "story.chinese.soushenji_tales",
}
NEW_SOURCES = {
    "source.finnish.kalevala_crawford.gutenberg": (3, "https://www.gutenberg.org/ebooks/5186", "HISTORICAL_TRANSLATION"),
    "source.indian.mahabharata_ganguli.sacredtexts": (3, "https://sacred-texts.com/hin/maha/index.htm", "HISTORICAL_TRANSLATION"),
    "source.persian.epic_of_kings_zimmern": (4, "https://classics.mit.edu/Ferdowsi/kings.html", "HISTORICAL_PROSE_RETELLING"),
    "source.china.soushenji.gutenberg": (4, "https://www.gutenberg.org/ebooks/25362", "PRIMARY_TEXT_DIGITAL_EDITION"),
}
ROMAN = {"I": 1, "V": 5, "X": 10, "L": 50, "C": 100}


def roman(value):
    total = 0
    for index, char in enumerate(value):
        number = ROMAN[char]
        total += -number if index + 1 < len(value) and ROMAN[value[index + 1]] > number else number
    return total


class WorldEpicsTests(unittest.TestCase):
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

    def test_schema_51_and_52_seal_v035_preserved_after_v036(self):
        with self.connect() as connection:
            migrations = dict(connection.execute(
                "SELECT version,name FROM schema_migrations WHERE version IN (51,52)"
            ).fetchall())
            latest = connection.execute(
                "SELECT id,schema_version,data_version FROM dataset_releases ORDER BY built_at DESC,id DESC LIMIT 1"
            ).fetchone()
            sealed = connection.execute(
                "SELECT id,schema_version,data_version FROM dataset_releases WHERE id='release.v0.35.0'"
            ).fetchone()
            batch = connection.execute(
                "SELECT status,version_label FROM story_expansion_batches WHERE id='storybatch.v0350.07'"
            ).fetchone()
            targets = dict(connection.execute(
                "SELECT status,COUNT(*) FROM story_expansion_targets WHERE batch_id='storybatch.v0350.07' GROUP BY status"
            ).fetchall())
            session = connection.execute(
                "SELECT status FROM research_sessions WHERE id='session.20261024.v0350_world_epics'"
            ).fetchone()
            languages = dict(connection.execute(
                "SELECT id,iso_639_3 FROM languages WHERE id IN ('lang.fin','lang.fas')"
            ).fetchall())
        self.assertEqual(migrations, {51: "20261024_v0350_world_epics", 52: "20261024_v0350_world_epics_release"})
        self.assertEqual(dict(sealed), {"id": "release.v0.35.0", "schema_version": 52, "data_version": "0.35.0"})
        self.assertEqual(dict(latest), {"id": "release.v0.36.0", "schema_version": 54, "data_version": "0.36.0"})
        self.assertEqual(tuple(batch), ("CHECKPOINT_COMPLETE", "0.35.0"))
        self.assertEqual(targets, {"COMPLETED": 15})
        self.assertEqual(session["status"], "COMPLETED")
        self.assertEqual(languages, {"lang.fin": "fin", "lang.fas": "fas"})
        meta = self.snapshot["meta"]
        self.assertEqual(meta["projectVersion"], "0.36.0-deity-story-upgrade")
        self.assertEqual(meta["dataVersion"], "0.36.0")
        # v0.36 adds the Homeric Hymns series; the v0.35 series stay as sealed.
        self.assertGreaterEqual(meta["counts"]["storySeries"], 13)
        self.assertGreaterEqual(meta["counts"]["storySeriesParts"], 46)

    def test_four_new_series_are_ordered_linked_and_name_their_gaps(self):
        for series_id, story_ids in SERIES.items():
            series = self.series[series_id]
            self.assertEqual([part["storyId"] for part in series["parts"]], story_ids)
            self.assertEqual([part["order"] for part in series["parts"]], list(range(1, len(story_ids) + 1)))
            self.assertEqual(series["totalChapters"], SERIES_CHAPTERS[series_id], series_id)
            self.assertTrue(series["selectionNote"])
            civilizations = {self.stories[story_id]["civilizationId"] for story_id in story_ids}
            self.assertEqual(len(civilizations), 1, series_id)
            for index, story_id in enumerate(story_ids):
                link = self.stories[story_id]["series"]
                self.assertEqual((link["id"], link["partOrder"], link["partCount"]), (series_id, index + 1, len(story_ids)))
                self.assertEqual(link["previousStoryId"], story_ids[index - 1] if index else None)
                self.assertEqual(link["nextStoryId"], story_ids[index + 1] if index + 1 < len(story_ids) else None)
        gaps = {part["storyId"] for series_id in SERIES for part in self.series[series_id]["parts"] if part["gapNote"]}
        self.assertEqual(gaps, GAPS)
        # The Soushen ji reading is a standalone anthology, not a series part.
        self.assertIsNone(self.stories["story.chinese.soushenji_tales"]["series"])

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
            average = sum(len(row["body_zh"]) for row in sections) / len(sections)
            self.assertGreaterEqual(average, 320, version_id)
            anchors = [row["anchor_claim_id"] for row in sections]
            self.assertEqual(len(anchors), len(set(anchors)), version_id)
            for row in sections:
                self.assertGreaterEqual(len(row["body_zh"]), 280, row["id"])
                self.assertGreaterEqual(len(row["body_en"].split()), 120, row["id"])
                self.assertGreater(row["supports"], 0, row["id"])
        self.assertEqual(len(rows), 186)
        self.assertGreaterEqual(sum(len(row["body_zh"]) for row in rows), 60_000)

    def test_reading_time_follows_the_text(self):
        for version_id, story_id in NEW_VERSIONS.items():
            chars = sum(len(section["bodyZh"]) for section in self.versions[version_id]["sections"])
            self.assertEqual(self.stories[story_id]["readingMinutes"], max(1, round(chars / 400)), story_id)

    def test_witnesses_and_layers(self):
        with self.connect() as connection:
            layers = dict(connection.execute(
                """SELECT c.knowledge_layer || '/' || e.evidence_type, COUNT(*) FROM claims c
                     JOIN evidence e ON e.claim_id=c.id WHERE c.id LIKE 'claim.v0350.%' GROUP BY 1"""
            ).fetchall())
            sources = {row["id"]: tuple(row)[1:] for row in connection.execute(
                f"SELECT id,evidence_tier,url,source_type FROM sources WHERE id IN ({','.join('?' for _ in NEW_SOURCES)})",
                tuple(NEW_SOURCES),
            )}
            perspective = connection.execute(
                "SELECT source_perspective FROM sources WHERE id='source.persian.epic_of_kings_zimmern'"
            ).fetchone()[0]
        # The Shahnameh and the Soushen ji are medieval texts; the Kojiki, Kalevala and Mahabharata parts cite primary translations.
        self.assertEqual(layers, {"MYTHIC_NARRATIVE/PRIMARY_TEXT": 137, "MYTHIC_NARRATIVE/MEDIEVAL_TEXT": 49})
        self.assertEqual(sources, NEW_SOURCES)
        self.assertIn("not a full translation", perspective)
        for story_id in SERIES["series.persian.shahnameh_rostam"]:
            self.assertIn("完整译本", self.stories[story_id]["editorialNote"] or "", story_id)

    def test_kojiki_locators_follow_chamberlain_pages(self):
        sections = []
        for story_id in SERIES["series.japanese.kojiki"]:
            if story_id == "story.japanese.iwato_orochi":
                continue  # sealed in v0.32
            version_id = next(v for v, s in NEW_VERSIONS.items() if s == story_id)
            for locator in self.locators(version_id):
                match = re.match(r"Sect\. ([IVXLC]+)(?:–([IVXLC]+))?.*\(kj(\d{3})(?:–kj(\d{3}))?\)$", locator)
                self.assertIsNotNone(match, locator)
                first = roman(match.group(1))
                # Sacred-texts numbers Chamberlain's sections seven pages on: Sect. XXI is kj028.
                self.assertEqual(int(match.group(3)), first + 7, locator)
                sections.append(first)
        self.assertEqual(sections, sorted(sections))
        self.assertEqual((sections[0], sections[-1]), (1, 89))

    def test_kalevala_runes_follow_the_poem(self):
        runes = {}
        for story_id in SERIES["series.finnish.kalevala"]:
            version_id = next(v for v, s in NEW_VERSIONS.items() if s == story_id)
            cited = set()
            for locator in self.locators(version_id):
                match = re.fullmatch(r"Rune ([IVXL]+)(?:–([IVXL]+))?", locator)
                self.assertIsNotNone(match, locator)
                first = roman(match.group(1))
                cited.update(range(first, roman(match.group(2) or match.group(1)) + 1))
            runes[story_id] = cited
        self.assertEqual(runes["story.finnish.kalevala_sampo_forging"], set(range(1, 11)))
        self.assertEqual(runes["story.finnish.kalevala_lemminkainen"], set(range(11, 16)))
        self.assertEqual(runes["story.finnish.kalevala_kullervo"], set(range(31, 37)))
        self.assertEqual(runes["story.finnish.kalevala_sampo_theft"], set(range(39, 44)))

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
            ("deity.japanese.izanagi", "storyver.japanese.kojiki_sect1_10"),
            ("deity.japanese.amaterasu", "storyver.japanese.kojiki_sect11_19"),
            ("deity.japanese.okuninushi", "storyver.japanese.kojiki_sect20_32"),
            ("deity.japanese.takemikazuchi", "storyver.japanese.kojiki_sect20_32"),
            ("deity.japanese.ninigi", "storyver.japanese.kojiki_sect33_43"),
            ("deity.finnish.ilmatar", "storyver.finnish.kalevala_crawford_1_10"),
            ("deity.hindu.yama", "storyver.hindu.mahabharata_ganguli_savitri"),
            ("deity.hindu.krishna", "storyver.hindu.mahabharata_ganguli_kurukshetra"),
            ("deity.chinese.change", "storyver.chinese.soushenji_selected_13"),
        ):
            self.assertEqual(self.cards[entity_id]["primaryVersionId"], version_id, entity_id)
            self.assertEqual(len(self.cards[entity_id]["beats"]), len(self.versions[version_id]["sections"]))
        counts = self.snapshot["meta"]["deityStoryCardStatusCounts"]
        # v0.36 upgrades evidence cards to stories, so these are bounds rather than exact v0.35 counts.
        self.assertGreaterEqual(counts["STORY_LINKED"], 188)
        self.assertLessEqual(counts["CLAIM_CARD"], 55)
        self.assertEqual(counts["PERMISSION_LIMITED"], 2)

    def test_offline_archive_and_markdown_carry_the_new_series(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            manifest = generate(DB, root / "offline", root / "manifest.json")
            html_text = (root / "offline" / HTML_NAME).read_text(encoding="utf-8")
            archive = json.loads((root / "offline" / JSON_NAME).read_text(encoding="utf-8"))
        self.assertIn("story-archive.html", HTML_NAME)
        self.assertGreaterEqual(manifest["counts"]["storySeries"], 13)
        self.assertEqual([series["id"] for series in archive["storySeries"]][9:13], list(SERIES))
        for series_id in SERIES:
            self.assertIn(f'id="{series_id}"', html_text)
        index = (ROOT / "profiles" / "stories" / "series.md").read_text(encoding="utf-8")
        self.assertIn("## 古事记连载 / The Kojiki (series)", index)
        self.assertIn("(story.persian.rostam_sohrab.md)", index)
        part = (ROOT / "profiles" / "stories" / "story.japanese.yamato_takeru.md").read_text(encoding="utf-8")
        self.assertIn("> 跳过的章节：与上一部之间跳过第四十四至七十八节", part)
        last = (ROOT / "profiles" / "stories" / "story.finnish.kalevala_sampo_theft.md").read_text(encoding="utf-8")
        self.assertIn("到此读完", last)
        tales = (ROOT / "profiles" / "stories" / "story.chinese.soushenji_tales.md").read_text(encoding="utf-8")
        self.assertNotIn("> 系列连载", tales)


if __name__ == "__main__":
    unittest.main()
