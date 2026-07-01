import { useState } from 'react'
import { type AscentFormValues, type RouteSearchResult } from './hooks'
import {
  useAscentFields, buildAscentValues,
  RouteSelect, RouteInfoPanel, AscentFields,
} from './ascentFields'
import '../../styles/admin.css'

interface Props {
  preselectedRoute?: RouteSearchResult
  defaultDate?: string
  sessionId?: string | null
  onSubmit: (values: AscentFormValues, route?: RouteSearchResult) => void
  onCancel: () => void
  isLoading?: boolean
}

// Aggiungi salita da una sessione (o convert progetto). Stesso identico modulo
// campi di LogNewPage/AscentEditForm: nessuna copia divergente.
export default function AscentForm({ preselectedRoute, defaultDate, sessionId, onSubmit, onCancel, isLoading }: Props) {
  const [query, setQuery] = useState(preselectedRoute?.name ?? '')
  const [selectedRoute, setSelectedRoute] = useState<RouteSearchResult | null>(preselectedRoute ?? null)

  const ctrl = useAscentFields({
    date: defaultDate ?? new Date().toISOString().slice(0, 10),
    proposedBase: preselectedRoute?.official_grade ?? '',
  })

  function selectRoute(r: RouteSearchResult) {
    setSelectedRoute(r)
    setQuery(r.name)
    if (r.official_grade && !ctrl.proposedBase) ctrl.setProposedBase(r.official_grade)
  }

  function submit() {
    if (!selectedRoute) return
    onSubmit(buildAscentValues(ctrl, selectedRoute, sessionId ?? null), selectedRoute)
  }

  return (
    <div className="inline-form">
      {/* Selezione via + pannello info */}
      {selectedRoute ? (
        <RouteInfoPanel
          routeId={selectedRoute.id}
          name={selectedRoute.name}
          cragName={selectedRoute.crag_name}
          sectorName={selectedRoute.sector_name}
          officialGrade={selectedRoute.official_grade}
          onChange={preselectedRoute ? undefined : () => { setSelectedRoute(null); setQuery('') }}
        />
      ) : (
        <RouteSelect query={query} onQueryChange={q => { setQuery(q); setSelectedRoute(null) }} onSelect={selectRoute} />
      )}

      <AscentFields ctrl={ctrl} showDate showKneepad showVisibility showNotes />

      <div className="form-actions">
        <button type="button" className="btn-secondary" onClick={onCancel}>Annulla</button>
        <button type="button" className="btn-primary" onClick={submit} disabled={isLoading || !selectedRoute}>
          {isLoading ? 'Salvataggio…' : 'Salva ascensione'}
        </button>
      </div>
    </div>
  )
}
