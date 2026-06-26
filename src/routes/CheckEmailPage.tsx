import { Link } from 'react-router-dom'
import '../styles/auth.css'

export default function CheckEmailPage() {
  return (
    <div className="auth-page">
      <div className="auth-box">
        <div className="auth-brand">▲</div>
        <h1 className="auth-title">Controlla la tua email</h1>
        <p className="auth-sub" style={{ marginTop: 12 }}>
          Ti abbiamo inviato un link di conferma.<br />
          Aprilo per attivare il tuo account.
        </p>
        <div className="auth-links" style={{ marginTop: 24 }}>
          <Link to="/login">Torna al login</Link>
        </div>
      </div>
    </div>
  )
}
