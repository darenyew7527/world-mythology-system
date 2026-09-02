export const READER_STORAGE_KEY = 'wms-reader-v029'

export const DEFAULT_READER_STATE = Object.freeze({
  schemaVersion: 1,
  bookmarks: [],
  progress: {},
  settings: {
    fontScale: 100,
    lineHeight: 'comfortable',
    highContrast: false,
  },
})

const allowedFontScales = new Set([90, 100, 115, 130])
const allowedLineHeights = new Set(['compact', 'comfortable', 'spacious'])

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
    window.localStorage.setItem(READER_STORAGE_KEY, JSON.stringify(normalizeReaderState(state)))
  } catch {
    // Reading remains available if storage is blocked or full.
  }
}
