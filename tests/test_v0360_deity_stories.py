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

HYMNS = [
    "story.greek.demeter_persephone",
    "story.greek.hymn_apollo",
    "story.greek.hymn_hermes",
    "story.greek.hymn_aphrodite",
]
NEW_VERSIONS = {
    "storyver.greek.hymn3_apollo_evelyn_white": "story.greek.hymn_apollo",
    "storyver.greek.hymn4_hermes_evelyn_white": "story.greek.hymn_hermes",
    "storyver.greek.hymn5_aphrodite_evelyn_white": "story.greek.hymn_aphrodite",
    "storyver.greek.theogony_titans_children": "story.greek.titans_children",
    "storyver.greek.library_artemis": "story.greek.artemis_library",
    "storyver.greek.library_3_4_3_5_dionysus": "story.greek.dionysus_library",
    "storyver.greek.iliad_butler_ares": "story.greek.ares_iliad",
    "storyver.norse.gylf_4_12_creation_long": "story.norse.ymir_world",
    "storyver.norse.skald_35_sif_long": "story.norse.forging_treasures",
    "storyver.norse.skald_17_hrungnir": "story.norse.thor_hrungnir",
    "storyver.egyptian.bentresh_stela_louvre_c284": "story.egyptian.bentresh_khonsu",
    "storyver.egyptian.dorbiney_two_brothers": "story.egyptian.two_brothers",
    "storyver.egyptian.deir_el_bahari_birth_cycle": "story.egyptian.hatshepsut_divine_birth",
    "storyver.egyptian.shabaka_stone_memphite": "story.egyptian.memphite_theology",
    "storyver.ugaritic.ktu_1_3_1_4_palace": "story.ugaritic.baal_palace",
    "storyver.sumerian.inana_ebih_etcsl": "story.sumerian.inana_ebih",
    "storyver.chinese.lunheng_leixu": "story.chinese.leigong_leixu",
}
# Deities that had only evidence cards in v0.35 and the story their card now opens.
UPGRADED = {
    "deity.greek.leto": "story.greek.hymn_apollo",
    "deity.greek.maia": "story.greek.hymn_hermes",
    "deity.greek.hestia": "story.greek.hymn_aphrodite",
    "deity.greek.artemis": "story.greek.artemis_library",
    "deity.greek.dionysus": "story.greek.dionysus_library",
    "deity.greek.semele": "story.greek.dionysus_library",
    "deity.greek.ares": "story.greek.ares_iliad",
    "deity.greek.erebus": "story.greek.titans_children",
    "deity.greek.aether": "story.greek.titans_children",
    "deity.greek.hemera": "story.greek.titans_children",
    "deity.greek.crius": "story.greek.titans_children",
    "deity.greek.theia": "story.greek.titans_children",
    "deity.greek.hyperion": "story.greek.titans_children",
    "deity.greek.selene": "story.greek.titans_children",
    "deity.greek.eos": "story.greek.titans_children",
    "deity.greek.hypnos": "story.greek.titans_children",
    "deity.greek.thanatos": "story.greek.titans_children",
    "deity.greek.eurybia": "story.greek.titans_children",
    "deity.greek.astraeus": "story.greek.titans_children",
    "deity.greek.pallas_titan": "story.greek.titans_children",
    "deity.greek.perses": "story.greek.titans_children",
    "deity.greek.asteria": "story.greek.titans_children",
    "deity.norse.buri": "story.norse.ymir_world",
    "deity.norse.borr": "story.norse.ymir_world",
    "deity.norse.jord": "story.norse.ymir_world",
    "deity.norse.sif": "story.norse.forging_treasures",
    "deity.norse.ullr": "story.norse.forging_treasures",
    "deity.norse.magni": "story.norse.thor_hrungnir",
    "deity.egyptian.khonsu": "story.egyptian.bentresh_khonsu",
    "deity.egyptian.ra_horakhty": "story.egyptian.two_brothers",
    "deity.egyptian.amun": "story.egyptian.hatshepsut_divine_birth",
    "deity.egyptian.amun_ra": "story.egyptian.hatshepsut_divine_birth",
    "deity.egyptian.ptah": "story.egyptian.memphite_theology",
    "deity.ugaritic.el": "story.ugaritic.baal_palace",
    "deity.ugaritic.asherah": "story.ugaritic.baal_palace",
    "deity.sumerian.an": "story.sumerian.inana_ebih",
    "deity.chinese.leigong": "story.chinese.leigong_leixu",
}
# Deities that keep evidence cards: no located public narrative in which they act was found,
# or (Yorùbá/Ifá) a living-tradition access policy applies.
STILL_CARDS = {
    "deity.egyptian.khepri", "deity.egyptian.atum_ra", "deity.egyptian.atum_horakhty", "deity.egyptian.mut",
    "deity.egyptian.sokar", "deity.egyptian.ptah_sokar_osiris", "deity.norse.thrud", "deity.norse.meili",
    "deity.norse.modi", "deity.ugaritic.dagan", "deity.assyrian.ashur", "deity.slavic.veles",
    "deity.japanese.raijin", "deity.japanese.fujin", "deity.japanese.karaijin", "deity.yoruba.oshun",
    "deity.yoruba.shango", "deity.yoruba.orunmila",
}
NEW_SOURCES = {
    "source.greek.hesiod_hymns_evelyn_white.gutenberg": (3, "https://www.gutenberg.org/ebooks/348", "HISTORICAL_TRANSLATION"),
    "source.greek.iliad_butler.gutenberg": (3, "https://www.gutenberg.org/ebooks/2199", "HISTORICAL_TRANSLATION"),
    "source.egypt.bentresh_stela.tla": (2, "https://thesaurus-linguae-aegyptiae.de/text/4VLZLA44UVGJZN22WIWP774LOQ", "ACADEMIC_EPIGRAPHIC_DATABASE"),
    "source.egypt.dorbiney.bm": (2, "https://www.britishmuseum.org/collection/object/Y_EA10183-2", "MUSEUM_OBJECT_AND_PRIMARY_TEXT"),
    "source.egypt.hatshepsut_birth_cycle.tla": (2, "https://thesaurus-linguae-aegyptiae.de/text/HT6VX6MTDFA23BCFLNEKOTHO2I", "ACADEMIC_EPIGRAPHIC_DATABASE"),
    "source.egypt.shabaka_stone.bm": (2, "https://www.britishmuseum.org/collection/object/Y_EA498", "MUSEUM_OBJECT_AND_PRIMARY_TEXT"),
    "source.sumerian.inana_ebih.etcsl": (2, "https://etcsl.orinst.ox.ac.uk/section1/tr132.htm", "PRIMARY_TEXT_DIGITAL_EDITION"),
}


