-- 045: RLS su _orientation_backup (tabella di backup dei vecchi bot metadati).
-- Era esposta via PostgREST senza RLS (advisor ERROR 0013). Attivo RLS SENZA policy:
-- diventa inaccessibile ad anon/authenticated; solo la service_role (i bot) la legge/scrive.
-- Nessuna policy = deny-all per i ruoli API. Non rompe nulla (backup, non usata dalla UI).

alter table if exists public._orientation_backup enable row level security;
