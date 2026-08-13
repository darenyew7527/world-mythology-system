from __future__ import annotations

import argparse
import json

from .db import DEFAULT_DB_PATH, connect


def _entity(identifier: str) -> int:
    conn = connect(DEFAULT_DB_PATH, readonly=True)
    try:
        entity = conn.execute("SELECT * FROM entities WHERE id=?", (identifier,)).fetchone()
        if not entity:
            print(json.dumps({"error": "entity_not_found", "id": identifier}, ensure_ascii=False))
            return 1
        relations = [dict(row) for row in conn.execute(
            "SELECT * FROM relationship_edges_bidirectional WHERE source_entity_id=? ORDER BY relationship_type,target_entity_id",
            (identifier,),
        )]
        claims = [dict(row) for row in conn.execute("SELECT * FROM claims WHERE subject_id=? ORDER BY id", (identifier,))]
        print(json.dumps({"entity": dict(entity), "relations": relations, "claims": claims}, ensure_ascii=False, indent=2))
        return 0
    finally:
        conn.close()


def _network(identifier: str) -> int:
    conn = connect(DEFAULT_DB_PATH, readonly=True)
    try:
        rows = [dict(row) for row in conn.execute(
            """SELECT r.claim_id,r.relationship_type,r.target_entity_id,e.canonical_name,e.name_zh,
                      r.certainty,r.confidence,r.is_inferred_inverse,
                      c.review_status,c.assertion_scope,c.knowledge_layer,c.claim_status,
                      (SELECT COUNT(*) FROM evidence ev WHERE ev.claim_id=r.claim_id) AS evidence_count
               FROM relationship_edges_bidirectional r
               JOIN entities e ON e.id=r.target_entity_id
               JOIN claims c ON c.id=r.claim_id
               WHERE r.source_entity_id=? ORDER BY r.relationship_type,e.canonical_name""", (identifier,)
        )]
        print(json.dumps(rows, ensure_ascii=False, indent=2))
        return 0 if rows else 1
    finally:
        conn.close()


def _search(query: str) -> int:
    term = f"%{query}%"
    conn = connect(DEFAULT_DB_PATH, readonly=True)
    try:
        rows = [dict(row) for row in conn.execute(
            """SELECT DISTINCT e.id,e.canonical_name,e.name_zh,e.primary_type,e.evidence_status
               FROM entities e LEFT JOIN names n ON n.entity_id=e.id LEFT JOIN aliases a ON a.entity_id=e.id
               WHERE e.canonical_name LIKE ? OR e.name_zh LIKE ? OR n.name_text LIKE ? OR a.alias_text LIKE ?
               ORDER BY e.canonical_name LIMIT 100""", (term, term, term, term)
        )]
        print(json.dumps(rows, ensure_ascii=False, indent=2))
        return 0
    finally:
        conn.close()


def _queue(status: str | None) -> int:
    conn = connect(DEFAULT_DB_PATH, readonly=True)
    try:
        if status:
            rows = [dict(row) for row in conn.execute(
                "SELECT * FROM collection_queue WHERE status=? ORDER BY priority DESC,id", (status,)
            )]
        else:
            rows = [dict(row) for row in conn.execute("SELECT * FROM collection_queue ORDER BY priority DESC,id")]
        print(json.dumps(rows, ensure_ascii=False, indent=2))
        return 0
    finally:
        conn.close()


def main() -> int:
    parser = argparse.ArgumentParser(prog="mythology")
    sub = parser.add_subparsers(dest="command", required=True)
    entity_parser = sub.add_parser("entity")
    entity_parser.add_argument("id")
    network_parser = sub.add_parser("network")
    network_parser.add_argument("id")
    search_parser = sub.add_parser("search")
    search_parser.add_argument("query")
    queue_parser = sub.add_parser("queue")
    queue_parser.add_argument("--status")
    args = parser.parse_args()
    if args.command == "entity":
        return _entity(args.id)
    if args.command == "network":
        return _network(args.id)
    if args.command == "search":
        return _search(args.query)
    return _queue(args.status)


if __name__ == "__main__":
    raise SystemExit(main())
