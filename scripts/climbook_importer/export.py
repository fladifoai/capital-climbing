"""Write CSV, JSON, and Markdown report outputs."""
from __future__ import annotations

import csv
import json
import logging
from pathlib import Path
from typing import Any, Optional

from config import (
    OUTPUT_CSV, OUTPUT_JSON, REPORT_MD,
    FALESIE_OUTPUT_CSV, FALESIE_OUTPUT_JSON, FALESIE_REPORT_MD,
    TODAY, SOURCE, CSV_COLUMNS,
)

logger = logging.getLogger(__name__)


def _null(v: Any) -> str:
    if v is None:
        return ""
    return str(v)


def make_row(
    *,
    source_url: str,
    country: str,
    region: str,
    province_or_area: str,
    municipality: str,
    crag_name: str,
    crag_alias: str = "",
    sector_name: str = "",
    sector_alias: str = "",
    route_name: str,
    route_alias: str = "",
    official_grade: Optional[str] = None,
    community_grade: Optional[str] = None,
    grade_votes: Optional[int] = None,
    length_m: Optional[float] = None,
    bolts: Optional[int] = None,
    pitches: Optional[int] = None,
    orientation: Optional[str] = None,
    rock_type: Optional[str] = None,
    style: Optional[str] = None,
    tags: Optional[str] = None,
    notes: Optional[str] = None,
    confidence: str,
    needs_review: bool,
    in_user_logbook: bool,
) -> dict:
    return {
        "source": SOURCE,
        "source_url": source_url,
        "country": _null(country),
        "region": _null(region),
        "province_or_area": _null(province_or_area),
        "municipality": _null(municipality),
        "crag_name": _null(crag_name),
        "crag_alias": _null(crag_alias),
        "sector_name": _null(sector_name),
        "sector_alias": _null(sector_alias),
        "route_name": _null(route_name),
        "route_alias": _null(route_alias),
        "official_grade": _null(official_grade),
        "community_grade": _null(community_grade),
        "grade_votes": _null(grade_votes),
        "length_m": _null(length_m),
        "bolts": _null(bolts),
        "pitches": _null(pitches),
        "orientation": _null(orientation),
        "rock_type": _null(rock_type),
        "style": _null(style),
        "tags": _null(tags),
        "notes": _null(notes),
        "confidence": confidence,
        "needs_review": "true" if needs_review else "false",
        "in_user_logbook": "true" if in_user_logbook else "false",
        "last_verified_at": TODAY,
    }


def write_csv(rows: list[dict], path: Path = OUTPUT_CSV) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=CSV_COLUMNS, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)
    logger.info(f"CSV written: {path} ({len(rows)} rows)")
    if path == OUTPUT_CSV:
        FALESIE_OUTPUT_CSV.parent.mkdir(parents=True, exist_ok=True)
        import shutil
        shutil.copy2(path, FALESIE_OUTPUT_CSV)
        logger.info(f"CSV copied: {FALESIE_OUTPUT_CSV}")


def write_json(data: Any, path: Path = OUTPUT_JSON) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    logger.info(f"JSON written: {path}")
    if path == OUTPUT_JSON:
        FALESIE_OUTPUT_JSON.parent.mkdir(parents=True, exist_ok=True)
        import shutil
        shutil.copy2(path, FALESIE_OUTPUT_JSON)
        logger.info(f"JSON copied: {FALESIE_OUTPUT_JSON}")


def write_report(stats: dict, path: Path = REPORT_MD) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "# Climbook Import Report",
        "",
        f"Generated: {TODAY}",
        "",
        "## Summary",
        "",
        f"- Falesie target: **{stats.get('crags_target', 0)}**",
        f"- Falesie trovate: **{stats.get('crags_found', 0)}**",
        f"- Falesie non trovate: **{stats.get('crags_not_found', 0)}**",
        f"- Settori trovati: **{stats.get('sectors_found', 0)}**",
        f"- Vie totali trovate: **{stats.get('routes_found', 0)}**",
        f"- Vie logbook abbinate: **{stats.get('logbook_matched', 0)}**",
        f"- Vie logbook non trovate: **{stats.get('logbook_not_found', 0)}**",
        f"- Settori ambigui: **{stats.get('ambiguous_sectors', 0)}**",
        f"- Falesie ambigue: **{stats.get('ambiguous_crags', 0)}**",
        f"- Errori HTTP: **{stats.get('http_errors', 0)}**",
        f"- Pagine saltate: **{stats.get('pages_skipped', 0)}**",
        f"- Righe needs_review: **{stats.get('needs_review_count', 0)}**",
        "",
        "## Dettaglio falesie",
        "",
        "| Falesia input | Falesia Climbook | Match | Settori trovati | Vie trovate | Needs review |",
        "|---|---|---|---:|---:|:---:|",
    ]

    for row in stats.get("crag_rows", []):
        nr = "✓" if not row.get("needs_review") else "⚠"
        lines.append(
            f"| {row['input']} | {row['climbook']} | {row['match']} "
            f"| {row['sectors']} | {row['routes']} | {nr} |"
        )

    if stats.get("not_found_logbook_routes"):
        lines += ["", "## Vie logbook non trovate su Climbook", ""]
        for item in stats["not_found_logbook_routes"]:
            lines.append(f"- `{item['crag']}` / `{item['route']}`")

    if stats.get("errors"):
        lines += ["", "## Errori", ""]
        for e in stats["errors"]:
            lines.append(f"- {e}")

    path.write_text("\n".join(lines), encoding="utf-8")
    logger.info(f"Report written: {path}")
    if path == REPORT_MD:
        FALESIE_REPORT_MD.parent.mkdir(parents=True, exist_ok=True)
        import shutil
        shutil.copy2(path, FALESIE_REPORT_MD)
        logger.info(f"Report copied: {FALESIE_REPORT_MD}")
