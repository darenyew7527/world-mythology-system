from __future__ import annotations

import os
import sqlite3
from pathlib import Path

from . import seed_data
from .db import BUILD_TIMESTAMP, DEFAULT_DB_PATH, SCHEMA_PATH, canonical_json, connect, normalize_name


DEFAULT_LANGUAGE_BY_CIVILIZATION = {
    "civ.greek": "lang.grc", "civ.roman": "lang.lat", "civ.norse": "lang.non",
    "civ.egyptian": "lang.egy", "civ.sumerian": "lang.sux", "civ.akkadian": "lang.akk",
    "civ.babylonian": "lang.akk", "civ.assyrian": "lang.akk", "civ.ugaritic": "lang.uga",
    "civ.vedic": "lang.san", "civ.hindu": "lang.san", "civ.zoroastrian": "lang.ave",
    "civ.chinese_ancient": "lang.lzh", "civ.daoist": "lang.lzh", "civ.chinese_folk": "lang.zh",
    "civ.japanese_shinto": "lang.ojp", "civ.maya": "lang.myn", "civ.mexica": "lang.nci",
    "civ.irish": "lang.gle", "civ.ifa": "lang.yrb", "civ.yoruba": "lang.yrb",
    "civ.hawaiian": "lang.haw", "civ.maori": "lang.mai",
}


def _execute_schema(conn: sqlite3.Connection) -> None:
    conn.executescript(SCHEMA_PATH.read_text(encoding="utf-8"))
    conn.execute(
        "INSERT INTO schema_migrations(version,name,applied_at) VALUES(?,?,?)",
        (1, "initial evidence-aware knowledge schema", BUILD_TIMESTAMP),
    )


def _insert_foundations(conn: sqlite3.Connection) -> None:
    conn.executemany(
        "INSERT INTO regions(id,canonical_name,name_zh,parent_id) VALUES(?,?,?,?)",
        seed_data.REGIONS,
    )
    conn.executemany(
        "INSERT INTO languages(id,canonical_name,name_zh,iso_639_3,script_name,historical_stage) VALUES(?,?,?,?,?,?)",
        seed_data.LANGUAGES,
    )
    for code, label_en, label_zh, parent in seed_data.ENTITY_TYPES:
        conn.execute(
            "INSERT INTO entity_types(code,label_en,label_zh,parent_code) VALUES(?,?,?,NULL)",
            (code, label_en, label_zh),
        )
    for code, _label_en, _label_zh, parent in seed_data.ENTITY_TYPES:
        if parent:
            conn.execute("UPDATE entity_types SET parent_code=? WHERE code=?", (parent, code))
    for code, inverse, label_en, label_zh, category, symmetric in seed_data.RELATIONSHIP_TYPES:
        conn.execute(
            "INSERT INTO relationship_types(code,inverse_code,label_en,label_zh,category,is_symmetric) VALUES(?,NULL,?,?,?,?)",
            (code, label_en, label_zh, category, symmetric),
        )
    for code, inverse, *_rest in seed_data.RELATIONSHIP_TYPES:
        conn.execute("UPDATE relationship_types SET inverse_code=? WHERE code=?", (inverse, code))
    for civ_id, name, zh, parent, region, tradition_type, priority in seed_data.CIVILIZATIONS:
        conn.execute(
            """INSERT INTO civilizations(
                   id,canonical_name,name_zh,parent_id,region_id,tradition_type,research_status,evidence_status
               ) VALUES(?,?,?,?,?,?,?,?)""",
            (civ_id, name, zh, parent, region, tradition_type,
             "COLLECTING" if priority else "DISCOVERED", "PARTIAL" if priority else "UNVERIFIED"),
        )
    for civilization_id, language_id in DEFAULT_LANGUAGE_BY_CIVILIZATION.items():
        conn.execute(
            """INSERT INTO civilization_languages(civilization_id,language_id,usage_role,notes)
               VALUES(?,?,?,?)""",
            (civilization_id, language_id, "ATTESTED",
             "Baseline language link for discovery and name routing; not an exclusivity claim."),
        )
    conn.executemany(
        """INSERT INTO cultures(
               id,canonical_name,name_zh,parent_id,civilization_id,region_id,description,research_status
           ) VALUES(?,?,?,?,?,?,?,?)""",
        [(*row, "PARTIAL") for row in seed_data.CULTURES],
    )
    for child, parent in [
        ("civ.anglo_saxon", "civ.germanic"), ("civ.irish", "civ.celtic"),
        ("civ.welsh", "civ.celtic"), ("civ.gaulish", "civ.celtic"),
        ("civ.ifa", "civ.yoruba"), ("civ.babylonian", "civ.akkadian"),
    ]:
        conn.execute(
            "INSERT OR IGNORE INTO tradition_links(source_civilization_id,link_type,target_civilization_id,notes) VALUES(?,?,?,?)",
            (child, "SUBTRADITION_OF", parent, "First-round scope relationship; historical nuance remains researchable."),
        )


