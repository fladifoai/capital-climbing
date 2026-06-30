import {
  ResponsiveContainer, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip,
} from 'recharts'
import { fmtScore, type MonthScore } from '../../features/score/calc'

interface TipProps {
  active?: boolean
  payload?: Array<{ payload: MonthScore }>
}
function Tip({ active, payload }: TipProps) {
  if (!active || !payload?.length) return null
  const d = payload[0].payload
  return (
    <div className="chart-tooltip">
      <div className="chart-tooltip-title">{d.month_label}</div>
      <div className="chart-tooltip-row">{d.route_count} vie</div>
      <div className="chart-tooltip-row">{fmtScore(d.monthly_score)} pt</div>
      <div className="chart-tooltip-row">media {fmtScore(d.avg_score_per_route)}/via</div>
    </div>
  )
}

// 13.3 — Punti mensili dell'anno selezionato.
export default function MonthlyScoreChart({
  data,
  year,
  years,
  onYearChange,
}: {
  data: MonthScore[]
  year: number
  years: number[]
  onYearChange: (y: number) => void
}) {
  return (
    <div className="chart-section">
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 8, flexWrap: 'wrap' }}>
        <h3 className="chart-title" style={{ margin: 0 }}>Punti mensili</h3>
        <select
          value={year}
          onChange={(e) => onYearChange(Number(e.target.value))}
          style={{ background: '#2A3240', color: 'var(--text)', border: '1px solid rgba(247,243,234,0.14)', borderRadius: 8, padding: '4px 8px', fontSize: 13 }}
        >
          {years.map((y) => <option key={y} value={y}>{y}</option>)}
        </select>
      </div>
      {data.length === 0 ? (
        <p className="chart-description">Nessun punto nel {year}.</p>
      ) : (
        <ResponsiveContainer width="100%" height={240}>
          <BarChart data={data} margin={{ top: 12, right: 16, bottom: 8, left: 8 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="rgba(247,243,234,0.08)" />
            <XAxis dataKey="month_label" tick={{ fontSize: 11, fill: '#9c958a' }} />
            <YAxis tick={{ fontSize: 11, fill: '#9c958a' }} tickFormatter={(v) => fmtScore(v)} width={56} />
            <Tooltip content={<Tip />} cursor={{ fill: 'rgba(247,243,234,0.05)' }} />
            <Bar dataKey="monthly_score" fill="#4C9BE8" radius={[4, 4, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      )}
    </div>
  )
}
