import json
import sqlite3
import subprocess
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DATABASE = ROOT / "database" / "world_mythology.sqlite"
WEB = ROOT / "web"


def run_node(source: str):
    completed = subprocess.run(
        ["node", "--input-type=module", "--eval", source],
        cwd=WEB,
        check=True,
        capture_output=True,
        text=True,
    )
    return json.loads(completed.stdout)


class MobileGraphV051Tests(unittest.TestCase):
    def test_full_mobile_nodes_and_labels_stay_inside_viewbox(self):
        result = run_node(
            """
            import { graphLayout, nodePosition } from './src/graphLayout.js'
            const layout = graphLayout(false, 'mobile')
            const results = [4, 9, 14].map((count) => ({
              count,
              nodes: Array.from({length: count}, (_, index) => nodePosition(index, count, layout))
            }))
            console.log(JSON.stringify({layout, results}))
            """
        )
        layout = result["layout"]
        self.assertEqual((layout["width"], layout["height"]), (390, 500))
        horizontal_clearance = layout["targetRadius"] + 36
        vertical_clearance = layout["targetRadius"] + 38
        for group in result["results"]:
            for node in group["nodes"]:
                self.assertGreaterEqual(node["x"], horizontal_clearance, group["count"])
                self.assertLessEqual(node["x"], layout["width"] - horizontal_clearance, group["count"])
                self.assertGreaterEqual(node["y"], layout["targetRadius"], group["count"])
                self.assertLessEqual(node["y"], layout["height"] - vertical_clearance, group["count"])

    def test_mobile_edge_labels_point_inward(self):
        result = run_node(
            """
            import { graphLayout, mobileTextPlacement } from './src/graphLayout.js'
            const layout = graphLayout(false, 'mobile')
            console.log(JSON.stringify({
              left: mobileTextPlacement(40, layout),
              center: mobileTextPlacement(195, layout),
              right: mobileTextPlacement(350, layout)
            }))
            """
        )
        self.assertEqual(result["left"]["textAnchor"], "start")
        self.assertLess(result["left"]["textX"], 0)
        self.assertEqual(result["center"]["textAnchor"], "middle")
        self.assertEqual(result["right"]["textAnchor"], "end")
        self.assertGreater(result["right"]["textX"], 0)

    def test_desktop_labels_clear_the_graph_legend(self):
        result = run_node(
            """
            import { graphLayout, nodePosition } from './src/graphLayout.js'
            const layout = graphLayout(false, 'desktop')
            const nodes = Array.from({length: 14}, (_, index) => nodePosition(index, 14, layout))
            console.log(JSON.stringify({layout, nodes}))
            """
        )
        layout = result["layout"]
        label_clearance = layout["targetRadius"] + 38
        for node in result["nodes"]:
            self.assertGreaterEqual(node["y"], layout["targetRadius"])
            self.assertLessEqual(node["y"], layout["height"] - label_clearance)

    def test_genealogy_labels_describe_target_role(self):
        result = run_node(
            """
            import { relationTargetLabel } from './src/i18n.js'
            const values = ['CHILD_OF', 'PARENT_OF', 'FATHER_OF', 'MOTHER_OF', 'SIBLING_OF', 'CONSORT_OF']
            console.log(JSON.stringify(Object.fromEntries(
              values.map((value) => [value, {
                zh: relationTargetLabel(value, 'zh'),
                en: relationTargetLabel(value, 'en')
              }])
            )))
            """
        )
        self.assertEqual(result["CHILD_OF"], {"zh": "父母", "en": "Parent"})
        self.assertEqual(result["PARENT_OF"], {"zh": "子女", "en": "Child"})
        self.assertEqual(result["FATHER_OF"]["zh"], "子女")
        self.assertEqual(result["MOTHER_OF"]["zh"], "子女")
        self.assertEqual(result["SIBLING_OF"], {"zh": "兄弟姐妹", "en": "Sibling"})
        self.assertEqual(result["CONSORT_OF"], {"zh": "配偶／伴侣", "en": "Consort"})

    def test_mobile_css_has_dedicated_svg_and_safe_area(self):
        css = (WEB / "src" / "styles.css").read_text(encoding="utf-8")
        self.assertIn(".graph-svg-mobile", css)
        self.assertIn("env(safe-area-inset-bottom)", css)
        self.assertNotIn("width: 150%", css)
        self.assertNotIn("width: 175%", css)
        graph_view = (WEB / "src" / "components" / "GraphView.jsx").read_text(encoding="utf-8")
        self.assertIn("scrollIntoView", graph_view)
        self.assertIn("inline: 'center'", graph_view)

    def test_release_migration_is_recorded_without_claim_changes(self):
        connection = sqlite3.connect(DATABASE)
        try:
            release = connection.execute(
                "SELECT schema_version, data_version, release_notes FROM dataset_releases WHERE id='release.0.5.1'"
            ).fetchone()
            self.assertIsNotNone(release)
            self.assertEqual(release[0], 7)
            self.assertEqual(release[1], "0.5.1-mobile-graph-hotfix-20260814")
            self.assertIn("unchanged from v0.5.0", release[2])
            migration = connection.execute(
                "SELECT name FROM schema_migrations WHERE version=8"
            ).fetchone()
            self.assertEqual(migration[0], "20260814_v051_mobile_graph_hotfix")
            # This historical release test must remain valid as append-only
            # research migrations add later claims, evidence and sources.
            self.assertGreaterEqual(connection.execute("SELECT COUNT(*) FROM claims").fetchone()[0], 221)
            self.assertGreaterEqual(connection.execute("SELECT COUNT(*) FROM evidence").fetchone()[0], 215)
            self.assertGreaterEqual(connection.execute("SELECT COUNT(*) FROM sources").fetchone()[0], 100)
        finally:
            connection.close()


if __name__ == "__main__":
    unittest.main()
