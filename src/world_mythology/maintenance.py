from __future__ import annotations

import hashlib
import json
from datetime import datetime, timezone
import re
from pathlib import Path
from urllib.parse import urlparse

from .db import DEFAULT_DB_PATH, PROJECT_ROOT, connect, normalize_name, sha256_file


RECEIPT_PREFIX = "VERIFICATION_RECEIPT_JSON="
RECEIPT_REQUIRED_FIELDS = {"checked_at", "method", "locator", "outcome"}
AUDIT_PAYLOAD_PREFIX = "REDACTED_PAYLOAD"


def _value(row, key: str):
    """Read sqlite.Row or dict-like source records without losing nulls."""
    try:
        return row[key]
    except (KeyError, IndexError):
        return None


def valid_web_url(value: str | None) -> bool:
    parsed = urlparse(value or "")
    return parsed.scheme in {"http", "https"} and bool(parsed.netloc)


def source_locator_kind(row) -> str | None:
    """Return the strongest usable locator; a web URL is not mandatory."""
    if valid_web_url(_value(row, "stable_url")):
        return "STABLE_URL"
    if valid_web_url(_value(row, "url")):
        return "URL"
    doi = (_value(row, "doi") or "").strip()
    if re.fullmatch(r"10\.\d{4,9}/\S+", doi, flags=re.IGNORECASE):
        return "DOI"
    isbn = re.sub(r"[^0-9Xx]", "", _value(row, "isbn") or "")
    if len(isbn) in {10, 13}:
        return "ISBN"
    if (_value(row, "catalogue_number") or "").strip():
        return "CATALOGUE_NUMBER"
    if (_value(row, "manuscript_number") or "").strip():
        return "MANUSCRIPT_NUMBER"
    return None


def extract_verification_receipt(notes: str | None) -> dict | None:
    """Extract the last machine-readable receipt embedded in source notes."""
    for line in reversed((notes or "").splitlines()):
        if line.startswith(RECEIPT_PREFIX):
            try:
                receipt = json.loads(line[len(RECEIPT_PREFIX):])
            except json.JSONDecodeError:
                return None
            if (isinstance(receipt, dict) and RECEIPT_REQUIRED_FIELDS <= set(receipt)
                    and all(isinstance(receipt[key], str) and receipt[key].strip()
                            for key in RECEIPT_REQUIRED_FIELDS)):
                return receipt
            return None
    return None


def check_alias_candidates(db_path: Path | str = DEFAULT_DB_PATH) -> list[dict]:
    conn = connect(db_path, readonly=True)
    try:
        rows = conn.execute(
            """SELECT n.normalized_text,COUNT(DISTINCT n.entity_id) AS entity_count,
                      GROUP_CONCAT(DISTINCT n.entity_id) AS entity_ids
               FROM names n
               GROUP BY n.normalized_text
               HAVING COUNT(DISTINCT n.entity_id)>1
               ORDER BY entity_count DESC,n.normalized_text"""
        ).fetchall()
        return [dict(row) for row in rows]
    finally:
        conn.close()


def _audit_payload_summary(value: str) -> str:
    """Return a bounded, non-reversible diagnostic for rejected input."""
    encoded = value.encode("utf-8")
    digest = hashlib.sha256(encoded).hexdigest()
    return f"{AUDIT_PAYLOAD_PREFIX};sha256={digest};bytes={len(encoded)}"


def write_alias_report(candidates: list[dict], path: Path | str | None = None) -> Path:
    output = Path(path) if path else PROJECT_ROOT / "reports" / "alias_candidates.md"
    output.parent.mkdir(parents=True, exist_ok=True)
    lines = ["# 别名与去重候选报告", "",
             "本报告只发现候选，不自动合并。相同标准化名称可能指向不同文明、时期或实体。", "",
             "| Normalized name | Entity count | Candidate entity IDs |", "|---|---:|---|"]
    if candidates:
        lines.extend(f"| `{row['normalized_text']}` | {row['entity_count']} | `{row['entity_ids']}` |" for row in candidates)
    else:
        lines.append("| — | 0 | — |")
    output.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return output


