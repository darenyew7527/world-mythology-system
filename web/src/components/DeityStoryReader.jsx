import { useEffect, useMemo, useState } from 'react'
import { LONG_STORY_SECTIONS, deckFromCard, readingMinutes } from '../storyDeck.js'
import { readingPosition, saveReadingPosition } from '../readerStorage.js'
import ChapterNav, { chapterAnchor, NextChapter } from './ChapterNav.jsx'

const ui = {
  zh: {
    tell: '▶ 讲故事模式',
    full: '阅读完整故事（版本与来源）',
    profile: '查看档案',
    source: '来源',
    uncertain: '尚不确定',
    boundary: '讲述边界',
    statement: '原始表述',
    status: { STORY_LINKED: '完整故事', CLAIM_CARD: '证据卡', PERMISSION_LIMITED: '需社区授权', PENDING_SOURCES: '待补来源' },
    claimIntro: '这位神祇还没有成段的故事；下面按出处逐条讲述目前登记的记载。',
    long: (n) => `长篇 · ${n} 章`,
    more: (name) => `更多关于${name}的故事`,
    chapters: (n) => `${n} 章`,
    minutes: (n) => `约 ${n} 分钟`,
  },
  en: {
    tell: '▶ Storyteller mode',
    full: 'Read the full story (versions and sources)',
    profile: 'Open profile',
    source: 'Source',
    uncertain: 'Uncertain',
    boundary: 'Storytelling boundary',
    statement: 'Original statement',
    status: { STORY_LINKED: 'Full story', CLAIM_CARD: 'Evidence card', PERMISSION_LIMITED: 'Permission required', PENDING_SOURCES: 'Awaiting sources' },
    claimIntro: 'This deity has no continuous story yet; the recorded evidence is told point by point, each with its source.',
    long: (n) => `Long story · ${n} chapters`,
    more: (name) => `More stories about ${name}`,
    chapters: (n) => `${n} chapters`,
    minutes: (n) => `about ${n} min`,
  },
}

const pick = (language, zh, en) => (language === 'zh' ? zh || en : en || zh)

