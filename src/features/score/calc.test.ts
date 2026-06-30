import { describe, it, expect } from 'vitest'
import type { AscentWithRoute } from '../logbook/hooks'
import {
  computeOverview,
  computeCumulative,
  computeByYear,
  computeByStyle,
  computeByGradeStyle,
  computeTopRoutes,
  computeLast12Months,
} from './calc'

// Helper: costruisce una salita minima con i soli campi usati dai calcoli.
function ascent(p: {
  date: string
  score: number | null
  style?: string
  count?: number | null
  grade?: string
  name?: string
  crag?: string
  is_repeat?: boolean
  status?: string
}): AscentWithRoute {
  return {
    date: p.date,
    score: p.score,
    ascent_style: p.style ?? 'redpoint',
    attempt_count: p.count ?? null,
    attempt_type: null,
    is_repeat: p.is_repeat ?? false,
    status: p.status ?? 'completed',
    grade_at_ascent: p.grade ?? '7a',
    route: {
      id: 'r', name: p.name ?? 'Via', official_grade: p.grade ?? '7a',
      grade_numeric: 16, route_type: 'sport',
      sector: { id: 's', name: 'Sett', crag: { id: 'c', name: p.crag ?? 'Falesia' } },
    },
  } as unknown as AscentWithRoute
}

const sample = (): AscentWithRoute[] => [
  ascent({ date: '2024-01-10', score: 1690, style: 'onsight', grade: '7a', name: 'A' }),
  ascent({ date: '2024-06-20', score: 1400, style: 'redpoint', count: 5, grade: '7a', name: 'B' }),
  ascent({ date: '2026-03-01', score: 1490, style: 'flash', grade: '7a', name: 'C' }),
  ascent({ date: '2026-05-15', score: 1430, style: 'redpoint', count: 2, grade: '7a', name: 'D' }),
  ascent({ date: '2026-05-16', score: null, is_repeat: true, grade: '7a', name: 'Rip' }),
  ascent({ date: '2026-05-17', score: null, status: 'project', grade: '7a', name: 'Prog' }),
]

describe('computeOverview', () => {
  it('lifetime esclude ripetizioni e progetti', () => {
    const o = computeOverview(sample(), new Date('2026-06-30'))
    expect(o.route_count).toBe(4)
    expect(o.lifetime_score).toBe(1690 + 1400 + 1490 + 1430)
    expect(o.season_score).toBe(1490 + 1430) // solo 2026
    expect(o.best_route?.route_name).toBe('A')
    expect(o.best_route?.capital_score).toBe(1690)
  })
})

describe('computeCumulative', () => {
  it('somma progressiva in ordine di data', () => {
    const c = computeCumulative(sample())
    expect(c).toHaveLength(4)
    expect(c[0].cumulative_score).toBe(1690)
    expect(c[c.length - 1].cumulative_score).toBe(6010)
  })
})

describe('computeByYear', () => {
  it('raggruppa per anno con medie', () => {
    const y = computeByYear(sample())
    expect(y.map((r) => r.year)).toEqual([2024, 2026])
    expect(y[0].season_score).toBe(3090)
    expect(y[1].route_count).toBe(2)
  })
})

describe('computeByStyle', () => {
  it('separa onsight/flash/second_go/redpoint', () => {
    const s = computeByStyle(sample())
    const map = Object.fromEntries(s.map((x) => [x.attempt_type, x.total_score]))
    expect(map.onsight).toBe(1690)
    expect(map.flash).toBe(1490)
    expect(map.second_go).toBe(1430)
    expect(map.redpoint).toBe(1400)
  })
})

describe('computeByGradeStyle', () => {
  it('un solo grado 7a con tutti gli stili', () => {
    const g = computeByGradeStyle(sample())
    expect(g).toHaveLength(1)
    expect(g[0].grade).toBe('7a')
    expect(g[0].total_score).toBe(6010)
    expect(g[0].onsight_score).toBe(1690)
  })
})

describe('computeTopRoutes', () => {
  it('ordina per punti desc con rank', () => {
    const t = computeTopRoutes(sample(), 10)
    expect(t[0].route_name).toBe('A')
    expect(t[0].rank).toBe(1)
    expect(t.map((r) => r.capital_score)).toEqual([1690, 1490, 1430, 1400])
  })
})

describe('computeLast12Months', () => {
  it('filtra gli ultimi 12 mesi', () => {
    const l = computeLast12Months(sample(), new Date('2026-06-30'))
    expect(l.route_count).toBe(2) // marzo + maggio 2026
    expect(l.last_12_months_score).toBe(1490 + 1430)
  })
})
