"""Build-time deity story cards for the public snapshot and offline archive.

A card never adds facts. Each beat is either a published story section or an
existing claim that has at least one supporting evidence row; deities whose
only material is restricted by a tradition access policy get a
PERMISSION_LIMITED card that states the boundary instead of a story.
"""

from __future__ import annotations

from typing import Any, Iterable

DEITY_TYPES = {"DEITY", "PRIMORDIAL_DEITY", "ANCESTOR_DEITY"}
MAX_BEATS = 6
MAX_FACTS = 6
MAX_RELATED = 8

ACCESS_ORDER = ["PUBLIC_CONTEXT", "ATTRIBUTION_REQUIRED", "PERMISSION_REQUIRED", "DO_NOT_COLLECT"]
RESTRICTED = {"PERMISSION_REQUIRED", "DO_NOT_COLLECT"}

# Predicates that describe what happens in a narrative come first in a claim card.
NARRATIVE_PREDICATES = [
    "PARTICIPATED_IN", "NARRATIVE_CONDITION", "NARRATIVE_ACTION", "CREATOR_OF", "CREATED_BY", "EMANATION_OF",
    "KILLED", "DEFEATED", "DEFEATS", "DEFEATED_BY", "STRUCK", "BEHEADS", "CONTENDED_WITH", "TRANSFORMS_INTO",
    "ASSUMES_FORM", "MOURNS", "RECOVERS", "HEALED", "ASSISTED", "GAVE_AWAY", "RECEIVES", "DRINKS",
    "IMPRISONED_BY", "REVEALED_RITES_TO", "LIVES_IN", "DWELLS_IN", "BORN_IN", "RULES", "ORIGIN", "ORIGIN_ACCOUNT",
]
FACT_PREDICATES = [
    "DOMAIN", "ROLE", "BEARS_TITLE", "ATTRIBUTE", "DESCRIBED_AS", "LEXICAL_MEANING", "RITUAL_ROLE",
    "CHILD_OF", "PARENT_OF", "FATHER_OF", "MOTHER_OF", "SIBLING_OF", "CONSORT_OF", "STEP_PARENT_OF",
    "OWNS", "USES", "CARRIES", "WORSHIPPED_AT", "ENEMY_OF", "MEMBER_OF", "HAS_MEMBER", "CO_INVOKED_WITH",
    "IDENTIFIED_WITH", "FORM_OF", "COMPOSITE_EXPRESSION_OF", "REPRESENTS", "REPRESENTED_BY",
]
BOUNDARY_PREDICATES = {"EVIDENCE_SCOPE", "INTERPRETIVE_LIMIT", "CULTURAL_LAYER_WARNING", "SOURCE_LAYER_BOUNDARY"}

