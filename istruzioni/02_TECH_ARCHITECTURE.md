# Architettura tecnica

## Frontend

```text
React
TypeScript
Vite
HashRouter
TanStack Query
React Hook Form
Zod
Recharts
Papa Parse
```

## Backend gestito

```text
Supabase Auth
Supabase PostgreSQL
Supabase Row Level Security
Supabase Storage
Supabase Edge Functions
```

Storage ed Edge Functions possono essere aggiunti dopo l'MVP.

## Hosting

```text
GitHub repository
        ↓
GitHub Actions
        ↓
GitHub Pages

Supabase
├── Auth
├── Database
└── Storage
```

## Struttura consigliata

```text
src/
├── app/
├── components/
├── features/
│   ├── auth/
│   ├── catalog/
│   ├── ascents/
│   ├── projects/
│   ├── sessions/
│   ├── users/
│   ├── analytics/
│   └── admin/
├── lib/
├── hooks/
├── routes/
├── schemas/
├── services/
├── styles/
└── types/

supabase/
├── migrations/
├── seed.sql
└── functions/

docs/
legacy/
.github/workflows/
```

## Rotte frontend

```text
#/login
#/register
#/dashboard
#/explore
#/crags/:cragId
#/routes/:routeId
#/my-routes
#/sessions
#/projects
#/analytics
#/users
#/u/:username
#/settings
#/admin
#/admin/import
```

## Regole

- usare HashRouter per GitHub Pages;
- usare query tipizzate;
- separare accesso dati da componenti UI;
- non incorporare dati reali nel bundle;
- preservare il prototipo in `legacy/`.
