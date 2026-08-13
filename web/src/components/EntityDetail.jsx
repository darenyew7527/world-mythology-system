import { useMemo, useState } from 'react'
import { issueUrl } from '../config.js'
import {
  civilizationDisplay,
  entityDisplay,
  entitySecondary,
  relationLabel,
  statusLabel,
  typeLabel,
} from '../i18n.js'
import {
  BookIcon,
  CloseIcon,
  CopyIcon,
  EditIcon,
  EntityGlyph,
  ExternalIcon,
  PlusIcon,
} from './Icons.jsx'
import RelationshipGraph from './RelationshipGraph.jsx'

const locatorText = (evidence) =>
  [
    evidence.sourceLocation,
    evidence.chapter && `chapter ${evidence.chapter}`,
    evidence.verse && `verse ${evidence.verse}`,
    evidence.line && `line ${evidence.line}`,
    evidence.page && `p. ${evidence.page}`,
    evidence.catalogueNumber && `cat. ${evidence.catalogueNumber}`,
  ].filter(Boolean).join(' · ')

function EvidenceCard({ evidence, copy }) {
  return (
    <article className="evidence-card">
      <header>
        <span><BookIcon size={18} />{evidence.evidenceType || 'EVIDENCE'}</span>
        <code>{evidence.sourceId}</code>
      </header>
      <h4>{evidence.sourceTitle}</h4>
      {evidence.institution && <p><strong>{copy.institution}:</strong> {evidence.institution}</p>}
      {locatorText(evidence) && <p><strong>{copy.evidenceLocator}:</strong> {locatorText(evidence)}</p>}
      {evidence.rightsStatus && <p className="rights-note"><strong>{copy.rights}:</strong> {evidence.rightsStatus}</p>}
      {evidence.sourceUrl && (
        <a href={evidence.sourceUrl} rel="noreferrer" target="_blank">
          {copy.openSource}<ExternalIcon size={15} />
        </a>
      )}
    </article>
  )
}

function ClaimCard({ claim, copy, language }) {
  return (
    <article className="claim-card">
      <header>
        <code>{claim.predicate}</code>
        <span className={`review-state review-${(claim.reviewStatus || '').toLocaleLowerCase()}`}>
          {statusLabel(claim.reviewStatus || claim.claimStatus, language)}
        </span>
      </header>
      <p>{claim.statement || claim.objectLiteral || '—'}</p>
      <dl>
        <div><dt>{copy.assertionScope}</dt><dd>{claim.assertionScope || '—'}</dd></div>
        <div><dt>{copy.knowledgeLayer}</dt><dd>{claim.knowledgeLayer || '—'}</dd></div>
        <div><dt>{copy.confidence}</dt><dd>{claim.confidence == null ? '—' : `${Math.round(claim.confidence * 100)}%`}</dd></div>
      </dl>
      {claim.evidence.length > 0 && (
        <div className="claim-evidence-list">
          {claim.evidence.map((evidence) => <EvidenceCard copy={copy} evidence={evidence} key={evidence.id} />)}
        </div>
      )}
    </article>
  )
}

