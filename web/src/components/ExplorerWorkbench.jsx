import { useEffect, useMemo, useState } from 'react'
import { AlertIcon, BookIcon, DatabaseIcon, GlobeIcon, NetworkIcon } from './Icons.jsx'
import { entityDisplay, statusLabel } from '../i18n.js'

const PANELS = ['map', 'timeline', 'witness', 'versions', 'audit']

const UI = {
  zh: {
    title: 'Explorer 2.0 · 证据工作台',
    intro: '把地点、版本、文本见证、冲突、来源质量、覆盖缺口与永久研究队列放在同一阅读路径中。所有图层都来自持久数据库。',
    baseline: '阶段性知识基线，不表示资料已经全部完成。',
    panels: { map: '证据地图', timeline: '版本时间线', witness: '见证图', versions: '版本比较', audit: '质量与缺口' },
    mapTitle: '有坐标证据的现实地点',
    mapIntro: '仅绘制数据库中同时具有明确经纬度、现实地点层级和非基线证据等级的记录。地图底图为方位示意，不表示历史疆界。',
    coordinateBacked: '有坐标地点',
    coordinatesMissing: '现实地点待补坐标',
    coordinatePolicy: '不推测、不从名称自动地理编码',
    openEntity: '打开实体',
    timelineTitle: '数据版本时间线',
    timelineIntro: '这里按数据库检查点日期排序；神话时期的自由文本标签不会被硬塞进现代绝对年代。',
    schema: 'Schema',
    witnessTitle: '实体 → Claim → 来源见证',
    witnessIntro: '分层图只显示数据库里的显式连接；连线不表示实体同一、共同起源或唯一版本。',
    noWitness: '当前实体没有可绘制的已连接证据。',
    witnessOutline: '见证文本清单',
    versionsTitle: '数据版本元数据比较',
    versionsIntro: '旧版本没有逐版保存全部计数，因此这里只比较可核验的版本、时间、Schema、Git 检查点和发布说明，不伪造数量增量。',
    earlier: '版本 A',
    later: '版本 B',
    schemaDelta: 'Schema 版本差',
    noCommit: '待最终检查点盖章',
    conflictsTitle: '冲突与并存版本',
    conflictsIntro: '开放冲突与“作为版本并存”的记录都保留；查看器不会替你选出一个不存在的唯一答案。',
    allStatuses: '全部状态',
    sourceQuality: '来源质量登记',
    sourceQualityNote: '层级与核验状态描述登记元数据，不是文化价值排名。',
    verification: '核验状态',
    evidenceTier: '证据层级',
    livingSources: '活态传统来源',
    permissionSources: '要求社区许可',
    coverageTitle: '文明研究密度热图',
    coverageNote: '色深表示“至少一条 Claim 有 Evidence 的实体比例”；它不是完成度，也不衡量某传统的重要性。',
    tradition: '文明／传统',
    evidenced: '有证据实体',
    claims: 'Claims',
    evidence: 'Evidence',
    conflicts: '冲突',
    queued: '队列',
    queueTitle: '永久研究队列进度',
    queueNote: 'BASELINE_COMPLETE 只表示某个有限目标达到当前基线，永久队列没有“全部完成”终点。',
    accessTitle: '活态传统访问策略',
    accessNote: '公开网页不等于可自由采集；受限、传承谱系或入门内容维持默认禁止。',
    permitted: '可记录范围',
    prohibited: '禁止／受限范围',
    authority: '权限依据',
    featureLedger: 'Explorer 功能与证据边界',
    openEvidence: '打开证据层筛选',
    currentEntity: '当前实体',
    source: '来源',
  },
  en: {
    title: 'Explorer 2.0 · Evidence workbench',
    intro: 'Places, releases, textual witnesses, conflicts, source quality, coverage gaps, and the permanent research queue share one evidence-first reading path. Every layer comes from persistent tables.',
    baseline: 'An expandable staged baseline, not a claim of total completion.',
    panels: { map: 'Evidence map', timeline: 'Release timeline', witness: 'Witness graph', versions: 'Version comparison', audit: 'Quality & gaps' },
    mapTitle: 'Real places with coordinate evidence',
    mapIntro: 'Only records with explicit coordinates, a real-place layer, and a non-baseline evidence grade are plotted. The substrate is schematic and does not depict historical borders.',
    coordinateBacked: 'coordinate-backed places',
    coordinatesMissing: 'real places missing coordinates',
    coordinatePolicy: 'No inference and no name-based geocoding',
    openEntity: 'Open entity',
    timelineTitle: 'Dataset release timeline',
    timelineIntro: 'This view orders database checkpoints by date. Free-text mythic period labels are not forced onto a modern absolute chronology.',
    schema: 'Schema',
    witnessTitle: 'Entity → Claim → source witness',
    witnessIntro: 'The layered graph shows explicit database links only. An edge does not establish identity, common origin, or a single canonical version.',
    noWitness: 'The current entity has no linked evidence that can be drawn.',
    witnessOutline: 'Text witness outline',
    versionsTitle: 'Dataset release metadata comparison',
    versionsIntro: 'Earlier releases do not store a complete per-release count ledger, so this view compares only verifiable version, time, schema, Git checkpoint, and release-note metadata.',
    earlier: 'Version A',
    later: 'Version B',
    schemaDelta: 'Schema delta',
    noCommit: 'Awaiting final checkpoint stamp',
    conflictsTitle: 'Conflicts and coexisting variants',
    conflictsIntro: 'Open conflicts and records resolved as variants remain visible. The viewer does not manufacture a single answer.',
    allStatuses: 'All statuses',
    sourceQuality: 'Source quality register',
    sourceQualityNote: 'Tiers and verification states describe registered metadata, not cultural value.',
    verification: 'Verification status',
    evidenceTier: 'Evidence tier',
    livingSources: 'Living-tradition sources',
    permissionSources: 'Community permission required',
    coverageTitle: 'Research-density heatmap by tradition',
    coverageNote: 'Color intensity is the share of entities with at least one evidenced claim. It is not completeness or cultural importance.',
    tradition: 'Tradition',
    evidenced: 'Evidenced entities',
    claims: 'Claims',
    evidence: 'Evidence',
    conflicts: 'Conflicts',
    queued: 'Queue',
    queueTitle: 'Permanent research queue progress',
    queueNote: 'BASELINE_COMPLETE marks one bounded checkpoint. The permanent queue has no all-complete endpoint.',
    accessTitle: 'Living-tradition access policy',
    accessNote: 'A public page is not blanket permission to collect; restricted, lineage, and initiatory material stays default-deny.',
    permitted: 'Permitted scope',
    prohibited: 'Prohibited / restricted scope',
    authority: 'Authority basis',
    featureLedger: 'Explorer features and evidence boundaries',
    openEvidence: 'Open evidence-layer filters',
    currentEntity: 'Current entity',
    source: 'Source',
  },
}