def _insert_sources(conn: sqlite3.Connection) -> None:
    columns = [
        "id", "title", "source_type", "evidence_tier", "institution", "author_or_editor",
        "language_id", "accessed_date", "url", "catalogue_number", "manuscript_number",
        "rights_status", "verification_status", "notes", "source_perspective",
        "community_or_lineage", "collector_context", "living_tradition",
        "access_or_reuse_restrictions", "community_permission_required",
        "same_witness_as_source_id", "translation_status",
    ]
    sql = f"INSERT INTO sources({','.join(columns)}) VALUES({','.join('?' for _ in columns)})"
    pending = list(seed_data.SOURCES)
    # Same-witness references can point forward. Insert without links, then patch links.
    for source in pending:
        row = dict(source)
        row["same_witness_as_source_id"] = None
        conn.execute(sql, tuple(row.get(col) for col in columns))
    for source in pending:
        if source.get("same_witness_as_source_id"):
            conn.execute(
                "UPDATE sources SET same_witness_as_source_id=? WHERE id=?",
                (source["same_witness_as_source_id"], source["id"]),
            )


def _insert_entities(conn: sqlite3.Connection) -> None:
    seen: set[str] = set()
    for entity in seed_data.CORE_ENTITIES:
        if entity["id"] in seen:
            raise ValueError(f"duplicate seed entity id: {entity['id']}")
        seen.add(entity["id"])
        conn.execute(
            """INSERT INTO entities(
                   id,canonical_name,name_zh,original_name,transliteration,primary_type,
                   primary_civilization_id,description,research_status,evidence_status,
                   metadata_json,created_at,updated_at
               ) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)""",
            (
                entity["id"], entity["canonical_name"], entity.get("name_zh"), entity.get("original_name"),
                entity.get("transliteration"), entity["primary_type"], entity.get("civilization_id"),
                entity.get("description"), entity.get("research_status", "PARTIAL"),
                "UNVERIFIED", "{}", BUILD_TIMESTAMP, BUILD_TIMESTAMP,
            ),
        )
        types = [entity["primary_type"], *entity.get("extra_types", [])]
        for index, type_code in enumerate(dict.fromkeys(types)):
            conn.execute(
                "INSERT INTO entity_classifications(entity_id,type_code,is_primary) VALUES(?,?,?)",
                (entity["id"], type_code, 1 if index == 0 else 0),
            )
        if entity.get("civilization_id"):
            conn.execute(
                "INSERT INTO entity_civilizations(entity_id,civilization_id,association_role,certainty) VALUES(?,?,?,?)",
                (entity["id"], entity["civilization_id"], "ORIGIN_OR_ATTESTATION", "SUPPORTED"),
            )
        name_rows = [
            ("canonical", entity["canonical_name"], "lang.en", "CANONICAL", 1),
        ]
        if entity.get("name_zh"):
            name_rows.append(("zh", entity["name_zh"], "lang.zh", "TRANSLATION", 1))
        if entity.get("original_name") and entity["original_name"] != entity["canonical_name"]:
            language = DEFAULT_LANGUAGE_BY_CIVILIZATION.get(entity.get("civilization_id"))
            name_rows.append(("original", entity["original_name"], language, "ORIGINAL", 1))
        for suffix, text, language, kind, preferred in name_rows:
            conn.execute(
                """INSERT OR IGNORE INTO names(
                       id,entity_id,name_text,normalized_text,language_id,name_type,is_preferred
                   ) VALUES(?,?,?,?,?,?,?)""",
                (f"name.{entity['id']}.{suffix}", entity["id"], text, normalize_name(text), language, kind, preferred),
            )


