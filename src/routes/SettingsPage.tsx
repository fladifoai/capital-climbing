import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'
import { useOwnProfile, useUpdateProfile } from '../features/users/hooks'
import {
  useUpdateEmail,
  useUpdatePassword,
  usePrivateSettings,
  useUpdatePrivateSettings,
  useInjuryPeriods,
  useCreateInjuryPeriod,
  useDeleteInjuryPeriod,
  exportUserData,
  ascentsToCsv,
  downloadFile,
  useSoftDeleteAccount,
} from '../features/users/settingsHooks'
import type { Profile } from '../types/database'
import '../styles/users.css'
import '../styles/admin.css'

type Tab = 'account' | 'profilo' | 'privacy' | 'sicurezza' | 'privati' | 'backup' | 'pericolo'

const TABS: { id: Tab; label: string }[] = [
  { id: 'account', label: 'Account' },
  { id: 'profilo', label: 'Profilo' },
  { id: 'privacy', label: 'Privacy' },
  { id: 'sicurezza', label: 'Sicurezza' },
  { id: 'privati', label: 'Dati privati' },
  { id: 'backup', label: 'Dati e backup' },
  { id: 'pericolo', label: 'Zona pericolosa' },
]

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
const USERNAME_RE = /^[a-zA-Z0-9_-]{3,30}$/
const PASSWORD_RE = /^(?=.*[A-Za-z])(?=.*\d).{8,}$/

export default function SettingsPage() {
  const { user } = useAuth()
  const { data: profile, isLoading } = useOwnProfile(user?.id ?? '')
  const [tab, setTab] = useState<Tab>('account')

  if (!user) return null
  if (isLoading || !profile) return <div className="loading-state">Caricamento…</div>

  return (
    <div className="settings-page settings-wide">
      <h1>Impostazioni</h1>
      <p className="settings-sub">
        Profilo pubblico:{' '}
        <Link to={`/u/${profile.username}`} className="settings-link">@{profile.username}</Link>
      </p>

      <div className="settings-layout">
        <nav className="settings-tabs">
          {TABS.map((t) => (
            <button
              key={t.id}
              className={`settings-tab${tab === t.id ? ' active' : ''}${t.id === 'pericolo' ? ' danger' : ''}`}
              onClick={() => setTab(t.id)}
            >
              {t.label}
            </button>
          ))}
        </nav>

        <div className="settings-content">
          {tab === 'account' && <AccountSection email={user.email ?? ''} />}
          {tab === 'profilo' && <ProfileSection profile={profile} userId={user.id} />}
          {tab === 'privacy' && <PrivacySection profile={profile} userId={user.id} />}
          {tab === 'sicurezza' && <PasswordSection email={user.email ?? ''} />}
          {tab === 'privati' && <PrivateDataSection userId={user.id} />}
          {tab === 'backup' && <BackupSection userId={user.id} username={profile.username} />}
          {tab === 'pericolo' && <DangerSection userId={user.id} username={profile.username} />}
        </div>
      </div>
    </div>
  )
}

// ─── feedback helpers ─────────────────────────────────────

function Saved({ show, text = 'Modifiche salvate.' }: { show: boolean; text?: string }) {
  if (!show) return null
  return <div className="settings-saved">✓ {text}</div>
}

function ErrMsg({ msg }: { msg?: string | null }) {
  if (!msg) return null
  return <div className="admin-error" style={{ marginTop: 10 }}>{msg}</div>
}

// ─── Account (email) ──────────────────────────────────────

