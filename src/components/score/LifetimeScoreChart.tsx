import {
  ResponsiveContainer, LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip,
} from 'recharts'
import { fmtScore, type CumulativePoint } from '../../features/score/calc'

interface TipProps {
  active?: boolean
  payload?: Array<{ payload: CumulativePoint }>
}
function Tip({ active, payload }: TipProps) {
  if (!active || !payload?.length) return null
  const d = payload[0].payload
  return (
    <div className="chart-tooltip">
      <div className="chart-tooltip-title">{d.route_name}</div>
      <div className="chart-tooltip-date">{d.date}</div>
      <div className="chart-tooltip-row">+{fmtScore(d.capital_score)} pt</div>
      <div className="chart-tooltip-row">Totale: {fmtScore(d.cumulative_score)}</div>
    </div>
  )
}

// 13.1 — Lifetime Capital Score cumulativo nel tempo.
export default function LifetimeScoreChart({ data }: { data: CumulativePoint[] }) {
  return (
    <div className="chart-section">
      <h3 className="chart-title">Capital Score nel tempo</h3>
      <p className="chart-description">Crescita cumulativa del tuo profilo.</p>
      <ResponsiveContainer width="100%" height={280}>
        <LineChart data={data} margin={{ top: 8, right: 16, bottom: 8, left: 8 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="rgba(247,243,234,0.08)" />
          <XAxis dataKey="date" tick={{ fontSize: 11, fill: '#9c958a' }} minTickGap={32} />
          <YAxis tick={{ fontSize: 11, fill: '#9c958a' }} tickFormatter={(v) => fmtScore(v)} width={56} />
          <Tooltip content={<Tip />} />
          <Line type="monotone" dataKey="cumulative_score" stroke="#C85F3A" strokeWidth={2} dot={false} />
        </LineChart>
      </ResponsiveContainer>
    </div>
  )
}
