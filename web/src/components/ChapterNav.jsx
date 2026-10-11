// Chapter navigation for long-form stories (v0.32): a contents list, a
// "continue reading" jump to the first unread chapter, and a next-chapter link
// at the end of each chapter. Positions are remembered on this device only.

const ui = {
  zh: {
    toc: '目录',
    chapters: '章',
    minutes: (n) => `约 ${n} 分钟`,
    read: (n, total) => `已读 ${n}/${total}`,
    resume: '继续阅读',
    chapter: (n) => `第 ${n} 章`,
    next: '下一章',
    end: '全篇完',
    backToToc: '回到目录',
  },
  en: {
    toc: 'Contents',
    chapters: 'chapters',
    minutes: (n) => `about ${n} min`,
    read: (n, total) => `${n}/${total} read`,
    resume: 'Continue reading',
    chapter: (n) => `Chapter ${n}`,
    next: 'Next chapter',
    end: 'The end',
    backToToc: 'Back to contents',
  },
}

export const chapterAnchor = (prefix, id) => `${prefix}-${String(id).replace(/[^A-Za-z0-9_-]+/g, '-')}`

export const scrollToAnchor = (anchorId) => {
  if (typeof document === 'undefined') return
  const target = document.getElementById(anchorId)
  if (!target) return
  const reduce = window.matchMedia?.('(prefers-reduced-motion: reduce)').matches
  target.scrollIntoView({ behavior: reduce ? 'auto' : 'smooth', block: 'start' })
  const heading = target.querySelector('[data-chapter-heading]') || target
  heading.focus?.({ preventScroll: true })
}

export default function ChapterNav({ chapters, language, minutes, prefix, progressOrder = 0 }) {
  const copy = ui[language] || ui.zh
  const total = chapters.length
  const read = Math.min(progressOrder, total)
  const resume = read > 0 && read < total ? chapters.find((chapter) => chapter.order > read) : null

  return (
    <nav className="chapter-nav" aria-label={copy.toc} id={`${prefix}-toc`} tabIndex={-1}>
      <header>
        <strong>{copy.toc}</strong>
        <span>
          {total} {copy.chapters}
          {minutes ? ` · ${copy.minutes(minutes)}` : ''}
          {read > 0 ? ` · ${copy.read(read, total)}` : ''}
        </span>
        {read > 0 && (
          <progress aria-label={copy.read(read, total)} max={total} value={read} />
        )}
      </header>
      {resume && (
        <button className="chapter-resume" type="button" onClick={() => scrollToAnchor(chapterAnchor(prefix, resume.id))}>
          {copy.resume} · {copy.chapter(resume.order)} {resume.title}
        </button>
      )}
      <ol>
        {chapters.map((chapter) => (
          <li data-read={chapter.order <= read || undefined} key={chapter.id}>
            <button type="button" onClick={() => scrollToAnchor(chapterAnchor(prefix, chapter.id))}>
              <span>{String(chapter.order).padStart(2, '0')}</span>
              {chapter.title}
            </button>
          </li>
        ))}
      </ol>
    </nav>
  )
}

// End-of-chapter link: records the chapter as read, then moves to the next one.
export function NextChapter({ chapters, language, onAdvance, position, prefix }) {
  const copy = ui[language] || ui.zh
  const current = chapters[position]
  const next = chapters[position + 1]
  const advance = () => {
    onAdvance?.(current.order)
    scrollToAnchor(next ? chapterAnchor(prefix, next.id) : `${prefix}-toc`)
  }
  return (
    <button className="chapter-next" data-end={!next || undefined} type="button" onClick={advance}>
      {next
        ? <>{copy.next}<b>{copy.chapter(next.order)} · {next.title}</b><span aria-hidden="true">→</span></>
        : <>{copy.end}<b>{copy.backToToc}</b><span aria-hidden="true">↑</span></>}
    </button>
  )
}
