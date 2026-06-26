import { useMemo, useState } from 'react'
import {
  ResponsiveContainer, BarChart, Bar, XAxis, YAxis,
  CartesianGrid, Tooltip, Cell, LineChart, Line, Legend,
} from 'recharts'
import { useAuth } from '../features/auth/AuthContext'
import { useMyAscents } from '../features/logbook/hooks'
import { useMyProjects } from '../features/projects/hooks'
import '../styles/analytics.css'

const GREEN = '#2d5a27'
const LIGHT_GREEN = '#4a8a42'
const ORANGE = '#e07b00'
const RED = '#c0392b'
const ATTEMPT_LABELS: Record<string, string> = {
  onsight: 'On-sight', flash: 'Flash', second: '2° giro',
  third: '3° giro', four_plus: '4+', redpoint: 'Redpoint',
}

const MONTHS_IT = ['Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu', 'Lug', 'Ago', 'Set', 'Ott', 'Nov', 'Dic']

// grade_numeric → label mapping (scale from migration context)
const NUM_TO_GRADE: Record<number, string> = {
  1: '5a', 2: '5b', 3: '5c', 4: '6a', 5: '6a+', 6: '6b', 7: '6b+', 8: '6c', 9: '6c+',
  10: '7a', 11: '7a+', 12: '7b', 13: '7b+', 14: '7c', 15: '7c+', 16: '8a', 17: '8a+',
  18: '8b', 19: '8b+', 20: '8c', 21: '8c+', 22: '9a',
}

function numToGrade(n: number): string {
  return NUM_TO_GRADE[n] ?? String(n)
}

