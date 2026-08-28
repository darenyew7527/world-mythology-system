import json
import sqlite3
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "database" / "world_mythology.sqlite"


class DariusStatueProvenanceTests(unittest.TestCase):
    def connect(self):
        connection = sqlite3.connect(DB)
        connection.row_factory = sqlite3.Row
        return connection

    def test_release_and_migration(self):
        with self.connect() as connection:
            migration = connection.execute(
                "SELECT name FROM schema_migrations WHERE version=21"
            ).fetchone()[0]
            release = connection.execute(
                "SELECT schema_version,data_version FROM dataset_releases WHERE id='release.0.14.0'"
            ).fetchone()
        self.assertEqual(migration, "20260827_v0140_darius_statue_provenance")
        self.assertEqual(
            (release["schema_version"], release["data_version"]),
            (21, "0.14.0-darius-statue-provenance-20260827"),
        )

    def test_new_entities_are_named_and_distinct(self):
        ids = [
            "historical.achaemenid.xerxes_i",
            "site.iran.susa",
            "site.iran.susa_darius_gate",
            "event.persia.darius_statue_transfer_egypt_susa",
            "event.archaeology.darius_statue_discovery_1972",
            "institution.iran.national_museum",
        ]
        with self.connect() as connection:
            entities = connection.execute(
                f"SELECT COUNT(*) FROM entities WHERE id IN ({','.join('?' for _ in ids)})", ids
            ).fetchone()[0]
            names = connection.execute(
                f"SELECT COUNT(DISTINCT entity_id) FROM names WHERE entity_id IN ({','.join('?' for _ in ids)})", ids
            ).fetchone()[0]
        self.assertEqual(entities, 6)
        self.assertEqual(names, 6)

    def test_claims_have_evidence(self):
        with self.connect() as connection:
            claims = connection.execute(
                "SELECT COUNT(*) FROM claims WHERE id LIKE 'claim.v0140.%'"
            ).fetchone()[0]
            evidenced = connection.execute(
                """SELECT COUNT(DISTINCT c.id) FROM claims c
                   JOIN evidence e ON e.claim_id=c.id
                   WHERE c.id LIKE 'claim.v0140.%'"""
            ).fetchone()[0]
        self.assertEqual(claims, 16)
        self.assertEqual(evidenced, claims)

    def test_transfer_is_qualified_reconstruction(self):
        with self.connect() as connection:
            entity = connection.execute(
                "SELECT metadata_json FROM entities WHERE id='event.persia.darius_statue_transfer_egypt_susa'"
            ).fetchone()
            claim = connection.execute(
                "SELECT assertion_scope,knowledge_layer,confidence FROM claims WHERE id='claim.v0140.transfer_xerxes'"
            ).fetchone()
        self.assertEqual(json.loads(entity["metadata_json"])["reality_status"], "HISTORICAL_RECONSTRUCTION")
        self.assertEqual(claim["assertion_scope"], "SCHOLARLY_INTERPRETATION")
        self.assertEqual(claim["knowledge_layer"], "SCHOLARLY_INTERPRETATION")
        self.assertLess(claim["confidence"], 1.0)

    def test_second_statue_is_not_materialized(self):
        with self.connect() as connection:
            phantom = connection.execute(
                "SELECT COUNT(*) FROM entities WHERE id LIKE '%second%darius%statue%'"
            ).fetchone()[0]
            conflict = connection.execute(
                "SELECT status FROM conflicts WHERE id='conflict.v0140.statue_pair_reconstruction'"
            ).fetchone()[0]
        self.assertEqual(phantom, 0)
        self.assertEqual(conflict, "OPEN")

    def test_inventory_gap_is_explicit(self):
        with self.connect() as connection:
            profile = connection.execute(
                "SELECT catalogue_number,acquisition_notes FROM museum_object_profiles WHERE entity_id='museum.iran.darius_susa_statue'"
            ).fetchone()
            queue = connection.execute(
                "SELECT status FROM collection_queue WHERE id='queue.v0140.iran.darius_statue_inventory'"
            ).fetchone()[0]
        self.assertEqual(profile["catalogue_number"], "Susa Darius statue")
        self.assertIn("exact inventory number remains queued", profile["acquisition_notes"])
        self.assertIn(queue, {"NEEDS_REVIEW", "PARTIAL", "BASELINE_COMPLETE"})


if __name__ == "__main__":
    unittest.main()
