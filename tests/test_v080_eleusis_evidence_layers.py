import sqlite3
import unittest
from pathlib import Path

from scripts.generate_web_data import build_snapshot


ROOT = Path(__file__).resolve().parents[1]
DATABASE = ROOT / "database" / "world_mythology.sqlite"


class EleusisEvidenceLayersV080Tests(unittest.TestCase):
    def connection(self):
        connection = sqlite3.connect(DATABASE)
        connection.row_factory = sqlite3.Row
        return connection

    def test_release_and_migration_are_recorded(self):
        with self.connection() as connection:
            migration = connection.execute(
                "SELECT name FROM schema_migrations WHERE version=13"
            ).fetchone()
            self.assertEqual(migration["name"], "20260821_v080_eleusis_evidence_layers")
            release = connection.execute(
                "SELECT schema_version,data_version FROM dataset_releases WHERE id='release.0.8.0'"
            ).fetchone()
            self.assertEqual(release["schema_version"], 13)
            self.assertEqual(release["data_version"], "0.8.0-eleusis-evidence-layers-20260821")

    def test_new_entities_keep_archaeology_ritual_text_and_objects_distinct(self):
        expected = {
            "hero.greek.triptolemos": "HERO",
            "ritual.greek.eleusinian_mysteries": "RITUAL",
            "site.greece.eleusis_telesterion": "ARCHAEOLOGICAL_SITE",
            "text.greek.ieleusis97": "INSCRIPTION",
            "museum.nam.great_eleusinian_relief_126": "MUSEUM_OBJECT",
        }
        with self.connection() as connection:
            actual = dict(connection.execute(
                "SELECT id,primary_type FROM entities WHERE id IN (%s)"
                % ",".join("?" for _ in expected), tuple(expected)
            ))
            self.assertEqual(actual, expected)

    def test_every_v080_claim_has_evidence(self):
        with self.connection() as connection:
            self.assertEqual(connection.execute(
                "SELECT COUNT(*) FROM claims WHERE id LIKE 'claim.v080.%'"
            ).fetchone()[0], 25)
            missing = connection.execute(
                "SELECT c.id FROM claims c LEFT JOIN evidence e ON e.claim_id=c.id "
                "WHERE c.id LIKE 'claim.v080.%' GROUP BY c.id HAVING COUNT(e.id)=0"
            ).fetchall()
            self.assertEqual(missing, [])

    def test_secret_content_is_a_recorded_open_evidence_limit(self):
        with self.connection() as connection:
            conflict = connection.execute(
                "SELECT status,conflict_type,resolution_notes FROM conflicts "
                "WHERE id='conflict.v080.eleusinian_secret_content'"
            ).fetchone()
            self.assertEqual(conflict["status"], "OPEN")
            self.assertEqual(conflict["conflict_type"], "EVIDENCE_LIMIT")
            self.assertIn("never fill", conflict["resolution_notes"])

    def test_relief_copy_is_not_merged_with_original(self):
        with self.connection() as connection:
            copy_claim = connection.execute(
                "SELECT object_entity_id,confidence FROM claims "
                "WHERE id='claim.v080.metrelief_copy_relief126'"
            ).fetchone()
            self.assertEqual(copy_claim["object_entity_id"], "museum.nam.great_eleusinian_relief_126")
            self.assertGreaterEqual(copy_claim["confidence"], 0.95)
            redirects = connection.execute(
                "SELECT COUNT(*) FROM entity_redirects WHERE duplicate_entity_id IN "
                "('museum.met.eleusinian_relief_14_130_9','museum.nam.great_eleusinian_relief_126')"
            ).fetchone()[0]
            self.assertEqual(redirects, 0)

    def test_queue_advances_and_preserves_follow_up_branches(self):
        with self.connection() as connection:
            status = connection.execute(
                "SELECT status FROM collection_queue WHERE id='queue.greek.v050.eleusis_layers'"
            ).fetchone()[0]
            self.assertEqual(status, "PARTIAL")
            self.assertEqual(connection.execute(
                "SELECT COUNT(*) FROM collection_queue WHERE id LIKE 'queue.v080.greek.%'"
            ).fetchone()[0], 6)

    def test_public_snapshot_exposes_v080_entities_and_version(self):
        snapshot = build_snapshot(DATABASE)
        self.assertRegex(snapshot["meta"]["projectVersion"], r"^0\.\d+\.\d+-")
        ids = {entity["id"] for entity in snapshot["entities"]}
        self.assertIn("ritual.greek.eleusinian_mysteries", ids)
        self.assertIn("museum.nam.great_eleusinian_relief_126", ids)


if __name__ == "__main__":
    unittest.main()