export default function EntityDetail({
  copy,
  entity,
  language,
  mobileOpen,
  onCloseMobile,
  onNavigate,
  onSelect,
}) {
  const [tab, setTab] = useState('overview')
  const [copied, setCopied] = useState(false)

  const evidence = useMemo(() => {
    const seen = new Set()
    return entity.claims.flatMap((claim) => claim.evidence).filter((item) => {
      if (seen.has(item.id)) return false
      seen.add(item.id)
      return true
    })
  }, [entity])

  const sources = useMemo(() => {
    const map = new Map()
    for (const item of evidence) {
      if (!map.has(item.sourceId)) map.set(item.sourceId, item)
    }
    return [...map.values()]
  }, [evidence])

  const copyEntityLink = async () => {
    const url = new URL(window.location.href)
    url.hash = `entity=${encodeURIComponent(entity.id)}`
    try {
      await navigator.clipboard.writeText(url.toString())
      setCopied(true)
      window.setTimeout(() => setCopied(false), 1800)
    } catch {
      window.location.hash = `entity=${encodeURIComponent(entity.id)}`
    }
  }

  const tabs = [
    ['overview', copy.overview],
    ['relations', copy.relations],
    ['evidence', copy.evidence],
    ['sources', copy.sourcePlural],
  ]

  const secondary = entitySecondary(entity, language)
  const feedbackTitle = language === 'zh'
    ? `[资料纠错] ${entityDisplay(entity, language)} (${entity.id})`
    : `[Data correction] ${entityDisplay(entity, language)} (${entity.id})`
  const sourceTitle = language === 'zh'
    ? `[来源建议] ${entityDisplay(entity, language)} (${entity.id})`
    : `[Source suggestion] ${entityDisplay(entity, language)} (${entity.id})`

  return (
    <section className={`entity-detail ${mobileOpen ? 'is-mobile-open' : ''}`}>
      <div className="mobile-sheet-handle" />
      <button aria-label={copy.close} className="mobile-close" type="button" onClick={onCloseMobile}>
        <CloseIcon size={26} />
      </button>

      <header className="detail-heading">
        <span className="detail-glyph"><EntityGlyph size={44} type={entity.primaryType} /></span>
        <div>
          <h1>{entityDisplay(entity, language)} {secondary && <em>{secondary}</em>}</h1>
          <p>{civilizationDisplay(entity, language)} · {typeLabel(entity.primaryType, language)}</p>
          {entity.originalName && <small>{entity.originalName}</small>}
        </div>
        <div className="detail-identity">
          <code>{entity.id}</code>
          <button aria-label={copy.copyLink} title={copy.copyLink} type="button" onClick={copyEntityLink}>
            <CopyIcon size={18} />
          </button>
          {copied && <span className="copy-toast">{copy.copied}</span>}
        </div>
      </header>

      <nav className="detail-tabs" aria-label="Entity details">
        {tabs.map(([key, label]) => (
          <button className={tab === key ? 'is-active' : ''} key={key} type="button" onClick={() => setTab(key)}>
            {label}
            {key === 'relations' && <span>{entity.relationships.length}</span>}
            {key === 'evidence' && <span>{evidence.length}</span>}
            {key === 'sources' && <span>{sources.length}</span>}
          </button>
        ))}
      </nav>

      <div className="detail-scroll">
        {tab === 'overview' && (
          <div className="overview-layout">
            <section className="basic-information">
              <h2>{copy.basicInformation}</h2>
              <dl>
                <div><dt>{copy.originalName}</dt><dd>{entity.originalName || '—'}</dd></div>
                <div><dt>{copy.type}</dt><dd>{entity.types.map((type) => typeLabel(type, language)).join(' · ')}</dd></div>
                <div><dt>{copy.civilization}</dt><dd>{civilizationDisplay(entity, language)}</dd></div>
                <div><dt>{copy.period}</dt><dd>{entity.historicalPeriod || '—'}</dd></div>
                <div><dt>{copy.researchStatus}</dt><dd>{statusLabel(entity.researchStatus, language)}</dd></div>
                <div><dt>{copy.evidenceStatus}</dt><dd>{statusLabel(entity.evidenceStatus, language)}</dd></div>
              </dl>
              <h3>{copy.description}</h3>
              <p>{entity.description || copy.descriptionMissing}</p>
              <h3>{copy.aliases}</h3>
              <div className="alias-list">
                {entity.aliases.length > 0 ? entity.aliases.slice(0, 18).map((alias) => <span key={alias}>{alias}</span>) : '—'}
              </div>
              <div className="contribution-actions">
                <a href={issueUrl('data-correction.yml', feedbackTitle)} rel="noreferrer" target="_blank">
                  <EditIcon size={18} />{copy.submitCorrection}
                </a>
                <a href={issueUrl('source-suggestion.yml', sourceTitle)} rel="noreferrer" target="_blank">
                  <PlusIcon size={18} />{copy.suggestSource}
                </a>
              </div>
            </section>

            <section className="graph-preview-panel">
              <div className="section-heading-line">
                <h2>{copy.relationshipGraph}</h2>
                <button type="button" onClick={() => onNavigate('graph')}>{copy.viewFullGraph}</button>
              </div>
              <RelationshipGraph compact copy={copy} entity={entity} language={language} onSelect={onSelect} />
            </section>

            <section className="overview-claims">
              <div className="section-heading-line"><h2>{copy.claims}</h2><span>{entity.claims.length}</span></div>
              {entity.claims.length === 0 ? <div className="empty-state">{copy.noClaims}</div> : (
                <div className="claim-grid">
                  {entity.claims.slice(0, 4).map((claim) => (
                    <ClaimCard claim={claim} copy={copy} key={claim.id} language={language} />
                  ))}
                </div>
              )}
            </section>
          </div>
        )}

        {tab === 'relations' && (
          <div className="relations-tab">
            <RelationshipGraph copy={copy} entity={entity} language={language} onSelect={onSelect} />
            <div className="relations-table" role="table">
              <div className="relations-table-head" role="row">
                <span>{copy.relations}</span><span>{copy.relationTarget}</span><span>{copy.review}</span><span>{copy.confidence}</span>
              </div>
              {entity.relationships.map((relation, index) => (
                <button
                  className="relation-row"
                  key={`${relation.claimId}-${relation.type}-${relation.targetId}-${index}`}
                  role="row"
                  type="button"
                  onClick={() => onSelect(relation.targetId)}
                >
                  <span><code>{relationLabel(relation.type, language)}</code></span>
                  <span>{language === 'zh' ? relation.targetNameZh || relation.targetName : relation.targetName}</span>
                  <span>{statusLabel(relation.reviewStatus || relation.certainty, language)}</span>
                  <span>{relation.confidence == null ? '—' : `${Math.round(relation.confidence * 100)}%`}</span>
                </button>
              ))}
            </div>
          </div>
        )}

        {tab === 'evidence' && (
          <div className="evidence-tab">
            <div className="tab-introduction">
              <h2>{copy.claims}</h2>
              <p>{copy.evidenceIntro}</p>
              <small>{copy.publicPolicy}</small>
            </div>
            {entity.claims.length === 0 ? <div className="empty-state">{copy.noClaims}</div> : entity.claims.map((claim) => (
              <ClaimCard claim={claim} copy={copy} key={claim.id} language={language} />
            ))}
          </div>
        )}

        {tab === 'sources' && (
          <div className="sources-tab">
            <div className="tab-introduction">
              <h2>{copy.sourcePlural}</h2>
              <p>{copy.publicPolicy}</p>
            </div>
            {sources.length === 0 ? <div className="empty-state">{copy.noEvidence}</div> : (
              <div className="source-grid">
                {sources.map((source) => <EvidenceCard copy={copy} evidence={source} key={source.sourceId} />)}
              </div>
            )}
          </div>
        )}
      </div>
    </section>
  )
}
