import { useMemo, useState } from 'react'
import {
  ResponsiveContainer, BarChart, Bar, XAxis, YAxis,
  CartesianGrid, Tooltip, Cell,
} from 'recharts'
import { useAuth } from '../features/auth/AuthContext'
import { useMyAscents } from '../features/logbook/hooks'
import { useMyProjects } from '../features/projects/hooks'
import '../styles/analytics.css'

const GREEN = '#2d5a27'
const LIGHT_GREEN = '#4a8a42'
const ATTEMPT_LABELS: Record<string, string> = {
  onsight: 'On-sight', flash: 'Flash', second: '2° giro',
  third: '3° giro', four_plus: '4+', redpoint: 'Redpoint',
}

const MONTHS_IT = ['Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu', 'Lug', 'Ago', 'Set', 'Ott', 'Nov', 'Dic']

function gradeLabel(n: number | null): string {
  return n?.toString() ?? '?'
}

export default function AnalyticsPage() {
  const { user } = useAuth()
  const { data: ascents, isLoading: loadingAscents } = useMyAscents(user?.id ?? '')
  const { data: projects } = useMyProjects(user?.id ?? '')

  const currentYear = new Date().getFullYear()
  const [yearFilter, setYearFilter] = useState<number | 'all'>(currentYear)

  // Available years from data
  const availableYears = useMemo(() => {
    const years = new Set<number>()
    ;(ascents ?? []).forEach(a => {
      const y = parseInt(a.date.slice(0, 4))
      if (!isNaN(y)) years.add(y)
    })
    return Array.from(years).sort((a, b) => b - a)
  }, [ascents])

  // Filter to selected year
  const filtered = useMemo(() => {
    const completed = (ascents ?? []).filter(a => a.status === 'completed')
    if (yearFilter === 'all') return completed
    return completed.filter(a => a.date.startsWith(String(yearFilter)))
  }, [ascents, yearFilter])

  // KPIs
  const kpis = useMemo(() => {
    const total = filtered.length
    const grades = filtered.map(a => a.grade_numeric_at_ascent ?? 0).filter(n => n > 0)
    const best = grades.length ? Math.max(...grades) : null
    const bestGradeLabel = best != null
      ? filtered.find(a => (a.grade_numeric_at_ascent ?? 0) === best)?.grade_at_ascent ?? gradeLabel(best)
      : '—'

    const onsightGrades = filtered.filter(a => a.attempt_type === 'onsight').map(a => a.grade_numeric_at_ascent ?? 0)
    const bestOS = onsightGrades.length ? Math.max(...onsightGrades) : null
    const bestOSLabel = bestOS != null
      ? filtered.find(a => a.attempt_type === 'onsight' && (a.grade_numeric_at_ascent ?? 0) === bestOS)?.grade_at_ascent ?? gradeLabel(bestOS)
      : '—'

    const flashGrades = filtered.filter(a => a.attempt_type === 'flash').map(a => a.grade_numeric_at_ascent ?? 0)
    const bestFL = flashGrades.length ? Math.max(...flashGrades) : null
    const bestFLLabel = bestFL != null
      ? filtered.find(a => a.attempt_type === 'flash' && (a.grade_numeric_at_ascent ?? 0) === bestFL)?.grade_at_ascent ?? gradeLabel(bestFL)
      : '—'

    const osFl = filtered.filter(a => a.attempt_type === 'onsight' || a.attempt_type === 'flash').length
    const osFlPct = total > 0 ? Math.round((osFl / total) * 100) : 0

    const activeProjects = (projects ?? []).filter(p => p.status === 'active').length

    const uniqueCrags = new Set(filtered.map(a => a.route?.sector?.crag?.id).filter(Boolean))

    return { total, bestGradeLabel, bestOSLabel, bestFLLabel, osFlPct, activeProjects, crags: uniqueCrags.size }
  }, [filtered, projects])

  // Chart 1: Ascents per month
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
        const [, m] = key.split('-')
        const monthIdx = parseInt(m) - 1
        return { month: MONTHS_IT[monthIdx] ?? key, count }
      })
  }, [filtered, yearFilter])

  // Chart 2: Grade distribution
  const gradeData = useMemo(() => {
    const map = new Map<string, { count: number; numeric: number }>()
    filtered.forEach(a => {
      const grade = a.grade_at_ascent ?? a.route?.official_grade ?? null
      if (!grade) return
      const existing = map.get(grade)
      if (existing) {
        existing.count++
      } else {
        map.set(grade, { count: 1, numeric: a.grade_numeric_at_ascent ?? 0 })
      }
    })
    return Array.from(map.entries())
      .map(([grade, { count, numeric }]) => ({ grade, count, numeric }))
      .sort((a, b) => a.numeric - b.numeric)
  }, [filtered])

  // Chart 3: Attempt type breakdown
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

  if (!user) return null
  if (loadingAscents) return <div className="loading-state">Caricamento analisi…</div>

  const years = availableYears.length > 0 ? availableYears : [currentYear]

  return (
    <div className="analytics-page">
      <div className="analytics-header">
        <h1>Analisi</h1>
        <div className="year-filter">
          {years.map(y => (
            <button
              key={y}
              className={`year-btn${yearFilter === y ? ' active' : ''}`}
              onClick={() => setYearFilter(y)}
            >
              {y}
            </button>
          ))}
          <button
            className={`year-btn${yearFilter === 'all' ? ' active' : ''}`}
            onClick={() => setYearFilter('all')}
          >
            Tutti
          </button>
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

      {/* Chart: ascents per month */}
      <div className="chart-section">
        <h2>Salite per mese {yearFilter !== 'all' ? `— ${yearFilter}` : ''}</h2>
        {monthlyData.every(d => d.count === 0) ? (
          <div className="chart-empty">Nessuna salita nel periodo selezionato.</div>
        ) : (
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={monthlyData} margin={{ top: 4, right: 8, left: -20, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
              <XAxis dataKey="month" tick={{ fontSize: 11 }} />
              <YAxis allowDecimals={false} tick={{ fontSize: 11 }} />
              <Tooltip
                contentStyle={{ fontSize: 12, borderRadius: 8, border: '1px solid #e0e0d8' }}
                formatter={(v) => [v, 'Salite']}
              />
              <Bar dataKey="count" fill={GREEN} radius={[3, 3, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        )}
      </div>

      {/* Chart: grade distribution */}
      <div className="chart-section">
        <h2>Distribuzione gradi</h2>
        {gradeData.length === 0 ? (
          <div className="chart-empty">Nessuna salita con grado nel periodo.</div>
        ) : (
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={gradeData} margin={{ top: 4, right: 8, left: -20, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
              <XAxis dataKey="grade" tick={{ fontSize: 11 }} />
              <YAxis allowDecimals={false} tick={{ fontSize: 11 }} />
              <Tooltip
                contentStyle={{ fontSize: 12, borderRadius: 8, border: '1px solid #e0e0d8' }}
                formatter={(v) => [v, 'Salite']}
              />
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

      {/* Chart: attempt type */}
      <div className="chart-section">
        <h2>Tipo di salita</h2>
        {attemptData.length === 0 ? (
          <div className="chart-empty">Nessun dato nel periodo.</div>
        ) : (
          <ResponsiveContainer width="100%" height={180}>
            <BarChart data={attemptData} layout="vertical" margin={{ top: 4, right: 24, left: 60, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
              <XAxis type="number" allowDecimals={false} tick={{ fontSize: 11 }} />
              <YAxis type="category" dataKey="type" tick={{ fontSize: 11 }} width={60} />
              <Tooltip
                contentStyle={{ fontSize: 12, borderRadius: 8, border: '1px solid #e0e0d8' }}
                formatter={(v) => [v, 'Salite']}
              />
              <Bar dataKey="count" fill={GREEN} radius={[0, 3, 3, 0]} />
            </BarChart>
          </ResponsiveContainer>
        )}
      </div>
    </div>
  )
}