ZH_OBJECT_TEMPLATES = {
    "CHILD_OF": "{s}是{o}的孩子。",
    "PARENT_OF": "{s}是{o}的父母。",
    "FATHER_OF": "{s}是{o}的父亲。",
    "MOTHER_OF": "{s}是{o}的母亲。",
    "STEP_PARENT_OF": "{s}是{o}的继父母。",
    "SIBLING_OF": "{s}与{o}是兄弟姐妹。",
    "CONSORT_OF": "{s}与{o}是配偶。",
    "KILLED": "{s}杀死了{o}。",
    "DEFEATED": "{s}击败了{o}。",
    "DEFEATS": "{s}击败了{o}。",
    "DEFEATED_BY": "{s}被{o}击败。",
    "STRUCK": "{s}击中了{o}。",
    "BEHEADS": "{s}斩下{o}的头。",
    "CONTENDED_WITH": "{s}与{o}相争。",
    "PARTICIPATED_IN": "{s}出现在“{o}”之中。",
    "CREATOR_OF": "{s}创造了{o}。",
    "CREATED_BY": "{s}由{o}所造。",
    "EMANATION_OF": "{s}出自{o}。",
    "TRANSFORMS_INTO": "{s}化为{o}。",
    "MOURNS": "{s}哀悼{o}。",
    "HEALED": "{s}治愈了{o}。",
    "ASSISTED": "{s}帮助了{o}。",
    "IMPRISONED_BY": "{s}被{o}囚禁。",
    "REVEALED_RITES_TO": "{s}向{o}揭示仪式。",
    "OWNS": "{s}拥有{o}。",
    "USES": "{s}使用{o}。",
    "CARRIES": "{s}携带{o}。",
    "GAVE_AWAY": "{s}交出了{o}。",
    "RECEIVES": "{s}得到{o}。",
    "LIVES_IN": "{s}住在{o}。",
    "DWELLS_IN": "{s}居于{o}。",
    "BORN_IN": "{s}诞生于{o}。",
    "RULES": "{s}统治{o}。",
    "WORSHIPPED_AT": "{s}在{o}受到崇拜。",
    "ENEMY_OF": "{s}与{o}为敌。",
    "MEMBER_OF": "{s}属于{o}。",
    "HAS_MEMBER": "{s}包括{o}。",
    "CO_INVOKED_WITH": "{s}与{o}一同被呼告。",
    "IDENTIFIED_WITH": "{s}被认同为{o}。",
    "FORM_OF": "{s}是{o}的一种形态。",
    "COMPOSITE_EXPRESSION_OF": "{s}是包含{o}的复合神名。",
    "REPRESENTS": "{s}象征{o}。",
    "REPRESENTED_BY": "{s}以{o}为象征。",
    "ASSOCIATED_WITH": "{s}与{o}相关。",
    "APPEARS_IN": "{s}出现在{o}中。",
    "MENTIONED_IN": "{s}见于{o}。",
    "MENTIONS": "{s}提到{o}。",
    "DEPICTS": "{s}描绘了{o}。",
    "DEPICTED_ON": "{s}的形象见于{o}。",
    "CONTAINS_DEPICTION_OF": "{s}中有{o}的形象。",
    "DEDICATED_TO": "{s}献给{o}。",
    "WITNESS_OF": "{s}是{o}的见证。",
    "HELD_BY_MUSEUM": "{s}收藏于{o}。",
}
ZH_LITERAL_LABELS = {
    "DOMAIN": "职掌",
    "ROLE": "角色",
    "BEARS_TITLE": "称号",
    "ATTRIBUTE": "特征",
    "APPEARANCE": "形象",
    "DESCRIBED_AS": "描述",
    "LEXICAL_MEANING": "名字含义",
    "NARRATIVE_ACTION": "情节",
    "NARRATIVE_CONDITION": "情境",
    "ASSUMES_FORM": "化形",
    "RITUAL_ROLE": "仪式",
    "ORIGIN": "来历",
    "ORIGIN_ACCOUNT": "起源叙述",
    "DRINKS": "饮下",
    "RECOVERS": "取回",
}


def _name(entity: dict[str, Any] | None, fallback: str | None) -> tuple[str, str]:
    if entity is None:
        return fallback or "", fallback or ""
    return entity.get("nameZh") or entity["canonicalName"], entity["canonicalName"]


def _split_description(description: str | None) -> tuple[str | None, str | None]:
    if not description:
        return None, None
    if " / " in description:
        left, right = description.split(" / ", 1)
        if any("一" <= ch <= "鿿" for ch in left):
            return left.strip(), right.strip()
    if any("一" <= ch <= "鿿" for ch in description):
        return description, None
    return None, description


def _supporting(claim: dict[str, Any]) -> list[dict[str, Any]]:
    return [item for item in claim.get("evidence", []) if item.get("direction") == "SUPPORTS"]


def _citation(claim: dict[str, Any]) -> dict[str, Any]:
    evidence = _supporting(claim) or claim.get("evidence", [])
    first = evidence[0] if evidence else {}
    return {
        "sourceId": first.get("sourceId"),
        "sourceTitle": first.get("sourceTitle"),
        "sourceLocation": first.get("sourceLocation"),
        "evidenceCount": len(claim.get("evidence", [])),
    }


def claim_sentence(claim: dict[str, Any], lookup: dict[str, dict[str, Any]], labels: dict[str, str]) -> str:
    """Chinese sentence derived only from the claim's structure and entity names."""
    subject_zh, _ = _name(lookup.get(claim["subjectId"]), claim["subjectId"])
    predicate = claim["predicate"]
    if claim.get("objectEntityId"):
        object_zh, _ = _name(lookup.get(claim["objectEntityId"]), claim["objectEntityId"])
        template = ZH_OBJECT_TEMPLATES.get(predicate)
        if template:
            return template.format(s=subject_zh, o=object_zh)
        label = labels.get(predicate) or predicate.replace("_", " ").lower()
        return f"{subject_zh} · {label} · {object_zh}"
    label = ZH_LITERAL_LABELS.get(predicate) or labels.get(predicate) or predicate.replace("_", " ").lower()
    return f"{subject_zh}——{label}：{claim.get('objectLiteral') or ''}"


def _claim_beat(claim: dict[str, Any], lookup, labels) -> dict[str, Any]:
    # Statement, layer and evidence stay in the snapshot's claims; the beat adds
    # only the derived Chinese sentence and the first source for card summaries.
    citation = _citation(claim)
    return {
        "kind": "CLAIM",
        "claimId": claim["id"],
        "predicate": claim["predicate"],
        "textZh": claim_sentence(claim, lookup, labels),
        "sourceId": citation["sourceId"],
    }


