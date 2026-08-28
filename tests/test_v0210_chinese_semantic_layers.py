import json,sqlite3,unittest
from pathlib import Path
DB=Path(__file__).resolve().parents[1]/'database'/'world_mythology.sqlite'
class ChineseSemanticTests(unittest.TestCase):
 def connect(self): c=sqlite3.connect(DB);c.row_factory=sqlite3.Row;return c
 def test_release(self):
  with self.connect() as c:self.assertEqual(c.execute('select name from schema_migrations where version=29').fetchone()[0],'20260827_v0210_chinese_semantic_layers')
 def test_claims_evidenced(self):
  with self.connect() as c:r=c.execute("select count(*) t,count(distinct e.claim_id) e from claims c left join evidence e on e.claim_id=c.id where c.id like 'claim.v0210.%'").fetchone()
  self.assertEqual(r['t'],17);self.assertEqual(r['t'],r['e'])
 def test_semantic_layers_distinct(self):
  with self.connect() as c:
   a=json.loads(c.execute("select metadata_json from entities where id='concept.chinese.wuxing.hongfan_operations'").fetchone()[0]);b=json.loads(c.execute("select metadata_json from entities where id='concept.chinese.wuxing.han_correlative_omens'").fetchone()[0])
  self.assertNotEqual(a['semantic_layer'],b['semantic_layer']);self.assertFalse(b['same_as_hongfan'])
 def test_daoist_gap_not_invented(self):
  with self.connect() as c:r=c.execute("select status from collection_queue where id='queue.v0210.china.leigong_daoist'").fetchone()[0]
  self.assertEqual(r,'NEEDS_REVIEW')
 def test_mogao_sites_separate(self):
  with self.connect() as c:ids={r[0] for r in c.execute("select id from entities where id in ('site.chinese.mogao_cave_285','site.chinese.mogao_cave_249')")}
  self.assertEqual(len(ids),2)
if __name__=='__main__':unittest.main()
