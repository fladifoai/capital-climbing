"""Fix country_id and region_id on all imported crags (they were NULL after import).

Migration 005 seeds:
  Italy  = 00000000-0000-0000-0001-000000000001
  Regions 0002-000000000001..20 (1=Abruzzo, 7=Lazio, 11=Molise, 14=Sardegna, 18=Umbria, 19=Valle d'Aosta)
Spain + Isole Baleari are NOT in the seed — this script upserts them.
"""
from __future__ import annotations
import os, sys, logging, uuid
from pathlib import Path
import requests, urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

sys.path.insert(0, str(Path(__file__).parent))
from supabase_import import SUPABASE_URL, _headers, _get, _insert

logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")
log = logging.getLogger(__name__)

# ── Known UUIDs from 005_seed_territories.sql ─────────────────────────────────
ITALY_ID  = "00000000-0000-0000-0001-000000000001"
REGIONS_IT = {
    "Abruzzo":       "00000000-0000-0000-0002-000000000001",
    "Lazio":         "00000000-0000-0000-0002-000000000007",
    "Molise":        "00000000-0000-0000-0002-000000000011",
    "Sardegna":      "00000000-0000-0000-0002-000000000014",
    "Umbria":        "00000000-0000-0000-0002-000000000018",
    "Valle d'Aosta": "00000000-0000-0000-0002-000000000019",
}


def _patch(table: str, row_id: str, data: dict) -> None:
    h = _headers()
    h["Prefer"] = "return=minimal"
    resp = requests.patch(
        f"{SUPABASE_URL}/rest/v1/{table}",
        headers=h,
        params={"id": f"eq.{row_id}"},
        json=data,
        verify=False,
    )
    if resp.status_code not in (200, 204):
        raise RuntimeError(f"PATCH {table} {row_id} → {resp.status_code} {resp.text[:300]}")


def ensure_country(name: str, iso2: str, slug: str) -> str:
    rows = _get("countries", {"slug": f"eq.{slug}", "limit": "1"})
    if rows:
        return rows[0]["id"]
    cid = str(uuid.uuid4())
    row = _insert("countries", {"id": cid, "name": name, "iso2": iso2, "slug": slug})
    log.info(f"Country INSERT: {name} → {row['id']}")
    return row["id"]


def ensure_region(country_id: str, name: str, norm: str, slug: str) -> str:
    rows = _get("regions", {"country_id": f"eq.{country_id}", "slug": f"eq.{slug}", "limit": "1"})
    if rows:
        return rows[0]["id"]
    rid = str(uuid.uuid4())
    row = _insert("regions", {
        "id": rid,
        "country_id": country_id,
        "name": name,
        "normalized_name": norm,
        "slug": slug,
    })
    log.info(f"Region INSERT: {name} → {row['id']}")
    return row["id"]


def update_crags_for_country_region(country_texts: list[str], country_id: str, region_text: str | None, region_id: str | None) -> int:
    total = 0
    for country_text in country_texts:
        params: dict = {"country": f"eq.{country_text}", "country_id": "is.null", "select": "id,name,region", "limit": "500"}
        if region_text:
            params["region"] = f"eq.{region_text}"
        rows = _get("crags", params)
        if not rows:
            continue
        patch_data: dict = {"country_id": country_id}
        if region_id:
            patch_data["region_id"] = region_id
        for row in rows:
            _patch("crags", row["id"], patch_data)
            log.info(f"  PATCHED: {row['name']} ({row.get('region', '?')})")
        total += len(rows)
    return total


def run() -> None:
    if not os.environ.get("SUPABASE_SERVICE_KEY"):
        log.error("Set SUPABASE_SERVICE_KEY")
        sys.exit(1)

    total = 0

    # ── Italy: accepts both "Italy" (insert_missing_crags) and "Italia" (supabase_import CSV) ──
    log.info("=== Italy ===")
    for region_name, region_id in REGIONS_IT.items():
        n = update_crags_for_country_region(["Italy", "Italia"], ITALY_ID, region_name, region_id)
        log.info(f"  {region_name}: {n} crags updated")
        total += n

    # Catch any Italy crags with unrecognised region
    n = update_crags_for_country_region(["Italy", "Italia"], ITALY_ID, None, None)
    if n:
        log.warning(f"  Italy (no region match): {n} crags only got country_id")
    total += n

    # ── Spain: accepts both "Spain" and "Spagna" ──────────────────────────────
    log.info("=== Spain ===")
    spain_id = ensure_country("Spagna", "ES", "spain")
    baleari_id = ensure_region(spain_id, "Isole Baleari", "isole-baleari", "isole-baleari")
    n = update_crags_for_country_region(["Spain", "Spagna"], spain_id, "Isole Baleari", baleari_id)
    log.info(f"  Isole Baleari: {n} crags updated")
    total += n

    log.info(f"=== DONE — {total} crags patched ===")


if __name__ == "__main__":
    run()
