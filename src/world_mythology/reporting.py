from __future__ import annotations

import json
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

from .db import DEFAULT_DB_PATH, PROJECT_ROOT, connect, sha256_file
from .maintenance import extract_verification_receipt, source_locator_kind


def _md(value: object | None) -> str:
    if value is None or value == "":
        return "—"
    return str(value).replace("|", "\\|").replace("\n", " ")


def _write_table(path: Path, title: str, headers: list[str], rows: list[list[object]]) -> None:
    lines = [f"# {title}", "", "| " + " | ".join(headers) + " |", "|" + "|".join("---" for _ in headers) + "|"]
    lines.extend("| " + " | ".join(_md(value) for value in row) + " |" for row in rows)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _generate_indexes(conn, profile_root: Path) -> None:
    index_dir = profile_root / "indexes"
    civ_rows = [list(row) for row in conn.execute(
        "SELECT id,name_zh,canonical_name,tradition_type,research_status,evidence_status FROM civilizations ORDER BY canonical_name"
    )]
    _write_table(index_dir / "civilizations.md", "文明与文化传统索引", ["ID", "中文", "English", "Type", "Research", "Evidence"], civ_rows)

    collections = {
        "deities.md": ("神祇索引", "SELECT e.id,e.name_zh,e.canonical_name,e.primary_type,c.name_zh,e.research_status,e.evidence_status FROM deities e LEFT JOIN civilizations c ON c.id=e.primary_civilization_id ORDER BY c.canonical_name,e.canonical_name"),
        "artifacts.md": ("神器与武器索引", "SELECT e.id,e.name_zh,e.canonical_name,e.primary_type,c.name_zh,e.research_status,e.evidence_status FROM artifacts e LEFT JOIN civilizations c ON c.id=e.primary_civilization_id ORDER BY c.canonical_name,e.canonical_name"),
        "elements.md": ("元素、力量与概念索引", "SELECT e.id,e.name_zh,e.canonical_name,e.primary_type,c.name_zh,e.research_status,e.evidence_status FROM entities e LEFT JOIN civilizations c ON c.id=e.primary_civilization_id WHERE EXISTS (SELECT 1 FROM entity_classifications ec WHERE ec.entity_id=e.id AND ec.type_code IN ('ELEMENT','POWER','CONCEPT','COSMOLOGY')) ORDER BY e.primary_type,e.canonical_name"),
        "creatures.md": ("怪物、神兽与生物索引", "SELECT e.id,e.name_zh,e.canonical_name,e.primary_type,c.name_zh,e.research_status,e.evidence_status FROM creatures e LEFT JOIN civilizations c ON c.id=e.primary_civilization_id ORDER BY c.canonical_name,e.canonical_name"),
        "texts.md": ("古书与原始文献索引", "SELECT e.id,e.name_zh,e.canonical_name,e.primary_type,c.name_zh,tp.composition_period,e.evidence_status FROM texts e LEFT JOIN civilizations c ON c.id=e.primary_civilization_id LEFT JOIN text_profiles tp ON tp.entity_id=e.id ORDER BY c.canonical_name,e.canonical_name"),
        "sites.md": ("古迹、遗址与圣地索引", "SELECT e.id,e.name_zh,e.canonical_name,e.primary_type,c.name_zh,pp.reality_status,pp.unesco_status FROM entities e JOIN place_profiles pp ON pp.entity_id=e.id LEFT JOIN civilizations c ON c.id=e.primary_civilization_id ORDER BY c.canonical_name,e.canonical_name"),
        "events.md": ("神话事件索引", "SELECT e.id,e.name_zh,e.canonical_name,e.primary_type,c.name_zh,e.research_status,e.evidence_status FROM events e LEFT JOIN civilizations c ON c.id=e.primary_civilization_id ORDER BY c.canonical_name,e.canonical_name"),
    }
    headers = ["ID", "中文", "English", "Type", "Civilization", "Detail/Status", "Evidence"]
    for filename, (title, query) in collections.items():
        _write_table(index_dir / filename, title, headers, [list(row) for row in conn.execute(query)])

    source_rows = []
    for row in conn.execute("SELECT id,title,institution,source_type,evidence_tier,verification_status,url FROM sources ORDER BY evidence_tier,title"):
        source_rows.append([row["id"], row["title"], row["institution"], row["source_type"], row["evidence_tier"], row["verification_status"], f"[link]({row['url']})"])
    _write_table(index_dir / "sources.md", "来源索引", ["ID", "Title", "Institution", "Type", "Tier", "Verification", "URL"], source_rows)


