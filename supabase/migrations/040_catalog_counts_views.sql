-- Conteggi catalogo lato server (perf): evita di scaricare l'intera tabella
-- routes (~15k righe) nel browser solo per contare crag/settori/vie.
-- Le view aggregano per regione e per nazione; gli hook fanno UNA query leggera.
-- Semantica identica al calcolo JS precedente: le vie sono contate via sector_id.

create or replace view public.region_counts
with (security_invoker = true) as
select
  r.id                  as region_id,
  r.country_id          as country_id,
  count(distinct c.id)  as crag_count,
  count(distinct s.id)  as sector_count,
  count(distinct rt.id) as route_count
from public.regions r
left join public.crags   c  on c.region_id  = r.id
left join public.sectors s  on s.crag_id    = c.id
left join public.routes  rt on rt.sector_id = s.id
group by r.id, r.country_id;

create or replace view public.country_counts
with (security_invoker = true) as
select
  co.id                 as country_id,
  count(distinct c.id)  as crag_count,
  count(distinct s.id)  as sector_count,
  count(distinct rt.id) as route_count
from public.countries co
left join public.crags   c  on c.country_id  = co.id
left join public.sectors s  on s.crag_id     = c.id
left join public.routes  rt on rt.sector_id  = s.id
group by co.id;

grant select on public.region_counts  to anon, authenticated;
grant select on public.country_counts to anon, authenticated;

notify pgrst, 'reload schema';
