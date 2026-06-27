"""Import climbook CSV data into Supabase (crags, sectors, routes)."""
from __future__ import annotations

import csv
import logging
import os
import sys
from pathlib import Path

import requests
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

sys.path.insert(0, str(Path(__file__).parent))
from normalizers import normalize_name, normalize_route_name
from config import OUTPUT_CSV

logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")
log = logging.getLogger(__name__)

SUPABASE_URL = "https://apfyktdacsklnptcgjko.supabase.co"
SERVICE_KEY = os.environ.get("SUPABASE_SERVICE_KEY", "")

GRADE_NUMERIC: dict[str, float] = {
    "3": 3.0, "3+": 3.3,
    "4-": 3.7, "4": 4.0, "4+": 4.3,
    "5-": 4.7, "5": 5.0, "5+": 5.3,
    "5a": 5.0, "5b": 5.1, "5c": 5.2,
    "6a": 6.0, "6a+": 6.1,
    "6b": 6.2, "6b+": 6.3,
    "6c": 6.4, "6c+": 6.5,
    "7a": 7.0, "7a+": 7.1,
    "7b": 7.2, "7b+": 7.3,
    "7c": 7.4, "7c+": 7.5,
    "8a": 8.0, "8a+": 8.1,
    "8b": 8.2, "8b+": 8.3,
    "8c": 8.4, "8c+": 8.5,
    "9a": 9.0, "9a+": 9.1,
    "9b": 9.2, "9b+": 9.3,
    "9c": 9.4,
}


def _headers() -> dict:
    return {
        "apikey": SERVICE_KEY,
        "Authorization": f"Bearer {SERVICE_KEY}",
        "Content-Type": "application/json",
        "Prefer": "return=representation",
    }


def _get(table: str, params: dict) -> list:
    resp = requests.get(
        f"{SUPABASE_URL}/rest/v1/{table}",
        headers=_headers(),
        params=params,
        verify=False,
    )
    resp.raise_for_status()
    return resp.json()


def _insert(table: str, data: dict) -> dict:
    resp = requests.post(
        f"{SUPABASE_URL}/rest/v1/{table}",
        headers=_headers(),
        json=data,
        verify=False,
    )
    resp.raise_for_status()
    rows = resp.json()
    return rows[0] if rows else {}


def find_crag(normalized: str) -> dict | None:
    rows = _get("crags", {"normalized_name": f"eq.{normalized}", "limit": "1"})
    return rows[0] if rows else None


def find_sector(crag_id: str, normalized: str) -> dict | None:
    rows = _get("sectors", {
        "crag_id": f"eq.{crag_id}",
        "normalized_name": f"eq.{normalized}",
        "limit": "1",
    })
    return rows[0] if rows else None


def fetch_all_routes_in_sector(sector_id: str) -> set[str]:
    """Return set of normalized_names already in this sector."""
    rows = _get("routes", {"sector_id": f"eq.{sector_id}", "select": "normalized_name", "limit": "1000"})
    return {r["normalized_name"] for r in rows}


def bulk_insert(table: str, data: list[dict]) -> list[dict]:
    resp = requests.post(
        f"{SUPABASE_URL}/rest/v1/{table}",
        headers=_headers(),
        json=data,
        verify=False,
    )
    resp.raise_for_status()
    return resp.json()


def grade_num(grade: str) -> float | None:
    if not grade:
        return None
    return GRADE_NUMERIC.get(grade.strip().lower())


def or_none(val: str) -> str | None:
    v = val.strip()
    return v if v else None


def _int(val: str) -> int | None:
    try:
        return int(val) if val.strip() else None
    except ValueError:
        return None


def _float(val: str) -> float | None:
    try:
        return float(val) if val.strip() else None
    except ValueError:
        return None


