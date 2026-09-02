import hashlib
import json
import sqlite3
import tempfile
import unittest
from pathlib import Path

from scripts.generate_offline_archive import HTML_NAME, JSON_NAME, generate
from scripts.generate_web_data import build_snapshot


ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "database" / "world_mythology.sqlite"


class ReaderOfflineArchiveTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.snapshot = build_snapshot(DB)

    def connect(self):
        connection = sqlite3.connect(DB)
        connection.row_factory = sqlite3.Row
        return connection

    def test_schema_39_registers_zero_collection_reader_contracts(self):
        with self.connect() as connection:
            migration = connection.execute(
                "SELECT name FROM schema_migrations WHERE version=39"
            ).fetchone()
            rows = connection.execute(
                "SELECT * FROM reader_feature_registry ORDER BY feature_code"
            ).fetchall()
        self.assertEqual(migration["name"], "20260902_v0290_reader_offline_archive")
        self.assertEqual(len(rows), 5)
        self.assertTrue(all(row["public_database_writes"] == 0 for row in rows))
        self.assertTrue(all(row["personal_data_collection"] == 0 for row in rows))
        self.assertEqual(
            {row["storage_scope"] for row in rows},
            {"LOCAL_ONLY", "STATIC_PUBLIC_ARTIFACT"},
        )

    def test_public_snapshot_exposes_privacy_contract_not_reading_activity(self):
        meta = self.snapshot["meta"]
        self.assertEqual(meta["projectVersion"], "0.29.0-reader-offline-archive")
        self.assertEqual(meta["dataVersion"], "0.29.0")
        self.assertEqual(meta["counts"]["readerFeatures"], 5)
        self.assertEqual(len(self.snapshot["readerFeatures"]), 5)
        self.assertTrue(
            all(not item["publicDatabaseWrites"] for item in self.snapshot["readerFeatures"])
        )
        self.assertTrue(
            all(not item["personalDataCollection"] for item in self.snapshot["readerFeatures"])
        )
        self.assertNotIn("wms-reader-v029", json.dumps(self.snapshot, ensure_ascii=False))

    def test_schema_40_seals_v029_as_latest_release(self):
        with self.connect() as connection:
            migration = connection.execute(
                "SELECT name FROM schema_migrations WHERE version=40"
            ).fetchone()
            release = connection.execute(
                "SELECT schema_version,data_version FROM dataset_releases "
                "WHERE id='release.v0.29.0'"
            ).fetchone()
            introduced = {
                row[0]
                for row in connection.execute(
                    "SELECT introduced_in FROM reader_feature_registry"
                )
            }
        checkpoint = json.loads(
            (ROOT / "reports" / "checkpoint.json").read_text(encoding="utf-8")
        )
        manifest = json.loads(
            (ROOT / "exports" / "manifest.json").read_text(encoding="utf-8")
        )
        self.assertEqual(migration["name"], "20260902_v0290_reader_offline_archive_release")
        self.assertEqual(dict(release), {"schema_version": 40, "data_version": "0.29.0"})
        self.assertEqual(introduced, {"v0.29.0"})
        self.assertEqual(checkpoint["snapshot_status"], "SEALED_RELEASE")
        self.assertEqual(checkpoint["release_id"], "release.v0.29.0")
        self.assertEqual(manifest["snapshot_status"], "SEALED_RELEASE")
        self.assertEqual(manifest["latest_sealed_release"]["data_version"], "0.29.0")

    def test_versioned_local_storage_and_accessible_controls_are_wired(self):
        storage = (ROOT / "web" / "src" / "readerStorage.js").read_text(encoding="utf-8")
        tools = (ROOT / "web" / "src" / "components" / "StoryReaderTools.jsx").read_text(encoding="utf-8")
        library = (ROOT / "web" / "src" / "components" / "StoryLibrary.jsx").read_text(encoding="utf-8")
        styles = (ROOT / "web" / "src" / "styles.css").read_text(encoding="utf-8")
        self.assertIn("wms-reader-v029", storage)
        self.assertIn("schemaVersion: 1", storage)
        self.assertIn("window.localStorage.setItem", storage)
        self.assertIn("aria-pressed={isBookmarked}", tools)
        self.assertIn("<progress aria-label={copy.progress}", tools)
        self.assertIn("highContrast", tools)
        self.assertIn("StoryReaderTools", library)
        self.assertIn("story-progress-marker", library)
        self.assertIn("@media print", styles)
        self.assertIn("@media (max-width: 760px)", styles)
        self.assertIn(":focus-visible", styles)

    def test_offline_archive_is_self_contained_and_matches_story_checkpoint(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            manifest = generate(DB, root / "offline", root / "manifest.json")
            html_path = root / "offline" / HTML_NAME
            json_path = root / "offline" / JSON_NAME
            html_text = html_path.read_text(encoding="utf-8")
            archive = json.loads(json_path.read_text(encoding="utf-8"))

        self.assertEqual(
            manifest["counts"],
            {"stories": 26, "storyVersions": 29, "storySections": 89, "readingRoutes": 6},
        )
        self.assertEqual(len(archive["stories"]), self.snapshot["meta"]["counts"]["stories"])
        self.assertEqual(archive["artifactVersion"], "0.29.0")
        self.assertEqual(archive["privacyModel"], "NO_PERSONAL_READING_STATE; PUBLIC_SNAPSHOT_ONLY")
        self.assertIn("Source and rights", html_text)
        self.assertIn("Evidence / 证据", html_text)
        self.assertIn("reuseRestrictions", json.dumps(archive, ensure_ascii=False))
        self.assertNotIn("<script src=", html_text)
        self.assertNotIn("<link rel=\"stylesheet\"", html_text)
        self.assertNotIn("shortQuote", json.dumps(archive, ensure_ascii=False))
        self.assertNotIn("short_quote", json.dumps(archive, ensure_ascii=False))
        self.assertEqual(
            manifest["artifacts"][HTML_NAME]["sha256"],
            hashlib.sha256(html_text.encode("utf-8")).hexdigest(),
        )

    def test_committed_archive_manifest_matches_current_database_and_files(self):
        manifest = json.loads(
            (ROOT / "reports" / "offline_archive_manifest.json").read_text(encoding="utf-8")
        )
        database_hash = hashlib.sha256(DB.read_bytes()).hexdigest()
        self.assertEqual(manifest["databaseSha256"], database_hash)
        for name, metadata in manifest["artifacts"].items():
            path = ROOT / "web" / "public" / "offline" / name
            self.assertTrue(path.is_file())
            self.assertEqual(metadata["bytes"], path.stat().st_size)
            self.assertEqual(metadata["sha256"], hashlib.sha256(path.read_bytes()).hexdigest())


if __name__ == "__main__":
    unittest.main()
