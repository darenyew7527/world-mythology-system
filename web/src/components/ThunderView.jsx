import { useMemo } from 'react'
import { EntityGlyph, ThunderIcon } from './Icons.jsx'

const displayName = (entity, language) => {
  if (!entity) return ''
  return language === 'zh' ? (entity.nameZh || entity.canonicalName) : entity.canonicalName
}

const civilizationName = (entity, language) => {
  if (!entity) return ''
  return language === 'zh'
    ? (entity.civilizationNameZh || entity.civilizationName || '')
    : (entity.civilizationName || entity.civilizationNameZh || '')
}

export default function ThunderView({ comparisons, copy, entities, language, onOpenEntity }) {
  const entityById = useMemo(
    () => new Map(entities.map((entity) => [entity.id, entity])),
    [entities],
  )
  const comparison = comparisons.find((item) => item.id === 'comparison.thunder_storm_deities')
    || comparisons[0]

  if (!comparison) {
    return <main className="single-view thunder-view"><p>{copy.thunderUnavailable}</p></main>
  }

  const description = language === 'zh' ? comparison.descriptionZh : comparison.descriptionEn
  const methodology = language === 'zh' ? comparison.methodologyZh : comparison.methodologyEn
  const members = comparison.members
    .map((member) => ({ ...member, entity: entityById.get(member.entityId) }))
    .filter((member) => member.entity)

  return (
    <main className="single-view thunder-view">
      <header className="thunder-hero">
        <span className="thunder-mark"><ThunderIcon size={54} /></span>
        <div>
          <h1>{language === 'zh' ? comparison.nameZh : comparison.canonicalName}</h1>
          <p>{description}</p>
        </div>
        <aside>
          <strong>{copy.comparisonMethod}</strong>
          <span>{methodology}</span>
        </aside>
      </header>

      <section className="thor-correction" aria-label={copy.thorCorrectionTitle}>
        <strong>{copy.thorCorrectionTitle}</strong>
        <p>{copy.thorCorrectionBody}</p>
        <div>
          {[
            'deity.norse.thor',
            'deity.norse.loki',
            'deity.norse.hel',
            'deity.norse.sif',
            'deity.norse.thrud',
            'modern.marvel.mcu.loki',
            'modern.marvel.mcu.hela',
          ].map((id) => {
            const entity = entityById.get(id)
            if (!entity) return null
            return (
              <button key={id} type="button" onClick={() => onOpenEntity(id)}>
                {displayName(entity, language)}
              </button>
            )
          })}
        </div>
      </section>

      <section className="thunder-comparison" aria-label={copy.thunderComparisonTable}>
        <header>
          <span>{copy.traditionAndDeity}</span>
          <span>{copy.nativeScope}</span>
          <span>{copy.comparisonBoundary}</span>
          <span>{copy.evidence}</span>
        </header>
        {members.map((member) => {
          const scope = language === 'zh' ? member.nativeScopeZh : member.nativeScopeEn
          const distinction = language === 'zh' ? member.distinctionZh : member.distinctionEn
          return (
            <button
              className="thunder-row"
              key={member.entityId}
              type="button"
              onClick={() => onOpenEntity(member.entityId)}
            >
              <span className="thunder-identity">
                <i><EntityGlyph size={31} type={member.entity.primaryType} /></i>
                <b>{displayName(member.entity, language)} <em>{member.entity.canonicalName}</em></b>
                <small>{civilizationName(member.entity, language)} · {member.entity.originalName || copy.originalNameUnknown}</small>
              </span>
              <span data-label={copy.nativeScope}>{scope}</span>
              <span data-label={copy.comparisonBoundary}>{distinction}</span>
              <span className="thunder-evidence" data-label={copy.evidence}>
                <b>{member.evidenceCount}</b>
                <small>{copy.locatedEvidence}</small>
              </span>
            </button>
          )
        })}
      </section>

      <section className="comparison-boundaries">
        <h2>{copy.comparisonBoundariesTitle}</h2>
        <p>{copy.comparisonBoundariesBody}</p>
        <dl>
          {copy.comparisonBoundaryItems.map(([term, meaning]) => (
            <div key={term}><dt>{term}</dt><dd>{meaning}</dd></div>
          ))}
        </dl>
      </section>
    </main>
  )
}
