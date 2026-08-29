import json
import sqlite3
import unittest
from pathlib import Path

from scripts.generate_web_data import build_snapshot


ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "database" / "world_mythology.sqlite"


class Explorer2EvidenceWorkbenchTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.snapshot = build_snapshot(DB)

    def connect(self):
        connection = sqlite3.connect(DB)
        connection.row_factory = sqlite3.Row
        return connection

    def test_release_and_feature_registry_are_persistent(self):
        with self.connect() as connection:
            migration = connection.execute(
                "SELECT name FROM schema_migrations WHERE version=33"
            ).fetchone()
            feature_count = connection.execute(
                "SELECT COUNT(*) FROM explorer_feature_registry WHERE introduced_in='0.24.0'"
            ).fetchone()[0]
        self.assertEqual(migration["name"], "20260827_v0240_explorer2_evidence_workbench")
        self.assertEqual(feature_count, 10)

    def test_public_snapshot_has_all_explorer_analytics(self):
        analytics = self.snapshot["analytics"]
        self.assertEqual(
            set(analytics),
            {"map", "releaseHistory", "sourceQuality", "coverageByCivilization", "queueProgress", "accessPolicyCounts"},
        )
        self.assertIn("release.0.24.0", {item["id"] for item in analytics["releaseHistory"]})

    def test_map_never_infers_missing_coordinates(self):
        map_data = self.snapshot["analytics"]["map"]
        self.assertEqual(map_data["coordinateBackedCount"], len(map_data["places"]))
        self.assertGreater(map_data["missingCoordinateCount"], 0)
        self.assertTrue(all(place["latitude"] is not None and place["longitude"] is not None for place in map_data["places"]))
        self.assertTrue(all(place["evidenceGrade"] not in {"UNASSESSED", "BASELINE_METADATA"} for place in map_data["places"]))

    def test_release_history_is_exact_and_ordered(self):
        releases = self.snapshot["analytics"]["releaseHistory"]
        release = next(item for item in releases if item["id"] == "release.0.24.0")
        self.assertEqual(release["schemaVersion"], 33)
        self.assertEqual([item["builtAt"] for item in releases], sorted(item["builtAt"] for item in releases))

    def test_source_quality_and_queue_totals_reconcile(self):
        quality = self.snapshot["analytics"]["sourceQuality"]
        queue = self.snapshot["analytics"]["queueProgress"]
        self.assertEqual(quality["total"], len(self.snapshot["sources"]))
        self.assertEqual(sum(quality["verificationStatusCounts"].values()), quality["total"])
        self.assertEqual(queue["total"], len(self.snapshot["queue"]))
        self.assertEqual(sum(queue["statusCounts"].values()), queue["total"])

    def test_conflicts_and_access_policies_are_public_governance_metadata(self):
        self.assertEqual(len(self.snapshot["conflicts"]), self.snapshot["meta"]["counts"]["conflicts"])
        self.assertEqual(len(self.snapshot["accessPolicies"]), 8)
        self.assertEqual(
            set(self.snapshot["analytics"]["accessPolicyCounts"]),
            {"PUBLIC_CONTEXT", "ATTRIBUTION_REQUIRED", "PERMISSION_REQUIRED", "DO_NOT_COLLECT"},
        )
        serialized = json.dumps(self.snapshot, ensure_ascii=False)
        self.assertNotIn("short_quote", serialized)
        self.assertNotIn("shortQuote", serialized)

    def test_frontend_exposes_workbench_and_four_evidence_filters(self):
        component = (ROOT / "web" / "src" / "components" / "ExplorerWorkbench.jsx").read_text(encoding="utf-8")
        evidence_view = (ROOT / "web" / "src" / "components" / "EvidenceView.jsx").read_text(encoding="utf-8")
        for marker in ("EvidenceMap", "ReleaseTimeline", "WitnessGraph", "VersionComparison", "AuditWorkbench"):
            self.assertIn(marker, component)
        for marker in ("assertionScope", "knowledgeLayer", "reviewStatus", "evidenceType"):
            self.assertIn(marker, evidence_view)


if __name__ == "__main__":
    unittest.main()
