import json
import sqlite3
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DATABASE = ROOT / "database" / "world_mythology.sqlite"


class GreekGenealogyV040Tests(unittest.TestCase):
    def setUp(self):
        self.connection = sqlite3.connect(DATABASE)
        self.connection.row_factory = sqlite3.Row

    def tearDown(self):
        self.connection.close()

    def test_requested_deities_exist_with_evidenced_outgoing_claims(self):
        requested = {
            "deity.greek.thanatos", "deity.greek.hypnos", "deity.greek.nyx",
            "deity.greek.hecate", "deity.greek.selene", "deity.greek.helios",
            "deity.greek.hestia",
        }
        rows = self.connection.execute(
            "SELECT id,evidence_status FROM entities WHERE id IN (%s)"
            % ",".join("?" for _ in requested), tuple(requested)
        ).fetchall()
        self.assertEqual({row["id"] for row in rows}, requested)
        self.assertTrue(all(row["evidence_status"] == "SOURCE_BACKED" for row in rows))
        for entity_id in requested:
            unsupported = self.connection.execute(
                """SELECT COUNT(*) FROM claims c
                   WHERE c.subject_id=?
                     AND NOT EXISTS (SELECT 1 FROM evidence e WHERE e.claim_id=c.id)""",
                (entity_id,),
            ).fetchone()[0]
            self.assertEqual(unsupported, 0, entity_id)

    def test_bidirectional_genealogy_is_queryable_from_child(self):
        helios_edges = {
            (row["relationship_type"], row["target_entity_id"])
            for row in self.connection.execute(
                """SELECT relationship_type,target_entity_id
                   FROM relationship_edges_bidirectional
                   WHERE source_entity_id='deity.greek.helios'"""
            )
        }
        self.assertIn(("CHILD_OF", "deity.greek.hyperion"), helios_edges)
        self.assertIn(("CHILD_OF", "deity.greek.theia"), helios_edges)
        self.assertIn(("SIBLING_OF", "deity.greek.selene"), helios_edges)

    def test_hecate_layers_and_perses_identity_are_not_flattened(self):
        hecate = self.connection.execute(
            "SELECT metadata_json FROM entities WHERE id='deity.greek.hecate'"
        ).fetchone()
        self.assertIn("later magic", json.loads(hecate["metadata_json"])["layer_caution"])
        magic_edges = self.connection.execute(
            """SELECT COUNT(*) FROM claims
               WHERE subject_id='deity.greek.hecate'
                 AND object_entity_id='concept.comparative.magic'"""
        ).fetchone()[0]
        self.assertEqual(magic_edges, 0)
        perses = json.loads(self.connection.execute(
            "SELECT metadata_json FROM entities WHERE id='deity.greek.perses'"
        ).fetchone()[0])
        self.assertIn("more than one", perses["identity_caution"])
        queue_status = self.connection.execute(
            "SELECT status FROM collection_queue WHERE id='queue.greek.v040.perses_identity'"
        ).fetchone()[0]
        self.assertEqual(queue_status, "CONFLICT")

    def test_public_comment_is_discovery_provenance_not_evidence(self):
        discovery = self.connection.execute(
            """SELECT discovered_from_source_id,discovery_context
               FROM queue_discoveries
               WHERE id='discovery.20260814.public_greek_feedback'"""
        ).fetchone()
        self.assertIsNone(discovery["discovered_from_source_id"])
        self.assertIn("never as evidence", discovery["discovery_context"])
        source_mentions = self.connection.execute(
            "SELECT COUNT(*) FROM sources WHERE lower(title) LIKE '%threads%'"
        ).fetchone()[0]
        self.assertEqual(source_mentions, 0)

    def test_new_source_statuses_are_honest(self):
        rows = self.connection.execute(
            """SELECT verification_status FROM sources
               WHERE id IN (
                 'source.greek.homeric_hymn_demeter.scaife',
                 'source.greek.homeric_hymn_hestia29.scaife',
                 'source.greek.homeric_hymn_helios31.scaife',
                 'source.greek.homeric_hymn_selene32.scaife'
               )"""
        ).fetchall()
        self.assertEqual(len(rows), 4)
        self.assertEqual({row[0] for row in rows}, {"URL_SYNTAX_VALID"})
        self.assertEqual(self.connection.execute(
            "SELECT COUNT(*) FROM sources WHERE verification_status='WEB_CONFIRMED'"
        ).fetchone()[0], 0)


if __name__ == "__main__":
    unittest.main()
