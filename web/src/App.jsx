import { useCallback, useEffect, useMemo, useState } from 'react'
import ContributeView from './components/ContributeView.jsx'
import EntityDetail from './components/EntityDetail.jsx'
import EntityList from './components/EntityList.jsx'
import EvidenceView from './components/EvidenceView.jsx'
import ExplorerWorkbench from './components/ExplorerWorkbench.jsx'
import { Filters, MobileFilters } from './components/Filters.jsx'
import GraphView from './components/GraphView.jsx'
import Header from './components/Header.jsx'
import { SearchIcon } from './components/Icons.jsx'
import MetricStrip from './components/MetricStrip.jsx'
import ProgressView from './components/ProgressView.jsx'
import StoryLibrary from './components/StoryLibrary.jsx'
import ThunderView from './components/ThunderView.jsx'
import { t } from './i18n.js'

const FEATURED_IDS = [
  'deity.greek.zeus',
  'deity.norse.odin',
  'deity.norse.thor',
  'deity.norse.loki',
  'deity.egyptian.ra',
  'deity.vedic.indra',
  'being.chinese.pangu',
  'deity.sumerian.inanna',
  'deity.japanese.amaterasu',
  'deity.yoruba.orunmila',
]

const VALID_VIEWS = new Set(['explore', 'stories', 'workbench', 'graph', 'thunder', 'evidence', 'progress', 'contribute'])

const readQueryView = () => {
  const view = new URL(window.location.href).searchParams.get('view')
  return VALID_VIEWS.has(view) ? view : 'explore'
}

