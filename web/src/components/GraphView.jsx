import { EntityGlyph } from './Icons.jsx'
import { civilizationDisplay, entityDisplay, entitySecondary, typeLabel } from '../i18n.js'
import RelationshipGraph from './RelationshipGraph.jsx'

export default function GraphView({ copy, entities, entity, language, onSelect }) {
  return (
    <main className="single-view graph-view">
      <aside className="graph-picker">
        <header>
          <h1>{copy.nav.graph}</h1>
          <p>{copy.found(entities.length)}</p>
        </header>
        <div className="graph-picker-list">
          {entities.slice(0, 100).map((item) => (
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
              <p>{civilizationDisplay(entity, language)} · {entity.relationships.length} {copy.relations}</p>
            </div>
          </div>
          <code>{entity.id}</code>
        </header>
        <RelationshipGraph copy={copy} entity={entity} language={language} onSelect={onSelect} />
        <div className="graph-legend">
          <span><i className="legend-line" />{language === 'zh' ? '由 Claim 投影的关系' : 'Claim-projected relation'}</span>
          <span><i className="legend-node" />{language === 'zh' ? '可继续探索的实体' : 'Explorable entity'}</span>
          <span>{language === 'zh' ? '点击外围节点继续探索' : 'Select an outer node to continue'}</span>
        </div>
      </section>
    </main>
  )
}