const shorten = (value, length = 30) => {
  if (!value) return '—'
  return value.length > length ? `${value.slice(0, length - 1)}…` : value
}

const formatDate = (value, language) => {
  if (!value) return '—'
  const date = new Date(value)
  if (Number.isNaN(date.valueOf())) return value
  return new Intl.DateTimeFormat(language === 'zh' ? 'zh-CN' : 'en-GB', {
    year: 'numeric', month: 'short', day: '2-digit', timeZone: 'UTC',
  }).format(date)
}

const readPanel = () => {
  const panel = new URL(window.location.href).searchParams.get('panel')
  return PANELS.includes(panel) ? panel : 'map'
}

function MetricBars({ values, label }) {
  const entries = Object.entries(values || {}).sort((a, b) => b[1] - a[1])
  const max = Math.max(1, ...entries.map(([, value]) => value))
  return (
    <div className="workbench-bars" aria-label={label}>
      {entries.map(([key, value]) => (
        <div key={key}>
          <span>{key}</span>
          <i><b style={{ width: `${Math.max(3, (value / max) * 100)}%` }} /></i>
          <strong>{value}</strong>
        </div>
      ))}
    </div>
  )
}

function EvidenceMap({ analytics, language, onSelect, text }) {
  const places = analytics.places || []
  const position = (place) => ({
    x: ((place.longitude + 180) / 360) * 720,
    y: ((90 - place.latitude) / 180) * 360,
  })

  return (
    <section className="workbench-module map-module" aria-labelledby="evidence-map-title">
      <header className="module-heading">
        <div><h2 id="evidence-map-title">{text.mapTitle}</h2><p>{text.mapIntro}</p></div>
        <div className="module-metrics">
          <span><strong>{analytics.coordinateBackedCount}</strong>{text.coordinateBacked}</span>
          <span><strong>{analytics.missingCoordinateCount}</strong>{text.coordinatesMissing}</span>
        </div>
      </header>
      <div className="evidence-map-frame">
        <svg aria-describedby="map-method-note" className="evidence-map-svg" role="img" viewBox="0 0 720 360">
          <title>{text.mapTitle}</title>
          <desc>{text.mapIntro}</desc>
          <rect className="map-ocean" height="360" width="720" />
          <g className="map-graticule">
            {[60, 120, 180, 240, 300].map((x) => <line key={`x-${x}`} x1={x} x2={x} y1="0" y2="360" />)}
            {[60, 120, 180, 240, 300].map((y) => <line key={`y-${y}`} x1="0" x2="720" y1={y} y2={y} />)}
          </g>
          <g aria-hidden="true" className="map-land">
            <path d="M43 83 76 50 145 37 211 58 245 91 220 122 180 132 153 163 111 153 83 127 49 119Z" />
            <path d="M226 151 280 162 307 207 293 270 258 329 233 286 231 226 210 182Z" />
            <path d="M340 72 392 58 432 73 440 104 413 121 386 111 361 127 332 107Z" />
            <path d="M365 130 421 123 458 158 451 218 415 282 378 244 362 190 336 154Z" />
            <path d="M430 71 520 45 623 63 687 104 651 136 594 128 560 163 515 155 478 126 438 116Z" />
            <path d="M574 226 629 211 682 239 665 282 608 294 570 267Z" />
            <path d="M315 333 390 326 470 335 425 350 348 351Z" />
          </g>
          {places.map((place) => {
            const { x, y } = position(place)
            const label = language === 'zh' ? place.nameZh || place.canonicalName : place.canonicalName
            return (
              <g
                aria-label={`${label}: ${place.latitude.toFixed(4)}, ${place.longitude.toFixed(4)}`}
                className="map-point"
                key={place.entityId}
                role="button"
                tabIndex="0"
                transform={`translate(${x} ${y})`}
                onClick={() => onSelect(place.entityId)}
                onKeyDown={(event) => {
                  if (event.key === 'Enter' || event.key === ' ') onSelect(place.entityId)
                }}
              >
                <circle className="map-point-halo" r="12" />
                <circle r="4.5" />
                <text x={x > 570 ? -10 : 10} y="-9" textAnchor={x > 570 ? 'end' : 'start'}>{shorten(label, 18)}</text>
              </g>
            )
          })}
        </svg>
        <p id="map-method-note"><AlertIcon size={17} />{text.coordinatePolicy} · {analytics.projection}</p>
      </div>
      <div className="map-place-list" role="list">
        {places.map((place) => (
          <button key={place.entityId} role="listitem" type="button" onClick={() => onSelect(place.entityId)}>
            <span><GlobeIcon size={20} /><strong>{language === 'zh' ? place.nameZh || place.canonicalName : place.canonicalName}</strong></span>
            <code>{place.latitude.toFixed(4)}, {place.longitude.toFixed(4)}</code>
            <small>{place.evidenceGrade} · {place.realityStatus}</small>
          </button>
        ))}
      </div>
    </section>
  )
}

