import { useMemo, useState } from 'react'
import { EntityGlyph } from './Icons.jsx'
import { civilizationDisplay, entityDisplay, entitySecondary, relationLabel, typeLabel } from '../i18n.js'
import RelationshipGraph from './RelationshipGraph.jsx'

const FAMILY_RELATIONS = new Set(['PARENT_OF', 'CHILD_OF', 'SIBLING_OF', 'CONSORT_OF'])

export default function GraphView({ copy, entities, entity, language, onSelect }) {
  const [mode, setMode] = useState('all')
  const [query, setQuery] = useState('')

  const pickerEntities = useMemo(() => {
    const normalized = query.trim().toLocaleLowerCase()
    if (!normalized) return entities.slice(0, 100)
    return entities
      .filter((item) => [item.canonicalName, item.nameZh, item.originalName, item.id]
        .some((value) => value?.toLocaleLowerCase().includes(normalized)))
      .slice(0, 100)
  }, [entities, query])

  const graphEntity = useMemo(() => {
    if (mode !== 'family') return entity
    return {
      ...entity,
      relationships: entity.relationships.filter((relation) => FAMILY_RELATIONS.has(relation.type)),
    }
  }, [entity, mode])

  return (
    <main className="single-view graph-view">
      <aside className="graph-picker">
        <header>
          <h1>{copy.nav.graph}</h1>
          <p>{copy.found(pickerEntities.length)}</p>
          <label className="graph-search">
            <span className="sr-only">{copy.graphSearch}</span>
            <input
              onChange={(event) => setQuery(event.target.value)}
              placeholder={copy.graphSearch}
              type="search"
              value={query}
            />
          </label>
        </header>
        <div className="graph-picker-list">
          {pickerEntities.map((item) => (
            <button className={item.id === entity.id ? 'is-selected' : ''} key={item.id} type="button" onClick={() => onSelect(item.id)}>
              <span><EntityGlyph size={24} type={item.primaryType} /></span>
              <span>
                <strong>{entityDisplay(item, language)} {entitySecondary(item, language) && <em>{entitySecondary(item, language)}</em>}</strong>
                <small>{civilizationDisplay(item, language)} · {typeLabel(item.primaryType, language)}</small>
              </span>
            </button>
          ))}
        </div>
      </aside>
      <section className="full-graph-panel">
        <header>
          <div>
            <span className="detail-glyph"><EntityGlyph size={40} type={entity.primaryType} /></span>
            <div>
              <h2>{entityDisplay(entity, language)} {entitySecondary(entity, language) && <em>{entitySecondary(entity, language)}</em>}</h2>
              <p>{civilizationDisplay(entity, language)} · {graphEntity.relationships.length} {copy.relations}</p>
            </div>
          </div>
          <code>{entity.id}</code>
        </header>
        <div className="graph-mode-toolbar" role="group" aria-label={copy.graphMode}>
          <button aria-pressed={mode === 'all'} className={mode === 'all' ? 'is-active' : ''} onClick={() => setMode('all')} type="button">
            {copy.graphAll}
          </button>
          <button aria-pressed={mode === 'family'} className={mode === 'family' ? 'is-active' : ''} onClick={() => setMode('family')} type="button">
            {copy.graphFamily}
          </button>
          <p>{mode === 'family' ? copy.graphFamilyNote : copy.graphAllNote}</p>
        </div>
        <RelationshipGraph copy={copy} entity={graphEntity} language={language} onSelect={onSelect} />
        {mode === 'family' && graphEntity.relationships.length > 0 && (
          <section className="family-ledger" aria-label={copy.graphFamilyLedger}>
            <header>
              <strong>{copy.graphFamilyLedger}</strong>
              <span>{copy.graphWitnessNote}</span>
            </header>
            <div>
              {graphEntity.relationships.map((relation) => (
                <button key={`${relation.id}-${relation.targetId}`} onClick={() => onSelect(relation.targetId)} type="button">
                  <span>{relationLabel(relation.type, language)}</span>
                  <strong>{language === 'zh' ? relation.targetNameZh || relation.targetName : relation.targetName}</strong>
                  <small>{relation.evidenceCount} {copy.evidence} · {Math.round((relation.confidence || 0) * 100)}%</small>
                </button>
              ))}
            </div>
          </section>
        )}
        <div className="graph-legend">
          <span><i className="legend-line" />{language === 'zh' ? '由 Claim 投影的关系' : 'Claim-projected relation'}</span>
          <span><i className="legend-node" />{language === 'zh' ? '可继续探索的实体' : 'Explorable entity'}</span>
          <span>{language === 'zh' ? '点击外围节点继续探索' : 'Select an outer node to continue'}</span>
        </div>
      </section>
    </main>
  )
}
