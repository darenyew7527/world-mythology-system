import sqlite3
import unittest
from pathlib import Path

from scripts.generate_web_data import build_snapshot


ROOT = Path(__file__).resolve().parents[1]
DATABASE = ROOT / "database" / "world_mythology.sqlite"


class JapaneseThunderLocalDossiersV0100Tests(unittest.TestCase):
    def connection(self):
        connection = sqlite3.connect(DATABASE)
        connection.row_factory = sqlite3.Row
        return connection

    def test_release_and_migration_are_recorded(self):
        with self.connection() as connection:
            migration = connection.execute(
                "SELECT name FROM schema_migrations WHERE version=17"
            ).fetchone()
            self.assertEqual(migration["name"], "20260823_v0100_japanese_thunder_local_dossiers")
            release = connection.execute(
                "SELECT schema_version,data_version FROM dataset_releases WHERE id='release.0.10.0'"
            ).fetchone()
            self.assertEqual(release["schema_version"], 17)
            self.assertEqual(release["data_version"], "0.10.0-japanese-thunder-local-dossiers-20260823")

    def test_local_deity_site_ritual_and_visual_layers_are_distinct(self):
        expected = {
            "deity.japanese.kamo_wakeikazuchi": "DEITY",
            "site.japan.kamigamo_jinja": "ARCHAEOLOGICAL_SITE",
            "festival.japan.kamo_aoi": "FESTIVAL",
            "ritual.japan.kamo_kurabeuma": "RITUAL",
            "museum.japan.sotatsu_wind_thunder_screens": "MUSEUM_OBJECT",
        }
        with self.connection() as connection:
            actual = dict(connection.execute(
                "SELECT id,primary_type FROM entities WHERE id IN (%s)"
                % ",".join("?" for _ in expected), tuple(expected)
            ))
        self.assertEqual(actual, expected)

    def test_every_v0100_claim_has_evidence(self):
        with self.connection() as connection:
            self.assertEqual(connection.execute(
                "SELECT COUNT(*) FROM claims WHERE id LIKE 'claim.v0100.%'"
            ).fetchone()[0], 16)
            missing = connection.execute(
                "SELECT c.id FROM claims c LEFT JOIN evidence e ON e.claim_id=c.id "
                "WHERE c.id LIKE 'claim.v0100.%' GROUP BY c.id HAVING COUNT(e.id)=0"
            ).fetchall()
        self.assertEqual(missing, [])

    def test_honoikazuchi_homonym_is_not_merged(self):
        with self.connection() as connection:
            identity = connection.execute(
                "SELECT assessment FROM identity_candidates "
                "WHERE id='identity.v0100.hono_otokuni_vs_kojiki'"
            ).fetchone()[0]
            redirects = connection.execute(
                "SELECT COUNT(*) FROM entity_redirects WHERE duplicate_entity_id IN "
                "('deity.japanese.honoikazuchi_otokuni','deity.japanese.honoikazuchi')"
            ).fetchone()[0]
            conflict = connection.execute(
                "SELECT status FROM conflicts WHERE id='conflict.v0100.honoikazuchi_identity'"
            ).fetchone()[0]
        self.assertEqual(identity, "DISPUTED_IDENTITY")
        self.assertEqual(redirects, 0)
        self.assertEqual(conflict, "OPEN")

    def test_screen_is_later_visual_evidence_only(self):
        with self.connection() as connection:
            rows = connection.execute(
                "SELECT predicate,object_entity_id,knowledge_layer FROM claims "
                "WHERE subject_id='museum.japan.sotatsu_wind_thunder_screens'"
            ).fetchall()
        links = {(row["predicate"], row["object_entity_id"]): row["knowledge_layer"] for row in rows}
        self.assertEqual(links[("DEPICTS", "deity.japanese.raijin")], "LATER_RECEPTION")
        self.assertEqual(links[("DEPICTS", "deity.japanese.fujin")], "LATER_RECEPTION")

    def test_queue_advances_and_followups_persist(self):
        with self.connection() as connection:
            self.assertEqual(connection.execute(
                "SELECT status FROM collection_queue WHERE id='queue.v060.japanese.raijin_regional'"
            ).fetchone()[0], "PARTIAL")
            self.assertEqual(connection.execute(
                "SELECT COUNT(*) FROM collection_queue WHERE id LIKE 'queue.v0100.%'"
            ).fetchone()[0], 6)

    def test_public_snapshot_exposes_version_and_local_dossiers(self):
        snapshot = build_snapshot(DATABASE)
        self.assertRegex(snapshot["meta"]["projectVersion"], r"^0\.\d+\.\d+-")
        ids = {entity["id"] for entity in snapshot["entities"]}
        self.assertIn("deity.japanese.kamo_wakeikazuchi", ids)
        self.assertIn("museum.japan.sotatsu_wind_thunder_screens", ids)


if __name__ == "__main__":
    unittest.main()
