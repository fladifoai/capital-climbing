import {
  ResponsiveContainer, LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip,
} from 'recharts'
import { fmtScore, type RollingPoint } from '../../features/score/calc'

interface TipProps {
  active?: boolean
  payload?: Array<{ payload: RollingPoint }>
}
function Tip({ active, payload }: TipProps) {
  if (!active || !payload?.length) return null
  const d = payload[0].payload
  return (
    <div className="chart-tooltip">
      <div className="chart-tooltip-title">{d.label}</div>
      <div className="chart-tooltip-row">{fmtScore(d.rolling_score)} pt (12 mesi)</div>
    </div>
  )
}

// 13.4 — Rolling: per ogni mese la somma dei 12 mesi precedenti (forma recente).
export default function Last12MonthsScoreChart({ data }: { data: RollingPoint[] }) {
  return (
    <div className="chart-section">
      <h3 className="chart-title">Forma recente (rolling 12 mesi)</h3>
      <p className="chart-description">Somma punti dei 12 mesi precedenti, mese per mese.</p>
      <ResponsiveContainer width="100%" height={260}>
        <LineChart data={data} margin={{ top: 8, right: 16, bottom: 8, left: 8 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="rgba(247,243,234,0.08)" />
          <XAxis dataKey="label" tick={{ fontSize: 11, fill: '#9c958a' }} minTickGap={24} />
          <YAxis tick={{ fontSize: 11, fill: '#9c958a' }} tickFormatter={(v) => fmtScore(v)} width={56} />
          <Tooltip content={<Tip />} />
          <Line type="monotone" dataKey="rolling_score" stroke="#28B487" strokeWidth={2} dot={false} />
        </LineChart>
      </ResponsiveContainer>
    </div>
  )
}
