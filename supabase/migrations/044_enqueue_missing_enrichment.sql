-- 044: RPC per mettere in coda TUTTE le falesie con almeno un campo mancante
-- (backfill). Admin-only. Idempotente: non ri-accoda chi e' gia' in coda.
-- Il cron `crag-enrich-drain` poi svuota la coda nel tempo.

-- SECURITY INVOKER: l'insert e' protetto dalla RLS della coda (with check is_admin);
-- il check esplicito sotto resta come difesa. Evita il warning 0029.
create or replace function public.enqueue_missing_enrichment()
returns integer
language plpgsql
security invoker
set search_path = public
as $$
declare
  n integer;
begin
  if not public.is_admin() then
    raise exception 'solo admin';
  end if;

  with candidates as (
    select c.id
    from public.crags c
    where c.latitude is null
       or c.altitude_m is null
       or c.orientation is null
       or c.best_seasons is null
       or array_length(c.best_seasons, 1) is null
       or exists (
         select 1 from public.sectors s
         where s.crag_id = c.id
           and (s.orientation is null or s.best_season is null or s.best_months is null
                or s.sun_morning is null or s.summer_score is null)
       )
  ), inserted as (
    insert into public.enrichment_queue (crag_id)
    select id from candidates
    on conflict (crag_id) do nothing
    returning 1
  )
  select count(*) into n from inserted;
  return n;
end;
$$;

revoke all on function public.enqueue_missing_enrichment() from public, anon;
grant execute on function public.enqueue_missing_enrichment() to authenticated;