class DeityStoryUpgradeTests(unittest.TestCase):
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

    def test_schema_53_and_54_seal_v036_as_latest_release(self):
        with self.connect() as connection:
            migrations = dict(connection.execute(
                "SELECT version,name FROM schema_migrations WHERE version IN (53,54)"
            ).fetchall())
            latest = connection.execute(
                "SELECT id,schema_version,data_version FROM dataset_releases ORDER BY built_at DESC,id DESC LIMIT 1"
            ).fetchone()
            batch = connection.execute(
                "SELECT status,version_label FROM story_expansion_batches WHERE id='storybatch.v0360.08'"
            ).fetchone()
            targets = dict(connection.execute(
                "SELECT status,COUNT(*) FROM story_expansion_targets WHERE batch_id='storybatch.v0360.08' GROUP BY status"
            ).fetchall())
            session = connection.execute(
                "SELECT status FROM research_sessions WHERE id='session.20261024.v0360_deity_story_upgrade'"
            ).fetchone()
        self.assertEqual(migrations, {53: "20261024_v0360_deity_story_upgrade", 54: "20261024_v0360_deity_story_upgrade_release"})
        self.assertEqual(dict(latest), {"id": "release.v0.36.0", "schema_version": 54, "data_version": "0.36.0"})
        self.assertEqual(tuple(batch), ("CHECKPOINT_COMPLETE", "0.36.0"))
        self.assertEqual(targets, {"COMPLETED": 17})
        self.assertEqual(session["status"], "COMPLETED")
        meta = self.snapshot["meta"]
        self.assertEqual(meta["projectVersion"], "0.36.0-deity-story-upgrade")
        self.assertEqual(meta["dataVersion"], "0.36.0")
        self.assertEqual(meta["counts"]["storySeries"], 14)
        self.assertEqual(meta["counts"]["storySeriesParts"], 50)

    def test_homeric_hymns_series_reuses_the_demeter_hymn(self):
        series = self.series["series.greek.homeric_hymns"]
        self.assertEqual([part["storyId"] for part in series["parts"]], HYMNS)
        self.assertEqual(series["totalChapters"], 52)
        self.assertTrue(series["selectionNote"])
        self.assertFalse([part for part in series["parts"] if part["gapNote"]])
        for index, story_id in enumerate(HYMNS):
            link = self.stories[story_id]["series"]
            self.assertEqual((link["id"], link["partOrder"], link["partCount"]), ("series.greek.homeric_hymns", index + 1, 4))
            self.assertEqual(link["previousStoryId"], HYMNS[index - 1] if index else None)
            self.assertEqual(link["nextStoryId"], HYMNS[index + 1] if index + 1 < len(HYMNS) else None)
        # Part 1 opens on the v0.32 long version of the Hymn to Demeter.
        self.assertEqual(self.stories[HYMNS[0]]["versions"][0]["id"], "storyver.greek.demeter_hymn2_long")
        standalone = set(NEW_VERSIONS.values()) - set(HYMNS) - {"story.norse.ymir_world", "story.norse.forging_treasures"}
        for story_id in standalone:
            self.assertIsNone(self.stories[story_id]["series"], story_id)

    def test_new_versions_are_long_and_every_section_is_evidenced(self):
        with self.connect() as connection:
            rows = connection.execute(
                f"""SELECT ss.story_version_id AS version_id, ss.id, ss.body_zh, ss.body_en, ss.anchor_claim_id,
                           (SELECT COUNT(*) FROM evidence e WHERE e.claim_id=ss.anchor_claim_id
                              AND e.direction='SUPPORTS') AS supports
                      FROM story_sections ss
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
            # Twelve or more chapters where the witness allows; the short Lunheng chapter and Inana and Ebih give 8 and 10.
            self.assertGreaterEqual(len(sections), 8, version_id)
            self.assertEqual(nodes[version_id], len(sections), version_id)
            average = sum(len(row["body_zh"]) for row in sections) / len(sections)
            self.assertGreaterEqual(average, 320, version_id)
            anchors = [row["anchor_claim_id"] for row in sections]
            self.assertEqual(len(anchors), len(set(anchors)), version_id)
            for row in sections:
                self.assertGreaterEqual(len(row["body_zh"]), 280, row["id"])
                self.assertGreaterEqual(len(row["body_en"].split()), 120, row["id"])
                self.assertGreater(row["supports"], 0, row["id"])
        self.assertEqual(len(rows), 211)
        self.assertGreaterEqual(sum(len(row["body_zh"]) for row in rows), 75_000)
        self.assertEqual(sum(1 for sections in by_version.values() if len(sections) >= 12), 15)

    def test_long_versions_lead_and_outlines_are_kept(self):
        for story_id, long_id in (("story.norse.ymir_world", "storyver.norse.gylf_4_12_creation_long"),
                                  ("story.norse.forging_treasures", "storyver.norse.skald_35_sif_long")):
            versions = [version["id"] for version in self.stories[story_id]["versions"]]
            self.assertEqual(versions[0], long_id, story_id)
            self.assertEqual(len(versions), 2, story_id)
        # The Sif version opens with Ullr from Gylfaginning 31 and follows Skáldskaparmál 35 after that.
        locators = self.locators("storyver.norse.skald_35_sif_long")
        self.assertEqual(locators[0], "Gylfaginning 31")
        self.assertEqual(set(locators[1:]), {"Skáldskaparmál 35"})

    def test_reading_time_follows_the_text(self):
        for version_id, story_id in NEW_VERSIONS.items():
            chars = sum(len(section["bodyZh"]) for section in self.versions[version_id]["sections"])
            self.assertEqual(self.stories[story_id]["readingMinutes"], max(1, round(chars / 400)), story_id)

    def test_witnesses_and_layers(self):
        with self.connect() as connection:
            layers = dict(connection.execute(
                """SELECT c.knowledge_layer || '/' || e.evidence_type, COUNT(*) FROM claims c
                     JOIN evidence e ON e.claim_id=c.id WHERE c.id LIKE 'claim.v0360.%' GROUP BY 1"""
            ).fetchall())
            sources = {row["id"]: tuple(row)[1:] for row in connection.execute(
                f"SELECT id,evidence_tier,url,source_type FROM sources WHERE id IN ({','.join('?' for _ in NEW_SOURCES)})",
                tuple(NEW_SOURCES),
            )}
            statuses = {row[0] for row in connection.execute(
                f"SELECT verification_status FROM sources WHERE id IN ({','.join('?' for _ in NEW_SOURCES)})",
                tuple(NEW_SOURCES),
            )}
        # Greek and Sumerian translations are primary texts, Snorri's Edda medieval, the Egyptian stelae and
        # reliefs inscriptions, and the D'Orbiney papyrus, the Ugaritic tablets and the Lunheng ancient texts.
        self.assertEqual(layers, {"MYTHIC_NARRATIVE/PRIMARY_TEXT": 100, "MYTHIC_NARRATIVE/MEDIEVAL_TEXT": 38,
                                  "MYTHIC_NARRATIVE/INSCRIPTION": 36, "MYTHIC_NARRATIVE/ANCIENT_TEXT": 37})
        self.assertEqual(sources, NEW_SOURCES)
        self.assertEqual(statuses, {"URL_SYNTAX_VALID"})
        note = self.stories["story.egyptian.bentresh_khonsu"]["editorialNote"]
        self.assertIn("不作史实断言", note)
        self.assertIn("不补写", self.stories["story.egyptian.memphite_theology"]["editorialNote"])

    def test_hymn_locators_follow_the_lines(self):
        ends = {"storyver.greek.hymn3_apollo_evelyn_white": (3, 546), "storyver.greek.hymn4_hermes_evelyn_white": (4, 580),
                "storyver.greek.hymn5_aphrodite_evelyn_white": (5, 293)}
        for version_id, (hymn, last) in ends.items():
            spans = []
            for locator in self.locators(version_id):
                match = re.fullmatch(r"Homeric Hymn (\d), lines (\d+)–(\d+)", locator)
                self.assertIsNotNone(match, locator)
                self.assertEqual(int(match.group(1)), hymn, locator)
                spans.append((int(match.group(2)), int(match.group(3))))
            self.assertEqual(spans[0][0], 1, version_id)
            self.assertEqual(spans[-1][1], last, version_id)
            for (_, end), (start, _) in zip(spans, spans[1:]):
                self.assertEqual(start, end + 1, version_id)

    def test_evidence_card_deities_now_open_stories(self):
        for entity_id, story_id in UPGRADED.items():
            card = self.cards[entity_id]
            self.assertEqual(card["status"], "STORY_LINKED", entity_id)
            self.assertEqual(card["primaryStoryId"], story_id, entity_id)
            self.assertEqual(len(card["beats"]), len(self.versions[card["primaryVersionId"]]["sections"]), entity_id)
        remaining = {card["entityId"] for card in self.cards.values() if card["status"] == "CLAIM_CARD"}
        self.assertEqual(remaining, STILL_CARDS)
        self.assertEqual(self.snapshot["meta"]["deityStoryCardStatusCounts"],
                         {"STORY_LINKED": 232, "CLAIM_CARD": 18, "PERMISSION_LIMITED": 2})
        for entity_id in ("deity.egyptian.khnum", "deity.egyptian.heqet", "deity.greek.iris", "deity.greek.eileithyia",
                          "deity.greek.styx", "deity.greek.phoebe", "deity.greek.pontus"):
            self.assertEqual(self.cards[entity_id]["status"], "STORY_LINKED", entity_id)

    def test_signature_stories_stay_on_their_cards(self):
        # New stories anchor these deities no more often than the stories they were known for, so the cards stay put.
        for entity_id, version_id in (
            ("deity.norse.odin", "storyver.norse.baldr_gylf_long"),
            ("deity.greek.hera", "storyver.greek.library_2_4_2_5_heracles_1"),
            ("deity.ugaritic.mot", "storyver.ugaritic.baal_mot_ktu15_16"),
            ("deity.egyptian.horus", "storyver.egyptian.plutarch_ch12_20"),
            ("deity.sumerian.inanna", "storyver.sumerian.inanna_etcsl_long"),
        ):
            self.assertEqual(self.cards[entity_id]["primaryVersionId"], version_id, entity_id)
        # Gods who are the subject of a whole hymn now open it.
        self.assertEqual(self.cards["deity.greek.apollo"]["primaryStoryId"], "story.greek.hymn_apollo")
        self.assertEqual(self.cards["deity.greek.hermes"]["primaryStoryId"], "story.greek.hymn_hermes")
        self.assertEqual(self.cards["deity.greek.aphrodite"]["primaryStoryId"], "story.greek.hymn_aphrodite")

    def test_validator_accepts_the_new_stories(self):
        source = sqlite3.connect(DB)
        copy = sqlite3.connect(":memory:")
        copy.row_factory = sqlite3.Row
        source.backup(copy)
        source.close()
        findings = [item for item in validate_connection(copy)
                    if item.rule_code.startswith("SERIES_") or item.severity in {"BLOCKING", "HIGH"}]
        copy.close()
        self.assertEqual(findings, [])

    def test_offline_archive_markdown_and_ui_carry_v036(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            manifest = generate(DB, root / "offline", root / "manifest.json")
            html_text = (root / "offline" / HTML_NAME).read_text(encoding="utf-8")
            archive = json.loads((root / "offline" / JSON_NAME).read_text(encoding="utf-8"))
        self.assertEqual(HTML_NAME, "world-mythology-v0.36-story-archive.html")
        self.assertEqual(manifest["counts"]["storySeries"], 14)
        self.assertIn("series.greek.homeric_hymns", [series["id"] for series in archive["storySeries"]])
        self.assertIn('id="series.greek.homeric_hymns"', html_text)
        index = (ROOT / "profiles" / "stories" / "series.md").read_text(encoding="utf-8")
        self.assertIn("## 荷马颂歌连载 / The Homeric Hymns (series)", index)
        self.assertIn("(story.greek.hymn_aphrodite.md)", index)
        for story_id in set(NEW_VERSIONS.values()):
            self.assertTrue((ROOT / "profiles" / "stories" / f"{story_id}.md").is_file(), story_id)
        last = (ROOT / "profiles" / "stories" / "story.greek.hymn_aphrodite.md").read_text(encoding="utf-8")
        self.assertIn("到此读完", last)
        library = (WEB / "components" / "StoryLibrary.jsx").read_text(encoding="utf-8")
        tools = (WEB / "components" / "StoryReaderTools.jsx").read_text(encoding="utf-8")
        self.assertIn("eyebrow: 'v0.36", library)
        self.assertIn(HTML_NAME, tools)


if __name__ == "__main__":
    unittest.main()
