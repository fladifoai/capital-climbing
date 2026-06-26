import { useState } from 'react'
import { Link } from 'react-router-dom'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { supabase } from '../lib/supabase'
import { forgotPasswordSchema, type ForgotPasswordData } from '../features/auth/schemas'
import '../styles/auth.css'

export default function ForgotPasswordPage() {
  const [sent, setSent] = useState(false)
  const [loading, setLoading] = useState(false)

  const { register, handleSubmit, formState: { errors } } = useForm<ForgotPasswordData>({
    resolver: zodResolver(forgotPasswordSchema),
  })

  async function onSubmit(data: ForgotPasswordData) {
    setLoading(true)
    await supabase.auth.resetPasswordForEmail(data.email, {
      redirectTo: `${window.location.origin}${import.meta.env.BASE_URL}#/reset-password`,
    })
    setSent(true)
    setLoading(false)
  }

  return (
    <div className="auth-page">
      <div className="auth-box">
        <div className="auth-brand">▲</div>
        <h1 className="auth-title">Capital Climbing</h1>

        {sent ? (
          <>
            <p className="auth-sub">Email inviata! Controlla la tua casella di posta.</p>
            <div className="auth-links" style={{ marginTop: 24 }}>
              <Link to="/login">Torna al login</Link>
            </div>
          </>
        ) : (
          <>
            <p className="auth-sub">Inserisci la tua email per ricevere il link di recupero</p>
            <form onSubmit={handleSubmit(onSubmit)} className="auth-form">
              <div className="field">
                <label>Email</label>
                <input type="email" {...register('email')} placeholder="la@tua.email" />
                {errors.email && <span className="field-error">{errors.email.message}</span>}
              </div>
              <button type="submit" className="btn-auth" disabled={loading}>
                {loading ? 'Invio…' : 'Invia link di recupero'}
              </button>
            </form>
            <div className="auth-links">
              <Link to="/login">Torna al login</Link>
            </div>
          </>
        )}
      </div>
    </div>
  )
}
