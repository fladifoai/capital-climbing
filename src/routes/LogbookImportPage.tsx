import { Fragment, useRef, useState } from 'react'
import {
  LOGBOOK_ALL_FIELDS, LOGBOOK_REQUIRED_FIELDS,
  type LogbookColumnMap, type LogbookField, type LogbookWizardStep, type ParsedLogbookRow, type RawLogbookRow,
} from '../features/logbook-import/types'
import {
  LOGBOOK_FIELD_LABELS, autoDetectLogbookColumns, parseLogbookFile, parseLogbookRow,
} from '../features/logbook-import/parse'
import '../styles/admin.css'
import '../styles/import.css'

const STEPS: { key: LogbookWizardStep; label: string }[] = [
  { key: 'upload', label: 'Carica' },
  { key: 'mapping', label: 'Colonne' },
  { key: 'preview', label: 'Anteprima' },
  { key: 'confirm', label: 'Conferma' },
  { key: 'done', label: 'Report' },
]

function StepBar({ current }: { current: LogbookWizardStep }) {
  const currentIdx = STEPS.findIndex(s => s.key === current)
  return (
    <div className="import-steps">
      {STEPS.map((step, i) => {
        const state = i < currentIdx ? 'done' : i === currentIdx ? 'active' : ''
        return (
          <Fragment key={step.key}>
            <div className={`import-step-item ${state}`}>
              <span className="import-step-num">{i < currentIdx ? '✓' : i + 1}</span>
              <span>{step.label}</span>
            </div>
            {i < STEPS.length - 1 && <span className="import-step-sep" />}
          </Fragment>
        )
      })}
    </div>
  )
}