function AccountSection({ email }: { email: string }) {
  const updateEmail = useUpdateEmail()
  const [newEmail, setNewEmail] = useState('')
  const [confirm, setConfirm] = useState('')
  const [err, setErr] = useState<string | null>(null)
  const [done, setDone] = useState(false)

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setErr(null); setDone(false)
    if (!EMAIL_RE.test(newEmail)) return setErr('Inserisci un indirizzo email valido.')
    if (newEmail !== confirm) return setErr('Le email inserite non coincidono.')
    if (newEmail === email) return setErr('La nuova email è uguale a quella attuale.')
    try {
      await updateEmail.mutateAsync(newEmail)
      setDone(true); setNewEmail(''); setConfirm('')
    } catch (e) { setErr((e as Error).message) }
  }

  return (
    <div className="settings-section">
      <h2>Account — Email</h2>
      <div className="settings-email-row"><strong>Email attuale:</strong> {email}</div>
      <form onSubmit={submit}>
        <div className="form-group">
          <label>Nuova email</label>
          <input type="email" value={newEmail} onChange={(e) => setNewEmail(e.target.value)} placeholder="nuova@email.it" />
        </div>
        <div className="form-group">
          <label>Conferma nuova email</label>
          <input type="email" value={confirm} onChange={(e) => setConfirm(e.target.value)} />
        </div>
        <div className="settings-actions">
          <button type="submit" className="btn-primary" disabled={updateEmail.isPending}>
            {updateEmail.isPending ? 'Salvataggio…' : 'Aggiorna email'}
          </button>
        </div>
        <Saved show={done} text="Ti abbiamo inviato una conferma alla nuova email. Controlla la posta per completare." />
        <ErrMsg msg={err} />
      </form>
    </div>
  )
}

// ─── Profilo ──────────────────────────────────────────────

function ProfileSection({ profile, userId }: { profile: Profile; userId: string }) {
  const update = useUpdateProfile()
  const [f, setF] = useState({
    username: profile.username,
    display_name: profile.display_name,
    avatar_url: profile.avatar_url ?? '',
    bio: profile.bio ?? '',
    city: profile.city ?? '',
    country: profile.country ?? '',
    climbing_since: profile.climbing_since != null ? String(profile.climbing_since) : '',
    preferred_style: profile.preferred_style ?? '',
  })
  const [err, setErr] = useState<string | null>(null)
  const [done, setDone] = useState(false)
  const set = (k: keyof typeof f) => (e: { target: { value: string } }) =>
    setF((p) => ({ ...p, [k]: e.target.value }))

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setErr(null); setDone(false)
    if (!USERNAME_RE.test(f.username))
      return setErr('Username: 3-30 caratteri, solo lettere, numeri, trattino e trattino basso.')
    if (f.display_name.trim().length < 1) return setErr('Il nome visualizzato è obbligatorio.')
    try {
      await update.mutateAsync({
        userId,
        values: {
          username: f.username,
          display_name: f.display_name,
          avatar_url: f.avatar_url || null,
          bio: f.bio || null,
          city: f.city || null,
          country: f.country || null,
          climbing_since: f.climbing_since ? Number(f.climbing_since) : null,
          preferred_style: f.preferred_style || null,
        },
      })
      setDone(true)
    } catch (e) {
      const m = (e as Error).message
      setErr(/duplicate|unique|23505/i.test(m) ? 'Questo username è già in uso.' : m)
    }
  }

  return (
    <div className="settings-section">
      <h2>Profilo</h2>
      <form onSubmit={submit}>
        <div className="form-grid">
          <div className="form-group">
            <label>Username *</label>
            <input value={f.username} onChange={set('username')} placeholder="flavio_climbs" />
          </div>
          <div className="form-group">
            <label>Nome visualizzato *</label>
            <input value={f.display_name} onChange={set('display_name')} placeholder="Flavio" />
          </div>
        </div>
        <div className="form-group">
          <label>Avatar (URL immagine)</label>
          <input value={f.avatar_url} onChange={set('avatar_url')} placeholder="https://…/foto.jpg" />
          {f.avatar_url && <img src={f.avatar_url} alt="" className="settings-avatar-preview" />}
        </div>
        <div className="form-group">
          <label>Bio</label>
          <textarea value={f.bio} onChange={set('bio')} rows={3} placeholder="Qualcosa su di te…" />
        </div>
        <div className="form-grid">
          <div className="form-group">
            <label>Città</label>
            <input value={f.city} onChange={set('city')} placeholder="es. Roma" />
          </div>
          <div className="form-group">
            <label>Paese</label>
            <input value={f.country} onChange={set('country')} placeholder="es. Italia" />
          </div>
          <div className="form-group">
            <label>Scala dal (anno)</label>
            <input type="number" min={1950} max={new Date().getFullYear()} value={f.climbing_since} onChange={set('climbing_since')} placeholder="es. 2010" />
          </div>
          <div className="form-group">
            <label>Stile preferito</label>
            <select value={f.preferred_style} onChange={set('preferred_style')}>
              <option value="">—</option>
              <option value="Sportiva">Sportiva</option>
              <option value="Boulder">Boulder</option>
              <option value="Trad">Trad</option>
              <option value="Multipitch">Multipitch</option>
              <option value="Mista">Mista</option>
            </select>
          </div>
        </div>
        <div className="settings-actions">
          <button type="submit" className="btn-primary" disabled={update.isPending}>
            {update.isPending ? 'Salvataggio…' : 'Salva modifiche'}
          </button>
        </div>
        <Saved show={done} />
        <ErrMsg msg={err} />
      </form>
    </div>
  )
}

