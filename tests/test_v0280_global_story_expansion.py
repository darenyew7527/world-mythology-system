import json
import sqlite3
import unittest
from collections import Counter
from pathlib import Path

from scripts.generate_web_data import build_snapshot


ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "database" / "world_mythology.sqlite"


class GlobalStoryExpansionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.snapshot = build_snapshot(DB)

    def connect(self):
        connection = sqlite3.connect(DB)
        connection.row_factory = sqlite3.Row
        return connection

    def test_schema_37_adds_fault_isolated_expansion_ledger(self):
        with self.connect() as connection:
            tables = {
                row[0]
                for row in connection.execute(
                    "SELECT name FROM sqlite_master WHERE type='table'"
                )
            }
            migration = connection.execute(
                "SELECT name FROM schema_migrations WHERE version=37"
            ).fetchone()
        self.assertTrue({"story_expansion_batches", "story_expansion_targets"} <= tables)
        self.assertEqual(
            migration["name"],
            "20260901_v0280_global_story_expansion_batch1",
        )

    def test_batch_retains_completed_queued_and_permission_blocked_targets(self):
        with self.connect() as connection:
            batch = connection.execute(
                "SELECT status,continuation_policy FROM story_expansion_batches "
                "WHERE id='storybatch.v0280.01'"
            ).fetchone()
            targets = connection.execute(
                "SELECT status FROM story_expansion_targets "
                "WHERE batch_id='storybatch.v0280.01' ORDER BY target_order"
            ).fetchall()
        self.assertEqual(batch["status"], "CHECKPOINT_COMPLETE")
        self.assertIn("never erase completed targets", batch["continuation_policy"])
        self.assertEqual(
            Counter(row["status"] for row in targets),
            Counter({"COMPLETED": 3, "QUEUED": 2, "BLOCKED_PERMISSION": 2}),
        )

    def test_first_batch_adds_three_stories_four_versions_and_twelve_events(self):
        story_ids = (
            "story.maya.hero_twins_seven_macaw",
            "story.japanese.kusanagi_transmission",
            "story.khmer.angkor_wat_churning_relief",
        )
        placeholders = ",".join("?" for _ in story_ids)
        with self.connect() as connection:
            row = connection.execute(
                f"""SELECT COUNT(DISTINCT s.id) AS stories,
                           COUNT(DISTINCT sv.id) AS versions,
                           COUNT(DISTINCT ss.id) AS sections,
                           COUNT(DISTINCT n.id) AS events
                    FROM stories s
                    JOIN story_versions sv ON sv.story_id=s.id
                    JOIN story_sections ss ON ss.story_version_id=sv.id
                    JOIN story_event_nodes n ON n.story_version_id=sv.id
                    WHERE s.id IN ({placeholders})""",
                story_ids,
            ).fetchone()
        self.assertEqual(dict(row), {
            "stories": 3,
            "versions": 4,
            "sections": 12,
            "events": 12,
        })

    def test_every_verified_v0280_claim_has_evidence(self):
        with self.connect() as connection:
            missing = connection.execute(
                """SELECT c.id FROM claims c
                   LEFT JOIN evidence e ON e.claim_id=c.id
                   WHERE c.id LIKE 'claim.v0280.%' AND c.review_status='VERIFIED'
                   GROUP BY c.id HAVING COUNT(e.id)=0"""
            ).fetchall()
        self.assertFalse(missing)

    def test_maya_episode_is_kiche_attributed_and_permission_scoped(self):
        with self.connect() as connection:
            source = connection.execute(
                "SELECT living_tradition,community_or_lineage,source_perspective "
                "FROM sources WHERE id='source.maya.creation.nmai'"
            ).fetchone()
            policy = connection.execute(
                "SELECT access_level,permitted_scope,prohibited_scope "
                "FROM tradition_access_policies "
                "WHERE id='policy.v0280.maya.hero_twins_public'"
            ).fetchone()
            story = connection.execute(
                "SELECT editorial_note FROM stories "
                "WHERE id='story.maya.hero_twins_seven_macaw'"
            ).fetchone()
        self.assertEqual(source["living_tradition"], 1)
        self.assertEqual(source["community_or_lineage"], "K'iche' Maya")
        self.assertIn("K'iche'", source["source_perspective"])
        self.assertEqual(policy["access_level"], "ATTRIBUTION_REQUIRED")
        self.assertIn("independently written", policy["permitted_scope"])
        self.assertIn("No claim of one standard Maya version", policy["prohibited_scope"])
        self.assertIn("K'iche'", story["editorial_note"])

    def test_kusanagi_versions_keep_academic_and_shrine_layers_separate(self):
        with self.connect() as connection:
            versions = connection.execute(
                "SELECT source_id FROM story_versions "
                "WHERE story_id='story.japanese.kusanagi_transmission' "
                "ORDER BY version_order"
            ).fetchall()
            boundary_evidence = connection.execute(
                "SELECT COUNT(*) FROM evidence "
                "WHERE claim_id='claim.v0280.japan.kusanagi_source_boundary'"
            ).fetchone()[0]
            artifact = connection.execute(
                "SELECT fate_summary FROM artifact_profiles "
                "WHERE entity_id='weapon.japanese.kusanagi'"
            ).fetchone()
        self.assertEqual(
            [row["source_id"] for row in versions],
            [
                "source.japanese.kusanagi.yamatanoorochi.kokugakuin",
                "source.japanese.kusanagi.atsuta_official",
            ],
        )
        self.assertEqual(boundary_evidence, 2)
        self.assertIn("no claim of independently verified physical continuity", artifact["fate_summary"])

    def test_angkor_story_is_a_real_site_material_witness_not_a_text_reconstruction(self):
        with self.connect() as connection:
            event_rows = connection.execute(
                """SELECT location_kind,coordinate_policy
                   FROM story_event_nodes
                   WHERE story_version_id='storyver.khmer.angkor_churning_apsara'"""
            ).fetchall()
            institutions = {
                row[0]
                for row in connection.execute(
                    "SELECT institution FROM sources "
                    "WHERE id IN ('source.khmer.angkor_wat.apsara','source.khmer.angkor.unesco668')"
                )
            }
            boundary = connection.execute(
                "SELECT object_literal FROM claims "
                "WHERE id='claim.v0280.khmer.material_scope'"
            ).fetchone()[0]
        self.assertEqual(len(event_rows), 3)
        self.assertTrue(
            all(
                (row["location_kind"], row["coordinate_policy"])
                == ("REAL_SITE", "ENTITY_PROFILE_ONLY")
                for row in event_rows
            )
        )
        self.assertEqual(institutions, {"APSARA National Authority", "UNESCO World Heritage Centre"})
        self.assertIn("not a complete or universal Sanskrit textual recension", boundary)

    def test_public_snapshot_exposes_batch_without_private_quotes(self):
        counts = self.snapshot["meta"]["counts"]
        self.assertEqual(
            self.snapshot["meta"]["datasetRelease"]["id"],
            "release.v0.31.0",
        )
        # Later batches only add rows; the v0.28 checkpoint remains a lower bound.
        minimums = {
            "stories": 29,
            "storyVersions": 35,
            "storySections": 113,
            "storyEventNodes": 113,
            "storyExpansionBatches": 2,
            "storyExpansionTargets": 15,
        }
        for key, minimum in minimums.items():
            self.assertGreaterEqual(counts[key], minimum, key)
        self.assertEqual(counts["storySections"], counts["storyEventNodes"])
        batch = next(
            item for item in self.snapshot["storyExpansionBatches"]
            if item["id"] == "storybatch.v0280.01"
        )
        self.assertEqual(len(batch["targets"]), 7)
        serialized = json.dumps(self.snapshot, ensure_ascii=False)
        self.assertNotIn("shortQuote", serialized)
        self.assertNotIn("short_quote", serialized)

    def test_ui_exposes_status_audit_and_mobile_overflow(self):
        app = (ROOT / "web" / "src" / "App.jsx").read_text(encoding="utf-8")
        library = (ROOT / "web" / "src" / "components" / "StoryLibrary.jsx").read_text(encoding="utf-8")
        styles = (ROOT / "web" / "src" / "styles.css").read_text(encoding="utf-8")
        tablet = styles.split("@media (max-width: 980px)", 1)[1]
        mobile = styles.split("@media (max-width: 760px)", 1)[1]
        self.assertIn("storyExpansionBatches={data.storyExpansionBatches || []}", app)
        self.assertIn('className="story-expansion-audit"', library)
        self.assertIn("BLOCKED_PERMISSION", library)
        self.assertIn("v0.31", library)
        self.assertIn(".story-expansion-audit ul { display: flex; overflow-x: auto", tablet)
        self.assertIn(".story-expansion-audit > header { align-items: flex-start; flex-direction: column; }", mobile)

    def test_v028_release_remains_preserved_after_later_seals(self):
        with self.connect() as connection:
            v028_release = connection.execute(
                "SELECT schema_version,data_version FROM dataset_releases "
                "WHERE id='release.v0.28.0'"
            ).fetchone()
            latest_release = connection.execute(
                "SELECT id,schema_version,data_version FROM dataset_releases "
                "ORDER BY built_at DESC,id DESC LIMIT 1"
            ).fetchone()
            migration = connection.execute(
                "SELECT name FROM schema_migrations WHERE version=38"
            ).fetchone()
        checkpoint = json.loads(
            (ROOT / "reports" / "checkpoint.json").read_text(encoding="utf-8")
        )
        manifest = json.loads(
            (ROOT / "exports" / "manifest.json").read_text(encoding="utf-8")
        )
        coverage = (ROOT / "reports" / "coverage_report.md").read_text(encoding="utf-8")
        self.assertEqual(dict(v028_release), {"schema_version": 38, "data_version": "0.28.0"})
        self.assertEqual(
            dict(latest_release),
            {"id": "release.v0.31.0", "schema_version": 44, "data_version": "0.31.0"},
        )
        self.assertEqual(
            migration["name"],
            "20260901_v0280_global_story_expansion_release",
        )
        self.assertEqual(checkpoint["snapshot_status"], "SEALED_RELEASE")
        self.assertEqual(
            checkpoint["data_version"],
            "0.31.0",
        )
        self.assertEqual(checkpoint["release_id"], "release.v0.31.0")
        self.assertEqual(checkpoint["latest_sealed_release_id"], "release.v0.31.0")
        self.assertEqual(manifest["snapshot_status"], "SEALED_RELEASE")
        self.assertEqual(
            manifest["project"]["data_version"],
            "0.31.0",
        )
        self.assertEqual(
            manifest["latest_sealed_release"]["data_version"],
            "0.31.0",
        )
        self.assertNotIn("当前为开发快照", coverage)


if __name__ == "__main__":
    unittest.main()
