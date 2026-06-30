# Session 2026-06-26 — Analytics Implementation

## Obiettivo
Implementare sezione analytics Capital Climbing. No scoring/punti. Separare `ascent_style` da `attempt_count`.

---

## File creati

### `src/analytics/normalizers/grades.ts`
- `GRADE_SCALE: Record<number, string>` (1='5a' … 22='9a')
- `numToGrade(n)`, `gradeToNum(g)`, `GRADE_ORDER`

### `src/analytics/types/index.ts`
- `AnalyticsFilters`: yearFilter, ascentStyles, attemptBuckets, gradeMin, gradeMax
- `DEFAULT_FILTERS`
- `KpiData` (estesa: uniqueRoutes, activeDays, medianGrade, within3/5/10, activeProjects, OS/FL/RP best)
- `DataQualityStats`, `GradePyramidEntry` (stili normalizzati), `GradeProgressionPoint`, `MonthlyActivity`, `CragStat`

### `src/analytics/calculations/ascent-style.ts`
```ts
type AscentStyle = 'onsight' | 'flash' | 'redpoint' | 'repeat' | 'unknown'
normalizeAscentStyle(value) // maps second/third/four_plus → 'redpoint'
ASCENT_STYLE_LABELS, ASCENT_STYLE_COLORS, ASCENT_STYLE_ORDER
```

### `src/analytics/calculations/attempt-buckets.ts`
```ts
type AttemptBucket = '1'|'2'|...|'10'|'11_15'|'16_20'|'21_30'|'31_40'|'41_50'|'50_plus'|'unknown'
getAttemptBucket(n)
ATTEMPT_BUCKET_LABELS, ATTEMPT_BUCKET_ORDER
ATTEMPT_SELECTOR_OPTIONS  // per form UI
resolveAttemptFields(raw, exact) // → { attempt_count, attempt_bucket }
```

### `src/analytics/calculations/ascent-style.test.ts` — 16 test
### `src/analytics/calculations/attempt-buckets.test.ts` — 24 test

### `src/analytics/metrics/ascents.ts`
- `filterAscents(ascents, filters)`
- `computeKpis(ascents, projects, sessions, filters) → KpiData`
- `computeDataQuality(ascents) → DataQualityStats`
- `computeGradeProgression`, `computeGradeProgressionLine`
- `computeGradePyramid` (stili normalizzati)
- `computeMonthlyActivity`, `computeTopCrags`, `computeAvailableYears`
- `computeAscentModeBreakdown`, `computeAttemptBucketBreakdown`, `computeModeByAttempt`

### `src/analytics/filters/useAnalyticsFilters.ts`
- State: `AnalyticsFilters`
- `setYear`, `setAscentStyles`, `setAttemptBuckets`, `setGradeRange`, `reset`, `isDefault`

---

## File modificati

### `supabase/migrations/011_ascent_style.sql`
Nuove colonne su `public.ascents`:
- `ascent_style text` (check: onsight/flash/redpoint/repeat/unknown)
- `attempt_count integer` (check: >= 1)
- `attempt_bucket text` (check: '1'–'10', '11_15', …, '50_plus', 'unknown')
- `legacy_attempt_type text`
- `needs_review boolean DEFAULT false`

Data migration: attempt_type → nuovi campi.
- second → ascent_style='redpoint', attempt_count=2
- third → ascent_style='redpoint', attempt_count=3
- four_plus → ascent_style='redpoint', attempt_count=NULL, needs_review=true

**Fix 2026-06-26**: aggiunto `DROP CONSTRAINT IF EXISTS` prima di `ADD CONSTRAINT` per evitare errore 42710 su run ripetuto.

### `src/types/database.ts`
Aggiunto a `Ascent`: `ascent_style`, `attempt_count`, `attempt_bucket`, `legacy_attempt_type`, `needs_review`

### `src/features/logbook/hooks.ts`
- `AscentFormValues` esteso con `ascent_style`, `attempt_count`, `attempt_bucket`
- `useCreateAscent` invia `needs_review: false`

### `src/features/logbook/AscentForm.tsx`
Riscritta. UX 2-step:
1. Seleziona stile (OS/FL/RP/Rip/Non specificato)
2. Se redpoint → seleziona giri (2-10 esatti, poi bucket 11_15…50_plus, con input numero facoltativo se bucket grande)

### `src/features/users/hooks.ts`
- `FeedAscent` tipo: aggiunto campo `ascent_style`
- Feed query: aggiunto `ascent_style` in SELECT

### `src/routes/AnalyticsPage.tsx`
Riscritta. 6 tab:
- **Panoramica** (default): line chart + volume bar + modalità bar + piramide top-10 + top falesie
- **Progressione**: scatter plot + line chart
- **Volume**: attività mensile
- **Profilo tecnico**: piramide gradi + modalità + giri
- **Falesie**: top falesie
- **Qualità dati**: DataQuality panel con barre completezza

Global filter bar: anno + stile (OS/FL/RP/Rip) + reset.

### `src/routes/MyRoutesPage.tsx`, `DashboardPage.tsx`, `SessionsPage.tsx`, `UserProfilePage.tsx`
Display badge stile: usa `a.ascent_style ?? a.attempt_type` come chiave.
Labels/colors aggiornate con chiavi normalizzate (repeat/unknown aggiunte).

### `src/styles/analytics.css`
Aggiunto: `.kpi-section-label`, `.style-filter`, `.style-btn`, `.quality-panel`, `.quality-row`, `.quality-bar-*`

---

## Bug fix chiave
- `second`/`third`/`four_plus` erano categorizzati come "Altro" nella piramide → fix con `normalizeAscentStyle`
- Tooltip Recharts `Formatter<ValueType>` TS error → rimossa annotazione tipo esplicita
- `??` e `||` mixing TS5076 → parentesi: `?? (style || '—')`
- UX: tab default "Progressione" mostrava solo 2 chart → aggiunta tab "Panoramica" con 5 chart visibili

---

## Stato da fare
- [ ] **CRITICO**: eseguire `011_ascent_style.sql` su Supabase SQL Editor
- [ ] G2: max OS/FL/RP per anno (chart Progressione)
- [ ] G4: calendario heatmap
- [ ] G5: efficienza per grado
- [ ] G7: successo per grado
- [ ] G8: punti forti / anti-stile
- [ ] Attempt bucket filter UI nella filter bar
- [ ] Deploy GitHub Pages dopo migrazione confermata
