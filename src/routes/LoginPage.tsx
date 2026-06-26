import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { supabase } from '../lib/supabase'
import { loginSchema, type LoginData } from '../features/auth/schemas'
import '../styles/auth.css'

export default function LoginPage() {
  const navigate = useNavigate()
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const { register, handleSubmit, formState: { errors } } = useForm<LoginData>({
    resolver: zodResolver(loginSchema),
  })

  async function onSubmit(data: LoginData) {
    setLoading(true)
    setError('')
    const { error } = await supabase.auth.signInWithPassword(data)
    if (error) {
      setError('Email o password errati')
      setLoading(false)
    } else {
      navigate('/dashboard')
    }
  }

  return (
    <div className="auth-page">
      <div className="auth-box">
        <div className="auth-brand">▲</div>
        <h1 className="auth-title">Capital Climbing</h1>
        <p className="auth-sub">Accedi al tuo account</p>

        <form onSubmit={handleSubmit(onSubmit)} className="auth-form">
          <div className="field">
            <label>Email</label>
            <input type="email" {...register('email')} placeholder="la@tua.email" />
            {errors.email && <span className="field-error">{errors.email.message}</span>}
          </div>

          <div className="field">
            <label>Password</label>
            <input type="password" {...register('password')} placeholder="••••••••" />
            {errors.password && <span className="field-error">{errors.password.message}</span>}
          </div>

          {error && <div className="auth-error">{error}</div>}

          <button type="submit" className="btn-auth" disabled={loading}>
            {loading ? 'Accesso…' : 'Accedi'}
          </button>
        </form>

        <div className="auth-links">
          <Link to="/forgot-password">Password dimenticata?</Link>
          <span>·</span>
          <Link to="/register">Crea account</Link>
        </div>
      </div>
    </div>
  )
}