function ReleaseTimeline({ language, releases, text }) {
  return (
    <section className="workbench-module timeline-module" aria-labelledby="release-timeline-title">
      <header className="module-heading">
        <div><h2 id="release-timeline-title">{text.timelineTitle}</h2><p>{text.timelineIntro}</p></div>
        <span className="module-count">{releases.length}</span>
      </header>
      <ol className="release-timeline">
        {[...releases].reverse().map((release, index) => (
          <li className={index === 0 ? 'is-current' : ''} key={release.id}>
            <i aria-hidden="true" />
            <article>
              <header><strong>{release.dataVersion.split('-2026')[0]}</strong><time>{formatDate(release.builtAt, language)}</time></header>
              <p>{release.releaseNotes || '—'}</p>
              <footer><code>{text.schema} {release.schemaVersion}</code><code>{release.gitCommit ? release.gitCommit.slice(0, 12) : text.noCommit}</code></footer>
            </article>
          </li>
        ))}
      </ol>
    </section>
  )
}

function WitnessGraph({ entity, language, sources, text }) {
  const sourceById = useMemo(() => new Map(sources.map((source) => [source.id, source])), [sources])
  const graph = useMemo(() => {
    const claims = entity.claims
      .filter((claim) => claim.evidence.length > 0)
      .sort((a, b) => b.evidence.length - a.evidence.length || a.id.localeCompare(b.id))
      .slice(0, 7)
    const sourceIds = [...new Set(claims.flatMap((claim) => claim.evidence.map((item) => item.sourceId)))].slice(0, 9)
    const height = Math.max(430, claims.length * 78, sourceIds.length * 62)
    const claimPositions = new Map(claims.map((claim, index) => [claim.id, ((index + 1) * height) / (claims.length + 1)]))
    const sourcePositions = new Map(sourceIds.map((id, index) => [id, ((index + 1) * height) / (sourceIds.length + 1)]))
    return { claims, sourceIds, height, claimPositions, sourcePositions }
  }, [entity])

  if (graph.claims.length === 0) return <div className="workbench-empty">{text.noWitness}</div>

  return (
    <section className="workbench-module witness-module" aria-labelledby="witness-title">
      <header className="module-heading">
        <div><h2 id="witness-title">{text.witnessTitle}</h2><p>{text.witnessIntro}</p></div>
        <span className="current-entity-label"><NetworkIcon size={19} />{text.currentEntity}: {entityDisplay(entity, language)}</span>
      </header>
      <div className="witness-graph-frame">
        <svg aria-label={`${entityDisplay(entity, language)} ${text.witnessTitle}`} className="witness-graph-svg" role="img" viewBox={`0 0 960 ${graph.height}`}>
          <g className="witness-edges">
            {graph.claims.map((claim) => (
              <line key={`entity-${claim.id}`} x1="178" x2="342" y1={graph.height / 2} y2={graph.claimPositions.get(claim.id)} />
            ))}
            {graph.claims.flatMap((claim) => claim.evidence
              .filter((item) => graph.sourcePositions.has(item.sourceId))
              .map((item) => (
                <line key={`${claim.id}-${item.id}`} x1="568" x2="725" y1={graph.claimPositions.get(claim.id)} y2={graph.sourcePositions.get(item.sourceId)} />
              )))}
          </g>
          <g className="witness-entity-node" transform={`translate(25 ${graph.height / 2 - 42})`}>
            <rect height="84" rx="5" width="153" />
            <text x="14" y="32">{shorten(entityDisplay(entity, language), 18)}</text>
            <text className="node-meta" x="14" y="55">{shorten(entity.id, 22)}</text>
          </g>
          {graph.claims.map((claim) => (
            <g className="witness-claim-node" key={claim.id} transform={`translate(342 ${graph.claimPositions.get(claim.id) - 29})`}>
              <rect height="58" rx="4" width="226" />
              <text x="12" y="23">{shorten(claim.predicate, 25)}</text>
              <text className="node-meta" x="12" y="43">{shorten(claim.id, 31)}</text>
            </g>
          ))}
          {graph.sourceIds.map((sourceId) => {
            const source = sourceById.get(sourceId)
            return (
              <g className="witness-source-node" key={sourceId} transform={`translate(725 ${graph.sourcePositions.get(sourceId) - 26})`}>
                <rect height="52" rx="4" width="210" />
                <text x="11" y="21">{shorten(source?.title || sourceId, 28)}</text>
                <text className="node-meta" x="11" y="39">{shorten(source?.institution || sourceId, 30)}</text>
              </g>
            )
          })}
        </svg>
      </div>
      <details className="witness-outline" open>
        <summary>{text.witnessOutline} · {graph.claims.length}</summary>
        <div>
          {graph.claims.map((claim) => (
            <article key={claim.id}>
              <header><code>{claim.id}</code><span>{claim.knowledgeLayer || '—'}</span></header>
              <p>{claim.statement || claim.objectLiteral || '—'}</p>
              <ul>
                {claim.evidence.map((item) => (
                  <li key={item.id}><BookIcon size={16} /><span>{item.sourceTitle}<small>{item.evidenceType} · {item.sourceLocation || item.catalogueNumber || item.sourceId}</small></span></li>
                ))}
              </ul>
            </article>
          ))}
        </div>
      </details>
    </section>
  )
}

