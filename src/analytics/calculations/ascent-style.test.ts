import { describe, it, expect } from 'vitest'
import { normalizeAscentStyle } from './ascent-style'

describe('normalizeAscentStyle', () => {
  it('maps onsight → onsight', () => expect(normalizeAscentStyle('onsight')).toBe('onsight'))
  it('maps on-sight → onsight', () => expect(normalizeAscentStyle('on-sight')).toBe('onsight'))
  it('maps flash → flash', () => expect(normalizeAscentStyle('flash')).toBe('flash'))
  it('maps redpoint → redpoint', () => expect(normalizeAscentStyle('redpoint')).toBe('redpoint'))
  it('maps second → redpoint', () => expect(normalizeAscentStyle('second')).toBe('redpoint'))
  it('maps third → redpoint', () => expect(normalizeAscentStyle('third')).toBe('redpoint'))
  it('maps four_plus → redpoint', () => expect(normalizeAscentStyle('four_plus')).toBe('redpoint'))
  it('maps 2nd → redpoint', () => expect(normalizeAscentStyle('2nd')).toBe('redpoint'))
  it('maps 3rd → redpoint', () => expect(normalizeAscentStyle('3rd')).toBe('redpoint'))
  it('maps 4th_plus → redpoint', () => expect(normalizeAscentStyle('4th_plus')).toBe('redpoint'))
  it('maps repeat → repeat', () => expect(normalizeAscentStyle('repeat')).toBe('repeat'))
  it('maps null → unknown', () => expect(normalizeAscentStyle(null)).toBe('unknown'))
  it('maps undefined → unknown', () => expect(normalizeAscentStyle(undefined)).toBe('unknown'))
  it('maps empty string → unknown', () => expect(normalizeAscentStyle('')).toBe('unknown'))
  it('maps unknown string → unknown', () => expect(normalizeAscentStyle('project')).toBe('unknown'))
  it('is case-insensitive', () => expect(normalizeAscentStyle('FLASH')).toBe('flash'))
})
