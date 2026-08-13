from __future__ import annotations

import json
import sqlite3
from dataclasses import asdict, dataclass
from pathlib import Path
from .db import BUILD_TIMESTAMP, DEFAULT_DB_PATH, connect
from .maintenance import extract_verification_receipt, source_locator_kind, valid_web_url


@dataclass(frozen=True)
class Finding:
    severity: str
    rule_code: str
    message: str
    entity_id: str | None = None
    claim_id: str | None = None


def _finding(severity: str, code: str, message: str, entity_id: str | None = None,
             claim_id: str | None = None) -> Finding:
    return Finding(severity, code, message, entity_id, claim_id)


def validate_connection(conn: sqlite3.Connection) -> list[Finding]:
    findings: list[Finding] = []
    integrity = conn.execute("PRAGMA integrity_check").fetchone()[0]
    if integrity != "ok":
        findings.append(_finding("CRITICAL", "SQLITE_INTEGRITY", str(integrity)))
    foreign_keys = conn.execute("PRAGMA foreign_key_check").fetchall()
    if foreign_keys:
        findings.append(_finding("CRITICAL", "FOREIGN_KEY", f"{len(foreign_keys)} foreign-key violations"))

    # Regression floors describe this baseline release, not a universe-wide cap.
    expected_floors = {
        "civilizations": 90, "entities": 350, "sources": 70, "claims": 50,
        "evidence": 40, "relationships": 45, "collection_queue": 20,
    }
    for table, minimum in expected_floors.items():
        count = int(conn.execute(f'SELECT COUNT(*) FROM "{table}"').fetchone()[0])
        if count < minimum:
            findings.append(_finding("HIGH", "BASELINE_REGRESSION", f"{table}: {count} < baseline floor {minimum}"))

    missing_names = conn.execute(
        """SELECT e.id FROM entities e
           LEFT JOIN names n ON n.entity_id=e.id
           GROUP BY e.id HAVING COUNT(n.id)=0"""
    ).fetchall()
    for row in missing_names:
        findings.append(_finding("HIGH", "ENTITY_WITHOUT_NAME", "Active entity has no name", row[0]))

    bad_primary = conn.execute(
        """SELECT e.id, SUM(ec.is_primary)
           FROM entities e JOIN entity_classifications ec ON ec.entity_id=e.id
           GROUP BY e.id HAVING SUM(ec.is_primary) <> 1"""
    ).fetchall()
    for row in bad_primary:
        findings.append(_finding("HIGH", "PRIMARY_TYPE_CARDINALITY", f"primary type count={row[1]}", row[0]))

    unsourced_verified = conn.execute(
        """SELECT c.id,c.subject_id FROM claims c
           LEFT JOIN evidence e ON e.claim_id=c.id
           WHERE c.review_status='VERIFIED'
           GROUP BY c.id HAVING COUNT(e.id)=0"""
    ).fetchall()
    for row in unsourced_verified:
        findings.append(_finding("HIGH", "VERIFIED_WITHOUT_EVIDENCE", "Verified claim lacks evidence", row[1], row[0]))

    for row in conn.execute("SELECT * FROM sources"):
        if source_locator_kind(row) is None:
            findings.append(_finding("HIGH", "SOURCE_LOCATOR_INVALID", f"No valid stable locator: {row['id']}"))
        if (row["url"] or row["stable_url"]) and not (
            valid_web_url(row["url"]) or valid_web_url(row["stable_url"])
        ):
            findings.append(_finding("HIGH", "SOURCE_URL_INVALID", f"Invalid URL: {row['id']}"))
        if (row["url"] or row["stable_url"]) and not row["accessed_date"]:
            findings.append(_finding("HIGH", "SOURCE_ACCESS_DATE_MISSING", f"Missing web access date: {row['id']}"))
        if row["verification_status"] == "WEB_CONFIRMED" and extract_verification_receipt(row["notes"]) is None:
            findings.append(_finding("HIGH", "SOURCE_CONFIRMATION_UNREPRODUCIBLE",
                                     f"WEB_CONFIRMED lacks a machine-readable receipt: {row['id']}"))

    dangling_same_witness = conn.execute(
        """SELECT id FROM sources
           WHERE same_witness_as_source_id IS NOT NULL
             AND same_witness_as_source_id=id"""
    ).fetchall()
    for row in dangling_same_witness:
        findings.append(_finding("HIGH", "SAME_WITNESS_SELF_REFERENCE", "Source references itself as same witness"))

    queue_duplicates = conn.execute(
        """SELECT normalized_label,COALESCE(proposed_entity_type,''),COALESCE(civilization_id,''),COUNT(*)
           FROM collection_queue
           GROUP BY normalized_label,proposed_entity_type,civilization_id HAVING COUNT(*)>1"""
    ).fetchall()
    for row in queue_duplicates:
        findings.append(_finding("MEDIUM", "QUEUE_DUPLICATE", f"Duplicate queue fingerprint: {row[0]} ({row[3]})"))

    # Guardrail classifications explicitly requested by the architecture review.
    expected_types = {
        "creature.norse.fenrir": "MONSTER",
        "creature.norse.jormungandr": "DRAGON",
        "being.norse.ymir": "GIANT",
        "deity.egyptian.ma_at": "DEITY",
        "deity.babylonian.tiamat": "PRIMORDIAL_DEITY",
    }
    for entity_id, expected in expected_types.items():
        actual = conn.execute("SELECT primary_type FROM entities WHERE id=?", (entity_id,)).fetchone()
        if actual is None or actual[0] != expected:
            findings.append(_finding("HIGH", "TYPE_GUARDRAIL", f"Expected primary type {expected}, got {actual[0] if actual else None}", entity_id))

    required_extra_types = {
        "being.norse.ymir": "PRIMORDIAL_DEITY",
        "being.chinese.pangu": "PRIMORDIAL_DEITY",
        "deity.egyptian.ma_at": "CONCEPT",
        "deity.babylonian.tiamat": "DRAGON",
        "deity.ugaritic.yam": "CONCEPT",
    }
    for entity_id, type_code in required_extra_types.items():
        exists = conn.execute(
            "SELECT 1 FROM entity_classifications WHERE entity_id=? AND type_code=?", (entity_id, type_code)
        ).fetchone()
        if not exists:
            findings.append(_finding("HIGH", "MULTITYPE_GUARDRAIL", f"Missing classification {type_code}", entity_id))

    # Reverse graph checks prove that only one physical semantic claim is needed.
    reverse_expectations = [
        ("deity.greek.zeus", "CHILD_OF", "deity.greek.cronus"),
        ("deity.greek.zeus", "CHILD_OF", "deity.greek.rhea"),
        ("deity.norse.odin", "KILLED_BY", "creature.norse.fenrir"),
        ("weapon.norse.gungnir", "OWNED_BY", "deity.norse.odin"),
        ("deity.ugaritic.yam", "ENEMY_OF", "deity.ugaritic.baal"),
    ]
    for source_id, predicate, target_id in reverse_expectations:
        exists = conn.execute(
            """SELECT 1 FROM relationship_edges_bidirectional
               WHERE source_entity_id=? AND relationship_type=? AND target_entity_id=?""",
            (source_id, predicate, target_id),
        ).fetchone()
        if not exists:
            findings.append(_finding("HIGH", "INVERSE_GRAPH", f"Missing inferred edge {source_id} {predicate} {target_id}", source_id))

    profile_collections = [
        ("deities", "deity_profiles"),
        ("artifacts", "artifact_profiles"),
        ("creatures", "creature_profiles"),
        ("texts", "text_profiles"),
        ("archaeological_sites", "place_profiles"),
        ("mythical_places", "place_profiles"),
        ("realms", "place_profiles"),
        ("events", "myth_event_profiles"),
    ]
    for collection_view, profile_table in profile_collections:
        missing_profiles = conn.execute(
            f'''SELECT e.id FROM "{collection_view}" e
                LEFT JOIN "{profile_table}" p ON p.entity_id=e.id
                WHERE p.entity_id IS NULL'''
        ).fetchall()
        for row in missing_profiles:
            findings.append(_finding(
                "HIGH", "CLASSIFICATION_PROFILE_GAP",
                f"{collection_view} member lacks {profile_table}", row[0]
            ))

    physical_inverse_duplicates = conn.execute(
        """SELECT c1.id,c2.id FROM claims c1
           JOIN relationship_types rt ON rt.code=c1.predicate AND rt.is_symmetric=0
           JOIN claims c2 ON c2.subject_id=c1.object_entity_id
                         AND c2.object_entity_id=c1.subject_id
                         AND c2.predicate=rt.inverse_code
           WHERE c1.object_entity_id IS NOT NULL AND c1.id<c2.id"""
    ).fetchall()
    if physical_inverse_duplicates:
        findings.append(_finding("MEDIUM", "PHYSICAL_INVERSE_DUPLICATE",
                                 f"{len(physical_inverse_duplicates)} physical inverse pairs should be reviewed"))

    historical_supernatural = conn.execute(
        """SELECT id,subject_id,predicate FROM claims
           WHERE assertion_scope='HISTORICAL_REALITY'
             AND predicate IN ('KILLED','DEFEATED','CREATOR_OF','CAUSED')
             AND knowledge_layer='MYTHIC_NARRATIVE'"""
    ).fetchall()
    for row in historical_supernatural:
        findings.append(_finding("HIGH", "MYTH_AS_HISTORY", f"Mythic predicate marked historical: {row[2]}", row[1], row[0]))

    if conn.execute("SELECT COUNT(*) FROM modern_adaptations").fetchone()[0]:
        mixed = conn.execute(
            """SELECT ma.id FROM modern_adaptations ma
               JOIN entities a ON a.id=ma.ancient_entity_id
               JOIN entities m ON m.id=ma.modern_entity_id
               WHERE m.primary_type<>'MODERN_WORK' OR a.primary_type='MODERN_WORK'"""
        ).fetchall()
        for row in mixed:
            findings.append(_finding("HIGH", "MODERN_LAYER_MIX", f"Invalid adaptation layer: {row[0]}"))

    unsourced_provisional = conn.execute(
        """SELECT COUNT(*) FROM claims c LEFT JOIN evidence e ON e.claim_id=c.id
           WHERE c.review_status IN ('UNVERIFIED','PROVISIONAL')
           GROUP BY c.review_status HAVING COUNT(e.id)=0"""
    ).fetchall()
    if unsourced_provisional:
        findings.append(_finding("INFO", "EXPECTED_RESEARCH_GAPS",
                                 "Unverified/provisional claims without evidence remain queued and are not promoted to verified."))

    return findings


