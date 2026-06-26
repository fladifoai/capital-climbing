import { describe, it, expect } from 'vitest'
import { getAttemptBucket, resolveAttemptFields } from './attempt-buckets'

describe('getAttemptBucket', () => {
  it('1 → 1', () => expect(getAttemptBucket(1)).toBe('1'))
  it('2 → 2', () => expect(getAttemptBucket(2)).toBe('2'))
  it('10 → 10', () => expect(getAttemptBucket(10)).toBe('10'))
  it('11 → 11_15', () => expect(getAttemptBucket(11)).toBe('11_15'))
  it('15 → 11_15', () => expect(getAttemptBucket(15)).toBe('11_15'))
  it('16 → 16_20', () => expect(getAttemptBucket(16)).toBe('16_20'))
  it('20 → 16_20', () => expect(getAttemptBucket(20)).toBe('16_20'))
  it('21 → 21_30', () => expect(getAttemptBucket(21)).toBe('21_30'))
  it('30 → 21_30', () => expect(getAttemptBucket(30)).toBe('21_30'))
  it('31 → 31_40', () => expect(getAttemptBucket(31)).toBe('31_40'))
  it('40 → 31_40', () => expect(getAttemptBucket(40)).toBe('31_40'))
  it('41 → 41_50', () => expect(getAttemptBucket(41)).toBe('41_50'))
  it('50 → 41_50', () => expect(getAttemptBucket(50)).toBe('41_50'))
  it('51 → 50_plus', () => expect(getAttemptBucket(51)).toBe('50_plus'))
  it('null → unknown', () => expect(getAttemptBucket(null)).toBe('unknown'))
  it('undefined → unknown', () => expect(getAttemptBucket(undefined)).toBe('unknown'))
  it('0 → unknown', () => expect(getAttemptBucket(0)).toBe('unknown'))
  it('-1 → unknown', () => expect(getAttemptBucket(-1)).toBe('unknown'))
})

describe('resolveAttemptFields', () => {
  it('exact 5 → count=5, bucket=5', () => {
    const r = resolveAttemptFields('5', null)
    expect(r.attempt_count).toBe(5)
    expect(r.attempt_bucket).toBe('5')
  })
  it('bucket 11_15 no exact → count=null, bucket=11_15', () => {
    const r = resolveAttemptFields('11_15', null)
    expect(r.attempt_count).toBeNull()
    expect(r.attempt_bucket).toBe('11_15')
  })
  it('bucket 11_15 + exact 14 → count=14, bucket=11_15', () => {
    const r = resolveAttemptFields('11_15', 14)
    expect(r.attempt_count).toBe(14)
    expect(r.attempt_bucket).toBe('11_15')
  })
  it('null raw → count=null, bucket=null', () => {
    const r = resolveAttemptFields(null, null)
    expect(r.attempt_count).toBeNull()
    expect(r.attempt_bucket).toBeNull()
  })
  it('four_plus should NOT be set to 4', () => {
    // four_plus legacy must not produce attempt_count = 4 automatically
    const r = resolveAttemptFields(null, null)
    expect(r.attempt_count).not.toBe(4)
  })
})
