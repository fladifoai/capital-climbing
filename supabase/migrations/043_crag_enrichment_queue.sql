-- 043: coda di arricchimento falesie + drain automatico via pg_cron -> edge function.
--
-- Scopo: quando si importa/crea una falesia (o per backfill) si mette una riga in coda;
-- una edge function `crag-enrich` la processa (geocode, quota, orientamento, stagione,
-- best_months) in modo IDEMPOTENTE e VALIDA-NON-SOVRASCRIVE (se un campo c'e' gia',
-- non lo tocca; se l'utente lo ha fornito e il calcolo diverge -> needs_review).
-- Il cron sveglia la function ogni minuto finche' la coda non e' vuota (resumable).

create extension if not exists pg_cron;
create extension if not exists pg_net;

create table if not exists public.enrichment_queue (
  id uuid primary key default gen_random_uuid(),
  crag_id uuid not null references public.crags(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending','running','done','error')),
  attempts int not null default 0,
  max_attempts int not null default 5,
  last_error text,
  -- campi forniti a mano dall'utente (da validare, mai sovrascrivere)
  provided jsonb not null default '{}'::jsonb,
  -- diagnostica dell'ultimo run (status coord, fonti, valori scritti)
  result jsonb,
  -- discrepanze utente-vs-calcolato da rivedere a mano
  needs_review boolean not null default false,
  review jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (crag_id)
);
create index if not exists enrichment_queue_status_idx on public.enrichment_queue (status, created_at);

alter table public.enrichment_queue enable row level security;

-- Solo admin legge/gestisce dal client. La edge function usa service_role e bypassa RLS.
drop policy if exists enrichment_queue_admin_all on public.enrichment_queue;
create policy enrichment_queue_admin_all on public.enrichment_queue
  for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- Claim atomico: marca 'running' e ritorna i job da processare, senza doppioni tra
-- invocazioni concorrenti del cron (FOR UPDATE SKIP LOCKED). Ripesca i 'running' bloccati
-- da >10 min (function morta a meta'). Rispetta max_attempts.
create or replace function public.claim_enrichment_jobs(p_limit int default 3)
returns setof public.enrichment_queue
language sql
security definer
set search_path = public
as $$
  update public.enrichment_queue q
     set status = 'running', updated_at = now()
   where q.id in (
     select id from public.enrichment_queue
      where attempts < max_attempts
        and (status = 'pending'
             or (status = 'running' and updated_at < now() - interval '10 minutes'))
      order by created_at
      limit greatest(p_limit, 1)
      for update skip locked
   )
  returning q.*;
$$;
revoke all on function public.claim_enrichment_jobs(int) from public, anon, authenticated;
grant execute on function public.claim_enrichment_jobs(int) to service_role;

-- Cron: ogni minuto POSTa alla edge function (anon key = pubblica, ok in chiaro).
-- La function fa il lavoro pesante e throttla le API esterne; batch piccolo per giro.
select cron.unschedule('crag-enrich-drain') where exists (
  select 1 from cron.job where jobname = 'crag-enrich-drain'
);
select cron.schedule(
  'crag-enrich-drain',
  '* * * * *',
  $cron$
  select net.http_post(
    url := 'https://apfyktdacsklnptcgjko.supabase.co/functions/v1/crag-enrich',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFwZnlrdGRhY3NrbG5wdGNnamtvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI0MjkwOTUsImV4cCI6MjA5ODAwNTA5NX0.aCeSZzhVXkCCrcujdTHzJ6caKIDeqzNyXFnYQIozw5I'
    ),
    body := jsonb_build_object('mode', 'drain', 'batch', 3)
  );
  $cron$
);