function ReleaseCard({ label, language, release, text }) {
  return (
    <article className="release-compare-card">
      <span>{label}</span>
      <strong>{release?.dataVersion || '—'}</strong>
      <dl>
        <div><dt>{text.schema}</dt><dd>{release?.schemaVersion ?? '—'}</dd></div>
        <div><dt>UTC</dt><dd>{formatDate(release?.builtAt, language)}</dd></div>
        <div><dt>Git</dt><dd><code>{release?.gitCommit ? release.gitCommit.slice(0, 12) : text.noCommit}</code></dd></div>
      </dl>
      <p>{release?.releaseNotes || '—'}</p>
    </article>
  )
}

function VersionComparison({ conflicts, language, onSelect, releases, text }) {
  const [releaseAId, setReleaseAId] = useState(() => releases.at(-2)?.id || releases[0]?.id)
  const [releaseBId, setReleaseBId] = useState(() => releases.at(-1)?.id || releases[0]?.id)
  const [conflictStatus, setConflictStatus] = useState('ALL')
  const releaseById = useMemo(() => new Map(releases.map((release) => [release.id, release])), [releases])
  const statuses = useMemo(() => [...new Set(conflicts.map((conflict) => conflict.status).filter(Boolean))].sort(), [conflicts])
  const visibleConflicts = useMemo(
    () => conflicts.filter((conflict) => conflictStatus === 'ALL' || conflict.status === conflictStatus),
    [conflictStatus, conflicts],
  )
  const [selectedConflictId, setSelectedConflictId] = useState(() => conflicts[0]?.id)
  const selectedConflict = visibleConflicts.find((item) => item.id === selectedConflictId) || visibleConflicts[0]
  const releaseA = releaseById.get(releaseAId)
  const releaseB = releaseById.get(releaseBId)
  const schemaDelta = releaseA && releaseB ? releaseB.schemaVersion - releaseA.schemaVersion : 0

  useEffect(() => {
    if (selectedConflict && selectedConflict.id !== selectedConflictId) setSelectedConflictId(selectedConflict.id)
  }, [selectedConflict, selectedConflictId])

  return (
    <div className="versions-stack">
      <section className="workbench-module version-module" aria-labelledby="version-comparison-title">
        <header className="module-heading"><div><h2 id="version-comparison-title">{text.versionsTitle}</h2><p>{text.versionsIntro}</p></div></header>
        <div className="version-selectors">
          <label><span>{text.earlier}</span><select value={releaseAId} onChange={(event) => setReleaseAId(event.target.value)}>{releases.map((release) => <option key={release.id} value={release.id}>{release.dataVersion}</option>)}</select></label>
          <strong aria-label={`${text.schemaDelta}: ${schemaDelta}`}>{schemaDelta >= 0 ? '+' : ''}{schemaDelta}<small>{text.schemaDelta}</small></strong>
          <label><span>{text.later}</span><select value={releaseBId} onChange={(event) => setReleaseBId(event.target.value)}>{releases.map((release) => <option key={release.id} value={release.id}>{release.dataVersion}</option>)}</select></label>
        </div>
        <div className="release-comparison-grid"><ReleaseCard label={text.earlier} language={language} release={releaseA} text={text} /><ReleaseCard label={text.later} language={language} release={releaseB} text={text} /></div>
      </section>

      <section className="workbench-module conflict-module" aria-labelledby="conflicts-title">
        <header className="module-heading">
          <div><h2 id="conflicts-title">{text.conflictsTitle}</h2><p>{text.conflictsIntro}</p></div>
          <select aria-label={text.allStatuses} value={conflictStatus} onChange={(event) => setConflictStatus(event.target.value)}>
            <option value="ALL">{text.allStatuses}</option>
            {statuses.map((status) => <option key={status} value={status}>{statusLabel(status, language)}</option>)}
          </select>
        </header>
        <div className="conflict-workspace">
          <div className="conflict-list">
            {visibleConflicts.map((conflict) => (
              <button className={selectedConflict?.id === conflict.id ? 'is-selected' : ''} key={conflict.id} type="button" onClick={() => setSelectedConflictId(conflict.id)}>
                <strong>{language === 'zh' ? conflict.subjectNameZh || conflict.subjectName : conflict.subjectName || conflict.subjectNameZh}</strong>
                <span>{conflict.conflictType}</span><small>{statusLabel(conflict.status, language)}</small>
              </button>
            ))}
          </div>
          {selectedConflict && (
            <article className="conflict-detail">
              <header><div><code>{selectedConflict.id}</code><h3>{selectedConflict.summary}</h3></div>{selectedConflict.subjectId && <button type="button" onClick={() => onSelect(selectedConflict.subjectId)}>{text.openEntity}</button>}</header>
              <div className="claim-comparison">
                <section><span>A · {selectedConflict.claimAId || '—'}</span><p>{selectedConflict.claimAStatement || '—'}</p></section>
                <section><span>B · {selectedConflict.claimBId || '—'}</span><p>{selectedConflict.claimBStatement || '—'}</p></section>
              </div>
              <footer><strong>{statusLabel(selectedConflict.status, language)}</strong><p>{selectedConflict.resolutionNotes || text.conflictsIntro}</p></footer>
            </article>
          )}
        </div>
      </section>
    </div>
  )
}

