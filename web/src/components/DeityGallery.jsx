import { useDeferredValue, useMemo, useState } from 'react'
import { BookIcon, SearchIcon } from './Icons.jsx'
import { deckFromCard } from '../storyDeck.js'

const ui = {
  zh: {
    eyebrow: 'v0.31 · 神祇故事',
    title: '每一位神祇都有故事',
    intro: '有完整故事的神祇，直接按原典段落讲述；只有零散记载的，用带出处的要点讲；活态传统尚未获得社区授权的，只说明边界，不替社区讲故事。',
    search: '搜索神祇、文明或别名…',
    allCivs: '全部文明',
    all: '全部',
    random: '随机讲一位',
    tell: '讲故事',
    fullStory: '完整故事',
    profile: '档案',
    beats: '段',
    shown: '位',
    none: '没有符合筛选的神祇。',
    status: {
      STORY_LINKED: '完整故事',
      CLAIM_CARD: '证据卡',
      PERMISSION_LIMITED: '需社区授权',
      PENDING_SOURCES: '待补来源',
    },
    legend: {
      STORY_LINKED: '按原典段落讲述',
      CLAIM_CARD: '用带出处的要点讲述',
      PERMISSION_LIMITED: '只说明边界',
    },
  },
  en: {
    eyebrow: 'v0.31 · Deity stories',
    title: 'Every deity has a story',
    intro: 'Deities with full stories are told section by section from their witnesses; those with scattered evidence are told through cited points; living traditions without community permission show their boundary instead of a story.',
    search: 'Search deities, traditions or names…',
    allCivs: 'All traditions',
    all: 'All',
    random: 'Tell me a random one',
    tell: 'Tell the story',
    fullStory: 'Full story',
    profile: 'Profile',
    beats: 'beats',
    shown: 'shown',
    none: 'No deities match these filters.',
    status: {
      STORY_LINKED: 'Full story',
      CLAIM_CARD: 'Evidence card',
      PERMISSION_LIMITED: 'Permission required',
      PENDING_SOURCES: 'Awaiting sources',
    },
    legend: {
      STORY_LINKED: 'told from witness sections',
      CLAIM_CARD: 'told through cited points',
      PERMISSION_LIMITED: 'boundary only',
    },
  },
}

const STATUS_ORDER = ['STORY_LINKED', 'CLAIM_CARD', 'PERMISSION_LIMITED']
const normalize = (value) => (value || '').normalize('NFKD').toLocaleLowerCase()