// Full, readable text of a deity story card — shown inline so a story can be
// read the moment a deity is opened. It renders exactly the beats the
// storyteller mode uses, so both views stay in step. Long stories (v0.32) get
// a chapter list, next-chapter links and a remembered reading position.
export default function DeityStoryReader({ card, headingLevel = 2, index, language, onOpenEntity, onOpenStory, onTell }) {
  const copy = ui[language] || ui.zh
  const deck = useMemo(() => deckFromCard(card, index), [card, index])
  const [progress, setProgress] = useState(() => readingPosition(card.primaryVersionId))
  useEffect(() => setProgress(readingPosition(card.primaryVersionId)), [card.primaryVersionId])
  const Heading = `h${headingLevel}`
  const SubHeading = `h${Math.min(headingLevel + 1, 6)}`
  const hook = pick(language, card.hookZh, card.hookEn)
  const boundary = card.boundary && pick(language, card.boundary.textZh, card.boundary.textEn)
  const primaryTitle = card.primaryStoryId ? pick(language, deck.subtitleZh, deck.subtitleEn) : null
  const isStory = card.status === 'STORY_LINKED'
  const isLong = isStory && deck.beats.length >= LONG_STORY_SECTIONS
  const showChapters = isStory && deck.beats.length >= 6
  const prefix = `deity-${headingLevel}-${card.entityId}`
  const minutes = readingMinutes(deck.beats, language)
  const chapters = useMemo(() => deck.beats.map((beat, position) => ({
    id: beat.id || String(position),
    order: position + 1,
    title: pick(language, beat.headingZh, beat.headingEn) || String(position + 1),
  })), [deck, language])

  const otherStories = useMemo(() => (card.storyIds || [])
    .filter((storyId) => storyId !== card.primaryStoryId)
    .map((storyId) => index.storiesById.get(storyId))
    .filter(Boolean)
    .map((story) => ({
      id: story.id,
      title: pick(language, story.titleZh, story.canonicalTitle),
      chapters: Math.max(0, ...story.versions.map((version) => version.sections.length)),
      minutes: story.readingMinutes,
      series: story.series,
    }))
    // Parts of a series keep their reading order (v0.33); other stories, longest first.
    .sort((a, b) => (a.series && b.series && a.series.id === b.series.id
      ? a.series.partOrder - b.series.partOrder
      : Boolean(b.series) - Boolean(a.series) || (a.series?.id || '').localeCompare(b.series?.id || '') || b.chapters - a.chapters)),
  [card, index, language])

  const advance = (order) => {
    if (order <= progress) return
    setProgress(order)
    saveReadingPosition(card.primaryVersionId, card.primaryStoryId, order)
  }

  return (
    <article className="deity-reader" data-status={card.status}>
      <header>
        <span>
          {pick(language, card.civilizationNameZh, card.civilizationName)}
          <b className="deity-badge" data-status={card.status}>{copy.status[card.status] || card.status}</b>
          {isLong && <b className="deity-long-badge">{copy.long(deck.beats.length)}</b>}
        </span>
        <Heading>{pick(language, card.nameZh, card.name)}{language === 'zh' && card.name && <em>{card.name}</em>}</Heading>
        {primaryTitle && <p className="deity-reader-story-title">{primaryTitle}</p>}
        {hook && <p className="deity-reader-hook">{hook}</p>}
      </header>

      {card.status === 'CLAIM_CARD' && <p className="deity-reader-intro">{copy.claimIntro}</p>}

      {showChapters && (
        <ChapterNav chapters={chapters} language={language} minutes={minutes} prefix={prefix} progressOrder={progress} />
      )}

      {deck.beats.length > 0 && (
        <ol className="deity-reader-beats">
          {deck.beats.map((beat, position) => {
            const heading = pick(language, beat.headingZh, beat.headingEn)
            return (
              <li
                data-read={(showChapters && position + 1 <= progress) || undefined}
                id={showChapters ? chapterAnchor(prefix, chapters[position].id) : undefined}
                key={beat.id || position}
              >
                <span>{String(position + 1).padStart(2, '0')}</span>
                <div>
                  {heading && <SubHeading data-chapter-heading tabIndex={-1}>{heading}</SubHeading>}
                  <p className="deity-reader-text">{pick(language, beat.textZh, beat.textEn)}</p>
                  {language === 'zh' && !beat.headingZh && beat.textEn && (
                    <p className="deity-reader-statement" lang="en"><b>{copy.statement}</b>{beat.textEn}</p>
                  )}
                  {beat.source && <small><b>{copy.source}</b>{beat.source}{beat.note ? ` — ${beat.note}` : ''}</small>}
                  {beat.uncertainty && <small className="deity-reader-uncertain"><b>{copy.uncertain}</b>{beat.uncertainty}</small>}
                  {showChapters && (
                    <NextChapter chapters={chapters} language={language} onAdvance={advance} position={position} prefix={prefix} />
                  )}
                </div>
              </li>
            )
          })}
        </ol>
      )}

      {boundary && <p className="deity-boundary deity-reader-boundary"><b>{copy.boundary}</b>{boundary}</p>}

      {otherStories.length > 0 && onOpenStory && (
        <section className="deity-other-stories" aria-label={copy.more(pick(language, card.nameZh, card.name))}>
          <h3>{copy.more(pick(language, card.nameZh, card.name))}</h3>
          <ul>
            {otherStories.map((story) => (
              <li key={story.id}>
                <button type="button" onClick={() => onOpenStory(story.id)}>
                  <strong>{story.title}</strong>
                  {story.series && (
                    <small className="deity-series-part">
                      {pick(language, story.series.titleZh, story.series.titleEn)} · {pick(language, story.series.labelZh, story.series.labelEn)}
                    </small>
                  )}
                  <small>
                    {story.chapters >= LONG_STORY_SECTIONS ? copy.long(story.chapters) : copy.chapters(story.chapters)}
                    {story.minutes ? ` · ${copy.minutes(story.minutes)}` : ''}
                  </small>
                </button>
              </li>
            ))}
          </ul>
        </section>
      )}

      <footer>
        {deck.beats.length > 0 && onTell && (
          <button className="deity-tell" type="button" onClick={() => onTell(deck)}>{copy.tell}</button>
        )}
        {card.primaryStoryId && onOpenStory && (
          <button type="button" onClick={() => onOpenStory(card.primaryStoryId)}>{copy.full}</button>
        )}
        {onOpenEntity && <button type="button" onClick={() => onOpenEntity(card.entityId)}>{copy.profile}</button>}
      </footer>
    </article>
  )
}