def _generate_entity_profiles(conn, profile_root: Path) -> int:
    entity_dir = profile_root / "entities"
    entity_dir.mkdir(parents=True, exist_ok=True)
    count = 0
    for entity in conn.execute(
        """SELECT e.*,c.canonical_name AS civilization_en,c.name_zh AS civilization_zh
           FROM entities e LEFT JOIN civilizations c ON c.id=e.primary_civilization_id ORDER BY e.id"""
    ):
        lines = [f"# {entity['name_zh'] or entity['canonical_name']} / {entity['canonical_name']}", "",
                 f"- ID: `{entity['id']}`", f"- 类型: `{entity['primary_type']}`",
                 f"- 文明／传统: {_md(entity['civilization_zh'] or entity['civilization_en'])}",
                 f"- 原文名: {_md(entity['original_name'])}", f"- 转写: {_md(entity['transliteration'])}",
                 f"- 研究状态: `{entity['research_status']}`", f"- 证据状态: `{entity['evidence_status']}`", ""]
        if entity["description"]:
            lines.extend(["## 概要", "", entity["description"], ""])
        classifications = [row[0] for row in conn.execute(
            "SELECT type_code FROM entity_classifications WHERE entity_id=? ORDER BY is_primary DESC,type_code", (entity["id"],)
        )]
        lines.extend(["## 分类", "", ", ".join(f"`{item}`" for item in classifications), ""])
        relations = conn.execute(
            """SELECT r.claim_id,r.relationship_type,r.target_entity_id,t.canonical_name,t.name_zh,
                      r.certainty,r.confidence,r.is_inferred_inverse,
                      c.review_status,c.assertion_scope,c.knowledge_layer,
                      (SELECT COUNT(*) FROM evidence ev WHERE ev.claim_id=r.claim_id) AS evidence_count
               FROM relationship_edges_bidirectional r
               JOIN entities t ON t.id=r.target_entity_id
               JOIN claims c ON c.id=r.claim_id
               WHERE r.source_entity_id=? ORDER BY r.relationship_type,t.canonical_name""",
            (entity["id"],),
        ).fetchall()
        lines.extend(["## 关系网络", ""])
        if relations:
            lines.extend(["| Relation | Target | Review / layer | Evidence | Confidence | Direction |", "|---|---|---|---:|---:|---|"])
            for row in relations:
                direction = "inferred inverse" if row["is_inferred_inverse"] else "stored claim"
                review = f"{row['review_status']} / {row['assertion_scope']} / {row['knowledge_layer']}"
                lines.append(f"| `{row['relationship_type']}` | {row['name_zh'] or row['canonical_name']} (`{row['target_entity_id']}`) | {review} | {row['evidence_count']} | {row['confidence']:.2f} | {direction}; `{row['claim_id']}` |")
        else:
            lines.append("当前无关系边；保留为研究缺口。")
        lines.append("")
        claims = conn.execute(
            """SELECT c.id,c.statement,c.review_status,c.assertion_scope,c.confidence,
                      s.title AS source_title,s.url,e.source_location
               FROM claims c LEFT JOIN evidence e ON e.claim_id=c.id
               LEFT JOIN sources s ON s.id=e.source_id
               WHERE c.subject_id=? ORDER BY c.id""", (entity["id"],)
        ).fetchall()
        lines.extend(["## Claims 与证据", ""])
        if claims:
            for row in claims:
                lines.append(f"- `{row['id']}` [{row['review_status']} / {row['assertion_scope']} / {row['confidence']:.2f}] {row['statement']}")
                if row["source_title"]:
                    lines.append(f"  - 来源：[{row['source_title']}]({row['url']})；定位：{_md(row['source_location'])}")
                else:
                    lines.append("  - 来源：尚未固定；已进入缺失资料检查。")
        else:
            lines.append("尚无 claim；实体仅为发现/索引入口。")
        lines.extend(["", "> 本档案只代表当前阶段性基线，不是对该传统的最终或唯一解释。", ""])
        (entity_dir / f"{entity['id']}.md").write_text("\n".join(lines), encoding="utf-8")
        count += 1
    return count


