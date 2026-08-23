import json
import sqlite3
import unittest
from pathlib import Path

from scripts.generate_web_data import build_snapshot


ROOT = Path(__file__).resolve().parents[1]
DATABASE = ROOT / "database" / "world_mythology.sqlite"


class ThunderComparisonV060Tests(unittest.TestCase):
    def connection(self):
        connection = sqlite3.connect(DATABASE)
        connection.row_factory = sqlite3.Row
        return connection

    def test_release_and_migration_are_recorded(self):
        with self.connection() as connection:
            migration = connection.execute(
                "SELECT name FROM schema_migrations WHERE version=9"
            ).fetchone()
            self.assertEqual(migration["name"], "20260814_v060_thunder_comparison")
            release = connection.execute(
                "SELECT schema_version,data_version,release_notes "
                "FROM dataset_releases WHERE id='release.0.6.0'"
            ).fetchone()
            self.assertIsNotNone(release)
            self.assertEqual(release["schema_version"], 9)
            self.assertEqual(release["data_version"], "0.6.0-thunder-comparison-20260814")
            self.assertIn("Thor", release["release_notes"])

    def test_every_comparison_member_has_located_evidence(self):
        with self.connection() as connection:
            members = connection.execute(
                """SELECT m.entity_id,m.claim_id,COUNT(ev.id) AS evidence_count
                   FROM comparison_set_members m
                   JOIN claims c ON c.id=m.claim_id
                   JOIN evidence ev ON ev.claim_id=c.id
                   WHERE m.comparison_set_id='comparison.thunder_storm_deities'
                   GROUP BY m.entity_id,m.claim_id"""
            ).fetchall()
            self.assertEqual(len(members), 10)
            self.assertTrue(all(row["evidence_count"] > 0 for row in members))

    def test_comparison_does_not_assert_cross_cultural_identity(self):
        with self.connection() as connection:
            member_ids = {
                row[0] for row in connection.execute(
                    "SELECT entity_id FROM comparison_set_members "
                    "WHERE comparison_set_id='comparison.thunder_storm_deities'"
                )
            }
            placeholders = ",".join("?" for _ in member_ids)
            count = connection.execute(
                f"""SELECT COUNT(*) FROM claims
                    WHERE predicate='IDENTIFIED_WITH'
                      AND subject_id IN ({placeholders})
                      AND object_entity_id IN ({placeholders})""",
                tuple(member_ids) + tuple(member_ids),
            ).fetchone()[0]
            self.assertEqual(count, 0)

    def test_thor_old_norse_genealogy_and_loki_boundary(self):
        with self.connection() as connection:
            family = {
                (row["predicate"], row["object_entity_id"])
                for row in connection.execute(
                    """SELECT predicate,object_entity_id FROM claims
                       WHERE subject_id='deity.norse.thor'
                         AND predicate IN ('CHILD_OF','PARENT_OF','SIBLING_OF','CONSORT_OF','STEP_PARENT_OF')
                         AND claim_status='SUPPORTED'"""
                )
            }
            self.assertTrue({
                ("CHILD_OF", "deity.norse.odin"),
                ("CHILD_OF", "deity.norse.jord"),
                ("CONSORT_OF", "deity.norse.sif"),
                ("PARENT_OF", "deity.norse.magni"),
                ("PARENT_OF", "deity.norse.modi"),
                ("PARENT_OF", "deity.norse.thrud"),
                ("SIBLING_OF", "deity.norse.meili"),
                ("STEP_PARENT_OF", "deity.norse.ullr"),
            }.issubset(family))
            self.assertNotIn(("SIBLING_OF", "deity.norse.loki"), family)
            self.assertNotIn(("SIBLING_OF", "deity.norse.hel"), family)

    def test_marvel_kinship_is_confined_to_modern_adaptation_entities(self):
        with self.connection() as connection:
            modern = {
                (row["subject_id"], row["object_entity_id"], row["knowledge_layer"])
                for row in connection.execute(
                    """SELECT subject_id,object_entity_id,knowledge_layer FROM claims
                       WHERE id IN ('claim.v060.modern.thor_sibling_loki',
                                    'claim.v060.modern.thor_sibling_hela')"""
                )
            }
            self.assertEqual(modern, {
                ("modern.marvel.mcu.thor", "modern.marvel.mcu.loki", "POPULAR_CULTURE"),
                ("modern.marvel.mcu.thor", "modern.marvel.mcu.hela", "POPULAR_CULTURE"),
            })
            entity_types = {
                row["id"]: row["primary_type"]
                for row in connection.execute(
                    "SELECT id,primary_type FROM entities WHERE id LIKE 'modern.marvel.mcu.%'"
                )
            }
            self.assertTrue(entity_types)
            self.assertEqual(set(entity_types.values()), {"MODERN_WORK"})
            self.assertEqual(
                connection.execute(
                    "SELECT COUNT(*) FROM modern_adaptations "
                    "WHERE modern_entity_id LIKE 'modern.marvel.mcu.%'"
                ).fetchone()[0],
                3,
            )

    def test_japanese_and_chinese_identity_boundaries_are_explicit(self):
        with self.connection() as connection:
            candidates = {
                row["id"]: (row["assessment"], row["confidence"])
                for row in connection.execute(
                    """SELECT id,assessment,confidence FROM identity_candidates
                       WHERE id IN ('identity.v060.chinese.leigong_leize',
                                    'identity.v060.japanese.raijin_takemikazuchi')"""
                )
            }
            self.assertEqual(candidates["identity.v060.chinese.leigong_leize"][0], "DISPUTED_IDENTITY")
            self.assertLess(candidates["identity.v060.chinese.leigong_leize"][1], 0.5)
            self.assertEqual(candidates["identity.v060.japanese.raijin_takemikazuchi"][0], "EXPLICITLY_DISTINCT")
            eight = connection.execute(
                "SELECT COUNT(*) FROM claims WHERE predicate='MEMBER_OF' "
                "AND object_entity_id='group.japanese.eight_thunder_kami'"
            ).fetchone()[0]
            self.assertEqual(eight, 8)

    def test_living_tradition_permissions_are_preserved(self):
        with self.connection() as connection:
            temple = json.loads(connection.execute(
                "SELECT metadata_json FROM entities WHERE id='site.yoruba.koso_temple'"
            ).fetchone()[0])
            festival = json.loads(connection.execute(
                "SELECT metadata_json FROM entities WHERE id='festival.yoruba.sango_oyo'"
            ).fetchone()[0])
            self.assertTrue(temple["restricted_interiors"])
            self.assertEqual(temple["location_precision"], "public-level only")
            self.assertTrue(festival["community_permission_required"])
            self.assertEqual(festival["restricted_knowledge"], "metadata only")

    def test_public_web_snapshot_contains_bilingual_comparison(self):
        snapshot = build_snapshot(DATABASE)
        comparison = next(
            item for item in snapshot["comparisons"]
            if item["id"] == "comparison.thunder_storm_deities"
        )
        self.assertEqual(snapshot["meta"]["projectVersion"], "0.10.0-japanese-thunder-local-dossiers")
        self.assertEqual(len(comparison["members"]), 10)
        self.assertTrue(comparison["nameZh"])
        self.assertTrue(comparison["methodologyZh"])
        self.assertTrue(all(member["evidenceCount"] > 0 for member in comparison["members"]))


if __name__ == "__main__":
    unittest.main()
