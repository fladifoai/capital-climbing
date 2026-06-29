-- ============================================================
-- 023_cleanup_mario_logbook_2.sql
-- Seconda pulizia dati di test fladifo1@gmail.com (mario) per
-- re-import sul codice con Bellezza/quality + alias "Tentativi".
-- No-op se l'utente non esiste.
-- ============================================================

do $$
declare
  uid uuid;
begin
  select id into uid from auth.users where email = 'fladifo1@gmail.com';
  if uid is null then
    raise notice 'Utente non trovato: niente da fare.';
    return;
  end if;

  delete from public.ascents         where user_id      = uid;
  delete from public.sessions        where user_id      = uid;
  delete from public.pending_ascents where user_id      = uid;
  delete from public.crag_requests   where requester_id = uid;

  raise notice 'Pulizia 2 completata per %', uid;
end $$;
