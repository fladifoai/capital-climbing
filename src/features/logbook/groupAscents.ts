import type { AscentWithRoute } from './hooks'

// Logbook pulito: UNA riga per via. Le ripetizioni non creano righe nuove,
// confluiscono nella timeline della via e nei conteggi (ripetizioni/sessioni).

export type LogbookSortKey = 'date_desc' | 'date_asc' | 'grade_desc' | 'grade_asc' | 'quality_desc'

// Ordine di "bontà" stile per scegliere il miglior stile di una via (0 = migliore).
export const STYLE_RANK: Record<string, number> = {
  onsight: 0, flash: 1, redpoint: 2, second: 2, third: 2, four_plus: 2, unknown: 4,
}

export interface RouteGroup {
  routeId: string
  route: AscentWithRoute['route'] | null
  items: AscentWithRoute[]      // ordinate per data desc
  displayGrade: string
  gradeNumeric: number
  bestStyle: string | null      // miglior stile tra le SALITE (no ripetizioni)
  firstSendDate: string | null
  lastActivity: string
  repeatCount: number
  sessionCount: number
  quality: number | null
  hasSend: boolean
}

export function styleKey(a: AscentWithRoute): string {
  return a.ascent_style ?? a.attempt_type ?? 'unknown'
}

// is_repeat è autoritativo, ma copriamo anche i casi storici con ascent_style='repeat'.
export function isRepeatAscent(a: AscentWithRoute): boolean {
  return a.is_repeat === true || styleKey(a) === 'repeat'
}

export function buildGroups(ascents: AscentWithRoute[]): RouteGroup[] {
  const byRoute = new Map<string, AscentWithRoute[]>()
  for (const a of ascents) {
    const arr = byRoute.get(a.route_id)
    if (arr) arr.push(a)
    else byRoute.set(a.route_id, [a])
  }
  const groups: RouteGroup[] = []
  byRoute.forEach((items, routeId) => {
    const sorted = [...items].sort((a, b) => b.date.localeCompare(a.date))
    const sends = sorted.filter(a => !isRepeatAscent(a) && a.status === 'completed')
    // Miglior salita: rank stile più basso, a parità grado più alto, poi data più vecchia.
    const best = [...sends].sort((a, b) => {
      const ra = STYLE_RANK[styleKey(a)] ?? 4
      const rb = STYLE_RANK[styleKey(b)] ?? 4
      if (ra !== rb) return ra - rb
      const ga = a.grade_numeric_at_ascent ?? a.route?.grade_numeric ?? 0
      const gb = b.grade_numeric_at_ascent ?? b.route?.grade_numeric ?? 0
      if (gb !== ga) return gb - ga
      return a.date.localeCompare(b.date)
    })[0] ?? null
    const repeatCount = sorted.filter(isRepeatAscent).length
    const sessionKeys = new Set(sorted.map(a => a.session_id ?? `d:${a.date}`))
    const ref = best ?? sorted[0]
    groups.push({
      routeId,
      route: ref?.route ?? null,
      items: sorted,
      displayGrade: ref?.grade_at_ascent ?? ref?.route?.official_grade ?? '?',
      gradeNumeric: ref?.grade_numeric_at_ascent ?? ref?.route?.grade_numeric ?? 0,
      bestStyle: best ? styleKey(best) : null,
      firstSendDate: sends.length ? sends.map(a => a.date).sort()[0] : null,
      lastActivity: sorted[0]?.date ?? '',
      repeatCount,
      sessionCount: sessionKeys.size,
      quality: best?.quality ?? sorted.find(a => a.quality != null)?.quality ?? null,
      hasSend: sends.length > 0,
    })
  })
  return groups
}

export function sortGroups(list: RouteGroup[], sort: LogbookSortKey): RouteGroup[] {
  return [...list].sort((a, b) => {
    switch (sort) {
      case 'date_desc': return b.lastActivity.localeCompare(a.lastActivity)
      case 'date_asc':  return a.lastActivity.localeCompare(b.lastActivity)
      case 'grade_desc': return b.gradeNumeric - a.gradeNumeric
      case 'grade_asc':  return a.gradeNumeric - b.gradeNumeric
      case 'quality_desc': {
        const qa = a.quality ?? 0, qb = b.quality ?? 0
        return qb !== qa ? qb - qa : b.lastActivity.localeCompare(a.lastActivity)
      }
    }
  })
}
