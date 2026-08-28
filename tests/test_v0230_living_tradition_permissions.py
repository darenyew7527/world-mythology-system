import json,sqlite3,unittest
from pathlib import Path
DB=Path(__file__).resolve().parents[1]/'database'/'world_mythology.sqlite'
class LivingTraditionPermissionTests(unittest.TestCase):
 def connect(self):c=sqlite3.connect(DB);c.row_factory=sqlite3.Row;return c
 def test_release(self):
  with self.connect() as c:self.assertEqual(c.execute('select name from schema_migrations where version=32').fetchone()[0],'20260827_v0230_living_tradition_permissions')
 def test_claims_evidenced(self):
  with self.connect() as c:r=c.execute("select count(*) t,count(distinct e.claim_id) e from claims c left join evidence e on e.claim_id=c.id where c.id like 'claim.v0230.%'").fetchone()
  self.assertEqual(r['t'],11);self.assertEqual(r['t'],r['e'])
 def test_four_access_levels_persist(self):
  with self.connect() as c:levels={r[0] for r in c.execute('select distinct access_level from tradition_access_policies')}
  self.assertEqual(levels,{'PUBLIC_CONTEXT','ATTRIBUTION_REQUIRED','PERMISSION_REQUIRED','DO_NOT_COLLECT'})
 def test_ifa_hard_stop(self):
  with self.connect() as c:r=c.execute("select prohibited_scope from tradition_access_policies where id='policy.ifa.restricted' and access_level='DO_NOT_COLLECT'").fetchone()
  self.assertIsNotNone(r);self.assertIn('Secret verses',r[0])
 def test_maori_not_single_standard(self):
  with self.connect() as c:m=json.loads(c.execute("select metadata_json from entities where id='concept.maori.iwi_variant_scope'").fetchone()[0])
  self.assertFalse(m['single_standard_version'])
 def test_policy_table_exported(self):
  p=DB.parent.parent/'exports'/'jsonl'/'tradition_access_policies.jsonl';self.assertTrue(p.exists())
if __name__=='__main__':unittest.main()
