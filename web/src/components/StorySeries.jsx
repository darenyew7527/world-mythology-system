// Story series (v0.33): a shelf of multi-part readings, a "part X of N" bar in
// the reader and a continue-to-next-part link at the end of each part. Which
// part to continue is worked out from the existing on-device reading positions;
// nothing new is stored.
import { useEffect, useRef } from 'react'
import { scrollToAnchor } from './ChapterNav.jsx'

const ui = {
  zh: {
    shelf: '系列连载',
    shelfHint: '按原著顺序连读的多部长篇；每一部都是完整的故事，跳过的章节会注明。',
    parts: (n) => `${n} 部`,
    chapters: (n) => `${n} 章`,
    minutes: (n) => `约 ${n} 分钟`,
    start: '从第一部开始',
    continue: (label) => `继续读 · ${label}`,
    finished: '已读完全部',
    previous: '上一部',
    next: '下一部',
    nextPart: '继续读下一部',
    seriesEnd: (title) => `《${title}》到此读完`,
    contents: (n) => `${n} 部目录`,
    backToShelf: '回到系列目录',
    skipped: '跳过的章节',
    read: '已读完',
    reading: '读到一半',
  },
  en: {
    shelf: 'Story series',
    shelfHint: 'Multi-part readings in the order of the original work; each part is a complete story, and skipped chapters are named.',
    parts: (n) => `${n} parts`,
    chapters: (n) => `${n} chapters`,
    minutes: (n) => `about ${n} min`,
    start: 'Start with part 1',
    continue: (label) => `Continue · ${label}`,
    finished: 'All parts read',
    previous: 'Previous part',
    next: 'Next part',
    nextPart: 'Continue with the next part',
    seriesEnd: (title) => `End of ${title}`,
    contents: (n) => `Contents · ${n} parts`,
    backToShelf: 'Back to the series list',
    skipped: 'Skipped chapters',
    read: 'Read',
    reading: 'In progress',
  },
}

export const SERIES_SHELF_ID = 'story-series-shelf'
export const READER_TOP_ID = 'story-reader-top'

const title = (item, language) => (language === 'zh' ? item.titleZh || item.titleEn : item.titleEn || item.titleZh)
const label = (item, language) => (language === 'zh' ? item.labelZh : item.labelEn)

// Share of a story read on this device: the furthest position in any of its versions.
export const partProgress = (story, progress = {}) => {
  if (!story) return 0
  let best = 0
  for (const version of story.versions || []) {
    const total = version.sections?.length || 0
    const order = Number(progress[version.id]?.sectionOrder || 0)
    if (total > 0) best = Math.max(best, Math.min(order, total) / total)
  }
  return best
}

// The part to continue: the latest part with any progress, or the one after it once finished.
export const continuePart = (series, storiesById, progress) => {
  const states = series.parts.map((part) => partProgress(storiesById.get(part.storyId), progress))
  const last = states.reduce((found, value, index) => (value > 0 ? index : found), -1)
  if (last === -1) return { part: series.parts[0], started: false }
  if (states[last] < 1) return { part: series.parts[last], started: true }
  const next = series.parts.slice(last + 1).find((_, offset) => states[last + 1 + offset] < 1)
  return next ? { part: next, started: true } : { part: null, started: true }
}

// Part lists start folded on phones, and on wide screens only the series being read
// is unfolded, so the reader is not pushed far below the shelf (v0.34: nine series).
const wideScreen = () => typeof window === 'undefined' || !window.matchMedia?.('(max-width: 760px)').matches

const openPart = (onSelectStory, storyId) => {
  onSelectStory(storyId)
  // The reader re-mounts for the new story; move to its heading once it is drawn.
  setTimeout(() => scrollToAnchor(READER_TOP_ID), 60)
}

