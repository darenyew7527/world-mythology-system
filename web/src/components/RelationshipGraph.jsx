import { entityDisplay, relationLabel } from '../i18n.js'

const truncate = (value, length = 13) => {
  if (!value) return ''
  return value.length > length ? `${value.slice(0, length - 1)}…` : value
}

export default function RelationshipGraph({ compact = false, entity, language, onSelect, copy }) {
  const relations = entity.relationships.slice(0, compact ? 8 : 14)
  const width = 760
  const height = compact ? 390 : 520
  const centerX = width / 2
  const centerY = height / 2
  const radiusX = compact ? 245 : 270
  const radiusY = compact ? 145 : 200

  if (relations.length === 0) return <div className="graph-empty">{copy.noRelations}</div>

  return (
    <div className={`relationship-graph ${compact ? 'is-compact' : ''}`}>
      <svg role="img" aria-label={`${entityDisplay(entity, language)} ${copy.relationshipGraph}`} viewBox={`0 0 ${width} ${height}`}>
        <defs>
          <filter id="nodeGlow" x="-80%" y="-80%" width="260%" height="260%">
            <feGaussianBlur stdDeviation="4" result="blur" />
            <feMerge><feMergeNode in="blur" /><feMergeNode in="SourceGraphic" /></feMerge>
          </filter>
          <radialGradient id="graphField" cx="50%" cy="50%" r="55%">
            <stop offset="0" stopColor="#0c2e49" stopOpacity=".6" />
            <stop offset="1" stopColor="#03101b" stopOpacity="0" />
          </radialGradient>
        </defs>
        <ellipse cx={centerX} cy={centerY} fill="url(#graphField)" rx={radiusX + 48} ry={radiusY + 32} />
        <circle className="graph-orbit" cx={centerX} cy={centerY} r={compact ? 104 : 136} />
        <circle className="graph-orbit graph-orbit-outer" cx={centerX} cy={centerY} r={compact ? 160 : 214} />
        {relations.map((relation, index) => {
          const angle = (index / relations.length) * Math.PI * 2 - Math.PI / 2
          const x = centerX + Math.cos(angle) * radiusX
          const y = centerY + Math.sin(angle) * radiusY
          const label = language === 'zh' ? relation.targetNameZh || relation.targetName : relation.targetName
          return (
            <g className="relation-edge" key={`${relation.claimId}-${relation.type}-${relation.targetId}-${index}`}>
              <line x1={centerX} y1={centerY} x2={x} y2={y} />
              <text className="edge-label" x={(centerX + x) / 2} y={(centerY + y) / 2 - 7}>
                {truncate(relationLabel(relation.type, language), 10)}
              </text>
            </g>
          )
        })}
        <g className="center-node" filter="url(#nodeGlow)">
          <circle cx={centerX} cy={centerY} r={compact ? 49 : 60} />
          <text className="node-title" textAnchor="middle" x={centerX} y={centerY - 2}>
            {truncate(entityDisplay(entity, language), 10)}
          </text>
          <text className="node-subtitle" textAnchor="middle" x={centerX} y={centerY + 20}>
            {truncate(language === 'zh' ? entity.canonicalName : entity.nameZh, 12)}
          </text>
        </g>
        {relations.map((relation, index) => {
          const angle = (index / relations.length) * Math.PI * 2 - Math.PI / 2
          const x = centerX + Math.cos(angle) * radiusX
          const y = centerY + Math.sin(angle) * radiusY
          const label = language === 'zh' ? relation.targetNameZh || relation.targetName : relation.targetName
          return (
            <g
              className="target-node"
              key={`${relation.id}-${relation.targetId}-${index}`}
              role="button"
              tabIndex="0"
              transform={`translate(${x} ${y})`}
              onClick={() => onSelect?.(relation.targetId)}
              onKeyDown={(event) => {
                if (event.key === 'Enter' || event.key === ' ') onSelect?.(relation.targetId)
              }}
            >
              <circle r={compact ? 28 : 34} />
              <circle className="node-core" r="6" />
              <text className="target-title" textAnchor="middle" y={compact ? 46 : 53}>{truncate(label, compact ? 10 : 15)}</text>
              {!compact && <text className="target-relation" textAnchor="middle" y="70">{truncate(relationLabel(relation.type, language), 12)}</text>}
            </g>
          )
        })}
      </svg>
    </div>
  )
}
