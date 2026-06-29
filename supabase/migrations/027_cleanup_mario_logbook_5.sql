-- 027: pulizia dati test fladifo1@gmail.com per re-import. No-op se assente.
do $$
declare uid uuid;
begin
  select id into uid from auth.users where email = 'fladifo1@gmail.com';
  if uid is null then raise notice 'Utente non trovato.'; return; end if;
  delete from public.ascents         where user_id      = uid;
  delete from public.sessions        where user_id      = uid;
  delete from public.pending_ascents where user_id      = uid;
  delete from public.crag_requests   where requester_id = uid;
  raise notice 'Pulizia 5 completata per %', uid;
end $$;