// ─── Privacy ──────────────────────────────────────────────

const PRIVACY_FLAGS: { key: keyof Profile; label: string }[] = [
  { key: 'is_public', label: 'Profilo pubblico (visibile e ricercabile)' },
  { key: 'show_ascents', label: 'Mostra ascensioni pubbliche' },
  { key: 'show_projects', label: 'Mostra progetti pubblici' },
  { key: 'show_stats', label: 'Mostra statistiche pubbliche' },
  { key: 'show_charts', label: 'Mostra grafici pubblici' },
  { key: 'show_visited_crags', label: 'Mostra falesie visitate' },
  { key: 'show_max_grade', label: 'Mostra grado massimo' },
]

function PrivacySection({ profile, userId }: { profile: Profile; userId: string }) {
  const update = useUpdateProfile()
  const [flags, setFlags] = useState(() =>
    Object.fromEntries(PRIVACY_FLAGS.map((p) => [p.key, profile[p.key] as boolean])) as Record<string, boolean>
  )
  const [err, setErr] = useState<string | null>(null)
  const [done, setDone] = useState(false)

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setErr(null); setDone(false)
    try {
      await update.mutateAsync({ userId, values: flags })
      setDone(true)
    } catch { setErr('Non è stato possibile aggiornare la privacy. Riprova.') }
  }

  return (
    <div className="settings-section">
      <h2>Privacy</h2>
      <p className="settings-hint">Vedi sempre tutto di te stesso. Gli altri vedono solo ciò che è pubblico. Email, password e dati privati non sono mai pubblici.</p>
      <form onSubmit={submit}>
        {PRIVACY_FLAGS.map((p) => (
          <label key={p.key} className="settings-toggle">
            <input
              type="checkbox"
              checked={flags[p.key]}
              onChange={(e) => setFlags((s) => ({ ...s, [p.key]: e.target.checked }))}
            />
            <span>{p.label}</span>
          </label>
        ))}
        <div className="settings-actions">
          <button type="submit" className="btn-primary" disabled={update.isPending}>
            {update.isPending ? 'Salvataggio…' : 'Salva privacy'}
          </button>
        </div>
        <Saved show={done} text="Impostazioni privacy aggiornate." />
        <ErrMsg msg={err} />
      </form>
    </div>
  )
}

// ─── Sicurezza (password) ─────────────────────────────────

