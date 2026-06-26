import { useState, useCallback } from 'react'
import type { AnalyticsFilters } from '../types'
import { DEFAULT_FILTERS } from '../types'
import type { AscentStyle } from '../calculations/ascent-style'
import type { AttemptBucket } from '../calculations/attempt-buckets'

export function useAnalyticsFilters() {
  const [filters, setFilters] = useState<AnalyticsFilters>(DEFAULT_FILTERS)

  const setYear = useCallback((year: number | 'all') => {
    setFilters(f => ({ ...f, yearFilter: year }))
  }, [])

  const setAscentStyles = useCallback((styles: AscentStyle[] | 'all') => {
    setFilters(f => ({ ...f, ascentStyles: styles }))
  }, [])

  const setAttemptBuckets = useCallback((buckets: AttemptBucket[] | 'all') => {
    setFilters(f => ({ ...f, attemptBuckets: buckets }))
  }, [])

  const setGradeRange = useCallback((min: number | null, max: number | null) => {
    setFilters(f => ({ ...f, gradeMin: min, gradeMax: max }))
  }, [])

  const reset = useCallback(() => setFilters(DEFAULT_FILTERS), [])

  const isDefault =
    filters.yearFilter === 'all' &&
    filters.ascentStyles === 'all' &&
    filters.attemptBuckets === 'all' &&
    filters.gradeMin === null &&
    filters.gradeMax === null

  return { filters, setYear, setAscentStyles, setAttemptBuckets, setGradeRange, reset, isDefault }
}
