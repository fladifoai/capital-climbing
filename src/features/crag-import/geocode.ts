// Geocoding best-effort via Nominatim (OpenStreetMap), gratis, da browser.
// Per falesie italiane: name → state (regione), county (provincia), comune.
// Non climbing-specifico: può sbagliare → l'admin conferma/corregge sempre.
export interface GeoResult {
  region?: string
  province?: string
  municipality?: string
}

export interface GeoCandidate extends GeoResult {
  label: string   // testo leggibile per scegliere (es. "Grotti, Cittaducale, Lazio")
}

// Ritorna fino a 5 candidati: i nomi falesia (es. "Grotti") sono spesso
// ambigui, quindi l'admin sceglie quello giusto invece di prendere il primo.
export async function geocodeCragCandidates(query: string): Promise<GeoCandidate[]> {
  const q = query.trim()
  if (!q) return []
  const url = `https://nominatim.openstreetmap.org/search?format=jsonv2&addressdetails=1&limit=5&countrycodes=it&q=${encodeURIComponent(q)}`
  try {
    const res = await fetch(url, { headers: { Accept: 'application/json' } })
    if (!res.ok) return []
    const data = (await res.json()) as { address?: Record<string, string> }[]
    return (data ?? []).map(d => {
      const a = d.address ?? {}
      const region = a.state
      const province = a.county ?? a.province ?? a.state_district
      const municipality = a.city ?? a.town ?? a.village ?? a.municipality
      const label = [municipality, province, region].filter(Boolean).join(', ') || 'sconosciuto'
      return { region, province, municipality, label }
    })
  } catch {
    return []
  }
}

export async function geocodeCrag(query: string): Promise<GeoResult | null> {
  const list = await geocodeCragCandidates(query)
  return list[0] ?? null
}