def _insert_aliases_and_identity(conn: sqlite3.Connection) -> None:
    for alias_id, text, normalized, lang, entity_id, status, confidence, notes in seed_data.EXPLICIT_ALIASES:
        conn.execute(
            """INSERT INTO aliases(
                   id,alias_text,normalized_text,language_id,entity_id,resolution_status,confidence,notes
               ) VALUES(?,?,?,?,?,?,?,?)""",
            (alias_id, text, normalized, lang, entity_id, status, confidence, notes),
        )
    for row in seed_data.IDENTITY_CANDIDATES:
        candidate_id, entity_a, entity_b, assessment, confidence, source_id, notes = row
        if entity_a == entity_b:
            continue
        conn.execute(
            """INSERT INTO identity_candidates(
                   id,entity_a_id,entity_b_id,assessment,confidence,source_id,notes
               ) VALUES(?,?,?,?,?,?,?)""",
            (candidate_id, entity_a, entity_b, assessment, confidence, source_id, notes),
        )


def _insert_profiles(conn: sqlite3.Connection) -> None:
    rows = conn.execute(
        """SELECT e.id,e.primary_type
           FROM entities e"""
    ).fetchall()
    deity_types = {"DEITY", "PRIMORDIAL_DEITY", "ANCESTOR_DEITY"}
    artifact_types = {"ARTIFACT", "WEAPON", "SACRED_OBJECT", "ARMOR", "RING", "CROWN", "SCEPTER", "SHIP", "CHARIOT", "MOUNT"}
    creature_types = {"CREATURE", "MONSTER", "DIVINE_BEAST", "DRAGON", "GIANT", "DEMON", "SPIRIT", "UNDEAD"}
    text_types = {"TEXT", "EPIC", "SCRIPTURE", "MANUSCRIPT", "TABLET", "INSCRIPTION", "PAPYRUS", "ORAL_TRADITION"}
    place_types = {"PLACE", "REALM", "MYTHICAL_PLACE", "ARCHAEOLOGICAL_SITE", "TEMPLE", "PYRAMID", "TOMB", "MONUMENT"}

    def profile_type(primary_type: str, type_codes: set[str], eligible: set[str]) -> str:
        """Choose a stable profile label without hiding secondary classifications."""
        return primary_type if primary_type in eligible else sorted(type_codes & eligible)[0]

    for row in rows:
        type_codes = {r[0] for r in conn.execute("SELECT type_code FROM entity_classifications WHERE entity_id=?", (row["id"],))}
        if type_codes & deity_types:
            conn.execute("INSERT INTO deity_profiles(entity_id,deity_class) VALUES(?,?)", (
                row["id"], profile_type(row["primary_type"], type_codes, deity_types)
            ))
        if type_codes & artifact_types:
            conn.execute("INSERT INTO artifact_profiles(entity_id,artifact_type) VALUES(?,?)", (
                row["id"], profile_type(row["primary_type"], type_codes, artifact_types)
            ))
        if type_codes & creature_types:
            conn.execute("INSERT INTO creature_profiles(entity_id,creature_class) VALUES(?,?)", (
                row["id"], profile_type(row["primary_type"], type_codes, creature_types)
            ))
        if type_codes & text_types:
            conn.execute("INSERT INTO text_profiles(entity_id,text_type) VALUES(?,?)", (
                row["id"], profile_type(row["primary_type"], type_codes, text_types)
            ))
        if type_codes & place_types:
            reality_status = "MYTHICAL" if type_codes & {"REALM", "MYTHICAL_PLACE"} else "REAL_ARCHAEOLOGICAL"
            conn.execute(
                "INSERT INTO place_profiles(entity_id,place_type,reality_status) VALUES(?,?,?)",
                (row["id"], profile_type(row["primary_type"], type_codes, place_types), reality_status),
            )
        if "EVENT" in type_codes:
            conn.execute("INSERT INTO myth_event_profiles(entity_id,event_type) VALUES(?,?)", (row["id"], "EVENT"))
    for row in seed_data.TEXT_SEEDS:
        entity_id, _title, _zh, _original, _etype, _civ, language, period, author, text_type = row
        conn.execute(
            """INSERT INTO text_profiles(
                   entity_id,text_type,original_language_id,attributed_author,composition_period
               ) VALUES(?,?,?,?,?)
               ON CONFLICT(entity_id) DO UPDATE SET
                   text_type=excluded.text_type,
                   original_language_id=excluded.original_language_id,
                   attributed_author=excluded.attributed_author,
                   composition_period=excluded.composition_period""",
            (entity_id, text_type, language, author, period),
        )
    for row in seed_data.PLACE_SEEDS:
        entity_id, _name, _zh, _etype, _civ, country, place_type, reality, unesco = row
        conn.execute(
            """INSERT INTO place_profiles(
                   entity_id,place_type,country_code,unesco_status,reality_status,evidence_grade
               ) VALUES(?,?,?,?,?,?)
               ON CONFLICT(entity_id) DO UPDATE SET
                   place_type=excluded.place_type,
                   country_code=excluded.country_code,
                   unesco_status=excluded.unesco_status,
                   reality_status=excluded.reality_status,
                   evidence_grade=excluded.evidence_grade""",
            (entity_id, place_type, country, unesco, reality, "BASELINE_METADATA"),
        )
    for entity_id, event_type in [
        ("event.greek.titanomachy", "DIVINE_WAR"), ("event.norse.ragnarok", "WORLD_END_AND_RENEWAL"),
        ("event.sumerian.inanna_descent", "UNDERWORLD_JOURNEY"),
        ("event.babylonian.marduk_tiamat", "CREATION_COMBAT"),
    ]:
        conn.execute(
            """INSERT INTO myth_event_profiles(entity_id,event_type) VALUES(?,?)
               ON CONFLICT(entity_id) DO UPDATE SET event_type=excluded.event_type""",
            (entity_id, event_type),
        )
    museum_profiles = [
        ("museum.egypt.papyrus_ani_frame3", "British Museum", "EA10470,3", "PAPYRUS"),
        ("museum.babylon.flood_tablet_k3375", "British Museum", "K.3375", "CUNEIFORM_TABLET"),
        ("museum.ugarit.baal_cycle_ao16643", "Musée du Louvre", "AO 16643 / RS 3.361 / KTU 1.1", "CUNEIFORM_TABLET"),
        ("museum.ugarit.baal_thunder_ao15775", "Musée du Louvre", "AO 15775 / RS 4.427", "STELE"),
        ("museum.norse.mjolnir_rings", "Swedish History Museum", "107837_HST; 108686_HST", "AMULET_COLLECTION"),
        ("museum.greek.zeus_poseidon_met_21_88_52", "Metropolitan Museum of Art", "21.88.52", "BRONZE_STATUETTE"),
    ]
    conn.executemany(
        "INSERT INTO museum_object_profiles(entity_id,holding_institution,catalogue_number,object_type) VALUES(?,?,?,?)",
        museum_profiles,
    )


