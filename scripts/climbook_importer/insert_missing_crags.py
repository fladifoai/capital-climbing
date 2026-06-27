"""Insert the 5 crags not found on Climbook, with their logbook routes."""
from __future__ import annotations
import os, sys, logging
from pathlib import Path
import requests, urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")
log = logging.getLogger(__name__)

sys.path.insert(0, str(Path(__file__).parent))
from normalizers import normalize_name, normalize_route_name
from supabase_import import SUPABASE_URL, _headers, _get, _insert, grade_num, bulk_insert

CRAGS = [
    {
        "name": "Configni",
        "country": "Italy",
        "region": "Lazio",
        "province": "Rieti",
        "sectors": [
            {
                "name": "Principale",
                "routes": [
                    {"name": "Rino",                     "official_grade": "6b+"},
                    {"name": "Il calderone celtico",      "official_grade": "6a"},
                    {"name": "Ai Configni della Realtà",  "official_grade": "6a+"},
                    {"name": "Pilastrino",               "official_grade": "6b"},
                ],
            }
        ],
    },
    {
        "name": "Colle dell'Orso",
        "country": "Italy",
        "region": "Molise",
        "province": "Isernia",
        "sectors": [
            {
                "name": "Blocco P, Q - Morgia Quadra",
                "routes": [
                    {"name": "Charriba",                       "official_grade": "6c"},
                    {"name": "Olive fritte L1",                "official_grade": "6b"},
                    {"name": "Fagian Club",                    "official_grade": "6b+"},
                    {"name": "Socrate",                        "official_grade": "6a+"},
                    {"name": "Cardine sinistro",               "official_grade": "6b"},
                    {"name": "Pantera nera (Latte e caffe')",  "official_grade": "6a+"},
                ],
            }
        ],
    },
    {
        "name": "Miollet",
        "country": "Italy",
        "region": "Valle d'Aosta",
        "province": "Aosta",
        "sectors": [
            {
                "name": "Destro",
                "routes": [
                    {"name": "Il porco", "official_grade": "6b"},
                ],
            }
        ],
    },
    {
        "name": "Ermita de Betlem",
        "country": "Spain",
        "region": "Isole Baleari",
        "province": "Mallorca",
        "sectors": [
            {
                "name": "Principale",
                "routes": [
                    {"name": "Belle Epoque", "official_grade": "6b+"},
                ],
            }
        ],
    },
    {
        "name": "Tijuana",
        "country": "Spain",
        "region": "Isole Baleari",
        "province": "Mallorca",
        "sectors": [
            {
                "name": "Principale",
                "routes": [
                    {"name": "Tapas",           "official_grade": "6a+"},
                    {"name": "Colesterol Party", "official_grade": "6a+"},
                    {"name": "Es diedro",        "official_grade": "5c"},
                ],
            }
        ],
    },
]


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


def run() -> None:
    key = os.environ.get("SUPABASE_SERVICE_KEY", "")
    if not key:
        log.error("Set SUPABASE_SERVICE_KEY env var")
        sys.exit(1)

    for crag_data in CRAGS:
        cn = normalize_name(crag_data["name"])
        existing_crag = find_crag(cn)
        if existing_crag:
            crag_id = existing_crag["id"]
            log.info(f"Crag EXISTS: {crag_data['name']}")
        else:
            row = _insert("crags", {
                "name": crag_data["name"],
                "normalized_name": cn,
                "country": crag_data["country"],
                "region": crag_data["region"],
                "province": crag_data["province"],
            })
            crag_id = row["id"]
            log.info(f"Crag INSERT: {crag_data['name']} → {crag_id}")

        for sec_data in crag_data["sectors"]:
            sn = normalize_name(sec_data["name"])
            existing_sec = find_sector(crag_id, sn)
            if existing_sec:
                sec_id = existing_sec["id"]
                log.info(f"  Sector EXISTS: {sec_data['name']}")
            else:
                row = _insert("sectors", {
                    "crag_id": crag_id,
                    "name": sec_data["name"],
                    "normalized_name": sn,
                })
                sec_id = row["id"]
                log.info(f"  Sector INSERT: {sec_data['name']} → {sec_id}")

            existing_route_names = {
                r["normalized_name"]
                for r in _get("routes", {"sector_id": f"eq.{sec_id}", "select": "normalized_name", "limit": "200"})
            }

            to_insert = []
            for r in sec_data["routes"]:
                rn = normalize_route_name(r["name"])
                if rn in existing_route_names:
                    log.info(f"    Route EXISTS: {r['name']}")
                    continue
                to_insert.append({
                    "sector_id": sec_id,
                    "name": r["name"],
                    "normalized_name": rn,
                    "official_grade": r.get("official_grade"),
                    "grade_numeric": grade_num(r.get("official_grade", "")),
                })

            if to_insert:
                bulk_insert("routes", to_insert)
                log.info(f"    Routes INSERT: {len(to_insert)}")

    log.info("=== DONE ===")


if __name__ == "__main__":
    run()
