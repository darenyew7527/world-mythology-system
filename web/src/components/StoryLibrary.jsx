import { useDeferredValue, useEffect, useMemo, useState } from 'react'
import { BookIcon, ExternalIcon, SearchIcon } from './Icons.jsx'
import { statusLabel } from '../i18n.js'

const ui = {
  zh: {
    eyebrow: 'v0.27 · 原典见证对读',
    title: '神话故事阅读库',
    intro: '逐项对照独立原典见证；原文名、转写、语言与定位并列，版本不合并，缺口不补写。',
    search: '搜索故事、人物、神器或主题…',
    all: '全部文明',
    stories: '个故事',
    versions: '个版本',
    minutes: '分钟阅读',
    sourceBacked: '来源见证',
    access: '访问层级',
    version: '故事版本',
    witness: '见证范围',
    narrativeScope: '本版叙述范围',
    source: '原典／权威来源',
    locator: '定位',
    openSource: '打开来源',
    characters: '人物、文本与神器',
    evidence: '证据连接',
    claims: '条 Claims',
    variants: '版本冲突',
    editorial: '编辑说明',
    unknown: '当前证据未说明',
    noResult: '没有符合当前筛选的故事。',
    select: '选择左侧故事开始阅读。',
    openEntity: '查看实体',
    routes: '主题阅读路线',
    routePolicy: '路线是编辑导航，不代表跨文明同源。',
    eventSequence: '事件顺序与地点',
    narrativeOrder: '叙事顺序，不是绝对年代',
    place: '地点',
    noPlace: '当前证据未定位地点',
    noCoordinate: '不推测坐标',
    witnessIdentity: '原典见证标识',
    originalTitle: '原题',
    transliteration: '转写',
    language: '语言',
    rightsBoundary: '版权边界',
    comparisonTitle: '原典见证对读',
    comparisonPolicy: '逐项对齐；点击见证可切换正文。对读不生成统一文本。',
    comparisonScope: '对读范围',
    synthesisPolicy: '合成规则',
    sourceLocator: '来源定位',
    difference: '差异说明',
  },
  en: {
    eyebrow: 'v0.27 · Original witness comparison',
    title: 'Myth Story Library',
    intro: 'Compare independent textual witnesses item by item; original forms, transliterations, languages, and locators stay visible while gaps remain explicit.',
    search: 'Search stories, people, artifacts, or themes…',
    all: 'All traditions',
    stories: 'stories',
    versions: 'versions',
    minutes: 'min read',
    sourceBacked: 'Witness status',
    access: 'Access level',
    version: 'Story version',
    witness: 'Witness scope',
    narrativeScope: 'Narrative scope',
    source: 'Primary / authoritative source',
    locator: 'Locator',
    openSource: 'Open source',
    characters: 'People, texts, and artifacts',
    evidence: 'Evidence links',
    claims: 'claims',
    variants: 'Variant conflicts',
    editorial: 'Editorial note',
    unknown: 'The current evidence does not say',
    noResult: 'No stories match the current filters.',
    select: 'Choose a story to begin reading.',
    openEntity: 'Open entity',
    routes: 'Thematic reading routes',
    routePolicy: 'Routes are editorial navigation, not common-origin claims.',
    eventSequence: 'Event sequence and places',
    narrativeOrder: 'Narrative order, not absolute chronology',
    place: 'Place',
    noPlace: 'The current evidence does not locate this event',
    noCoordinate: 'Coordinates are not inferred',
    witnessIdentity: 'Witness identity',
    originalTitle: 'Original title',
    transliteration: 'Transliteration',
    language: 'Language',
    rightsBoundary: 'Rights boundary',
    comparisonTitle: 'Original witness comparison',
    comparisonPolicy: 'Aligned item by item; select a witness to switch the reading text. No unified text is generated.',
    comparisonScope: 'Comparison scope',
    synthesisPolicy: 'Synthesis rule',
    sourceLocator: 'Source locator',
    difference: 'Difference note',
  },
}

