export type AscentStyle = 'onsight' | 'flash' | 'redpoint' | 'repeat' | 'unknown'

export function normalizeAscentStyle(value: string | null | undefined): AscentStyle {
  if (!value) return 'unknown'
  const v = value.trim().toLowerCase()
  if (v === 'onsight' || v === 'on-sight') return 'onsight'
  if (v === 'flash') return 'flash'
  if (v === 'redpoint' || v === 'second' || v === 'third' || v === 'four_plus' ||
      v === '2nd' || v === '3rd' || v === '4th_plus') return 'redpoint'
  if (v === 'repeat') return 'repeat'
  return 'unknown'
}

export const ASCENT_STYLE_LABELS: Record<AscentStyle, string> = {
  onsight: 'On-sight',
  flash: 'Flash',
  redpoint: 'Redpoint',
  repeat: 'Ripetizione',
  unknown: 'Non specificato',
}

export const ASCENT_STYLE_COLORS: Record<AscentStyle, string> = {
  onsight: '#28B487',
  flash: '#4C9BE8',
  redpoint: '#D9902F',
  repeat: '#A78BFA',
  unknown: '#8E887E',
}

export const ASCENT_STYLE_ORDER: AscentStyle[] = ['onsight', 'flash', 'redpoint', 'repeat', 'unknown']
