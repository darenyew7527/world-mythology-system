#!/usr/bin/env python3
"""Generate a self-contained, print-friendly public story archive for the current release."""

from __future__ import annotations

import argparse
import hashlib
import html
import json
import sys
from pathlib import Path
from typing import Any

PROJECT_DIR = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_DIR))
sys.path.insert(0, str(PROJECT_DIR / "src"))

from scripts.generate_web_data import build_snapshot
from world_mythology.db import DEFAULT_DB_PATH, PROJECT_ROOT
from world_mythology.story_cards import resolve_card


DEFAULT_OUTPUT_DIR = PROJECT_ROOT / "web" / "public" / "offline"
DEFAULT_MANIFEST = PROJECT_ROOT / "reports" / "offline_archive_manifest.json"
HTML_NAME = "world-mythology-v0.31-story-archive.html"
JSON_NAME = "world-mythology-v0.31-story-archive.json"


def _escape(value: Any) -> str:
    return html.escape(str(value or ""), quote=True)


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def _render_source(version: dict[str, Any]) -> str:
    source = version.get("source") or {}
    url = source.get("url") or ""
    link = (
        f'<a href="{_escape(url)}" rel="noreferrer">Open source / 打开来源</a>'
        if url.startswith(("https://", "http://"))
        else ""
    )
    return f"""
      <section class="source-card">
        <h4>来源与许可 / Source and rights</h4>
        <dl>
          <div><dt>Title</dt><dd>{_escape(source.get('title') or version.get('sourceId'))}</dd></div>
          <div><dt>Institution</dt><dd>{_escape(source.get('institution'))}</dd></div>
          <div><dt>Locator</dt><dd>{_escape(version.get('sourceLocation'))}</dd></div>
          <div><dt>Rights</dt><dd>{_escape(source.get('rightsStatus'))}</dd></div>
          <div><dt>Reuse</dt><dd>{_escape(source.get('reuseRestrictions'))}</dd></div>
          <div><dt>Witness scope</dt><dd>{_escape(version.get('witnessScope'))}</dd></div>
        </dl>
        {link}
      </section>
    """


def _render_version(version: dict[str, Any], *, open_first: bool) -> str:
    sections = []
    for section in version.get("sections", []):
        uncertainty = section.get("uncertaintyNote")
        sections.append(
            f"""
            <section class="reading-section">
              <span>{int(section.get('order') or 0):02d}</span>
              <div>
                <h4><span class="zh">{_escape(section.get('headingZh'))}</span><span class="en">{_escape(section.get('headingEn'))}</span></h4>
                <p class="zh">{_escape(section.get('bodyZh'))}</p>
                <p class="en">{_escape(section.get('bodyEn'))}</p>
                <aside><strong>Evidence / 证据</strong><span>{_escape(section.get('evidenceNote'))}</span><code>{_escape(section.get('anchorClaimId'))}</code>{f'<em>{_escape(uncertainty)}</em>' if uncertainty else ''}</aside>
              </div>
            </section>
            """
        )
    return f"""
      <details class="version" {'open' if open_first else ''}>
        <summary><span class="zh">{_escape(version.get('labelZh'))}</span><span class="en">{_escape(version.get('labelEn'))}</span><small>{len(sections)} sections</small></summary>
        <div class="version-scope">
          <p><strong>Narrative scope:</strong> {_escape(version.get('narrativeScope'))}</p>
          <p><strong>Rights note:</strong> {_escape(version.get('rightsNote'))}</p>
        </div>
        {_render_source(version)}
        <div class="prose">{''.join(sections)}</div>
      </details>
    """


