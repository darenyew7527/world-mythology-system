import json
import tempfile
import unittest
from pathlib import Path

from scripts.generate_web_data import build_snapshot, write_snapshot


ROOT = Path(__file__).resolve().parents[1]


class PublicWebExportTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.snapshot = build_snapshot(ROOT / "database" / "world_mythology.sqlite")

    def test_public_snapshot_preserves_core_counts(self):
        counts = self.snapshot["meta"]["counts"]
        self.assertEqual(counts["registeredEntities"], 430)
        self.assertEqual(counts["canonicalEntities"], 425)
        self.assertEqual(counts["civilizations"], 95)
        self.assertEqual(counts["sources"], 87)
        self.assertEqual(counts["claims"], 109)
        self.assertEqual(counts["directRelationships"], 94)

    def test_public_snapshot_excludes_evidence_quotes(self):
        serialized = json.dumps(self.snapshot, ensure_ascii=False)
        self.assertNotIn("short_quote", serialized)
        self.assertNotIn("shortQuote", serialized)

    def test_public_snapshot_has_searchable_zeus_network(self):
        zeus = next(entity for entity in self.snapshot["entities"] if entity["id"] == "deity.greek.zeus")
        targets = {relation["targetId"] for relation in zeus["relationships"]}
        self.assertIn("deity.greek.cronus", targets)
        self.assertIn("deity.greek.rhea", targets)
        self.assertIn("weapon.greek.zeus_thunderbolt", targets)
        self.assertTrue(any(claim["evidence"] for claim in zeus["claims"]))

    def test_public_snapshot_is_deterministic(self):
        with tempfile.TemporaryDirectory() as directory:
            first = Path(directory) / "first.json"
            second = Path(directory) / "second.json"
            write_snapshot(self.snapshot, first)
            write_snapshot(build_snapshot(ROOT / "database" / "world_mythology.sqlite"), second)
            self.assertEqual(first.read_bytes(), second.read_bytes())


if __name__ == "__main__":
    unittest.main()
