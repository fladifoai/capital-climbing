-- ============================================================
-- 042_trigram_search.sql
-- Ricerca vie/falesie per SIMILARITÀ (pg_trgm) invece di ilike.
-- - tolleranza refusi (trigram)
-- - accenti/apostrofi normalizzati (unaccent + strip apostrofi)
-- - match anche su route_aliases e crags.aliases
-- - risultati ordinati per rilevanza, non alfabetici
-- ============================================================

create extension if not exists pg_trgm;

-- unaccent NON è immutable di suo → wrapper immutable per poterlo indicizzare.
-- Toglie anche gli apostrofi (de' → de) per uniformare i nomi.
create or replace function public.f_unaccent(text)
returns text
language sql immutable parallel safe strict
as $$
  select translate(
    extensions.unaccent('extensions.unaccent'::regdictionary, lower($1)),
    '''’`',
    ''
  )
$$;

-- ─── Indici GIN trigram ──────────────────────────────────────
create index if not exists idx_routes_name_trgm
  on public.routes using gin (public.f_unaccent(name) gin_trgm_ops);
create index if not exists idx_crags_name_trgm
  on public.crags using gin (public.f_unaccent(name) gin_trgm_ops);
create index if not exists idx_route_aliases_trgm
  on public.route_aliases using gin (public.f_unaccent(alias) gin_trgm_ops);

-- ─── RPC ricerca vie ─────────────────────────────────────────
create or replace function public.search_routes(q text, lim int default 20)
returns table (
  id uuid, name text, official_grade text, grade_numeric numeric,
  route_type text, crag_id uuid, crag_name text, sector_name text, score real
)
language sql stable
as $$
  with nq as (select public.f_unaccent(trim(q)) as v)
  select r.id, r.name, r.official_grade, r.grade_numeric, r.route_type,
         coalesce(r.crag_id, sec.crag_id) as crag_id,
         c.name as crag_name,
         sec.name as sector_name,
         (
           greatest(
             similarity(public.f_unaccent(r.name), (select v from nq)),
             coalesce((
               select max(similarity(public.f_unaccent(ra.alias), (select v from nq)))
               from public.route_aliases ra where ra.route_id = r.id
             ), 0)
           )
           -- boost se il nome contiene la query come sottostringa esatta
           + case when public.f_unaccent(r.name) like '%'||(select v from nq)||'%' then 0.3 else 0 end
         )::real as score
  from public.routes r
  left join public.sectors sec on sec.id = r.sector_id
  left join public.crags   c   on c.id   = coalesce(r.crag_id, sec.crag_id)
  where public.f_unaccent(r.name) % (select v from nq)
     or public.f_unaccent(r.name) like '%'||(select v from nq)||'%'
     or exists (
          select 1 from public.route_aliases ra
          where ra.route_id = r.id
            and public.f_unaccent(ra.alias) % (select v from nq)
        )
  order by score desc, r.name
  limit lim;
$$;

-- ─── RPC ricerca falesie ─────────────────────────────────────
create or replace function public.search_crags(q text, lim int default 15)
returns table (id uuid, name text, region text, province text, score real)
language sql stable
as $$
  with nq as (select public.f_unaccent(trim(q)) as v)
  select c.id, c.name, c.region, c.province,
         (
           greatest(
             similarity(public.f_unaccent(c.name), (select v from nq)),
             coalesce((
               select max(similarity(public.f_unaccent(a), (select v from nq)))
               from unnest(c.aliases) a
             ), 0)
           )
           + case when public.f_unaccent(c.name) like '%'||(select v from nq)||'%' then 0.3 else 0 end
         )::real as score
  from public.crags c
  where public.f_unaccent(c.name) % (select v from nq)
     or public.f_unaccent(c.name) like '%'||(select v from nq)||'%'
     or exists (
          select 1 from unnest(c.aliases) a
          where public.f_unaccent(a) % (select v from nq)
        )
  order by score desc, c.name
  limit lim;
$$;

grant execute on function public.search_routes(text, int) to anon, authenticated;
grant execute on function public.search_crags(text, int)  to anon, authenticated;