function AuditWorkbench({ data, language, onNavigate, text }) {
  const quality = data.analytics.sourceQuality
  const coverage = data.analytics.coverageByCivilization
  const queue = data.analytics.queueProgress
  const accessCounts = data.analytics.accessPolicyCounts

  return (
    <div className="audit-stack">
      <section className="audit-grid">
        <article className="workbench-module quality-panel">
          <header className="module-heading"><div><h2>{text.sourceQuality}</h2><p>{text.sourceQualityNote}</p></div><span className="module-count">{quality.total}</span></header>
          <div className="quality-columns">
            <section><h3>{text.verification}</h3><MetricBars label={text.verification} values={quality.verificationStatusCounts} /></section>
            <section><h3>{text.evidenceTier}</h3><MetricBars label={text.evidenceTier} values={quality.evidenceTierCounts} /></section>
          </div>
          <footer><span><strong>{quality.livingTraditionSources}</strong>{text.livingSources}</span><span><strong>{quality.communityPermissionRequired}</strong>{text.permissionSources}</span></footer>
        </article>

        <article className="workbench-module queue-progress-panel">
          <header className="module-heading"><div><h2>{text.queueTitle}</h2><p>{text.queueNote}</p></div><span className="module-count">{queue.total}</span></header>
          <MetricBars label={text.queueTitle} values={queue.statusCounts} />
          <div className="priority-bands"><MetricBars label="Priority bands" values={queue.priorityBands} /></div>
        </article>
      </section>

      <section className="workbench-module coverage-panel" aria-labelledby="coverage-title">
        <header className="module-heading"><div><h2 id="coverage-title">{text.coverageTitle}</h2><p>{text.coverageNote}</p></div></header>
        <div className="coverage-table" role="table" aria-label={text.coverageTitle}>
          <div className="coverage-row coverage-head" role="row"><span role="columnheader">{text.tradition}</span><span role="columnheader">{text.evidenced}</span><span role="columnheader">{text.claims}</span><span role="columnheader">{text.evidence}</span><span role="columnheader">{text.conflicts}</span><span role="columnheader">{text.queued}</span></div>
          {coverage.slice(0, 32).map((item) => {
            const percentage = Math.round(item.evidencedEntityRate * 100)
            return (
              <div className="coverage-row" key={item.civilizationId} role="row" style={{ '--coverage': `${percentage}%` }}>
                <strong role="cell">{language === 'zh' ? item.nameZh || item.canonicalName : item.canonicalName}</strong>
                <span className="coverage-rate" role="cell"><i><b style={{ width: `${percentage}%` }} /></i><em>{item.evidencedEntityCount}/{item.entityCount} · {percentage}%</em></span>
                <span role="cell">{item.claimCount}</span><span role="cell">{item.evidenceCount}</span><span role="cell">{item.conflictCount}</span><span role="cell">{item.queueCount}</span>
              </div>
            )
          })}
        </div>
      </section>

      <section className="workbench-module access-panel" aria-labelledby="access-title">
        <header className="module-heading"><div><h2 id="access-title">{text.accessTitle}</h2><p>{text.accessNote}</p></div><button type="button" onClick={() => onNavigate('evidence')}>{text.openEvidence}</button></header>
        <div className="access-counts">
          {Object.entries(accessCounts).map(([level, count]) => <span className={`access-${level.toLocaleLowerCase()}`} key={level}><strong>{count}</strong>{level}</span>)}
        </div>
        <div className="access-policy-list">
          {data.accessPolicies.map((policy) => (
            <details key={policy.id}>
              <summary><span>{policy.accessLevel}</span><strong>{policy.communityContext || policy.entityId}</strong><small>{policy.reviewedAt}</small></summary>
              <dl>
                <div><dt>{text.authority}</dt><dd>{policy.authorityName} · {policy.policyBasis}</dd></div>
                <div><dt>{text.permitted}</dt><dd>{policy.permittedScope}</dd></div>
                <div><dt>{text.prohibited}</dt><dd>{policy.prohibitedScope}</dd></div>
              </dl>
            </details>
          ))}
        </div>
      </section>

      <section className="workbench-module feature-ledger">
        <header className="module-heading"><div><h2>{text.featureLedger}</h2><p>{text.baseline}</p></div></header>
        <div>{data.explorerFeatures.map((feature) => <article key={feature.code}><span className={`feature-${feature.status.toLocaleLowerCase()}`}>{feature.status}</span><strong>{language === 'zh' ? feature.titleZh : feature.titleEn}</strong><p>{feature.evidenceCaveat}</p><code>{feature.dataBasis}</code></article>)}</div>
      </section>
    </div>
  )
}