def _render_story(story: dict[str, Any]) -> str:
    versions = "".join(
        _render_version(version, open_first=index == 0)
        for index, version in enumerate(story.get("versions", []))
    )
    search_text = " ".join(
        str(value or "")
        for value in (
            story.get("id"),
            story.get("titleZh"),
            story.get("canonicalTitle"),
            story.get("summaryZh"),
            story.get("summaryEn"),
            story.get("civilizationNameZh"),
            story.get("civilizationName"),
            " ".join(story.get("themes", [])),
        )
    ).casefold()
    themes = "".join(f"<li>{_escape(theme)}</li>" for theme in story.get("themes", []))
    return f"""
    <article class="story" data-civilization="{_escape(story.get('civilizationId'))}" data-search="{_escape(search_text)}" id="{_escape(story.get('id'))}">
      <header>
        <span>{_escape(story.get('civilizationNameZh'))} / {_escape(story.get('civilizationName'))}</span>
        <h2><span class="zh">{_escape(story.get('titleZh'))}</span><span class="en">{_escape(story.get('canonicalTitle'))}</span></h2>
        <p class="zh">{_escape(story.get('summaryZh'))}</p>
        <p class="en">{_escape(story.get('summaryEn'))}</p>
        <ul class="themes">{themes}</ul>
        <dl class="story-meta">
          <div><dt>Evidence</dt><dd>{_escape(story.get('evidenceStatus'))}</dd></div>
          <div><dt>Access</dt><dd>{_escape(story.get('accessLevel'))}</dd></div>
          <div><dt>Reading</dt><dd>{_escape(story.get('readingMinutes'))} min</dd></div>
        </dl>
      </header>
      {versions}
      <footer><strong>Editorial boundary / 编辑边界</strong><p>{_escape(story.get('editorialNote'))}</p></footer>
    </article>
    """


CARD_STATUS_LABELS = {
    "STORY_LINKED": ("有完整故事", "Full story"),
    "CLAIM_CARD": ("证据卡", "Evidence card"),
    "PERMISSION_LIMITED": ("需社区授权", "Permission required"),
    "PENDING_SOURCES": ("待补来源", "Awaiting sources"),
}


def _render_card(card: dict[str, Any]) -> str:
    status_zh, status_en = CARD_STATUS_LABELS.get(card["status"], (card["status"], card["status"]))
    beats = []
    for index, beat in enumerate(card["beats"], start=1):
        heading = (
            f'<h4><span class="zh">{_escape(beat["headingZh"])}</span><span class="en">{_escape(beat["headingEn"])}</span></h4>'
            if beat.get("headingZh") else ""
        )
        locator = " · ".join(str(part) for part in (beat.get("sourceTitle"), beat.get("sourceLocation"), beat.get("evidenceNote")) if part)
        note = f'<em>{_escape(beat["uncertaintyNote"])}</em>' if beat.get("uncertaintyNote") else ""
        beats.append(
            f"""<li><span>{index:02d}</span><div>{heading}<p class="zh">{_escape(beat['textZh'])}</p>"""
            f"""<p class="{'en' if beat.get('headingZh') else 'statement'}">{_escape(beat['textEn'])}</p>"""
            f"""<small>{_escape(locator)}</small>{note}</div></li>"""
        )
    boundary = card.get("boundary")
    boundary_html = (
        f'<aside class="card-boundary"><span class="zh">{_escape(boundary["textZh"])}</span><span class="en">{_escape(boundary["textEn"])}</span></aside>'
        if boundary else ""
    )
    search_text = " ".join(str(value or "") for value in (card["entityId"], card["nameZh"], card["name"], card.get("civilizationNameZh"), card.get("civilizationName"))).casefold()
    return f"""
    <article class="deity-card" data-civilization="{_escape(card.get('civilizationId'))}" data-search="{_escape(search_text)}" id="card-{_escape(card['entityId'])}">
      <header><span>{_escape(card.get('civilizationNameZh'))} / {_escape(card.get('civilizationName'))} · <b class="zh">{_escape(status_zh)}</b><b class="en">{_escape(status_en)}</b></span>
        <h3><span class="zh">{_escape(card['nameZh'])}</span> <span class="latin">{_escape(card['name'])}</span></h3>
        <p class="zh">{_escape(card.get('hookZh') or '')}</p><p class="en">{_escape(card.get('hookEn') or '')}</p></header>
      <ol class="beats">{''.join(beats)}</ol>
      {boundary_html}
    </article>
    """


