import {
  ResponsiveContainer, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Cell,
} from 'recharts'
import { fmtScore, type YearScore } from '../../features/score/calc'

interface TipProps {
  active?: boolean
  payload?: Array<{ payload: YearScore }>
}
function Tip({ active, payload }: TipProps) {
  if (!active || !payload?.length) return null
  const d = payload[0].payload
  return (
    <div className="chart-tooltip">
      <div className="chart-tooltip-title">{d.year}</div>
      <div className="chart-tooltip-row">{d.route_count} vie</div>
      <div className="chart-tooltip-row">{fmtScore(d.season_score)} pt</div>
      <div className="chart-tooltip-row">media {fmtScore(d.avg_score_per_route)}/via</div>
      {d.route_count < 10 && <div className="chart-tooltip-sub">Campione piccolo</div>}
    </div>
  )
}

// 13.2 — Season Score per anno. Barre con campione &lt;10 vie attenuate.
export default function SeasonScoreChart({ data }: { data: YearScore[] }) {
  return (
    <div className="chart-section">
      <h3 className="chart-title">Punti per anno</h3>
      <p className="chart-description">Season Score per ogni stagione.</p>
      <ResponsiveContainer width="100%" height={260}>
        <BarChart data={data} margin={{ top: 8, right: 16, bottom: 8, left: 8 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="rgba(247,243,234,0.08)" />
          <XAxis dataKey="year" tick={{ fontSize: 11, fill: '#9c958a' }} />
          <YAxis tick={{ fontSize: 11, fill: '#9c958a' }} tickFormatter={(v) => fmtScore(v)} width={56} />
          <Tooltip content={<Tip />} cursor={{ fill: 'rgba(247,243,234,0.05)' }} />
          <Bar dataKey="season_score" radius={[4, 4, 0, 0]}>
            {data.map((d) => (
              <Cell key={d.year} fill="#C85F3A" fillOpacity={d.route_count < 10 ? 0.4 : 1} />
            ))}
          </Bar>
        </BarChart>
      </ResponsiveContainer>
    </div>
  )
}
