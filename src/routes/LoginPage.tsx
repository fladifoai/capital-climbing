import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { supabase } from '../lib/supabase'
import { loginSchema, forgotPasswordSchema, type LoginData, type ForgotPasswordData } from '../features/auth/schemas'
import '../styles/auth.css'

type Mode = 'login' | 'forgot'

export default function LoginPage() {
  const navigate = useNavigate()
  const [mode, setMode] = useState<Mode>('login')
  const [rememberMe, setRememberMe] = useState(false)
  const [loginError, setLoginError] = useState('')
  const [loginLoading, setLoginLoading] = useState(false)
  const [forgotSent, setForgotSent] = useState(false)
  const [forgotLoading, setForgotLoading] = useState(false)

  const loginForm = useForm<LoginData>({ resolver: zodResolver(loginSchema) })
  const forgotForm = useForm<ForgotPasswordData>({ resolver: zodResolver(forgotPasswordSchema) })

  async function onLogin(data: LoginData) {
    setLoginLoading(true)
    setLoginError('')
    const { error } = await supabase.auth.signInWithPassword(data)
    if (error) {
      setLoginError('Email o password errati')
      setLoginLoading(false)
    } else {
      if (rememberMe) {
        localStorage.setItem('cc_session_type', 'persistent')
        sessionStorage.removeItem('cc_session_only')
      } else {
        localStorage.setItem('cc_session_type', 'session')
        sessionStorage.setItem('cc_session_only', '1')
      }
      navigate('/dashboard')
    }
  }

  async function onForgot(data: ForgotPasswordData) {
    setForgotLoading(true)
    await supabase.auth.resetPasswordForEmail(data.email, {
      redirectTo: `${window.location.origin}${import.meta.env.BASE_URL}#/reset-password`,
    })
    setForgotSent(true)
    setForgotLoading(false)
  }

  function backToLogin() {
    setMode('login')
    setForgotSent(false)
    forgotForm.reset()
  }

  return (
    <div className="auth-page">
      <div className="auth-box">
        <div className="auth-brand">▲</div>
        <h1 className="auth-title">Capital Climbing</h1>

        {mode === 'login' ? (
          <>
            <p className="auth-sub">Accedi al tuo account</p>

            <div className="auth-tabs">
              <button type="button" className="auth-tab active">Accedi</button>
              <Link to="/register" className="auth-tab">Registrati</Link>
            </div>

            <form onSubmit={loginForm.handleSubmit(onLogin)} className="auth-form">
              <div className="field">
                <label>Email</label>
                <input type="email" {...loginForm.register('email')} placeholder="la@tua.email" />
                {loginForm.formState.errors.email && (
                  <span className="field-error">{loginForm.formState.errors.email.message}</span>
                )}
              </div>

              <div className="field">
                <label>Password</label>
                <input type="password" {...loginForm.register('password')} placeholder="••••••••" />
                {loginForm.formState.errors.password && (
                  <span className="field-error">{loginForm.formState.errors.password.message}</span>
                )}
              </div>

              <div className="auth-row">
                <label className="auth-remember">
                  <input
                    type="checkbox"
                    checked={rememberMe}
                    onChange={e => setRememberMe(e.target.checked)}
                  />
                  Ricordami
                </label>
                <button type="button" className="auth-link-btn" onClick={() => setMode('forgot')}>
                  Password dimenticata?
                </button>
              </div>

              {loginError && <div className="auth-error">{loginError}</div>}

              <button type="submit" className="btn-auth" disabled={loginLoading}>
                {loginLoading ? 'Accesso…' : 'Accedi'}
              </button>
            </form>
          </>
        ) : (
          <>
            <p className="auth-sub">Recupero password</p>

            {forgotSent ? (
              <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
                <div className="auth-success">
                  Email inviata! Controlla la tua casella di posta per il link di recupero.
                </div>
                <button type="button" className="btn-auth" onClick={backToLogin}>
                  Torna al login
                </button>
              </div>
            ) : (
              <form onSubmit={forgotForm.handleSubmit(onForgot)} className="auth-form">
                <div className="field">
                  <label>Email</label>
                  <input type="email" {...forgotForm.register('email')} placeholder="la@tua.email" />
                  {forgotForm.formState.errors.email && (
                    <span className="field-error">{forgotForm.formState.errors.email.message}</span>
                  )}
                </div>

                <button type="submit" className="btn-auth" disabled={forgotLoading}>
                  {forgotLoading ? 'Invio…' : 'Invia link di recupero'}
                </button>

                <button type="button" className="auth-link-btn auth-link-btn--center" onClick={backToLogin}>
                  ← Torna al login
                </button>
              </form>
            )}
          </>
        )}
      </div>
    </div>
  )
}
