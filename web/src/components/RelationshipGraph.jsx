import { entityDisplay, relationTargetLabel } from '../i18n.js'
import { graphLayout, mobileTextPlacement, nodePosition } from '../graphLayout.js'

const truncate = (value, length = 13) => {
  if (!value) return ''
  return value.length > length ? `${value.slice(0, length - 1)}…` : value
}

function GraphSvg({ compact, copy, entity, kind, language, onSelect, relations }) {
  const layout = graphLayout(compact, kind)
  const glowId = `nodeGlow-${kind}-${compact ? 'compact' : 'full'}`
  const fieldId = `graphField-${kind}-${compact ? 'compact' : 'full'}`

  return (
    <svg
      className={`graph-svg-${kind}`}
      data-graph-layout={kind}
      preserveAspectRatio="xMidYMid meet"
      role="img"
      aria-label={`${entityDisplay(entity, language)} ${copy.relationshipGraph}`}
      viewBox={`0 0 ${layout.width} ${layout.height}`}
    >
      <defs>
        <filter id={glowId} x="-80%" y="-80%" width="260%" height="260%">
          <feGaussianBlur stdDeviation="4" result="blur" />
          <feMerge><feMergeNode in="blur" /><feMergeNode in="SourceGraphic" /></feMerge>
        </filter>
        <radialGradient id={fieldId} cx="50%" cy="50%" r="55%">
          <stop offset="0" stopColor="#0c2e49" stopOpacity=".6" />
          <stop offset="1" stopColor="#03101b" stopOpacity="0" />
        </radialGradient>
      </defs>
      <ellipse
        cx={layout.centerX}
        cy={layout.centerY}
        fill={`url(#${fieldId})`}
        rx={layout.radiusX + (kind === 'mobile' ? 28 : 48)}
        ry={layout.radiusY + 32}
      />
      <circle className="graph-orbit" cx={layout.centerX} cy={layout.centerY} r={layout.orbitInner} />
      <circle className="graph-orbit graph-orbit-outer" cx={layout.centerX} cy={layout.centerY} r={layout.orbitOuter} />
      {relations.map((relation, index) => {
        const { x, y } = nodePosition(index, relations.length, layout)
        return (
          <g className="relation-edge" key={`${relation.claimId}-${relation.type}-${relation.targetId}-${index}`}>
            <line x1={layout.centerX} y1={layout.centerY} x2={x} y2={y} />
            <text className="edge-label" x={(layout.centerX + x) / 2} y={(layout.centerY + y) / 2 - 7}>
              {truncate(relationTargetLabel(relation.type, language), 10)}
            </text>
          </g>
        )
      })}
      <g className="center-node" filter={`url(#${glowId})`}>
        <circle cx={layout.centerX} cy={layout.centerY} r={layout.centerRadius} />
        <text className="node-title" textAnchor="middle" x={layout.centerX} y={layout.centerY - 2}>
          {truncate(entityDisplay(entity, language), 10)}
        </text>
        <text className="node-subtitle" textAnchor="middle" x={layout.centerX} y={layout.centerY + 20}>
          {truncate(language === 'zh' ? entity.canonicalName : entity.nameZh, 12)}
        </text>
      </g>
      {relations.map((relation, index) => {
        const { x, y } = nodePosition(index, relations.length, layout)
        const label = language === 'zh' ? relation.targetNameZh || relation.targetName : relation.targetName
        const { textAnchor, textX } = mobileTextPlacement(x, layout)
        const titleY = layout.targetRadius + (compact ? 18 : 19)
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
            <circle r={layout.targetRadius} />
            <circle className="node-core" r={kind === 'mobile' ? 5 : 6} />
            <text className="target-title" textAnchor={textAnchor} x={textX} y={titleY}>
              {truncate(label, compact ? 10 : 15)}
            </text>
            {!compact && (
              <text className="target-relation" textAnchor={textAnchor} x={textX} y={titleY + 17}>
                {truncate(relationTargetLabel(relation.type, language), 12)}
              </text>
            )}
          </g>
        )
      })}
    </svg>
  )
}

export default function RelationshipGraph({ compact = false, entity, language, onSelect, copy }) {
  const relations = entity.relationships.slice(0, compact ? 8 : 14)

  if (relations.length === 0) return <div className="graph-empty">{copy.noRelations}</div>

  return (
    <div className={`relationship-graph ${compact ? 'is-compact' : ''}`}>
      <GraphSvg compact={compact} copy={copy} entity={entity} kind="desktop" language={language} onSelect={onSelect} relations={relations} />
      <GraphSvg compact={compact} copy={copy} entity={entity} kind="mobile" language={language} onSelect={onSelect} relations={relations} />
    </div>
  )
}
