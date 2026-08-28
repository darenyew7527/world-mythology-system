import json,sqlite3,unittest
from pathlib import Path
DB=Path(__file__).resolve().parents[1]/'database'/'world_mythology.sqlite'
class VajraReceptionTests(unittest.TestCase):
 def connect(self):c=sqlite3.connect(DB);c.row_factory=sqlite3.Row;return c
 def test_release(self):
  with self.connect() as c:self.assertEqual(c.execute('select name from schema_migrations where version=31').fetchone()[0],'20260827_v0220_vajra_reception_layers')
 def test_claims_evidenced(self):
  with self.connect() as c:r=c.execute("select count(*) t,count(distinct e.claim_id) e from claims c left join evidence e on e.claim_id=c.id where c.id like 'claim.v0220.%'").fetchone()
  self.assertEqual(r['t'],16);self.assertEqual(r['t'],r['e'])
 def test_objects_not_weapon(self):
  with self.connect() as c:
   objects={r[0] for r in c.execute("select id from entities where id like 'museum.%vajra%' and created_at='2026-08-27T15:00:00Z'")};m=json.loads(c.execute("select metadata_json from entities where id='concept.south_asia.vajra_reception_layers'").fetchone()[0])
  self.assertEqual(len(objects),3);self.assertFalse(m['shared_physical_identity'])
 def test_jain_gap_explicit(self):
  with self.connect() as c:r=c.execute("select status from collection_queue where id='queue.v0220.vajra.jain_objects'").fetchone()[0]
  self.assertEqual(r,'NEEDS_REVIEW')
if __name__=='__main__':unittest.main()
