import { describe, it, expect } from 'vitest'
import {
  buildAscentValues, buildMapped, deriveOptionFromRecord, parseProposed,
  type AscentFieldsController, type AscentTargetRoute,
} from './ascentFields'

// Fake controller: buildAscentValues legge solo i valori + proposedLabel/Num.
// I setter non servono al test, li lasciamo no-op.
function fakeCtrl(over: Partial<AscentFieldsController> = {}): AscentFieldsController {
  const noop = () => {}
  const base = {
    date: '2026-07-01',
    selectedOption: 'onsight',
    isRepeat: false,
    drawsMode: 'unknown',
    effort: '' as number | '',
    quality: null as number | null,
    difficultyFeel: '',
    styleFeel: '',
    proposedBase: '',
    proposedDec: '',
    wantRepeat: null as boolean | null,
    kneepad: false,
    notes: '',
    visibility: 'public' as 'public' | 'private',
    proposedLabel: '',
    proposedNum: null as number | null,
    setDate: noop, setSelectedOption: noop, setIsRepeat: noop, setDrawsMode: noop,
    setEffort: noop, setQuality: noop, setDifficultyFeel: noop, setStyleFeel: noop,
    setProposedBase: noop, setProposedDec: noop, setWantRepeat: noop, setKneepad: noop,
    setNotes: noop, setVisibility: noop,
  }
  return { ...base, ...over } as AscentFieldsController
}

const ROUTE: AscentTargetRoute = { id: 'r1', official_grade: '6b', grade_numeric: 12 }

describe('buildAscentValues — fonte unica per LogNewPage / AscentForm', () => {
  it('stesso input produce lo stesso AscentFormValues in entrambi i contesti', () => {
    const state = {
      date: '2026-06-20',
      selectedOption: '3',
      drawsMode: 'placed_by_user',
      effort: 8 as number | '',
      quality: 4 as number | null,
      difficultyFeel: 'hard',
      styleFeel: 'my_style',
      proposedBase: '6b',
      proposedDec: '8',
      proposedLabel: '6b.8',
      wantRepeat: true as boolean | null,
      kneepad: true,
      notes: 'bella',
      visibility: 'private' as 'public' | 'private',
    }
    // LogNewPage e AscentForm chiamano ENTRAMBI buildAscentValues sullo stesso ctrl.
    const fromLogNew = buildAscentValues(fakeCtrl(state), ROUTE, null)
    const fromAscentForm = buildAscentValues(fakeCtrl(state), ROUTE, null)
    expect(fromAscentForm).toEqual(fromLogNew)

    expect(fromLogNew).toMatchObject({
      route_id: 'r1',
      ascent_style: 'redpoint',
      attempt_count: 3,
      attempt_bucket: '3',
      draws_mode: 'placed_by_user',
      difficulty_feel: 'hard',
      style_feel: 'my_style',
      proposed_grade: '6b.8',
      want_repeat: true,
      kneepad_used: true,
      effort: 8,
      quality: 4,
      notes: 'bella',
      visibility: 'private',
      grade_at_ascent: '6b',
    })
  })

  it('override ginocchiera (LogNewPage usa il pannello note) non tocca gli altri campi', () => {
    const state = { selectedOption: 'onsight', kneepad: false }
    const withOverride = buildAscentValues(fakeCtrl(state), ROUTE, null, { kneepadUsed: true })
    const noOverride = buildAscentValues(fakeCtrl(state), ROUTE, null)
    expect(withOverride.kneepad_used).toBe(true)
    expect(noOverride.kneepad_used).toBe(null)
    expect({ ...withOverride, kneepad_used: null }).toEqual(noOverride)
  })

  it('ripetizione azzera draws_mode/attempt', () => {
    const v = buildAscentValues(fakeCtrl({ isRepeat: true, selectedOption: '3', drawsMode: 'placed_by_user' }), ROUTE, null)
    expect(v.ascent_style).toBe('repeat')
    expect(v.attempt_count).toBeNull()
    expect(v.attempt_bucket).toBeNull()
    expect(v.draws_mode).toBeNull()
  })
})

describe('buildMapped', () => {
  it('onsight/flash → 1 tentativo', () => {
    expect(buildMapped('onsight', false)).toEqual({ ascent_style: 'onsight', attempt_count: 1, attempt_bucket: '1' })
    expect(buildMapped('flash', false)).toEqual({ ascent_style: 'flash', attempt_count: 1, attempt_bucket: '1' })
  })
  it('giro esatto e bucket', () => {
    expect(buildMapped('4', false)).toEqual({ ascent_style: 'redpoint', attempt_count: 4, attempt_bucket: '4' })
    expect(buildMapped('11_20', false)).toEqual({ ascent_style: 'redpoint', attempt_count: null, attempt_bucket: '11_20' })
  })
})

describe('deriveOptionFromRecord (prefill edit)', () => {
  it('ricava l’opzione dallo stile salvato', () => {
    expect(deriveOptionFromRecord('onsight', 1, '1')).toBe('onsight')
    expect(deriveOptionFromRecord('flash', 1, '1')).toBe('flash')
    expect(deriveOptionFromRecord('redpoint', 3, '3')).toBe('3')
    expect(deriveOptionFromRecord('redpoint', null, '11_20')).toBe('11_20')
    expect(deriveOptionFromRecord('redpoint', 5, null)).toBe('5')
    expect(deriveOptionFromRecord('redpoint', null, null)).toBe('2')
  })
})

describe('parseProposed', () => {
  it('separa base e decimale', () => {
    expect(parseProposed('6b.8')).toEqual({ base: '6b', dec: '8' })
    expect(parseProposed('6b')).toEqual({ base: '6b', dec: '' })
    expect(parseProposed(null)).toEqual({ base: '', dec: '' })
  })
})
