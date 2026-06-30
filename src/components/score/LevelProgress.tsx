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
  const ratio = Math.min(1, Math.max(0, level.progress))
  const pctExact = ratio * 100
  // Etichetta: un decimale sotto l'1% così "appena passato la soglia" non sembra 0.
  const pctLabel = pctExact > 0 && pctExact < 1 ? pctExact.toFixed(1) : String(Math.round(pctExact))
  // Larghezza barra: minimo visibile quando c'è progresso > 0 (evita fill invisibile).
  const fillWidth = pctExact > 0 ? Math.max(pctExact, 2) : 0

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
            <div style={{ width: `${fillWidth}%`, height: '100%', background: 'linear-gradient(90deg,#C85F3A,#E8A05A)', borderRadius: 999, transition: 'width .4s' }} />
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 8, fontSize: 12, color: 'var(--text-muted)' }}>
            <span>{pctLabel}%</span>
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
