import { useState } from 'react'
import { useAuth } from '../features/auth/AuthContext'
import { useScoreData } from '../features/score/hooks'
import ScoreOverviewCards from '../components/score/ScoreOverviewCards'
import LevelProgress from '../components/score/LevelProgress'
import LifetimeScoreChart from '../components/score/LifetimeScoreChart'
import SeasonScoreChart from '../components/score/SeasonScoreChart'
import MonthlyScoreChart from '../components/score/MonthlyScoreChart'
import Last12MonthsScoreChart from '../components/score/Last12MonthsScoreChart'
import ScoreByStyleChart from '../components/score/ScoreByStyleChart'
import ScoreByGradeStyleChart from '../components/score/ScoreByGradeStyleChart'
import TopRoutesScoreTable from '../components/score/TopRoutesScoreTable'
import '../styles/analytics.css'
import '../styles/score.css'

export default function ScorePage() {
  const { user } = useAuth()
  const [year, setYear] = useState(new Date().getFullYear())
  const data = useScoreData(user?.id ?? '', year)

  if (!user) return null
  if (data.isLoading) return <div className="loading-state">Caricamento punti…</div>
  if (data.error) return <div className="admin-error">Errore: {(data.error as Error).message}</div>

  if (!data.hasData) {
    return (
      <div className="score-page">
        <div className="score-page-header">
          <h1>Capital Score</h1>
          <p>Registra le tue salite per iniziare a guadagnare punti.</p>
        </div>
      </div>
    )
  }

  const years = data.availableYears.length ? data.availableYears : [year]

  return (
    <div className="score-page">
      <div className="score-page-header">
        <h1>Capital Score</h1>
        <p>XP realistici per arrampicata: grado + stile della salita.</p>
      </div>

      <ScoreOverviewCards overview={data.overview} />

      <div style={{ marginTop: 16 }}>
        <LevelProgress level={data.overview.level} lifetimeScore={data.overview.lifetime_score} />
      </div>

      <div style={{ marginTop: 16 }}>
        <LifetimeScoreChart data={data.cumulative} />
      </div>

      <div className="score-grid-2" style={{ marginTop: 16 }}>
        <SeasonScoreChart data={data.byYear} />
        <MonthlyScoreChart data={data.byMonth} year={year} years={years} onYearChange={setYear} />
      </div>

      <div className="score-grid-2" style={{ marginTop: 16 }}>
        <Last12MonthsScoreChart data={data.rolling12} />
        <ScoreByStyleChart data={data.byStyle} />
      </div>

      <div style={{ marginTop: 16 }}>
        <ScoreByGradeStyleChart data={data.byGradeStyle} />
      </div>

      <div style={{ marginTop: 16 }}>
        <TopRoutesScoreTable data={data.topRoutes} />
      </div>
    </div>
  )
}
