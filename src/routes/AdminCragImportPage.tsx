import { Fragment, useRef, useState } from 'react'
import {
  CRAG_ALL_FIELDS, CRAG_REQUIRED_FIELDS,
  type CragColumnMap, type CragField, type CragGroup, type CragImportReport,
  type CragWizardStep, type ParsedCragRow, type RawCragRow,
} from '../features/crag-import/types'
import {
  CRAG_FIELD_LABELS, autoDetectCragColumns, parseCragFile, parseCragRow,
} from '../features/crag-import/parse'
import { useExecuteCragImport, useRegions, useResolveCragImport } from '../features/crag-import/hooks'
import { geocodeCragCandidates, type GeoCandidate } from '../features/crag-import/geocode'
import { normalizeKey } from '../features/logbook-import/normalize'
import '../styles/admin.css'
import '../styles/import.css'

const STEPS: { key: CragWizardStep; label: string }[] = [
  { key: 'upload', label: 'Carica' },
  { key: 'mapping', label: 'Colonne' },
  { key: 'confirm', label: 'Regione & conferma' },
  { key: 'done', label: 'Report' },
]

function StepBar({ current }: { current: CragWizardStep }) {
  const idx = STEPS.findIndex(s => s.key === current)
  return (
    <div className="import-steps">
      {STEPS.map((s, i) => (
        <Fragment key={s.key}>
          <div className={`import-step-item ${i < idx ? 'done' : i === idx ? 'active' : ''}`}>
            <span className="import-step-num">{i < idx ? '✓' : i + 1}</span><span>{s.label}</span>
          </div>
          {i < STEPS.length - 1 && <span className="import-step-sep" />}
        </Fragment>
      ))}
    </div>
  )
}

// ── Confirm: regione per falesia + riepilogo ────────────────────────────────
function CragRow({
  group, regions, onChange,
}: {
  group: CragGroup
  regions: { id: string; name: string }[]
  onChange: (g: CragGroup) => void
}) {
  const [geoLoading, setGeoLoading] = useState(false)
  const [candidates, setCandidates] = useState<GeoCandidate[] | null>(null)
  const regionByNorm = new Map(regions.map(r => [normalizeKey(r.name), r.id]))

  function applyCandidate(c: GeoCandidate) {
    const rid = c.region ? regionByNorm.get(normalizeKey(c.region)) ?? null : group.region_id
    onChange({
      ...group,
      region: c.region ?? group.region,
      region_id: rid,
      province: c.province ?? group.province,
      municipality: c.municipality ?? group.municipality,
      geoSource: 'auto',
    })
  }

  async function autoGeo() {
    setGeoLoading(true)
    const list = await geocodeCragCandidates(group.crag_name)
    setGeoLoading(false)
    setCandidates(list)
    if (list.length === 1) applyCandidate(list[0])
  }

  const needsRegion = !group.existingCragId && !group.region_id

  return (
    <tr className={needsRegion ? 'row-error' : ''}>
      <td style={{ fontWeight: 600 }}>
        {group.crag_name}
        <div style={{ fontSize: 11, color: 'var(--text-muted)' }}>
          {group.existingCragId ? '≈ esiste (merge)' : '✦ nuova'}
          {' · '}{group.sectors.filter(s => !s.existing).length} settori nuovi
          {' · '}{group.routesNew} vie nuove{group.routesExisting > 0 ? `, ${group.routesExisting} già presenti` : ''}
        </div>
      </td>
      <td>
        <select
          className="mapping-select"
          value={group.region_id ?? ''}
          onChange={e => onChange({ ...group, region_id: e.target.value || null, geoSource: 'manual' })}
        >
          <option value="">— scegli regione —</option>
          {regions.map(r => <option key={r.id} value={r.id}>{r.name}</option>)}
        </select>
      </td>
      <td>
        <input
          className="mapping-select" style={{ minWidth: 120 }}
          placeholder="provincia" value={group.province}
          onChange={e => onChange({ ...group, province: e.target.value })}
        />
      </td>
      <td>
        <button className="btn-secondary" style={{ padding: '5px 10px', fontSize: 12 }} onClick={autoGeo} disabled={geoLoading}>
          {geoLoading ? '…' : '🔍 Auto'}
        </button>
        {candidates && candidates.length > 1 && (
          <select
            className="mapping-select" style={{ minWidth: 160, marginTop: 6, display: 'block' }}
            defaultValue=""
            onChange={e => { const c = candidates[Number(e.target.value)]; if (c) applyCandidate(c) }}
          >
            <option value="">— scegli risultato ({candidates.length}) —</option>
            {candidates.map((c, i) => <option key={i} value={i}>{c.label}</option>)}
          </select>
        )}
        {candidates && candidates.length === 0 && (
          <div style={{ fontSize: 11, color: 'var(--text-muted)', marginTop: 4 }}>Nessun risultato, scegli a mano</div>
        )}
      </td>
    </tr>
  )
}

