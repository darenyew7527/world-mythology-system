import json
import sqlite3
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "database" / "world_mythology.sqlite"


class DariusTextWitnessTests(unittest.TestCase):
    def connect(self):
        connection = sqlite3.connect(DB)
        connection.row_factory = sqlite3.Row
        return connection

    def test_release_and_migration(self):
        with self.connect() as connection:
            name = connection.execute(
                "SELECT name FROM schema_migrations WHERE version=22"
            ).fetchone()[0]
            data_version = connection.execute(
                "SELECT data_version FROM dataset_releases WHERE id='release.0.15.0'"
            ).fetchone()[0]
        self.assertEqual(name, "20260827_v0150_darius_text_witnesses")
        self.assertEqual(data_version, "0.15.0-darius-text-witnesses-20260827")

    def test_numbered_texts_are_editorial_witnesses(self):
        ids = [f"text.egypt.darius_susa.hieroglyph_text_{n}" for n in range(1, 5)]
        with self.connect() as connection:
            rows = connection.execute(
                f"SELECT id,metadata_json FROM entities WHERE id IN ({','.join('?' for _ in ids)})",
                ids,
            ).fetchall()
        self.assertEqual(len(rows), 4)
        for row in rows:
            metadata = json.loads(row["metadata_json"])
            self.assertEqual(metadata["witness_role"], "EDITORIAL_SEGMENT")
            self.assertIsNone(metadata["ancient_title"])

    def test_new_claims_all_have_evidence(self):
        with self.connect() as connection:
            counts = connection.execute(
                """SELECT COUNT(*) total,
                          COUNT(DISTINCT CASE WHEN e.id IS NOT NULL THEN c.id END) evidenced
                   FROM claims c LEFT JOIN evidence e ON e.claim_id=c.id
                   WHERE c.id LIKE 'claim.v0150.%'"""
            ).fetchone()
        self.assertEqual(counts["total"], 15)
        self.assertEqual(counts["evidenced"], counts["total"])

    def test_subject_sets_do_not_encode_modern_ethnicity(self):
        with self.connect() as connection:
            rows = connection.execute(
                "SELECT metadata_json FROM entities WHERE id LIKE 'text.egypt.darius_susa.subject_list.%'"
            ).fetchall()
            guard = connection.execute(
                "SELECT statement FROM claims WHERE id='claim.v0150.subject_mapping_guard'"
            ).fetchone()[0]
        self.assertEqual(len(rows), 2)
        self.assertTrue(all(json.loads(r[0])["mapping_guard"] == "ANCIENT_LABELS_FIRST" for r in rows))
        self.assertIn("ancient labels", guard)

    def test_yoyotte_pagination_is_corrected(self):
        with self.connect() as connection:
            source = connection.execute(
                "SELECT catalogue_number,doi FROM sources WHERE id='source.egypt.darius_hieroglyphs.yoyotte1973'"
            ).fetchone()
        self.assertIn("256-259", source["catalogue_number"])
        self.assertEqual(source["doi"], "10.3406/crai.1973.12879")


if __name__ == "__main__":
    unittest.main()