export default function AnalyticsPage() {
  const { user } = useAuth()
  const { data: ascents, isLoading: loadingAscents } = useMyAscents(user?.id ?? '')
  const { data: projects } = useMyProjects(user?.id ?? '')

  const currentYear = new Date().getFullYear()
  // Default 'all' so seeded historical data is visible immediately
  const [yearFilter, setYearFilter] = useState<number | 'all'>('all')

  const availableYears = useMemo(() => {
    const years = new Set<number>()
    ;(ascents ?? []).forEach(a => {
      const y = parseInt(a.date.slice(0, 4))
      if (!isNaN(y)) years.add(y)
    })
    return Array.from(years).sort((a, b) => b - a)
  }, [ascents])

  const filtered = useMemo(() => {
    const completed = (ascents ?? []).filter(a => a.status === 'completed')
    if (yearFilter === 'all') return completed
    return completed.filter(a => a.date.startsWith(String(yearFilter)))
  }, [ascents, yearFilter])

  // ── KPIs ─────────────────────────────────────────────────────────────
  const kpis = useMemo(() => {
    const total = filtered.length
    const grades = filtered.map(a => a.grade_numeric_at_ascent ?? 0).filter(n => n > 0)
    const best = grades.length ? Math.max(...grades) : null
    const bestGradeLabel = best != null
      ? filtered.find(a => (a.grade_numeric_at_ascent ?? 0) === best)?.grade_at_ascent ?? numToGrade(best)
      : '—'

    const onsightGrades = filtered.filter(a => a.attempt_type === 'onsight').map(a => a.grade_numeric_at_ascent ?? 0)
    const bestOS = onsightGrades.length ? Math.max(...onsightGrades) : null
    const bestOSLabel = bestOS != null
      ? filtered.find(a => a.attempt_type === 'onsight' && (a.grade_numeric_at_ascent ?? 0) === bestOS)?.grade_at_ascent ?? numToGrade(bestOS)
      : '—'

    const flashGrades = filtered.filter(a => a.attempt_type === 'flash').map(a => a.grade_numeric_at_ascent ?? 0)
    const bestFL = flashGrades.length ? Math.max(...flashGrades) : null
    const bestFLLabel = bestFL != null
      ? filtered.find(a => a.attempt_type === 'flash' && (a.grade_numeric_at_ascent ?? 0) === bestFL)?.grade_at_ascent ?? numToGrade(bestFL)
      : '—'

    const osFl = filtered.filter(a => a.attempt_type === 'onsight' || a.attempt_type === 'flash').length
    const osFlPct = total > 0 ? Math.round((osFl / total) * 100) : 0

    const activeProjects = (projects ?? []).filter(p => p.status === 'active').length
    const uniqueCrags = new Set(filtered.map(a => a.route?.sector?.crag?.id).filter(Boolean))

    return { total, bestGradeLabel, bestOSLabel, bestFLLabel, osFlPct, activeProjects, crags: uniqueCrags.size }
  }, [filtered, projects])

  // ── Chart 1: Salite per mese ──────────────────────────────────────────
  const monthlyData = useMemo(() => {
    const map = new Map<string, number>()
    if (yearFilter !== 'all') {
      for (let m = 0; m < 12; m++) {
        map.set(`${yearFilter}-${String(m + 1).padStart(2, '0')}`, 0)
      }
    }
    filtered.forEach(a => {
      const key = a.date.slice(0, 7)
      map.set(key, (map.get(key) ?? 0) + 1)
    })
    return Array.from(map.entries())
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([key, count]) => {
        const [y, m] = key.split('-')
        const monthIdx = parseInt(m) - 1
        const label = yearFilter === 'all' ? key : (MONTHS_IT[monthIdx] ?? key)
        return { label, count, year: y }
      })
  }, [filtered, yearFilter])

  // ── Chart 2: Distribuzione gradi ──────────────────────────────────────
  const gradeData = useMemo(() => {
    const map = new Map<string, { count: number; numeric: number }>()
    filtered.forEach(a => {
      const grade = a.grade_at_ascent ?? a.route?.official_grade ?? null
      if (!grade) return
      const existing = map.get(grade)
      if (existing) existing.count++
      else map.set(grade, { count: 1, numeric: a.grade_numeric_at_ascent ?? 0 })
    })
    return Array.from(map.entries())
      .map(([grade, { count, numeric }]) => ({ grade, count, numeric }))
      .sort((a, b) => a.numeric - b.numeric)
  }, [filtered])

  // ── Chart 3: Tipo di salita ───────────────────────────────────────────
  const attemptData = useMemo(() => {
    const map = new Map<string, number>()
    filtered.forEach(a => {
      if (!a.attempt_type) return
      map.set(a.attempt_type, (map.get(a.attempt_type) ?? 0) + 1)
    })
    return Array.from(map.entries())
      .map(([type, count]) => ({ type: ATTEMPT_LABELS[type] ?? type, count }))
      .sort((a, b) => b.count - a.count)
  }, [filtered])

  // ── Chart 4: Progressione grado nel tempo ────────────────────────────
  const progressionData = useMemo(() => {
    const map = new Map<string, { best: number; total: number; count: number }>()
    filtered.forEach(a => {
      const key = yearFilter === 'all' ? a.date.slice(0, 4) : a.date.slice(0, 7)
      const n = a.grade_numeric_at_ascent ?? 0
      if (!n) return
      const entry = map.get(key)
      if (entry) {
        if (n > entry.best) entry.best = n
        entry.total += n
        entry.count++
      } else {
        map.set(key, { best: n, total: n, count: 1 })
      }
    })
    return Array.from(map.entries())
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([key, { best, total, count }]) => {
        const [, m] = key.split('-')
        const monthIdx = m ? parseInt(m) - 1 : -1
        const label = yearFilter === 'all' ? key : (MONTHS_IT[monthIdx] ?? key)
        return {
          label,
          best,
          avg: Math.round((total / count) * 10) / 10,
          bestLabel: numToGrade(best),
          avgLabel: numToGrade(Math.round(total / count)),
        }
      })
  }, [filtered, yearFilter])

  // ── Chart 5: Top falesie ──────────────────────────────────────────────
  const cragData = useMemo(() => {
    const map = new Map<string, { name: string; count: number }>()
    filtered.forEach(a => {
      const id = a.route?.sector?.crag?.id
      const name = a.route?.sector?.crag?.name
      if (!id || !name) return
      const existing = map.get(id)
      if (existing) existing.count++
      else map.set(id, { name, count: 1 })
    })
    return Array.from(map.values()).sort((a, b) => b.count - a.count).slice(0, 10)
  }, [filtered])

  // ── Chart 6: Stacked OS/FL/RP per grado ──────────────────────────────
  const stackedData = useMemo(() => {
    const map = new Map<string, { grade: string; numeric: number; onsight: number; flash: number; redpoint: number; other: number }>()
    filtered.forEach(a => {
      const grade = a.grade_at_ascent ?? a.route?.official_grade ?? null
      if (!grade) return
      const existing = map.get(grade)
      const entry = existing ?? {
        grade, numeric: a.grade_numeric_at_ascent ?? 0,
        onsight: 0, flash: 0, redpoint: 0, other: 0,
      }
      if (!existing) map.set(grade, entry)
      if (a.attempt_type === 'onsight') entry.onsight++
      else if (a.attempt_type === 'flash') entry.flash++
      else if (a.attempt_type === 'redpoint') entry.redpoint++
      else entry.other++
    })
    return Array.from(map.values()).sort((a, b) => a.numeric - b.numeric)
  }, [filtered])

  if (!user) return null
  if (loadingAscents) return <div className="loading-state">Caricamento analisi…</div>

  const years = availableYears.length > 0 ? availableYears : [currentYear]

  return (
    <div className="analytics-page">
      <div className="analytics-header">
        <h1>Analisi</h1>
        <div className="year-filter">
          <button
            className={`year-btn${yearFilter === 'all' ? ' active' : ''}`}
            onClick={() => setYearFilter('all')}
          >
            Tutti
          </button>
          {years.map(y => (
            <button
              key={y}
              className={`year-btn${yearFilter === y ? ' active' : ''}`}
              onClick={() => setYearFilter(y)}
            >
              {y}
            </button>
          ))}
        </div>
      </div>

      {/* KPI cards */}
      <div className="kpi-grid">
        <div className="kpi-card">
          <div className="kpi-value">{kpis.total}</div>
          <div className="kpi-label">Salite</div>
        </div>
        <div className="kpi-card">
          <div className="kpi-value">{kpis.bestGradeLabel}</div>
          <div className="kpi-label">Grado max</div>
        </div>
        <div className="kpi-card">
          <div className="kpi-value">{kpis.bestOSLabel}</div>
          <div className="kpi-label">On-sight max</div>
        </div>
        <div className="kpi-card">
          <div className="kpi-value">{kpis.bestFLLabel}</div>
          <div className="kpi-label">Flash max</div>
        </div>
        <div className="kpi-card">
          <div className="kpi-value">{kpis.osFlPct}%</div>
          <div className="kpi-label">OS + Flash</div>
        </div>
        <div className="kpi-card">
          <div className="kpi-value">{kpis.crags}</div>
          <div className="kpi-label">Falesie</div>
        </div>
        <div className="kpi-card">
          <div className="kpi-value">{kpis.activeProjects}</div>
          <div className="kpi-label">Progetti</div>
        </div>
      </div>

      {/* Row 1: volume + tipo */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16, marginBottom: 16 }}>

        {/* Chart 1: Salite per mese */}
        <div className="chart-section" style={{ marginBottom: 0 }}>
          <h2>Volume {yearFilter !== 'all' ? yearFilter : 'per anno'}</h2>
          {monthlyData.every(d => d.count === 0) ? (
            <div className="chart-empty">Nessuna salita nel periodo.</div>
          ) : (
            <ResponsiveContainer width="100%" height={200}>
              <BarChart data={monthlyData} margin={{ top: 4, right: 8, left: -20, bottom: 0 }}>
                <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
                <XAxis dataKey="label" tick={{ fontSize: 10 }} interval="preserveStartEnd" />
                <YAxis allowDecimals={false} tick={{ fontSize: 10 }} />
                <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Salite']} />
                <Bar dataKey="count" fill={GREEN} radius={[3, 3, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          )}
        </div>

        {/* Chart 3: Tipo di salita */}
        <div className="chart-section" style={{ marginBottom: 0 }}>
          <h2>Tipo di salita</h2>
          {attemptData.length === 0 ? (
            <div className="chart-empty">Nessun dato.</div>
          ) : (
            <ResponsiveContainer width="100%" height={200}>
              <BarChart data={attemptData} layout="vertical" margin={{ top: 4, right: 24, left: 70, bottom: 0 }}>
                <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                <YAxis type="category" dataKey="type" tick={{ fontSize: 10 }} width={70} />
                <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Salite']} />
                <Bar dataKey="count" fill={GREEN} radius={[0, 3, 3, 0]} />
              </BarChart>
            </ResponsiveContainer>
          )}
        </div>
      </div>

      {/* Chart 2: Distribuzione gradi (piramide) */}
      <div className="chart-section">
        <h2>Distribuzione gradi</h2>
        {gradeData.length === 0 ? (
          <div className="chart-empty">Nessun dato.</div>
        ) : (
          <ResponsiveContainer width="100%" height={220}>
            <BarChart data={gradeData} margin={{ top: 4, right: 8, left: -20, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
              <XAxis dataKey="grade" tick={{ fontSize: 11 }} />
              <YAxis allowDecimals={false} tick={{ fontSize: 11 }} />
              <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Salite']} />
              <Bar dataKey="count" radius={[3, 3, 0, 0]}>
                {gradeData.map((entry, i) => (
                  <Cell
                    key={entry.grade}
                    fill={i === gradeData.length - 1 ? '#1a3a16' : i >= gradeData.length - 3 ? GREEN : LIGHT_GREEN}
                  />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        )}
      </div>

      {/* Chart 4: Progressione grado nel tempo */}
      <div className="chart-section">
        <h2>Progressione grado nel tempo</h2>
        {progressionData.length < 2 ? (
          <div className="chart-empty">Servono almeno 2 periodi con dati per mostrare la progressione.</div>
        ) : (
          <ResponsiveContainer width="100%" height={220}>
            <LineChart data={progressionData} margin={{ top: 4, right: 16, left: -10, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
              <XAxis dataKey="label" tick={{ fontSize: 10 }} interval="preserveStartEnd" />
              <YAxis
                allowDecimals={false}
                tick={{ fontSize: 10 }}
                tickFormatter={numToGrade}
                domain={['auto', 'auto']}
              />
              <Tooltip
                contentStyle={{ fontSize: 11, borderRadius: 8 }}
                formatter={(value: number, name: string) => [numToGrade(Math.round(value)), name === 'best' ? 'Massimo' : 'Media']}
              />
              <Legend formatter={(v) => v === 'best' ? 'Grado massimo' : 'Media'} wrapperStyle={{ fontSize: 11 }} />
              <Line type="monotone" dataKey="best" stroke={GREEN} strokeWidth={2} dot={{ r: 3 }} name="best" />
              <Line type="monotone" dataKey="avg" stroke={ORANGE} strokeWidth={2} dot={{ r: 3 }} strokeDasharray="4 2" name="avg" />
            </LineChart>
          </ResponsiveContainer>
        )}
      </div>

      {/* Row 2: top crags + OS/FL/RP per grade */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>

        {/* Chart 5: Top falesie */}
        <div className="chart-section" style={{ marginBottom: 0 }}>
          <h2>Top falesie</h2>
          {cragData.length === 0 ? (
            <div className="chart-empty">Nessun dato.</div>
          ) : (
            <ResponsiveContainer width="100%" height={Math.max(160, cragData.length * 28)}>
              <BarChart data={cragData} layout="vertical" margin={{ top: 4, right: 24, left: 8, bottom: 0 }}>
                <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                <YAxis type="category" dataKey="name" tick={{ fontSize: 10 }} width={110} />
                <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Salite']} />
                <Bar dataKey="count" fill={LIGHT_GREEN} radius={[0, 3, 3, 0]} />
              </BarChart>
            </ResponsiveContainer>
          )}
        </div>

        {/* Chart 6: OS/FL/RP stacked per grado */}
        <div className="chart-section" style={{ marginBottom: 0 }}>
          <h2>Come hai salito per grado</h2>
          {stackedData.length === 0 ? (
            <div className="chart-empty">Nessun dato.</div>
          ) : (
            <ResponsiveContainer width="100%" height={Math.max(160, stackedData.length * 28)}>
              <BarChart data={stackedData} margin={{ top: 4, right: 8, left: -20, bottom: 0 }}>
                <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
                <XAxis dataKey="grade" tick={{ fontSize: 10 }} />
                <YAxis allowDecimals={false} tick={{ fontSize: 10 }} />
                <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} />
                <Legend wrapperStyle={{ fontSize: 11 }} />
                <Bar dataKey="onsight" name="OS" stackId="a" fill="#1a6e2c" />
                <Bar dataKey="flash"   name="FL" stackId="a" fill={ORANGE} />
                <Bar dataKey="redpoint" name="RP" stackId="a" fill={RED} />
                <Bar dataKey="other"   name="Altro" stackId="a" fill="#aac0a7" radius={[3, 3, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          )}
        </div>
      </div>
    </div>
  )
}
