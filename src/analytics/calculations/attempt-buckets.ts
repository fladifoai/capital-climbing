export type AttemptBucket =
  | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' | '10'
  | '11_15' | '16_20' | '21_30' | '31_40' | '41_50' | '50_plus'
  | 'unknown'

export function getAttemptBucket(attemptCount: number | null | undefined): AttemptBucket {
  if (attemptCount == null || attemptCount <= 0) return 'unknown'
  if (attemptCount <= 10) return String(attemptCount) as AttemptBucket
  if (attemptCount <= 15) return '11_15'
  if (attemptCount <= 20) return '16_20'
  if (attemptCount <= 30) return '21_30'
  if (attemptCount <= 40) return '31_40'
  if (attemptCount <= 50) return '41_50'
  return '50_plus'
}

export const ATTEMPT_BUCKET_LABELS: Record<AttemptBucket, string> = {
  '1': '1° giro',
  '2': '2° giro',
  '3': '3° giro',
  '4': '4° giro',
  '5': '5° giro',
  '6': '6° giro',
  '7': '7° giro',
  '8': '8° giro',
  '9': '9° giro',
  '10': '10° giro',
  '11_15': '11–15 giri',
  '16_20': '16–20 giri',
  '21_30': '21–30 giri',
  '31_40': '31–40 giri',
  '41_50': '41–50 giri',
  '50_plus': 'Più di 50',
  'unknown': 'Non specificato',
}

export const ATTEMPT_BUCKET_ORDER: AttemptBucket[] = [
  '1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
  '11_15', '16_20', '21_30', '31_40', '41_50', '50_plus', 'unknown',
]

// Selector options shown in the form for Redpoint
export const ATTEMPT_SELECTOR_OPTIONS: Array<{ value: string; label: string; isBucket: boolean }> = [
  { value: '2',      label: '2° giro',      isBucket: false },
  { value: '3',      label: '3° giro',      isBucket: false },
  { value: '4',      label: '4° giro',      isBucket: false },
  { value: '5',      label: '5° giro',      isBucket: false },
  { value: '6',      label: '6° giro',      isBucket: false },
  { value: '7',      label: '7° giro',      isBucket: false },
  { value: '8',      label: '8° giro',      isBucket: false },
  { value: '9',      label: '9° giro',      isBucket: false },
  { value: '10',     label: '10° giro',     isBucket: false },
  { value: '11_15',  label: '11–15 giri',   isBucket: true },
  { value: '16_20',  label: '16–20 giri',   isBucket: true },
  { value: '21_30',  label: '21–30 giri',   isBucket: true },
  { value: '31_40',  label: '31–40 giri',   isBucket: true },
  { value: '41_50',  label: '41–50 giri',   isBucket: true },
  { value: '50_plus', label: 'Più di 50',   isBucket: true },
]

export function resolveAttemptFields(
  raw: string | null,
  exact: number | null
): { attempt_count: number | null; attempt_bucket: AttemptBucket | null } {
  if (!raw) return { attempt_count: null, attempt_bucket: null }
  const exactValues = ['2','3','4','5','6','7','8','9','10']
  if (exactValues.includes(raw)) {
    const count = parseInt(raw)
    return { attempt_count: count, attempt_bucket: getAttemptBucket(count) }
  }
  // It's a bucket
  const bucket = raw as AttemptBucket
  if (exact != null && exact >= 1) {
    return { attempt_count: exact, attempt_bucket: getAttemptBucket(exact) }
  }
  return { attempt_count: null, attempt_bucket: bucket }
}
