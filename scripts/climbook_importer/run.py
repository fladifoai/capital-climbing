#!/usr/bin/env python3
"""
Climbook personal importer for Capital Climbing.

Usage:
  python run.py --dry-run
  python run.py --max-crags 3
  python run.py --crag "Collepardo"
  python run.py --use-cache
  python run.py --refresh-cache
"""
from __future__ import annotations

import argparse
import csv
import logging
import sys
from pathlib import Path
from typing import Optional

sys.path.insert(0, str(Path(__file__).parent))

from config import (
    FALESIE_MD, VIE_MD, DATA_IMPORT_DIR, DATA_RAW_DIR, DATA_PROCESSED_DIR,
    TARGETS_CSV, SCRAPE_RAW_JSON, TODAY, BASE_URL, KNOWN_CRAGS, KNOWN_REGIONS,
)
from parse_targets import parse_crags, parse_ascents, CragTarget, AscentTarget
from climbook_client import ClimbookClient
from parsers import (
    parse_crag_routes_page, parse_route_search_page,
    parse_route_page_for_crag, parse_region_page, ClimbookCrag,
)
from normalizers import normalize_crag_name, normalize_route_name
from matcher import find_best_crag, route_in_logbook, CragMatch
from export import write_csv, write_json, write_report, make_row

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%H:%M:%S",
)
logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# Targets CSV
# ---------------------------------------------------------------------------

