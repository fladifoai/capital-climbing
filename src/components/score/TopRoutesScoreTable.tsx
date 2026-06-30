import { fmtScore, ATTEMPT_COLOR, ATTEMPT_LABEL, type TopRoute } from '../../features/score/calc'

// 13.5 — Top 10 vie per Capital Score.
export default function TopRoutesScoreTable({ data }: { data: TopRoute[] }) {
  return (
    <div className="chart-section">
      <h3 className="chart-title">Top vie per punti</h3>
      <div style={{ overflowX: 'auto' }}>
        <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
          <thead>
            <tr style={{ textAlign: 'left', color: 'var(--text-muted)', fontSize: 11, textTransform: 'uppercase' }}>
              <th style={{ padding: '6px 8px' }}>#</th>
              <th style={{ padding: '6px 8px' }}>Via</th>
              <th style={{ padding: '6px 8px' }}>Falesia</th>
              <th style={{ padding: '6px 8px' }}>Grado</th>
              <th style={{ padding: '6px 8px' }}>Stile</th>
              <th style={{ padding: '6px 8px', textAlign: 'right' }}>Punti</th>
              <th style={{ padding: '6px 8px' }}>Data</th>
            </tr>
          </thead>
          <tbody>
            {data.map((r) => (
              <tr key={`${r.rank}-${r.route_name}`} style={{ borderTop: '1px solid rgba(247,243,234,0.08)' }}>
                <td style={{ padding: '8px', color: 'var(--text-muted)', fontWeight: 700 }}>{r.rank}</td>
                <td style={{ padding: '8px', fontWeight: 600 }}>{r.route_name}</td>
                <td style={{ padding: '8px', color: 'var(--text-muted)' }}>{r.crag_name || '—'}</td>
                <td style={{ padding: '8px' }}><span className="grade-badge">{r.grade || '—'}</span></td>
                <td style={{ padding: '8px' }}>
                  <span style={{
                    fontSize: 11, fontWeight: 700, padding: '2px 8px', borderRadius: 999,
                    color: ATTEMPT_COLOR[r.attempt_type],
                    background: `${ATTEMPT_COLOR[r.attempt_type]}18`,
                    border: `1px solid ${ATTEMPT_COLOR[r.attempt_type]}44`,
                  }}>{ATTEMPT_LABEL[r.attempt_type]}</span>
                </td>
                <td style={{ padding: '8px', textAlign: 'right', fontWeight: 800 }}>{fmtScore(r.capital_score)}</td>
                <td style={{ padding: '8px', color: 'var(--text-muted)' }}>{r.date}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}
