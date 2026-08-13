import { ChevronIcon, EntityGlyph } from './Icons.jsx'
import {
  civilizationDisplay,
  entityDisplay,
  entitySecondary,
  statusLabel,
  typeLabel,
} from '../i18n.js'

export default function EntityList({ copy, entities, language, onSelect, selectedId }) {
  return (
    <section className="entity-results" aria-label={copy.entities}>
      <div className="results-heading">
        <span>{copy.found(entities.length)}</span>
        <span>{copy.sortEvidence}</span>
      </div>
      <div className="entity-list" role="listbox" aria-label={copy.entities}>
        {entities.length === 0 && <div className="empty-state">{copy.noResults}</div>}
        {entities.map((entity) => (
          <button
            aria-selected={selectedId === entity.id}
            className={`entity-row ${selectedId === entity.id ? 'is-selected' : ''}`}
            key={entity.id}
            role="option"
            type="button"
            onClick={() => onSelect(entity.id)}
          >
            <span className="entity-glyph"><EntityGlyph size={34} type={entity.primaryType} /></span>
            <span className="entity-row-copy">
              <strong>
                {entityDisplay(entity, language)}
                {entitySecondary(entity, language) && <em>{entitySecondary(entity, language)}</em>}
              </strong>
              <span>{civilizationDisplay(entity, language)} · {typeLabel(entity.primaryType, language)}</span>
              <small className={`status-dot status-${entity.evidenceStatus.toLocaleLowerCase()}`}>
                {statusLabel(entity.evidenceStatus, language)}
              </small>
            </span>
            <ChevronIcon className="row-chevron" size={18} />
          </button>
        ))}
      </div>
    </section>
  )
}