export default function SeriesShelf({ language, onSelectStory, progress, selectedStoryId, series, storiesById }) {
  const copy = ui[language] || ui.zh
  const listRef = useRef(null)
  const currentSeriesId = series.find((item) => item.parts.some((part) => part.storyId === selectedStoryId))?.id
  // The shelf is one swipeable row; bring the series being read into view without moving the page.
  useEffect(() => {
    const list = listRef.current
    const card = list?.querySelector('[data-current="true"]')
    if (!card) return
    const offset = card.getBoundingClientRect().left - list.getBoundingClientRect().left
    if (offset < 0 || offset + card.offsetWidth > list.clientWidth) list.scrollLeft += offset - 10
  }, [currentSeriesId])
  if (!series.length) return null
  const unfold = wideScreen()
  return (
    <section className="story-series-shelf" aria-labelledby={`${SERIES_SHELF_ID}-title`} id={SERIES_SHELF_ID} tabIndex={-1}>
      <header>
        <div>
          <strong id={`${SERIES_SHELF_ID}-title`}>{copy.shelf}</strong>
          <span>{copy.shelfHint}</span>
        </div>
        <b>{series.length}</b>
      </header>
      <div className="story-series-list" ref={listRef}>
        {series.map((item) => {
          const resume = continuePart(item, storiesById, progress)
          return (
            <article className="story-series-card" data-current={item.id === currentSeriesId ? 'true' : undefined} key={item.id}>
              <h3>{title(item, language)}</h3>
              <p>{language === 'zh' ? item.descriptionZh : item.descriptionEn}</p>
              <small className="story-series-meta">
                {copy.parts(item.parts.length)} · {copy.chapters(item.totalChapters)} · {copy.minutes(item.totalMinutes)}
              </small>
              <details className="story-series-parts" open={unfold && item.id === currentSeriesId}>
              <summary>{copy.contents(item.parts.length)}</summary>
              <ol>
                {item.parts.map((part) => {
                  const share = partProgress(storiesById.get(part.storyId), progress)
                  const state = share >= 1 ? 'read' : share > 0 ? 'reading' : undefined
                  return (
                    <li data-state={state} key={part.storyId}>
                      <button
                        aria-current={part.storyId === selectedStoryId ? 'true' : undefined}
                        title={part.gapNote || part.sourceSpan}
                        type="button"
                        onClick={() => openPart(onSelectStory, part.storyId)}
                      >
                        <span>{String(part.order).padStart(2, '0')}</span>
                        <strong>{label(part, language)}</strong>
                        <small>
                          {part.sourceSpan} · {copy.chapters(part.chapters)}
                          {state ? ` · ${state === 'read' ? copy.read : copy.reading}` : ''}
                        </small>
                      </button>
                    </li>
                  )
                })}
              </ol>
              </details>
              {resume.part ? (
                <button className="story-series-continue" type="button" onClick={() => openPart(onSelectStory, resume.part.storyId)}>
                  {resume.started ? copy.continue(label(resume.part, language)) : copy.start}
                </button>
              ) : <p className="story-series-done">✓ {copy.finished}</p>}
            </article>
          )
        })}
      </div>
    </section>
  )
}

// "Part X of N" with previous/next part, shown under the reader heading.
export function SeriesBar({ language, onSelectStory, story, storiesById }) {
  const copy = ui[language] || ui.zh
  const series = story?.series
  if (!series) return null
  const previous = storiesById.get(series.previousStoryId)
  const next = storiesById.get(series.nextStoryId)
  return (
    <nav className="story-series-bar" aria-label={title(series, language)}>
      <button className="story-series-title" type="button" onClick={() => scrollToAnchor(SERIES_SHELF_ID)}>
        {title(series, language)}
      </button>
      <strong>{label(series, language)} ({series.partOrder}/{series.partCount})</strong>
      <small>{series.sourceSpan}</small>
      <span className="story-series-steps">
        {previous && (
          <button type="button" onClick={() => openPart(onSelectStory, previous.id)}>
            <span aria-hidden="true">←</span> {copy.previous}
          </button>
        )}
        {next && (
          <button type="button" onClick={() => openPart(onSelectStory, next.id)}>
            {copy.next} <span aria-hidden="true">→</span>
          </button>
        )}
      </span>
      {series.gapNote && <em>{copy.skipped}: {series.gapNote}</em>}
    </nav>
  )
}

// End of a part: carry straight on into the next one.
export function SeriesNext({ language, onSelectStory, story, storiesById }) {
  const copy = ui[language] || ui.zh
  const series = story?.series
  if (!series) return null
  const next = storiesById.get(series.nextStoryId)
  if (!next) {
    return (
      <nav className="story-series-next" data-end aria-label={title(series, language)}>
        <strong>{copy.seriesEnd(title(series, language))}</strong>
        <button type="button" onClick={() => scrollToAnchor(SERIES_SHELF_ID)}>{copy.backToShelf}</button>
      </nav>
    )
  }
  return (
    <nav className="story-series-next" aria-label={title(series, language)}>
      <button type="button" onClick={() => openPart(onSelectStory, next.id)}>
        <span>{copy.nextPart}</span>
        <b>{label(next.series, language)} ({next.series.partOrder}/{next.series.partCount})</b>
        {next.series?.gapNote && <small>{copy.skipped}: {next.series.gapNote}</small>}
        <span aria-hidden="true">→</span>
      </button>
    </nav>
  )
}
