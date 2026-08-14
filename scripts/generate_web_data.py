#!/usr/bin/env python3
"""Build the public, browser-safe knowledge snapshot from the canonical SQLite DB.

The website intentionally publishes source metadata and evidence locators, but it
does not publish the ``short_quote`` field. This keeps the public preview useful
while respecting source-specific reuse terms.
"""

from __future__ import annotations

import argparse
import json
import sqlite3
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_DATABASE = ROOT / "database" / "world_mythology.sqlite"
DEFAULT_OUTPUT = ROOT / "web" / "public" / "data" / "site-data.json"


def _rows(connection: sqlite3.Connection, sql: str, parameters: tuple[Any, ...] = ()) -> list[dict[str, Any]]:
    return [dict(row) for row in connection.execute(sql, parameters)]


def _clean(value: Any) -> Any:
    if isinstance(value, str):
        value = value.strip()
        return value or None
    return value


def build_snapshot(database_path: Path) -> dict[str, Any]:
    connection = sqlite3.connect(database_path)
    connection.row_factory = sqlite3.Row

    redirects = {
        row["duplicate_entity_id"]: row["canonical_entity_id"]
        for row in connection.execute(
            "SELECT duplicate_entity_id, canonical_entity_id FROM entity_redirects"
        )
    }

    raw_entities = _rows(
        connection,
        """
        SELECT
            e.id,
            e.canonical_name,
            e.name_zh,
            e.original_name,
            e.transliteration,
            e.primary_type,
            e.primary_civilization_id,
            e.historical_period,
            e.description,
            e.research_status,
            e.evidence_status,
            c.canonical_name AS civilization_name,
            c.name_zh AS civilization_name_zh
        FROM entities e
        LEFT JOIN civilizations c ON c.id = e.primary_civilization_id
        ORDER BY COALESCE(e.name_zh, e.canonical_name), e.canonical_name, e.id
        """,
    )

    canonical_ids = {row["id"] for row in raw_entities if row["id"] not in redirects}
    entity_lookup = {row["id"]: row for row in raw_entities}

    aliases: dict[str, list[str]] = defaultdict(list)
    for row in _rows(
        connection,
        """
        SELECT entity_id, name_text
        FROM names
        ORDER BY entity_id, is_preferred DESC, name_text
        """,
    ):
        entity_id = redirects.get(row["entity_id"], row["entity_id"])
        if entity_id in canonical_ids and row["name_text"] not in aliases[entity_id]:
            aliases[entity_id].append(row["name_text"])

    classifications: dict[str, list[str]] = defaultdict(list)
    for row in _rows(
        connection,
        "SELECT entity_id, type_code FROM entity_classifications ORDER BY entity_id, is_primary DESC, type_code",
    ):
        entity_id = redirects.get(row["entity_id"], row["entity_id"])
        if entity_id in canonical_ids and row["type_code"] not in classifications[entity_id]:
            classifications[entity_id].append(row["type_code"])

    claim_lookup = {
        row["id"]: row
        for row in _rows(
            connection,
            """
            SELECT id, subject_id, predicate, object_entity_id, object_literal,
                   statement, claim_status, confidence, confidence_level,
                   review_status, assertion_scope, knowledge_layer,
                   tradition_scope, temporal_scope
            FROM claims
            ORDER BY id
            """,
        )
    }

    evidence_by_claim: dict[str, list[dict[str, Any]]] = defaultdict(list)
    public_sources: dict[str, dict[str, Any]] = {}
    for row in _rows(
        connection,
        """
        SELECT
            ev.id,
            ev.claim_id,
            ev.source_id,
            ev.source_location,
            ev.chapter,
            ev.verse,
            ev.line,
            ev.page,
            ev.catalogue_number AS evidence_catalogue_number,
            ev.evidence_type,
            ev.direction,
            ev.strength,
            s.title AS source_title,
            s.original_title AS source_original_title,
            s.source_type,
            s.evidence_tier,
            s.institution,
            s.author_or_editor,
            s.publication_date,
            s.url,
            s.stable_url,
            s.doi,
            s.isbn,
            s.catalogue_number AS source_catalogue_number,
            s.manuscript_number,
            s.rights_status,
            s.source_perspective,
            s.living_tradition,
            s.access_or_reuse_restrictions,
            s.community_permission_required,
            s.verification_status
        FROM evidence ev
        JOIN sources s ON s.id = ev.source_id
        ORDER BY ev.claim_id, ev.id
        """,
    ):
        source = {
            "id": row["source_id"],
            "title": _clean(row["source_title"]),
            "originalTitle": _clean(row["source_original_title"]),
            "sourceType": _clean(row["source_type"]),
            "evidenceTier": _clean(row["evidence_tier"]),
            "institution": _clean(row["institution"]),
            "authorOrEditor": _clean(row["author_or_editor"]),
            "publicationDate": _clean(row["publication_date"]),
            "url": _clean(row["stable_url"]) or _clean(row["url"]),
            "doi": _clean(row["doi"]),
            "isbn": _clean(row["isbn"]),
            "catalogueNumber": _clean(row["source_catalogue_number"]),
            "manuscriptNumber": _clean(row["manuscript_number"]),
            "rightsStatus": _clean(row["rights_status"]),
            "sourcePerspective": _clean(row["source_perspective"]),
            "livingTradition": bool(row["living_tradition"]),
            "reuseRestrictions": _clean(row["access_or_reuse_restrictions"]),
            "communityPermissionRequired": bool(row["community_permission_required"]),
            "verificationStatus": _clean(row["verification_status"]),
        }
        public_sources[source["id"]] = source
        evidence_by_claim[row["claim_id"]].append(
            {
                "id": row["id"],
                "sourceId": row["source_id"],
                "sourceTitle": source["title"],
                "sourceUrl": source["url"],
                "institution": source["institution"],
                "sourceLocation": _clean(row["source_location"]),
                "chapter": _clean(row["chapter"]),
                "verse": _clean(row["verse"]),
                "line": _clean(row["line"]),
                "page": _clean(row["page"]),
                "catalogueNumber": _clean(row["evidence_catalogue_number"]),
                "evidenceType": _clean(row["evidence_type"]),
                "direction": _clean(row["direction"]),
                "strength": _clean(row["strength"]),
                "rightsStatus": source["rightsStatus"],
                "reuseRestrictions": source["reuseRestrictions"],
            }
        )

    relationship_map: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for row in _rows(
        connection,
        """
        SELECT id, source_entity_id, relationship_type, target_entity_id,
               claim_id, variant_label, certainty, confidence,
               is_inferred_inverse
        FROM relationship_edges_bidirectional
        ORDER BY source_entity_id, relationship_type, target_entity_id, claim_id
        """,
    ):
        source_id = redirects.get(row["source_entity_id"], row["source_entity_id"])
        target_id = redirects.get(row["target_entity_id"], row["target_entity_id"])
        if source_id not in canonical_ids or target_id not in canonical_ids:
            continue
        target = entity_lookup[target_id]
        claim = claim_lookup.get(row["claim_id"], {})
        relationship_map[source_id].append(
            {
                "id": row["id"],
                "type": row["relationship_type"],
                "targetId": target_id,
                "targetName": target["canonical_name"],
                "targetNameZh": target["name_zh"],
                "claimId": row["claim_id"],
                "variantLabel": _clean(row["variant_label"]),
                "certainty": _clean(row["certainty"]),
                "confidence": row["confidence"],
                "inferredInverse": bool(row["is_inferred_inverse"]),
                "reviewStatus": _clean(claim.get("review_status")),
                "assertionScope": _clean(claim.get("assertion_scope")),
                "knowledgeLayer": _clean(claim.get("knowledge_layer")),
                "evidenceCount": len(evidence_by_claim.get(row["claim_id"], [])),
            }
        )

    claims_by_entity: dict[str, list[dict[str, Any]]] = defaultdict(list)
    public_claims: list[dict[str, Any]] = []
    for claim in claim_lookup.values():
        subject_id = redirects.get(claim["subject_id"], claim["subject_id"])
        object_id = redirects.get(claim["object_entity_id"], claim["object_entity_id"])
        item = {
            "id": claim["id"],
            "subjectId": subject_id,
            "predicate": claim["predicate"],
            "objectEntityId": object_id,
            "objectLiteral": _clean(claim["object_literal"]),
            "statement": _clean(claim["statement"]),
            "claimStatus": _clean(claim["claim_status"]),
            "confidence": claim["confidence"],
            "confidenceLevel": _clean(claim["confidence_level"]),
            "reviewStatus": _clean(claim["review_status"]),
            "assertionScope": _clean(claim["assertion_scope"]),
            "knowledgeLayer": _clean(claim["knowledge_layer"]),
            "traditionScope": _clean(claim["tradition_scope"]),
            "temporalScope": _clean(claim["temporal_scope"]),
            "evidence": evidence_by_claim.get(claim["id"], []),
        }
        public_claims.append(item)
        if subject_id in canonical_ids:
            claims_by_entity[subject_id].append(item)
        if object_id in canonical_ids and object_id != subject_id:
            claims_by_entity[object_id].append(item)

    entities: list[dict[str, Any]] = []
    for row in raw_entities:
        if row["id"] in redirects:
            continue
        entities.append(
            {
                "id": row["id"],
                "canonicalName": row["canonical_name"],
                "nameZh": _clean(row["name_zh"]),
                "originalName": _clean(row["original_name"]),
                "transliteration": _clean(row["transliteration"]),
                "primaryType": row["primary_type"],
                "types": classifications.get(row["id"], [row["primary_type"]]),
                "civilizationId": _clean(row["primary_civilization_id"]),
                "civilizationName": _clean(row["civilization_name"]),
                "civilizationNameZh": _clean(row["civilization_name_zh"]),
                "historicalPeriod": _clean(row["historical_period"]),
                "description": _clean(row["description"]),
                "researchStatus": row["research_status"],
                "evidenceStatus": row["evidence_status"],
                "aliases": aliases.get(row["id"], []),
                "relationships": relationship_map.get(row["id"], []),
                "claims": claims_by_entity.get(row["id"], []),
            }
        )

    civilization_counts = Counter(entity["civilizationId"] for entity in entities if entity["civilizationId"])
    civilizations = []
    for row in _rows(
        connection,
        """
        SELECT id, canonical_name, name_zh, original_name, tradition_type,
               period_start, period_end, research_status, evidence_status
        FROM civilizations
        ORDER BY COALESCE(name_zh, canonical_name), canonical_name
        """,
    ):
        civilizations.append(
            {
                "id": row["id"],
                "canonicalName": row["canonical_name"],
                "nameZh": _clean(row["name_zh"]),
                "originalName": _clean(row["original_name"]),
                "traditionType": _clean(row["tradition_type"]),
                "periodStart": row["period_start"],
                "periodEnd": row["period_end"],
                "researchStatus": row["research_status"],
                "evidenceStatus": row["evidence_status"],
                "entityCount": civilization_counts.get(row["id"], 0),
            }
        )

    type_counts = Counter(entity["primaryType"] for entity in entities)
    evidence_status_counts = Counter(entity["evidenceStatus"] for entity in entities)
    research_status_counts = Counter(entity["researchStatus"] for entity in entities)
    queue_status_counts = Counter(
        row["status"] for row in connection.execute("SELECT status FROM collection_queue")
    )

    release = dict(
        connection.execute(
            """
            SELECT id, schema_version, data_version, git_commit, built_at,
                   database_sha256, release_notes
            FROM dataset_releases
            ORDER BY built_at DESC, id DESC
            LIMIT 1
            """
        ).fetchone()
    )

    queue = _rows(
        connection,
        """
        SELECT id, target_label, proposed_entity_type, civilization_id,
               priority, status, next_action
        FROM collection_queue
        ORDER BY priority DESC, target_label
        """,
    )

    snapshot = {
        "meta": {
            "projectVersion": "0.4.0-greek-genealogy",
            "datasetRelease": release,
            "generatedFrom": "database/world_mythology.sqlite",
            "completionClaim": (
                "当前公开可发现资料的阶段性知识基线已经建立，并且系统可以继续扩张。"
            ),
            "publicDataPolicy": (
                "Source metadata and evidence locators are published; evidence short quotes are excluded."
            ),
            "counts": {
                "registeredEntities": len(raw_entities),
                "canonicalEntities": len(entities),
                "civilizations": len(civilizations),
                "sources": connection.execute("SELECT COUNT(*) FROM sources").fetchone()[0],
                "claims": len(public_claims),
                "evidence": connection.execute("SELECT COUNT(*) FROM evidence").fetchone()[0],
                "directRelationships": connection.execute("SELECT COUNT(*) FROM relationships").fetchone()[0],
                "conflicts": connection.execute("SELECT COUNT(*) FROM conflicts").fetchone()[0],
                "queue": len(queue),
            },
            "typeCounts": dict(sorted(type_counts.items())),
            "evidenceStatusCounts": dict(sorted(evidence_status_counts.items())),
            "researchStatusCounts": dict(sorted(research_status_counts.items())),
            "queueStatusCounts": dict(sorted(queue_status_counts.items())),
        },
        "civilizations": civilizations,
        "entities": entities,
        "claims": public_claims,
        "sources": sorted(public_sources.values(), key=lambda item: (item["title"] or "", item["id"])),
        "queue": queue,
    }
    connection.close()
    return snapshot


def write_snapshot(snapshot: dict[str, Any], output_path: Path) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(
        json.dumps(snapshot, ensure_ascii=False, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--database", type=Path, default=DEFAULT_DATABASE)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    snapshot = build_snapshot(args.database)
    write_snapshot(snapshot, args.output)
    print(
        json.dumps(
            {
                "output": str(args.output),
                "canonical_entities": snapshot["meta"]["counts"]["canonicalEntities"],
                "claims": snapshot["meta"]["counts"]["claims"],
                "sources": snapshot["meta"]["counts"]["sources"],
            },
            ensure_ascii=False,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