def _rank(predicate: str, order: list[str]) -> int:
    return order.index(predicate) if predicate in order else len(order)


def _primary_story(entity_id: str, story_ids: Iterable[str], stories_by_id: dict[str, dict[str, Any]],
                   deity_claim_ids: set[str]) -> tuple[dict[str, Any], dict[str, Any]] | None:
    best = None
    for story_id in story_ids:
        story = stories_by_id.get(story_id)
        if not story:
            continue
        for version in story["versions"]:
            if not any(item["id"] == entity_id for item in version["entities"]):
                continue
            anchored = sum(1 for section in version["sections"] if section.get("anchorClaimId") in deity_claim_ids)
            character = any(item["id"] == entity_id and item.get("role") == "CHARACTER" for item in version["entities"])
            if not anchored and not character:
                continue  # merely related: the deity's own claims tell its story better
            score = (anchored, character, -(story.get("featuredOrder") or 9999), -version.get("versionOrder", 0))
            if best is None or score > best[0]:
                best = (score, story, version)
    return (best[1], best[2]) if best else None


def build_deity_story_cards(entities: list[dict[str, Any]], stories: list[dict[str, Any]],
                            access_policies: list[dict[str, Any]], predicate_labels: dict[str, str]) -> list[dict[str, Any]]:
    lookup = {entity["id"]: entity for entity in entities}
    stories_by_id = {story["id"]: story for story in stories}
    policies: dict[str, list[dict[str, Any]]] = {}
    for policy in access_policies:
        policies.setdefault(policy["entityId"], []).append(policy)

    cards = []
    for entity in entities:
        if not DEITY_TYPES.intersection(entity.get("types") or [entity["primaryType"]]):
            continue
        entity_id = entity["id"]
        evidenced = [claim for claim in entity.get("claims", []) if _supporting(claim)
                     and claim.get("reviewStatus") != "REJECTED"]
        boundary_claims = [claim for claim in evidenced if claim["predicate"] in BOUNDARY_PREDICATES
                           and claim["subjectId"] == entity_id]
        usable = [claim for claim in evidenced if claim["predicate"] not in BOUNDARY_PREDICATES]
        deity_claim_ids = {claim["id"] for claim in entity.get("claims", [])}

        story_links = [link["id"] for link in entity.get("stories", [])]
        primary = _primary_story(entity_id, story_links, stories_by_id, deity_claim_ids)
        beats: list[dict[str, Any]] = []
        used_claims: set[str] = set()
        if primary:
            story, version = primary
            for section in version["sections"][:MAX_BEATS]:
                # Section text lives once in the snapshot's stories; beats only reference it.
                beats.append({"kind": "STORY_SECTION", "sectionId": section["id"], "claimId": section.get("anchorClaimId")})
                if section.get("anchorClaimId"):
                    used_claims.add(section["anchorClaimId"])
        else:
            narrative = sorted((claim for claim in usable if claim["predicate"] in NARRATIVE_PREDICATES),
                               key=lambda claim: (_rank(claim["predicate"], NARRATIVE_PREDICATES), claim["id"]))
            rest = sorted((claim for claim in usable if claim["predicate"] not in NARRATIVE_PREDICATES),
                          key=lambda claim: (_rank(claim["predicate"], FACT_PREDICATES), claim["id"]))
            for claim in (narrative + rest)[:MAX_BEATS]:
                beats.append(_claim_beat(claim, lookup, predicate_labels))
                used_claims.add(claim["id"])

        facts = [
            _claim_beat(claim, lookup, predicate_labels)
            for claim in sorted((claim for claim in usable if claim["id"] not in used_claims),
                                key=lambda claim: (_rank(claim["predicate"], FACT_PREDICATES), claim["id"]))
        ][:MAX_FACTS]

        related: list[dict[str, Any]] = []
        seen: set[str] = set()
        for claim in usable:
            other = claim["objectEntityId"] if claim["subjectId"] == entity_id else claim["subjectId"]
            if not other or other == entity_id or other in seen or other not in lookup:
                continue
            seen.add(other)
            related.append({"id": other, "predicate": claim["predicate"]})
        related = related[:MAX_RELATED]

        entity_policies = policies.get(entity_id, [])
        levels = sorted({policy["accessLevel"] for policy in entity_policies}, key=ACCESS_ORDER.index)
        strictest = levels[-1] if levels else "PUBLIC_CONTEXT"
        if beats and primary:
            status = "STORY_LINKED"
        elif beats:
            status = "CLAIM_CARD"
        elif strictest in RESTRICTED:
            status = "PERMISSION_LIMITED"
        else:
            status = "PENDING_SOURCES"

        boundary = None
        restricted = [policy for policy in entity_policies if policy["accessLevel"] in RESTRICTED]
        if status == "PERMISSION_LIMITED" and restricted:
            policy = restricted[0]
            boundary = {
                "kind": "ACCESS_POLICY",
                "textZh": "这位神祇属于活态传统。在具名社区权威授权并写明可用范围之前，本站不发布故事，也不替社区讲述。",
                "textEn": f"Living tradition. Permitted: {policy['permittedScope']} Not collected: {policy['prohibitedScope']}",
                "policyId": policy["id"],
                "authorityName": policy["authorityName"],
            }
        elif boundary_claims:
            claim = boundary_claims[0]
            boundary = {
                "kind": "EVIDENCE_SCOPE",
                "textZh": "证据边界：" + (claim.get("objectLiteral") or claim.get("statement") or ""),
                "textEn": claim.get("statement") or "",
                "claimId": claim["id"],
            }
        elif restricted:
            policy = restricted[0]
            boundary = {
                "kind": "ACCESS_POLICY",
                "textZh": "此处只使用公开记录；活态传统中的叙事、祷词与仪式须经社区授权。",
                "textEn": f"Not collected without permission: {policy['prohibitedScope']}",
                "policyId": policy["id"],
                "authorityName": policy["authorityName"],
            }

        hook_zh, hook_en = _split_description(entity.get("description"))
        source_ids = {beat.get("sourceId") for beat in facts + beats if beat.get("sourceId")}
        if primary:
            source_ids.add(primary[1].get("sourceId"))
        cards.append({
            "entityId": entity_id,
            "nameZh": entity.get("nameZh") or entity["canonicalName"],
            "name": entity["canonicalName"],
            "originalName": entity.get("originalName"),
            "civilizationId": entity.get("civilizationId"),
            "civilizationName": entity.get("civilizationName"),
            "civilizationNameZh": entity.get("civilizationNameZh"),
            "status": status,
            "accessLevel": strictest,
            "hookZh": hook_zh,
            "hookEn": hook_en,
            "primaryStoryId": primary[0]["id"] if primary else None,
            "primaryVersionId": primary[1]["id"] if primary else None,
            "storyIds": [link["id"] for link in entity.get("stories", [])],
            "beats": [dict(beat, order=index) for index, beat in enumerate(beats, start=1)],
            "facts": facts,
            "related": related,
            "boundary": boundary,
            "claimCount": len(usable),
            "sourceCount": len(source_ids),
        })

    cards.sort(key=lambda card: (card["civilizationNameZh"] or card["civilizationName"] or "", card["nameZh"], card["entityId"]))
    return cards


