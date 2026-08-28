import json, sqlite3, unittest
from pathlib import Path

DB = Path(__file__).resolve().parents[1] / "database" / "world_mythology.sqlite"

class EleusisNetworkTests(unittest.TestCase):
    def connect(self):
        c = sqlite3.connect(DB); c.row_factory = sqlite3.Row; return c

    def test_release_and_migration(self):
        with self.connect() as c:
            self.assertEqual(c.execute("select name from schema_migrations where version=24").fetchone()[0], "20260827_v0170_eleusis_network")
            self.assertEqual(c.execute("select data_version from dataset_releases where id='release.0.17.0'").fetchone()[0], "0.17.0-eleusis-network-20260827")

    def test_claims_are_evidenced(self):
        with self.connect() as c:
            row = c.execute("select count(*) t,count(distinct e.claim_id) e from claims c left join evidence e on e.claim_id=c.id where c.id like 'claim.v0170.%'").fetchone()
        self.assertEqual(row["t"], 16); self.assertEqual(row["t"], row["e"])

    def test_inscription_findspots_are_not_flattened(self):
        with self.connect() as c:
            rows = c.execute("select metadata_json from entities where id in ('text.greek.ieleusis71','text.greek.ieleusis72')").fetchall()
        self.assertEqual(len(rows), 2)
        self.assertTrue(all(json.loads(r[0])["findspot_scope"] == "ELEUSIS_NOT_SANCTUARY" for r in rows))

    def test_ninnion_keeps_secrecy_guard(self):
        with self.connect() as c:
            metadata = json.loads(c.execute("select metadata_json from entities where id='museum.nam.ninnion_tablet_a11036'").fetchone()[0])
            claim = c.execute("select claim_status from claims where id='claim.v0170.ninnion_secrecy_limit'").fetchone()[0]
        self.assertEqual(metadata["secrecy_guard"], "ICONOGRAPHY_IS_NOT_COMPLETE_RITUAL_DISCLOSURE")
        self.assertEqual(claim, "INTERPRETIVE")

    def test_copy_network_does_not_merge_objects(self):
        with self.connect() as c:
            members = c.execute("select count(*) from claims where subject_id='concept.greek.eleusinian_relief_copy_network' and predicate='HAS_MEMBER'").fetchone()[0]
            redirects = c.execute("select count(*) from entity_redirects where duplicate_entity_id in ('museum.nam.great_eleusinian_relief_126','museum.met.eleusinian_relief_14_130_9')").fetchone()[0]
        self.assertEqual(members, 2); self.assertEqual(redirects, 0)

if __name__ == "__main__": unittest.main()