def _coverage(conn) -> tuple[dict[str, float], str]:
    metrics: dict[str, float] = {}
    for table in ["civilizations", "entities", "sources", "claims", "evidence", "relationships", "conflicts", "collection_queue"]:
        metrics[table] = float(conn.execute(f'SELECT COUNT(*) FROM "{table}"').fetchone()[0])
    metrics["priority_civilizations"] = float(conn.execute("SELECT COUNT(*) FROM civilizations WHERE research_status='COLLECTING'").fetchone()[0])
    metrics["redirected_duplicate_entities"] = float(conn.execute("SELECT COUNT(*) FROM entity_redirects").fetchone()[0])
    metrics["canonical_entities"] = float(conn.execute(
        "SELECT COUNT(*) FROM entities WHERE id NOT IN (SELECT duplicate_entity_id FROM entity_redirects)"
    ).fetchone()[0])
    metrics["entities_with_claims"] = float(conn.execute("SELECT COUNT(DISTINCT subject_id) FROM claims").fetchone()[0])
    metrics["entities_with_evidence"] = float(conn.execute("SELECT COUNT(DISTINCT c.subject_id) FROM claims c JOIN evidence e ON e.claim_id=c.id").fetchone()[0])
    metrics["evidenced_claims"] = float(conn.execute("SELECT COUNT(DISTINCT claim_id) FROM evidence").fetchone()[0])
    metrics["verified_claims"] = float(conn.execute("SELECT COUNT(*) FROM claims WHERE review_status='VERIFIED'").fetchone()[0])
    metrics["unverified_or_provisional_claims"] = float(conn.execute("SELECT COUNT(*) FROM claims WHERE review_status IN ('UNVERIFIED','PROVISIONAL')").fetchone()[0])
    metrics["web_confirmed_sources"] = float(conn.execute("SELECT COUNT(*) FROM sources WHERE verification_status='WEB_CONFIRMED'").fetchone()[0])
    metrics["url_syntax_valid_sources"] = float(conn.execute("SELECT COUNT(*) FROM sources WHERE verification_status='URL_SYNTAX_VALID'").fetchone()[0])
    metrics["registered_sources"] = float(conn.execute("SELECT COUNT(*) FROM sources WHERE verification_status='REGISTERED'").fetchone()[0])
    metrics["sources_needing_review"] = float(conn.execute("SELECT COUNT(*) FROM sources WHERE verification_status='NEEDS_REVIEW'").fetchone()[0])
    metrics["living_tradition_sources"] = float(conn.execute("SELECT COUNT(*) FROM sources WHERE living_tradition=1").fetchone()[0])
    metrics["queue_new_or_discovered"] = float(conn.execute("SELECT COUNT(*) FROM collection_queue WHERE status IN ('NEW','DISCOVERED')").fetchone()[0])
    metrics["queue_source_found"] = float(conn.execute("SELECT COUNT(*) FROM collection_queue WHERE status='SOURCE_FOUND'").fetchone()[0])
    # Sparse-field metrics expose the actual research depth instead of treating
    # an empty profile shell as completed content.
    metrics["deity_profiles_with_domains"] = float(conn.execute(
        "SELECT COUNT(*) FROM deity_profiles WHERE COALESCE(domains_json,'[]') NOT IN ('[]','{}','')"
    ).fetchone()[0])
    metrics["artifact_profiles_with_abilities"] = float(conn.execute(
        "SELECT COUNT(*) FROM artifact_profiles WHERE COALESCE(abilities_json,'[]') NOT IN ('[]','{}','')"
    ).fetchone()[0])
    metrics["creature_profiles_with_abilities"] = float(conn.execute(
        "SELECT COUNT(*) FROM creature_profiles WHERE COALESCE(abilities_json,'[]') NOT IN ('[]','{}','')"
    ).fetchone()[0])
    metrics["text_profiles_with_summary"] = float(conn.execute(
        "SELECT COUNT(*) FROM text_profiles WHERE NULLIF(TRIM(COALESCE(summary,'')),'') IS NOT NULL"
    ).fetchone()[0])
    metrics["place_profiles_with_coordinates"] = float(conn.execute(
        "SELECT COUNT(*) FROM place_profiles WHERE latitude IS NOT NULL AND longitude IS NOT NULL"
    ).fetchone()[0])
    metrics["text_entities_with_evidence"] = float(conn.execute(
        """SELECT COUNT(DISTINCT t.id) FROM texts t JOIN claims c ON c.subject_id=t.id
           JOIN evidence ev ON ev.claim_id=c.id"""
    ).fetchone()[0])
    metrics["place_entities_with_evidence"] = float(conn.execute(
        """SELECT COUNT(DISTINCT p.entity_id) FROM place_profiles p JOIN claims c ON c.subject_id=p.entity_id
           JOIN evidence ev ON ev.claim_id=c.id"""
    ).fetchone()[0])
    summary = "当前公开可发现资料的阶段性知识基线已经建立，并且系统可以继续扩张。"
    return metrics, summary