def check_sources(db_path: Path | str = DEFAULT_DB_PATH) -> dict:
    conn = connect(db_path, readonly=True)
    problems: list[dict] = []
    try:
        for row in conn.execute("SELECT * FROM sources ORDER BY id"):
            locator_kind = source_locator_kind(row)
            if locator_kind is None:
                problems.append({"source_id": row["id"], "code": "MISSING_STABLE_LOCATOR"})
            if (row["url"] or row["stable_url"]) and not (
                valid_web_url(row["url"]) or valid_web_url(row["stable_url"])
            ):
                problems.append({"source_id": row["id"], "code": "INVALID_URL"})
            if (row["url"] or row["stable_url"]) and not row["accessed_date"]:
                problems.append({"source_id": row["id"], "code": "MISSING_ACCESS_DATE"})
            if row["verification_status"] == "URL_SYNTAX_VALID" and locator_kind not in {"URL", "STABLE_URL"}:
                problems.append({"source_id": row["id"], "code": "URL_STATUS_WITHOUT_VALID_URL"})
            if row["verification_status"] == "WEB_CONFIRMED":
                receipt = extract_verification_receipt(row["notes"])
                if receipt is None:
                    problems.append({"source_id": row["id"], "code": "WEB_CONFIRMED_WITHOUT_RECEIPT"})
                elif receipt["outcome"] != "REACHABLE":
                    problems.append({"source_id": row["id"], "code": "WEB_CONFIRMED_RECEIPT_NOT_REACHABLE"})
                elif not valid_web_url(str(receipt["locator"])):
                    problems.append({"source_id": row["id"], "code": "WEB_CONFIRMED_RECEIPT_INVALID_LOCATOR"})
                elif receipt["locator"] not in {row["url"], row["stable_url"]}:
                    problems.append({"source_id": row["id"], "code": "WEB_CONFIRMED_RECEIPT_LOCATOR_MISMATCH"})
            if row["living_tradition"] and not (row["community_or_lineage"] or row["notes"]):
                problems.append({"source_id": row["id"], "code": "LIVING_TRADITION_WITHOUT_CONTEXT"})
            if row["community_permission_required"] and not row["access_or_reuse_restrictions"]:
                problems.append({"source_id": row["id"], "code": "PERMISSION_WITHOUT_RESTRICTION_NOTE"})
        same_witness_links = [dict(row) for row in conn.execute(
            "SELECT id,same_witness_as_source_id FROM sources WHERE same_witness_as_source_id IS NOT NULL ORDER BY id"
        )]
        return {
            "status": "PASS" if not problems else "NEEDS_REVIEW",
            "source_count": conn.execute("SELECT COUNT(*) FROM sources").fetchone()[0],
            "web_confirmed": conn.execute("SELECT COUNT(*) FROM sources WHERE verification_status='WEB_CONFIRMED'").fetchone()[0],
            "url_syntax_valid": conn.execute("SELECT COUNT(*) FROM sources WHERE verification_status='URL_SYNTAX_VALID'").fetchone()[0],
            "registered": conn.execute("SELECT COUNT(*) FROM sources WHERE verification_status='REGISTERED'").fetchone()[0],
            "status_counts": {row[0]: row[1] for row in conn.execute(
                "SELECT verification_status,COUNT(*) FROM sources GROUP BY verification_status ORDER BY verification_status"
            )},
            "problems": problems,
            "same_witness_links": same_witness_links,
        }
    finally:
        conn.close()


def next_queue_batch(db_path: Path | str = DEFAULT_DB_PATH, limit: int = 20) -> list[dict]:
    conn = connect(db_path, readonly=True)
    try:
        return [dict(row) for row in conn.execute(
            """SELECT * FROM collection_queue
               WHERE status NOT IN ('BASELINE_COMPLETE','COLLECTING')
               ORDER BY priority DESC,
                        CASE status WHEN 'SOURCE_FOUND' THEN 0 WHEN 'NEEDS_REVIEW' THEN 1 ELSE 2 END,
                        created_at,id LIMIT ?""", (limit,)
        )]
    finally:
        conn.close()


