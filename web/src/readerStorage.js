export const READER_STORAGE_KEY = 'wms-reader-v029'

export const DEFAULT_READER_STATE = Object.freeze({
  schemaVersion: 1,
  bookmarks: [],
  progress: {},
  settings: {
    fontScale: 100,
    lineHeight: 'comfortable',
    highContrast: false,
    tellerScale: 100,
    tellerNotes: true,
  },
})

const allowedFontScales = new Set([90, 100, 115, 130])
const allowedLineHeights = new Set(['compact', 'comfortable', 'spacious'])
export const TELLER_SCALES = [85, 100, 120, 140, 165]
const allowedTellerScales = new Set(TELLER_SCALES)

export const normalizeReaderState = (value) => {
  const candidate = value && typeof value === 'object' ? value : {}
  const settings = candidate.settings && typeof candidate.settings === 'object'
    ? candidate.settings
    : {}

  return {
    schemaVersion: 1,
    bookmarks: Array.isArray(candidate.bookmarks)
      ? [...new Set(candidate.bookmarks.filter((item) => typeof item === 'string'))]
      : [],
    progress: candidate.progress && typeof candidate.progress === 'object'
      ? candidate.progress
      : {},
    settings: {
      fontScale: allowedFontScales.has(Number(settings.fontScale))
        ? Number(settings.fontScale)
        : DEFAULT_READER_STATE.settings.fontScale,
      lineHeight: allowedLineHeights.has(settings.lineHeight)
        ? settings.lineHeight
        : DEFAULT_READER_STATE.settings.lineHeight,
      highContrast: Boolean(settings.highContrast),
      tellerScale: allowedTellerScales.has(Number(settings.tellerScale))
        ? Number(settings.tellerScale)
        : DEFAULT_READER_STATE.settings.tellerScale,
      tellerNotes: settings.tellerNotes === undefined
        ? DEFAULT_READER_STATE.settings.tellerNotes
        : Boolean(settings.tellerNotes),
    },
  }
}

export const loadReaderState = () => {
  if (typeof window === 'undefined') return normalizeReaderState(DEFAULT_READER_STATE)
  try {
    const stored = window.localStorage.getItem(READER_STORAGE_KEY)
    return normalizeReaderState(stored ? JSON.parse(stored) : DEFAULT_READER_STATE)
  } catch {
    return normalizeReaderState(DEFAULT_READER_STATE)
  }
}

export const saveReaderState = (state) => {
  if (typeof window === 'undefined') return
  try {
    // Storyteller preferences are owned by storyteller mode; keep whatever it stored.
    const stored = loadReaderState()
    const next = normalizeReaderState(state)
    next.settings.tellerScale = stored.settings.tellerScale
    next.settings.tellerNotes = stored.settings.tellerNotes
    window.localStorage.setItem(READER_STORAGE_KEY, JSON.stringify(next))
  } catch {
    // Reading remains available if storage is blocked or full.
  }
}

export const saveTellerSettings = (partial) => {
  if (typeof window === 'undefined') return
  try {
    const stored = loadReaderState()
    const next = normalizeReaderState({ ...stored, settings: { ...stored.settings, ...partial } })
    window.localStorage.setItem(READER_STORAGE_KEY, JSON.stringify(next))
  } catch {
    // Preferences simply reset next time if storage is unavailable.
  }
}