def run(csv_path: Path = OUTPUT_CSV) -> None:
    if not SERVICE_KEY:
        log.error("Set SUPABASE_SERVICE_KEY env var before running.")
        sys.exit(1)

    rows = list(csv.DictReader(csv_path.open(encoding="utf-8")))
    log.info(f"CSV: {len(rows)} rows from {csv_path}")

    # ── 1. Crags ────────────────────────────────────────────────
    crag_id_map: dict[str, str] = {}  # normalized_crag_name -> uuid

    crags_seen: dict[str, dict] = {}
    for r in rows:
        n = normalize_name(r["crag_name"])
        if n and n not in crags_seen:
            crags_seen[n] = r

    inserted_crags = skipped_crags = 0
    for norm, r in crags_seen.items():
        existing = find_crag(norm)
        if existing:
            crag_id_map[norm] = existing["id"]
            skipped_crags += 1
            log.info(f"  Crag EXISTS: {r['crag_name']}")
            continue

        payload: dict = {
            "name": r["crag_name"],
            "normalized_name": norm,
            "country": or_none(r["country"]) or "Italy",
            "region": or_none(r["region"]),
            "province": or_none(r["province_or_area"]),
            "rock_type": or_none(r["rock_type"]),
            "last_verified_at": or_none(r["last_verified_at"]),
        }
        row = _insert("crags", payload)
        crag_id_map[norm] = row["id"]
        inserted_crags += 1
        log.info(f"  Crag INSERT: {r['crag_name']} → {row['id']}")

    log.info(f"Crags: {inserted_crags} inserted, {skipped_crags} skipped")

    # ── 2. Sectors ───────────────────────────────────────────────
    sector_id_map: dict[tuple[str, str], str] = {}  # (crag_norm, sector_norm) -> uuid

    sectors_seen: dict[tuple[str, str], dict] = {}
    for r in rows:
        cn = normalize_name(r["crag_name"])
        sn = normalize_name(r["sector_name"]) if r["sector_name"].strip() else "_default"
        key = (cn, sn)
        if key not in sectors_seen:
            sectors_seen[key] = r

    inserted_sectors = skipped_sectors = 0
    for (cn, sn), r in sectors_seen.items():
        crag_id = crag_id_map.get(cn)
        if not crag_id:
            continue

        existing = find_sector(crag_id, sn)
        if existing:
            sector_id_map[(cn, sn)] = existing["id"]
            skipped_sectors += 1
            continue

        sector_display = r["sector_name"].strip() if r["sector_name"].strip() else r["crag_name"]
        payload = {
            "crag_id": crag_id,
            "name": sector_display,
            "normalized_name": sn,
            "orientation": or_none(r["orientation"]),
        }
        row = _insert("sectors", payload)
        sector_id_map[(cn, sn)] = row["id"]
        inserted_sectors += 1

    log.info(f"Sectors: {inserted_sectors} inserted, {skipped_sectors} skipped")

    # ── 3. Routes — group by sector, bulk insert ─────────────────
    from collections import defaultdict
    routes_by_sector: dict[str, list[dict]] = defaultdict(list)

    for r in rows:
        cn = normalize_name(r["crag_name"])
        sn = normalize_name(r["sector_name"]) if r["sector_name"].strip() else "_default"
        sector_id = sector_id_map.get((cn, sn))
        if not sector_id:
            log.warning(f"  No sector for: {r['route_name']} @ {r['crag_name']}")
            continue
        routes_by_sector[sector_id].append(r)

    inserted_routes = skipped_routes = 0
    for sector_id, sector_rows in routes_by_sector.items():
        existing_names = fetch_all_routes_in_sector(sector_id)
        to_insert = []
        for r in sector_rows:
            rn = normalize_route_name(r["route_name"])
            if rn in existing_names:
                skipped_routes += 1
                continue
            official_grade = or_none(r["official_grade"])
            to_insert.append({
                "sector_id": sector_id,
                "name": r["route_name"],
                "normalized_name": rn,
                "official_grade": official_grade,
                "grade_numeric": grade_num(official_grade) if official_grade else None,
                "length_m": _int(r.get("length_m", "")),
                "pitches": _int(r.get("pitches", "")),
                "bolts": _int(r.get("bolts", "")),
                "rock_type": or_none(r.get("rock_type", "")),
            })

        if to_insert:
            BATCH = 50
            for i in range(0, len(to_insert), BATCH):
                chunk = to_insert[i:i + BATCH]
                bulk_insert("routes", chunk)
                inserted_routes += len(chunk)
                log.info(f"  Routes batch {i//BATCH + 1}: {len(chunk)} inserted")

    log.info(f"Routes: {inserted_routes} inserted, {skipped_routes} skipped")
    log.info("=== IMPORT DONE ===")


if __name__ == "__main__":
    run()
