import json, sqlite3, unittest
from pathlib import Path
DB = Path(__file__).resolve().parents[1] / 'database' / 'world_mythology.sqlite'

class JapaneseThunderWitnessTests(unittest.TestCase):
    def connect(self):
        c=sqlite3.connect(DB); c.row_factory=sqlite3.Row; return c
    def test_release(self):
        with self.connect() as c:
            self.assertEqual(c.execute('select name from schema_migrations where version=25').fetchone()[0],'20260827_v0180_japanese_thunder_witnesses')
    def test_claims_evidenced(self):
        with self.connect() as c:
            r=c.execute("select count(*) t,count(distinct e.claim_id) e from claims c left join evidence e on e.claim_id=c.id where c.id like 'claim.v0180.%'").fetchone()
        self.assertEqual(r['t'],22); self.assertEqual(r['t'],r['e'])
    def test_karaijin_not_merged(self):
        with self.connect() as c:
            ids={r[0] for r in c.execute("select id from entities where id in ('deity.japanese.karaijin','deity.japanese.raijin','deity.japanese.kamo_wakeikazuchi')")}
            ident=c.execute("select count(*) from claims where subject_id='deity.japanese.karaijin' and predicate='IDENTIFIED_WITH'").fetchone()[0]
        self.assertEqual(len(ids),3); self.assertEqual(ident,0)
    def test_fragment_is_not_complete_manuscript(self):
        with self.connect() as c:
            m=json.loads(c.execute("select metadata_json from entities where id='text.japan.yamashiro_fudoki_kamo_fragment'").fetchone()[0])
        self.assertFalse(m['complete_manuscript']); self.assertEqual(m['witness_role'],'QUOTED_FRAGMENT')
    def test_screen_objects_remain_distinct(self):
        with self.connect() as c:
            relation=c.execute("select count(*) from claims where id='claim.v0180.korin_copy_sotatsu' and predicate='LATER_COPY_OF'").fetchone()[0]
            profile=c.execute("select catalogue_number from museum_object_profiles where entity_id='museum.tnm.korin_wind_thunder_a11189_1'").fetchone()[0]
        self.assertEqual(relation,1); self.assertEqual(profile,'A-11189-1')

if __name__=='__main__': unittest.main()