function PasswordSection({ email }: { email: string }) {
  const update = useUpdatePassword()
  const [cur, setCur] = useState('')
  const [next, setNext] = useState('')
  const [confirm, setConfirm] = useState('')
  const [err, setErr] = useState<string | null>(null)
  const [done, setDone] = useState(false)

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setErr(null); setDone(false)
    if (!PASSWORD_RE.test(next))
      return setErr('La nuova password deve avere almeno 8 caratteri e contenere almeno una lettera e un numero.')
    if (next !== confirm) return setErr('Le nuove password non coincidono.')
    try {
      await update.mutateAsync({ currentPassword: cur, newPassword: next, email })
      setDone(true); setCur(''); setNext(''); setConfirm('')
    } catch (e) { setErr((e as Error).message) }
  }

  return (
    <div className="settings-section">
      <h2>Sicurezza — Password</h2>
      <form onSubmit={submit}>
        <div className="form-group">
          <label>Password attuale</label>
          <input type="password" value={cur} onChange={(e) => setCur(e.target.value)} autoComplete="current-password" />
        </div>
        <div className="form-group">
          <label>Nuova password</label>
          <input type="password" value={next} onChange={(e) => setNext(e.target.value)} autoComplete="new-password" />
        </div>
        <div className="form-group">
          <label>Conferma nuova password</label>
          <input type="password" value={confirm} onChange={(e) => setConfirm(e.target.value)} autoComplete="new-password" />
        </div>
        <div className="settings-actions">
          <button type="submit" className="btn-primary" disabled={update.isPending}>
            {update.isPending ? 'Salvataggio…' : 'Aggiorna password'}
          </button>
        </div>
        <Saved show={done} text="Password aggiornata correttamente." />
        <ErrMsg msg={err} />
      </form>
    </div>
  )
}

// ─── Dati privati ─────────────────────────────────────────

function PrivateDataSection({ userId }: { userId: string }) {
  const { data: priv, isLoading } = usePrivateSettings(userId)
  const update = useUpdatePrivateSettings()
  const [f, setF] = useState({
    height_cm: '', weight_kg: '', ape_index_cm: '',
    dominant_hand: '', main_shoes: '', uses_kneepad: false, private_training_notes: '',
  })
  const [done, setDone] = useState(false)
  const [err, setErr] = useState<string | null>(null)

  useEffect(() => {
    if (priv) setF({
      height_cm: priv.height_cm != null ? String(priv.height_cm) : '',
      weight_kg: priv.weight_kg != null ? String(priv.weight_kg) : '',
      ape_index_cm: priv.ape_index_cm != null ? String(priv.ape_index_cm) : '',
      dominant_hand: priv.dominant_hand ?? '',
      main_shoes: priv.main_shoes ?? '',
      uses_kneepad: priv.uses_kneepad ?? false,
      private_training_notes: priv.private_training_notes ?? '',
    })
  }, [priv])

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setErr(null); setDone(false)
    try {
      await update.mutateAsync({
        userId,
        values: {
          height_cm: f.height_cm ? Number(f.height_cm) : null,
          weight_kg: f.weight_kg ? Number(f.weight_kg) : null,
          ape_index_cm: f.ape_index_cm ? Number(f.ape_index_cm) : null,
          dominant_hand: (f.dominant_hand || null) as 'left' | 'right' | 'ambi' | null,
          main_shoes: f.main_shoes || null,
          uses_kneepad: f.uses_kneepad,
          private_training_notes: f.private_training_notes || null,
        },
      })
      setDone(true)
    } catch (e) { setErr((e as Error).message) }
  }

  if (isLoading) return <div className="settings-section"><div className="loading-state">Caricamento…</div></div>

  return (
    <>
      <div className="settings-section">
        <h2>Dati privati del climber</h2>
        <p className="settings-hint">Questi dati servono alle tue analisi personali e non sono mai visibili agli altri utenti.</p>
        <form onSubmit={submit}>
          <div className="form-grid">
            <div className="form-group">
              <label>Altezza (cm)</label>
              <input type="number" value={f.height_cm} onChange={(e) => setF((p) => ({ ...p, height_cm: e.target.value }))} />
            </div>
            <div className="form-group">
              <label>Peso (kg)</label>
              <input type="number" step="0.1" value={f.weight_kg} onChange={(e) => setF((p) => ({ ...p, weight_kg: e.target.value }))} />
            </div>
            <div className="form-group">
              <label>Ape index (cm)</label>
              <input type="number" step="0.1" value={f.ape_index_cm} onChange={(e) => setF((p) => ({ ...p, ape_index_cm: e.target.value }))} placeholder="+/- rispetto altezza" />
            </div>
            <div className="form-group">
              <label>Mano dominante</label>
              <select value={f.dominant_hand} onChange={(e) => setF((p) => ({ ...p, dominant_hand: e.target.value }))}>
                <option value="">—</option>
                <option value="right">Destra</option>
                <option value="left">Sinistra</option>
                <option value="ambi">Ambidestro</option>
              </select>
            </div>
            <div className="form-group">
              <label>Scarpetta principale</label>
              <input value={f.main_shoes} onChange={(e) => setF((p) => ({ ...p, main_shoes: e.target.value }))} placeholder="es. Solution" />
            </div>
          </div>
          <label className="settings-toggle">
            <input type="checkbox" checked={f.uses_kneepad} onChange={(e) => setF((p) => ({ ...p, uses_kneepad: e.target.checked }))} />
            <span>Uso il kneepad</span>
          </label>
          <div className="form-group">
            <label>Note allenamento / note fisiche (private)</label>
            <textarea rows={3} value={f.private_training_notes} onChange={(e) => setF((p) => ({ ...p, private_training_notes: e.target.value }))} />
          </div>
          <div className="settings-actions">
            <button type="submit" className="btn-primary" disabled={update.isPending}>
              {update.isPending ? 'Salvataggio…' : 'Salva dati privati'}
            </button>
          </div>
          <Saved show={done} />
          <ErrMsg msg={err} />
        </form>
      </div>
      <InjurySection userId={userId} />
    </>
  )
}