const evidenceStateLabels = {
  zh: {
    ATTESTED: '原典已见证',
    NOT_STATED: '当前定位未陈述',
    UNMODELED: '尚未建模',
    DAMAGED: '文本残损',
    INFERRED: '推断项',
  },
  en: {
    ATTESTED: 'Attested',
    NOT_STATED: 'Not stated here',
    UNMODELED: 'Not yet modeled',
    DAMAGED: 'Text damaged',
    INFERRED: 'Inferred',
  },
}

const comparisonScopeLabels = {
  zh: {
    SHARED_ELEMENT: '共享元素',
    DIVERGENT_ACCOUNT: '分歧叙述',
    ASYMMETRIC_WITNESS: '非对称见证',
    EXPLICIT_UNKNOWN: '显式未知',
    KEEP_SEPARATE: '保持分立',
    NO_SYNTHESIS: '禁止合成',
  },
  en: {
    SHARED_ELEMENT: 'Shared element',
    DIVERGENT_ACCOUNT: 'Divergent account',
    ASYMMETRIC_WITNESS: 'Asymmetric witness',
    EXPLICIT_UNKNOWN: 'Explicit unknown',
    KEEP_SEPARATE: 'Keep separate',
    NO_SYNTHESIS: 'No synthesis',
  },
}

const normalize = (value) => (value || '').normalize('NFKD').toLocaleLowerCase()

const storyTitle = (story, language) =>
  language === 'zh' ? story.titleZh || story.canonicalTitle : story.canonicalTitle

const storySummary = (story, language) =>
  language === 'zh' ? story.summaryZh : story.summaryEn

const versionLabel = (version, language) =>
  language === 'zh' ? version.labelZh : version.labelEn

const linkedName = (entity, language) =>
  language === 'zh' ? entity.nameZh || entity.canonicalName : entity.canonicalName

