// Geocoding best-effort via Nominatim (OpenStreetMap), gratis, da browser.
// Per falesie italiane: name → state (regione), county (provincia), comune.
// Non climbing-specifico: può sbagliare → l'admin conferma/corregge sempre.
export interface GeoResult {
  region?: string
  province?: string
  municipality?: string
}

export async function geocodeCrag(query: string): Promise<GeoResult | null> {
  const q = query.trim()
  if (!q) return null
  const url = `https://nominatim.openstreetmap.org/search?format=jsonv2&addressdetails=1&limit=1&countrycodes=it&q=${encodeURIComponent(q)}`
  try {
    const res = await fetch(url, { headers: { Accept: 'application/json' } })
    if (!res.ok) return null
    const data = (await res.json()) as { address?: Record<string, string> }[]
    if (!data?.length) return null
    const a = data[0].address ?? {}
    return {
      region: a.state,
      province: a.county ?? a.province ?? a.state_district,
      municipality: a.city ?? a.town ?? a.village ?? a.municipality,
    }
  } catch {
    return null
  }
}