function InjurySection({ userId }: { userId: string }) {
  const { data: injuries } = useInjuryPeriods(userId)
  const create = useCreateInjuryPeriod()
  const del = useDeleteInjuryPeriod()
  const [f, setF] = useState({ start_date: '', end_date: '', label: '', notes: '' })
  const [err, setErr] = useState<string | null>(null)

  async function add(e: React.FormEvent) {
    e.preventDefault()
    setErr(null)
    if (!f.start_date) return setErr('La data di inizio è obbligatoria.')
    try {
      await create.mutateAsync({
        userId,
        values: { start_date: f.start_date, end_date: f.end_date || null, label: f.label || null, notes: f.notes || null },
      })
      setF({ start_date: '', end_date: '', label: '', notes: '' })
    } catch (e) { setErr((e as Error).message) }
  }

  return (
    <div className="settings-section">
      <h2>Periodi di infortunio</h2>
      <p className="settings-hint">Privati. Possono essere usati nei grafici per evidenziare le pause.</p>
      {(injuries ?? []).length > 0 && (
        <ul className="injury-list">
          {injuries!.map((i) => (
            <li key={i.id} className="injury-item">
              <div>
                <strong>{i.label || 'Infortunio'}</strong>
                <span className="injury-dates">{i.start_date}{i.end_date ? ` → ${i.end_date}` : ' → in corso'}</span>
                {i.notes && <p className="injury-notes">{i.notes}</p>}
              </div>
              <button className="btn-danger-outline" onClick={() => del.mutate({ userId, id: i.id })}>Elimina</button>
            </li>
          ))}
        </ul>
      )}
      <form onSubmit={add} className="injury-form">
        <div className="form-grid">
          <div className="form-group">
            <label>Data inizio *</label>
            <input type="date" value={f.start_date} onChange={(e) => setF((p) => ({ ...p, start_date: e.target.value }))} />
          </div>
          <div className="form-group">
            <label>Data fine</label>
            <input type="date" value={f.end_date} onChange={(e) => setF((p) => ({ ...p, end_date: e.target.value }))} />
          </div>
          <div className="form-group">
            <label>Titolo</label>
            <input value={f.label} onChange={(e) => setF((p) => ({ ...p, label: e.target.value }))} placeholder="es. Infortunio pulley" />
          </div>
        </div>
        <div className="form-group">
          <label>Note private</label>
          <textarea rows={2} value={f.notes} onChange={(e) => setF((p) => ({ ...p, notes: e.target.value }))} />
        </div>
        <div className="settings-actions">
          <button type="submit" className="btn-primary" disabled={create.isPending}>
            {create.isPending ? 'Aggiunta…' : 'Aggiungi periodo'}
          </button>
        </div>
        <ErrMsg msg={err} />
      </form>
    </div>
  )
}

