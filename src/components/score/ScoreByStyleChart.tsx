import {
  ResponsiveContainer, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Cell,
} from 'recharts'
import { fmtScore, ATTEMPT_COLOR, ATTEMPT_LABEL, type StyleScore } from '../../features/score/calc'

interface Row extends StyleScore {
  label: string
  color: string
}

interface TipProps {
  active?: boolean
  payload?: Array<{ payload: Row }>
}
function Tip({ active, payload }: TipProps) {
  if (!active || !payload?.length) return null
  const d = payload[0].payload
  return (
    <div className="chart-tooltip">
      <div className="chart-tooltip-title">{d.label}</div>
      <div className="chart-tooltip-row">{d.route_count} vie</div>
      <div className="chart-tooltip-row">{fmtScore(d.total_score)} pt</div>
      <div className="chart-tooltip-row">media {fmtScore(d.avg_score)}/via</div>
    </div>
  )
}

// 13.6 — Punti per stile (da dove arrivano i punti).
export default function ScoreByStyleChart({ data }: { data: StyleScore[] }) {
  const rows: Row[] = data.map((d) => ({
    ...d,
    label: ATTEMPT_LABEL[d.attempt_type],
    color: ATTEMPT_COLOR[d.attempt_type],
  }))
  return (
    <div className="chart-section">
      <h3 className="chart-title">Punti per stile</h3>
      <p className="chart-description">Contributo di on-sight, flash, 2° giro e redpoint.</p>
      <ResponsiveContainer width="100%" height={240}>
        <BarChart data={rows} margin={{ top: 8, right: 16, bottom: 8, left: 8 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="rgba(247,243,234,0.08)" />
          <XAxis dataKey="label" tick={{ fontSize: 11, fill: '#9c958a' }} />
          <YAxis tick={{ fontSize: 11, fill: '#9c958a' }} tickFormatter={(v) => fmtScore(v)} width={56} />
          <Tooltip content={<Tip />} cursor={{ fill: 'rgba(247,243,234,0.05)' }} />
          <Bar dataKey="total_score" radius={[4, 4, 0, 0]}>
            {rows.map((d) => <Cell key={d.attempt_type} fill={d.color} />)}
          </Bar>
        </BarChart>
      </ResponsiveContainer>
    </div>
  )
}
