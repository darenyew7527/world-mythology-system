import sqlite3
import unittest
from pathlib import Path

from scripts.generate_web_data import build_snapshot

ROOT = Path(__file__).resolve().parents[1]
DATABASE = ROOT / "database" / "world_mythology.sqlite"


class DariusStatueInscriptionsV0130Tests(unittest.TestCase):
    def connection(self):
        connection = sqlite3.connect(DATABASE)
        connection.row_factory = sqlite3.Row
        return connection

    def test_release_and_migration(self):
        with self.connection() as connection:
            migration = connection.execute("SELECT name FROM schema_migrations WHERE version=20").fetchone()[0]
            release = connection.execute("SELECT schema_version,data_version FROM dataset_releases WHERE id='release.0.13.0'").fetchone()
        self.assertEqual(migration, "20260826_v0130_darius_statue_inscriptions")
        self.assertEqual((release["schema_version"], release["data_version"]), (20, "0.13.0-darius-statue-inscriptions-20260826"))

    def test_parallel_languages_are_distinct(self):
        with self.connection() as connection:
            rows = connection.execute("SELECT entity_id,original_language_id FROM text_profiles WHERE entity_id LIKE 'text.persia.dsab.%'").fetchall()
            redirects = connection.execute("SELECT COUNT(*) FROM entity_redirects WHERE duplicate_entity_id LIKE 'text.persia.dsab.%'").fetchone()[0]
        self.assertEqual({row["original_language_id"] for row in rows}, {"lang.peo", "lang.elx", "lang.akk"})
        self.assertEqual(redirects, 0)

    def test_hieroglyphic_program_is_not_dsab(self):
        with self.connection() as connection:
            corpus = connection.execute("SELECT metadata_json FROM entities WHERE id='text.egypt.darius_susa_hieroglyphic_program'").fetchone()[0]
            redirects = connection.execute("SELECT COUNT(*) FROM entity_redirects WHERE duplicate_entity_id IN ('text.persia.dsab','text.egypt.darius_susa_hieroglyphic_program')").fetchone()[0]
        self.assertIn('"witness_count":5', corpus)
        self.assertEqual(redirects, 0)

    def test_every_new_claim_has_evidence(self):
        with self.connection() as connection:
            self.assertEqual(connection.execute("SELECT COUNT(*) FROM claims WHERE id LIKE 'claim.v0130.%'").fetchone()[0], 17)
            missing = connection.execute("SELECT c.id FROM claims c LEFT JOIN evidence e ON e.claim_id=c.id WHERE c.id LIKE 'claim.v0130.%' GROUP BY c.id HAVING COUNT(e.id)=0").fetchall()
        self.assertEqual(missing, [])

    def test_origin_evidence_layers_remain_separate(self):
        with self.connection() as connection:
            claim = connection.execute("SELECT assertion_scope,knowledge_layer FROM claims WHERE id='claim.v0130.dsab_made_egypt'").fetchone()
            material = connection.execute("SELECT assertion_scope,knowledge_layer FROM claims WHERE id='claim.v0130.statue_wadi_hammamat'").fetchone()
        self.assertEqual((claim["assertion_scope"], claim["knowledge_layer"]), ("TEXT_SAYS", "TEXTUAL_WITNESS"))
        self.assertEqual((material["assertion_scope"], material["knowledge_layer"]), ("SCHOLARLY_INTERPRETATION", "ARCHAEOLOGICAL"))

    def test_queue_advanced_and_followups_persist(self):
        with self.connection() as connection:
            status = connection.execute("SELECT status FROM collection_queue WHERE id='queue.v0120.egypt.darius_statue_inscriptions'").fetchone()[0]
            count = connection.execute("SELECT COUNT(*) FROM collection_queue WHERE id LIKE 'queue.v0130.%'").fetchone()[0]
        self.assertEqual(status, "BASELINE_COMPLETE")
        self.assertEqual(count, 6)

    def test_public_snapshot(self):
        snapshot = build_snapshot(DATABASE)
        self.assertRegex(snapshot["meta"]["projectVersion"], r"^0\.\d+\.\d+-")
        ids = {entity["id"] for entity in snapshot["entities"]}
        self.assertIn("text.persia.dsab", ids)
        self.assertIn("text.egypt.darius_susa_hieroglyphic_province_list", ids)


if __name__ == "__main__":
    unittest.main()