// ── Main ────────────────────────────────────────────────────────────────────
export default function AdminCragImportPage() {
  const [step, setStep] = useState<CragWizardStep>('upload')
  const [headers, setHeaders] = useState<string[]>([])
  const [rawRows, setRawRows] = useState<RawCragRow[]>([])
  const [map, setMap] = useState<CragColumnMap>({})
  const [groups, setGroups] = useState<CragGroup[]>([])
  const [report, setReport] = useState<CragImportReport | null>(null)
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const inputRef = useRef<HTMLInputElement>(null)
  const { data: regions = [] } = useRegions()
  const resolve = useResolveCragImport()
  const execute = useExecuteCragImport()

  async function handleFile(file: File) {
    setError(''); setLoading(true)
    try {
      const { headers: h, rows } = await parseCragFile(file)
      const m = autoDetectCragColumns(h)
      setHeaders(h); setRawRows(rows); setMap(m)
      if (CRAG_REQUIRED_FIELDS.every(f => !!m[f])) {
        await doResolve(rows, m)
      } else {
        setStep('mapping')
      }
    } catch (e) { setError((e as Error).message) }
    finally { setLoading(false) }
  }

  async function doResolve(rows: RawCragRow[], m: CragColumnMap) {
    const parsed: ParsedCragRow[] = rows.map((r, i) => parseCragRow(i + 2, r, m))
    const g = await resolve.mutateAsync(parsed)
    setGroups(g)
    setStep('confirm')
  }

  async function handleConfirm() {
    const rep = await execute.mutateAsync(groups)
    setReport(rep)
    setStep('done')
  }

  function reset() {
    setStep('upload'); setHeaders([]); setRawRows([]); setMap({}); setGroups([]); setReport(null); setError('')
  }

  const blocked = groups.some(g => !g.existingCragId && !g.region_id)

  return (
    <div className="admin-page import-page">
      <div className="admin-header"><h1 className="admin-title">Importa falesia</h1></div>
      <StepBar current={step} />

      {step === 'upload' && (
        <div>
          <div className="upload-zone" onClick={() => inputRef.current?.click()}>
            <div className="upload-zone-icon">⛰️</div>
            <div className="upload-zone-title">Carica un file falesia</div>
            <div className="upload-zone-sub">CSV, Excel (.xlsx), Markdown (.md), PDF (best-effort)</div>
            <input ref={inputRef} type="file" accept=".csv,.xlsx,.xls,.md,.markdown,.pdf"
              onChange={e => { const f = e.target.files?.[0]; if (f) handleFile(f) }} />
          </div>
          {loading && <div style={{ marginTop: 12, color: 'var(--text-muted)' }}>Lettura & analisi…</div>}
          {error && <div className="admin-error" style={{ marginTop: 12 }}>{error}</div>}
          <div style={{ marginTop: 20, fontSize: 13, color: 'var(--text-muted)' }}>
            <strong>Colonne richieste:</strong> {CRAG_REQUIRED_FIELDS.map(f => CRAG_FIELD_LABELS[f]).join(', ')}.
            Opzionali: settore, regione, provincia, comune.
          </div>
        </div>
      )}

      {step === 'mapping' && (
        <div>
          <p style={{ fontSize: 13, color: 'var(--text-muted)', marginBottom: 16 }}>
            Associa le colonne. <span style={{ color: '#FFB0A5' }}>*</span> obbligatorie.
          </p>
          <table className="mapping-table">
            <thead><tr><th>Campo</th><th>Colonna</th></tr></thead>
            <tbody>
              {CRAG_ALL_FIELDS.map((field: CragField) => (
                <tr key={field}>
                  <td>{CRAG_FIELD_LABELS[field]}{(CRAG_REQUIRED_FIELDS as readonly string[]).includes(field) && <span className="mapping-required-badge">*</span>}</td>
                  <td>
                    <select className={`mapping-select${map[field] ? ' mapped' : ''}`} value={map[field] ?? ''}
                      onChange={e => setMap({ ...map, [field]: e.target.value || undefined })}>
                      <option value="">— non mappare —</option>
                      {headers.map(h => <option key={h} value={h}>{h}</option>)}
                    </select>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          <div className="import-actions">
            <button className="btn-secondary" onClick={() => setStep('upload')}>← Indietro</button>
            <button className="btn-primary" disabled={!CRAG_REQUIRED_FIELDS.every(f => !!map[f]) || resolve.isPending}
              onClick={() => doResolve(rawRows, map)}>
              {resolve.isPending ? 'Analisi…' : 'Continua →'}
            </button>
          </div>
        </div>
      )}

      {step === 'confirm' && (
        <div>
          <p style={{ fontSize: 13, color: 'var(--text-muted)', marginBottom: 12 }}>
            {groups.length} falesie. Imposta la <strong>regione</strong> per quelle nuove (menu o 🔍 Auto da OpenStreetMap).
            Le falesie esistenti vengono unite (merge): aggiunte solo settori/vie mancanti.
          </p>
          {blocked && <div className="admin-error" style={{ marginBottom: 12 }}>Assegna una regione a tutte le falesie nuove (righe in rosso).</div>}
          <table className="import-table">
            <thead><tr><th>Falesia</th><th>Regione</th><th>Provincia</th><th>Auto</th></tr></thead>
            <tbody>
              {groups.map((g, i) => (
                <CragRow key={g.normalized_crag} group={g} regions={regions}
                  onChange={ng => setGroups(prev => prev.map((x, j) => j === i ? ng : x))} />
              ))}
            </tbody>
          </table>
          <div className="import-actions">
            <button className="btn-secondary" onClick={() => setStep('upload')}>← Annulla</button>
            <button className="btn-primary" disabled={blocked || execute.isPending} onClick={handleConfirm}>
              {execute.isPending ? 'Importazione…' : 'Importa nel catalogo'}
            </button>
          </div>
          {execute.isError && <div className="admin-error" style={{ marginTop: 12 }}>{(execute.error as Error)?.message}</div>}
        </div>
      )}

      {step === 'done' && report && (
        <div className="import-report">
          <div className="import-report-icon">{report.errors.length === 0 ? '✅' : '⚠️'}</div>
          <div className="import-report-title">Import falesia completato</div>
          <div className="import-report-stats">
            <div className="report-stat"><div className="report-stat-num ok">{report.cragsCreated}</div><div className="report-stat-label">Falesie nuove</div></div>
            <div className="report-stat"><div className="report-stat-num upd">{report.cragsMerged}</div><div className="report-stat-label">Falesie merge</div></div>
            <div className="report-stat"><div className="report-stat-num ok">{report.sectorsCreated}</div><div className="report-stat-label">Settori nuovi</div></div>
            <div className="report-stat"><div className="report-stat-num ok">{report.routesCreated}</div><div className="report-stat-label">Vie nuove</div></div>
            <div className="report-stat"><div className="report-stat-num skip">{report.routesSkipped}</div><div className="report-stat-label">Vie già presenti</div></div>
            <div className="report-stat"><div className="report-stat-num upd">{report.enrichmentQueued}</div><div className="report-stat-label">In arricchimento</div></div>
          </div>
          {report.enrichmentQueued > 0 && (
            <p style={{ fontSize: 13, color: 'var(--text-muted)', margin: '4px 0 12px' }}>
              🛰️ {report.enrichmentQueued} falesie messe in coda: coordinate, quota, orientamento, stagione e mesi
              migliori vengono cercati e completati automaticamente in background (fonti aperte OSM/Open-Meteo).
              Segui lo stato in <a href="/admin">Admin → Arricchimento</a>. I campi già presenti non vengono toccati.
            </p>
          )}
          {report.errors.length > 0 && (
            <table className="import-table" style={{ width: '100%' }}>
              <thead><tr><th>Falesia</th><th>Errore</th></tr></thead>
              <tbody>{report.errors.map((e, i) => <tr key={i} className="row-error"><td>{e.crag}</td><td className="row-errors-cell">{e.message}</td></tr>)}</tbody>
            </table>
          )}
          <button className="btn-primary" onClick={reset}>Nuovo import falesia</button>
        </div>
      )}
    </div>
  )
}