def _render_html(archive: dict[str, Any]) -> str:
    stories = archive["stories"]
    civilization_options: dict[str, str] = {}
    for story in stories:
        civilization_options[story.get("civilizationId") or "UNKNOWN"] = (
            story.get("civilizationNameZh") or story.get("civilizationName") or "Unknown"
        )
    options = "".join(
        f'<option value="{_escape(key)}">{_escape(label)}</option>'
        for key, label in sorted(civilization_options.items(), key=lambda item: item[1])
    )
    story_html = "".join(_render_story(story) for story in stories)
    cards = archive.get("deityStoryCards", [])
    card_html = "".join(_render_card(card) for card in cards)
    return f"""<!doctype html>
<html lang="zh-Hans" data-lang="zh">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>世界神话系统 v0.31 离线故事档案</title>
  <style>
    :root {{ color-scheme: light dark; --ink:#17222a; --muted:#52636e; --paper:#f7f2e8; --line:#c6bda9; --gold:#8b672f; --blue:#315f76; font-family: system-ui,-apple-system,"Noto Sans SC",sans-serif; }}
    * {{ box-sizing:border-box; }}
    body {{ margin:0; color:var(--ink); background:#e8e1d3; }}
    .en {{ display:none; }} html[data-lang="en"] .zh {{ display:none; }} html[data-lang="en"] .en {{ display:initial; }}
    .masthead {{ padding:34px clamp(18px,5vw,72px); color:#e8dcc5; background:#132733; }}
    .masthead span {{ color:#d6b776; font:12px ui-monospace,monospace; letter-spacing:.14em; }}
    .masthead h1 {{ margin:10px 0 8px; font-family:Georgia,serif; font-weight:500; }}
    .masthead p {{ max-width:850px; margin:0; color:#b9c5c9; line-height:1.7; }}
    .controls {{ position:sticky; z-index:5; top:0; display:grid; grid-template-columns:minmax(220px,1fr) minmax(180px,.35fr) auto auto; gap:8px; padding:10px clamp(18px,5vw,72px); border-bottom:1px solid #314853; background:#10242f; }}
    input,select,button {{ min-height:42px; padding:8px 11px; border:1px solid #55717d; background:#0d1d26; color:#f1eadc; }} button {{ cursor:pointer; }}
    .archive-note {{ margin:18px auto; max-width:1180px; padding:15px 18px; border:1px solid var(--line); background:var(--paper); line-height:1.65; }}
    main {{ display:grid; gap:18px; max-width:1180px; margin:0 auto; padding:0 18px 48px; }}
    .story {{ border:1px solid var(--line); background:var(--paper); box-shadow:0 10px 30px rgba(37,31,23,.08); }}
    .story[hidden] {{ display:none; }}
    .story > header {{ padding:24px clamp(18px,4vw,42px); border-bottom:1px solid var(--line); }}
    .story > header > span {{ color:var(--gold); font:11px ui-monospace,monospace; text-transform:uppercase; }}
    h2 {{ margin:8px 0; font-family:Georgia,serif; font-size:clamp(24px,4vw,38px); font-weight:500; }}
    .story > header > p {{ max-width:900px; color:var(--muted); line-height:1.75; }}
    .themes {{ display:flex; flex-wrap:wrap; gap:6px; padding:0; list-style:none; }} .themes li {{ padding:4px 7px; border:1px solid var(--line); color:#6d5838; font-size:12px; }}
    .story-meta {{ display:flex; flex-wrap:wrap; gap:16px; margin:14px 0 0; }} .story-meta div {{ display:flex; gap:6px; }} dt {{ color:var(--muted); }} dd {{ margin:0; }}
    .version {{ border-bottom:1px solid var(--line); }} summary {{ display:flex; justify-content:space-between; gap:16px; padding:16px clamp(18px,4vw,42px); color:#463c2d; cursor:pointer; font-family:Georgia,serif; }}
    .version-scope,.source-card {{ margin:0 clamp(18px,4vw,42px) 14px; padding:14px; border-left:3px solid var(--blue); background:#eee9df; }}
    .version-scope p {{ margin:4px 0; line-height:1.6; }} .source-card h4 {{ margin:0 0 9px; }} .source-card dl {{ display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); gap:7px 14px; }} .source-card dl div {{ min-width:0; }} .source-card dd {{ overflow-wrap:anywhere; }} .source-card a {{ display:inline-block; margin-top:9px; color:var(--blue); }}
    .prose {{ max-width:900px; margin:0 auto; padding:20px clamp(18px,5vw,70px) 35px; }} .reading-section {{ display:grid; grid-template-columns:34px 1fr; gap:12px; padding:22px 0; break-inside:avoid; }} .reading-section > span {{ color:var(--gold); font:12px ui-monospace,monospace; }} .reading-section h4 {{ margin:0 0 10px; font:500 21px Georgia,serif; }} .reading-section p {{ margin:0; font-family:Georgia,serif; font-size:18px; line-height:1.9; }} .reading-section aside {{ display:grid; gap:5px; margin-top:14px; padding:10px 12px; border-left:2px solid var(--blue); background:#eee9df; color:var(--muted); font-size:12px; }} .reading-section code,.reading-section em {{ overflow-wrap:anywhere; }}
    .story > footer {{ padding:16px clamp(18px,4vw,42px); background:#eee9df; }} .story > footer p {{ margin:5px 0 0; color:var(--muted); line-height:1.6; }}
    .cards-heading {{ max-width:1180px; margin:28px auto 8px; padding:0 18px; font-family:Georgia,serif; font-weight:500; }}
    #deity-cards {{ grid-template-columns:repeat(auto-fill,minmax(320px,1fr)); align-items:start; }}
    .deity-card {{ border:1px solid var(--line); background:var(--paper); padding:16px 18px; break-inside:avoid; }} .deity-card[hidden] {{ display:none; }}
    .deity-card header > span {{ color:var(--gold); font:11px ui-monospace,monospace; }} .deity-card h3 {{ margin:6px 0; font:500 22px Georgia,serif; }} .deity-card .latin {{ color:var(--muted); font-size:15px; }}
    .deity-card header p {{ margin:4px 0; color:var(--muted); line-height:1.6; }}
    .beats {{ margin:10px 0 0; padding:0; list-style:none; }} .beats li {{ display:grid; grid-template-columns:28px 1fr; gap:8px; padding:9px 0; border-top:1px solid var(--line); }} .beats li > span {{ color:var(--gold); font:11px ui-monospace,monospace; }}
    .beats h4 {{ margin:0 0 4px; font:500 16px Georgia,serif; }} .beats p {{ margin:0 0 4px; line-height:1.7; }} .beats .statement {{ color:var(--muted); font-size:13px; }} .beats small {{ display:block; color:var(--muted); font-size:12px; overflow-wrap:anywhere; }} .beats em {{ display:block; color:#6d5838; font-size:12px; }}
    .card-boundary {{ margin-top:10px; padding:9px 11px; border-left:3px solid var(--gold); background:#eee9df; color:var(--muted); font-size:13px; line-height:1.6; }}
    @media(max-width:700px) {{ #deity-cards {{ grid-template-columns:1fr; }} }}
    @media(max-width:700px) {{ .controls {{ position:static; grid-template-columns:1fr 1fr; }} .controls input {{ grid-column:1/-1; }} .source-card dl {{ grid-template-columns:1fr; }} .reading-section p {{ font-size:17px; }} }}
    @media print {{ @page {{ margin:16mm; }} body {{ background:#fff; }} .controls {{ display:none; }} .masthead {{ padding:0 0 14px; color:#111; background:#fff; }} .masthead p {{ color:#333; }} .archive-note {{ margin:10px 0; }} main {{ display:block; max-width:none; padding:0; }} .story {{ margin:0 0 22px; border:0; box-shadow:none; break-before:page; }} .story:first-child {{ break-before:auto; }} .version {{ break-inside:auto; }} details:not([open]) > *:not(summary) {{ display:block; }} summary {{ list-style:none; }} }}
  </style>
</head>
<body>
  <header class="masthead"><span>v0.31 · OFFLINE / PRINT ARCHIVE</span><h1><span class="zh">世界神话故事离线档案</span><span class="en">World Mythology Offline Story Archive</span></h1><p><span class="zh">来源、证据定位与许可边界随故事一起保存；本文件不包含个人阅读记录，也不重建受限传统。</span><span class="en">Sources, evidence locators, and rights boundaries travel with each story. This file contains no personal reading history and does not reconstruct restricted traditions.</span></p></header>
  <nav class="controls" aria-label="Archive filters"><input id="search" type="search" placeholder="搜索 / Search"><select id="civilization"><option value="ALL">全部传统 / All traditions</option>{options}</select><button id="language" type="button">中文 / EN</button><button type="button" onclick="window.print()">打印 / Print</button></nav>
  <aside class="archive-note"><strong>{_escape(archive['projectVersion'])}</strong> · {_escape(archive['generatedAt'])} · {len(stories)} stories · {len(cards)} deity cards<br>{_escape(archive['licenseNote'])}</aside>
  <main id="stories">{story_html}</main>
  <h2 class="cards-heading"><span class="zh">神祇故事卡（{len(cards)}）</span><span class="en">Deity story cards ({len(cards)})</span></h2>
  <main id="deity-cards">{card_html}</main>
  <script>
    const search = document.querySelector('#search');
    const civilization = document.querySelector('#civilization');
    const stories = [...document.querySelectorAll('.story, .deity-card')];
    function filter() {{ const q = search.value.normalize('NFKD').toLocaleLowerCase(); const civ = civilization.value; for (const story of stories) story.hidden = !story.dataset.search.includes(q) || (civ !== 'ALL' && story.dataset.civilization !== civ); }}
    search.addEventListener('input', filter); civilization.addEventListener('change', filter);
    document.querySelector('#language').addEventListener('click', () => {{ const root=document.documentElement; root.dataset.lang=root.dataset.lang==='zh'?'en':'zh'; root.lang=root.dataset.lang==='zh'?'zh-Hans':'en'; }});
  </script>
</body>
</html>
"""


