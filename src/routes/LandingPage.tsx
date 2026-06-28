import { useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'
import '../styles/landing.css'

const FEATURES = [
  {
    icon: '🗺️',
    title: 'Catalogo tecnico',
    desc: 'Falesie, settori e vie organizzati per regione, area e grado. Non una lista piatta.',
  },
  {
    icon: '📋',
    title: 'Logbook personale',
    desc: 'Ascensioni, tentativi, sessioni, progetti e note. Ogni dato personale resta legato al tuo account.',
  },
  {
    icon: '📈',
    title: 'Analisi per migliorare',
    desc: 'Grafici, progressione, distribuzione per grado, OS/Flash/RP, volume, progetti. Capisci come stai crescendo.',
  },
  {
    icon: '🔒',
    title: 'Privacy per default',
    desc: 'I tuoi dati personali sono privati. Decidi tu cosa condividere sul profilo pubblico.',
  },
]

const STEPS = [
  {
    icon: '🔍',
    title: 'Cerca o importa una falesia',
    desc: 'Trova la falesia nel catalogo o importa le tue falesie con un file CSV.',
  },
  {
    icon: '🧗',
    title: 'Seleziona la via',
    desc: 'Cerca la via per nome o grado. Se non esiste, l\'admin può aggiungerla al catalogo.',
  },
  {
    icon: '✍️',
    title: 'Registra salita o sessione',
    desc: 'Aggiungi ascensione, sessione o progetto con tutti i dettagli che vuoi.',
  },
  {
    icon: '📊',
    title: 'Analizza progressione',
    desc: 'Visualizza statistiche, grafici e la tua piramide dei gradi in tempo reale.',
  },
]

export default function LandingPage() {
  const { user } = useAuth()
  const [menuOpen, setMenuOpen] = useState(false)

  const ctaTo = user ? '/home' : '/register'
  const ctaLabel = user ? 'Vai alla Home →' : 'Inizia ora — è gratis'

  function closeMenu() { setMenuOpen(false) }

  return (
    <div className="landing-page">
      {/* Header */}
      <header className="landing-header">
        <Link to="/" className="landing-logo">
          <span className="landing-logo-mark">▲</span>
          <span className="landing-logo-name">Capital Climbing</span>
        </Link>

        <nav className="landing-nav">
          <Link to="/explore" className="landing-nav-link">Esplora</Link>
          <a href="#funzionalita" className="landing-nav-link">Funzionalità</a>
          <a href="#come-funziona" className="landing-nav-link">Come funziona</a>
          <a href="#privacy" className="landing-nav-link">Privacy</a>
        </nav>

        <div className="landing-header-actions">
          <Link to="/login" className="btn-landing-login">Accedi</Link>
          <Link to={ctaTo} className="btn-landing-cta">{user ? 'Dashboard' : 'Inizia ora'}</Link>
        </div>

        <button
          className={`landing-hamburger${menuOpen ? ' open' : ''}`}
          aria-label="Menu"
          aria-expanded={menuOpen}
          onClick={() => setMenuOpen(v => !v)}
        >
          <span /><span /><span />
        </button>
      </header>

      {/* Mobile nav overlay */}
      {menuOpen && (
        <div className="landing-mobile-nav" onClick={closeMenu}>
          <Link to="/explore" className="landing-mobile-nav-link" onClick={closeMenu}>Esplora</Link>
          <a href="#funzionalita" className="landing-mobile-nav-link" onClick={closeMenu}>Funzionalità</a>
          <a href="#come-funziona" className="landing-mobile-nav-link" onClick={closeMenu}>Come funziona</a>
          <a href="#privacy" className="landing-mobile-nav-link" onClick={closeMenu}>Privacy</a>
          <div className="landing-mobile-nav-actions">
            <Link to="/login" className="btn-landing-login" onClick={closeMenu}>Accedi</Link>
            <Link to={ctaTo} className="btn-landing-cta" onClick={closeMenu}>{user ? 'Dashboard' : 'Inizia ora'}</Link>
          </div>
        </div>
      )}


      {/* Hero */}
      <section className="landing-hero">
        <div className="landing-hero-left">
          <div className="landing-hero-badge">
            ▲ Per climber veri
          </div>
          <h1 className="landing-hero-title">
            Il diario tecnico per la tua <span>arrampicata</span>.
          </h1>
          <p className="landing-hero-sub">
            Registra vie, falesie, sessioni e progetti. Analizza la tua progressione con statistiche pensate per climber veri.
          </p>
          <div className="landing-hero-actions">
            <Link to="/explore" className="btn-hero-primary">
              Esplora le falesie
            </Link>
            <Link to={ctaTo} className="btn-hero-secondary">
              {ctaLabel}
            </Link>
          </div>
        </div>

        {/* Preview mock — dati demo, non reali */}
        <div className="landing-hero-preview">
          <div className="preview-kpi-card">
            <div className="preview-kpi-val">124</div>
            <div className="preview-kpi-label">Vie demo</div>
          </div>
          <div className="preview-kpi-card">
            <div className="preview-kpi-val">7b</div>
            <div className="preview-kpi-label">Grado max demo</div>
          </div>
          <div className="preview-chart-card">
            <div className="preview-chart-title">Progressione gradi (demo)</div>
            <div className="preview-chart-bars">
              {[20,35,42,48,55,60,68,74,80,87,92,95].map((h, i) => (
                <div
                  key={i}
                  className="preview-chart-bar"
                  style={{ height: `${h}%` }}
                />
              ))}
            </div>
          </div>
          <div className="preview-ascent-card">
            <div className="preview-ascent-dot" />
            <div>
              <div className="preview-ascent-text">Spigolo Tecnico · 7a</div>
              <div className="preview-ascent-sub">Monte Demo · On-sight · ieri</div>
            </div>
          </div>
          <div className="preview-kpi-card">
            <div className="preview-kpi-val">61%</div>
            <div className="preview-kpi-label">OS + Flash demo</div>
          </div>
          <div className="preview-kpi-card">
            <div className="preview-kpi-val">4</div>
            <div className="preview-kpi-label">Progetti demo</div>
          </div>
        </div>
      </section>

      <div className="landing-divider" />

      {/* Funzionalità */}
      <section className="landing-section" id="funzionalita">
        <div className="landing-section-label">Funzionalità</div>
        <h2 className="landing-section-title">Tutto quello che ti serve per capire come stai scalando.</h2>
        <p className="landing-section-sub">
          Niente di superfluo. Solo gli strumenti che servono a un climber che vuole migliorare.
        </p>
        <div className="landing-features-grid">
          {FEATURES.map(f => (
            <div key={f.title} className="landing-feature-card">
              <div className="landing-feature-icon">{f.icon}</div>
              <div className="landing-feature-title">{f.title}</div>
              <div className="landing-feature-desc">{f.desc}</div>
            </div>
          ))}
        </div>
      </section>

      <div className="landing-divider" />

      {/* Not a social */}
      <section className="landing-section">
        <div className="landing-not-social">
          <div className="landing-section-label" style={{ textAlign: 'center' }}>Filosofia</div>
          <div className="landing-not-social-title">
            Non è un social network.
          </div>
          <p className="landing-not-social-sub">
            Capital Climbing non è un feed, non è una classifica e non è un social.<br />
            È uno strumento personale per capire come stai scalando.
          </p>
          <div className="landing-not-social-badges">
            {['No ranking pubblico', 'No feed', 'No like', 'No follower'].map(b => (
              <span key={b} className="landing-badge">✕ {b}</span>
            ))}
          </div>
        </div>
      </section>

      <div className="landing-divider" />

      {/* Come funziona */}
      <section className="landing-section" id="come-funziona">
        <div className="landing-section-label">Come funziona</div>
        <h2 className="landing-section-title">In 4 passi.</h2>
        <p className="landing-section-sub">
          Semplice da usare, potente nei dati.
        </p>
        <div className="landing-steps-grid">
          {STEPS.map((s, i) => (
            <div key={s.title} className="landing-step">
              <div className="landing-step-num">{i + 1}</div>
              <div className="landing-step-icon">{s.icon}</div>
              <div className="landing-step-title">{s.title}</div>
              <div className="landing-step-desc">{s.desc}</div>
            </div>
          ))}
        </div>
      </section>

      <div className="landing-divider" />

      {/* Privacy */}
      <section className="landing-section" id="privacy">
        <div className="landing-privacy">
          <div>
            <div className="landing-section-label">Privacy</div>
            <h2 className="landing-section-title" style={{ fontSize: 'clamp(22px,3vw,32px)' }}>
              I tuoi dati restano tuoi.
            </h2>
            <p className="landing-section-sub">
              Decidi cosa tenere privato e cosa mostrare sul profilo. I tuoi dati tecnici, note private e beta personali non vengono mai pubblicati senza permesso.
            </p>
          </div>
          <div className="landing-privacy-badges">
            <div className="landing-privacy-badge">
              <span className="landing-privacy-badge-icon">🔒</span>
              Dati privati per default
            </div>
            <div className="landing-privacy-badge">
              <span className="landing-privacy-badge-icon">👤</span>
              Profilo pubblico opzionale
            </div>
            <div className="landing-privacy-badge">
              <span className="landing-privacy-badge-icon">📝</span>
              Note personali protette
            </div>
            <div className="landing-privacy-badge">
              <span className="landing-privacy-badge-icon">⚖️</span>
              Nessun ranking pubblico
            </div>
          </div>
        </div>
      </section>

      <div className="landing-divider" />

      {/* CTA finale */}
      <section className="landing-cta-final">
        <h2 className="landing-cta-final-title">
          Pronto a capire davvero come stai scalando?
        </h2>
        <p className="landing-cta-final-sub">
          Esplora il catalogo pubblico subito, oppure crea un account per tracciare le tue salite.
        </p>
        <div className="landing-cta-final-actions">
          <Link to="/explore" className="btn-hero-primary">
            Esplora le falesie
          </Link>
          <Link to={ctaTo} className="btn-hero-secondary">
            {ctaLabel}
          </Link>
        </div>
      </section>

      {/* Footer */}
      <footer>
        <div className="landing-divider" />
        <div className="landing-footer">
          <span className="landing-footer-copy">© 2026 Capital Climbing</span>
          <div className="landing-footer-links">
            <Link to="/explore" className="landing-footer-link">Esplora</Link>
            <Link to="/login" className="landing-footer-link">Accedi</Link>
            <Link to="/register" className="landing-footer-link">Registrati</Link>
          </div>
        </div>
      </footer>
    </div>
  )
}