def import_queue_jsonl(input_path: Path | str, db_path: Path | str = DEFAULT_DB_PATH,
                       *, apply: bool = False) -> dict:
    source_path = Path(input_path).resolve()
    source_label = source_path.name or "queue-import.jsonl"
    rows: list[dict] = []
    errors: list[dict] = []
    for line_number, line in enumerate(source_path.read_text(encoding="utf-8").splitlines(), 1):
        if not line.strip():
            continue
        try:
            item = json.loads(line)
            if not item.get("target_label") or not item.get("proposed_entity_type"):
                raise ValueError("target_label and proposed_entity_type are required")
            item["normalized_label"] = normalize_name(item["target_label"])
            rows.append({"line": line_number, "payload_summary": _audit_payload_summary(line), "item": item})
        except Exception as exc:  # validation report keeps the offending line local
            errors.append({"line": line_number, "code": "INVALID_JSONL_ROW", "error": str(exc),
                           "payload_summary": _audit_payload_summary(line)})
    result = {"mode": "apply" if apply else "dry_run", "input": source_label,
              "valid_rows": len(rows), "errors": errors, "inserted": 0, "skipped": 0}
    if not apply:
        return result
    started_at = datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")
    source_hash = sha256_file(source_path)
    run_fingerprint = f"{source_label}|{source_hash}|{started_at}"
    run_id = f"import.{hashlib.sha256(run_fingerprint.encode()).hexdigest()[:20]}"
    conn = connect(db_path)
    try:
        with conn:
            conn.execute(
                "INSERT INTO import_runs(id,started_at,source_path,source_hash,status) VALUES(?,?,?,?,?)",
                (run_id, started_at, source_label, source_hash, "RUNNING"),
            )
            for parsed in rows:
                item = parsed["item"]
                conn.execute("SAVEPOINT queue_import_row")
                try:
                    duplicate = conn.execute(
                        """SELECT id FROM collection_queue
                           WHERE normalized_label=? AND proposed_entity_type=?
                             AND COALESCE(civilization_id,'')=COALESCE(?, '')""",
                        (item["normalized_label"], item["proposed_entity_type"], item.get("civilization_id")),
                    ).fetchone()
                    if duplicate:
                        conn.execute("RELEASE queue_import_row")
                        result["skipped"] += 1
                        continue
                    fingerprint = "|".join([item["normalized_label"], item["proposed_entity_type"], item.get("civilization_id") or ""])
                    queue_id = item.get("id") or f"queue.import.{hashlib.sha256(fingerprint.encode()).hexdigest()[:16]}"
                    status = item.get("status", "NEW")
                    context = item.get("discovery_context", "JSONL import")
                    conn.execute(
                        """INSERT INTO collection_queue(
                               id,target_label,normalized_label,proposed_entity_type,civilization_id,
                               discovered_from_entity_id,discovered_from_claim_id,discovered_from_source_id,
                               discovery_context,priority,status,next_action,created_at,updated_at
                           ) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                        (queue_id, item["target_label"], item["normalized_label"], item["proposed_entity_type"],
                         item.get("civilization_id"), item.get("discovered_from_entity_id"),
                         item.get("discovered_from_claim_id"), item.get("discovered_from_source_id"), context,
                         int(item.get("priority", 50)), status, item.get("next_action"), started_at, started_at),
                    )
                    audit_hash = hashlib.sha256(f"{run_id}|{parsed['line']}|{queue_id}".encode()).hexdigest()[:20]
                    conn.execute(
                        """INSERT INTO queue_discoveries(
                               id,queue_id,discovered_from_entity_id,discovered_from_claim_id,
                               discovered_from_source_id,discovery_context,discovered_at
                           ) VALUES(?,?,?,?,?,?,?)""",
                        (f"discovery.import.{audit_hash}", queue_id, item.get("discovered_from_entity_id"),
                         item.get("discovered_from_claim_id"), item.get("discovered_from_source_id"),
                         context, started_at),
                    )
                    conn.execute(
                        """INSERT INTO queue_status_history(id,queue_id,old_status,new_status,changed_at,reason)
                           VALUES(?,?,?,?,?,?)""",
                        (f"history.import.{audit_hash}", queue_id, None, status, started_at,
                         f"Created by {run_id} from JSONL line {parsed['line']}"),
                    )
                    result["inserted"] += 1
                    conn.execute("RELEASE queue_import_row")
                except Exception as exc:
                    conn.execute("ROLLBACK TO queue_import_row")
                    conn.execute("RELEASE queue_import_row")
                    errors.append({"line": parsed["line"], "code": "DATABASE_ROW_ERROR",
                                   "error": str(exc), "payload_summary": parsed["payload_summary"]})
            for error in errors:
                conn.execute(
                    """INSERT INTO import_errors(import_run_id,row_locator,error_code,message,raw_payload)
                       VALUES(?,?,?,?,?)""",
                        (run_id, f"line:{error['line']}", error["code"], error["error"],
                         error.get("payload_summary")),
                )
            ended_at = datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")
            conn.execute(
                """UPDATE import_runs SET ended_at=?,status=?,inserted_count=?,skipped_count=?,error_count=? WHERE id=?""",
                (ended_at, "COMPLETE_WITH_ERRORS" if errors else "COMPLETE",
                 result["inserted"], result["skipped"], len(errors), run_id),
            )
    finally:
        conn.close()
    result["run_id"] = run_id
    result["errors"] = errors
    return result