DEFAULT_MARKDOWN_DIR = PROJECT_ROOT / "profiles" / "stories" / "deities"


def _md_text(value: Any) -> str:
    return str(value or "").replace("\n", " ").strip()


def write_deity_story_markdown(cards: list[dict[str, Any]], output_dir: Path) -> int:
    """Write the resolved deity story cards as Markdown, one file per tradition, readable on GitHub."""
    output_dir.mkdir(parents=True, exist_ok=True)
    for stale in output_dir.glob("*.md"):
        stale.unlink()
    groups: dict[str, list[dict[str, Any]]] = {}
    for card in cards:
        groups.setdefault(card.get("civilizationId") or "civ.unknown", []).append(card)
    index_lines = [
        "# 神祇故事集 / Deity story collection", "",
        "> 每一位神祇都有一张故事卡，打开即可阅读。有完整故事的，按原典段落讲述；只有零散记载的，用带出处的要点讲述；"
        "活态传统尚未获得社区授权的，只说明边界。所有段落都来自已发布的故事分段或带证据的 Claim，本文件不新增事实。", "",
        "| 文明／传统 | Tradition | 神祇 | 完整故事 | 证据卡 | 需授权 |", "|---|---|---:|---:|---:|---:|",
    ]
    for civ_id, items in groups.items():
        slug = civ_id.split(".", 1)[-1]
        first = items[0]
        statuses = [item["status"] for item in items]
        index_lines.append(
            f"| [{first.get('civilizationNameZh') or first.get('civilizationName') or civ_id}]({slug}.md) | "
            f"{first.get('civilizationName') or civ_id} | {len(items)} | {statuses.count('STORY_LINKED')} | "
            f"{statuses.count('CLAIM_CARD')} | {statuses.count('PERMISSION_LIMITED')} |"
        )
        lines = [
            f"# {first.get('civilizationNameZh') or civ_id} / {first.get('civilizationName') or civ_id} — 神祇故事", "",
            "[← 神祇故事集](index.md)", "",
            "> 段落来自已发布故事或带证据的 Claim；来源与定位附在每段之后。", "",
        ]
        for card in items:
            status_zh, status_en = CARD_STATUS_LABELS.get(card["status"], (card["status"], card["status"]))
            lines.extend([f"## {card['nameZh']} · {card['name']}", "", f"**{status_zh} / {status_en}**", ""])
            if card.get("primaryStoryId"):
                lines.extend([f"完整故事档案：[{card['primaryStoryId']}](../{card['primaryStoryId']}.md)", ""])
            if card.get("hookZh"):
                lines.extend([f"> {_md_text(card['hookZh'])}", ""])
            if card.get("hookEn"):
                lines.extend([f"> *{_md_text(card['hookEn'])}*", ""])
            for number, beat in enumerate(card["beats"], start=1):
                heading = beat.get("headingZh")
                title = f"{heading} / {beat.get('headingEn')}" if heading else "记载 / Record"
                lines.extend([f"### {number}. {title}", "", _md_text(beat["textZh"]), ""])
                if beat.get("textEn"):
                    lines.extend([f"*{_md_text(beat['textEn'])}*", ""])
                locator = " · ".join(_md_text(part) for part in (beat.get("sourceTitle"), beat.get("sourceLocation"), beat.get("evidenceNote")) if part)
                if locator:
                    lines.extend([f"<sub>来源 / Source：{locator}</sub>", ""])
                if beat.get("uncertaintyNote"):
                    lines.extend([f"<sub>尚不确定 / Uncertain：{_md_text(beat['uncertaintyNote'])}</sub>", ""])
            boundary = card.get("boundary")
            if boundary:
                lines.extend([f"> **讲述边界 / Boundary**：{_md_text(boundary['textZh'])}", ">", f"> *{_md_text(boundary['textEn'])}*", ""])
            lines.extend(["---", ""])
        (output_dir / f"{slug}.md").write_text("\n".join(lines), encoding="utf-8")
    index_lines.append("")
    (output_dir / "index.md").write_text("\n".join(index_lines), encoding="utf-8")
    return len(groups)


