import { AlertIcon, DatabaseIcon } from './Icons.jsx'
import { statusLabel, typeLabel } from '../i18n.js'

function StatusBars({ language, values }) {
  const total = Object.values(values).reduce((sum, value) => sum + value, 0) || 1
  return (
    <div className="status-bars">
      {Object.entries(values).sort((a, b) => b[1] - a[1]).map(([status, count]) => (
        <div className="status-bar-row" key={status}>
          <span>{statusLabel(status, language)}</span>
          <div><i style={{ width: `${Math.max(2, (count / total) * 100)}%` }} /></div>
          <strong>{count}</strong>
        </div>
      ))}
    </div>
  )
}

export default function ProgressView({ copy, language, meta, queue }) {
  const counts = meta.counts
  const summary = [
    [counts.canonicalEntities, copy.canonicalEntities],
    [counts.claims, copy.claimsCount],
    [counts.evidence, copy.evidenceCount],
    [counts.conflicts, copy.conflicts],
  ]

  return (
    <main className="single-view progress-view">
      <header className="view-title">
        <div>
          <h1>{copy.progressTitle}</h1>
          <p>{copy.stagedBaseline}</p>
          <small>{copy.notComplete}</small>
        </div>
        <div className="release-label">
          <DatabaseIcon size={22} />
          <span>{meta.projectVersion}</span>
          <small>{meta.datasetRelease.data_version}</small>
        </div>
      </header>

      <section className="progress-summary">
        {summary.map(([value, label]) => <div key={label}><strong>{value}</strong><span>{label}</span></div>)}
      </section>

      <div className="progress-columns">
        <section className="progress-panel">
          <h2>{copy.evidenceCoverage}</h2>
          <StatusBars language={language} values={meta.evidenceStatusCounts} />
        </section>
        <section className="progress-panel">
          <h2>{copy.researchCoverage}</h2>
          <StatusBars language={language} values={meta.researchStatusCounts} />
        </section>
      </div>

      <section className="queue-panel">
        <div className="section-heading-line">
          <h2>{copy.queue}</h2>
          <span>{queue.length}</span>
        </div>
        <div className="queue-table">
          <div className="queue-head"><span>{language === 'zh' ? '研究目标' : 'Research target'}</span><span>{copy.type}</span><span>{copy.researchStatus}</span><span>{copy.priority}</span><span>{copy.nextAction}</span></div>
          {queue.slice(0, 18).map((item) => (
            <div className="queue-row" key={item.id}>
              <strong>{item.target_label}</strong>
              <span>{item.proposed_entity_type ? typeLabel(item.proposed_entity_type, language) : '—'}</span>
              <span>{statusLabel(item.status, language)}</span>
              <span>{item.priority}</span>
              <small>{item.next_action || '—'}</small>
            </div>
          ))}
        </div>
      </section>

      <aside className="baseline-notice">
        <AlertIcon size={24} />
        <p><strong>{copy.stagedBaseline}</strong><span>{copy.notComplete}</span></p>
      </aside>
    </main>
  )
}
