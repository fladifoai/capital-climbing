import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import { gradeToNum } from '../../analytics/normalizers/grades'

export interface ReviewAscent {
  id: string
  date: string
  grade_at_ascent: string | null
  ascent_style: string | null
  attempt_count: number | null
  attempt_bucket: string | null
  route_name_snapshot: string | null
  crag_name_snapshot: string | null
  route: { id: string; name: string } | null
}

export function useNeedsReviewAscents(userId: string) {
  return useQuery({
    queryKey: ['needs-review-ascents', userId],
    queryFn: async (): Promise<ReviewAscent[]> => {
      const { data, error } = await supabase
        .from('ascents')
        .select(`
          id, date, grade_at_ascent, ascent_style, attempt_count, attempt_bucket,
          route_name_snapshot, crag_name_snapshot,
          route:routes(id, name)
        `)
        .eq('user_id', userId)
        .eq('needs_review', true)
        .order('date', { ascending: false })
      if (error) throw error
      return (data ?? []) as unknown as ReviewAscent[]
    },
    enabled: !!userId,
  })
}

export interface ReviewUpdate {
  id: string
  grade_at_ascent: string | null
  ascent_style: string | null
  attempt_count: number | null
  attempt_bucket: string | null
}

export function useUpdateAscentReview(userId: string) {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (u: ReviewUpdate) => {
      const grade = u.grade_at_ascent
      const { error } = await supabase
        .from('ascents')
        .update({
          grade_at_ascent: grade,
          grade_snapshot: grade,
          grade_numeric_at_ascent: grade ? gradeToNum(grade.toLowerCase().replace(/\s+/g, '')) : null,
          ascent_style: u.ascent_style,
          attempt_count: u.attempt_count,
          attempt_bucket: u.attempt_bucket,
          needs_review: false,
        })
        .eq('id', u.id)
      if (error) throw error
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['needs-review-ascents', userId] })
      qc.invalidateQueries({ queryKey: ['my-ascents', userId] })
    },
  })
}
