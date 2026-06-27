export const demoLandingStats = [
  { label: 'Vie catalogabili', value: '10k+', note: 'dataset dimostrativo' },
  { label: 'Falesie', value: '500+', note: 'catalogo espandibile' },
  { label: 'Grafici', value: '10+', note: 'analisi tecniche' },
  { label: 'Privacy', value: '100%', note: 'controllo sui dati' },
]

export const demoDashboard = {
  routes: 124,
  crags: 18,
  maxGrade: '7b',
  osFlashRate: '61%',
  activeProjects: 4,
  monthlySessions: 9,
}

export const demoCragTree = [
  {
    region: 'Regione Demo',
    crags: [
      {
        name: 'Monte Demo',
        sectors: [
          {
            name: 'Settore Centrale',
            routes: [
              { name: 'Linea del Sole', grade: '6b+' },
              { name: 'Spigolo Tecnico', grade: '7a' },
              { name: 'Placca Nascosta', grade: '6c' },
            ],
          },
        ],
      },
    ],
  },
]

export const demoRecentAscents = [
  { name: 'Linea del Sole', grade: '6b+', crag: 'Monte Demo', style: 'On-sight' },
  { name: 'Fessura Nordica', grade: '6c', crag: 'Parete Ovest', style: 'Flash' },
  { name: 'Spigolo Tecnico', grade: '7a', crag: 'Monte Demo', style: 'Redpoint' },
]

export const demoActiveProjects = [
  { name: 'Diedro Classico', grade: '7b', crag: 'Monte Demo', attempts: 5 },
  { name: 'Tetto Giallo', grade: '7a+', crag: 'Parete Ovest', attempts: 3 },
  { name: 'Fessura Nera', grade: '6c+', crag: 'Rocca Nord', attempts: 7 },
]
