import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import type { UserPrivateSettings, InjuryPeriod } from '../../types/database'

// ─── Account: email ───────────────────────────────────────

export function useUpdateEmail() {
  return useMutation({
    mutationFn: async (newEmail: string) => {
      const { error } = await supabase.auth.updateUser({ email: newEmail })
      if (error) {
        if (/already/i.test(error.message))
          throw new Error('Questa email è già associata a un altro account.')
        throw new Error(error.message)
      }
    },
  })
}

// ─── Sicurezza: password ──────────────────────────────────

export function useUpdatePassword() {
  return useMutation({
    mutationFn: async (vars: { currentPassword: string; newPassword: string; email: string }) => {
      // Riautentica con la password attuale prima di cambiarla.
      const { error: reauthError } = await supabase.auth.signInWithPassword({
        email: vars.email,
        password: vars.currentPassword,
      })
      if (reauthError) throw new Error('La password attuale non è corretta.')

      const { error } = await supabase.auth.updateUser({ password: vars.newPassword })
      if (error) throw new Error(error.message)
    },
  })
}

// ─── Dati privati del climber ─────────────────────────────

export function usePrivateSettings(userId: string) {
  return useQuery({
    queryKey: ['private-settings', userId],
    queryFn: async (): Promise<UserPrivateSettings | null> => {
      const { data, error } = await supabase
        .from('user_private_settings')
        .select('*')
        .eq('user_id', userId)
        .maybeSingle()
      if (error) throw error
      return data
    },
    enabled: !!userId,
  })
}

export interface PrivateSettingsValues {
  height_cm?: number | null
  weight_kg?: number | null
  ape_index_cm?: number | null
  dominant_hand?: 'left' | 'right' | 'ambi' | null
  main_shoes?: string | null
  uses_kneepad?: boolean | null
  private_training_notes?: string | null
}

export function useUpdatePrivateSettings() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (vars: { userId: string; values: PrivateSettingsValues }) => {
      const { error } = await supabase
        .from('user_private_settings')
        .upsert({ user_id: vars.userId, ...vars.values }, { onConflict: 'user_id' })
      if (error) throw error
    },
    onSuccess: (_, vars) => {
      qc.invalidateQueries({ queryKey: ['private-settings', vars.userId] })
    },
  })
}

// ─── Periodi di infortunio ────────────────────────────────

export function useInjuryPeriods(userId: string) {
  return useQuery({
    queryKey: ['injury-periods', userId],
    queryFn: async (): Promise<InjuryPeriod[]> => {
      const { data, error } = await supabase
        .from('injury_periods')
        .select('*')
        .eq('user_id', userId)
        .order('start_date', { ascending: false })
      if (error) throw error
      return data ?? []
    },
    enabled: !!userId,
  })
}

export interface InjuryValues {
  start_date: string
  end_date?: string | null
  label?: string | null
  notes?: string | null
}

export function useCreateInjuryPeriod() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (vars: { userId: string; values: InjuryValues }) => {
      const { error } = await supabase
        .from('injury_periods')
        .insert({ user_id: vars.userId, ...vars.values })
      if (error) throw error
    },
    onSuccess: (_, vars) => qc.invalidateQueries({ queryKey: ['injury-periods', vars.userId] }),
  })
}

export function useUpdateInjuryPeriod() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (vars: { userId: string; id: string; values: InjuryValues }) => {
      const { error } = await supabase
        .from('injury_periods')
        .update(vars.values)
        .eq('id', vars.id)
      if (error) throw error
    },
    onSuccess: (_, vars) => qc.invalidateQueries({ queryKey: ['injury-periods', vars.userId] }),
  })
}

export function useDeleteInjuryPeriod() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (vars: { userId: string; id: string }) => {
      const { error } = await supabase.from('injury_periods').delete().eq('id', vars.id)
      if (error) throw error
    },
    onSuccess: (_, vars) => qc.invalidateQueries({ queryKey: ['injury-periods', vars.userId] }),
  })
}

// ─── Export dati ──────────────────────────────────────────

export interface UserExport {
  profile: unknown
  ascents: unknown[]
  projects: unknown[]
  sessions: unknown[]
  private_settings: unknown
  injury_periods: unknown[]
  exported_at: string
}

export async function exportUserData(userId: string): Promise<UserExport> {
  const [profile, ascents, projects, sessions, priv, injuries] = await Promise.all([
    supabase.from('profiles').select('*').eq('id', userId).maybeSingle(),
    supabase.from('ascents').select('*').eq('user_id', userId),
    supabase.from('projects').select('*').eq('user_id', userId),
    supabase.from('sessions').select('*').eq('user_id', userId),
    supabase.from('user_private_settings').select('*').eq('user_id', userId).maybeSingle(),
    supabase.from('injury_periods').select('*').eq('user_id', userId),
  ])
  return {
    profile: profile.data,
    ascents: ascents.data ?? [],
    projects: projects.data ?? [],
    sessions: sessions.data ?? [],
    private_settings: priv.data,
    injury_periods: injuries.data ?? [],
    exported_at: new Date().toISOString(),
  }
}

// Converte le ascensioni in CSV scaricabile.
export function ascentsToCsv(ascents: Record<string, unknown>[]): string {
  if (ascents.length === 0) return ''
  const cols = Object.keys(ascents[0])
  const escape = (v: unknown) => {
    const s = v == null ? '' : String(v)
    return /[",\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s
  }
  const header = cols.join(',')
  const rows = ascents.map((a) => cols.map((c) => escape(a[c])).join(','))
  return [header, ...rows].join('\n')
}

export function downloadFile(filename: string, content: string, mime: string) {
  const blob = new Blob([content], { type: mime })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = filename
  document.body.appendChild(a)
  a.click()
  document.body.removeChild(a)
  URL.revokeObjectURL(url)
}

// ─── Zona pericolosa: soft delete ─────────────────────────

export function useSoftDeleteAccount() {
  return useMutation({
    mutationFn: async (userId: string) => {
      const now = new Date().toISOString()
      const { error } = await supabase
        .from('profiles')
        .update({ is_deleted: true, deleted_at: now, delete_requested_at: now, is_public: false })
        .eq('id', userId)
      if (error) throw error
      await supabase.auth.signOut()
    },
  })
}
