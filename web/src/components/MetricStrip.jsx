import { DatabaseIcon, GlobeIcon, BookIcon, NetworkIcon } from './Icons.jsx'

export default function MetricStrip({ counts, copy }) {
  const metrics = [
    [counts.registeredEntities, copy.entities, DatabaseIcon],
    [counts.civilizations, copy.traditionsShort, GlobeIcon],
    [counts.sources, copy.sources, BookIcon],
    [counts.directRelationships, copy.relations, NetworkIcon],
  ]

  return (
    <div className="metric-strip" aria-label="Dataset snapshot">
      {metrics.map(([value, label, IconComponent]) => (
        <div className="metric-item" key={label}>
          <IconComponent size={28} />
          <strong>{value}</strong>
          <span>{label}</span>
        </div>
      ))}
    </div>
  )
}
