import json
import sqlite3
import unittest
from collections import Counter
from pathlib import Path

from scripts.generate_offline_archive import HTML_NAME, JSON_NAME
from scripts.generate_web_data import build_snapshot


ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "database" / "world_mythology.sqlite"
V030_STORIES = (
    "story.chinese.nuwa_repairs_sky",
    "story.chinese.gonggong_buzhou",
    "story.hindu.samudra_manthana_texts",
)
V030_SOURCES = (
    "source.china.huainanzi.lanmingxun.ctext",
    "source.china.huainanzi.tianwenxun.ctext",
    "source.china.liezi.tangwen.ctext",
    "source.india.mahabharata.adiparvan.gretil",
    "source.india.bhagavatapurana.gretil",
)


class GlobalStoryExpansionBatch2Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.snapshot = build_snapshot(DB)

    def connect(self):
        connection = sqlite3.connect(DB)
        connection.row_factory = sqlite3.Row
        return connection

    def test_schema_41_and_42_seal_v030_as_latest_release(self):
        with self.connect() as connection:
            migrations = {
                row["version"]: row["name"]
                for row in connection.execute(
                    "SELECT version,name FROM schema_migrations WHERE version IN (41,42)"
                )
            }
            latest = connection.execute(
                "SELECT id,schema_version,data_version FROM dataset_releases "
                "ORDER BY built_at DESC,id DESC LIMIT 1"
            ).fetchone()
            v029 = connection.execute(
                "SELECT schema_version FROM dataset_releases WHERE id='release.v0.29.0'"
            ).fetchone()
        self.assertEqual(migrations, {
            41: "20261002_v0300_global_story_expansion_batch2",
            42: "20261002_v0300_global_story_expansion_batch2_release",
        })
        self.assertEqual(
            dict(latest),
            {"id": "release.v0.30.0", "schema_version": 42, "data_version": "0.30.0"},
        )
        self.assertEqual(v029["schema_version"], 40)
        meta = self.snapshot["meta"]
        self.assertEqual(meta["projectVersion"], "0.30.0-global-story-expansion-batch-2")
        self.assertEqual(meta["dataVersion"], "0.30.0")

    def test_batch2_is_append_only_and_keeps_queued_and_blocked_targets(self):
        with self.connect() as connection:
            batch = connection.execute(
                "SELECT status,version_label FROM story_expansion_batches "
                "WHERE id='storybatch.v0300.02'"
            ).fetchone()
            batch2 = connection.execute(
                "SELECT status FROM story_expansion_targets WHERE batch_id='storybatch.v0300.02'"
            ).fetchall()
            batch1_queued = {
                row["id"]
                for row in connection.execute(
                    "SELECT id FROM story_expansion_targets "
                    "WHERE batch_id='storybatch.v0280.01' AND status='QUEUED'"
                )
            }
        self.assertEqual(dict(batch), {"status": "CHECKPOINT_COMPLETE", "version_label": "0.30.0"})
        self.assertEqual(
            Counter(row["status"] for row in batch2),
            Counter({"COMPLETED": 4, "QUEUED": 2, "BLOCKED_PERMISSION": 2}),
        )
        self.assertEqual(
            batch1_queued,
            {"storytarget.v0280.01.china", "storytarget.v0280.01.india"},
        )

    def test_three_stories_six_versions_and_one_event_node_per_section(self):
        placeholders = ",".join("?" for _ in V030_STORIES)
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
                V030_STORIES,
            ).fetchone()
            version_sources = connection.execute(
                f"""SELECT story_id,COUNT(DISTINCT source_id) AS sources
                    FROM story_versions WHERE story_id IN ({placeholders})
                    GROUP BY story_id""",
                V030_STORIES,
            ).fetchall()
        self.assertEqual(dict(row), {"stories": 3, "versions": 6, "sections": 24, "events": 24})
        self.assertTrue(all(item["sources"] == 2 for item in version_sources))

    def test_every_v030_claim_and_section_anchor_has_evidence(self):
        with self.connect() as connection:
            unsourced = connection.execute(
                """SELECT c.id FROM claims c
                   LEFT JOIN evidence e ON e.claim_id=c.id
                   WHERE c.id LIKE 'claim.v0300.%'
                   GROUP BY c.id HAVING COUNT(e.id)=0"""
            ).fetchall()
            anchors = connection.execute(
                """SELECT ss.id FROM story_sections ss
                   LEFT JOIN evidence e ON e.claim_id=ss.anchor_claim_id
                   WHERE ss.id LIKE 'storysec.v0300.%'
                   GROUP BY ss.id HAVING COUNT(e.id)=0"""
            ).fetchall()
            short_quotes = connection.execute(
                "SELECT COUNT(*) FROM evidence WHERE id LIKE 'evidence.v0300.%' AND short_quote IS NOT NULL"
            ).fetchone()[0]
        self.assertFalse(unsourced)
        self.assertFalse(anchors)
        self.assertEqual(short_quotes, 0)

    def test_new_sources_are_not_overstated_as_web_confirmed(self):
        placeholders = ",".join("?" for _ in V030_SOURCES)
        with self.connect() as connection:
            rows = connection.execute(
                f"SELECT id,verification_status,url,notes FROM sources WHERE id IN ({placeholders})",
                V030_SOURCES,
            ).fetchall()
        self.assertEqual(len(rows), 5)
        self.assertTrue(all(row["verification_status"] == "URL_SYNTAX_VALID" for row in rows))
        self.assertTrue(all(row["url"].startswith("https://") for row in rows))
        self.assertTrue(all("search-index" in row["notes"] or "not fetched" in row["notes"] for row in rows))

    def test_tortoise_support_stays_a_witness_conflict_without_identity_merge(self):
        with self.connect() as connection:
            conflict = connection.execute(
                "SELECT claim_a_id,claim_b_id,status FROM conflicts "
                "WHERE id='conflict.v0300.hindu.churning_tortoise_support'"
            ).fetchone()
            sources = {
                row["claim_id"]: row["source_id"]
                for row in connection.execute(
                    "SELECT claim_id,source_id FROM evidence WHERE claim_id IN "
                    "('claim.v0300.churn.akupara_supports','claim.v0300.churn.kurma_supports')"
                )
            }
            identity_links = connection.execute(
                """SELECT COUNT(*) FROM claims
                   WHERE predicate IN ('IDENTIFIED_WITH','FORM_OF','VARIANT_OF')
                     AND ((subject_id='creature.hindu.akupara' AND object_entity_id IN ('deity.hindu.kurma','deity.hindu.vishnu'))
                       OR (subject_id IN ('deity.hindu.kurma','deity.hindu.vishnu') AND object_entity_id='creature.hindu.akupara'))"""
            ).fetchone()[0]
            candidates = connection.execute(
                """SELECT COUNT(*) FROM identity_candidates
                   WHERE 'creature.hindu.akupara' IN (entity_a_id,entity_b_id)"""
            ).fetchone()[0]
        self.assertEqual(conflict["status"], "OPEN")
        self.assertEqual(
            (conflict["claim_a_id"], conflict["claim_b_id"]),
            ("claim.v0300.churn.akupara_supports", "claim.v0300.churn.kurma_supports"),
        )
        self.assertEqual(sources, {
            "claim.v0300.churn.akupara_supports": "source.india.mahabharata.adiparvan.gretil",
            "claim.v0300.churn.kurma_supports": "source.india.bhagavatapurana.gretil",
        })
        self.assertEqual(identity_links, 0)
        self.assertEqual(candidates, 0)

    def test_not_stated_poison_is_a_scoped_gap_not_a_negative_claim(self):
        with self.connect() as connection:
            members = {
                row["story_version_id"]: dict(row)
                for row in connection.execute(
                    "SELECT story_version_id,evidence_state,anchor_claim_id "
                    "FROM story_witness_comparison_members WHERE comparison_id='wcomp.churn.04_poison'"
                )
            }
            scope = connection.execute(
                "SELECT object_literal,predicate FROM claims WHERE id='claim.v0300.churn.mbh_poison_scope'"
            ).fetchone()
            apparatus = connection.execute(
                "SELECT status FROM collection_queue WHERE id='queue.v0300.india.churning_apparatus'"
            ).fetchone()
        self.assertEqual(members["storyver.hindu.churning_mbh_ce"]["evidence_state"], "NOT_STATED")
        self.assertIsNone(members["storyver.hindu.churning_mbh_ce"]["anchor_claim_id"])
        self.assertEqual(members["storyver.hindu.churning_bhagavata"]["evidence_state"], "ATTESTED")
        self.assertEqual(scope["predicate"], "EVIDENCE_SCOPE")
        self.assertIn("not assessed here", scope["object_literal"])
        self.assertEqual(apparatus["status"], "DISCOVERED")

    def test_gonggong_is_never_modeled_as_the_cause_of_nuwas_repair(self):
        events = ("event.chinese.gonggong_strikes_buzhou", "event.chinese.nuwa_repairs_sky")
        with self.connect() as connection:
            causal = connection.execute(
                """SELECT COUNT(*) FROM claims
                   WHERE predicate IN ('CAUSED','CAUSED_BY')
                     AND subject_id IN (?,?) AND object_entity_id IN (?,?)""",
                events + events,
            ).fetchone()[0]
            sequence = connection.execute(
                "SELECT object_entity_id FROM claims WHERE id='claim.v0300.gonggong.liezi_after_nuwa'"
            ).fetchone()
            placement = connection.execute(
                "SELECT status FROM conflicts WHERE id='conflict.v0300.china.gonggong_placement'"
            ).fetchone()
            later = connection.execute(
                "SELECT status FROM collection_queue WHERE id='queue.v0300.china.nuwa_later_causal_link'"
            ).fetchone()
            liezi_dragon = connection.execute(
                """SELECT evidence_state FROM story_witness_comparison_members
                   WHERE comparison_id='wcomp.nuwa.03_dragon_ash'
                     AND story_version_id='storyver.chinese.nuwa_liezi_tangwen'"""
            ).fetchone()
        self.assertEqual(causal, 0)
        self.assertEqual(sequence["object_entity_id"], "event.chinese.nuwa_repairs_sky")
        self.assertEqual(placement["status"], "OPEN")
        self.assertEqual(later["status"], "DISCOVERED")
        self.assertEqual(liezi_dragon["evidence_state"], "NOT_STATED")

    def test_angkor_relief_stays_material_and_mythic_places_have_no_coordinates(self):
        with self.connect() as connection:
            khmer_versions = connection.execute(
                "SELECT COUNT(*) FROM story_versions WHERE story_id='story.khmer.angkor_wat_churning_relief'"
            ).fetchone()[0]
            boundary = connection.execute(
                "SELECT direction,source_id FROM evidence "
                "WHERE claim_id='claim.v0300.churn.relief_recension_boundary'"
            ).fetchall()
            coordinates = connection.execute(
                """SELECT COUNT(*) FROM place_profiles
                   WHERE entity_id IN ('place.chinese.buzhou_mountain','place.hindu.mandara')
                     AND (latitude IS NOT NULL OR longitude IS NOT NULL)"""
            ).fetchone()[0]
            verified_nodes = connection.execute(
                """SELECT COUNT(*) FROM story_event_nodes
                   WHERE id LIKE 'storyevent.v0300.%' AND coordinate_policy='VERIFIED_COORDINATE'"""
            ).fetchone()[0]
        self.assertEqual(khmer_versions, 1)
        self.assertEqual({row["direction"] for row in boundary}, {"CONTEXT"})
        self.assertEqual(len({row["source_id"] for row in boundary}), 3)
        self.assertEqual(coordinates, 0)
        self.assertEqual(verified_nodes, 0)

    def test_witness_route_ends_with_the_material_witness(self):
        route = next(
            item for item in self.snapshot["readingRoutes"]
            if item["id"] == "route.textual_material_witness_layers"
        )
        self.assertEqual(route["routeType"], "WITNESS")
        self.assertEqual(len(route["steps"]), 6)
        self.assertEqual(route["steps"][-1]["storyId"], "story.khmer.angkor_wat_churning_relief")
        self.assertIn("never determine", route["evidencePolicy"])

    def test_public_snapshot_exposes_batch_history_and_comparisons_without_quotes(self):
        batches = self.snapshot["storyExpansionBatches"]
        self.assertEqual([batch["id"] for batch in batches], ["storybatch.v0300.02", "storybatch.v0280.01"])
        stories = {story["id"]: story for story in self.snapshot["stories"]}
        self.assertEqual(
            {story_id: len(stories[story_id]["witnessComparisons"]) for story_id in V030_STORIES},
            {
                "story.chinese.nuwa_repairs_sky": 4,
                "story.chinese.gonggong_buzhou": 2,
                "story.hindu.samudra_manthana_texts": 7,
            },
        )
        churning = stories["story.hindu.samudra_manthana_texts"]
        self.assertEqual(churning["versions"][0]["witnessProfile"]["languageId"], "lang.san")
        self.assertEqual(len(churning["conflicts"]), 1)
        serialized = json.dumps(self.snapshot, ensure_ascii=False)
        self.assertNotIn("shortQuote", serialized)
        self.assertNotIn("short_quote", serialized)

    def test_ui_switches_batches_and_links_current_offline_archive(self):
        library = (ROOT / "web" / "src" / "components" / "StoryLibrary.jsx").read_text(encoding="utf-8")
        tools = (ROOT / "web" / "src" / "components" / "StoryReaderTools.jsx").read_text(encoding="utf-8")
        styles = (ROOT / "web" / "src" / "styles.css").read_text(encoding="utf-8")
        storage = (ROOT / "web" / "src" / "readerStorage.js").read_text(encoding="utf-8")
        mobile = styles.split("@media (max-width: 760px)", 1)[1]
        self.assertIn('className="story-expansion-batches"', library)
        self.assertIn("aria-pressed={batch.id === expansionBatch.id}", library)
        self.assertIn("storyExpansionBatches.find((batch) => batch.id === selectedBatchId)", library)
        self.assertIn("repeat(auto-fit,minmax(150px,1fr))", styles)
        self.assertIn(".story-expansion-batches { margin-left: 0; }", mobile)
        self.assertIn(HTML_NAME, tools)
        self.assertIn(JSON_NAME, tools)
        self.assertTrue((ROOT / "web" / "public" / "offline" / HTML_NAME).is_file())
        # The local-state key is a storage schema, not a release label: keep it
        # stable so existing bookmarks and progress survive the upgrade.
        self.assertIn("wms-reader-v029", storage)


if __name__ == "__main__":
    unittest.main()
