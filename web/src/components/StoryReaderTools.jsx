const ui = {
  zh: {
    title: '本机阅读工具',
    localOnly: '书签、进度与阅读设置只保存在这台设备，不上传，也不进入公开数据库。',
    bookmark: '收藏本故事',
    bookmarked: '已收藏',
    progress: '阅读进度',
    section: '节',
    settings: '无障碍阅读设置',
    fontSize: '字号',
    lineHeight: '行距',
    compact: '紧凑',
    comfortable: '舒适',
    spacious: '宽松',
    contrast: '高对比',
    glossary: '术语与人物速查',
    themes: '主题术语',
    people: '人物、文本与器物',
    open: '查看档案',
    offline: '离线故事档案',
    offlineNote: '单文件 HTML 可下载后离线打开，也适合浏览器打印。',
    downloadHtml: '下载离线 HTML',
    downloadJson: '下载档案 JSON',
    print: '打印当前故事',
  },
  en: {
    title: 'On-device reader tools',
    localOnly: 'Bookmarks, progress, and reading settings stay on this device. They are not uploaded or written to the public database.',
    bookmark: 'Bookmark this story',
    bookmarked: 'Bookmarked',
    progress: 'Reading progress',
    section: 'section',
    settings: 'Accessible reading settings',
    fontSize: 'Text size',
    lineHeight: 'Line spacing',
    compact: 'Compact',
    comfortable: 'Comfortable',
    spacious: 'Spacious',
    contrast: 'High contrast',
    glossary: 'Glossary and character quick look',
    themes: 'Theme terms',
    people: 'People, texts, and artifacts',
    open: 'Open profile',
    offline: 'Offline story archive',
    offlineNote: 'Download the single-file HTML for offline reading and browser printing.',
    downloadHtml: 'Download offline HTML',
    downloadJson: 'Download archive JSON',
    print: 'Print current story',
  },
}

const labelForEntity = (entity, language) =>
  language === 'zh' ? entity.nameZh || entity.canonicalName : entity.canonicalName

export default function StoryReaderTools({
  isBookmarked,
  language,
  linkedEntities,
  onOpenEntity,
  onSettingsChange,
  onToggleBookmark,
  progressOrder,
  selected,
  selectedVersion,
  settings,
}) {
  const copy = ui[language] || ui.zh
  const sectionCount = selectedVersion.sections.length
  const progressPercent = sectionCount > 0
    ? Math.round((Math.min(progressOrder, sectionCount) / sectionCount) * 100)
    : 0
  const archiveBase = `${import.meta.env.BASE_URL}offline/`

  return (
    <section className="story-reader-tools" aria-label={copy.title}>
      <header>
        <div>
          <span>v0.30</span>
          <strong>{copy.title}</strong>
          <small>{copy.localOnly}</small>
        </div>
        <button
          aria-pressed={isBookmarked}
          className={isBookmarked ? 'is-active' : ''}
          type="button"
          onClick={onToggleBookmark}
        >
          <span aria-hidden="true">{isBookmarked ? '★' : '☆'}</span>
          {isBookmarked ? copy.bookmarked : copy.bookmark}
        </button>
      </header>

      <div className="story-reader-progress">
        <div>
          <strong>{copy.progress}</strong>
          <span>{progressOrder} / {sectionCount} {copy.section} · {progressPercent}%</span>
        </div>
        <progress aria-label={copy.progress} max={Math.max(sectionCount, 1)} value={progressOrder} />
      </div>

      <div className="story-reader-tool-grid">
        <fieldset>
          <legend>{copy.settings}</legend>
          <label>
            <span>{copy.fontSize}</span>
            <select
              aria-label={copy.fontSize}
              value={settings.fontScale}
              onChange={(event) => onSettingsChange({ fontScale: Number(event.target.value) })}
            >
              {[90, 100, 115, 130].map((value) => <option key={value} value={value}>{value}%</option>)}
            </select>
          </label>
          <label>
            <span>{copy.lineHeight}</span>
            <select
              aria-label={copy.lineHeight}
              value={settings.lineHeight}
              onChange={(event) => onSettingsChange({ lineHeight: event.target.value })}
            >
              <option value="compact">{copy.compact}</option>
              <option value="comfortable">{copy.comfortable}</option>
              <option value="spacious">{copy.spacious}</option>
            </select>
          </label>
          <label className="story-reader-switch">
            <input
              checked={settings.highContrast}
              type="checkbox"
              onChange={(event) => onSettingsChange({ highContrast: event.target.checked })}
            />
            <span>{copy.contrast}</span>
          </label>
        </fieldset>

        <details>
          <summary>{copy.glossary}<span>{selected.themes.length + linkedEntities.length}</span></summary>
          <div className="story-glossary">
            <strong>{copy.themes}</strong>
            <div className="story-theme-terms">
              {selected.themes.map((theme) => <span key={theme}>{theme}</span>)}
            </div>
            <strong>{copy.people}</strong>
            <ul>
              {linkedEntities.map((entity) => (
                <li key={entity.id}>
                  <div><span>{entity.role}</span><strong>{labelForEntity(entity, language)}</strong></div>
                  <button type="button" onClick={() => onOpenEntity(entity.id)}>{copy.open}</button>
                </li>
              ))}
            </ul>
          </div>
        </details>

        <section className="story-offline-actions">
          <strong>{copy.offline}</strong>
          <p>{copy.offlineNote}</p>
          <div>
            <a download href={`${archiveBase}world-mythology-v0.30-story-archive.html`}>{copy.downloadHtml}</a>
            <a download href={`${archiveBase}world-mythology-v0.30-story-archive.json`}>{copy.downloadJson}</a>
            <button type="button" onClick={() => window.print()}>{copy.print}</button>
          </div>
        </section>
      </div>
    </section>
  )
}