def _write_coverage(conn, report_dir: Path) -> dict[str, float]:
    metrics, summary = _coverage(conn)
    release = conn.execute(
        "SELECT id,data_version,built_at FROM dataset_releases ORDER BY built_at DESC,id DESC LIMIT 1"
    ).fetchone()
    report_id = f"coverage.{release['id']}"
    generated_at = datetime.now(timezone.utc).isoformat(timespec="seconds").replace("+00:00", "Z")
    conn.execute("DELETE FROM coverage_reports WHERE id=?", (report_id,))
    conn.execute("INSERT INTO coverage_reports(id,generated_at,baseline_label,summary) VALUES(?,?,?,?)",
                 (report_id, generated_at, release["data_version"], summary))
    for key, value in sorted(metrics.items()):
        denominator_keys = {
            "deity_profiles_with_domains": "deity_profiles",
            "artifact_profiles_with_abilities": "artifact_profiles",
            "creature_profiles_with_abilities": "creature_profiles",
            "text_profiles_with_summary": "text_profiles",
            "place_profiles_with_coordinates": "place_profiles",
            "text_entities_with_evidence": "texts",
            "place_entities_with_evidence": "place_profiles",
        }
        denominator = None
        notes = "Absolute count in the current registered baseline; not a percentage of world mythology."
        if key == "evidenced_claims":
            denominator = metrics["claims"]
            notes = "Claims with at least one evidence record / all currently registered claims."
        if key == "entities_with_evidence":
            denominator = metrics["entities"]
            notes = "Current registered entities with at least one evidenced outgoing claim; not global completeness."
        if key in denominator_keys:
            denominator = float(conn.execute(f'SELECT COUNT(*) FROM "{denominator_keys[key]}"').fetchone()[0])
            notes = "Populated or evidence-linked records / current records in this registered profile collection."
        conn.execute("INSERT INTO coverage_metrics(report_id,metric_key,metric_value,denominator,notes) VALUES(?,?,?,?,?)",
                     (report_id, key, value, denominator, notes))
    lines = ["# 阶段覆盖报告 / Coverage Report", "", summary, "",
             f"数据版本：`{release['data_version']}`；生成时间：`{generated_at}`。", "",
             "> 所有分母只指当前登记基线；系统不会计算或宣称“全球神话完成百分比”。", "",
             "| Metric | Value | Denominator | Meaning |", "|---|---:|---:|---|"]
    for row in conn.execute("SELECT metric_key,metric_value,denominator,notes FROM coverage_metrics WHERE report_id=? ORDER BY metric_key", (report_id,)):
        lines.append(f"| `{row['metric_key']}` | {int(row['metric_value'])} | {_md(int(row['denominator']) if row['denominator'] is not None else None)} | {row['notes']} |")
    lines.extend(["", "## 当前结论", "", summary, "",
                  "下一轮优先由永久队列决定：来源已发现但 claim 尚稀疏、能扩张最多关系边、以及文化权限模型尚未完成的项目优先。", ""])
    (report_dir / "coverage_report.md").write_text("\n".join(lines), encoding="utf-8")
    return metrics


