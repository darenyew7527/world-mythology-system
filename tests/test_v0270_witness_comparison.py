import json
import sqlite3
import unittest
from pathlib import Path

from scripts.generate_web_data import build_snapshot


ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "database" / "world_mythology.sqlite"


class OriginalWitnessComparisonTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.snapshot = build_snapshot(DB)

    def connect(self):
        connection = sqlite3.connect(DB)
        connection.row_factory = sqlite3.Row
        return connection

    def test_schema_36_adds_append_only_witness_tables(self):
        expected = {
            "story_witness_profiles",
            "story_witness_comparisons",
            "story_witness_comparison_members",
        }
        with self.connect() as connection:
            tables = {row[0] for row in connection.execute("SELECT name FROM sqlite_master WHERE type='table'")}
            migration = connection.execute("SELECT name FROM schema_migrations WHERE version=36").fetchone()
        self.assertTrue(expected <= tables)
        self.assertEqual(migration["name"], "20260831_v0270_witness_comparison")

    def test_first_comparison_batch_has_expected_cardinality(self):
        with self.connect() as connection:
            counts = {
                table: connection.execute(f'SELECT COUNT(*) FROM "{table}"').fetchone()[0]
                for table in (
                    "story_witness_profiles",
                    "story_witness_comparisons",
                    "story_witness_comparison_members",
                )
            }
            per_comparison = connection.execute(
                """SELECT comparison_id,COUNT(*) AS members
                   FROM story_witness_comparison_members
                   GROUP BY comparison_id"""
            ).fetchall()
            feature = connection.execute(
                "SELECT status FROM explorer_feature_registry WHERE feature_code='story_witness_comparison'"
            ).fetchone()
        self.assertEqual(counts, {
            "story_witness_profiles": 4,
            "story_witness_comparisons": 7,
            "story_witness_comparison_members": 14,
        })
        self.assertEqual(len(per_comparison), 7)
        self.assertTrue(all(row["members"] == 2 for row in per_comparison))
        self.assertEqual(feature["status"], "ACTIVE")

    def test_members_never_cross_story_boundaries(self):
        with self.connect() as connection:
            mismatches = connection.execute(
                """SELECT m.comparison_id,m.story_version_id
                   FROM story_witness_comparison_members m
                   JOIN story_witness_comparisons c ON c.id=m.comparison_id
                   JOIN story_versions v ON v.id=m.story_version_id
                   WHERE c.story_id<>v.story_id"""
            ).fetchall()
        self.assertFalse(mismatches)

    def test_attested_and_gap_states_have_distinct_evidence_rules(self):
        with self.connect() as connection:
            attested = connection.execute(
                """SELECT m.comparison_id,m.story_version_id,m.story_section_id,
                          m.anchor_claim_id,COUNT(ev.id) AS evidence_count
                   FROM story_witness_comparison_members m
                   LEFT JOIN evidence ev ON ev.claim_id=m.anchor_claim_id
                   WHERE m.evidence_state='ATTESTED'
                   GROUP BY m.comparison_id,m.story_version_id"""
            ).fetchall()
            gaps = connection.execute(
                """SELECT evidence_state,anchor_claim_id FROM story_witness_comparison_members
                   WHERE evidence_state IN ('NOT_STATED','UNMODELED')"""
            ).fetchall()
        self.assertTrue(attested)
        self.assertTrue(all(row["story_section_id"] and row["anchor_claim_id"] for row in attested))
        self.assertTrue(all(row["evidence_count"] > 0 for row in attested))
        self.assertTrue(gaps)
        self.assertTrue(all(row["anchor_claim_id"] is None for row in gaps))

    def test_aphrodite_asymmetry_is_not_rewritten_as_counterevidence(self):
        with self.connect() as connection:
            rows = connection.execute(
                """SELECT story_version_id,evidence_state,summary_en
                   FROM story_witness_comparison_members
                   WHERE comparison_id='wcomp.aphrodite.01_origin_scene'
                   ORDER BY member_order"""
            ).fetchall()
        self.assertEqual(
            [(row["story_version_id"], row["evidence_state"]) for row in rows],
            [
                ("storyver.greek.aphrodite_theogony", "ATTESTED"),
                ("storyver.greek.aphrodite_iliad", "NOT_STATED"),
            ],
        )
        self.assertIn("do not narrate", rows[1]["summary_en"])

    def test_ask_embla_triads_remain_separate_and_conflicted(self):
        with self.connect() as connection:
            rows = connection.execute(
                """SELECT story_version_id,original_form
                   FROM story_witness_comparison_members
                   WHERE comparison_id='wcomp.ask_embla.02_divine_triad'
                   ORDER BY member_order"""
            ).fetchall()
            conflict = connection.execute(
                """SELECT conflict_type,status FROM conflicts
                   WHERE id='conflict.v0270.norse.ask_embla_creator_triads'"""
            ).fetchone()
        self.assertEqual(rows[0]["original_form"], "Óðinn / Hœnir / Lóðurr")
        self.assertEqual(rows[1]["original_form"], "Óðinn / Vili / Vé")
        self.assertEqual((conflict["conflict_type"], conflict["status"]), ("WITNESS_VARIANT", "OPEN"))

    def test_public_snapshot_exposes_profiles_and_comparisons_without_quotes(self):
        counts = self.snapshot["meta"]["counts"]
        release_ids = {release["id"] for release in self.snapshot["analytics"]["releaseHistory"]}
        self.assertIn("release.v0.27.0", release_ids)
        self.assertEqual(counts["storyWitnessProfiles"], 4)
        self.assertEqual(counts["storyWitnessComparisons"], 7)
        self.assertEqual(counts["storyWitnessComparisonMembers"], 14)
        aphrodite = next(story for story in self.snapshot["stories"] if story["id"] == "story.greek.aphrodite_origins")
        self.assertEqual(len(aphrodite["witnessComparisons"]), 4)
        self.assertEqual(aphrodite["versions"][0]["witnessProfile"]["workTitleOriginal"], "Θεογονία")
        serialized = json.dumps(self.snapshot, ensure_ascii=False)
        self.assertNotIn("shortQuote", serialized)
        self.assertNotIn("short_quote", serialized)

    def test_ui_is_keyboard_readable_and_mobile_stacked(self):
        library = (ROOT / "web" / "src" / "components" / "StoryLibrary.jsx").read_text(encoding="utf-8")
        styles = (ROOT / "web" / "src" / "styles.css").read_text(encoding="utf-8")
        mobile = styles.split("@media (max-width: 760px)", 1)[1]
        self.assertIn('className="story-witness-comparison"', library)
        self.assertIn("aria-pressed", library)
        self.assertIn("原典见证对读", library)
        self.assertIn("story-comparison-members { grid-template-columns: 1fr; }", mobile)
        self.assertIn("overflow-wrap: anywhere", styles)

    def test_markdown_archive_preserves_no_synthesis_policy(self):
        aphrodite = (ROOT / "profiles" / "stories" / "story.greek.aphrodite_origins.md").read_text(encoding="utf-8")
        ask_embla = (ROOT / "profiles" / "stories" / "story.norse.ask_embla.md").read_text(encoding="utf-8")
        self.assertIn("## 原典见证对读", aphrodite)
        self.assertIn("`NOT_STATED`", aphrodite)
        self.assertIn("Óðinn / Hœnir / Lóðurr", ask_embla)
        self.assertIn("Óðinn / Vili / Vé", ask_embla)


if __name__ == "__main__":
    unittest.main()