export default function StoryLibrary({
  language,
  onOpenEntity,
  onSelectStory,
  readingRoutes = [],
  selectedStoryId,
  stories,
}) {
  const copy = ui[language] || ui.zh
  const [query, setQuery] = useState('')
  const [civilization, setCivilization] = useState('ALL')
  const [selectedVersionId, setSelectedVersionId] = useState(null)
  const deferredQuery = useDeferredValue(query)

  const civilizations = useMemo(() => {
    const map = new Map()
    for (const story of stories) {
      if (!story.civilizationId) continue
      map.set(story.civilizationId, {
        id: story.civilizationId,
        label: language === 'zh'
          ? story.civilizationNameZh || story.civilizationName
          : story.civilizationName,
      })
    }
    return [...map.values()].sort((a, b) => (a.label || '').localeCompare(b.label || '', language === 'zh' ? 'zh-Hans' : 'en'))
  }, [language, stories])

  const filtered = useMemo(() => {
    const needle = normalize(deferredQuery.trim())
    return stories.filter((story) => {
      if (civilization !== 'ALL' && story.civilizationId !== civilization) return false
      if (!needle) return true
      const linked = story.versions.flatMap((version) => version.entities)
      return normalize([
        story.id,
        story.titleZh,
        story.canonicalTitle,
        story.summaryZh,
        story.summaryEn,
        story.civilizationNameZh,
        story.civilizationName,
        ...story.themes,
        ...linked.flatMap((entity) => [entity.nameZh, entity.canonicalName]),
      ].join(' ')).includes(needle)
    })
  }, [civilization, deferredQuery, stories])

  const selected = stories.find((story) => story.id === selectedStoryId)
    || filtered[0]
    || stories[0]

  useEffect(() => {
    if (!selected) return
    if (!selected.versions.some((version) => version.id === selectedVersionId)) {
      setSelectedVersionId(selected.versions[0]?.id || null)
    }
  }, [selected, selectedVersionId])

  const selectedVersion = selected?.versions.find((version) => version.id === selectedVersionId)
    || selected?.versions[0]
  const witnessComparisons = selected?.witnessComparisons || []
  const witnessProfile = selectedVersion?.witnessProfile

  const linkedEntities = useMemo(() => {
    if (!selectedVersion) return []
    const map = new Map()
    for (const entity of selectedVersion.entities) {
      if (!map.has(entity.id)) map.set(entity.id, entity)
    }
    return [...map.values()]
  }, [selectedVersion])

  return (
    <main className="story-library single-view">
      <header className="story-hero">
        <div>
          <span>{copy.eyebrow}</span>
          <h1><BookIcon size={28} />{copy.title}</h1>
          <p>{copy.intro}</p>
        </div>
        <aside>
          <strong>{stories.length}</strong><span>{copy.stories}</span>
          <strong>{stories.reduce((sum, story) => sum + story.versions.length, 0)}</strong><span>{copy.versions}</span>
        </aside>
      </header>

      <section className="story-toolbar" aria-label={copy.title}>
        <label className="story-search">
          <SearchIcon size={19} />
          <input value={query} type="search" placeholder={copy.search} onChange={(event) => setQuery(event.target.value)} />
        </label>
        <select aria-label={copy.all} value={civilization} onChange={(event) => setCivilization(event.target.value)}>
          <option value="ALL">{copy.all}</option>
          {civilizations.map((item) => <option key={item.id} value={item.id}>{item.label}</option>)}
        </select>
        <span>{filtered.length} / {stories.length}</span>
      </section>

      <section className="story-route-strip" aria-label={copy.routes}>
        <header><div><strong>{copy.routes}</strong><span>{copy.routePolicy}</span></div><b>{readingRoutes.length}</b></header>
        <div>
          {readingRoutes.map((route) => (
            <details key={route.id}>
              <summary>
                <span>{route.routeType}</span>
                <strong>{language === 'zh' ? route.titleZh : route.titleEn}</strong>
                <small>{route.steps.length}</small>
              </summary>
              <p>{language === 'zh' ? route.descriptionZh : route.descriptionEn}</p>
              <ol>
                {route.steps.map((step) => (
                  <li key={`${route.id}-${step.order}`}>
                    <button type="button" onClick={() => {
                      onSelectStory(step.storyId)
                      setSelectedVersionId(step.storyVersionId)
                    }}>
                      <span>{String(step.order).padStart(2, '0')}</span>
                      <strong>{language === 'zh' ? step.storyTitleZh : step.storyTitleEn}</strong>
                      <small>{language === 'zh' ? step.rationaleZh : step.rationaleEn}</small>
                    </button>
                  </li>
                ))}
              </ol>
              <footer>{route.evidencePolicy}</footer>
            </details>
          ))}
        </div>
      </section>

      <div className="story-layout">
        <section className="story-index" aria-label={copy.title}>
          {filtered.length === 0 && <p className="story-empty">{copy.noResult}</p>}
          {filtered.map((story) => (
            <button
              className={story.id === selected?.id ? 'is-selected' : ''}
              key={story.id}
              type="button"
              onClick={() => onSelectStory(story.id)}
            >
              <span>{language === 'zh' ? story.civilizationNameZh || story.civilizationName : story.civilizationName}</span>
              <strong>{storyTitle(story, language)}</strong>
              <p>{storySummary(story, language)}</p>
              <footer>
                <small>{story.readingMinutes} {copy.minutes}</small>
                <small>{story.versions.length} {copy.versions}</small>
                <small>{statusLabel(story.evidenceStatus, language)}</small>
              </footer>
            </button>
          ))}
        </section>

        {selected && selectedVersion ? (
          <article className="story-reader" key={selected.id}>
            <header className="story-reader-heading">
              <div>
                <span>{language === 'zh' ? selected.civilizationNameZh || selected.civilizationName : selected.civilizationName}</span>
                <h2>{storyTitle(selected, language)}</h2>
                <p>{storySummary(selected, language)}</p>
              </div>
              <dl>
                <div><dt>{copy.sourceBacked}</dt><dd>{statusLabel(selected.evidenceStatus, language)}</dd></div>
                <div><dt>{copy.access}</dt><dd>{selected.accessLevel}</dd></div>
              </dl>
            </header>

            <section className="story-version-picker">
              <strong>{copy.version}</strong>
              <div>
                {selected.versions.map((version) => (
                  <button
                    className={version.id === selectedVersion.id ? 'is-selected' : ''}
                    key={version.id}
                    type="button"
                    onClick={() => setSelectedVersionId(version.id)}
                  >
                    {versionLabel(version, language)}
                  </button>
                ))}
              </div>
            </section>

            <section className="story-witness-card">
              <div>
                <span>{copy.witness}</span>
                <p>{selectedVersion.witnessScope}</p>
              </div>
              <div>
                <span>{copy.narrativeScope}</span>
                <p>{selectedVersion.narrativeScope}</p>
              </div>
              <div>
                <span>{copy.source}</span>
                <strong>{selectedVersion.source.title || selectedVersion.sourceId}</strong>
                <small>{copy.locator}: {selectedVersion.sourceLocation}</small>
                {selectedVersion.source.url && (
                  <a href={selectedVersion.source.url} rel="noreferrer" target="_blank">
                    {copy.openSource}<ExternalIcon size={14} />
                  </a>
                )}
              </div>
              {witnessProfile && (
                <div className="story-witness-identity">
                  <span>{copy.witnessIdentity}</span>
                  <strong dir="auto">{witnessProfile.workTitleOriginal}</strong>
                  {witnessProfile.workTitleTransliteration && (
                    <small>{copy.transliteration}: {witnessProfile.workTitleTransliteration}</small>
                  )}
                  <p dir="auto">{witnessProfile.witnessLabelOriginal}</p>
                  <small>
                    {copy.language}: {language === 'zh'
                      ? witnessProfile.languageNameZh || witnessProfile.languageName
                      : witnessProfile.languageName}
                    {witnessProfile.iso6393 ? ` · ${witnessProfile.iso6393}` : ''}
                    {witnessProfile.scriptName ? ` · ${witnessProfile.scriptName}` : ''}
                  </small>
                  <small>{copy.rightsBoundary}: {witnessProfile.rightsBoundary}</small>
                </div>
              )}
            </section>

            {witnessComparisons.length > 0 && (
              <section className="story-witness-comparison" aria-labelledby="story-witness-comparison-title">
                <header>
                  <div>
                    <strong id="story-witness-comparison-title">{copy.comparisonTitle}</strong>
                    <span>{copy.comparisonPolicy}</span>
                  </div>
                  <b>{witnessComparisons.length}</b>
                </header>
                <div className="story-comparison-list">
                  {witnessComparisons.map((comparison) => (
                    <article key={comparison.id} className="story-comparison-item">
                      <header>
                        <span>{String(comparison.order).padStart(2, '0')}</span>
                        <div>
                          <h3>{language === 'zh' ? comparison.topicZh : comparison.topicEn}</h3>
                          <p>{language === 'zh' ? comparison.editorialNoteZh : comparison.editorialNoteEn}</p>
                        </div>
                        <dl>
                          <div>
                            <dt>{copy.comparisonScope}</dt>
                            <dd>{comparisonScopeLabels[language]?.[comparison.scope] || comparison.scope}</dd>
                          </div>
                          <div>
                            <dt>{copy.synthesisPolicy}</dt>
                            <dd>{comparisonScopeLabels[language]?.[comparison.synthesisPolicy] || comparison.synthesisPolicy}</dd>
                          </div>
                        </dl>
                      </header>
                      <div className="story-comparison-members" role="group" aria-label={language === 'zh' ? comparison.topicZh : comparison.topicEn}>
                        {comparison.members.map((member) => (
                          <article
                            className={member.storyVersionId === selectedVersion.id ? 'is-selected' : ''}
                            key={`${comparison.id}-${member.storyVersionId}`}
                          >
                            <button
                              aria-pressed={member.storyVersionId === selectedVersion.id}
                              className="story-comparison-select"
                              type="button"
                              onClick={() => setSelectedVersionId(member.storyVersionId)}
                            >
                              <strong>{language === 'zh' ? member.versionLabelZh : member.versionLabelEn}</strong>
                              <span className={`story-evidence-state is-${member.evidenceState.toLocaleLowerCase().replace('_', '-')}`}>
                                {evidenceStateLabels[language]?.[member.evidenceState] || member.evidenceState}
                              </span>
                            </button>
                            {member.originalForm && <p className="story-original-form" dir="auto">{member.originalForm}</p>}
                            {member.transliteration && <small>{copy.transliteration}: {member.transliteration}</small>}
                            <dl>
                              <div>
                                <dt>{copy.language}</dt>
                                <dd>{language === 'zh' ? member.languageNameZh || member.languageName : member.languageName}{member.iso6393 ? ` · ${member.iso6393}` : ''}</dd>
                              </div>
                              <div>
                                <dt>{copy.sourceLocator}</dt>
                                <dd>{member.sourceLocation}</dd>
                              </div>
                            </dl>
                            <p>{language === 'zh' ? member.summaryZh : member.summaryEn}</p>
                            <footer>
                              <strong>{copy.difference}</strong>
                              <span>{language === 'zh' ? member.differenceNoteZh : member.differenceNoteEn}</span>
                            </footer>
                          </article>
                        ))}
                      </div>
                    </article>
                  ))}
                </div>
              </section>
            )}

            <section className="story-event-map">
              <header>
                <div><strong>{copy.eventSequence}</strong><span>{copy.narrativeOrder}</span></div>
                <b>{selectedVersion.events.length}</b>
              </header>
              <ol>
                {selectedVersion.events.map((event) => (
                  <li key={event.id} className={event.placeEntityId ? 'has-place' : ''}>
                    <span>{String(event.order).padStart(2, '0')}</span>
                    <div>
                      <strong>{language === 'zh' ? event.titleZh : event.titleEn}</strong>
                      <p>{event.placeEntityId
                        ? `${copy.place}: ${language === 'zh' ? event.placeNameZh || event.placeName : event.placeName}`
                        : copy.noPlace}</p>
                      <small>{event.coordinatePolicy === 'VERIFIED_COORDINATE'
                        ? `${event.latitude}, ${event.longitude}`
                        : copy.noCoordinate}</small>
                    </div>
                  </li>
                ))}
              </ol>
            </section>

            <div className="story-prose">
              {selectedVersion.sections.map((section) => (
                <section key={section.id}>
                  <span>{String(section.order).padStart(2, '0')}</span>
                  <div>
                    <h3>{language === 'zh' ? section.headingZh : section.headingEn}</h3>
                    <p>{language === 'zh' ? section.bodyZh : section.bodyEn}</p>
                    <aside>
                      <strong>{copy.evidence}</strong>
                      <span>{section.evidenceNote}</span>
                      {section.anchorClaimId && <code>{section.anchorClaimId}</code>}
                      {section.uncertaintyNote && <em>{copy.unknown}: {section.uncertaintyNote}</em>}
                    </aside>
                  </div>
                </section>
              ))}
            </div>

            <section className="story-linked-entities">
              <h3>{copy.characters}</h3>
              <div>
                {linkedEntities.map((entity) => (
                  <button key={entity.id} type="button" onClick={() => onOpenEntity(entity.id)}>
                    <span>{entity.role}</span>
                    <strong>{linkedName(entity, language)}</strong>
                    <small>{copy.openEntity}</small>
                  </button>
                ))}
              </div>
            </section>

            <footer className="story-audit-footer">
              <div><strong>{copy.evidence}</strong><span>{selectedVersion.claims.length} {copy.claims}</span></div>
              {selected.conflicts.length > 0 && <div><strong>{copy.variants}</strong><span>{selected.conflicts.length}</span></div>}
              <p><strong>{copy.editorial}:</strong> {selected.editorialNote}</p>
            </footer>
          </article>
        ) : <p className="story-empty">{copy.select}</p>}
      </div>
    </main>
  )
}
