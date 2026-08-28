import json
import sqlite3
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "database" / "world_mythology.sqlite"

class DariusArchaeologicalChainTests(unittest.TestCase):
    def connect(self):
        connection = sqlite3.connect(DB)
        connection.row_factory = sqlite3.Row
        return connection

    def test_release_and_migration(self):
        with self.connect() as connection:
            migration = connection.execute("SELECT name FROM schema_migrations WHERE version=23").fetchone()[0]
            release = connection.execute("SELECT data_version FROM dataset_releases WHERE id='release.0.16.0'").fetchone()[0]
        self.assertEqual(migration, "20260827_v0160_darius_archaeological_chain")
        self.assertEqual(release, "0.16.0-darius-archaeological-chain-20260827")

    def test_new_claims_are_evidenced(self):
        with self.connect() as connection:
            row = connection.execute("""SELECT COUNT(*) total, COUNT(DISTINCT e.claim_id) evidenced
                FROM claims c LEFT JOIN evidence e ON e.claim_id=c.id WHERE c.id LIKE 'claim.v0160.%'""").fetchone()
        self.assertEqual(row["total"], 14)
        self.assertEqual(row["evidenced"], row["total"])

    def test_susa_is_not_flattened_to_achaemenid_period(self):
        with self.connect() as connection:
            profile = connection.execute("SELECT date_range,unesco_status FROM place_profiles WHERE entity_id='site.iran.susa'").fetchone()
        self.assertIn("fifth millennium", profile["date_range"])
        self.assertIn("1455", profile["unesco_status"])

    def test_inventory_candidate_remains_authority_gap(self):
        with self.connect() as connection:
            conflict = connection.execute("SELECT status,conflict_type FROM conflicts WHERE id='conflict.v0160.darius_inventory_authority'").fetchone()
            catalogue = connection.execute("SELECT catalogue_number FROM museum_object_profiles WHERE entity_id='museum.iran.darius_susa_statue'").fetchone()[0]
        self.assertEqual((conflict["status"], conflict["conflict_type"]), ("OPEN", "AUTHORITY_GAP"))
        self.assertNotEqual(catalogue, "NMI 4112")

    def test_heliopolis_is_proposed(self):
        with self.connect() as connection:
            claim = connection.execute("SELECT claim_status,assertion_scope,confidence FROM claims WHERE id='claim.v0160.heliopolis_proposed'").fetchone()
            metadata = json.loads(connection.execute("SELECT metadata_json FROM entities WHERE id='site.egypt.heliopolis_atum_precinct'").fetchone()[0])
        self.assertEqual(claim["claim_status"], "INTERPRETIVE")
        self.assertEqual(claim["assertion_scope"], "SCHOLARLY_INTERPRETATION")
        self.assertLess(claim["confidence"], 0.8)
        self.assertEqual(metadata["itinerary_role"], "PROPOSED_DESTINATION_ONLY")

if __name__ == "__main__":
    unittest.main()