// ─── Dati e backup ────────────────────────────────────────

function BackupSection({ userId, username }: { userId: string; username: string }) {
  const [busy, setBusy] = useState<string | null>(null)
  const [err, setErr] = useState<string | null>(null)

  async function run(kind: 'csv' | 'json') {
    setErr(null); setBusy(kind)
    try {
      const data = await exportUserData(userId)
      if (kind === 'csv') {
        const csv = ascentsToCsv(data.ascents as Record<string, unknown>[])
        if (!csv) { setErr('Nessuna ascensione da esportare.'); return }
        downloadFile(`capital-climbing_${username}_ascensioni.csv`, csv, 'text/csv;charset=utf-8')
      } else {
        downloadFile(`capital-climbing_${username}_backup.json`, JSON.stringify(data, null, 2), 'application/json')
      }
    } catch (e) { setErr((e as Error).message) } finally { setBusy(null) }
  }

  return (
    <div className="settings-section">
      <h2>Dati e backup</h2>
      <p className="settings-hint">Esporta i tuoi dati. Niente viene cancellato.</p>
      <div className="settings-actions" style={{ justifyContent: 'flex-start', gap: 10, flexWrap: 'wrap' }}>
        <button className="btn-primary" disabled={busy !== null} onClick={() => run('csv')}>
          {busy === 'csv' ? 'Esporto…' : 'Esporta ascensioni (CSV)'}
        </button>
        <button className="btn-primary" disabled={busy !== null} onClick={() => run('json')}>
          {busy === 'json' ? 'Esporto…' : 'Scarica backup completo (JSON)'}
        </button>
        <Link to="/logbook/import" className="btn-secondary">Importa logbook</Link>
      </div>
      <ErrMsg msg={err} />
    </div>
  )
}

// ─── Zona pericolosa ──────────────────────────────────────

function DangerSection({ userId, username }: { userId: string; username: string }) {
  const del = useSoftDeleteAccount()
  const [open, setOpen] = useState(false)
  const [confirm, setConfirm] = useState('')
  const [err, setErr] = useState<string | null>(null)

  async function doDelete() {
    setErr(null)
    try {
      await del.mutateAsync(userId)
      window.location.href = '/'
    } catch (e) { setErr((e as Error).message) }
  }

  return (
    <div className="settings-section settings-danger">
      <h2>Zona pericolosa</h2>
      <p className="settings-hint">
        Eliminando il profilo, non sarai più visibile agli altri e le tue attività pubbliche verranno nascoste.
        I dati restano recuperabili da un admin (soft delete).
      </p>
      {!open ? (
        <button className="btn-danger" onClick={() => setOpen(true)}>Elimina profilo</button>
      ) : (
        <div className="danger-confirm">
          <p>
            Stai per eliminare il profilo <strong>@{username}</strong>.
            Questa azione può essere irreversibile. Per confermare, scrivi <code>ELIMINA</code> qui sotto.
          </p>
          <input value={confirm} onChange={(e) => setConfirm(e.target.value)} placeholder="ELIMINA" />
          <div className="settings-actions" style={{ justifyContent: 'flex-start', gap: 10 }}>
            <button className="btn-secondary" onClick={() => { setOpen(false); setConfirm('') }}>Annulla</button>
            <button className="btn-danger" disabled={confirm !== 'ELIMINA' || del.isPending} onClick={doDelete}>
              {del.isPending ? 'Eliminazione…' : 'Elimina definitivamente'}
            </button>
          </div>
          <ErrMsg msg={err} />
        </div>
      )}
    </div>
  )
}