def _write_operational_reports(conn, report_dir: Path) -> None:
    conflicts = [list(row) for row in conn.execute(
        "SELECT id,subject_id,conflict_type,status,summary FROM conflicts ORDER BY status,id"
    )]
    _write_table(report_dir / "conflicts.md", "冲突与版本报告", ["ID", "Subject", "Type", "Status", "Summary"], conflicts)
    queue = [list(row) for row in conn.execute(
        "SELECT id,target_label,proposed_entity_type,civilization_id,priority,status,next_action FROM collection_queue ORDER BY priority DESC,id"
    )]
    _write_table(report_dir / "research_queue.md", "永久研究队列", ["ID", "Target", "Type", "Civilization", "Priority", "Status", "Next action"], queue)
    missing_by_type = [list(row) for row in conn.execute(
        """SELECT primary_type,COUNT(*) AS total,
                  SUM(CASE WHEN evidence_status='UNVERIFIED' THEN 1 ELSE 0 END) AS unverified,
                  SUM(CASE WHEN id NOT IN (SELECT subject_id FROM claims) THEN 1 ELSE 0 END) AS without_claim
           FROM entities GROUP BY primary_type ORDER BY without_claim DESC,primary_type"""
    )]
    lines = ["# 缺失资料报告", "", "缺失项保留为空值或研究状态，不用臆造内容填满。", "",
             "| Type | Registered | Unverified | Without outgoing claim |", "|---|---:|---:|---:|"]
    lines.extend(f"| `{row[0]}` | {row[1]} | {row[2]} | {row[3]} |" for row in missing_by_type)
    unsourced = [list(row) for row in conn.execute(
        """SELECT c.id,c.subject_id,c.predicate,c.review_status,c.statement FROM claims c
           LEFT JOIN evidence e ON e.claim_id=c.id WHERE e.id IS NULL ORDER BY c.review_status,c.id"""
    )]
    lines.extend(["", "## 尚未固定来源的 claims", ""])
    if unsourced:
        lines.extend(["| Claim | Subject | Predicate | Review | Statement |", "|---|---|---|---|---|"])
        lines.extend("| " + " | ".join(_md(v) for v in row) + " |" for row in unsourced)
    else:
        lines.append("无。")
    (report_dir / "missing_data.md").write_text("\n".join(lines) + "\n", encoding="utf-8")

    source_lines = ["# 来源验证报告", "",
                    "本报告区分来源登记、URL 语法检查与可复验网络确认。访问日期是登记元数据，不等同于访问成功回执；没有结构化回执的记录不会标为 `WEB_CONFIRMED`。", "",
                    "状态协议：`REGISTERED` 表示有 DOI、ISBN、馆藏号、手稿号等稳定定位符；`URL_SYNTAX_VALID` 只表示 HTTP(S) URL 结构有效；`WEB_CONFIRMED` 还必须在 notes 中保留机器可读的 `VERIFICATION_RECEIPT_JSON`（checked_at、method、locator、outcome）。", "",
                    "| Status | Count |", "|---|---:|"]
    for row in conn.execute("SELECT verification_status,COUNT(*) FROM sources GROUP BY verification_status ORDER BY verification_status"):
        source_lines.append(f"| {row[0]} | {row[1]} |")
    source_lines.extend(["", "## 同一文本见证的多个入口", "", "| Source | Same witness as |", "|---|---|"])
    same_rows = conn.execute("SELECT id,same_witness_as_source_id FROM sources WHERE same_witness_as_source_id IS NOT NULL ORDER BY id").fetchall()
    if same_rows:
        source_lines.extend(f"| `{row[0]}` | `{row[1]}` |" for row in same_rows)
    else:
        source_lines.append("| — | — |")
    source_lines.extend(["", "网络可达性会变化；即使有回执，`WEB_CONFIRMED` 也只证明回执记录的检查时点与结果，不代表永久在线、内容正确或学术结论成立。", ""])
    (report_dir / "source_validation.md").write_text("\n".join(source_lines), encoding="utf-8")

    registry_lines = [
        "# 完整来源登记表 / Source Registry", "",
        "以下逐条列出当前数据库全部来源。定位符可以是 URL、stable URL、DOI、ISBN、馆藏号或手稿号；URL 语法有效不等于已联网确认。", "",
        "| ID | Title | Institution | Type | Tier | Verification | Accessed | Locator | Locator type | Culture / permission context | Receipt |",
        "|---|---|---|---|---:|---|---|---|---|---|---|",
    ]
    for row in conn.execute("SELECT * FROM sources ORDER BY evidence_tier,title,id"):
        locators = []
        if row["url"]:
            locators.append(f"URL: [{row['url']}]({row['url']})")
        if row["stable_url"]:
            locators.append(f"stable: [{row['stable_url']}]({row['stable_url']})")
        for key, label in (("doi", "DOI"), ("isbn", "ISBN"), ("catalogue_number", "catalogue"),
                           ("manuscript_number", "manuscript")):
            if row[key]:
                locators.append(f"{label}: `{row[key]}`")
        context = "; ".join(filter(None, [
            f"perspective={row['source_perspective']}" if row["source_perspective"] else None,
            f"community={row['community_or_lineage']}" if row["community_or_lineage"] else None,
            f"collector={row['collector_context']}" if row["collector_context"] else None,
            "living tradition" if row["living_tradition"] else None,
            "community permission required" if row["community_permission_required"] else None,
            row["access_or_reuse_restrictions"],
            f"notes={row['notes']}" if row["notes"] else None,
        ]))
        receipt = extract_verification_receipt(row["notes"])
        receipt_label = "present" if receipt else "—"
        registry_lines.append("| " + " | ".join(_md(value) for value in (
            f"`{row['id']}`", row["title"], row["institution"], row["source_type"], row["evidence_tier"],
            row["verification_status"], row["accessed_date"], "; ".join(locators), source_locator_kind(row), context, receipt_label,
        )) + " |")
    registry_lines.extend(["", f"登记总数：{conn.execute('SELECT COUNT(*) FROM sources').fetchone()[0]}。", ""])
    (report_dir / "source_registry.md").write_text("\n".join(registry_lines), encoding="utf-8")


