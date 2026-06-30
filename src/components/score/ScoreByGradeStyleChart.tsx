import {
  ResponsiveContainer, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend,
} from 'recharts'
import { fmtScore, ATTEMPT_COLOR, type GradeStyleScore } from '../../features/score/calc'

// 13.7 — Piramide punti: stacked bar per grado, suddivisa per stile.
export default function ScoreByGradeStyleChart({ data }: { data: GradeStyleScore[] }) {
  return (
    <div className="chart-section">
      <h3 className="chart-title">Punti per grado e stile</h3>
      <p className="chart-description">Quali gradi generano più punti, e con quale stile.</p>
      <ResponsiveContainer width="100%" height={300}>
        <BarChart data={data} margin={{ top: 8, right: 16, bottom: 8, left: 8 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="rgba(247,243,234,0.08)" />
          <XAxis dataKey="grade" tick={{ fontSize: 11, fill: '#9c958a' }} />
          <YAxis tick={{ fontSize: 11, fill: '#9c958a' }} tickFormatter={(v) => fmtScore(Number(v))} width={56} />
          <Tooltip
            cursor={{ fill: 'rgba(247,243,234,0.05)' }}
            contentStyle={{ background: '#2A3240', border: '1px solid rgba(247,243,234,0.14)', borderRadius: 8, fontSize: 12 }}
            formatter={(v) => [fmtScore(Number(v)), '']}
          />
          <Legend wrapperStyle={{ fontSize: 12 }} />
          <Bar dataKey="onsight_score" name="On-sight" stackId="g" fill={ATTEMPT_COLOR.onsight} />
          <Bar dataKey="flash_score" name="Flash" stackId="g" fill={ATTEMPT_COLOR.flash} />
          <Bar dataKey="second_go_score" name="2° giro" stackId="g" fill={ATTEMPT_COLOR.second_go} />
          <Bar dataKey="redpoint_score" name="Redpoint" stackId="g" fill={ATTEMPT_COLOR.redpoint} radius={[4, 4, 0, 0]} />
        </BarChart>
      </ResponsiveContainer>
    </div>
  )
}
