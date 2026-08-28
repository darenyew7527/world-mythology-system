import json, sqlite3, unittest
from pathlib import Path
DB=Path(__file__).resolve().parents[1]/'database'/'world_mythology.sqlite'
class AncientNearEastTests(unittest.TestCase):
    def connect(self): c=sqlite3.connect(DB); c.row_factory=sqlite3.Row; return c
    def test_release(self):
        with self.connect() as c: self.assertEqual(c.execute('select name from schema_migrations where version=27').fetchone()[0],'20260827_v0200_ancient_near_east_witnesses')
    def test_claims_evidenced(self):
        with self.connect() as c: r=c.execute("select count(*) t,count(distinct e.claim_id) e from claims c left join evidence e on e.claim_id=c.id where c.id like 'claim.v0200.%'").fetchone()
        self.assertEqual(r['t'],19); self.assertEqual(r['t'],r['e'])
    def test_inanna_ishtar_not_merged(self):
        with self.connect() as c:
            ids={r[0] for r in c.execute("select id from entities where id in ('deity.sumerian.inanna','deity.akkadian.ishtar')")}
            guard=json.loads(c.execute("select metadata_json from entities where id='concept.mesopotamia.inanna_ishtar_identification'").fetchone()[0])
        self.assertEqual(len(ids),2); self.assertFalse(guard['merge_entities'])
    def test_baal_title_and_deity_distinct(self):
        with self.connect() as c: ids={r[0] for r in c.execute("select id from entities where id in ('concept.ugaritic.baal_title','deity.ugaritic.baal')")}
        self.assertEqual(len(ids),2)
    def test_anzu_layers_distinct(self):
        with self.connect() as c: ids={r[0] for r in c.execute("select id from entities where id in ('creature.akkadian.anzu','text.akkadian.anzu','artifact.mesopotamian.tablet_destinies')")}
        self.assertEqual(len(ids),3)
if __name__=='__main__': unittest.main()
