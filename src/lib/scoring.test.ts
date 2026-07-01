import { describe, it, expect } from 'vitest'
import {
  calculateCapitalScore,
  capitalScoreFromAscent,
  getLevelInfo,
  normalizeGrade,
  normalizeAttemptType,
} from './scoring'

const score = (grade: string, attemptType: string) =>
  calculateCapitalScore({ grade, attemptType })

describe('normalizeGrade', () => {
  it('lowercases, trims, removes spaces', () => {
    expect(normalizeGrade('7A')).toBe('7a')
    expect(normalizeGrade('6B+')).toBe('6b+')
    expect(normalizeGrade('7 a')).toBe('7a')
    expect(normalizeGrade('6c / 6c+')).toBe('6c/6c+')
  })
})

describe('normalizeAttemptType', () => {
  it('maps UI labels to technical keys', () => {
    expect(normalizeAttemptType('On-sight')).toBe('onsight')
    expect(normalizeAttemptType('Flash')).toBe('flash')
    expect(normalizeAttemptType('2° giro')).toBe('second_go')
    expect(normalizeAttemptType('3° giro')).toBe('redpoint')
    expect(normalizeAttemptType('boh')).toBe('redpoint') // default
  })
})

describe('Capital Score — valori attesi', () => {
  it('6b+ onsight = 1390', () => expect(score('6b+', 'onsight')).toBe(1390))
  it('7a redpoint = 1400', () => expect(score('7a', 'redpoint')).toBe(1400))
  it('7a second_go = 1430', () => expect(score('7a', 'second_go')).toBe(1430))
  it('7a flash = 1490', () => expect(score('7a', 'flash')).toBe(1490))
  it('7a onsight = 1690', () => expect(score('7a', 'onsight')).toBe(1690))
  it('7b+ redpoint = 1700', () => expect(score('7b+', 'redpoint')).toBe(1700))
})

describe('Capital Score — gerarchia', () => {
  it('7a onsight < 7b+ redpoint', () =>
    expect(score('7a', 'onsight')!).toBeLessThan(score('7b+', 'redpoint')!))
  it('6b+ onsight < 7a redpoint', () =>
    expect(score('6b+', 'onsight')!).toBeLessThan(score('7a', 'redpoint')!))
  it('7a second_go > 7a redpoint', () =>
    expect(score('7a', 'second_go')!).toBeGreaterThan(score('7a', 'redpoint')!))
  it('7a flash > 7a second_go', () =>
    expect(score('7a', 'flash')!).toBeGreaterThan(score('7a', 'second_go')!))
  it('7a onsight > 7a flash', () =>
    expect(score('7a', 'onsight')!).toBeGreaterThan(score('7a', 'flash')!))
})

describe('Capital Score — dal 3° giro in poi stesso punteggio', () => {
  it('3°/4°/5°/7° giro = redpoint = stesso bonus 0', () => {
    const rp = score('7a', 'redpoint')
    for (const giro of ['3° giro', '4° giro', '5° giro', '7° giro']) {
      expect(score('7a', giro)).toBe(rp)
    }
  })
})

describe('Capital Score — grado non riconosciuto', () => {
  it('ritorna null', () => {
    expect(score('5a', 'onsight')).toBeNull() // sotto la scala Capital
    expect(score('xyz', 'flash')).toBeNull()
  })
})

describe('capitalScoreFromAscent — adapter modello app', () => {
  it('onsight style = montando (+10) → 1700', () =>
    expect(capitalScoreFromAscent({ grade: '7a', ascent_style: 'onsight' })).toBe(1700))
  it('onsight montando (1700) NON supera 7b+ redpoint (1700)', () =>
    expect(capitalScoreFromAscent({ grade: '7a', ascent_style: 'onsight' })!).toBeLessThanOrEqual(
      calculateCapitalScore({ grade: '7b+', attemptType: 'redpoint' })!,
    ))
  it('redpoint con attempt_count 2 → second_go', () =>
    expect(
      capitalScoreFromAscent({ grade: '7a', ascent_style: 'redpoint', attempt_count: 2 }),
    ).toBe(1430))
  it('redpoint con attempt_count 5 → redpoint', () =>
    expect(
      capitalScoreFromAscent({ grade: '7a', ascent_style: 'redpoint', attempt_count: 5 }),
    ).toBe(1400))
  it('legacy attempt_type second senza conteggio → second_go', () =>
    expect(
      capitalScoreFromAscent({ grade: '7a', ascent_style: 'redpoint', attempt_type: 'second' }),
    ).toBe(1430))
  it('grado mancante → null', () =>
    expect(capitalScoreFromAscent({ grade: null, ascent_style: 'onsight' })).toBeNull())
})

describe('Livelli — Elite nascosto', () => {
  it('score 999999 → elite non sbloccato, non è next_level', () => {
    const info = getLevelInfo(999_999)
    expect(info.eliteUnlocked).toBe(false)
    expect(info.nextLevel).toBeNull() // già Master, Elite non visibile
  })
  it('score 1000000 → elite sbloccato e livello attuale Elite', () => {
    const info = getLevelInfo(1_000_000)
    expect(info.eliteUnlocked).toBe(true)
    expect(info.level?.key).toBe('elite')
  })
  it('livelli pubblici progressivi', () => {
    expect(getLevelInfo(0).level).toBeNull()
    expect(getLevelInfo(5_000).level?.key).toBe('prime_vie')
    expect(getLevelInfo(60_000).level?.key).toBe('local_climber')
    expect(getLevelInfo(60_000).nextLevel?.key).toBe('strong_climber')
  })
})
