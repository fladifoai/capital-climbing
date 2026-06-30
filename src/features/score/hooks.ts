import { useMemo } from 'react'
import { useMyAscents } from '../logbook/hooks'
import {
  computeOverview,
  computeCumulative,
  computeByYear,
  computeByMonth,
  computeLast12Months,
  computeByStyle,
  computeByGradeStyle,
  computeTopRoutes,
  computeAvailableScoreYears,
  computeRolling12,
} from './calc'

// Carica tutte le salite dell'utente e deriva tutte le aggregazioni Capital
// Score in un colpo solo (memoizzate). Un'unica query, niente backend REST.
export function useScoreData(userId: string, selectedYear: number) {
  const { data: ascents, isLoading, error } = useMyAscents(userId)

  return useMemo(() => {
    const rows = ascents ?? []
    return {
      isLoading,
      error,
      hasData: rows.some((a) => a.score != null && !a.is_repeat),
      overview: computeOverview(rows),
      cumulative: computeCumulative(rows),
      byYear: computeByYear(rows),
      byMonth: computeByMonth(rows, selectedYear),
      last12Months: computeLast12Months(rows),
      byStyle: computeByStyle(rows),
      byGradeStyle: computeByGradeStyle(rows),
      topRoutes: computeTopRoutes(rows, 10),
      rolling12: computeRolling12(rows),
      availableYears: computeAvailableScoreYears(rows),
    }
  }, [ascents, isLoading, error, selectedYear])
}
