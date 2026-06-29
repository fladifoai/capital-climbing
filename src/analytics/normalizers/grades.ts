// Full French sport scale 4a → 9c, sequential numbering.
// grade_numeric (routes) and grade_numeric_at_ascent (ascents) are stored in DB
// using these numbers — keep migration in sync when this changes.
export const GRADE_SCALE: Record<number, string> = {
  1: '4a', 2: '4b', 3: '4c',
  4: '5a', 5: '5a+', 6: '5b', 7: '5b+', 8: '5c', 9: '5c+',
  10: '6a', 11: '6a+', 12: '6b', 13: '6b+', 14: '6c', 15: '6c+',
  16: '7a', 17: '7a+', 18: '7b', 19: '7b+', 20: '7c', 21: '7c+',
  22: '8a', 23: '8a+', 24: '8b', 25: '8b+', 26: '8c', 27: '8c+',
  28: '9a', 29: '9a+', 30: '9b', 31: '9b+', 32: '9c',
}

// Slash grades (e.g. '6b/6b+') resolve to the higher of the two
const SLASH_ALIASES: Record<string, string> = {
  '5a/5a+': '5a+', '5b/5b+': '5b+', '5c/5c+': '5c+',
  '6a/6a+': '6a+', '6b/6b+': '6b+', '6c/6c+': '6c+', '6c+/7a': '7a',
  '7a/7a+': '7a+', '7b/7b+': '7b+', '7c/7c+': '7c+',
  '8a/8a+': '8a+', '8b/8b+': '8b+', '8c/8c+': '8c+',
  '9a/9a+': '9a+', '9b/9b+': '9b+',
}

export const GRADE_TO_NUM: Record<string, number> = {
  ...Object.fromEntries(
    Object.entries(GRADE_SCALE).map(([n, g]) => [g, Number(n)])
  ),
  ...Object.fromEntries(
    Object.entries(SLASH_ALIASES).map(([slash, target]) => {
      const entry = Object.entries(GRADE_SCALE).find(([, g]) => g === target)
      return [slash, entry ? Number(entry[0]) : 0]
    })
  ),
}

export function numToGrade(n: number): string {
  return GRADE_SCALE[n] ?? String(n)
}

// Decimal community grade: 12.8 → "6b.8", 13.0 → "6b+".
// Frazione (.1–.9) = quanto è spostato verso il grado successivo.
export function numToGradeDecimal(n: number): string {
  let floor = Math.floor(n)
  let frac = Math.round((n - floor) * 10)
  if (frac >= 10) { floor += 1; frac = 0 }
  const base = GRADE_SCALE[floor] ?? String(floor)
  return frac === 0 ? base : `${base}.${frac}`
}

export function gradeToNum(g: string): number | null {
  return GRADE_TO_NUM[g] ?? null
}

export const GRADE_ORDER: string[] = Object.values(GRADE_SCALE)
