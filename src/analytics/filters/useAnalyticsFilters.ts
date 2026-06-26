import { useState, useCallback } from 'react'
import type { AnalyticsFilters } from '../types'
import { DEFAULT_FILTERS } from '../types'
import type { AttemptType } from '../../types/database'

export function useAnalyticsFilters() {
  const [filters, setFilters] = useState<AnalyticsFilters>(DEFAULT_FILTERS)

  const setYear = useCallback((year: number | 'all') => {
    setFilters(f => ({ ...f, yearFilter: year }))
  }, [])

  const setAttemptTypes = useCallback((types: AttemptType[] | 'all') => {
    setFilters(f => ({ ...f, attemptTypes: types }))
  }, [])

  const setGradeRange = useCallback((min: number | null, max: number | null) => {
    setFilters(f => ({ ...f, gradeMin: min, gradeMax: max }))
  }, [])

  const reset = useCallback(() => setFilters(DEFAULT_FILTERS), [])

  const isDefault =
    filters.yearFilter === 'all' &&
    filters.attemptTypes === 'all' &&
    filters.gradeMin === null &&
    filters.gradeMax === null

  return { filters, setYear, setAttemptTypes, setGradeRange, reset, isDefault }
}
