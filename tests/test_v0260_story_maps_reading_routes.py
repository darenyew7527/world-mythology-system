import json
import sqlite3
import unittest
from pathlib import Path

from scripts.generate_web_data import build_snapshot


ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "database" / "world_mythology.sqlite"


class StoryMapsReadingRoutesTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.snapshot = build_snapshot(DB)

    def connect(self):
        connection = sqlite3.connect(DB)
        connection.row_factory = sqlite3.Row
        return connection

    def test_schema_35_adds_append_only_route_tables(self):
        expected = {"story_event_nodes", "reading_routes", "reading_route_steps"}
        with self.connect() as connection:
            tables = {row[0] for row in connection.execute("SELECT name FROM sqlite_master WHERE type='table'")}
            migration = connection.execute("SELECT name FROM schema_migrations WHERE version=35").fetchone()
        self.assertTrue(expected <= tables)
        self.assertEqual(migration["name"], "20260830_v0260_story_maps_reading_routes")

    def test_new_public_procession_stories_are_source_backed(self):
        with self.connect() as connection:
            rows = connection.execute(
                """SELECT s.id,COUNT(DISTINCT sv.id) versions,COUNT(DISTINCT ss.id) sections,
                          COUNT(DISTINCT scl.claim_id) claims,COUNT(DISTINCT ev.id) evidence
                   FROM stories s JOIN story_versions sv ON sv.story_id=s.id
                   JOIN story_sections ss ON ss.story_version_id=sv.id
                   JOIN story_claim_links scl ON scl.story_version_id=sv.id
                   JOIN evidence ev ON ev.claim_id=scl.claim_id
                   WHERE s.id IN ('story.egyptian.opet_procession','story.greek.eleusinia_procession')
                   GROUP BY s.id"""
            ).fetchall()
        self.assertEqual(len(rows), 2)
        self.assertTrue(all(row["versions"] == 1 and row["sections"] == 4 for row in rows))
        self.assertTrue(all(row["claims"] >= 4 and row["evidence"] >= 4 for row in rows))

    def test_every_section_has_ordered_event_node(self):
        with self.connect() as connection:
            sections = connection.execute("SELECT COUNT(*) FROM story_sections").fetchone()[0]
            events = connection.execute("SELECT COUNT(*) FROM story_event_nodes").fetchone()[0]
            mismatches = connection.execute(
                """SELECT ss.id FROM story_sections ss
                   LEFT JOIN story_event_nodes n
                     ON n.story_version_id=ss.story_version_id AND n.event_order=ss.section_order
                   WHERE n.id IS NULL"""
            ).fetchall()
        self.assertEqual(events, sections)
        self.assertFalse(mismatches)

    def test_real_place_policy_never_invents_coordinates(self):
        with self.connect() as connection:
            rows = connection.execute(
                """SELECT n.id,n.coordinate_policy,p.latitude,p.longitude
                   FROM story_event_nodes n
                   LEFT JOIN place_profiles p ON p.entity_id=n.place_entity_id
                   WHERE n.coordinate_policy='VERIFIED_COORDINATE'"""
            ).fetchall()
            forbidden = connection.execute(
                """SELECT COUNT(*) FROM story_event_nodes
                   WHERE location_kind='MYTHIC_PLACE' AND coordinate_policy='VERIFIED_COORDINATE'"""
            ).fetchone()[0]
        self.assertTrue(all(row["latitude"] is not None and row["longitude"] is not None for row in rows))
        self.assertEqual(forbidden, 0)

    def test_six_routes_keep_witness_specific_steps(self):
        with self.connect() as connection:
            routes = connection.execute("SELECT COUNT(*) FROM reading_routes").fetchone()[0]
            steps = connection.execute("SELECT COUNT(*) FROM reading_route_steps").fetchone()[0]
            orphaned = connection.execute(
                """SELECT COUNT(*) FROM reading_route_steps rs
                   LEFT JOIN story_versions sv ON sv.id=rs.story_version_id
                   WHERE rs.story_version_id IS NOT NULL AND sv.id IS NULL"""
            ).fetchone()[0]
        self.assertEqual(routes, 6)
        self.assertGreaterEqual(steps, 20)
        self.assertEqual(orphaned, 0)

    def test_public_snapshot_and_ui_expose_routes_without_quotes(self):
        self.assertEqual(self.snapshot["meta"]["projectVersion"], "0.26.0-story-maps-reading-routes")
        self.assertEqual(self.snapshot["meta"]["counts"]["stories"], 23)
        self.assertEqual(self.snapshot["meta"]["counts"]["storyEventNodes"], 77)
        self.assertEqual(len(self.snapshot["readingRoutes"]), 6)
        serialized = json.dumps(self.snapshot, ensure_ascii=False)
        self.assertNotIn("shortQuote", serialized)
        self.assertNotIn("short_quote", serialized)
        library = (ROOT / "web" / "src" / "components" / "StoryLibrary.jsx").read_text(encoding="utf-8")
        self.assertIn("story-route-strip", library)
        self.assertIn("story-event-map", library)
        self.assertIn("Coordinates are not inferred", library)

    def test_queue_targets_are_audited_without_false_completion(self):
        with self.connect() as connection:
            opet = connection.execute("SELECT status,next_action FROM collection_queue WHERE id='queue.v070.egypt.opet_layers'").fetchone()
            sacred = connection.execute("SELECT status,next_action FROM collection_queue WHERE id='queue.v080.greek.sacred_way_monuments'").fetchone()
            new_gaps = connection.execute("SELECT COUNT(*) FROM collection_queue WHERE id LIKE 'queue.v0260.%'").fetchone()[0]
        self.assertEqual(opet["status"], "BASELINE_COMPLETE")
        self.assertEqual(sacred["status"], "PARTIAL")
        self.assertEqual(new_gaps, 3)
        self.assertIn("Add", opet["next_action"])


if __name__ == "__main__":
    unittest.main()