// ── Step 1: Upload ────────────────────────────────────────────────────────
function StepUpload({
  onParsed,
}: {
  onParsed: (headers: string[], rows: RawLogbookRow[], filename: string) => void
}) {
  const inputRef = useRef<HTMLInputElement>(null)
  const [dragging, setDragging] = useState(false)
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const [fileInfo, setFileInfo] = useState<{ name: string; count: number } | null>(null)

  async function handleFile(file: File) {
    setError('')
    setLoading(true)
    try {
      const { headers, rows } = await parseLogbookFile(file)
      setFileInfo({ name: file.name, count: rows.length })
      onParsed(headers, rows, file.name)
    } catch (e) {
      setError((e as Error).message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div>
      <div
        className={`upload-zone${dragging ? ' dragging' : ''}`}
        onClick={() => inputRef.current?.click()}
        onDragOver={e => { e.preventDefault(); setDragging(true) }}
        onDragLeave={() => setDragging(false)}
        onDrop={e => {
          e.preventDefault(); setDragging(false)
          const file = e.dataTransfer.files[0]
          if (file) handleFile(file)
        }}
      >
        <div className="upload-zone-icon">📒</div>
        <div className="upload-zone-title">Trascina il tuo logbook o clicca per selezionarlo</div>
        <div className="upload-zone-sub">Formati: CSV, Excel (.xlsx). PDF in arrivo.</div>
        <input
          ref={inputRef}
          type="file"
          accept=".csv,.xlsx,.xls"
          onChange={e => { const f = e.target.files?.[0]; if (f) handleFile(f) }}
        />
      </div>

      {loading && <div style={{ marginTop: 12, color: 'var(--text-muted)' }}>Lettura file…</div>}
      {error && <div className="admin-error" style={{ marginTop: 12 }}>{error}</div>}

      {fileInfo && !loading && (
        <div className="upload-file-info">
          <span className="upload-file-name">📄 {fileInfo.name}</span>
          <span className="upload-file-count">{fileInfo.count} righe trovate</span>
        </div>
      )}

      <div style={{ marginTop: 20, fontSize: 13, color: 'var(--text-muted)' }}>
        <strong>Colonne richieste:</strong>{' '}
        {LOGBOOK_REQUIRED_FIELDS.map(f => LOGBOOK_FIELD_LABELS[f]).join(', ')}
      </div>
    </div>
  )
}

// ── Step 2: Mapping ─────────────────────────────────────────────────────────
function StepMapping({
  headers, map, onChange, onBack, onNext,
}: {
  headers: string[]
  map: LogbookColumnMap
  onChange: (m: LogbookColumnMap) => void
  onBack: () => void
  onNext: () => void
}) {
  const canProceed = LOGBOOK_REQUIRED_FIELDS.every(f => !!map[f])
  return (
    <div>
      <p style={{ fontSize: 13, color: 'var(--text-muted)', marginBottom: 16 }}>
        Associa le colonne del tuo file ai campi. I campi <span style={{ color: '#FFB0A5', fontWeight: 600 }}>*</span> sono obbligatori.
      </p>
      <table className="mapping-table">
        <thead><tr><th>Campo</th><th>Colonna nel file</th></tr></thead>
        <tbody>
          {LOGBOOK_ALL_FIELDS.map((field: LogbookField) => {
            const isRequired = (LOGBOOK_REQUIRED_FIELDS as readonly string[]).includes(field)
            const mapped = map[field]
            return (
              <tr key={field}>
                <td>
                  {LOGBOOK_FIELD_LABELS[field]}
                  {isRequired && <span className="mapping-required-badge">*</span>}
                </td>
                <td>
                  <select
                    className={`mapping-select${mapped ? ' mapped' : ''}`}
                    value={mapped ?? ''}
                    onChange={e => onChange({ ...map, [field]: e.target.value || undefined })}
                  >
                    <option value="">— non mappare —</option>
                    {headers.map(h => <option key={h} value={h}>{h}</option>)}
                  </select>
                </td>
              </tr>
            )
          })}
        </tbody>
      </table>
      <div className="import-actions">
        <button className="btn-secondary" onClick={onBack}>← Indietro</button>
        <button className="btn-primary" onClick={onNext} disabled={!canProceed}>Anteprima →</button>
      </div>
    </div>
  )
}

// ── Step 3: Preview ───────────────────────────────────────────────────────
function StepPreview({
  rows, onBack,
}: {
  rows: ParsedLogbookRow[]
  onBack: () => void
}) {
  const valid = rows.filter(r => r.isValid).length
  const review = rows.filter(r => r.needsReview).length
  const invalid = rows.filter(r => !r.isValid).length

  return (
    <div>
      <div className="validation-summary">
        <div className="validation-stat">
          <div className="validation-stat-num ok">{valid}</div>
          <div className="validation-stat-label">Valide</div>
        </div>
        <div className="validation-stat">
          <div className="validation-stat-num dup">{review}</div>
          <div className="validation-stat-label">Da revisionare</div>
        </div>
        <div className="validation-stat">
          <div className="validation-stat-num err">{invalid}</div>
          <div className="validation-stat-label">Errori</div>
        </div>
      </div>

      <table className="import-table">
        <thead>
          <tr>
            <th>#</th><th>Data</th><th>Falesia</th><th>Settore</th><th>Via</th>
            <th>Grado</th><th>Modalità</th><th>Problemi</th>
          </tr>
        </thead>
        <tbody>
          {rows.map(row => (
            <tr key={row.rowNum} className={!row.isValid ? 'row-error' : row.needsReview ? 'row-dup' : ''}>
              <td style={{ color: '#8a9a87' }}>{row.rowNum}</td>
              <td>{row.date ?? <span style={{ color: '#FFB0A5' }}>{row.raw_date || '—'}</span>}</td>
              <td>{row.crag_name || '—'}</td>
              <td>{row.sector_name || '—'}</td>
              <td>{row.route_name || '—'}</td>
              <td>{row.grade ? <span className="grade-badge">{row.grade}</span> : '—'}</td>
              <td style={{ fontSize: 12 }}>
                {row.attempt_type ?? '—'}{row.attempt_count ? ` (${row.attempt_count}°)` : ''}
              </td>
              <td className="row-errors-cell">{[...row.errors, ...row.warnings].join(', ') || '✓'}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <div className="import-actions">
        <button className="btn-secondary" onClick={onBack}>← Indietro</button>
        <button className="btn-primary" disabled title="Abbinamento vie + salvataggio: Fase 2">
          Salva ascensioni → (Fase 2)
        </button>
      </div>
      <p style={{ fontSize: 12, color: 'var(--text-muted)', marginTop: 8 }}>
        Anteprima parsing. Abbinamento al catalogo e salvataggio arrivano nella prossima fase.
      </p>
    </div>
  )
}

// ── Main ────────────────────────────────────────────────────────────────────
export default function LogbookImportPage() {
  const [step, setStep] = useState<LogbookWizardStep>('upload')
  const [headers, setHeaders] = useState<string[]>([])
  const [rawRows, setRawRows] = useState<RawLogbookRow[]>([])
  const [map, setMap] = useState<LogbookColumnMap>({})
  const [rows, setRows] = useState<ParsedLogbookRow[]>([])

  function handleParsed(h: string[], data: RawLogbookRow[]) {
    setHeaders(h)
    setRawRows(data)
    setMap(autoDetectLogbookColumns(h))
    setStep('mapping')
  }

  function handleMapping() {
    setRows(rawRows.map((row, i) => parseLogbookRow(i + 2, row, map)))
    setStep('preview')
  }

  return (
    <div className="admin-page import-page">
      <div className="admin-header">
        <h1 className="admin-title">Importa il tuo logbook</h1>
      </div>

      <StepBar current={step} />

      {step === 'upload' && <StepUpload onParsed={(h, d) => handleParsed(h, d)} />}
      {step === 'mapping' && (
        <StepMapping
          headers={headers}
          map={map}
          onChange={setMap}
          onBack={() => setStep('upload')}
          onNext={handleMapping}
        />
      )}
      {step === 'preview' && (
        <StepPreview rows={rows} onBack={() => setStep('mapping')} />
      )}
    </div>
  )
}
