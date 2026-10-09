import json
import re
import sqlite3
import tempfile
import unittest
from pathlib import Path

from scripts.generate_offline_archive import HTML_NAME, JSON_NAME, generate
from scripts.generate_web_data import build_snapshot
from world_mythology.story_cards import build_deity_story_cards, claim_sentence


ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "database" / "world_mythology.sqlite"
WEB = ROOT / "web" / "src"

V031_STORIES = (
    "story.chinese.fuxi_eight_trigrams", "story.chinese.huangdi_chiyou", "story.chinese.nezha_wukong",
    "story.chinese.pangu_sanwu_liji", "story.egyptian.heavenly_cow", "story.egyptian.heliopolitan_family",
    "story.egyptian.mourning_sisters", "story.egyptian.weighing_heart_ani", "story.hawaiian.pele_journey",
    "story.irish.second_battle_mag_tuired", "story.japanese.izanagi_izanami", "story.maya.divine_images",
    "story.mexica.birth_huitzilopochtli", "story.mexica.quetzalcoatl_tollan", "story.mexica.templo_mayor_twin_shrines",
    "story.norse.frigg_baldr", "story.norse.heimdall_watchman", "story.norse.tyr_fenrir", "story.norse.vanir_family",
    "story.norse.ymir_world", "story.slavic.kyiv_idols", "story.sumerian.enki_ninhursag",
    "story.sumerian.gilgamesh_huwawa_utu", "story.sumerian.nanna_journey", "story.zoroastrian.mihr_yasht",
    "story.zoroastrian.sixteen_lands",
)

# Deities that had no claim at all before v0.31.
PREVIOUSLY_CLAIMLESS = (
    "being.chinese.pangu", "being.norse.ymir", "being.zoroastrian.angra_mainyu", "deity.assyrian.ashur",
    "deity.chinese.fu_xi", "deity.chinese.nezha", "deity.egyptian.anubis", "deity.egyptian.geb",
    "deity.egyptian.hathor", "deity.egyptian.isis", "deity.egyptian.nephthys", "deity.egyptian.nut",
    "deity.egyptian.sekhmet", "deity.egyptian.seth", "deity.egyptian.shu", "deity.egyptian.tefnut",
    "deity.egyptian.thoth", "deity.hawaiian.pele", "deity.hindu.brahma", "deity.irish.bridig",
    "deity.irish.dagda", "deity.irish.lugh", "deity.irish.morrigan", "deity.japanese.izanagi",
    "deity.japanese.izanami", "deity.japanese.tsukuyomi", "deity.maori.papatuanuku", "deity.maori.ranginui",
    "deity.maya.chaac", "deity.maya.itzamna", "deity.maya.kukulkan", "deity.mexica.huitzilopochtli",
    "deity.mexica.quetzalcoatl", "deity.mexica.tezcatlipoca", "deity.mexica.tlaloc", "deity.norse.freyja",
    "deity.norse.freyr", "deity.norse.frigg", "deity.norse.heimdall", "deity.norse.njord", "deity.norse.tyr",
    "deity.polynesian.tane", "deity.polynesian.tangaroa", "deity.slavic.mokosh", "deity.sumerian.an",
    "deity.sumerian.nanna", "deity.sumerian.ninhursag", "deity.sumerian.utu", "deity.ugaritic.asherah",
    "deity.yoruba.oshun", "deity.zoroastrian.mithra", "hero.chinese.yellow_emperor",
)
PERMISSION_LIMITED = {"deity.yoruba.ogun", "deity.yoruba.olodumare"}


class DeityStoriesTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.snapshot = build_snapshot(DB)
        cls.cards = {card["entityId"]: card for card in cls.snapshot["deityStoryCards"]}
        cls.claims = {claim["id"]: claim for claim in cls.snapshot["claims"]}
        cls.sections = {
            section["id"]
            for story in cls.snapshot["stories"]
            for version in story["versions"]
            for section in version["sections"]
        }

    def connect(self):
        connection = sqlite3.connect(DB)
        connection.row_factory = sqlite3.Row
        return connection

    def test_schema_43_and_44_seal_v031_as_latest_release(self):
        with self.connect() as connection:
            migrations = dict(connection.execute(
                "SELECT version,name FROM schema_migrations WHERE version IN (43,44)"
            ).fetchall())
            latest = connection.execute(
                "SELECT id,schema_version,data_version FROM dataset_releases ORDER BY built_at DESC,id DESC LIMIT 1"
            ).fetchone()
            v030 = connection.execute(
                "SELECT schema_version FROM dataset_releases WHERE id='release.v0.30.0'"
            ).fetchone()
            batch = connection.execute(
                "SELECT status,version_label FROM story_expansion_batches WHERE id='storybatch.v0310.03'"
            ).fetchone()
            targets = dict(connection.execute(
                "SELECT status,COUNT(*) FROM story_expansion_targets WHERE batch_id='storybatch.v0310.03' GROUP BY status"
            ).fetchall())
        self.assertEqual(migrations, {43: "20261009_v0310_deity_stories", 44: "20261009_v0310_deity_stories_release"})
        self.assertEqual(dict(latest), {"id": "release.v0.31.0", "schema_version": 44, "data_version": "0.31.0"})
        self.assertEqual(v030["schema_version"], 42)
        self.assertEqual(tuple(batch), ("CHECKPOINT_COMPLETE", "0.31.0"))
        self.assertEqual(targets, {"COMPLETED": 27, "BLOCKED_PERMISSION": 1})
        meta = self.snapshot["meta"]
        self.assertEqual(meta["projectVersion"], "0.31.0-deity-stories")
        self.assertEqual(meta["dataVersion"], "0.31.0")

    def test_every_deity_has_a_story_card(self):
        with self.connect() as connection:
            deities = {row[0] for row in connection.execute("SELECT id FROM deities")}
            redirected = {row[0] for row in connection.execute("SELECT duplicate_entity_id FROM entity_redirects")}
        self.assertEqual(set(self.cards), deities - redirected)
        statuses = {card["status"] for card in self.cards.values()}
        self.assertLessEqual(statuses, {"STORY_LINKED", "CLAIM_CARD", "PERMISSION_LIMITED"})
        self.assertEqual(self.snapshot["meta"]["counts"]["deityStoryCards"], len(self.cards))
        self.assertEqual(
            {entity_id for entity_id, card in self.cards.items() if not card["beats"]},
            PERMISSION_LIMITED,
        )

    def test_card_beats_are_published_sections_or_evidenced_claims(self):
        for card in self.cards.values():
            for beat in card["beats"] + card["facts"]:
                if beat["kind"] == "STORY_SECTION":
                    self.assertIn(beat["sectionId"], self.sections, card["entityId"])
                else:
                    claim = self.claims[beat["claimId"]]
                    supports = [item for item in claim["evidence"] if item["direction"] == "SUPPORTS"]
                    self.assertTrue(supports, beat["claimId"])
                    self.assertTrue(beat["textZh"])
            if card["status"] == "STORY_LINKED":
                self.assertTrue(card["primaryStoryId"])
                self.assertIn(card["primaryStoryId"], card["storyIds"])

    def test_permission_limited_cards_state_the_boundary_without_a_story(self):
        with self.connect() as connection:
            claims = connection.execute(
                "SELECT COUNT(*) FROM claims WHERE subject_id IN ('deity.yoruba.ogun','deity.yoruba.olodumare') "
                "OR object_entity_id IN ('deity.yoruba.ogun','deity.yoruba.olodumare')"
            ).fetchone()[0]
            levels = {
                row[0]: row[1] for row in connection.execute(
                    "SELECT entity_id,access_level FROM tradition_access_policies WHERE id LIKE 'policy.v0310.%'"
                    " AND entity_id IN ('deity.yoruba.ogun','deity.yoruba.olodumare')"
                )
            }
        self.assertEqual(claims, 0)
        self.assertEqual(levels, {entity_id: "PERMISSION_REQUIRED" for entity_id in PERMISSION_LIMITED})
        for entity_id in PERMISSION_LIMITED:
            card = self.cards[entity_id]
            self.assertEqual(card["status"], "PERMISSION_LIMITED")
            self.assertEqual(card["boundary"]["kind"], "ACCESS_POLICY")
            self.assertIn("不发布故事", card["boundary"]["textZh"])

    def test_previously_claimless_deities_now_have_evidenced_claims(self):
        with self.connect() as connection:
            for entity_id in PREVIOUSLY_CLAIMLESS:
                count = connection.execute(
                    """SELECT COUNT(DISTINCT c.id) FROM claims c JOIN evidence e ON e.claim_id=c.id
                       WHERE (c.subject_id=? OR c.object_entity_id=?) AND e.direction='SUPPORTS'""",
                    (entity_id, entity_id),
                ).fetchone()[0]
                self.assertGreater(count, 0, entity_id)

    def test_new_stories_are_sectioned_located_and_mapped(self):
        with self.connect() as connection:
            rows = connection.execute(
                f"""SELECT sv.id,COUNT(DISTINCT ss.id) sections,COUNT(DISTINCT n.id) nodes,
                           COUNT(DISTINCT scl.claim_id) claims,COUNT(DISTINCT sel.entity_id) entities
                    FROM story_versions sv
                    JOIN story_sections ss ON ss.story_version_id=sv.id
                    LEFT JOIN story_event_nodes n ON n.story_version_id=sv.id
                    LEFT JOIN story_claim_links scl ON scl.story_version_id=sv.id
                    LEFT JOIN story_entity_links sel ON sel.story_version_id=sv.id
                    WHERE sv.story_id IN ({','.join('?' for _ in V031_STORIES)})
                    GROUP BY sv.id""",
                V031_STORIES,
            ).fetchall()
            unanchored = connection.execute(
                f"""SELECT ss.id FROM story_sections ss
                    JOIN story_versions sv ON sv.id=ss.story_version_id
                    LEFT JOIN evidence e ON e.claim_id=ss.anchor_claim_id
                    WHERE sv.story_id IN ({','.join('?' for _ in V031_STORIES)}) AND e.id IS NULL""",
                V031_STORIES,
            ).fetchall()
            stories = connection.execute(
                f"SELECT COUNT(*) FROM stories WHERE id IN ({','.join('?' for _ in V031_STORIES)})",
                V031_STORIES,
            ).fetchone()[0]
        self.assertEqual(stories, len(V031_STORIES))
        self.assertEqual(len(rows), 28)
        for row in rows:
            self.assertGreaterEqual(row["sections"], 3, row["id"])
            self.assertEqual(row["sections"], row["nodes"], row["id"])
            self.assertGreater(row["claims"], 0, row["id"])
            self.assertGreater(row["entities"], 0, row["id"])
        self.assertFalse(unanchored)

    def test_layers_and_living_tradition_boundaries_are_kept(self):
        with self.connect() as connection:
            novel_layers = {row[0] for row in connection.execute(
                "SELECT DISTINCT c.knowledge_layer FROM claims c JOIN evidence e ON e.claim_id=c.id "
                "WHERE e.source_id='source.china.xiyouji_ch004.wikisource'"
            )}
            killed = connection.execute(
                "SELECT assertion_scope FROM claims WHERE id='claim.v0310.china.huangdi_kills_chiyou'"
            ).fetchone()[0]
            access = dict(connection.execute(
                "SELECT id,access_level FROM stories WHERE id IN ('story.hawaiian.pele_journey','story.maori.creation_many')"
            ).fetchall())
            maori_version = connection.execute(
                "SELECT story_id,access_level,version_order FROM story_versions WHERE id='storyver.maori.creation_common_threads'"
            ).fetchone()
            oshun = {row[0] for row in connection.execute(
                "SELECT access_level FROM tradition_access_policies WHERE entity_id='deity.yoruba.oshun'"
            )}
            sources = connection.execute(
                "SELECT verification_status,notes FROM sources WHERE accessed_date='2026-10-09'"
            ).fetchall()
        self.assertEqual(novel_layers, {"LATER_RECEPTION"})
        self.assertNotEqual(killed, "HISTORICAL_REALITY")
        self.assertEqual(access, {"story.hawaiian.pele_journey": "ATTRIBUTION_REQUIRED",
                                  "story.maori.creation_many": "ATTRIBUTION_REQUIRED"})
        self.assertEqual(tuple(maori_version), ("story.maori.creation_many", "ATTRIBUTION_REQUIRED", 2))
        self.assertEqual(oshun, {"PUBLIC_CONTEXT", "PERMISSION_REQUIRED"})
        self.assertEqual(len(sources), 21)
        self.assertTrue(all(row["verification_status"] == "URL_SYNTAX_VALID" and row["notes"] for row in sources))

    def test_feature_registries_declare_zero_collection_storyteller(self):
        with self.connect() as connection:
            explorer = dict(connection.execute(
                "SELECT feature_code,status FROM explorer_feature_registry WHERE introduced_in='v0.31.0'"
            ).fetchall())
            reader = connection.execute(
                "SELECT storage_scope,public_database_writes,personal_data_collection FROM reader_feature_registry "
                "WHERE feature_code='STORYTELLER_MODE'"
            ).fetchone()
        self.assertEqual(explorer, {"deity_story_cards": "ACTIVE", "storyteller_mode": "ACTIVE"})
        self.assertEqual(tuple(reader), ("LOCAL_ONLY", 0, 0))

    def test_offline_archive_includes_resolved_deity_cards(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            manifest = generate(DB, root / "offline", root / "manifest.json")
            html_text = (root / "offline" / HTML_NAME).read_text(encoding="utf-8")
            archive = json.loads((root / "offline" / JSON_NAME).read_text(encoding="utf-8"))
        self.assertEqual(HTML_NAME, "world-mythology-v0.31-story-archive.html")
        self.assertEqual(manifest["counts"]["deityStoryCards"], len(self.cards))
        self.assertEqual(len(archive["deityStoryCards"]), len(self.cards))
        tyr = next(card for card in archive["deityStoryCards"] if card["entityId"] == "deity.norse.tyr")
        self.assertTrue(all(beat["textZh"] and beat["textEn"] for beat in tyr["beats"]))
        self.assertIn("神祇故事卡", html_text)
        self.assertIn('class="deity-card"', html_text)
        self.assertNotIn("<script src=", html_text)
        serialized = json.dumps(archive, ensure_ascii=False) + json.dumps(self.snapshot, ensure_ascii=False)
        self.assertNotIn("shortQuote", serialized)
        self.assertNotIn("short_quote", serialized)

    def test_markdown_story_collection_is_readable_on_github(self):
        from scripts.generate_offline_archive import write_deity_story_markdown
        from world_mythology.story_cards import resolve_card

        sections = {
            section["id"]: dict(section, sourceTitle=(version.get("source") or {}).get("title"),
                                sourceLocation=version.get("sourceLocation"))
            for story in self.snapshot["stories"]
            for version in story["versions"]
            for section in version["sections"]
        }
        cards = [resolve_card(card, sections, self.claims) for card in self.snapshot["deityStoryCards"]]
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            write_deity_story_markdown(cards, root)
            index = (root / "index.md").read_text(encoding="utf-8")
            irish = (root / "irish.md").read_text(encoding="utf-8")
            yoruba = (root / "yoruba.md").read_text(encoding="utf-8")
        self.assertIn("(irish.md)", index)
        self.assertIn("萨温节前后，达格达在乌恩辛河边", irish)
        self.assertIn("Gray 本 §84", irish)
        self.assertIn("不发布故事", yoruba)
        committed = ROOT / "profiles" / "stories" / "deities"
        self.assertTrue((committed / "index.md").is_file())
        self.assertIn("deities/index.md", (ROOT / "README.md").read_text(encoding="utf-8"))

    def test_card_builder_never_invents_a_story(self):
        entities = [
            {"id": "deity.test.a", "canonicalName": "A", "nameZh": "甲", "primaryType": "DEITY", "types": ["DEITY"],
             "claims": [], "stories": [], "description": None},
            {"id": "deity.test.b", "canonicalName": "B", "nameZh": "乙", "primaryType": "DEITY", "types": ["DEITY"],
             "stories": [], "description": "乙神 / Deity B",
             "claims": [
                 {"id": "c1", "subjectId": "deity.test.b", "predicate": "CHILD_OF", "objectEntityId": "deity.test.a",
                  "objectLiteral": None, "statement": "B is A's child.", "reviewStatus": "VERIFIED",
                  "evidence": [{"direction": "SUPPORTS", "sourceId": "s1"}]},
                 {"id": "c2", "subjectId": "deity.test.b", "predicate": "DOMAIN", "objectEntityId": None,
                  "objectLiteral": "rain", "statement": "Unsupported.", "reviewStatus": "VERIFIED", "evidence": []},
             ]},
        ]
        policies = [{"id": "p1", "entityId": "deity.test.a", "accessLevel": "PERMISSION_REQUIRED",
                     "permittedScope": "Name only.", "prohibitedScope": "Narratives.", "authorityName": "Community"}]
        cards = {card["entityId"]: card for card in build_deity_story_cards(entities, [], policies, {})}
        self.assertEqual(cards["deity.test.a"]["status"], "PERMISSION_LIMITED")
        self.assertEqual(cards["deity.test.a"]["beats"], [])
        self.assertEqual(cards["deity.test.b"]["status"], "CLAIM_CARD")
        self.assertEqual([beat["claimId"] for beat in cards["deity.test.b"]["beats"]], ["c1"])
        self.assertEqual(cards["deity.test.b"]["hookZh"], "乙神")
        lookup = {entity["id"]: entity for entity in entities}
        self.assertEqual(claim_sentence(entities[1]["claims"][0], lookup, {}), "乙是甲的孩子。")

    def test_ui_wires_gallery_storyteller_and_readable_type(self):
        app = (WEB / "App.jsx").read_text(encoding="utf-8")
        header = (WEB / "components" / "Header.jsx").read_text(encoding="utf-8")
        teller = (WEB / "components" / "StorytellerMode.jsx").read_text(encoding="utf-8")
        gallery = (WEB / "components" / "DeityGallery.jsx").read_text(encoding="utf-8")
        detail = (WEB / "components" / "EntityDetail.jsx").read_text(encoding="utf-8")
        library = (WEB / "components" / "StoryLibrary.jsx").read_text(encoding="utf-8")
        storage = (WEB / "readerStorage.js").read_text(encoding="utf-8")
        styles = (WEB / "styles.css").read_text(encoding="utf-8")
        self.assertIn("'deities'", app)
        self.assertIn("<DeityGallery", app)
        self.assertIn("<StorytellerMode", app)
        self.assertIn("'deities'", header)
        self.assertIn('role="dialog"', teller)
        self.assertIn('aria-modal="true"', teller)
        for key in ("Escape", "ArrowRight", "ArrowLeft"):
            self.assertIn(key, teller)
        self.assertIn("aria-live", teller)
        self.assertIn("deckFromCard", gallery)
        self.assertIn("<DeityStoryReader", detail)
        self.assertIn("<DeityStoryReader", gallery)
        self.assertIn("storyOfTheDay", gallery)
        # The reader comes before the audit and route panels so a story is readable on open.
        self.assertLess(library.index('className="story-layout"'), library.index('className="story-expansion-audit"'))
        self.assertLess(library.index('className="story-layout"'), library.index('className="story-route-strip"'))
        self.assertIn("story-tell-button", library)
        self.assertIn("wms-reader-v029", storage)
        self.assertIn("saveTellerSettings", storage)
        self.assertIn(".teller {", styles)
        self.assertIn("prefers-reduced-motion", styles)
        tiny = [
            float(value) for value in re.findall(r"font-size:\s*(0?\.\d+)rem", styles)
            if float(value) < 0.68
        ]
        self.assertEqual(tiny, [])


if __name__ == "__main__":
    unittest.main()
