import json
import sqlite3
import unittest
from pathlib import Path

from scripts.generate_web_data import build_snapshot


ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "database" / "world_mythology.sqlite"


class StoryReadingLibraryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.snapshot = build_snapshot(DB)

    def connect(self):
        connection = sqlite3.connect(DB)
        connection.row_factory = sqlite3.Row
        return connection

    def test_schema_34_and_story_tables_are_persistent(self):
        expected = {
            "stories", "story_versions", "story_sections", "story_claim_links",
            "story_entity_links", "story_conflict_links",
        }
        with self.connect() as connection:
            tables = {row[0] for row in connection.execute("SELECT name FROM sqlite_master WHERE type='table'")}
            migration = connection.execute("SELECT name FROM schema_migrations WHERE version=34").fetchone()
        self.assertTrue(expected <= tables)
        self.assertEqual(migration["name"], "20260829_v0250_story_reading_library")

    def test_first_reading_batch_has_expected_cardinality(self):
        with self.connect() as connection:
            counts = {
                table: connection.execute(f'SELECT COUNT(*) FROM "{table}"').fetchone()[0]
                for table in ("stories", "story_versions", "story_sections", "story_claim_links", "story_entity_links")
            }
        self.assertGreaterEqual(counts["stories"], 21)
        self.assertGreaterEqual(counts["story_versions"], 23)
        self.assertGreaterEqual(counts["story_sections"], 69)
        self.assertGreaterEqual(counts["story_claim_links"], 106)
        self.assertGreaterEqual(counts["story_entity_links"], 103)

    def test_every_version_is_readable_and_source_linked(self):
        with self.connect() as connection:
            rows = connection.execute(
                """SELECT sv.id,COUNT(DISTINCT ss.id) AS sections,
                          COUNT(DISTINCT scl.claim_id) AS claims,COUNT(DISTINCT sel.entity_id) AS entities,
                          COUNT(DISTINCT src.id) AS sources
                   FROM story_versions sv
                   LEFT JOIN story_sections ss ON ss.story_version_id=sv.id
                   LEFT JOIN story_claim_links scl ON scl.story_version_id=sv.id
                   LEFT JOIN story_entity_links sel ON sel.story_version_id=sv.id
                   LEFT JOIN sources src ON src.id=sv.source_id
                   GROUP BY sv.id"""
            ).fetchall()
        self.assertTrue(rows)
        self.assertTrue(all(row["sections"] >= 3 for row in rows))
        self.assertTrue(all(row["claims"] > 0 and row["entities"] > 0 and row["sources"] == 1 for row in rows))

    def test_variant_witnesses_remain_separate(self):
        with self.connect() as connection:
            variants = dict(connection.execute(
                """SELECT story_id,COUNT(*) FROM story_versions
                   WHERE story_id IN ('story.greek.aphrodite_origins','story.norse.ask_embla')
                   GROUP BY story_id"""
            ).fetchall())
            conflict = connection.execute(
                """SELECT conflict_id FROM story_conflict_links
                   WHERE story_id='story.greek.aphrodite_origins'"""
            ).fetchone()[0]
        self.assertEqual(variants["story.greek.aphrodite_origins"], 2)
        self.assertEqual(variants["story.norse.ask_embla"], 2)
        self.assertEqual(conflict, "conflict.greek.aphrodite_parentage_v050")

    def test_public_snapshot_exposes_story_reading_without_quotes(self):
        self.assertGreaterEqual(self.snapshot["meta"]["counts"]["stories"], 21)
        self.assertGreaterEqual(self.snapshot["meta"]["counts"]["storyVersions"], 23)
        self.assertGreaterEqual(self.snapshot["meta"]["counts"]["storySections"], 69)
        self.assertGreaterEqual(len(self.snapshot["stories"]), 21)
        serialized = json.dumps(self.snapshot["stories"], ensure_ascii=False)
        self.assertNotIn("shortQuote", serialized)
        self.assertNotIn("short_quote", serialized)

    def test_entity_and_story_navigation_are_bidirectional(self):
        linked = [entity for entity in self.snapshot["entities"] if entity.get("stories")]
        self.assertGreaterEqual(len(linked), 90)
        app = (ROOT / "web" / "src" / "App.jsx").read_text(encoding="utf-8")
        detail = (ROOT / "web" / "src" / "components" / "EntityDetail.jsx").read_text(encoding="utf-8")
        library = (ROOT / "web" / "src" / "components" / "StoryLibrary.jsx").read_text(encoding="utf-8")
        self.assertIn("<StoryLibrary", app)
        self.assertIn("onOpenStory={selectStory}", app)
        self.assertIn("entity.stories.map", detail)
        self.assertIn("onOpenEntity(entity.id)", library)

    def test_complete_markdown_story_archive_is_generated(self):
        story_root = ROOT / "profiles" / "stories"
        pages = [path for path in story_root.glob("story.*.md") if path.name != "index.md"]
        self.assertGreaterEqual(len(pages), 21)
        index = (story_root / "index.md").read_text(encoding="utf-8")
        self.assertIn("神话故事阅读档案索引", index)
        sample = (story_root / "story.greek.demeter_persephone.md").read_text(encoding="utf-8")
        self.assertIn("本版本连接的 Claims", sample)
        self.assertIn("可持续扩张的阶段性阅读基线", sample)


if __name__ == "__main__":
    unittest.main()
