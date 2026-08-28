import sqlite3
import unittest
from pathlib import Path

from scripts.generate_web_data import build_snapshot

ROOT = Path(__file__).resolve().parents[1]
DATABASE = ROOT / "database" / "world_mythology.sqlite"


class RaAtumWitnessLayersV0120Tests(unittest.TestCase):
    def connection(self):
        connection = sqlite3.connect(DATABASE)
        connection.row_factory = sqlite3.Row
        return connection

    def test_release_and_migration(self):
        with self.connection() as connection:
            self.assertEqual(connection.execute("SELECT name FROM schema_migrations WHERE version=19").fetchone()[0], "20260825_v0120_ra_atum_witness_layers")
            release = connection.execute("SELECT schema_version,data_version FROM dataset_releases WHERE id='release.0.12.0'").fetchone()
        self.assertEqual((release["schema_version"], release["data_version"]), (19, "0.12.0-ra-atum-witness-layers-20260825"))

    def test_two_composites_and_components_remain_distinct(self):
        with self.connection() as connection:
            atum_ra = {row[0] for row in connection.execute("SELECT object_entity_id FROM claims WHERE subject_id='deity.egyptian.atum_ra' AND predicate='COMPOSITE_EXPRESSION_OF'")}
            atum_horakhty = {row[0] for row in connection.execute("SELECT object_entity_id FROM claims WHERE subject_id='deity.egyptian.atum_horakhty' AND predicate='COMPOSITE_EXPRESSION_OF'")}
            redirects = connection.execute("SELECT COUNT(*) FROM entity_redirects WHERE duplicate_entity_id IN ('deity.egyptian.atum','deity.egyptian.ra','deity.egyptian.atum_ra','deity.egyptian.atum_horakhty')").fetchone()[0]
        self.assertEqual(atum_ra, {"deity.egyptian.atum", "deity.egyptian.ra"})
        self.assertEqual(atum_horakhty, {"deity.egyptian.atum", "deity.egyptian.ra_horakhty"})
        self.assertEqual(redirects, 0)

    def test_every_claim_has_evidence(self):
        with self.connection() as connection:
            self.assertEqual(connection.execute("SELECT COUNT(*) FROM claims WHERE id LIKE 'claim.v0120.%'").fetchone()[0], 19)
            missing = connection.execute("SELECT c.id FROM claims c LEFT JOIN evidence e ON e.claim_id=c.id WHERE c.id LIKE 'claim.v0120.%' GROUP BY c.id HAVING COUNT(e.id)=0").fetchall()
        self.assertEqual(missing, [])

    def test_chapter15_is_variant_group_not_fixed_text(self):
        with self.connection() as connection:
            row = connection.execute("SELECT metadata_json FROM entities WHERE id='text.egypt.book_dead_chapter15'").fetchone()[0]
            claim = connection.execute("SELECT claim_status FROM claims WHERE id='claim.v0120.chapter15_variants'").fetchone()[0]
        self.assertIn("multiple ancient variants", row)
        self.assertEqual(claim, "SUPPORTED")

    def test_context_is_not_depiction(self):
        with self.connection() as connection:
            bad = connection.execute("SELECT COUNT(*) FROM claims WHERE subject_id='museum.iran.darius_susa_statue' AND predicate='DEPICTS' AND object_entity_id IN ('deity.egyptian.atum_ra','deity.egyptian.atum')").fetchone()[0]
            guard = connection.execute("SELECT review_status FROM claims WHERE id='claim.v0120.pakeshi_non_depiction_guard'").fetchone()[0]
        self.assertEqual(bad, 0)
        self.assertEqual(guard, "VERIFIED")

    def test_queue_advances_and_followups_persist(self):
        with self.connection() as connection:
            self.assertEqual(connection.execute("SELECT status FROM collection_queue WHERE id='queue.v0110.egypt.ra_atum_composite'").fetchone()[0], "PARTIAL")
            self.assertEqual(connection.execute("SELECT COUNT(*) FROM collection_queue WHERE id LIKE 'queue.v0120.%'").fetchone()[0], 6)

    def test_public_snapshot(self):
        snapshot = build_snapshot(DATABASE)
        self.assertRegex(snapshot["meta"]["projectVersion"], r"^0\.\d+\.\d+-")
        ids = {entity["id"] for entity in snapshot["entities"]}
        self.assertIn("deity.egyptian.atum_ra", ids)
        self.assertIn("museum.iran.darius_susa_statue", ids)


if __name__ == "__main__":
    unittest.main()
