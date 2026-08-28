import { useMemo, useState } from 'react'
import { BookIcon, ExternalIcon, SearchIcon } from './Icons.jsx'
import { statusLabel } from '../i18n.js'

const locatorText = (evidence) =>
  [evidence.sourceLocation, evidence.chapter, evidence.verse, evidence.line, evidence.page, evidence.catalogueNumber]
    .filter(Boolean)
    .join(' · ')

export default function EvidenceView({ claims, copy, language }) {
  const [query, setQuery] = useState('')
  const [scope, setScope] = useState('ALL')
  const [layer, setLayer] = useState('ALL')
  const [review, setReview] = useState('ALL')
  const [evidenceType, setEvidenceType] = useState('ALL')
  const scopes = useMemo(() => [...new Set(claims.map((claim) => claim.assertionScope).filter(Boolean))].sort(), [claims])
  const layers = useMemo(() => [...new Set(claims.map((claim) => claim.knowledgeLayer).filter(Boolean))].sort(), [claims])
  const reviews = useMemo(() => [...new Set(claims.map((claim) => claim.reviewStatus).filter(Boolean))].sort(), [claims])
  const evidenceTypes = useMemo(() => [...new Set(claims.flatMap((claim) => claim.evidence.map((item) => item.evidenceType)).filter(Boolean))].sort(), [claims])
  const filtered = useMemo(() => {
    const needle = query.trim().toLocaleLowerCase()
    return claims.filter((claim) => {
      if (scope !== 'ALL' && claim.assertionScope !== scope) return false
      if (layer !== 'ALL' && claim.knowledgeLayer !== layer) return false
      if (review !== 'ALL' && claim.reviewStatus !== review) return false
      if (evidenceType !== 'ALL' && !claim.evidence.some((item) => item.evidenceType === evidenceType)) return false
      if (!needle) return true
      const evidenceText = claim.evidence.map((item) => `${item.sourceTitle} ${item.institution || ''} ${item.sourceId}`).join(' ')
      return `${claim.id} ${claim.predicate} ${claim.statement || ''} ${evidenceText}`.toLocaleLowerCase().includes(needle)
    })
  }, [claims, evidenceType, layer, query, review, scope])

  return (
    <main className="single-view evidence-view">
      <header className="view-title">
        <div>
          <h1>{copy.allEvidence}</h1>
          <p>{copy.evidenceIntro}</p>
          <small>{copy.publicPolicy}</small>
        </div>
        <div className="view-count"><strong>{filtered.length}</strong><span>{copy.claims}</span></div>
      </header>

      <div className="evidence-toolbar is-layered">
        <label className="search-box compact-search">
          <SearchIcon size={20} />
          <input
            aria-label={copy.searchPlaceholder}
            placeholder={language === 'zh' ? '搜索 Claim、来源或机构…' : 'Search claims, sources, or institutions…'}
            type="search"
            value={query}
            onChange={(event) => setQuery(event.target.value)}
          />
        </label>
        <select aria-label={copy.assertionScope} value={scope} onChange={(event) => setScope(event.target.value)}>
          <option value="ALL">{language === 'zh' ? '全部说法范围' : 'All assertion scopes'}</option>
          {scopes.map((item) => <option key={item} value={item}>{item}</option>)}
        </select>
        <select aria-label={copy.knowledgeLayer} value={layer} onChange={(event) => setLayer(event.target.value)}>
          <option value="ALL">{language === 'zh' ? '全部知识层' : 'All knowledge layers'}</option>
          {layers.map((item) => <option key={item} value={item}>{item}</option>)}
        </select>
        <select aria-label={copy.review} value={review} onChange={(event) => setReview(event.target.value)}>
          <option value="ALL">{language === 'zh' ? '全部审核状态' : 'All review states'}</option>
          {reviews.map((item) => <option key={item} value={item}>{statusLabel(item, language)}</option>)}
        </select>
        <select aria-label={language === 'zh' ? '证据类型' : 'Evidence type'} value={evidenceType} onChange={(event) => setEvidenceType(event.target.value)}>
          <option value="ALL">{language === 'zh' ? '全部证据类型' : 'All evidence types'}</option>
          {evidenceTypes.map((item) => <option key={item} value={item}>{item}</option>)}
        </select>
      </div>

      <div className="evidence-ledger">
        {filtered.length === 0 && <div className="empty-state">{copy.noResults}</div>}
        {filtered.slice(0, 160).map((claim) => (
          <article className="ledger-row" key={claim.id}>
            <header>
              <code>{claim.id}</code>
              <span>{claim.predicate}</span>
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
            <div className="ledger-evidence">
              {claim.evidence.length === 0 && <span className="no-evidence-label">{copy.noEvidence}</span>}
              {claim.evidence.map((item) => (
                <div key={item.id}>
                  <BookIcon size={18} />
                  <span>
                    <strong>{item.sourceTitle}</strong>
                    <small>{item.evidenceType}{locatorText(item) ? ` · ${locatorText(item)}` : ''}</small>
                  </span>
                  {item.sourceUrl && <a aria-label={copy.openSource} href={item.sourceUrl} rel="noreferrer" target="_blank"><ExternalIcon size={17} /></a>}
                </div>
              ))}
            </div>
          </article>
        ))}
      </div>
    </main>
  )
}