def _write_visual_data(conn, visualization_dir: Path) -> None:
    visualization_dir.mkdir(parents=True, exist_ok=True)
    nodes = [dict(row) for row in conn.execute(
        """SELECT id,canonical_name,name_zh,primary_type,primary_civilization_id,evidence_status
           FROM entities
           WHERE id IN (SELECT source_entity_id FROM relationships UNION SELECT target_entity_id FROM relationships)
           ORDER BY id"""
    )]
    edges = [dict(row) for row in conn.execute(
        """SELECT r.id,r.source_entity_id,r.relationship_type,r.target_entity_id,r.claim_id,
                  r.certainty,r.confidence,c.review_status,c.assertion_scope,c.knowledge_layer,
                  (SELECT COUNT(*) FROM evidence ev WHERE ev.claim_id=r.claim_id) AS evidence_count
           FROM relationships r JOIN claims c ON c.id=r.claim_id ORDER BY r.id"""
    )]
    payload = json.dumps({"nodes": nodes, "edges": edges}, ensure_ascii=False, separators=(",", ":"))
    (visualization_dir / "graph-data.js").write_text(f"window.MYTH_GRAPH={payload};\n", encoding="utf-8")


def generate_reports(db_path: Path | str = DEFAULT_DB_PATH) -> dict:
    profile_root = PROJECT_ROOT / "profiles"
    report_dir = PROJECT_ROOT / "reports"
    report_dir.mkdir(parents=True, exist_ok=True)
    conn = connect(db_path)
    try:
        with conn:
            metrics = _write_coverage(conn, report_dir)
        _generate_indexes(conn, profile_root)
        profile_count = _generate_entity_profiles(conn, profile_root)
        _write_operational_reports(conn, report_dir)
        _write_visual_data(conn, PROJECT_ROOT / "visualization")
    finally:
        conn.close()
    with connect(db_path, readonly=True) as read_conn:
        release = read_conn.execute(
            "SELECT id,data_version,built_at FROM dataset_releases ORDER BY built_at DESC,id DESC LIMIT 1"
        ).fetchone()
        next_round = [row[0] for row in read_conn.execute(
            """SELECT target_label FROM collection_queue
               WHERE status NOT IN ('BASELINE_COMPLETE','EXPAND_LATER')
               ORDER BY priority DESC,
                        CASE status WHEN 'CONFLICT' THEN 0 WHEN 'NEEDS_REVIEW' THEN 1
                                    WHEN 'SOURCE_FOUND' THEN 2 ELSE 3 END,
                        id LIMIT 5"""
        )]
    generated_at = datetime.now(timezone.utc).isoformat(timespec="seconds").replace("+00:00", "Z")
    checkpoint = {
        "checkpoint": f"WORLD_MYTHOLOGY_{release['data_version'].upper().replace('-', '_').replace('.', '_')}",
        "release_id": release["id"],
        "generated_at": generated_at,
        "status": "STAGED_EXPANDABLE_BASELINE",
        "database_sha256": sha256_file(db_path),
        "entity_profiles": profile_count,
        "metrics": {key: int(value) for key, value in metrics.items()},
        "next_round": next_round,
        "completion_claim": "Current publicly discoverable material has a staged knowledge baseline; the system remains expandable.",
    }
    (report_dir / "checkpoint.json").write_text(json.dumps(checkpoint, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    return checkpoint
