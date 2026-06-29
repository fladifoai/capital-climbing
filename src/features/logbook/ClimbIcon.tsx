// Custom line-art icons for climbing technical attributes (stile / prese / movimenti).
// One glyph per attribute key, drawn to reflect its meaning.
// Style: 24×24 viewBox, stroke=currentColor, no fill, round caps — coherent line-art.
import type { ReactNode } from 'react'

// ─── Glyph registry ─────────────────────────────────────────────────────────
// Each entry is the inner SVG content for its key.
const G: Record<string, ReactNode> = {

  // ═══ STILE ═══
  technical: (<><circle cx="12" cy="12" r="8.5" /><circle cx="12" cy="12" r="4.5" /><circle cx="12" cy="12" r="1" /></>),
  powerful: (<><path d="M5 16h4a2 2 0 0 0 2-2v-1" /><path d="M11 13a3 3 0 1 0 3 3" /><path d="M14 11V6h3v3" /><path d="M14 6h3" /></>),
  endurance: (<><rect x="6" y="7" width="12" height="10" rx="2" /><path d="M18 10h2v4h-2" /><path d="M9 10v4M12 9v6M15 10v4" /></>),
  sustained: (<><path d="M3 12c2-4 4 4 6 0s4 4 6 0 4 4 6 0" /></>),
  boulderish: (<><path d="M4 18l5-9 4 5 2-3 5 7z" /><circle cx="9" cy="7" r="1.3" /></>),
  physical: (<><path d="M13 3 5 13h6l-2 8 10-11h-6z" /></>),
  balance: (<><path d="M12 4v3" /><path d="M5 7h14" /><path d="M5 7l-2.5 5a3 3 0 0 0 5 0z" /><path d="M19 7l-2.5 5a3 3 0 0 0 5 0z" /><path d="M9 20h6" /></>),
  reading: (<><path d="M2 12s4-6 10-6 10 6 10 6-4 6-10 6-10-6-10-6z" /><circle cx="12" cy="12" r="2.5" /></>),
  finger: (<><path d="M8 21v-6l-2-2a1.5 1.5 0 0 1 2-2l1 1V5a1.5 1.5 0 0 1 3 0v6" /><path d="M12 11V4a1.5 1.5 0 0 1 3 0v8" /><path d="M15 12v-1a1.5 1.5 0 0 1 3 0v5a5 5 0 0 1-5 5H9" /></>),
  footwork: (<><path d="M7 4c2 0 3 2 3 5s-1 5-3 9c-2 0-3-2-3-5s1-7 3-9z" /><circle cx="14" cy="6" r="1" /><circle cx="16" cy="8" r="1" /><circle cx="17" cy="11" r="1" /><circle cx="16" cy="14" r="1" /></>),
  pumpy: (<><path d="M12 3c4 5 5 8 5 11a5 5 0 0 1-10 0c0-3 1-6 5-11z" /><path d="M12 21c2 0 3-2 3-4" /></>),
  mental: (<><path d="M16 5a5 5 0 0 0-9 3 4 4 0 0 0 0 8 4 4 0 0 0 7 1" /><path d="M12 5v14" /><path d="M12 9h3M12 13h4" /></>),
  single_crux: (<><path d="M12 4 3 19h18z" /><path d="M12 11v4M12 17v.5" /></>),
  hard_start: (<><circle cx="12" cy="19" r="2.5" /><path d="M12 16V5" /><path d="M8 9l4-4 4 4" /></>),
  hard_finish: (<><path d="M6 21V4h11l-2 3 2 3H6" /><path d="M6 21h.01" /></>),
  consistent: (<><path d="M4 17h3v-4h3v-4h4v8h3v-6h2" /></>),
  overhang: (<><path d="M5 4v16" /><path d="M5 4c7 0 11 3 11 9" /><path d="M16 13l3-2M16 13l-1-3" /></>),
  slab: (<><path d="M4 20 18 6" /><path d="M4 20h14" /><path d="M14 6l4 .5-.5 4" transform="translate(-4 0)" /></>),
  wall: (<><path d="M8 3v18" /><path d="M14 3v18" /><path d="M11 6v2M11 12v2M11 17v.5" /></>),
  diedre: (<><path d="M12 3v18" /><path d="M12 3 4 9" /><path d="M12 3l8 6" /></>),
  crack: (<><path d="M12 3l-2 4 3 3-3 4 2 3-1 4" /></>),
  roof: (<><path d="M3 7h12c4 0 4 6 0 6" /><path d="M3 7v3M11 7v3M15 9l-1 3 3-1" /></>),

  // ═══ PRESE ═══
  crimp_sharp: (<><path d="M3 14h18l-3-4" /><path d="M8 14v-4M11 14v-5M14 14v-4M17 14v-3" /></>),
  crimp_rounded: (<><path d="M3 14a9 5 0 0 1 18 0" /><path d="M8 12v-3M11 11v-3M14 11v-3M17 12v-2" /></>),
  mono: (<><circle cx="12" cy="14" r="4" /><path d="M12 10V4" /></>),
  two_finger: (<><circle cx="12" cy="15" r="5" /><path d="M10 11V4M14 11V4" /></>),
  three_finger: (<><circle cx="12" cy="15" r="5.5" /><path d="M9 11V5M12 10V4M15 11V5" /></>),
  sloper: (<><path d="M3 18a9 8 0 0 1 18 0" /><path d="M8 11l1 4M12 9v5M16 11l-1 4" /></>),
  pinch: (<><path d="M8 4c-2 2-2 5 0 8l2-1" /><path d="M16 4c2 2 2 5 0 8l-2-1" /><rect x="10" y="9" width="4" height="10" rx="1.5" /></>),
  jug: (<><path d="M4 8h16v3a4 4 0 0 1-4 4h-1" /><path d="M8 15v3M11 15v4M14 15v3" /></>),
  barrel: (<><path d="M9 3c-2 6-2 12 0 18" /><path d="M15 3c2 6 2 12 0 18" /><path d="M9 9h6M9 15h6" /></>),
  sidepull: (<><rect x="10" y="3" width="4" height="18" rx="1.5" /><path d="M9 12H3M3 12l3-2M3 12l3 2" /></>),
  gaston: (<><rect x="10" y="3" width="4" height="18" rx="1.5" /><path d="M15 12h6M21 12l-3-2M21 12l-3 2" /></>),
  undercling: (<><path d="M3 9h18" /><path d="M5 9c0 3 2 5 7 5s7-2 7-5" /><path d="M12 14v6M12 20l-2-2M12 20l2-2" /></>),
  foothold_large: (<><rect x="4" y="13" width="11" height="5" rx="1" /><path d="M17 5c1.5 0 2.5 1.5 2.5 4s-1 4-2.5 6" /></>),
  foothold_small: (<><rect x="9" y="14" width="5" height="3" rx="1" /><path d="M18 6c1 0 1.6 1 1.6 2.5S19 11 18 12.5" /></>),
  slick: (<><path d="M12 3c3 5 5 8 5 11a5 5 0 0 1-10 0c0-3 2-6 5-11z" /><path d="M10 14a2 3 0 0 0 1 4" /></>),
  sharp: (<><path d="M3 16l3-6 3 6 3-6 3 6 3-6 3 6" /><path d="M3 19h18" /></>),
  morphological: (<><path d="M6 3v18M18 3v18" /><path d="M6 3h12M6 21h12" /><path d="M6 8h3M15 8h3M6 13h3M15 13h3M6 18h3M15 18h3" /></>),

  // ═══ MOVIMENTI ═══
  static: (<><circle cx="12" cy="6" r="2.2" /><path d="M12 8v7" /><path d="M8 11h8" /><path d="M12 15l-3 5M12 15l3 5" /></>),
  dynamic: (<><path d="M12 3v6M12 9l5-3M12 9l-5-3" /><path d="M5 14l4 2-1 5M19 14l-4 2 1 5" /><circle cx="12" cy="11" r="1.5" /></>),
  jump: (<><circle cx="12" cy="5" r="2" /><path d="M12 7v5l-3 4M12 12l3 4" /><path d="M7 9l5 3 5-3" /><path d="M5 21q7-5 14 0" /></>),
  long_reach: (<><circle cx="9" cy="6" r="2" /><path d="M9 8v6l-2 6" /><path d="M9 11l11-6" /><path d="M20 5l-3 .5M20 5l-.5 3" /></>),
  cross: (<><path d="M5 6l14 12M19 6 5 18" /><circle cx="5" cy="6" r="1.5" /><circle cx="19" cy="6" r="1.5" /></>),
  hand_swap: (<><path d="M7 8a5 5 0 0 1 10 0" /><path d="M17 8l-2-2M17 8l2-2" /><path d="M17 16a5 5 0 0 1-10 0" /><path d="M7 16l2 2M7 16l-2 2" /></>),
  foot_swap: (<><path d="M6 5c1.5 0 2.5 2 2.5 5S7.5 17 6 19" /><path d="M18 5c-1.5 0-2.5 2-2.5 5s1 7 2.5 9" /><path d="M11 12h2M11 9l2 3-2 3" /></>),
  flag: (<><path d="M7 3v18" /><path d="M7 4h10l-3 3 3 3H7" /></>),
  bicycle: (<><circle cx="6" cy="16" r="3" /><circle cx="18" cy="16" r="3" /><path d="M6 16l4-7h5l-3 7" /><path d="M10 9h4" /></>),
  lolotte: (<><circle cx="13" cy="5" r="2" /><path d="M13 7v5" /><path d="M13 12l-5 2 3 3" /><path d="M13 12l4 3-2 4" /></>),
  dulfer: (<><path d="M9 3v18" /><path d="M9 8l5-3M14 5l-.5 3M14 5l-3 .5" /><path d="M9 14l5 3M14 17l-.5-3M14 17l-3-.5" /></>),
  compression: (<><rect x="9" y="6" width="6" height="12" rx="1.5" /><path d="M6 12H3M3 12l2-2M3 12l2 2" /><path d="M18 12h3M21 12l-2-2M21 12l-2 2" /></>),
  opposition: (<><path d="M5 12h6M11 12l-2-2M11 12l-2 2" /><path d="M19 12h-6M13 12l2-2M13 12l2 2" /><path d="M12 4v16" /></>),
  heel_hook: (<><path d="M6 5c2 0 3 2 3 5l6 5c2 2 0 5-2 4l-7-3c-2-1-3-3-3-7 0-4 1-6 3-6z" /><path d="M14 16l2 2" /></>),
  toe_hook: (<><path d="M18 6c-2 0-3 2-3 5l-6 5c-2 2 0 5 2 4l7-3c2-1 3-4 3-8 0-2-1-3-3-3z" /><circle cx="9" cy="18" r="1" /></>),
  kneebar: (<><path d="M8 3v8l5 5" /><path d="M8 11l-3 3" /><rect x="3" y="13" width="18" height="3" rx="1" transform="rotate(8 12 14)" /></>),
  campus: (<><path d="M7 3v18M17 3v18" /><path d="M7 7h10M7 12h10M7 17h10" /></>),
  coordination: (<><circle cx="7" cy="8" r="2.5" /><circle cx="16" cy="14" r="2.5" /><path d="M9 9q4 1 5 4" /><path d="M14 13l.5-2.5M14 13l2-.5" /></>),
  mandatory: (<><path d="M12 3 3 20h18z" /><path d="M12 9v5M12 16v.5" /></>),
  mantle: (<><path d="M3 14h18" /><path d="M8 14v-3a4 4 0 0 1 8 0v3" /><path d="M12 8V3M12 3l-2 2M12 3l2 2" /></>),
  traverse: (<><path d="M3 12h16M3 12l4-3M3 12l4 3" /><path d="M19 6v12" /></>),
  rock_over: (<><path d="M5 12a7 7 0 0 1 14 0" /><path d="M19 12l-2-2M19 12l2-2" /><circle cx="9" cy="16" r="1.3" /><circle cx="15" cy="9" r="1.3" /></>),
  jam: (<><path d="M9 3v6l-2 2v6a3 3 0 0 0 6 0v-3" /><path d="M13 14V6a1.5 1.5 0 0 1 3 0v6" /><path d="M16 12l3-1" /></>),
  drop_knee: (<><circle cx="11" cy="5" r="2" /><path d="M11 7v4l4 2" /><path d="M11 11l-4 3 3 3" /><path d="M15 13l1 4" /></>),
  deadpoint: (<><circle cx="12" cy="12" r="9" /><circle cx="12" cy="12" r="1.5" /><path d="M12 3v3M12 18v3M3 12h3M18 12h3" /></>),
}

// ─── Component ──────────────────────────────────────────────────────────────

export default function ClimbIcon({ name, size = 26 }: { name: string; size?: number }) {
  const glyph = G[name]
  if (!glyph) return <span style={{ fontSize: size * 0.8 }}>•</span>
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={1.7}
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
    >
      {glyph}
    </svg>
  )
}

export const CLIMB_ICON_KEYS = Object.keys(G)
