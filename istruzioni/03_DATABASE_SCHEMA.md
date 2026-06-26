# Schema database

## Principi

- UUID come chiavi primarie;
- `timestamptz` per timestamp;
- foreign key;
- indici;
- check constraint;
- trigger `updated_at`;
- migrazioni SQL versionate.

## Tabelle utenti

### profiles

```text
id
username
display_name
avatar_url
bio
country
city
climbing_since
preferred_style
created_at
updated_at
```

`id` deve riferirsi a `auth.users(id)`.

### user_roles

```text
user_id
role
created_at
```

Ruoli:

```text
user
admin
```

## Catalogo

### sources

```text
id
name
url
license
permission_status
can_publish
can_use_for_statistics
attribution
notes
created_at
```

### crags

```text
id
name
normalized_name
country
region
province
latitude
longitude
altitude_m
rock_type
parking_notes
access_notes
approach_minutes
approach_distance_km
orientation
best_seasons
rainproof
services jsonb
access_status
last_verified_at
created_at
updated_at
```

### sectors

```text
id
crag_id
name
normalized_name
description
orientation
approach_notes
sort_order
created_at
updated_at
```

### routes

```text
id
sector_id
name
normalized_name
official_grade
grade_numeric
length_m
pitches
bolts
angle
route_type
rock_type
first_ascent
bolter
description
created_at
updated_at
```

### route_aliases

```text
id
route_id
alias
normalized_alias
source_id
created_at
```

### route_sources

```text
route_id
source_id
external_id
source_url
retrieved_at
created_at
```

## Dati personali

### ascents

```text
id
user_id
route_id
session_id
date
status
attempt_type
grade_at_ascent
grade_numeric_at_ascent
score
personal_grade
kneepad_used
effort
notes
visibility
created_at
updated_at
```

### projects

```text
id
user_id
route_id
opened_date
last_session_date
priority
status
sessions_count
attempts_count
progress
high_point
moves_solved
moves_missing
next_strategy
beta_notes
visibility
created_at
updated_at
```

### sessions

```text
id
user_id
crag_id
sector_id
date
temperature
humidity
wind
conditions
rock_condition
partner
sleep_quality
rest_days
session_rpe
notes
visibility
created_at
updated_at
```

### attempts

```text
id
user_id
session_id
route_id
attempt_number
result
high_point
fall_move
beta_used
kneepad_used
shoes
effort
rest_minutes
notes
visibility
created_at
```

### user_route_notes

```text
id
user_id
route_id
hold_profile jsonb
movement_profile jsonb
style_profile jsonb
crux
rests
main_beta
alternative_beta
kneepad_data jsonb
equipment_data jsonb
safety_notes
visibility
created_at
updated_at
```

## Import

### import_jobs

```text
id
created_by
filename
status
total_rows
valid_rows
invalid_rows
created_at
completed_at
```

### import_rows

```text
id
import_job_id
row_number
raw_data jsonb
normalized_data jsonb
status
errors jsonb
created_at
```
