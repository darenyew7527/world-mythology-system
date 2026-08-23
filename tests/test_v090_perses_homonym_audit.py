import sqlite3
import unittest
from pathlib import Path

from scripts.generate_web_data import build_snapshot


ROOT = Path(__file__).resolve().parents[1]
DATABASE = ROOT / "database" / "world_mythology.sqlite"


class PersesHomonymAuditV090Tests(unittest.TestCase):
    def connection(self):
        connection = sqlite3.connect(DATABASE)
        connection.row_factory = sqlite3.Row
        return connection

    def test_release_and_migration_are_recorded(self):
        with self.connection() as connection:
            migration = connection.execute(
                "SELECT name FROM schema_migrations WHERE version=14"
            ).fetchone()
            self.assertEqual(migration["name"], "20260822_v090_perses_homonym_audit")
            release = connection.execute(
                "SELECT schema_version,data_version FROM dataset_releases WHERE id='release.0.9.0'"
            ).fetchone()
            self.assertEqual(release["schema_version"], 16)
            self.assertEqual(release["data_version"], "0.9.0-perses-homonym-audit-20260822")

    def test_three_perses_entities_remain_distinct(self):
        ids = (
            "deity.greek.perses",
            "deity.greek.perses_helios",
            "hero.greek.perses_perseus_son",
        )
        with self.connection() as connection:
            self.assertEqual(connection.execute(
                "SELECT COUNT(*) FROM entities WHERE id IN (?,?,?)", ids
            ).fetchone()[0], 3)
            self.assertEqual(connection.execute(
                "SELECT COUNT(*) FROM identity_candidates "
                "WHERE id LIKE 'identity.v090.%' AND assessment='EXPLICITLY_DISTINCT'"
            ).fetchone()[0], 3)
            self.assertEqual(connection.execute(
                "SELECT COUNT(*) FROM entity_redirects WHERE duplicate_entity_id IN (?,?,?)", ids
            ).fetchone()[0], 0)

    def test_every_v090_claim_has_evidence(self):
        with self.connection() as connection:
            self.assertEqual(connection.execute(
                "SELECT COUNT(*) FROM claims WHERE id LIKE 'claim.v090.%'"
            ).fetchone()[0], 27)
            missing = connection.execute(
                "SELECT c.id FROM claims c LEFT JOIN evidence e ON e.claim_id=c.id "
                "WHERE c.id LIKE 'claim.v090.%' GROUP BY c.id HAVING COUNT(e.id)=0"
            ).fetchall()
            self.assertEqual(missing, [])

    def test_titan_perses_genealogy_is_source_scoped(self):
        with self.connection() as connection:
            links = {(row["predicate"], row["object_entity_id"]) for row in connection.execute(
                "SELECT predicate,object_entity_id FROM claims "
                "WHERE id LIKE 'claim.v090.%' AND (subject_id='deity.greek.perses' OR object_entity_id='deity.greek.perses')"
            )}
        self.assertIn(("PARENT_OF", "deity.greek.perses"), links)
        self.assertIn(("CONSORT_OF", "deity.greek.asteria"), links)
        self.assertIn(("PARENT_OF", "deity.greek.hecate"), links)

    def test_other_perses_traditions_are_not_attached_to_titan(self):
        with self.connection() as connection:
            solar = {(row["predicate"], row["object_entity_id"]) for row in connection.execute(
                "SELECT predicate,object_entity_id FROM claims "
                "WHERE id LIKE 'claim.v090.%' AND (subject_id='deity.greek.perses_helios' OR object_entity_id='deity.greek.perses_helios')"
            )}
            herodotean = {(row["predicate"], row["object_entity_id"]) for row in connection.execute(
                "SELECT predicate,object_entity_id FROM claims "
                "WHERE id LIKE 'claim.v090.%' AND (subject_id='hero.greek.perses_perseus_son' OR object_entity_id='hero.greek.perses_perseus_son')"
            )}
        self.assertIn(("PARENT_OF", "deity.greek.perses_helios"), solar)
        self.assertIn(("SIBLING_OF", "hero.greek.aeetes"), solar)
        self.assertIn(("PARENT_OF", "hero.greek.perses_perseus_son"), herodotean)

    def test_queue_advances_and_preserves_followups(self):
        with self.connection() as connection:
            self.assertEqual(connection.execute(
                "SELECT status FROM collection_queue WHERE id='queue.greek.v040.perses_identity'"
            ).fetchone()[0], "PARTIAL")
            self.assertEqual(connection.execute(
                "SELECT COUNT(*) FROM collection_queue WHERE id LIKE 'queue.v090.greek.%'"
            ).fetchone()[0], 6)

    def test_public_snapshot_exposes_version_and_entities(self):
        snapshot = build_snapshot(DATABASE)
        self.assertEqual(snapshot["meta"]["projectVersion"], "0.10.0-japanese-thunder-local-dossiers")
        ids = {entity["id"] for entity in snapshot["entities"]}
        self.assertIn("deity.greek.perses_helios", ids)
        self.assertIn("hero.greek.perses_perseus_son", ids)


if __name__ == "__main__":
    unittest.main()
