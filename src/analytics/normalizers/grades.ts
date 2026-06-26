export const GRADE_SCALE: Record<number, string> = {
  1: '5a', 2: '5b', 3: '5c',
  4: '6a', 5: '6a+',
  6: '6b', 7: '6b+',
  8: '6c', 9: '6c+',
  10: '7a', 11: '7a+',
  12: '7b', 13: '7b+',
  14: '7c', 15: '7c+',
  16: '8a', 17: '8a+',
  18: '8b', 19: '8b+',
  20: '8c', 21: '8c+',
  22: '9a',
}

// Slash grades (e.g. '6b/6b+') resolve to the higher of the two
const SLASH_ALIASES: Record<string, string> = {
  '6b/6b+': '6b+', '6c/6c+': '6c+', '6c+/7a': '7a',
  '7a/7a+': '7a+', '7b/7b+': '7b+', '7c/7c+': '7c+',
  '8a/8a+': '8a+', '8b/8b+': '8b+',
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

export function gradeToNum(g: string): number | null {
  return GRADE_TO_NUM[g] ?? null
}

export const GRADE_ORDER: string[] = Object.values(GRADE_SCALE)
