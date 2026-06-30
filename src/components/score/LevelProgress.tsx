import { fmtScore } from '../../features/score/calc'
import type { LevelInfo } from '../../lib/scoring'

// Progress bar verso il prossimo livello pubblico.
// Elite NON viene mai mostrato finché lifetime_score < 1.000.000.
export default function LevelProgress({
  level,
  lifetimeScore,
}: {
  level: LevelInfo
  lifetimeScore: number
}) {
  const pct = Math.round(Math.min(1, Math.max(0, level.progress)) * 100)

  return (
    <div className="chart-section">
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 10 }}>
        <div>
          <div style={{ fontSize: 13, color: 'var(--text-muted)' }}>Livello attuale</div>
          <div style={{ fontSize: 22, fontWeight: 800, color: 'var(--accent)' }}>
            {level.level?.label ?? 'Nessun livello'}
            {level.eliteUnlocked && ' 👑'}
          </div>
        </div>
        <div style={{ textAlign: 'right' }}>
          <div style={{ fontSize: 22, fontWeight: 800 }}>{fmtScore(lifetimeScore)}</div>
          <div style={{ fontSize: 12, color: 'var(--text-muted)' }}>Capital Score</div>
        </div>
      </div>

      {level.nextLevel ? (
        <>
          <div style={{ height: 12, borderRadius: 999, background: 'rgba(247,243,234,0.10)', overflow: 'hidden' }}>
            <div style={{ width: `${pct}%`, height: '100%', background: 'linear-gradient(90deg,#C85F3A,#E8A05A)', borderRadius: 999, transition: 'width .4s' }} />
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 8, fontSize: 12, color: 'var(--text-muted)' }}>
            <span>{pct}%</span>
            <span>
              Mancano <strong style={{ color: 'var(--text)' }}>{fmtScore(level.pointsToNext)}</strong> per {level.nextLevel.label}
            </span>
          </div>
        </>
      ) : (
        <div style={{ fontSize: 13, color: 'var(--text-muted)', paddingTop: 4 }}>
          {level.eliteUnlocked
            ? 'Hai raggiunto il livello massimo. 👑'
            : 'Livello massimo pubblico raggiunto. Continua a scalare per sbloccare nuovi traguardi.'}
        </div>
      )}
    </div>
  )
}