export default function DeityGallery({ cards, entityById, index, language, onOpenEntity, onOpenStory, onTell }) {
  const copy = ui[language] || ui.zh
  const [query, setQuery] = useState('')
  const [civilization, setCivilization] = useState('ALL')
  const [status, setStatus] = useState('ALL')
  const deferredQuery = useDeferredValue(query)

  const statusCounts = useMemo(() => {
    const counts = {}
    for (const card of cards) counts[card.status] = (counts[card.status] || 0) + 1
    return counts
  }, [cards])

  const civilizations = useMemo(() => {
    const map = new Map()
    for (const card of cards) {
      if (!card.civilizationId || map.has(card.civilizationId)) continue
      map.set(card.civilizationId, language === 'zh' ? card.civilizationNameZh || card.civilizationName : card.civilizationName)
    }
    return [...map.entries()].sort((a, b) => (a[1] || '').localeCompare(b[1] || '', language === 'zh' ? 'zh-Hans' : 'en'))
  }, [cards, language])

  const filtered = useMemo(() => {
    const needle = normalize(deferredQuery.trim())
    return cards.filter((card) => {
      if (civilization !== 'ALL' && card.civilizationId !== civilization) return false
      if (status !== 'ALL' && card.status !== status) return false
      if (!needle) return true
      const aliases = entityById.get(card.entityId)?.aliases || []
      return normalize([card.entityId, card.nameZh, card.name, card.originalName, card.civilizationNameZh,
        card.civilizationName, card.hookZh, card.hookEn, ...aliases].join(' ')).includes(needle)
    })
  }, [cards, civilization, deferredQuery, entityById, status])

  const groups = useMemo(() => {
    const map = new Map()
    for (const card of filtered) {
      const key = card.civilizationId || 'UNKNOWN'
      if (!map.has(key)) {
        map.set(key, {
          id: key,
          label: language === 'zh' ? card.civilizationNameZh || card.civilizationName : card.civilizationName,
          cards: [],
        })
      }
      map.get(key).cards.push(card)
    }
    return [...map.values()]
  }, [filtered, language])

  const tell = (card) => onTell(deckFromCard(card, index))
  const tellRandom = () => {
    const pool = filtered.filter((card) => card.beats.length > 0)
    if (pool.length === 0) return
    tell(pool[Math.floor(Math.random() * pool.length)])
  }

  return (
    <main className="deity-gallery single-view">
      <header className="deity-hero">
        <div>
          <span>{copy.eyebrow}</span>
          <h1><BookIcon size={28} />{copy.title}</h1>
          <p>{copy.intro}</p>
        </div>
        <dl>
          {STATUS_ORDER.map((key) => (
            <div data-status={key} key={key}>
              <dt>{copy.status[key]}</dt>
              <dd>{statusCounts[key] || 0}</dd>
              <small>{copy.legend[key]}</small>
            </div>
          ))}
        </dl>
      </header>

      <section className="deity-toolbar" aria-label={copy.title}>
        <label className="story-search">
          <SearchIcon size={19} />
          <input aria-label={copy.search} placeholder={copy.search} type="search" value={query} onChange={(event) => setQuery(event.target.value)} />
        </label>
        <select aria-label={copy.allCivs} value={civilization} onChange={(event) => setCivilization(event.target.value)}>
          <option value="ALL">{copy.allCivs}</option>
          {civilizations.map(([id, label]) => <option key={id} value={id}>{label}</option>)}
        </select>
        <div className="deity-status-filter" role="group" aria-label={copy.all}>
          {['ALL', ...STATUS_ORDER].map((key) => (
            <button aria-pressed={status === key} key={key} type="button" onClick={() => setStatus(key)}>
              {key === 'ALL' ? copy.all : copy.status[key]}
            </button>
          ))}
        </div>
        <button className="deity-random" type="button" onClick={tellRandom}>✦ {copy.random}</button>
        <span className="deity-count">{filtered.length} / {cards.length} {copy.shown}</span>
      </section>

      {groups.length === 0 && <p className="story-empty">{copy.none}</p>}
      {groups.map((group) => (
        <section className="deity-group" key={group.id} aria-label={group.label}>
          <h2>{group.label}<small>{group.cards.length}</small></h2>
          <div className="deity-grid">
            {group.cards.map((card) => {
              const hook = language === 'zh' ? card.hookZh || card.hookEn : card.hookEn || card.hookZh
              const primaryName = language === 'zh' ? card.nameZh : card.name
              const secondaryName = language === 'zh' ? card.name : card.nameZh
              return (
                <article className="deity-card" data-status={card.status} key={card.entityId}>
                  <header>
                    <span className="deity-badge" data-status={card.status}>{copy.status[card.status] || card.status}</span>
                    {card.beats.length > 0 && <small>{card.beats.length} {copy.beats}</small>}
                  </header>
                  <h3>{primaryName}{secondaryName && secondaryName !== primaryName && <em>{secondaryName}</em>}</h3>
                  {hook && <p>{hook}</p>}
                  {card.status === 'PERMISSION_LIMITED' && card.boundary && (
                    <p className="deity-boundary">{language === 'zh' ? card.boundary.textZh : card.boundary.textEn}</p>
                  )}
                  <footer>
                    {card.beats.length > 0 && (
                      <button className="deity-tell" type="button" onClick={() => tell(card)}>▶ {copy.tell}</button>
                    )}
                    {card.primaryStoryId && (
                      <button type="button" onClick={() => onOpenStory(card.primaryStoryId)}>{copy.fullStory}</button>
                    )}
                    <button type="button" onClick={() => onOpenEntity(card.entityId)}>{copy.profile}</button>
                  </footer>
                </article>
              )
            })}
          </div>
        </section>
      ))}
    </main>
  )
}
