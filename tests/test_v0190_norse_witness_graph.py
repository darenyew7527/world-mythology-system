import json, sqlite3, unittest
from pathlib import Path
DB=Path(__file__).resolve().parents[1]/'database'/'world_mythology.sqlite'
class NorseWitnessGraphTests(unittest.TestCase):
    def connect(self):
        c=sqlite3.connect(DB); c.row_factory=sqlite3.Row; return c
    def test_release(self):
        with self.connect() as c: self.assertEqual(c.execute('select name from schema_migrations where version=26').fetchone()[0],'20260827_v0190_norse_witness_graph')
    def test_claims_evidenced(self):
        with self.connect() as c: r=c.execute("select count(*) t,count(distinct e.claim_id) e from claims c left join evidence e on e.claim_id=c.id where c.id like 'claim.v0190.%'").fetchone()
        self.assertEqual(r['t'],17); self.assertEqual(r['t'],r['e'])
    def test_creation_triads_not_merged(self):
        with self.connect() as c:
            rows=c.execute("select object_literal from claims where id in ('claim.v0190.voluspa_triad','claim.v0190.gylf_triad') order by id").fetchall()
            merges=c.execute("select count(*) from claims where predicate='IDENTIFIED_WITH' and subject_id in ('deity.norse.hoenir','deity.norse.lodurr')").fetchone()[0]
        self.assertEqual(len(rows),2); self.assertNotEqual(rows[0][0],rows[1][0]); self.assertEqual(merges,0)
    def test_sindri_eitri_open_conflict(self):
        with self.connect() as c:
            ids={r[0] for r in c.execute("select id from entities where id in ('being.norse.sindri','being.norse.eitri')")}
            status=c.execute("select status from conflicts where id='conflict.v0190.sindri_eitri'").fetchone()[0]
        self.assertEqual(len(ids),2); self.assertEqual(status,'OPEN')
    def test_witness_harmonization_guard(self):
        with self.connect() as c:
            a=json.loads(c.execute("select metadata_json from entities where id='text.norse.voluspa.st17_18'").fetchone()[0])
            b=json.loads(c.execute("select metadata_json from entities where id='text.norse.gylfaginning.ch8_9'").fetchone()[0])
        self.assertFalse(a['harmonize_with_prose_edda']); self.assertFalse(b['harmonize_with_voluspa'])
if __name__=='__main__': unittest.main()
