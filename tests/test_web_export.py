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
        self.assertEqual(counts["registeredEntities"], 453)
        self.assertEqual(counts["canonicalEntities"], 448)
        self.assertEqual(counts["civilizations"], 95)
        self.assertEqual(counts["sources"], 91)
        self.assertEqual(counts["claims"], 159)
        self.assertEqual(counts["directRelationships"], 139)

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

    def test_public_snapshot_has_v040_greek_genealogy(self):
        by_id = {entity["id"]: entity for entity in self.snapshot["entities"]}
        requested = {
            "deity.greek.thanatos", "deity.greek.hypnos", "deity.greek.nyx",
            "deity.greek.hecate", "deity.greek.selene", "deity.greek.helios",
            "deity.greek.hestia",
        }
        self.assertTrue(requested.issubset(by_id))
        helios_family = {
            (relation["type"], relation["targetId"])
            for relation in by_id["deity.greek.helios"]["relationships"]
            if relation["type"] in {"PARENT_OF", "CHILD_OF", "SIBLING_OF", "CONSORT_OF"}
        }
        self.assertIn(("CHILD_OF", "deity.greek.hyperion"), helios_family)
        self.assertIn(("CHILD_OF", "deity.greek.theia"), helios_family)
        self.assertIn(("SIBLING_OF", "deity.greek.selene"), helios_family)
        self.assertTrue(all(relation["evidenceCount"] > 0 for relation in by_id["deity.greek.helios"]["relationships"]))

    def test_public_snapshot_is_deterministic(self):
        with tempfile.TemporaryDirectory() as directory:
            first = Path(directory) / "first.json"
            second = Path(directory) / "second.json"
            write_snapshot(self.snapshot, first)
            write_snapshot(build_snapshot(ROOT / "database" / "world_mythology.sqlite"), second)
            self.assertEqual(first.read_bytes(), second.read_bytes())


if __name__ == "__main__":
    unittest.main()
