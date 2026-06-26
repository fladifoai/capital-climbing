import { useState } from 'react'
import { useIsSpoilerUnlocked, useUnlockSpoiler } from './hooks'

interface Props {
  routeId: string
  userId: string | null
  title: string
  children: React.ReactNode
}

export default function SpoilerGuard({ routeId, userId, title, children }: Props) {
  const [sessionUnlocked, setSessionUnlocked] = useState(false)
  const [dialogOpen, setDialogOpen] = useState(false)
  const [remember, setRemember] = useState(false)

  const { data: dbUnlocked = false } = useIsSpoilerUnlocked(routeId, userId ?? '')
  const unlock = useUnlockSpoiler()

  const isUnlocked = sessionUnlocked || dbUnlocked

  if (isUnlocked) return <>{children}</>

  async function confirmUnlock() {
    if (remember && userId) {
      await unlock.mutateAsync({ routeId, userId })
    }
    setSessionUnlocked(true)
    setDialogOpen(false)
  }

  function closeDialog() {
    setDialogOpen(false)
    setRemember(false)
  }

  return (
    <>
      <div className="spoiler-guard" role="region" aria-label={`${title} — protetto da modalità On-sight`}>
        <span className="spoiler-guard-icon" aria-hidden="true">🔒</span>
        <p className="spoiler-guard-title">{title} nascosti</p>
        <p className="spoiler-guard-sub">Sblocca per visualizzare i dettagli tecnici</p>
        <button
          className="spoiler-unlock-btn"
          onClick={() => setDialogOpen(true)}
          aria-haspopup="dialog"
        >
          Sblocca informazioni tecniche
        </button>
      </div>

      {dialogOpen && (
        <div
          className="spoiler-overlay"
          role="dialog"
          aria-modal="true"
          aria-labelledby="spoiler-dialog-title"
          onClick={e => { if (e.target === e.currentTarget) closeDialog() }}
        >
          <div className="spoiler-dialog">
            <h3 id="spoiler-dialog-title">Sbloccare le informazioni tecniche?</h3>
            <p className="spoiler-dialog-warning">
              Questa sezione può contenere informazioni su prese, movimenti,
              riposi, kneebar e beta che potrebbero rovinare il tuo tentativo On-sight.
            </p>
            {userId ? (
              <label className="spoiler-remember">
                <input
                  type="checkbox"
                  checked={remember}
                  onChange={e => setRemember(e.target.checked)}
                />
                Ricorda per questa via
              </label>
            ) : (
              <p className="spoiler-login-hint">
                <a href="#/login">Accedi</a> per ricordare la scelta per questa via.
              </p>
            )}
            <div className="spoiler-dialog-btns">
              <button className="btn-secondary" onClick={closeDialog}>Annulla</button>
              <button
                className="btn-primary"
                onClick={confirmUnlock}
                disabled={unlock.isPending}
                // eslint-disable-next-line jsx-a11y/no-autofocus
                autoFocus
              >
                Sblocca comunque
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  )
}
