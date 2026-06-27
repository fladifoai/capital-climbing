import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { supabase } from '../lib/supabase'
import { registerSchema, type RegisterData } from '../features/auth/schemas'
import '../styles/auth.css'

export default function RegisterPage() {
  const navigate = useNavigate()
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const { register, handleSubmit, formState: { errors } } = useForm<RegisterData>({
    resolver: zodResolver(registerSchema),
  })

  async function onSubmit(data: RegisterData) {
    setLoading(true)
    setError('')

    const { error } = await supabase.auth.signUp({
      email: data.email,
      password: data.password,
      options: {
        data: {
          username: data.username.toLowerCase(),
          display_name: data.display_name,
        },
        emailRedirectTo: `${window.location.origin}${import.meta.env.BASE_URL}#/dashboard`,
      },
    })

    if (error) {
      setError(error.message)
      setLoading(false)
    } else {
      navigate('/check-email')
    }
  }

  return (
    <div className="auth-page">
      <div className="auth-box">
        <div className="auth-brand">▲</div>
        <h1 className="auth-title">Capital Climbing</h1>
        <p className="auth-sub">Crea il tuo account</p>

        <div className="auth-tabs">
          <Link to="/login" className="auth-tab">Accedi</Link>
          <button type="button" className="auth-tab active">Registrati</button>
        </div>

        <form onSubmit={handleSubmit(onSubmit)} className="auth-form">
          <div className="field">
            <label>Username</label>
            <input {...register('username')} placeholder="es. mario_rossi" />
            {errors.username && <span className="field-error">{errors.username.message}</span>}
          </div>

          <div className="field">
            <label>Nome visualizzato</label>
            <input {...register('display_name')} placeholder="es. Mario Rossi" />
            {errors.display_name && <span className="field-error">{errors.display_name.message}</span>}
          </div>

          <div className="field">
            <label>Email</label>
            <input type="email" {...register('email')} placeholder="la@tua.email" />
            {errors.email && <span className="field-error">{errors.email.message}</span>}
          </div>

          <div className="field">
            <label>Password</label>
            <input type="password" {...register('password')} placeholder="Minimo 6 caratteri" />
            {errors.password && <span className="field-error">{errors.password.message}</span>}
          </div>

          {error && <div className="auth-error">{error}</div>}

          <button type="submit" className="btn-auth" disabled={loading}>
            {loading ? 'Registrazione…' : 'Crea account'}
          </button>
        </form>

        <div className="auth-links">
          <Link to="/login">Hai già un account?</Link>
          <span>·</span>
          <Link to="/login">Accedi</Link>
        </div>
      </div>
    </div>
  )
}
