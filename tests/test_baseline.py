from __future__ import annotations

import csv
import json
import shutil
import sys
import tempfile
import unittest
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT))
sys.path.insert(0, str(PROJECT_ROOT / "src"))

from world_mythology.builder import _refresh_evidence_status, build_database
from world_mythology.db import connect
from world_mythology.db import sha256_file
from world_mythology.exporter import export_all, persistent_tables
from world_mythology.maintenance import check_sources, import_queue_jsonl, next_queue_batch
from world_mythology.migrations import apply_migrations
from world_mythology.validation import validate_database


class BaselineDatabaseTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.tempdir = tempfile.TemporaryDirectory()
        cls.root = Path(cls.tempdir.name)
        cls.db_path = build_database(cls.root / "world_mythology.sqlite")

    @classmethod
    def tearDownClass(cls) -> None:
        cls.tempdir.cleanup()

    def connection(self):
        return connect(self.db_path, readonly=True)

    def test_sqlite_integrity_and_foreign_keys(self) -> None:
        with self.connection() as conn:
            self.assertEqual(conn.execute("PRAGMA integrity_check").fetchone()[0], "ok")
            self.assertEqual(conn.execute("PRAGMA foreign_key_check").fetchall(), [])

    def test_first_round_scope_is_substantial_but_not_claimed_complete(self) -> None:
        with self.connection() as conn:
            self.assertGreaterEqual(conn.execute("SELECT COUNT(*) FROM civilizations").fetchone()[0], 90)
            self.assertGreaterEqual(conn.execute("SELECT COUNT(*) FROM cultures").fetchone()[0], 15)
            self.assertGreaterEqual(conn.execute("SELECT COUNT(*) FROM entities").fetchone()[0], 350)
            policy = conn.execute("SELECT value FROM project_metadata WHERE key='completion_policy'").fetchone()[0]
            self.assertEqual(policy, "NO_ALL_COMPLETE")

    def test_expected_seed_collections(self) -> None:
        with self.connection() as conn:
            counts = {name: conn.execute(f"SELECT COUNT(*) FROM {name}").fetchone()[0]
                      for name in ("deities", "artifacts", "elements", "texts", "archaeological_sites", "sources")}
            self.assertGreaterEqual(counts["deities"], 90)
            self.assertGreaterEqual(counts["artifacts"], 30)
            self.assertGreaterEqual(counts["elements"], 20)
            self.assertGreaterEqual(counts["texts"], 90)
            self.assertGreaterEqual(counts["archaeological_sites"], 40)
            self.assertGreaterEqual(counts["sources"], 70)

    def test_unicode_round_trip(self) -> None:
        with self.connection() as conn:
            expected = {
                "weapon.norse.mjolnir": "Mjölnir",
                "creature.norse.jormungandr": "Jörmungandr",
                "text.norse.havamal": "Hávamál",
                "text.babylonian.enuma_elish": "Enūma Eliš",
                "deity.chinese.nu_wa": "女娲",
                "weapon.japanese.amenonuhoko": "天沼矛",
            }
            for entity_id, value in expected.items():
                row = conn.execute("SELECT canonical_name,name_zh FROM entities WHERE id=?", (entity_id,)).fetchone()
                self.assertIn(value, {row[0], row[1]})

    def test_priority_traditions_have_language_links(self) -> None:
        with self.connection() as conn:
            self.assertGreaterEqual(conn.execute("SELECT COUNT(*) FROM civilization_languages").fetchone()[0], 20)
            self.assertIsNotNone(conn.execute(
                """SELECT 1 FROM civilization_languages
                   WHERE civilization_id='civ.ugaritic' AND language_id='lang.uga'"""
            ).fetchone())

    def test_multitype_guardrails(self) -> None:
        with self.connection() as conn:
            expected = {
                ("being.norse.ymir", "GIANT", "PRIMORDIAL_DEITY"),
                ("deity.egyptian.ma_at", "DEITY", "CONCEPT"),
                ("deity.babylonian.tiamat", "PRIMORDIAL_DEITY", "DRAGON"),
            }
            for entity_id, primary, extra in expected:
                self.assertEqual(conn.execute("SELECT primary_type FROM entities WHERE id=?", (entity_id,)).fetchone()[0], primary)
                self.assertIsNotNone(conn.execute(
                    "SELECT 1 FROM entity_classifications WHERE entity_id=? AND type_code=?", (entity_id, extra)
                ).fetchone())

    def test_secondary_classifications_drive_views_and_profiles(self) -> None:
        expected_memberships = {
            "deity.ugaritic.yam": ("concepts", "deity_profiles"),
            "deity.yoruba.orunmila": ("deities", "deity_profiles"),
            "deity.babylonian.tiamat": ("creatures", "creature_profiles"),
            "being.norse.ymir": ("deities", "deity_profiles"),
            "being.chinese.pangu": ("deities", "deity_profiles"),
        }
        with self.connection() as conn:
            for entity_id, (view_name, profile_name) in expected_memberships.items():
                self.assertIsNotNone(conn.execute(
                    f'SELECT 1 FROM "{view_name}" WHERE id=?', (entity_id,)
                ).fetchone(), f"{entity_id} missing from {view_name}")
                self.assertIsNotNone(conn.execute(
                    f'SELECT 1 FROM "{profile_name}" WHERE entity_id=?', (entity_id,)
                ).fetchone(), f"{entity_id} missing from {profile_name}")

    def test_relationships_are_claim_projection(self) -> None:
        with self.connection() as conn:
            relationship_count = conn.execute("SELECT COUNT(*) FROM relationships").fetchone()[0]
            relational_claims = conn.execute(
                """SELECT COUNT(*) FROM claims c JOIN relationship_types rt ON rt.code=c.predicate
                   WHERE c.object_entity_id IS NOT NULL AND c.review_status<>'REJECTED'"""
            ).fetchone()[0]
            self.assertEqual(relationship_count, relational_claims)

    def test_inverse_relationship_query(self) -> None:
        expected = [
            ("deity.greek.zeus", "CHILD_OF", "deity.greek.cronus"),
            ("deity.greek.zeus", "CHILD_OF", "deity.greek.rhea"),
            ("deity.norse.odin", "KILLED_BY", "creature.norse.fenrir"),
            ("weapon.norse.gungnir", "OWNED_BY", "deity.norse.odin"),
        ]
        with self.connection() as conn:
            for source, relation, target in expected:
                row = conn.execute(
                    """SELECT 1 FROM relationship_edges_bidirectional
                       WHERE source_entity_id=? AND relationship_type=? AND target_entity_id=?""",
                    (source, relation, target),
                ).fetchone()
                self.assertIsNotNone(row)

    def test_symmetric_relationship_query_has_reverse_edge(self) -> None:
        with self.connection() as conn:
            reverse = conn.execute(
                """SELECT is_inferred_inverse FROM relationship_edges_bidirectional
                   WHERE source_entity_id='deity.ugaritic.yam'
                     AND relationship_type='ENEMY_OF'
                     AND target_entity_id='deity.ugaritic.baal'"""
            ).fetchone()
            self.assertIsNotNone(reverse)
            self.assertEqual(reverse[0], 1)

    def test_source_backed_requires_evidence_for_every_claim(self) -> None:
        test_db = self.root / "mixed-evidence.sqlite"
        shutil.copy2(self.db_path, test_db)
        with connect(test_db) as conn:
            self.assertEqual(conn.execute(
                "SELECT evidence_status FROM entities WHERE id='deity.egyptian.ra'"
            ).fetchone()[0], "SOURCE_BACKED")
            conn.execute(
                """INSERT INTO claims(
                       id,subject_id,predicate,object_literal,object_datatype,statement,
                       claim_status,confidence,confidence_level,review_status,assertion_scope,
                       knowledge_layer,created_at
                   ) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                (
                    "claim.test.ra.unsourced", "deity.egyptian.ra", "RESEARCH_NOTE",
                    "pending", "STRING", "Deliberately unsourced regression fixture.",
                    "UNRESOLVED", 0.1, "LOW", "UNVERIFIED", "SCHOLARLY_INTERPRETATION",
                    "SCHOLARLY_INTERPRETATION", "2026-08-10T00:00:00Z",
                ),
            )
            _refresh_evidence_status(conn)
            self.assertEqual(conn.execute(
                "SELECT evidence_status FROM entities WHERE id='deity.egyptian.ra'"
            ).fetchone()[0], "PARTIAL")

    def test_verified_claims_have_evidence(self) -> None:
        with self.connection() as conn:
            rows = conn.execute(
                """SELECT c.id FROM claims c LEFT JOIN evidence e ON e.claim_id=c.id
                   WHERE c.review_status='VERIFIED' GROUP BY c.id HAVING COUNT(e.id)=0"""
            ).fetchall()
            self.assertEqual(rows, [])

    def test_unverified_element_crosswalks_remain_unpromoted(self) -> None:
        with self.connection() as conn:
            rows = conn.execute(
                """SELECT review_status,COUNT(*) FROM claims
                   WHERE id LIKE 'claim.wuxing.member.%' OR id LIKE 'claim.pancamahabhuta.member.%'
                   GROUP BY review_status"""
            ).fetchall()
            self.assertEqual([(row[0], row[1]) for row in rows], [("UNVERIFIED", 10)])

    def test_same_manuscript_access_points_are_linked(self) -> None:
        with self.connection() as conn:
            pairs = {(row[0], row[1]) for row in conn.execute(
                "SELECT id,same_witness_as_source_id FROM sources WHERE same_witness_as_source_id IS NOT NULL"
            )}
            self.assertIn(("source.mexica.florentine.loc", "source.mexica.florentine.getty"), pairs)
            self.assertIn(("source.slavic.laurentian.unesco", "source.slavic.laurentian.nlr"), pairs)

    def test_living_tradition_source_governance(self) -> None:
        with self.connection() as conn:
            ifa = conn.execute("SELECT * FROM sources WHERE id='source.yoruba.ifa.unesco'").fetchone()
            self.assertEqual(ifa["living_tradition"], 1)
            self.assertEqual(ifa["community_permission_required"], 1)
            self.assertTrue(ifa["access_or_reuse_restrictions"])

    def test_conflict_versions_coexist(self) -> None:
        with self.connection() as conn:
            conflict = conn.execute("SELECT * FROM conflicts WHERE id='conflict.met_21_88_52.identity'").fetchone()
            self.assertEqual(conflict["status"], "OPEN")
            claims = conn.execute("SELECT COUNT(*) FROM claims WHERE variant_group='met.21_88_52.identity'").fetchone()[0]
            self.assertEqual(claims, 2)

    def test_validation_has_no_blocking_findings(self) -> None:
        result = validate_database(self.db_path, persist=False)
        self.assertEqual(result["blocking"], 0, result)

    def test_source_syntax_and_context_checks(self) -> None:
        result = check_sources(self.db_path)
        self.assertEqual(result["status"], "PASS", result)
        self.assertEqual(result["web_confirmed"], 0)
        self.assertEqual(result["source_count"], result["url_syntax_valid"] + result["registered"])

    def test_web_confirmation_requires_reproducible_receipt(self) -> None:
        test_db = self.root / "receipt-check.sqlite"
        shutil.copy2(self.db_path, test_db)
        with connect(test_db) as conn:
            conn.execute(
                "UPDATE sources SET verification_status='WEB_CONFIRMED',notes=NULL WHERE id='source.unesco.olympia.517'"
            )
            conn.commit()
        result = check_sources(test_db)
        self.assertEqual(result["status"], "NEEDS_REVIEW")
        self.assertIn("WEB_CONFIRMED_WITHOUT_RECEIPT", {item["code"] for item in result["problems"]})

        receipt = {
            "checked_at": "2026-08-10T00:00:00Z",
            "method": "BROWSER_OPEN",
            "locator": "https://whc.unesco.org/en/list/517/",
            "outcome": "REACHABLE",
        }
        with connect(test_db) as conn:
            conn.execute(
                "UPDATE sources SET notes=? WHERE id='source.unesco.olympia.517'",
                ("VERIFICATION_RECEIPT_JSON=" + json.dumps(receipt, separators=(",", ":")),),
            )
            conn.commit()
        self.assertEqual(check_sources(test_db)["status"], "PASS")

    def test_url_less_catalogue_locator_is_valid(self) -> None:
        test_db = self.root / "catalogue-locator.sqlite"
        shutil.copy2(self.db_path, test_db)
        with connect(test_db) as conn:
            conn.execute(
                "UPDATE sources SET url=NULL,verification_status='REGISTERED' WHERE id='source.unesco.olympia.517'"
            )
            conn.commit()
        result = check_sources(test_db)
        self.assertEqual(result["status"], "PASS", result)

    def test_queue_selects_priority_without_infinite_loop(self) -> None:
        batch = next_queue_batch(self.db_path, limit=7)
        self.assertEqual(len(batch), 7)
        self.assertGreaterEqual(batch[0]["priority"], batch[-1]["priority"])
        self.assertNotIn(batch[0]["status"], {"BASELINE_COMPLETE", "COLLECTING"})

    def test_queue_import_keeps_per_line_and_discovery_audit(self) -> None:
        private_folder = self.root / "private-maintainer-folder"
        private_folder.mkdir(exist_ok=True)
        queue_file = private_folder / "queue-import.jsonl"
        secret_marker = "SYNTHETIC_PRIVATE_MARKER_MUST_NOT_PERSIST"
        queue_file.write_text(
            json.dumps({"target_label": "Sentinel Queue Import", "proposed_entity_type": "DEITY",
                        "discovery_context": "Regression test", "priority": 41}) + "\n" +
            json.dumps({"target_label": f"Missing type {secret_marker}"}) + "\n" +
            json.dumps({"target_label": "Broken FK Import", "proposed_entity_type": "DEITY",
                        "civilization_id": "civilization.does_not_exist"}) + "\n",
            encoding="utf-8",
        )
        result = import_queue_jsonl(queue_file, self.db_path, apply=True)
        self.assertEqual(result["input"], queue_file.name)
        self.assertNotIn(secret_marker, json.dumps(result))
        self.assertNotIn(str(private_folder), json.dumps(result))
        self.assertEqual(result["inserted"], 1)
        self.assertEqual(len(result["errors"]), 2)
        with self.connection() as conn:
            queue_id = conn.execute(
                "SELECT id FROM collection_queue WHERE normalized_label='sentinel queue import'"
            ).fetchone()[0]
            self.assertEqual(conn.execute(
                "SELECT COUNT(*) FROM queue_discoveries WHERE queue_id=?", (queue_id,)
            ).fetchone()[0], 1)
            self.assertEqual(conn.execute(
                "SELECT COUNT(*) FROM queue_status_history WHERE queue_id=?", (queue_id,)
            ).fetchone()[0], 1)
            self.assertEqual(conn.execute(
                "SELECT COUNT(*) FROM import_errors WHERE import_run_id=?", (result["run_id"],)
            ).fetchone()[0], 2)
            source_path = conn.execute(
                "SELECT source_path FROM import_runs WHERE id=?", (result["run_id"],)
            ).fetchone()[0]
            raw_payloads = [row[0] for row in conn.execute(
                "SELECT raw_payload FROM import_errors WHERE import_run_id=?", (result["run_id"],)
            )]
            self.assertEqual(source_path, queue_file.name)
            self.assertTrue(all(value.startswith("REDACTED_PAYLOAD;") for value in raw_payloads))
            persisted = source_path + "\n" + "\n".join(raw_payloads)
            self.assertNotIn(secret_marker, persisted)
            self.assertNotIn(str(private_folder), persisted)
            self.assertEqual(conn.execute(
                "SELECT COUNT(*) FROM collection_queue WHERE normalized_label='broken fk import'"
            ).fetchone()[0], 0)

        export_root = self.root / "privacy-safe-exports"
        export_all(self.db_path, export_root)
        export_text = (export_root / "jsonl" / "import_runs.jsonl").read_text(encoding="utf-8")
        export_text += (export_root / "jsonl" / "import_errors.jsonl").read_text(encoding="utf-8")
        self.assertNotIn(secret_marker, export_text)
        self.assertNotIn(str(private_folder), export_text)

    def test_exports_are_parseable_and_count_preserving(self) -> None:
        export_root = self.root / "exports"
        stale_jsonl = export_root / "jsonl" / "removed_table.jsonl"
        stale_csv = export_root / "csv" / "removed_table.csv"
        stale_jsonl.parent.mkdir(parents=True)
        stale_csv.parent.mkdir(parents=True)
        stale_jsonl.write_text("stale\n", encoding="utf-8")
        stale_csv.write_text("stale\n", encoding="utf-8")
        manifest = export_all(self.db_path, export_root)
        self.assertEqual(manifest["database_sha256"], sha256_file(self.db_path))
        with self.connection() as conn:
            current_version = conn.execute(
                "SELECT data_version FROM dataset_releases ORDER BY built_at DESC,id DESC LIMIT 1"
            ).fetchone()[0]
            expected_tables = persistent_tables(conn)
        self.assertEqual(manifest["release"]["data_version"], current_version)
        self.assertEqual(manifest["tables"], expected_tables)
        self.assertEqual(set(manifest["counts"]), set(expected_tables))
        self.assertFalse(stale_jsonl.exists())
        self.assertFalse(stale_csv.exists())
        with self.connection() as conn:
            for table in expected_tables:
                jsonl_path = export_root / "jsonl" / f"{table}.jsonl"
                csv_path = export_root / "csv" / f"{table}.csv"
                json_rows = [json.loads(line) for line in jsonl_path.read_text(encoding="utf-8").splitlines()]
                columns = [row[1] for row in conn.execute(f'PRAGMA table_info("{table}")')]
                expected_rows = [dict(row) for row in conn.execute(f'SELECT * FROM "{table}"')]
                if columns:
                    expected_rows.sort(key=lambda row: str(row.get(columns[0], "")))
                with csv_path.open(encoding="utf-8", newline="") as handle:
                    csv_rows = list(csv.DictReader(handle))
                self.assertEqual(json_rows, expected_rows, f"JSONL round trip: {table}")
                expected_csv = [
                    {key: "" if value is None else str(value) for key, value in row.items()}
                    for row in expected_rows
                ]
                self.assertEqual(csv_rows, expected_csv, f"CSV round trip: {table}")
        self.assertNotIn("relationships", manifest["tables"])
        expected_manifest_paths = {
            *(f"jsonl/{table}.jsonl" for table in expected_tables),
            *(f"csv/{table}.csv" for table in expected_tables),
            "graph/knowledge_graph.json", "graph/relationships.csv", "graph/knowledge_graph.graphml",
        }
        self.assertEqual({item["path"] for item in manifest["files"]}, expected_manifest_paths)
        graph = json.loads((export_root / "graph" / "knowledge_graph.json").read_text(encoding="utf-8"))
        self.assertEqual(len(graph["nodes"]), manifest["counts"]["entities"])
        self.assertEqual(len(graph["nodes"]), manifest["graph_counts"]["nodes"])
        self.assertEqual(len(graph["edges"]), manifest["graph_counts"]["edges"])
        self.assertTrue(graph["edges"])
        self.assertTrue({"claim_id", "review_status", "assertion_scope", "knowledge_layer", "evidence_count"}
                        <= set(graph["edges"][0]))

    def test_daily_pipeline_preserves_existing_sentinel(self) -> None:
        from scripts.run_pipeline import prepare_database, run_pipeline

        with connect(self.db_path) as conn:
            conn.execute(
                """INSERT INTO project_metadata(key,value,updated_at)
                   VALUES('test.persistent_sentinel','keep-me','2026-08-10T00:00:00Z')
                   ON CONFLICT(key) DO UPDATE SET value=excluded.value,updated_at=excluded.updated_at"""
            )
        resolved = prepare_database(self.db_path)
        self.assertEqual(resolved, self.db_path)
        run_pipeline(resolved, export_root=self.root / "pipeline-exports", generate_reading_outputs=False)
        with self.connection() as conn:
            value = conn.execute(
                "SELECT value FROM project_metadata WHERE key='test.persistent_sentinel'"
            ).fetchone()[0]
        self.assertEqual(value, "keep-me")

    def test_research_migrations_are_replayable_and_idempotent(self) -> None:
        migration_db = build_database(self.root / "migration-replay.sqlite")
        first = apply_migrations(migration_db)
        second = apply_migrations(migration_db)
        self.assertTrue(any(item["version"] == 2 for item in first))
        self.assertEqual(second, [])
        with connect(migration_db, readonly=True) as conn:
            self.assertIsNotNone(conn.execute(
                "SELECT 1 FROM entities WHERE id='creature.greek.typhon'"
            ).fetchone())
            self.assertEqual(conn.execute(
                "SELECT COUNT(*) FROM schema_migrations WHERE version=2"
            ).fetchone()[0], 1)

    def test_wuxing_native_components_are_not_generic_element_merges(self) -> None:
        apply_migrations(self.db_path)
        with self.connection() as conn:
            native_ids = {
                row[0] for row in conn.execute(
                    """SELECT e.id FROM entities e
                       WHERE e.id LIKE 'element.chinese.%'
                         AND json_extract(e.metadata_json,'$.native_system')='concept.chinese.wuxing'"""
                )
            }
            self.assertEqual(len(native_ids), 5)
            self.assertNotIn("concept.comparative.water", native_ids)
            self.assertEqual(conn.execute(
                "SELECT COUNT(*) FROM relationships WHERE relationship_type='ELEMENT_OF' "
                "AND target_entity_id='concept.chinese.wuxing'"
            ).fetchone()[0], 5)
            self.assertEqual(conn.execute(
                "SELECT COUNT(*) FROM entity_redirects WHERE duplicate_entity_id LIKE 'concept.chinese.wuxing.%'"
            ).fetchone()[0], 5)

    def test_pipeline_requires_explicit_database_lifecycle(self) -> None:
        from scripts.run_pipeline import prepare_database

        missing = self.root / "explicit-lifecycle.sqlite"
        with self.assertRaises(FileNotFoundError):
            prepare_database(missing)
        self.assertFalse(missing.exists())
        created = prepare_database(missing, init=True)
        self.assertEqual(created, missing)
        self.assertTrue(missing.exists())
        with self.assertRaises(FileExistsError):
            prepare_database(missing, init=True)

    def test_rebuild_replaces_generated_database_safely(self) -> None:
        rebuilt = build_database(self.db_path)
        self.assertEqual(rebuilt, self.db_path)
        with self.connection() as conn:
            self.assertGreater(conn.execute("SELECT COUNT(*) FROM entities").fetchone()[0], 350)


if __name__ == "__main__":
    unittest.main()
