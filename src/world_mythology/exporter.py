from __future__ import annotations

import csv
import json
from pathlib import Path
from xml.sax.saxutils import escape

from .db import DEFAULT_DB_PATH, PROJECT_ROOT, canonical_json, connect, sha256_file


def persistent_tables(conn) -> list[str]:
    """Return every application table, excluding SQLite internals and all views."""
    return [row[0] for row in conn.execute(
        """SELECT name FROM sqlite_master
           WHERE type='table' AND name NOT LIKE 'sqlite_%'
           ORDER BY name"""
    )]


def _clean_managed_exports(directory: Path, suffix: str) -> None:
    """Remove files from earlier manifests so exports never retain stale tables."""
    directory.mkdir(parents=True, exist_ok=True)
    for path in directory.glob(f"*{suffix}"):
        if path.is_file():
            path.unlink()


def _rows(conn, name: str) -> tuple[list[str], list[dict]]:
    cursor = conn.execute(f'SELECT * FROM "{name}"')
    columns = [description[0] for description in cursor.description]
    data = [dict(row) for row in cursor.fetchall()]
    if columns:
        first = columns[0]
        data.sort(key=lambda row: str(row.get(first, "")))
    return columns, data


def _write_graph(conn, graph_dir: Path) -> list[Path]:
    graph_dir.mkdir(parents=True, exist_ok=True)
    nodes = [dict(row) for row in conn.execute(
        "SELECT id,canonical_name,name_zh,primary_type,primary_civilization_id,research_status,evidence_status FROM entities ORDER BY id"
    )]
    edges = [dict(row) for row in conn.execute(
        """SELECT r.id,r.source_entity_id,r.relationship_type,r.target_entity_id,r.claim_id,
                  r.variant_label,r.certainty,r.confidence,c.review_status,c.assertion_scope,
                  c.knowledge_layer,c.claim_status,
                  (SELECT COUNT(*) FROM evidence ev WHERE ev.claim_id=r.claim_id) AS evidence_count
           FROM relationships r JOIN claims c ON c.id=r.claim_id ORDER BY r.id"""
    )]
    graph_json = graph_dir / "knowledge_graph.json"
    graph_json.write_text(canonical_json({"nodes": nodes, "edges": edges}) + "\n", encoding="utf-8")
    relation_csv = graph_dir / "relationships.csv"
    with relation_csv.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(edges[0]) if edges else ["id"], lineterminator="\n")
        writer.writeheader()
        writer.writerows(edges)
    graphml = graph_dir / "knowledge_graph.graphml"
    lines = [
        '<?xml version="1.0" encoding="UTF-8"?>',
        '<graphml xmlns="http://graphml.graphdrawing.org/xmlns">',
        '  <key id="name" for="node" attr.name="name" attr.type="string"/>',
        '  <key id="type" for="node" attr.name="type" attr.type="string"/>',
        '  <key id="relation" for="edge" attr.name="relation" attr.type="string"/>',
        '  <graph id="world_mythology" edgedefault="directed">',
    ]
    for node in nodes:
        lines.append(f'    <node id="{escape(node["id"])}"><data key="name">{escape(node["canonical_name"])}</data><data key="type">{escape(node["primary_type"])}</data></node>')
    for edge in edges:
        lines.append(f'    <edge id="{escape(edge["id"])}" source="{escape(edge["source_entity_id"])}" target="{escape(edge["target_entity_id"])}"><data key="relation">{escape(edge["relationship_type"])}</data></edge>')
    lines.extend(["  </graph>", "</graphml>"])
    graphml.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return [graph_json, relation_csv, graphml]


def export_all(db_path: Path | str = DEFAULT_DB_PATH, export_root: Path | str | None = None) -> dict:
    root = Path(export_root) if export_root else PROJECT_ROOT / "exports"
    jsonl_dir, csv_dir, graph_dir = root / "jsonl", root / "csv", root / "graph"
    _clean_managed_exports(jsonl_dir, ".jsonl")
    _clean_managed_exports(csv_dir, ".csv")
    _clean_managed_exports(graph_dir, ".json")
    _clean_managed_exports(graph_dir, ".csv")
    _clean_managed_exports(graph_dir, ".graphml")
    generated: list[Path] = []
    counts: dict[str, int] = {}
    release_metadata: dict = {}
    project_metadata: dict[str, str] = {}
    conn = connect(db_path, readonly=True)
    try:
        tables = persistent_tables(conn)
        for name in tables:
            columns, rows = _rows(conn, name)
            counts[name] = len(rows)
            jsonl_path = jsonl_dir / f"{name}.jsonl"
            jsonl_path.write_text("".join(canonical_json(row) + "\n" for row in rows), encoding="utf-8")
            csv_path = csv_dir / f"{name}.csv"
            with csv_path.open("w", encoding="utf-8", newline="") as handle:
                writer = csv.DictWriter(handle, fieldnames=columns, lineterminator="\n")
                writer.writeheader()
                writer.writerows(rows)
            generated.extend([jsonl_path, csv_path])
        generated.extend(_write_graph(conn, graph_dir))
        release_row = conn.execute(
            """SELECT id,schema_version,data_version,git_commit,built_at
               FROM dataset_releases ORDER BY built_at DESC,id DESC LIMIT 1"""
        ).fetchone()
        if release_row:
            release_metadata = dict(release_row)
        project_metadata = {
            row["key"]: row["value"]
            for row in conn.execute(
                "SELECT key,value FROM project_metadata "
                "WHERE key IN ('project_version','data_version','schema_version','project_status')"
            )
        }
    finally:
        conn.close()
    manifest = {
        "format_version": 2,
        "database": str(Path(db_path).name),
        "database_sha256": sha256_file(db_path),
        "snapshot_status": (
            "SEALED_RELEASE"
            if project_metadata.get("data_version") == release_metadata.get("data_version")
            else "DEVELOPMENT"
        ),
        "project": project_metadata,
        "latest_sealed_release": release_metadata,
        "release": release_metadata,
        "tables": tables,
        "excluded_object_types": ["view", "sqlite_internal"],
        "counts": counts,
        "graph_counts": {
            "nodes": counts.get("entities", 0),
            "edges": 0,
        },
        "files": [],
    }
    graph_json = graph_dir / "knowledge_graph.json"
    if graph_json.exists():
        graph = json.loads(graph_json.read_text(encoding="utf-8"))
        manifest["graph_counts"] = {"nodes": len(graph["nodes"]), "edges": len(graph["edges"])}
    for path in sorted(generated):
        manifest["files"].append({
            "path": str(path.relative_to(root)), "sha256": sha256_file(path), "bytes": path.stat().st_size,
        })
    manifest_path = root / "manifest.json"
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    return manifest
