import sqlite3
import unittest
from pathlib import Path

from scripts.generate_web_data import build_snapshot

ROOT = Path(__file__).resolve().parents[1]
DATABASE = ROOT / "database" / "world_mythology.sqlite"


class PtahSokarOsirisV0110Tests(unittest.TestCase):
    def connection(self):
        connection = sqlite3.connect(DATABASE)
        connection.row_factory = sqlite3.Row
        return connection

    def test_release_and_migration(self):
        with self.connection() as connection:
            self.assertEqual(connection.execute("SELECT name FROM schema_migrations WHERE version=18").fetchone()[0], "20260824_v0110_ptah_sokar_osiris_objects")
            release = connection.execute("SELECT schema_version,data_version FROM dataset_releases WHERE id='release.0.11.0'").fetchone()
        self.assertEqual((release["schema_version"], release["data_version"]), (18, "0.11.0-ptah-sokar-osiris-objects-20260824"))

    def test_components_remain_separate(self):
        with self.connection() as connection:
            components = {row[0] for row in connection.execute("SELECT object_entity_id FROM claims WHERE subject_id='deity.egyptian.ptah_sokar_osiris' AND predicate='COMPOSITE_EXPRESSION_OF'")}
            redirects = connection.execute("SELECT COUNT(*) FROM entity_redirects WHERE duplicate_entity_id IN ('deity.egyptian.ptah','deity.egyptian.sokar','deity.egyptian.osiris','deity.egyptian.ptah_sokar_osiris')").fetchone()[0]
        self.assertEqual(components, {"deity.egyptian.ptah", "deity.egyptian.sokar", "deity.egyptian.osiris"})
        self.assertEqual(redirects, 0)

    def test_every_claim_has_evidence(self):
        with self.connection() as connection:
            self.assertEqual(connection.execute("SELECT COUNT(*) FROM claims WHERE id LIKE 'claim.v0110.%'").fetchone()[0], 17)
            missing = connection.execute("SELECT c.id FROM claims c LEFT JOIN evidence e ON e.claim_id=c.id WHERE c.id LIKE 'claim.v0110.%' GROUP BY c.id HAVING COUNT(e.id)=0").fetchall()
        self.assertEqual(missing, [])

    def test_object_contents_are_not_generalized(self):
        with self.connection() as connection:
            conflict = connection.execute("SELECT status FROM conflicts WHERE id='conflict.v0110.pso_object_contents_variation'").fetchone()[0]
            solid = connection.execute("SELECT claim_status FROM claims WHERE id='claim.v0110.fig28_solid'").fetchone()[0]
            hypothetical = connection.execute("SELECT claim_status FROM claims WHERE id='claim.v0110.fig34_missing_base'").fetchone()[0]
        self.assertEqual((conflict, solid, hypothetical), ("OPEN", "SUPPORTED", "UNRESOLVED"))

    def test_museum_profiles_have_unique_catalogue_numbers(self):
        with self.connection() as connection:
            profiles = connection.execute("SELECT catalogue_number FROM museum_object_profiles WHERE entity_id LIKE 'museum.met.pso_%'").fetchall()
        self.assertEqual({row[0] for row in profiles}, {"28.3.48", "21.9.1a-c", "21.9.1d", "34.9"})

    def test_queue_advances_and_followups_persist(self):
        with self.connection() as connection:
            self.assertEqual(connection.execute("SELECT status FROM collection_queue WHERE id='queue.v070.egypt.syncretism_expansion'").fetchone()[0], "PARTIAL")
            self.assertEqual(connection.execute("SELECT COUNT(*) FROM collection_queue WHERE id LIKE 'queue.v0110.%'").fetchone()[0], 6)

    def test_public_snapshot(self):
        snapshot = build_snapshot(DATABASE)
        self.assertRegex(snapshot["meta"]["projectVersion"], r"^0\.\d+\.\d+-")
        ids = {entity["id"] for entity in snapshot["entities"]}
        self.assertIn("deity.egyptian.ptah_sokar_osiris", ids)
        self.assertIn("museum.met.pso_contents_21_9_1d", ids)


if __name__ == "__main__":
    unittest.main()