def card_status_counts(cards: list[dict[str, Any]]) -> dict[str, int]:
    counts: dict[str, int] = {}
    for card in cards:
        counts[card["status"]] = counts.get(card["status"], 0) + 1
    return dict(sorted(counts.items()))


def resolve_card(card: dict[str, Any], sections_by_id: dict[str, dict[str, Any]],
                 claims_by_id: dict[str, dict[str, Any]]) -> dict[str, Any]:
    """Expand a card's references into readable text (offline archive, print)."""

    def claim_text(item: dict[str, Any]) -> dict[str, Any]:
        claim = claims_by_id.get(item["claimId"], {})
        evidence = _supporting(claim) or claim.get("evidence", [])
        first = evidence[0] if evidence else {}
        return {
            "kind": "CLAIM",
            "claimId": item["claimId"],
            "headingZh": None,
            "headingEn": None,
            "textZh": item["textZh"],
            "textEn": claim.get("statement") or "",
            "sourceTitle": first.get("sourceTitle"),
            "sourceLocation": first.get("sourceLocation"),
            "knowledgeLayer": claim.get("knowledgeLayer"),
            "uncertaintyNote": None,
        }

    beats = []
    for beat in card["beats"]:
        if beat["kind"] == "STORY_SECTION":
            section = sections_by_id.get(beat["sectionId"], {})
            beats.append({
                "kind": "STORY_SECTION",
                "claimId": beat.get("claimId"),
                "headingZh": section.get("headingZh"),
                "headingEn": section.get("headingEn"),
                "textZh": section.get("bodyZh") or "",
                "textEn": section.get("bodyEn") or "",
                "sourceTitle": section.get("sourceTitle"),
                "sourceLocation": section.get("sourceLocation"),
                "knowledgeLayer": None,
                "uncertaintyNote": section.get("uncertaintyNote"),
            })
        else:
            beats.append(claim_text(beat))
    return dict(card, beats=beats, facts=[claim_text(item) for item in card["facts"]])