def _insert_claims_and_evidence(conn: sqlite3.Connection) -> None:
    for claim in seed_data.CLAIMS:
        conn.execute(
            """INSERT INTO claims(
                   id,subject_id,predicate,object_entity_id,object_literal,object_datatype,statement,
                   variant_group,claim_status,confidence,confidence_level,review_status,assertion_scope,
                   knowledge_layer,research_notes,created_at
               ) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
            (
                claim["id"], claim["subject_id"], claim["predicate"], claim.get("object_entity_id"),
                claim.get("object_literal"), "STRING" if claim.get("object_literal") is not None else "ENTITY",
                claim["statement"], claim.get("variant_group"), claim["claim_status"], claim["confidence"],
                claim["confidence_level"], claim["review_status"], claim["assertion_scope"],
                claim["knowledge_layer"], claim.get("research_notes"), BUILD_TIMESTAMP,
            ),
        )
        if claim.get("source_id"):
            conn.execute(
                """INSERT INTO evidence(
                       id,claim_id,source_id,source_location,evidence_type,direction,strength,research_notes
                   ) VALUES(?,?,?,?,?,?,?,?)""",
                (
                    f"evidence.{claim['id']}", claim["id"], claim["source_id"], claim.get("source_location"),
                    claim["evidence_type"], "SUPPORTS", claim["evidence_strength"], claim.get("research_notes"),
                ),
            )
        if claim.get("object_entity_id") and claim["predicate"] == "PARTICIPATED_IN":
            conn.execute(
                "INSERT OR IGNORE INTO event_participants(event_id,participant_id,role,claim_id) VALUES(?,?,?,?)",
                (claim["object_entity_id"], claim["subject_id"], "PARTICIPANT", claim["id"]),
            )
    for conflict in seed_data.CONFLICTS:
        conn.execute(
            """INSERT INTO conflicts(
                   id,subject_id,variant_group,claim_a_id,claim_b_id,conflict_type,status,summary
               ) VALUES(?,?,?,?,?,?,?,?)""",
            conflict,
        )


def _insert_queue(conn: sqlite3.Connection) -> None:
    for queue_id, label, proposed_type, civ, from_entity, context, priority, status, next_action in seed_data.QUEUE_SEEDS:
        conn.execute(
            """INSERT INTO collection_queue(
                   id,target_label,normalized_label,proposed_entity_type,civilization_id,
                   discovered_from_entity_id,discovery_context,priority,status,next_action,created_at,updated_at
               ) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)""",
            (queue_id, label, normalize_name(label), proposed_type, civ, from_entity, context, priority, status,
             next_action, BUILD_TIMESTAMP, BUILD_TIMESTAMP),
        )
        conn.execute(
            """INSERT INTO queue_discoveries(
                   id,queue_id,discovered_from_entity_id,discovery_context,discovered_at
               ) VALUES(?,?,?,?,?)""",
            (f"discovery.{queue_id}.1", queue_id, from_entity, context, BUILD_TIMESTAMP),
        )
        conn.execute(
            "INSERT INTO queue_status_history(id,queue_id,old_status,new_status,changed_at,reason) VALUES(?,?,?,?,?,?)",
            (f"history.{queue_id}.1", queue_id, None, status, BUILD_TIMESTAMP, "First-round discovery baseline"),
        )


def _insert_metadata(conn: sqlite3.Connection) -> None:
    metadata = {
        "project_name": "世界神话系统 / World Mythology System",
        "data_version": "0.1.0-baseline-20260810",
        "schema_version": "1",
        "baseline_statement": "Current publicly discoverable material has a staged knowledge baseline; the system remains expandable.",
        "completion_policy": "NO_ALL_COMPLETE",
        "generated_at": BUILD_TIMESTAMP,
    }
    conn.executemany(
        "INSERT INTO project_metadata(key,value,updated_at) VALUES(?,?,?)",
        [(key, value, BUILD_TIMESTAMP) for key, value in metadata.items()],
    )
    conn.execute(
        "INSERT INTO research_sessions(id,started_at,ended_at,scope,strategy,status,agent_or_process,notes) VALUES(?,?,?,?,?,?,?,?)",
        (
            "research.20260810.baseline1", BUILD_TIMESTAMP, BUILD_TIMESTAMP,
            "First-round global mythology architecture and evidence baseline",
            "Parallel authoritative-source discovery plus deterministic seed ingestion",
            "CHECKPOINT_COMPLETE", "Codex primary agent with three parallel sub-agents",
            "No claim of global completeness; queue continues expansion.",
        ),
    )
    conn.execute(
        "INSERT INTO dataset_releases(id,schema_version,data_version,built_at,release_notes) VALUES(?,?,?,?,?)",
        (
            "release.0.1.0", 1, "0.1.0-baseline-20260810", BUILD_TIMESTAMP,
            "First executable, evidence-aware, globally expandable baseline.",
        ),
    )


def _refresh_evidence_status(conn: sqlite3.Connection) -> None:
    conn.execute(
        """UPDATE entities
           SET evidence_status='PARTIAL'
           WHERE id IN (SELECT DISTINCT subject_id FROM claims)"""
    )
    conn.execute(
        """UPDATE entities
           SET evidence_status='SOURCE_BACKED'
           WHERE EXISTS (
               SELECT 1 FROM claims c WHERE c.subject_id=entities.id
           )
             AND NOT EXISTS (
               SELECT 1
               FROM claims c
               WHERE c.subject_id=entities.id
                 AND NOT EXISTS (SELECT 1 FROM evidence e WHERE e.claim_id=c.id)
           )"""
    )
    conn.execute(
        "UPDATE entities SET evidence_status='CONFLICTING' WHERE id IN (SELECT subject_id FROM conflicts WHERE status='OPEN')"
    )


def build_database(output_path: Path | str = DEFAULT_DB_PATH) -> Path:
    output = Path(output_path).resolve()
    output.parent.mkdir(parents=True, exist_ok=True)
    temp = output.with_suffix(output.suffix + ".building")
    if temp.exists():
        temp.unlink()
    conn = connect(temp)
    try:
        with conn:
            _execute_schema(conn)
            _insert_foundations(conn)
            _insert_sources(conn)
            _insert_entities(conn)
            _insert_aliases_and_identity(conn)
            _insert_profiles(conn)
            _insert_claims_and_evidence(conn)
            _insert_queue(conn)
            _refresh_evidence_status(conn)
            _insert_metadata(conn)
        result = conn.execute("PRAGMA integrity_check").fetchone()[0]
        if result != "ok":
            raise RuntimeError(f"SQLite integrity check failed: {result}")
        foreign_keys = conn.execute("PRAGMA foreign_key_check").fetchall()
        if foreign_keys:
            raise RuntimeError(f"SQLite foreign key check failed: {foreign_keys[:5]}")
        conn.execute("PRAGMA wal_checkpoint(TRUNCATE)")
    finally:
        conn.close()
    os.replace(temp, output)
    return output