def generate(
    database: Path = DEFAULT_DB_PATH,
    output_dir: Path = DEFAULT_OUTPUT_DIR,
    manifest_path: Path = DEFAULT_MANIFEST,
    markdown_dir: Path | None = None,
) -> dict[str, Any]:
    snapshot = build_snapshot(database)
    meta = snapshot["meta"]
    archive = {
        "formatVersion": 1,
        "artifactVersion": meta["dataVersion"],
        "projectVersion": meta["projectVersion"],
        "dataVersion": meta["dataVersion"],
        "generatedAt": meta["generatedAt"],
        "privacyModel": "NO_PERSONAL_READING_STATE; PUBLIC_SNAPSHOT_ONLY",
        "licenseNote": "Project-authored structured summaries follow DATA_LICENSE.md; every third-party source retains its own rights and reuse restrictions.",
        "stories": snapshot["stories"],
        "readingRoutes": snapshot.get("readingRoutes", []),
    }
    sections_by_id = {
        section["id"]: dict(section, sourceTitle=(version.get("source") or {}).get("title"), sourceLocation=version.get("sourceLocation"))
        for story in snapshot["stories"]
        for version in story["versions"]
        for section in version["sections"]
    }
    claims_by_id = {claim["id"]: claim for claim in snapshot["claims"]}
    archive["deityStoryCards"] = [
        resolve_card(card, sections_by_id, claims_by_id) for card in snapshot.get("deityStoryCards", [])
    ]

    output_dir.mkdir(parents=True, exist_ok=True)
    html_path = output_dir / HTML_NAME
    json_path = output_dir / JSON_NAME
    json_path.write_text(json.dumps(archive, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    html_path.write_text(_render_html(archive), encoding="utf-8")

    version_count = sum(len(story.get("versions", [])) for story in archive["stories"])
    section_count = sum(
        len(version.get("sections", []))
        for story in archive["stories"]
        for version in story.get("versions", [])
    )
    manifest = {
        "artifactVersion": archive["artifactVersion"],
        "projectVersion": archive["projectVersion"],
        "dataVersion": archive["dataVersion"],
        "generatedAt": archive["generatedAt"],
        "databaseSha256": _sha256(database),
        "counts": {
            "stories": len(archive["stories"]),
            "storyVersions": version_count,
            "storySections": section_count,
            "readingRoutes": len(archive["readingRoutes"]),
            "deityStoryCards": len(archive["deityStoryCards"]),
        },
        "privacyModel": archive["privacyModel"],
        "artifacts": {
            HTML_NAME: {"sha256": _sha256(html_path), "bytes": html_path.stat().st_size},
            JSON_NAME: {"sha256": _sha256(json_path), "bytes": json_path.stat().st_size},
        },
    }
    manifest_path.parent.mkdir(parents=True, exist_ok=True)
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    if markdown_dir is not None:
        write_deity_story_markdown(archive["deityStoryCards"], markdown_dir)
    return manifest


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--database", type=Path, default=DEFAULT_DB_PATH)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    parser.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    print(json.dumps(generate(args.database, args.output_dir, args.manifest, DEFAULT_MARKDOWN_DIR), ensure_ascii=False, indent=2))
