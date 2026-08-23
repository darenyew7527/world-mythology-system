import sqlite3
import unittest
from pathlib import Path

from scripts.generate_web_data import build_snapshot


ROOT = Path(__file__).resolve().parents[1]
DATABASE = ROOT / "database" / "world_mythology.sqlite"


class EgyptianSolarCompositesV070Tests(unittest.TestCase):
    def connection(self):
        connection = sqlite3.connect(DATABASE)
        connection.row_factory = sqlite3.Row
        return connection

    def test_release_and_migrations_are_recorded(self):
        with self.connection() as connection:
            migrations = dict(connection.execute(
                "SELECT version,name FROM schema_migrations WHERE version IN (10,11,12)"
            ))
            self.assertEqual(migrations[10], "20260815_v070_egyptian_solar_composites")
            self.assertEqual(migrations[11], "20260815_v070_name_completeness")
            self.assertEqual(migrations[12], "20260815_v070_release_metadata_consistency")
            release = connection.execute(
                "SELECT schema_version,data_version FROM dataset_releases "
                "WHERE id='release.0.7.0'"
            ).fetchone()
            self.assertEqual(release["schema_version"], 12)
            self.assertEqual(release["data_version"], "0.7.0-egyptian-solar-composites-20260815")

    def test_composites_are_distinct_entities_with_component_edges(self):
        with self.connection() as connection:
            entities = {
                row[0] for row in connection.execute(
                    "SELECT id FROM entities WHERE id IN "
                    "('deity.egyptian.amun','deity.egyptian.ra','deity.egyptian.horus',"
                    "'deity.egyptian.amun_ra','deity.egyptian.ra_horakhty')"
                )
            }
            self.assertEqual(len(entities), 5)
            components = {
                (row[0], row[1]) for row in connection.execute(
                    "SELECT subject_id,object_entity_id FROM claims "
                    "WHERE predicate='COMPOSITE_EXPRESSION_OF' AND claim_status='SUPPORTED'"
                )
            }
            self.assertTrue({
                ('deity.egyptian.amun_ra', 'deity.egyptian.amun'),
                ('deity.egyptian.amun_ra', 'deity.egyptian.ra'),
                ('deity.egyptian.ra_horakhty', 'deity.egyptian.ra'),
                ('deity.egyptian.ra_horakhty', 'deity.egyptian.horus'),
            }.issubset(components))
            redirects = connection.execute(
                "SELECT COUNT(*) FROM entity_redirects WHERE duplicate_entity_id IN "
                "('deity.egyptian.amun_ra','deity.egyptian.ra_horakhty')"
            ).fetchone()[0]
            self.assertEqual(redirects, 0)

    def test_every_v070_claim_has_evidence(self):
        with self.connection() as connection:
            missing = connection.execute(
                "SELECT c.id FROM claims c LEFT JOIN evidence e ON e.claim_id=c.id "
                "WHERE c.id LIKE 'claim.v070.%' GROUP BY c.id HAVING COUNT(e.id)=0"
            ).fetchall()
            self.assertEqual(missing, [])
            self.assertEqual(connection.execute(
                "SELECT COUNT(*) FROM claims WHERE id LIKE 'claim.v070.%'"
            ).fetchone()[0], 35)

    def test_spell17_identification_is_witness_scoped(self):
        with self.connection() as connection:
            candidate = connection.execute(
                "SELECT assessment,confidence,notes FROM identity_candidates "
                "WHERE id='identity.v070.khepri_ra_horakhty'"
            ).fetchone()
            self.assertEqual(candidate["assessment"], "IDENTIFIED_IN_SOURCE")
            self.assertIn("witness", candidate["notes"].lower())
            self.assertEqual(connection.execute(
                "SELECT COUNT(*) FROM entity_redirects "
                "WHERE duplicate_entity_id='deity.egyptian.khepri'"
            ).fetchone()[0], 0)

    def test_comparison_and_material_witnesses_are_connected(self):
        with self.connection() as connection:
            members = connection.execute(
                "SELECT COUNT(*) FROM comparison_set_members "
                "WHERE comparison_set_id='comparison.egyptian.solar_composite_forms'"
            ).fetchone()[0]
            self.assertEqual(members, 6)
            objects = connection.execute(
                "SELECT COUNT(*) FROM museum_object_profiles WHERE entity_id LIKE 'museum.%' "
                "AND entity_id IN (SELECT subject_id FROM claims WHERE id LIKE 'claim.v070.%')"
            ).fetchone()[0]
            self.assertEqual(objects, 5)
            self.assertIsNotNone(connection.execute(
                "SELECT 1 FROM museum_object_profiles "
                "WHERE entity_id='museum.met.nauny_book_dead_30_3_31'"
            ).fetchone())

    def test_queue_is_advanced_without_erasing_follow_up_work(self):
        with self.connection() as connection:
            advanced = dict(connection.execute(
                "SELECT id,status FROM collection_queue "
                "WHERE id IN ('queue.egypt.amun_ra','queue.egypt.ra_horakhty')"
            ))
            self.assertEqual(set(advanced.values()), {"PARTIAL"})
            follow_ups = connection.execute(
                "SELECT COUNT(*) FROM collection_queue WHERE id LIKE 'queue.v070.egypt.%'"
            ).fetchone()[0]
            self.assertGreaterEqual(follow_ups, 5)

    def test_public_snapshot_exposes_v070_comparison(self):
        snapshot = build_snapshot(DATABASE)
        self.assertEqual(snapshot["meta"]["projectVersion"], "0.10.0-japanese-thunder-local-dossiers")
        comparison = next(
            item for item in snapshot["comparisons"]
            if item["id"] == "comparison.egyptian.solar_composite_forms"
        )
        self.assertEqual(len(comparison["members"]), 6)
        self.assertTrue(all(member["evidenceCount"] > 0 for member in comparison["members"]))


if __name__ == "__main__":
    unittest.main()
