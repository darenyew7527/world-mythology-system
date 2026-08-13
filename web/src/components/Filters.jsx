import { useMemo, useState } from 'react'
import { FilterIcon } from './Icons.jsx'
import { typeLabel } from '../i18n.js'

export function Filters({
  civilizations,
  civilizationFilter,
  copy,
  language,
  onCivilizationChange,
  onReset,
  onTypeChange,
  typeCounts,
  typeFilter,
}) {
  const [civilizationQuery, setCivilizationQuery] = useState('')
  const topTypes = useMemo(
    () => Object.entries(typeCounts).sort((a, b) => b[1] - a[1]),
    [typeCounts],
  )
  const filteredCivilizations = useMemo(() => {
    const needle = civilizationQuery.trim().toLocaleLowerCase()
    return civilizations
      .filter((item) => item.entityCount > 0)
      .filter((item) => {
        if (!needle) return true
        return `${item.nameZh ?? ''} ${item.canonicalName}`.toLocaleLowerCase().includes(needle)
      })
      .sort((a, b) => b.entityCount - a.entityCount || a.canonicalName.localeCompare(b.canonicalName))
  }, [civilizations, civilizationQuery])

  return (
    <aside className="filter-rail">
      <div className="rail-heading">
        <span><FilterIcon size={18} />{copy.filters}</span>
        <button type="button" onClick={onReset}>{copy.reset}</button>
      </div>

      <section className="filter-section">
        <h2>{copy.category}</h2>
        <div className="filter-options">
          <button
            className={typeFilter === 'ALL' ? 'is-selected' : ''}
            type="button"
            onClick={() => onTypeChange('ALL')}
          >
            <span className="filter-check" />
            <span>{copy.allCategories}</span>
            <b>{Object.values(typeCounts).reduce((sum, value) => sum + value, 0)}</b>
          </button>
          {topTypes.map(([type, count]) => (
            <button
              className={typeFilter === type ? 'is-selected' : ''}
              key={type}
              type="button"
              onClick={() => onTypeChange(type)}
            >
              <span className="filter-check" />
              <span>{typeLabel(type, language)}</span>
              <b>{count}</b>
            </button>
          ))}
        </div>
      </section>

      <section className="filter-section civilization-filter">
        <h2>{copy.civilization}</h2>
        <input
          aria-label={copy.civilization}
          placeholder={language === 'zh' ? '搜索文明与传统' : 'Find a tradition'}
          type="search"
          value={civilizationQuery}
          onChange={(event) => setCivilizationQuery(event.target.value)}
        />
        <div className="filter-options">
          <button
            className={civilizationFilter === 'ALL' ? 'is-selected' : ''}
            type="button"
            onClick={() => onCivilizationChange('ALL')}
          >
            <span className="filter-check" />
            <span>{copy.allCivilizations}</span>
          </button>
          {filteredCivilizations.map((item) => (
            <button
              className={civilizationFilter === item.id ? 'is-selected' : ''}
              key={item.id}
              type="button"
              onClick={() => onCivilizationChange(item.id)}
            >
              <span className="filter-check" />
              <span>{language === 'zh' ? item.nameZh || item.canonicalName : item.canonicalName}</span>
              <b>{item.entityCount}</b>
            </button>
          ))}
        </div>
      </section>
    </aside>
  )
}

export function MobileFilters({
  civilizations,
  civilizationFilter,
  copy,
  language,
  onCivilizationChange,
  onTypeChange,
  typeCounts,
  typeFilter,
}) {
  return (
    <details className="mobile-filters">
      <summary><FilterIcon size={19} />{copy.filters}</summary>
      <div className="mobile-filter-grid">
        <label>
          <span>{copy.category}</span>
          <select value={typeFilter} onChange={(event) => onTypeChange(event.target.value)}>
            <option value="ALL">{copy.allCategories}</option>
            {Object.entries(typeCounts).sort((a, b) => b[1] - a[1]).map(([type, count]) => (
              <option key={type} value={type}>{typeLabel(type, language)} ({count})</option>
            ))}
          </select>
        </label>
        <label>
          <span>{copy.civilization}</span>
          <select value={civilizationFilter} onChange={(event) => onCivilizationChange(event.target.value)}>
            <option value="ALL">{copy.allCivilizations}</option>
            {civilizations.filter((item) => item.entityCount > 0).sort((a, b) => b.entityCount - a.entityCount).map((item) => (
              <option key={item.id} value={item.id}>
                {language === 'zh' ? item.nameZh || item.canonicalName : item.canonicalName} ({item.entityCount})
              </option>
            ))}
          </select>
        </label>
      </div>
    </details>
  )
}
