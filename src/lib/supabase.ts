import { createClient } from '@supabase/supabase-js'

// In produzione le VITE_* sono iniettate al build. Nei test (vitest) non
// esistono: fallback dummy così createClient non lancia "supabaseUrl is
// required" a import-time (i test non fanno vere chiamate di rete).
const supabaseUrl = (import.meta.env.VITE_SUPABASE_URL as string) || 'http://localhost:54321'
const supabaseKey = (import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY as string) || 'test-anon-key'

export const supabase = createClient(supabaseUrl, supabaseKey)
