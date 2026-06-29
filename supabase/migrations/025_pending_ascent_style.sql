-- ============================================================
-- 025_pending_ascent_style.sql
-- pending_ascents: aggiunge ascent_style + attempt_bucket (modello nuovo).
-- Aggiorna import_pending_for_route() per usarli al posto di attempt_type.
-- ============================================================

alter table public.pending_ascents
  add column if not exists ascent_style   text,
  add column if not exists attempt_bucket text;

create or replace function public.import_pending_for_route()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  crag_norm text;
  rec       record;
  new_asc   uuid;
begin
  if NEW.sector_id is not null then
    select c.normalized_name into crag_norm
    from public.sectors s
    join public.crags   c on c.id = s.crag_id
    where s.id = NEW.sector_id;
  end if;

  if crag_norm is null and NEW.crag_id is not null then
    select c.normalized_name into crag_norm
    from public.crags c where c.id = NEW.crag_id;
  end if;

  if crag_norm is null then
    return NEW;
  end if;

  for rec in
    select * from public.pending_ascents
    where status = 'pending'
      and normalized_crag  = crag_norm
      and normalized_route = NEW.normalized_name
  loop
    if exists (
      select 1 from public.ascents a
      where a.user_id = rec.user_id and a.route_id = NEW.id and a.date = rec.date
    ) then
      update public.pending_ascents set status='imported', imported_at=now() where id=rec.id;
      continue;
    end if;

    insert into public.ascents (
      user_id, route_id, date, status,
      attempt_type, ascent_style, attempt_count, attempt_bucket, needs_review,
      grade_at_ascent, grade_snapshot, proposed_grade, quality,
      route_name_snapshot, crag_name_snapshot, sector_name_snapshot,
      notes, visibility
    ) values (
      rec.user_id, NEW.id, rec.date, 'completed',
      null, rec.ascent_style, rec.attempt_count, rec.attempt_bucket,
      (rec.ascent_style is null or rec.grade is null),
      rec.grade, rec.grade, rec.proposed_grade, rec.quality,
      rec.route_name, rec.crag_name, rec.sector_name,
      rec.notes, 'public'
    )
    returning id into new_asc;

    update public.pending_ascents set status='imported', imported_at=now(), ascent_id=new_asc where id=rec.id;
  end loop;

  update public.crag_requests
    set status='resolved', resolved_at=now()
    where status='pending' and normalized_crag=crag_norm and normalized_route=NEW.normalized_name;

  return NEW;
end;
$$;
