export type Visibility = 'public' | 'private'
export type Role = 'user' | 'admin'
export type AscentStatus = 'completed' | 'attempted' | 'project'
export type AttemptType = 'onsight' | 'flash' | 'second' | 'third' | 'four_plus' | 'redpoint'
export type ProjectStatus = 'active' | 'paused' | 'completed' | 'abandoned'
export type Priority = 'high' | 'medium' | 'low'
export type ImportStatus = 'pending' | 'processing' | 'completed' | 'failed'
export type ImportRowStatus = 'pending' | 'valid' | 'invalid' | 'imported'

export interface Profile {
  id: string
  username: string
  display_name: string
  avatar_url: string | null
  bio: string | null
  country: string | null
  city: string | null
  climbing_since: number | null
  preferred_style: string | null
  created_at: string
  updated_at: string
}

export interface UserRole {
  user_id: string
  role: Role
  created_at: string
}

export interface Source {
  id: string
  name: string
  url: string | null
  license: string | null
  permission_status: string
  can_publish: boolean
  can_use_for_statistics: boolean
  attribution: string | null
  notes: string | null
  created_at: string
}

export interface Country {
  id: string
  name: string
  iso2: string
  slug: string
  created_at: string
  updated_at: string
}

export interface Region {
  id: string
  country_id: string
  name: string
  normalized_name: string
  slug: string
  created_at: string
  updated_at: string
}

export interface Area {
  id: string
  region_id: string
  name: string
  normalized_name: string
  slug: string
  area_type: string
  description: string | null
  created_at: string
  updated_at: string
}

export interface Crag {
  id: string
  name: string
  normalized_name: string
  slug: string | null
  aliases: string[]
  country: string
  country_id: string | null
  region: string | null
  region_id: string | null
  area_id: string | null
  municipality: string | null
  province: string | null
  latitude: number | null
  longitude: number | null
  altitude_m: number | null
  rock_type: string | null
  parking_notes: string | null
  access_notes: string | null
  approach_minutes: number | null
  approach_distance_km: number | null
  orientation: string | null
  best_seasons: string[] | null
  rainproof: boolean
  services: Record<string, unknown>
  access_status: string
  last_verified_at: string | null
  created_at: string
  updated_at: string
}

export interface Sector {
  id: string
  crag_id: string
  parent_sector_id: string | null
  name: string
  normalized_name: string
  slug: string | null
  aliases: string[]
  description: string | null
  orientation: string | null
  approach_notes: string | null
  sort_order: number
  created_at: string
  updated_at: string
}

export interface Route {
  id: string
  crag_id: string | null
  sector_id: string | null
  name: string
  normalized_name: string
  slug: string | null
  official_grade: string | null
  grade_numeric: number | null
  community_grade_raw: string | null
  community_grade_numeric: number | null
  length_m: number | null
  pitches: number
  bolts: number | null
  angle: string | null
  route_type: string
  rock_type: string | null
  first_ascent: string | null
  bolter: string | null
  description: string | null
  notes_public: string | null
  safety_notes: string | null
  beauty_avg: number | null
  repetitions_count: number
  source: string | null
  source_url: string | null
  line_order: number | null
  position_label: string | null
  created_at: string
  updated_at: string
}

export interface Ascent {
  id: string
  user_id: string
  route_id: string
  session_id: string | null
  date: string
  status: AscentStatus
  attempt_type: AttemptType | null
  ascent_style: string | null
  attempt_count: number | null
  attempt_bucket: string | null
  legacy_attempt_type: string | null
  needs_review: boolean
  route_name_snapshot: string | null
  crag_name_snapshot: string | null
  sector_name_snapshot: string | null
  grade_snapshot: string | null
  community_grade_snapshot: string | null
  grade_at_ascent: string | null
  grade_numeric_at_ascent: number | null
  score: number | null
  quality: number | null
  personal_grade: string | null
  kneepad_used: boolean | null
  effort: number | null
  notes: string | null
  visibility: Visibility
  created_at: string
  updated_at: string
}

export interface Project {
  id: string
  user_id: string
  route_id: string
  opened_date: string | null
  last_session_date: string | null
  priority: Priority
  status: ProjectStatus
  sessions_count: number
  attempts_count: number
  progress: number
  high_point: string | null
  moves_solved: string | null
  moves_missing: string | null
  next_strategy: string | null
  beta_notes: string | null
  visibility: Visibility
  created_at: string
  updated_at: string
}

export interface Session {
  id: string
  user_id: string
  crag_id: string | null
  sector_id: string | null
  date: string
  temperature: number | null
  humidity: number | null
  wind: string | null
  conditions: string | null
  rock_condition: string | null
  partner: string | null
  sleep_quality: number | null
  rest_days: number | null
  session_rpe: number | null
  notes: string | null
  visibility: Visibility
  created_at: string
  updated_at: string
}

export interface Attempt {
  id: string
  user_id: string
  session_id: string | null
  route_id: string
  attempt_number: number
  result: 'send' | 'attempt' | 'top_rope' | null
  high_point: string | null
  fall_move: string | null
  beta_used: string | null
  kneepad_used: boolean | null
  shoes: string | null
  effort: number | null
  rest_minutes: number | null
  notes: string | null
  visibility: Visibility
  created_at: string
}

export interface UserRouteNote {
  id: string
  user_id: string
  route_id: string
  hold_profile: Record<string, unknown>
  movement_profile: Record<string, unknown>
  style_profile: Record<string, unknown>
  crux: string | null
  rests: string | null
  main_beta: string | null
  alternative_beta: string | null
  kneepad_data: Record<string, unknown>
  equipment_data: Record<string, unknown>
  safety_notes: string | null
  visibility: Visibility
  created_at: string
  updated_at: string
}

export interface ImportJob {
  id: string
  created_by: string
  filename: string
  status: ImportStatus
  total_rows: number
  valid_rows: number
  invalid_rows: number
  created_at: string
  completed_at: string | null
}

export interface ImportRow {
  id: string
  import_job_id: string
  row_number: number
  raw_data: Record<string, unknown>
  normalized_data: Record<string, unknown>
  status: ImportRowStatus
  errors: unknown[]
  needs_review: boolean
  created_at: string
}

export type ExternalSourceEntityType = 'crag' | 'sector' | 'route'

export interface ExternalSource {
  id: string
  entity_type: ExternalSourceEntityType
  entity_id: string
  source_name: string
  source_url: string | null
  external_id: string | null
  raw_name: string | null
  raw_payload: Record<string, unknown> | null
  imported_at: string
}