def write_targets_csv(crags: list[CragTarget], ascents: list[AscentTarget]) -> None:
    DATA_RAW_DIR.mkdir(parents=True, exist_ok=True)
    logbook_by_crag: dict[str, list[str]] = {}
    for a in ascents:
        logbook_by_crag.setdefault(a.crag_name, []).append(a.route_name)

    fieldnames = [
        "crag_id", "country", "region", "province_or_area", "municipality",
        "crag_name", "aliases", "sectors", "geo_confidence",
        "logbook_route_count", "sample_routes",
    ]
    with open(TARGETS_CSV, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        for c in crags:
            routes = logbook_by_crag.get(c.crag_name, [])
            w.writerow({
                "crag_id": c.crag_id,
                "country": c.country,
                "region": c.region,
                "province_or_area": c.province_or_area,
                "municipality": c.municipality,
                "crag_name": c.crag_name,
                "aliases": "; ".join(c.aliases),
                "sectors": "; ".join(c.sectors),
                "geo_confidence": c.geo_confidence,
                "logbook_route_count": len(routes),
                "sample_routes": "; ".join(routes[:3]),
            })
    logger.info(f"Targets CSV: {TARGETS_CSV}")


# ---------------------------------------------------------------------------
# Crag discovery
# ---------------------------------------------------------------------------

def _lookup_known_crag(crag_name: str) -> Optional[tuple[int, str]]:
    """Return (crag_id, slug) if crag is pre-seeded in KNOWN_CRAGS, else None."""
    norm = normalize_crag_name(crag_name)
    for key, val in KNOWN_CRAGS.items():
        if key in norm or norm in key:
            return val["id"], val["slug"]
    return None


def discover_crag(
    crag_target: CragTarget,
    client: ClimbookClient,
    logbook_routes: list[str],
) -> Optional[CragMatch]:
    """
    Try to find crag URL on Climbook using:
    1. Pre-seeded KNOWN_CRAGS dict
    2. Route search using first known logbook route at this crag
    3. Region page browse if region is known
    """
    crag_name = crag_target.crag_name

    # 1. Known ID
    known = _lookup_known_crag(crag_name)
    if known:
        crag_id, slug = known
        url = f"{BASE_URL}/falesie/{crag_id}/{slug}"
        logger.info(f"  Known ID for '{crag_name}': {url}")
        return CragMatch(
            target_name=crag_name,
            matched_name=crag_name,
            matched_url=url,
            matched_id=crag_id,
            score=1.0,
            confidence="high",
            needs_review=False,
            note="Pre-seeded ID.",
        )

    # 2. Route search: search for the first logbook route
    candidates: list[dict] = []

    search_queries = [crag_name] + logbook_routes[:2]
    for query in search_queries:
        html = client.search_routes(query)
        if not html:
            continue

        route_results = parse_route_search_page(html)
        if not route_results:
            continue

        # Fetch first 2 route pages to extract crag URL
        for r in route_results[:2]:
            route_html = client.get_html(r["url"])
            if not route_html:
                continue
            crag_info = parse_route_page_for_crag(route_html)
            if crag_info:
                c_name = crag_info["crag_name"]
                c_url = crag_info["crag_url"]
                c_id = crag_info["crag_id"]
                if not any(c["url"] == c_url for c in candidates):
                    candidates.append({"name": c_name, "url": c_url, "crag_id": c_id})

        if candidates:
            break

    # 3. Region page browse
    if not candidates:
        region_norm = normalize_crag_name(crag_target.region)
        if region_norm in KNOWN_REGIONS:
            r_info = KNOWN_REGIONS[region_norm]
            html = client.get_region_page(r_info["id"], r_info["slug"])
            if html:
                candidates = parse_region_page(html)

    if not candidates:
        logger.warning(f"  No candidates found for '{crag_name}'")
        return None

    match = find_best_crag(crag_name, candidates)
    logger.info(f"  Match for '{crag_name}': {match.matched_name} (score={match.score:.2f})")
    return match


# ---------------------------------------------------------------------------
# Crag processing
# ---------------------------------------------------------------------------

def process_crag(
    crag_target: CragTarget,
    client: ClimbookClient,
    logbook_routes: set[str],
    logbook_norm: set[str],
    all_rows: list[dict],
    raw_data: list[dict],
    stats: dict,
) -> None:
    crag_name = crag_target.crag_name
    logger.info(f"→ Crag: {crag_name}")

    match = discover_crag(crag_target, client, list(logbook_routes))

    if not match or not match.matched_url:
        stats["crags_not_found"] += 1
        stats["errors"].append(f"Not found: {crag_name}")
        stats["crag_rows"].append({
            "input": crag_name, "climbook": "—", "match": "✗",
            "sectors": 0, "routes": 0, "needs_review": True,
        })
        return

    if match.needs_review:
        stats["ambiguous_crags"] += 1

    # Derive slug from URL
    url = match.matched_url
    parts = url.rstrip("/").split("/")
    crag_id = int(parts[-2])
    crag_slug = parts[-1]

    # Fetch full route list
    html = client.get_crag_routes(crag_id, crag_slug)
    if not html:
        stats["http_errors"] += 1
        stats["errors"].append(f"HTTP error fetching routes for: {crag_name} ({url}/vie)")
        stats["crag_rows"].append({
            "input": crag_name, "climbook": match.matched_name or "?", "match": "HTTP ERR",
            "sectors": 0, "routes": 0, "needs_review": True,
        })
        return

    crag = parse_crag_routes_page(html, f"{url}/vie")
    crag.url = url  # canonical crag URL without /vie

    stats["crags_found"] += 1
    stats["routes_found"] += len(crag.routes)
    stats["sectors_found"] += len(crag.sectors)

    # Override location from target if scraper couldn't extract it
    country = crag.country or crag_target.country
    region = crag.region or crag_target.region
    province = crag.province or crag_target.province_or_area
    municipality = crag_target.municipality

    raw_data.append({
        "crag_id_input": crag_target.crag_id,
        "crag_name_input": crag_name,
        "crag_name_climbook": crag.name,
        "crag_url": url,
        "crag_id_climbook": crag_id,
        "sectors": crag.sectors,
        "routes_count": len(crag.routes),
        "routes": [
            {
                "name": r.name,
                "url": r.url,
                "official_grade": r.official_grade,
                "community_grade": r.community_grade,
                "sector_name": r.sector_name,
            }
            for r in crag.routes
        ],
    })

    crag_alias = "; ".join(crag_target.aliases)
    nr_crag = 0

    for route in crag.routes:
        in_logbook, lb_score = route_in_logbook(route.name, logbook_norm)
        if in_logbook:
            stats["logbook_matched"] += 1

        needs_review = match.needs_review or (not route.official_grade and not route.community_grade)

        if needs_review:
            nr_crag += 1

        # Sector: use parsed sector, fallback to sector list from target if single sector
        sector_name = route.sector_name or ""
        if not sector_name and len(crag_target.sectors) == 1:
            sector_name = crag_target.sectors[0]

        all_rows.append(make_row(
            source_url=route.url,
            country=country,
            region=region,
            province_or_area=province,
            municipality=municipality,
            crag_name=crag.name,
            crag_alias=crag_alias,
            sector_name=sector_name,
            route_name=route.name,
            official_grade=route.official_grade,
            community_grade=route.community_grade,
            length_m=route.length_m,
            bolts=route.bolts,
            confidence=match.confidence,
            needs_review=needs_review,
            in_user_logbook=in_logbook,
        ))

    stats["needs_review_count"] += nr_crag

    match_symbol = "✓" if match.score >= 0.99 else f"~ {match.score:.2f}"
    stats["crag_rows"].append({
        "input": crag_name,
        "climbook": crag.name,
        "match": match_symbol,
        "sectors": len(crag.sectors),
        "routes": len(crag.routes),
        "needs_review": nr_crag > 0,
    })

    logger.info(f"  ✓ {crag.name}: {len(crag.routes)} routes, {len(crag.sectors)} sectors")


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Climbook personal data importer for Capital Climbing",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    parser.add_argument("--dry-run", action="store_true",
                        help="Parse targets only, no HTTP requests")
    parser.add_argument("--max-crags", type=int, default=None,
                        help="Limit number of crags to process")
    parser.add_argument("--crag", type=str, default=None,
                        help="Process only this crag (partial name match)")
    parser.add_argument("--use-cache", action="store_true", default=True,
                        help="Use local page cache (default: on)")
    parser.add_argument("--refresh-cache", action="store_true",
                        help="Ignore cache and re-fetch all pages")
    args = parser.parse_args()

    use_cache = not args.refresh_cache

    # --- Parse inputs ---
    if not FALESIE_MD.exists():
        logger.error(f"Missing: {FALESIE_MD}")
        sys.exit(1)
    if not VIE_MD.exists():
        logger.error(f"Missing: {VIE_MD}")
        sys.exit(1)

    crags, sectors = parse_crags()
    ascents = parse_ascents()
    logger.info(f"Parsed: {len(crags)} crags, {len(sectors)} sectors, {len(ascents)} ascents")

    write_targets_csv(crags, ascents)

    # --- Dry run ---
    if args.dry_run:
        logger.info("\n=== DRY RUN ===\n")
        logger.info("Target crags:")
        logbook_by_crag: dict[str, list[str]] = {}
        for a in ascents:
            logbook_by_crag.setdefault(a.crag_name, []).append(a.route_name)

        for c in crags:
            routes = logbook_by_crag.get(c.crag_name, [])
            known = _lookup_known_crag(c.crag_name)
            tag = "✓ known" if known else "? discover"
            logger.info(
                f"  [{tag}] {c.crag_id}: {c.crag_name} "
                f"({c.country}, {c.region}) — {len(routes)} logbook routes"
            )

        n = len(crags) if not args.max_crags else min(len(crags), args.max_crags)
        est = n * 4  # ~1 search + 2 route pages + 1 crag/vie page per crag
        logger.info(f"\nEstimated HTTP requests: ~{est}")
        logger.info(f"Estimated time at 4s avg: ~{est * 4 // 60}m {(est * 4) % 60}s")
        logger.info(f"\nTargets CSV: {TARGETS_CSV}")
        logger.info("Run without --dry-run to start scraping.")
        return

    # --- Filter crags ---
    target_crags = crags[:]
    if args.crag:
        q = normalize_crag_name(args.crag)
        target_crags = [
            c for c in crags
            if q in normalize_crag_name(c.crag_name) or
               normalize_crag_name(c.crag_name) in q
        ]
        if not target_crags:
            logger.error(f"No crag matching: {args.crag!r}")
            sys.exit(1)
        logger.info(f"Filtering to: {[c.crag_name for c in target_crags]}")

    if args.max_crags:
        target_crags = target_crags[: args.max_crags]

    # Build per-crag logbook index (normalized route names)
    logbook_by_crag: dict[str, set[str]] = {}
    for a in ascents:
        s = logbook_by_crag.setdefault(a.crag_name, set())
        s.add(normalize_route_name(a.route_name))
        for alias in a.route_aliases:
            s.add(normalize_route_name(alias))

    client = ClimbookClient(use_cache=use_cache)
    all_rows: list[dict] = []
    raw_data: list[dict] = []
    stats: dict = {
        "crags_target": len(target_crags),
        "crags_found": 0,
        "crags_not_found": 0,
        "sectors_found": 0,
        "routes_found": 0,
        "logbook_matched": 0,
        "logbook_not_found": 0,
        "ambiguous_sectors": 0,
        "ambiguous_crags": 0,
        "http_errors": 0,
        "pages_skipped": 0,
        "needs_review_count": 0,
        "crag_rows": [],
        "not_found_logbook_routes": [],
        "errors": [],
    }

    for crag_target in target_crags:
        logbook_norm = logbook_by_crag.get(crag_target.crag_name, set())
        logbook_routes = list(logbook_norm)
        process_crag(crag_target, client, set(logbook_routes), logbook_norm, all_rows, raw_data, stats)

    # Calculate logbook routes not found in output
    matched_routes = {r["route_name"] for r in all_rows if r["in_user_logbook"] == "true"}
    for a in ascents:
        if a.crag_name not in {c.crag_name for c in target_crags}:
            continue
        if normalize_route_name(a.route_name) not in {
            normalize_route_name(n) for n in matched_routes
        }:
            stats["logbook_not_found"] += 1
            stats["not_found_logbook_routes"].append({
                "crag": a.crag_name,
                "route": a.route_name,
            })

    # Write outputs
    DATA_PROCESSED_DIR.mkdir(parents=True, exist_ok=True)
    write_csv(all_rows)
    write_json({"generated_at": TODAY, "source": "climbook", "crags": raw_data}, SCRAPE_RAW_JSON)
    write_json({"generated_at": TODAY, "source": "climbook", "rows": all_rows})
    write_report(stats)

    logger.info("\n=== DONE ===")
    logger.info(f"Crags: {stats['crags_found']}/{stats['crags_target']} found")
    logger.info(f"Routes: {stats['routes_found']} total, {stats['logbook_matched']} logbook matched")
    logger.info(f"Client: {client.stats}")


if __name__ == "__main__":
    main()
