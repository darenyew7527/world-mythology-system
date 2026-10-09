import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { CloseIcon } from './Icons.jsx'
import { TELLER_SCALES, loadReaderState, saveTellerSettings } from '../readerStorage.js'

const ui = {
  zh: {
    mode: '讲故事模式',
    start: '开始讲述',
    previous: '上一段',
    next: '下一段',
    finish: '讲完了',
    restart: '从头再讲',
    close: '退出讲故事模式',
    notes: '来源与说明',
    hideNotes: '隐藏来源',
    showNotes: '显示来源',
    smaller: '缩小文字',
    larger: '放大文字',
    source: '来源',
    evidence: '证据',
    uncertain: '尚不确定',
    layer: '知识层',
    boundary: '讲述边界',
    readFull: '阅读完整故事',
    openProfile: '查看神祇档案',
    beat: '段',
    keys: '← → 翻页 · 空格 下一段 · N 来源 · Esc 退出',
    empty: '这张卡片没有可讲述的内容。',
    access: {
      PUBLIC_CONTEXT: '公开语境',
      ATTRIBUTION_REQUIRED: '须署名',
      PERMISSION_REQUIRED: '需社区授权',
      DO_NOT_COLLECT: '不收集',
    },
  },
  en: {
    mode: 'Storyteller mode',
    start: 'Begin',
    previous: 'Previous',
    next: 'Next',
    finish: 'The end',
    restart: 'Tell it again',
    close: 'Leave storyteller mode',
    notes: 'Sources and notes',
    hideNotes: 'Hide sources',
    showNotes: 'Show sources',
    smaller: 'Smaller text',
    larger: 'Larger text',
    source: 'Source',
    evidence: 'Evidence',
    uncertain: 'Uncertain',
    layer: 'Layer',
    boundary: 'Storytelling boundary',
    readFull: 'Read the full story',
    openProfile: 'Open deity profile',
    beat: 'beat',
    keys: '← → turn · Space next · N sources · Esc leave',
    empty: 'This card has nothing to tell yet.',
    access: {
      PUBLIC_CONTEXT: 'Public context',
      ATTRIBUTION_REQUIRED: 'Attribution required',
      PERMISSION_REQUIRED: 'Permission required',
      DO_NOT_COLLECT: 'Not collected',
    },
  },
}

const layerLabels = {
  zh: {
    MYTHIC_NARRATIVE: '神话叙事', TEXTUAL_WITNESS: '文本见证', ARCHAEOLOGICAL: '考古与物证', RITUAL_PRACTICE: '仪式实践',
    SCHOLARLY_INTERPRETATION: '学术解释', LATER_RECEPTION: '后世接受', POPULAR_CULTURE: '流行文化', SPECULATION: '推测',
    IN_TRADITION: '传统内部说法', TEXT_SAYS: '文本所述', HISTORICAL_REALITY: '历史层面', MODERN_RECEPTION: '现代接受',
  },
  en: {
    MYTHIC_NARRATIVE: 'Mythic narrative', TEXTUAL_WITNESS: 'Textual witness', ARCHAEOLOGICAL: 'Archaeological / material', RITUAL_PRACTICE: 'Ritual practice',
    SCHOLARLY_INTERPRETATION: 'Scholarly interpretation', LATER_RECEPTION: 'Later reception', POPULAR_CULTURE: 'Popular culture', SPECULATION: 'Speculation',
    IN_TRADITION: 'Within the tradition', TEXT_SAYS: 'What the text says', HISTORICAL_REALITY: 'Historical layer', MODERN_RECEPTION: 'Modern reception',
  },
}

const layerText = (beat, language) => [beat.layer, beat.scope]
  .filter((code, index, list) => code && list.indexOf(code) === index)
  .map((code) => layerLabels[language]?.[code] || code)
  .join(' · ')

const pick = (language, zh, en) => (language === 'zh' ? zh || en : en || zh)

