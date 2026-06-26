import { useEffect } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import type { Resolver } from 'react-hook-form'
import { Link } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'
import { useOwnProfile, useUpdateProfile } from '../features/users/hooks'
import '../styles/users.css'
import '../styles/admin.css'

const optStr = z
  .union([z.string(), z.null(), z.undefined()])
  .transform((v): string | null => (v == null || v === '' ? null : v))

const optNum = z
  .union([z.number(), z.nan(), z.null(), z.undefined()])
  .transform((v): number | null => {
    if (v == null || (typeof v === 'number' && isNaN(v))) return null
    return v
  })

const profileSchema = z.object({
  display_name: z.string().min(1, 'Nome richiesto').max(60),
  bio: optStr,
  city: optStr,
  country: optStr,
  climbing_since: optNum,
  preferred_style: optStr,
})

type ProfileSchema = z.infer<typeof profileSchema>

export default function SettingsPage() {
  const { user } = useAuth()
  const { data: profile, isLoading } = useOwnProfile(user?.id ?? '')
  const updateProfile = useUpdateProfile()

  const { register, handleSubmit, reset, formState: { errors, isDirty } } = useForm<ProfileSchema>({
    resolver: zodResolver(profileSchema) as Resolver<ProfileSchema>,
    defaultValues: {
      display_name: '',
      bio: '',
      city: '',
      country: '',
      climbing_since: undefined,
      preferred_style: '',
    },
  })

  useEffect(() => {
    if (profile) {
      reset({
        display_name: profile.display_name ?? '',
        bio: profile.bio ?? '',
        city: profile.city ?? '',
        country: profile.country ?? '',
        climbing_since: profile.climbing_since ?? undefined,
        preferred_style: profile.preferred_style ?? '',
      })
    }
  }, [profile, reset])

  async function onSubmit(data: ProfileSchema) {
    if (!user) return
    await updateProfile.mutateAsync({
      userId: user.id,
      values: {
        display_name: data.display_name,
        bio: data.bio,
        city: data.city,
        country: data.country,
        climbing_since: data.climbing_since,
        preferred_style: data.preferred_style,
      },
    })
    reset(data)
  }

  if (!user) return null
  if (isLoading) return <div className="loading-state">Caricamento…</div>

  return (
    <div className="settings-page">
      <h1>Impostazioni</h1>
      {profile && (
        <p style={{ fontSize: 13, color: '#8a9a87', margin: '0 0 20px' }}>
          Profilo pubblico:{' '}
          <Link to={`/u/${profile.username}`} style={{ color: '#2d5a27' }}>@{profile.username}</Link>
        </p>
      )}

      <div className="settings-email-row">
        <strong>Email:</strong> {user.email}
        <span style={{ marginLeft: 8, fontSize: 11 }}>(non modificabile qui)</span>
      </div>

      <form onSubmit={handleSubmit(onSubmit)}>
        <div className="settings-section">
          <h2>Profilo</h2>

          <div className={`form-group${errors.display_name ? ' error' : ''}`}>
            <label>Nome visualizzato *</label>
            <input {...register('display_name')} placeholder="Come vuoi apparire agli altri" />
            {errors.display_name && <span className="form-error">{errors.display_name.message}</span>}
          </div>

          <div className="form-group">
            <label>Bio</label>
            <textarea {...register('bio')} rows={3} placeholder="Qualcosa su di te…" />
          </div>

          <div className="form-grid">
            <div className="form-group">
              <label>Città</label>
              <input {...register('city')} placeholder="es. Roma" />
            </div>
            <div className="form-group">
              <label>Paese</label>
              <input {...register('country')} placeholder="es. Italia" />
            </div>
            <div className="form-group">
              <label>Scala dal (anno)</label>
              <input
                type="number"
                min={1950}
                max={new Date().getFullYear()}
                {...register('climbing_since', { valueAsNumber: true })}
                placeholder="es. 2010"
              />
            </div>
            <div className="form-group">
              <label>Stile preferito</label>
              <select {...register('preferred_style')}>
                <option value="">—</option>
                <option value="Sportiva">Sportiva</option>
                <option value="Boulder">Boulder</option>
                <option value="Trad">Trad</option>
                <option value="Multipitch">Multipitch</option>
                <option value="Mista">Mista</option>
              </select>
            </div>
          </div>
        </div>

        <div style={{ display: 'flex', gap: 10, justifyContent: 'flex-end' }}>
          <button
            type="submit"
            className="btn-primary"
            disabled={updateProfile.isPending || !isDirty}
          >
            {updateProfile.isPending ? 'Salvataggio…' : 'Salva modifiche'}
          </button>
        </div>

        {updateProfile.isSuccess && !isDirty && (
          <div className="settings-saved">✓ Profilo aggiornato!</div>
        )}
        {updateProfile.isError && (
          <div className="admin-error" style={{ marginTop: 10 }}>
            {(updateProfile.error as Error).message}
          </div>
        )}
      </form>
    </div>
  )
}