def validate_database(path: Path | str = DEFAULT_DB_PATH, *, persist: bool = True) -> dict:
    conn = connect(path, readonly=not persist)
    try:
        findings = validate_connection(conn)
        blocking = [f for f in findings if f.severity in {"HIGH", "CRITICAL"}]
        status = "PASS" if not findings else "PASS_WITH_NOTES" if not blocking else "FAIL"
        if persist:
            run_id = "quality.20260810.baseline"
            with conn:
                conn.execute("DELETE FROM quality_runs WHERE id=?", (run_id,))
                conn.execute(
                    "INSERT INTO quality_runs(id,started_at,ended_at,status,summary) VALUES(?,?,?,?,?)",
                    (run_id, BUILD_TIMESTAMP, BUILD_TIMESTAMP, status,
                     f"{len(findings)} findings; {len(blocking)} blocking"),
                )
                for index, finding in enumerate(findings, 1):
                    conn.execute(
                        """INSERT INTO quality_findings(
                               id,quality_run_id,severity,rule_code,entity_id,claim_id,message,status
                           ) VALUES(?,?,?,?,?,?,?,?)""",
                        (f"finding.{run_id}.{index:03d}", run_id, finding.severity, finding.rule_code,
                         finding.entity_id, finding.claim_id, finding.message,
                         "DEFERRED" if finding.severity == "INFO" else "OPEN"),
                    )
        return {"status": status, "blocking": len(blocking), "findings": [asdict(f) for f in findings]}
    finally:
        conn.close()


def write_validation_report(result: dict, path: Path | str) -> Path:
    output = Path(path)
    output.parent.mkdir(parents=True, exist_ok=True)
    lines = ["# 数据质量检查 / Data Quality Validation", "", f"状态：**{result['status']}**", "",
             f"Blocking findings: {result['blocking']}", ""]
    if not result["findings"]:
        lines.append("未发现问题。")
    else:
        lines.extend(["| Severity | Rule | Entity / Claim | Message |", "|---|---|---|---|"])
        for item in result["findings"]:
            locator = item.get("entity_id") or item.get("claim_id") or "—"
            lines.append(f"| {item['severity']} | `{item['rule_code']}` | `{locator}` | {item['message']} |")
    output.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return output