export default function StorytellerMode({ deck, language, onClose, onOpenEntity, onOpenStory }) {
  const copy = ui[language] || ui.zh
  const total = deck.beats.length
  // 0 = cover, 1..total = beats, total + 1 = closing card
  const [position, setPosition] = useState(0)
  const [settings, setSettings] = useState(() => loadReaderState().settings)
  const dialogRef = useRef(null)
  const pointerStart = useRef(null)
  const lastPosition = total + 1

  const go = useCallback((next) => {
    setPosition((current) => {
      const target = typeof next === 'function' ? next(current) : next
      return Math.max(0, Math.min(lastPosition, target))
    })
  }, [lastPosition])

  const updateSettings = useCallback((partial) => {
    setSettings((current) => ({ ...current, ...partial }))
    saveTellerSettings(partial)
  }, [])

  const scaleIndex = TELLER_SCALES.indexOf(settings.tellerScale)
  const changeScale = useCallback((delta) => {
    const index = Math.max(0, Math.min(TELLER_SCALES.length - 1, (scaleIndex < 0 ? 1 : scaleIndex) + delta))
    updateSettings({ tellerScale: TELLER_SCALES[index] })
  }, [scaleIndex, updateSettings])

  useEffect(() => {
    const previousFocus = document.activeElement
    const previousOverflow = document.body.style.overflow
    document.body.style.overflow = 'hidden'
    dialogRef.current?.focus()
    return () => {
      document.body.style.overflow = previousOverflow
      if (previousFocus && typeof previousFocus.focus === 'function') previousFocus.focus()
    }
  }, [])

  useEffect(() => {
    const onKey = (event) => {
      if (event.altKey || event.ctrlKey || event.metaKey) return
      const tag = event.target?.tagName
      const onButton = tag === 'BUTTON' || tag === 'A'
      if (event.key === 'Escape') { event.preventDefault(); onClose() }
      else if (event.key === 'ArrowRight' || event.key === 'PageDown') { event.preventDefault(); go((p) => p + 1) }
      else if (event.key === 'ArrowLeft' || event.key === 'PageUp') { event.preventDefault(); go((p) => p - 1) }
      else if (event.key === ' ' && !onButton) { event.preventDefault(); go((p) => p + (event.shiftKey ? -1 : 1)) }
      else if (event.key === 'Home') { event.preventDefault(); go(0) }
      else if (event.key === 'End') { event.preventDefault(); go(lastPosition) }
      else if (event.key === 'n' || event.key === 'N') updateSettings({ tellerNotes: !settings.tellerNotes })
      else if (event.key === '+' || event.key === '=') changeScale(1)
      else if (event.key === '-' || event.key === '_') changeScale(-1)
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [changeScale, go, lastPosition, onClose, settings.tellerNotes, updateSettings])

  const onPointerDown = (event) => {
    if (event.pointerType === 'mouse') return
    pointerStart.current = { x: event.clientX, y: event.clientY }
  }
  const onPointerUp = (event) => {
    const start = pointerStart.current
    pointerStart.current = null
    if (!start) return
    const dx = event.clientX - start.x
    const dy = event.clientY - start.y
    if (Math.abs(dx) > 48 && Math.abs(dx) > Math.abs(dy) * 1.4) go((p) => p + (dx < 0 ? 1 : -1))
  }

  // Keep Tab focus inside the dialog.
  const onKeyDownTrap = (event) => {
    if (event.key !== 'Tab' || !dialogRef.current) return
    const focusable = [...dialogRef.current.querySelectorAll('button:not([disabled]), a[href]')]
    if (focusable.length === 0) return
    const first = focusable[0]
    const last = focusable[focusable.length - 1]
    if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last.focus() }
    else if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first.focus() }
  }

  const beat = position >= 1 && position <= total ? deck.beats[position - 1] : null
  const title = pick(language, deck.titleZh, deck.titleEn)
  const subtitle = pick(language, deck.subtitleZh, deck.subtitleEn)
  const civilization = pick(language, deck.civilizationZh, deck.civilizationEn)
  const hook = pick(language, deck.hookZh, deck.hookEn)
  const boundary = pick(language, deck.boundaryZh, deck.boundaryEn)
  const progress = useMemo(() => (total === 0 ? 0 : Math.round((Math.min(position, total) / total) * 100)), [position, total])

  return (
    <div
      aria-labelledby="teller-title"
      aria-modal="true"
      className={`teller teller-scale-${settings.tellerScale}`}
      ref={dialogRef}
      role="dialog"
      tabIndex={-1}
      onKeyDown={onKeyDownTrap}
    >
      <header className="teller-bar">
        <div className="teller-identity">
          <span>{copy.mode} · {civilization}</span>
          <strong id="teller-title">{title}</strong>
        </div>
        <div className="teller-tools">
          <button aria-label={copy.smaller} disabled={scaleIndex === 0} type="button" onClick={() => changeScale(-1)}>A−</button>
          <button aria-label={copy.larger} disabled={scaleIndex === TELLER_SCALES.length - 1} type="button" onClick={() => changeScale(1)}>A+</button>
          <button aria-pressed={settings.tellerNotes} type="button" onClick={() => updateSettings({ tellerNotes: !settings.tellerNotes })}>
            {settings.tellerNotes ? copy.hideNotes : copy.showNotes}
          </button>
          <button aria-label={copy.close} className="teller-close" type="button" onClick={onClose}><CloseIcon size={22} /></button>
        </div>
        <div className="teller-progress" aria-hidden="true"><i style={{ width: `${progress}%` }} /></div>
      </header>

      <main className="teller-stage" onPointerDown={onPointerDown} onPointerUp={onPointerUp}>
        <div className="teller-page" key={position} aria-live="polite">
          {position === 0 && (
            <section className="teller-cover">
              <span>{civilization}</span>
              <h2>{title}</h2>
              {subtitle && <p className="teller-subtitle">{subtitle}</p>}
              {hook && <p className="teller-hook">{hook}</p>}
              <small>{total} {copy.beat} · {copy.access[deck.accessLevel] || deck.accessLevel}</small>
              {total > 0
                ? <button className="teller-primary" type="button" onClick={() => go(1)}>{copy.start} →</button>
                : <p className="teller-empty">{copy.empty}</p>}
            </section>
          )}

          {beat && (
            <article className="teller-beat">
              <span className="teller-count">{String(position).padStart(2, '0')} / {String(total).padStart(2, '0')}</span>
              {pick(language, beat.headingZh, beat.headingEn) && <h2>{pick(language, beat.headingZh, beat.headingEn)}</h2>}
              <p className="teller-text">{pick(language, beat.textZh, beat.textEn)}</p>
              {language === 'zh' && !beat.headingZh && beat.textEn && <p className="teller-statement" lang="en">{beat.textEn}</p>}
              {settings.tellerNotes && (
                <aside className="teller-notes" aria-label={copy.notes}>
                  {beat.source && <p><strong>{copy.source}</strong>{beat.source}</p>}
                  {beat.note && <p><strong>{copy.evidence}</strong>{beat.note}</p>}
                  {layerText(beat, language) && <p><strong>{copy.layer}</strong>{layerText(beat, language)}</p>}
                  {beat.uncertainty && <p className="teller-uncertain"><strong>{copy.uncertain}</strong>{beat.uncertainty}</p>}
                </aside>
              )}
            </article>
          )}

          {position === lastPosition && (
            <section className="teller-cover teller-closing">
              <span>{copy.finish}</span>
              <h2>{title}</h2>
              {boundary && <p className="teller-boundary"><strong>{copy.boundary}</strong>{boundary}</p>}
              {!boundary && deck.closingZh && <p className="teller-boundary"><strong>{copy.boundary}</strong>{deck.closingZh}</p>}
              <div className="teller-closing-actions">
                <button className="teller-primary" type="button" onClick={() => go(total > 0 ? 1 : 0)}>{copy.restart}</button>
                {deck.storyId && onOpenStory && deck.kind === 'DEITY' && (
                  <button type="button" onClick={() => onOpenStory(deck.storyId)}>{copy.readFull}</button>
                )}
                {deck.entityId && onOpenEntity && (
                  <button type="button" onClick={() => onOpenEntity(deck.entityId)}>{copy.openProfile}</button>
                )}
              </div>
            </section>
          )}
        </div>
      </main>

      <footer className="teller-controls">
        <button disabled={position === 0} type="button" onClick={() => go((p) => p - 1)}>← {copy.previous}</button>
        <nav aria-label={copy.mode} className="teller-dots">
          {deck.beats.map((item, index) => (
            <button
              aria-current={position === index + 1 ? 'step' : undefined}
              aria-label={`${index + 1} / ${total}`}
              key={item.id || index}
              type="button"
              onClick={() => go(index + 1)}
            />
          ))}
        </nav>
        <button disabled={position === lastPosition} type="button" onClick={() => go((p) => p + 1)}>{copy.next} →</button>
        <small className="teller-keys">{copy.keys}</small>
      </footer>
    </div>
  )
}
