import { fmtScore, type ScoreOverview } from '../../features/score/calc'

// Card KPI principali del Capital Score (dashboard punti).
export default function ScoreOverviewCards({ overview }: { overview: ScoreOverview }) {
  const o = overview
  return (
    <div className="kpi-grid">
      <div className="kpi-card">
        <div className="kpi-value">{fmtScore(o.lifetime_score)}</div>
        <div className="kpi-label">Capital Score</div>
        <div className="kpi-sub">Lifetime · {o.route_count} vie</div>
      </div>
      <div className="kpi-card">
        <div className="kpi-value">{fmtScore(o.season_score)}</div>
        <div className="kpi-label">Season Score {o.season_year}</div>
      </div>
      <div className="kpi-card">
        <div className="kpi-value">{fmtScore(o.last_12_months_score)}</div>
        <div className="kpi-label">Ultimi 12 mesi</div>
      </div>
      <div className="kpi-card">
        <div className="kpi-value">{fmtScore(o.avg_score_per_route)}</div>
        <div className="kpi-label">Punti medi per via</div>
      </div>
      {o.best_route && (
        <div className="kpi-card">
          <div className="kpi-value" style={{ fontSize: 18 }}>{o.best_route.route_name}</div>
          <div className="kpi-label">Migliore via</div>
          <div className="kpi-sub">
            {o.best_route.grade} · {fmtScore(o.best_route.capital_score)} pt
          </div>
        </div>
      )}
      {o.level.level && (
        <div className="kpi-card">
          <div className="kpi-value" style={{ fontSize: 20 }}>{o.level.level.label}</div>
          <div className="kpi-label">Livello attuale</div>
          {o.level.pointsToNext != null && o.level.nextLevel && (
            <div className="kpi-sub">
              {fmtScore(o.level.pointsToNext)} al livello {o.level.nextLevel.label}
            </div>
          )}
        </div>
      )}
    </div>
  )
}