const readHashEntity = () => {
  const match = window.location.hash.match(/^#entity=(.+)$/)
  return match ? decodeURIComponent(match[1]) : null
}

const readQueryStory = () => new URL(window.location.href).searchParams.get('story')

const normalize = (value) => (value || '').normalize('NFKD').toLocaleLowerCase()

export default function App() {
  const [data, setData] = useState(null)
  const [error, setError] = useState(null)
  const [language, setLanguage] = useState(() => window.localStorage.getItem('wms-language') || 'zh')
  const [activeView, setActiveView] = useState(readQueryView)
  const [selectedStoryId, setSelectedStoryId] = useState(readQueryStory)
  const [query, setQuery] = useState('')
  const [typeFilter, setTypeFilter] = useState('ALL')
  const [civilizationFilter, setCivilizationFilter] = useState('ALL')
  const [selectedId, setSelectedId] = useState(readHashEntity() || 'deity.greek.zeus')
  const [mobileDetailOpen, setMobileDetailOpen] = useState(false)
  const [menuOpen, setMenuOpen] = useState(false)

  const copy = t(language)

  const loadData = useCallback(() => {
    setError(null)
    fetch(`${import.meta.env.BASE_URL}data/site-data.json`)
      .then((response) => {
        if (!response.ok) throw new Error(`HTTP ${response.status}`)
        return response.json()
      })
      .then((snapshot) => setData(snapshot))
      .catch((reason) => setError(reason))
  }, [])

  useEffect(() => loadData(), [loadData])

  useEffect(() => {
    document.documentElement.lang = language === 'zh' ? 'zh-Hans' : 'en'
    window.localStorage.setItem('wms-language', language)
  }, [language])

  useEffect(() => {
    const onHashChange = () => {
      const entityId = readHashEntity()
      if (entityId) setSelectedId(entityId)
    }
    window.addEventListener('hashchange', onHashChange)
    return () => window.removeEventListener('hashchange', onHashChange)
  }, [])

  useEffect(() => {
    const onPopState = () => {
      setActiveView(readQueryView())
      setSelectedStoryId(readQueryStory())
    }
    window.addEventListener('popstate', onPopState)
    return () => window.removeEventListener('popstate', onPopState)
  }, [])

  const entityById = useMemo(() => {
    if (!data) return new Map()
    return new Map(data.entities.map((entity) => [entity.id, entity]))
  }, [data])

  const filteredEntities = useMemo(() => {
    if (!data) return []
    const needle = normalize(query.trim())
    const featuredIndex = new Map(FEATURED_IDS.map((id, index) => [id, index]))
    return data.entities
      .filter((entity) => typeFilter === 'ALL' || entity.types.includes(typeFilter))
      .filter((entity) => civilizationFilter === 'ALL' || entity.civilizationId === civilizationFilter)
      .filter((entity) => {
        if (!needle) return true
        return normalize([
          entity.id,
          entity.nameZh,
          entity.canonicalName,
          entity.originalName,
          entity.civilizationNameZh,
          entity.civilizationName,
          ...entity.aliases,
        ].join(' ')).includes(needle)
      })
      .sort((a, b) => {
        if (!needle) {
          const aFeatured = featuredIndex.get(a.id) ?? Number.MAX_SAFE_INTEGER
          const bFeatured = featuredIndex.get(b.id) ?? Number.MAX_SAFE_INTEGER
          if (aFeatured !== bFeatured) return aFeatured - bFeatured
        }
        const aSource = a.evidenceStatus === 'SOURCE_BACKED' ? 0 : a.evidenceStatus === 'PARTIAL' ? 1 : 2
        const bSource = b.evidenceStatus === 'SOURCE_BACKED' ? 0 : b.evidenceStatus === 'PARTIAL' ? 1 : 2
        if (aSource !== bSource) return aSource - bSource
        return (a.nameZh || a.canonicalName).localeCompare(b.nameZh || b.canonicalName, language === 'zh' ? 'zh-Hans' : 'en')
      })
  }, [civilizationFilter, data, language, query, typeFilter])

  const selectedEntity = entityById.get(selectedId) || filteredEntities[0] || data?.entities[0]

  const selectEntity = useCallback((id, options = {}) => {
    if (!entityById.has(id)) return
    setSelectedId(id)
    window.history.replaceState(null, '', `#entity=${encodeURIComponent(id)}`)
    if (options.openMobile !== false) setMobileDetailOpen(true)
  }, [entityById])

  const navigate = useCallback((view) => {
    if (!VALID_VIEWS.has(view)) return
    setActiveView(view)
    const url = new URL(window.location.href)
    if (view === 'explore') url.searchParams.delete('view')
    else url.searchParams.set('view', view)
    if (view !== 'stories') url.searchParams.delete('story')
    window.history.pushState(null, '', url)
  }, [])

  const selectStory = useCallback((storyId) => {
    if (!data?.stories?.some((story) => story.id === storyId)) return
    setSelectedStoryId(storyId)
    setActiveView('stories')
    const url = new URL(window.location.href)
    url.searchParams.set('view', 'stories')
    url.searchParams.set('story', storyId)
    window.history.replaceState(null, '', url)
  }, [data])

  const openEntity = useCallback((id) => {
    selectEntity(id)
    navigate('explore')
  }, [navigate, selectEntity])

  const resetFilters = () => {
    setTypeFilter('ALL')
    setCivilizationFilter('ALL')
  }

  if (error) {
    return (
      <div className="load-screen error-screen">
        <span>!</span>
        <h1>{copy.loadError}</h1>
        <code>{String(error.message || error)}</code>
        <button type="button" onClick={loadData}>{copy.retry}</button>
      </div>
    )
  }

  if (!data || !selectedEntity) {
    return (
      <div className="load-screen">
        <div className="loading-compass" />
        <h1>{copy.loading}</h1>
      </div>
    )
  }

  return (
    <div className="app-shell">
      <Header
        activeView={activeView}
        copy={copy}
        language={language}
        menuOpen={menuOpen}
        onNavigate={navigate}
        onToggleLanguage={() => setLanguage((current) => current === 'zh' ? 'en' : 'zh')}
        onToggleMenu={() => setMenuOpen((current) => !current)}
      />

      <section className="discovery-bar">
        <label className="search-box">
          <SearchIcon size={26} />
          <input
            aria-label={copy.searchPlaceholder}
            placeholder={copy.searchPlaceholder}
            type="search"
            value={query}
            onChange={(event) => setQuery(event.target.value)}
          />
        </label>
        <MetricStrip copy={copy} counts={data.meta.counts} />
      </section>

      {activeView === 'explore' && (
        <>
          <MobileFilters
            civilizations={data.civilizations}
            civilizationFilter={civilizationFilter}
            copy={copy}
            language={language}
            onCivilizationChange={setCivilizationFilter}
            onTypeChange={setTypeFilter}
            typeCounts={data.meta.typeCounts}
            typeFilter={typeFilter}
          />
          <main className="explorer-layout">
            <Filters
              civilizations={data.civilizations}
              civilizationFilter={civilizationFilter}
              copy={copy}
              language={language}
              onCivilizationChange={setCivilizationFilter}
              onReset={resetFilters}
              onTypeChange={setTypeFilter}
              typeCounts={data.meta.typeCounts}
              typeFilter={typeFilter}
            />
            <EntityList
              copy={copy}
              entities={filteredEntities}
              language={language}
              onSelect={(id) => selectEntity(id)}
              selectedId={selectedEntity.id}
            />
            <EntityDetail
              copy={copy}
              entity={selectedEntity}
              language={language}
              mobileOpen={mobileDetailOpen}
              onCloseMobile={() => setMobileDetailOpen(false)}
              onNavigate={navigate}
              onOpenStory={selectStory}
              onSelect={(id) => selectEntity(id)}
            />
          </main>
          {mobileDetailOpen && <button aria-label={copy.close} className="mobile-scrim" type="button" onClick={() => setMobileDetailOpen(false)} />}
        </>
      )}

      {activeView === 'workbench' && (
        <ExplorerWorkbench
          data={data}
          entity={selectedEntity}
          language={language}
          onNavigate={navigate}
          onSelect={(id) => selectEntity(id, { openMobile: false })}
        />
      )}

      {activeView === 'stories' && (
        <StoryLibrary
          language={language}
          onOpenEntity={openEntity}
          onSelectStory={selectStory}
          readingRoutes={data.readingRoutes || []}
          selectedStoryId={selectedStoryId}
          stories={data.stories || []}
        />
      )}

      {activeView === 'graph' && (
        <GraphView
          copy={copy}
          entities={filteredEntities}
          entity={selectedEntity}
          language={language}
          onSelect={(id) => selectEntity(id, { openMobile: false })}
        />
      )}
      {activeView === 'thunder' && (
        <ThunderView
          comparisons={data.comparisons || []}
          copy={copy}
          entities={data.entities}
          language={language}
          onOpenEntity={openEntity}
        />
      )}
      {activeView === 'evidence' && <EvidenceView claims={data.claims} copy={copy} language={language} />}
      {activeView === 'progress' && <ProgressView copy={copy} language={language} meta={data.meta} queue={data.queue} />}
      {activeView === 'contribute' && <ContributeView copy={copy} language={language} />}

      <footer className="site-footer">
        <span>{copy.brand} · {data.meta.projectVersion}</span>
        <span>{copy.footer}</span>
        <span>{copy.stagedBaseline}</span>
      </footer>
    </div>
  )
}
