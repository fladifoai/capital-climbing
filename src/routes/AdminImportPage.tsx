import { Fragment, useRef, useState } from 'react'
import Papa from 'papaparse'
import { ALL_APP_FIELDS, REQUIRED_FIELDS, type ColumnMap, type ImportReport, type ValidatedRow, type WizardStep } from '../features/import/types'
import { FIELD_LABELS, autoDetectColumns, validateRow } from '../features/import/utils'
import { useCheckDuplicates, useExecuteImport } from '../features/import/hooks'
import '../styles/admin.css'
import '../styles/import.css'

const STEPS: { key: WizardStep; label: string }[] = [
  { key: 'upload', label: 'Carica' },
  { key: 'mapping', label: 'Colonne' },
  { key: 'validation', label: 'Validazione' },
  { key: 'confirm', label: 'Conferma' },
  { key: 'done', label: 'Report' },
]

// ── Step indicator ────────────────────────────────────────────────────────────

function StepBar({ current }: { current: WizardStep }) {
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

// ── Step 1: Upload ────────────────────────────────────────────────────────────

function StepUpload({
  onParsed,
}: {
  onParsed: (headers: string[], rows: Record<string, string>[], filename: string) => void
}) {
  const inputRef = useRef<HTMLInputElement>(null)
  const [dragging, setDragging] = useState(false)
  const [error, setError] = useState('')
  const [fileInfo, setFileInfo] = useState<{ name: string; count: number } | null>(null)

  function handleFile(file: File) {
    if (!file.name.endsWith('.csv')) {
      setError('Solo file CSV (.csv)')
      return
    }
    setError('')
    Papa.parse<Record<string, string>>(file, {
      header: true,
      skipEmptyLines: true,
      complete(results) {
        const headers = results.meta.fields ?? []
        if (headers.length === 0) {
          setError('File vuoto o senza intestazione')
          return
        }
        setFileInfo({ name: file.name, count: results.data.length })
        onParsed(headers, results.data, file.name)
      },
      error(err) {
        setError(`Errore parsing: ${err.message}`)
      },
    })
  }

  return (
    <div>
      <div
        className={`upload-zone${dragging ? ' dragging' : ''}`}
        onClick={() => inputRef.current?.click()}
        onDragOver={e => { e.preventDefault(); setDragging(true) }}
        onDragLeave={() => setDragging(false)}
        onDrop={e => {
          e.preventDefault()
          setDragging(false)
          const file = e.dataTransfer.files[0]
          if (file) handleFile(file)
        }}
      >
        <div className="upload-zone-icon">📂</div>
        <div className="upload-zone-title">Trascina un file CSV o clicca per selezionarlo</div>
        <div className="upload-zone-sub">Formato: colonne con intestazione, separatore virgola o punto e virgola</div>
        <input
          ref={inputRef}
          type="file"
          accept=".csv"
          onChange={e => { const f = e.target.files?.[0]; if (f) handleFile(f) }}
        />
      </div>

      {error && <div className="admin-error" style={{ marginTop: 12 }}>{error}</div>}

      {fileInfo && (
        <div className="upload-file-info">
          <span className="upload-file-name">📄 {fileInfo.name}</span>
          <span className="upload-file-count">{fileInfo.count} righe trovate</span>
        </div>
      )}

      <div style={{ marginTop: 20, fontSize: 13, color: 'var(--text-muted)' }}>
        <strong>Colonne richieste:</strong>{' '}
        {REQUIRED_FIELDS.map(f => FIELD_LABELS[f]).join(', ')}
      </div>
    </div>
  )
}

// ── Step 2: Mapping ───────────────────────────────────────────────────────────

function StepMapping({
  headers,
  map,
  onChange,
  onBack,
  onNext,
}: {
  headers: string[]
  map: ColumnMap
  onChange: (m: ColumnMap) => void
  onBack: () => void
  onNext: () => void
}) {
  const canProceed = REQUIRED_FIELDS.every(f => !!map[f])

  return (
    <div>
      <p style={{ fontSize: 13, color: 'var(--text-muted)', marginBottom: 16 }}>
        Associa le colonne del tuo file ai campi dell'applicazione. I campi <span style={{ color: '#FFB0A5', fontWeight: 600 }}>*</span> sono obbligatori.
      </p>
      <table className="mapping-table">
        <thead>
          <tr>
            <th>Campo applicazione</th>
            <th>Colonna nel file</th>
          </tr>
        </thead>
        <tbody>
          {ALL_APP_FIELDS.map(field => {
            const isRequired = (REQUIRED_FIELDS as readonly string[]).includes(field)
            const mapped = map[field]
            return (
              <tr key={field}>
                <td>
                  {FIELD_LABELS[field]}
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
        <button className="btn-primary" onClick={onNext} disabled={!canProceed}>
          Valida →
        </button>
      </div>
    </div>
  )
}

// ── Step 3: Validation ────────────────────────────────────────────────────────

function StepValidation({
  rows,
  onBack,
  onNext,
  isLoading,
}: {
  rows: ValidatedRow[]
  onBack: () => void
  onNext: () => void
  isLoading: boolean
}) {
  const valid = rows.filter(r => r.isValid).length
  const invalid = rows.filter(r => !r.isValid).length
  const dups = rows.filter(r => r.isValid && r.existingRouteId).length

  return (
    <div>
      <div className="validation-summary">
        <div className="validation-stat">
          <div className="validation-stat-num ok">{valid}</div>
          <div className="validation-stat-label">Valide</div>
        </div>
        <div className="validation-stat">
          <div className="validation-stat-num err">{invalid}</div>
          <div className="validation-stat-label">Errori</div>
        </div>
        <div className="validation-stat">
          <div className="validation-stat-num dup">{dups}</div>
          <div className="validation-stat-label">Duplicati</div>
        </div>
      </div>

      {invalid > 0 && (
        <table className="import-table" style={{ marginBottom: 16 }}>
          <thead>
            <tr>
              <th>#</th>
              <th>Falesia</th>
              <th>Settore</th>
              <th>Via</th>
              <th>Errori</th>
            </tr>
          </thead>
          <tbody>
            {rows.filter(r => !r.isValid).map(row => (
              <tr key={row.rowNum} className="row-error">
                <td style={{ color: '#8a9a87' }}>{row.rowNum}</td>
                <td>{row.crag_name || '—'}</td>
                <td>{row.sector_name || '—'}</td>
                <td>{row.route_name || '—'}</td>
                <td className="row-errors-cell">{row.errors.join(', ')}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}

      {valid === 0 && (
        <div className="empty-state">Nessuna riga valida da importare.</div>
      )}

      <div className="import-actions">
        <button className="btn-secondary" onClick={onBack}>← Indietro</button>
        <button className="btn-primary" onClick={onNext} disabled={valid === 0 || isLoading}>
          {isLoading ? 'Controllo duplicati…' : `Procedi con ${valid} righe →`}
        </button>
      </div>
    </div>
  )
}

// ── Step 4: Confirm ───────────────────────────────────────────────────────────

function StepConfirm({
  rows,
  onRowAction,
  onBack,
  onConfirm,
  isLoading,
}: {
  rows: ValidatedRow[]
  onRowAction: (rowNum: number, action: ValidatedRow['action']) => void
  onBack: () => void
  onConfirm: () => void
  isLoading: boolean
}) {
  const valid = rows.filter(r => r.isValid)
  const toImport = valid.filter(r => r.action === 'import').length
  const toUpdate = valid.filter(r => r.action === 'update').length
  const toSkip = valid.filter(r => r.action === 'skip').length

  return (
    <div>
      <div className="validation-summary">
        <div className="validation-stat">
          <div className="validation-stat-num ok">{toImport}</div>
          <div className="validation-stat-label">Nuove</div>
        </div>
        <div className="validation-stat">
          <div className="validation-stat-num dup">{toUpdate}</div>
          <div className="validation-stat-label">Aggiornamenti</div>
        </div>
        <div className="validation-stat">
          <div className="validation-stat-num" style={{ color: '#8a9a87' }}>{toSkip}</div>
          <div className="validation-stat-label">Salti</div>
        </div>
      </div>

      <table className="import-table">
        <thead>
          <tr>
            <th>#</th>
            <th>Falesia</th>
            <th>Settore</th>
            <th>Via</th>
            <th>Grado</th>
            <th>Stato</th>
            <th>Azione</th>
          </tr>
        </thead>
        <tbody>
          {valid.map(row => (
            <tr key={row.rowNum} className={row.existingRouteId ? 'row-dup' : ''}>
              <td style={{ color: '#8a9a87' }}>{row.rowNum}</td>
              <td>{row.crag_name}</td>
              <td>{row.sector_name}</td>
              <td>{row.route_name}</td>
              <td><span className="grade-badge">{row.official_grade}</span></td>
              <td style={{ fontSize: 11, color: 'var(--text-muted)' }}>
                {row.existingRouteId ? '⚠ duplicato' : row.existingCragId ? '≈ falesia esiste' : '✦ nuovo'}
              </td>
              <td>
                <select
                  className="action-select"
                  value={row.action}
                  onChange={e => onRowAction(row.rowNum, e.target.value as ValidatedRow['action'])}
                >
                  <option value="import">Importa</option>
                  <option value="update">Aggiorna</option>
                  <option value="skip">Salta</option>
                </select>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      <div className="import-actions">
        <button className="btn-secondary" onClick={onBack} disabled={isLoading}>← Indietro</button>
        <button
          className="btn-primary"
          onClick={onConfirm}
          disabled={isLoading || (toImport + toUpdate === 0)}
        >
          {isLoading ? 'Importazione…' : `Conferma importazione (${toImport + toUpdate})`}
        </button>
      </div>
    </div>
  )
}

// ── Step 5: Done ──────────────────────────────────────────────────────────────

function StepDone({ report, onReset }: { report: ImportReport; onReset: () => void }) {
  return (
    <div className="import-report">
      <div className="import-report-icon">{report.errors.length === 0 ? '✅' : '⚠️'}</div>
      <div className="import-report-title">
        {report.errors.length === 0 ? 'Importazione completata' : 'Importazione completata con errori'}
      </div>
      <div className="import-report-stats">
        <div className="report-stat">
          <div className="report-stat-num ok">{report.imported}</div>
          <div className="report-stat-label">Importate</div>
        </div>
        <div className="report-stat">
          <div className="report-stat-num upd">{report.updated}</div>
          <div className="report-stat-label">Aggiornate</div>
        </div>
        <div className="report-stat">
          <div className="report-stat-num skip">{report.skipped}</div>
          <div className="report-stat-label">Saltate</div>
        </div>
        {report.errors.length > 0 && (
          <div className="report-stat">
            <div className="report-stat-num err">{report.errors.length}</div>
            <div className="report-stat-label">Errori</div>
          </div>
        )}
      </div>

      {report.errors.length > 0 && (
        <table className="import-table" style={{ width: '100%' }}>
          <thead>
            <tr><th>#</th><th>Errore</th></tr>
          </thead>
          <tbody>
            {report.errors.map(e => (
              <tr key={e.rowNum} className="row-error">
                <td>{e.rowNum}</td>
                <td className="row-errors-cell">{e.message}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}

      <button className="btn-primary" onClick={onReset}>Nuova importazione</button>
    </div>
  )
}

// ── Main page ─────────────────────────────────────────────────────────────────

export default function AdminImportPage() {
  const [step, setStep] = useState<WizardStep>('upload')
  const [headers, setHeaders] = useState<string[]>([])
  const [rawRows, setRawRows] = useState<Record<string, string>[]>([])
  const [_filename, setFilename] = useState('')
  const [map, setMap] = useState<ColumnMap>({})
  const [rows, setRows] = useState<ValidatedRow[]>([])
  const [report, setReport] = useState<ImportReport | null>(null)

  const checkDups = useCheckDuplicates()
  const executeImport = useExecuteImport()

  function handleParsed(h: string[], data: Record<string, string>[], name: string) {
    setHeaders(h)
    setRawRows(data)
    setFilename(name)
    setMap(autoDetectColumns(h))
    setStep('mapping')
  }

  function handleMapping() {
    const validated = rawRows.map((row, i) => validateRow(i + 2, row, map))
    setRows(validated)
    setStep('validation')
  }

  async function handleValidation() {
    const withDups = await checkDups.mutateAsync(rows)
    setRows(withDups)
    setStep('confirm')
  }

  function handleRowAction(rowNum: number, action: ValidatedRow['action']) {
    setRows(prev => prev.map(r => r.rowNum === rowNum ? { ...r, action } : r))
  }

  async function handleConfirm() {
    const result = await executeImport.mutateAsync(rows)
    setReport(result)
    setStep('done')
  }

  function handleReset() {
    setStep('upload')
    setHeaders([])
    setRawRows([])
    setFilename('')
    setMap({})
    setRows([])
    setReport(null)
  }

  return (
    <div className="admin-page import-page">
      <div className="admin-header">
        <h1 className="admin-title">Importazione CSV</h1>
      </div>

      <StepBar current={step} />

      {step === 'upload' && <StepUpload onParsed={handleParsed} />}
      {step === 'mapping' && (
        <StepMapping
          headers={headers}
          map={map}
          onChange={setMap}
          onBack={() => setStep('upload')}
          onNext={handleMapping}
        />
      )}
      {step === 'validation' && (
        <StepValidation
          rows={rows}
          onBack={() => setStep('mapping')}
          onNext={handleValidation}
          isLoading={checkDups.isPending}
        />
      )}
      {step === 'confirm' && (
        <StepConfirm
          rows={rows}
          onRowAction={handleRowAction}
          onBack={() => setStep('validation')}
          onConfirm={handleConfirm}
          isLoading={executeImport.isPending}
        />
      )}
      {step === 'done' && report && (
        <StepDone report={report} onReset={handleReset} />
      )}

      {(checkDups.isError || executeImport.isError) && (
        <div className="admin-error" style={{ marginTop: 16 }}>
          {((checkDups.error || executeImport.error) as Error)?.message}
        </div>
      )}
    </div>
  )
}