export default function ExplorerWorkbench({ data, entity, language, onNavigate, onSelect }) {
  const text = UI[language] || UI.zh
  const [panel, setPanel] = useState(readPanel)

  useEffect(() => {
    const onPopState = () => setPanel(readPanel())
    window.addEventListener('popstate', onPopState)
    return () => window.removeEventListener('popstate', onPopState)
  }, [])

  const choosePanel = (nextPanel) => {
    setPanel(nextPanel)
    const url = new URL(window.location.href)
    url.searchParams.set('view', 'workbench')
    url.searchParams.set('panel', nextPanel)
    window.history.pushState(null, '', url)
  }

  const activeFeatureCount = data.explorerFeatures.filter((feature) => feature.status === 'ACTIVE').length
  const limitedFeatureCount = data.explorerFeatures.filter((feature) => feature.status === 'LIMITED').length

  return (
    <main className="single-view workbench-view">
      <header className="workbench-hero">
        <div><span><DatabaseIcon size={20} />v0.24</span><h1>{text.title}</h1><p>{text.intro}</p><small>{text.baseline}</small></div>
        <aside><strong>{activeFeatureCount}</strong><span>ACTIVE</span><strong>{limitedFeatureCount}</strong><span>LIMITED</span></aside>
      </header>
      <nav aria-label={text.title} className="workbench-tabs">
        {PANELS.map((item) => <button aria-pressed={panel === item} className={panel === item ? 'is-active' : ''} key={item} type="button" onClick={() => choosePanel(item)}>{text.panels[item]}</button>)}
      </nav>
      <div className="workbench-content">
        {panel === 'map' && <EvidenceMap analytics={data.analytics.map} language={language} onSelect={onSelect} text={text} />}
        {panel === 'timeline' && <ReleaseTimeline language={language} releases={data.analytics.releaseHistory} text={text} />}
        {panel === 'witness' && <WitnessGraph entity={entity} language={language} sources={data.sources} text={text} />}
        {panel === 'versions' && <VersionComparison conflicts={data.conflicts} language={language} onSelect={onSelect} releases={data.analytics.releaseHistory} text={text} />}
        {panel === 'audit' && <AuditWorkbench data={data} language={language} onNavigate={onNavigate} text={text} />}
      </div>
    </main>
  )
}
