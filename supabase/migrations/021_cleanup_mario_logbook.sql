-- ============================================================
-- 020_cleanup_mario_logbook.sql
-- Pulizia dati di test dell'utente fladifo1@gmail.com (mario):
-- elimina ascensioni, sessioni auto, coda pending e richieste falesia
-- per ri-importare il logbook da zero col matching corretto.
-- Su un DB senza quell'utente è un no-op (DELETE su 0 righe).
-- ============================================================

do $$
declare
  uid uuid;
begin
  select id into uid from auth.users where email = 'fladifo1@gmail.com';
  if uid is null then
    raise notice 'Utente fladifo1@gmail.com non trovato: niente da fare.';
    return;
  end if;

  delete from public.ascents        where user_id      = uid;
  delete from public.sessions       where user_id      = uid;
  delete from public.pending_ascents where user_id     = uid;
  delete from public.crag_requests  where requester_id = uid;

  raise notice 'Pulizia completata per %', uid;
end $$;
