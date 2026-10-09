import { useMemo } from 'react'
import { deckFromCard } from '../storyDeck.js'

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
  },
}

const pick = (language, zh, en) => (language === 'zh' ? zh || en : en || zh)

// Full, readable text of a deity story card — shown inline so a story can be
// read the moment a deity is opened. It renders exactly the beats the
// storyteller mode uses, so both views stay in step.
export default function DeityStoryReader({ card, headingLevel = 2, index, language, onOpenEntity, onOpenStory, onTell }) {
  const copy = ui[language] || ui.zh
  const deck = useMemo(() => deckFromCard(card, index), [card, index])
  const Heading = `h${headingLevel}`
  const SubHeading = `h${Math.min(headingLevel + 1, 6)}`
  const hook = pick(language, card.hookZh, card.hookEn)
  const boundary = card.boundary && pick(language, card.boundary.textZh, card.boundary.textEn)
  const primaryTitle = card.primaryStoryId ? pick(language, deck.subtitleZh, deck.subtitleEn) : null

  return (
    <article className="deity-reader" data-status={card.status}>
      <header>
        <span>
          {pick(language, card.civilizationNameZh, card.civilizationName)}
          <b className="deity-badge" data-status={card.status}>{copy.status[card.status] || card.status}</b>
        </span>
        <Heading>{pick(language, card.nameZh, card.name)}{language === 'zh' && card.name && <em>{card.name}</em>}</Heading>
        {primaryTitle && <p className="deity-reader-story-title">{primaryTitle}</p>}
        {hook && <p className="deity-reader-hook">{hook}</p>}
      </header>

      {card.status === 'CLAIM_CARD' && <p className="deity-reader-intro">{copy.claimIntro}</p>}

      {deck.beats.length > 0 && (
        <ol className="deity-reader-beats">
          {deck.beats.map((beat, position) => {
            const heading = pick(language, beat.headingZh, beat.headingEn)
            return (
              <li key={beat.id || position}>
                <span>{String(position + 1).padStart(2, '0')}</span>
                <div>
                  {heading && <SubHeading>{heading}</SubHeading>}
                  <p className="deity-reader-text">{pick(language, beat.textZh, beat.textEn)}</p>
                  {language === 'zh' && !beat.headingZh && beat.textEn && (
                    <p className="deity-reader-statement" lang="en"><b>{copy.statement}</b>{beat.textEn}</p>
                  )}
                  {beat.source && <small><b>{copy.source}</b>{beat.source}{beat.note ? ` — ${beat.note}` : ''}</small>}
                  {beat.uncertainty && <small className="deity-reader-uncertain"><b>{copy.uncertain}</b>{beat.uncertainty}</small>}
                </div>
              </li>
            )
          })}
        </ol>
      )}

      {boundary && <p className="deity-boundary deity-reader-boundary"><b>{copy.boundary}</b>{boundary}</p>}

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
