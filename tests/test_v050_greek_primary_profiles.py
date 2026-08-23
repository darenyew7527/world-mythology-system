import json
import sqlite3
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DATABASE = ROOT / "database" / "world_mythology.sqlite"


class GreekPrimaryProfilesV050Tests(unittest.TestCase):
    def setUp(self):
        self.connection = sqlite3.connect(DATABASE)
        self.connection.row_factory = sqlite3.Row

    def tearDown(self):
        self.connection.close()

    def test_core_deities_are_source_located(self):
        core = {
            "deity.greek.zeus", "deity.greek.hera", "deity.greek.poseidon",
            "deity.greek.hades", "deity.greek.athena", "deity.greek.apollo",
            "deity.greek.artemis", "deity.greek.hermes", "deity.greek.ares",
            "deity.greek.aphrodite", "deity.greek.hephaestus",
            "deity.greek.demeter", "deity.greek.dionysus",
        }
        rows = self.connection.execute(
            "SELECT id, original_name, description, evidence_status FROM entities WHERE id IN (%s)"
            % ",".join("?" for _ in core), tuple(core)
        ).fetchall()
        self.assertEqual({row["id"] for row in rows}, core)
        self.assertTrue(all(row["original_name"] and row["description"] for row in rows))
        self.assertTrue(all(row["evidence_status"] in {"SOURCE_BACKED", "CONFLICTING"} for row in rows))
        for entity_id in core:
            unsupported = self.connection.execute(
                """SELECT COUNT(*) FROM claims c
                   WHERE c.subject_id=?
                     AND NOT EXISTS (SELECT 1 FROM evidence e WHERE e.claim_id=c.id)""",
                (entity_id,),
            ).fetchone()[0]
            self.assertEqual(unsupported, 0, entity_id)

    def test_hymn_subworks_have_profiles_and_honest_source_status(self):
        texts = self.connection.execute(
            """SELECT e.id, e.evidence_status, t.shelfmark
               FROM entities e JOIN text_profiles t ON t.entity_id=e.id
               WHERE e.id IN (
                 'text.greek.homeric_hymn_apollo_3',
                 'text.greek.homeric_hymn_hermes_4',
                 'text.greek.homeric_hymn_aphrodite_5',
                 'text.greek.homeric_hymn_dionysus_7',
                 'text.greek.homeric_hymn_ares_8',
                 'text.greek.homeric_hymn_hephaestus_20',
                 'text.greek.homeric_hymn_poseidon_22',
                 'text.greek.homeric_hymn_artemis_27',
                 'text.greek.homeric_hymn_athena_28'
               )"""
        ).fetchall()
        self.assertEqual(len(texts), 9)
        self.assertTrue(all(row["shelfmark"].startswith("urn:cts:") for row in texts))
        statuses = self.connection.execute(
            """SELECT DISTINCT verification_status FROM sources
               WHERE id IN (
                 'source.greek.homeric_hymn_apollo3.scaife',
                 'source.greek.homeric_hymn_hermes4.scaife',
                 'source.greek.homeric_hymn_aphrodite5.scaife',
                 'source.greek.homeric_hymn_dionysus7.scaife',
                 'source.greek.homeric_hymn_ares8.scaife',
                 'source.greek.homeric_hymn_hephaestus20.scaife',
                 'source.greek.homeric_hymn_poseidon22.scaife',
                 'source.greek.homeric_hymn_artemis27.scaife',
                 'source.greek.homeric_hymn_athena28.scaife'
               )"""
        ).fetchall()
        self.assertEqual({row[0] for row in statuses}, {"URL_SYNTAX_VALID"})

    def test_aphrodite_variants_are_explicit_and_not_flattened(self):
        conflict = self.connection.execute(
            "SELECT * FROM conflicts WHERE id='conflict.greek.aphrodite_parentage_v050'"
        ).fetchone()
        self.assertEqual(conflict["status"], "OPEN")
        self.assertEqual(conflict["conflict_type"], "GENEALOGY_VARIANT")
        claims = self.connection.execute(
            """SELECT id, tradition_scope FROM claims
               WHERE variant_group='aphrodite.parentage_origin'
                 AND subject_id='deity.greek.aphrodite'"""
        ).fetchall()
        self.assertEqual(len(claims), 3)
        self.assertEqual({row["tradition_scope"] for row in claims}, {"Hesiodic", "Iliadic"})
        metadata = json.loads(self.connection.execute(
            "SELECT metadata_json FROM entities WHERE id='deity.greek.aphrodite'"
        ).fetchone()[0])
        self.assertIn("no automatic resolution", metadata["variant_caution"])

    def test_persephone_event_is_queryable_both_directions(self):
        participants = {
            row[0] for row in self.connection.execute(
                "SELECT participant_id FROM event_participants WHERE event_id='event.greek.persephone_abduction'"
            )
        }
        self.assertEqual(participants, {
            "deity.greek.persephone", "deity.greek.demeter", "deity.greek.hades",
        })
        for deity_id in participants:
            edge = self.connection.execute(
                """SELECT COUNT(*) FROM relationship_edges_bidirectional
                   WHERE source_entity_id=? AND target_entity_id='event.greek.persephone_abduction'""",
                (deity_id,),
            ).fetchone()[0]
            self.assertGreater(edge, 0, deity_id)

    def test_follow_up_gaps_remain_in_permanent_queue(self):
        statuses = {
            row["id"]: row["status"] for row in self.connection.execute(
                "SELECT id,status FROM collection_queue WHERE id LIKE 'queue.greek.v050.%'"
            )
        }
        self.assertEqual(len(statuses), 5)
        # v0.8 advances this durable gap while preserving six follow-up branches.
        self.assertEqual(statuses["queue.greek.v050.eleusis_layers"], "PARTIAL")
        self.assertEqual(statuses["queue.greek.v050.olympian_membership"], "NEEDS_REVIEW")


if __name__ == "__main__":
    unittest.main()
