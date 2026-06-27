"""Scrape one Climbook falesia and import routes under an existing crag/sector."""
from __future__ import annotations
import os, sys, logging
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from climbook_client import ClimbookClient
from parsers import parse_crag_routes_page
from normalizers import normalize_name, normalize_route_name
from supabase_import import _get, _insert, bulk_insert, grade_num

logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")
log = logging.getLogger(__name__)

# ── Config: one entry per falesia to import ────────────────────────────────
# Each dict: climbook_id, slug, target_crag_name (existing in DB), target_sector_name (existing in DB)
IMPORTS = [
    {
        "climbook_id": 328,
        "slug": "colle-dellorso-blocco-p-q-morgia-quadra",
        "target_crag": "Colle dell'Orso",
        "target_sector": "Blocco P, Q - Morgia Quadra",
    },
    {
        "climbook_id": 15121,
        "slug": "collepardo-cueva-cuevita",
        "target_crag": "Collepardo (Classica) - Elenco vie",
        "target_sector": "Cueva / Cuevita",
    },
    {
        "climbook_id": 154,
        "slug": "petrella-liri-petrella-alta",
        "target_crag": "Petrella Liri (Placche di Bini) - Elenco vie",
        "target_sector": "Petrella Alta",
    },
    {
        "climbook_id": 10,
        "slug": "ferentillo-gabbio",
        "target_crag": "Ferentillo (Isola) - Elenco vie",
        "target_sector": "Gabbio",
    },
    {
        "climbook_id": 1725,
        "slug": "grotti-grotti-bassa-nuovo-settore",
        "target_crag": "Grotti (Il Canile) - Elenco vie",
        "target_sector": "Grotti Bassa - Nuovo Settore",
    },
    {
        "climbook_id": 656,
        "slug": "subiaco-regno-dei-ragni",
        "target_crag": "Subiaco (Le Scalette) - Elenco vie",
        "target_sector": "Regno dei Ragni",
    },
]


def find_by_norm(table: str, field: str, value: str, extra: dict | None = None) -> dict | None:
    params = {field: f"eq.{value}", "limit": "1"}
    if extra:
        params.update(extra)
    rows = _get(table, params)
    return rows[0] if rows else None


def run() -> None:
    if not os.environ.get("SUPABASE_SERVICE_KEY"):
        log.error("Set SUPABASE_SERVICE_KEY")
        sys.exit(1)

    client = ClimbookClient(use_cache=True)

    for entry in IMPORTS:
        crag_id_cb = entry["climbook_id"]
        slug = entry["slug"]
        target_crag = entry["target_crag"]
        target_sector = entry["target_sector"]

        log.info(f"Scraping /falesie/{crag_id_cb}/{slug}/vie ...")
        html = client.get_crag_routes(crag_id_cb, slug)
        if not html:
            log.error(f"  Failed to fetch page")
            continue

        parsed = parse_crag_routes_page(html, f"https://www.climbook.com/falesie/{crag_id_cb}/{slug}")
        log.info(f"  Parsed: {len(parsed.routes)} routes")

        # Find existing crag
        crag_norm = normalize_name(target_crag)
        crag_row = find_by_norm("crags", "normalized_name", crag_norm)
        if not crag_row:
            log.error(f"  Crag not found in DB: {target_crag} (norm={crag_norm})")
            continue
        db_crag_id = crag_row["id"]
        log.info(f"  Crag: {target_crag} → {db_crag_id}")

        # Find or create sector
        sec_norm = normalize_name(target_sector)
        sec_row = find_by_norm("sectors", "normalized_name", sec_norm,
                               {"crag_id": f"eq.{db_crag_id}"})
        if sec_row:
            db_sec_id = sec_row["id"]
            log.info(f"  Sector EXISTS: {target_sector}")
        else:
            sec_row = _insert("sectors", {
                "crag_id": db_crag_id,
                "name": target_sector,
                "normalized_name": sec_norm,
            })
            db_sec_id = sec_row["id"]
            log.info(f"  Sector INSERT: {target_sector} → {db_sec_id}")

        # Existing routes in sector
        existing = {
            r["normalized_name"]
            for r in _get("routes", {"sector_id": f"eq.{db_sec_id}",
                                      "select": "normalized_name", "limit": "500"})
        }

        to_insert = []
        for r in parsed.routes:
            rn = normalize_route_name(r.name)
            if rn in existing:
                continue
            to_insert.append({
                "sector_id": db_sec_id,
                "name": r.name,
                "normalized_name": rn,
                "official_grade": r.official_grade,
                "grade_numeric": grade_num(r.official_grade) if r.official_grade else None,
                "length_m": int(r.length_m) if r.length_m else None,
                "bolts": r.bolts,
            })

        if to_insert:
            BATCH = 50
            total = 0
            for i in range(0, len(to_insert), BATCH):
                chunk = to_insert[i:i + BATCH]
                bulk_insert("routes", chunk)
                total += len(chunk)
            log.info(f"  Routes INSERT: {total} (skipped {len(existing)} existing)")
        else:
            log.info(f"  All {len(existing)} routes already present")

    log.info("=== DONE ===")


if __name__ == "__main__":
    run()
