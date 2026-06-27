"""Parse the two markdown input files into structured target lists."""
from __future__ import annotations

import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

from config import FALESIE_MD, VIE_MD


@dataclass
class CragTarget:
    crag_id: str
    country: str
    region: str
    province_or_area: str
    municipality: str
    crag_name: str
    aliases: list[str]
    sectors: list[str]
    geo_confidence: str


@dataclass
class SectorTarget:
    sector_id: str
    crag_id: str
    crag_name: str
    sector_name: str
    sector_status: str  # exact | candidate | unknown


@dataclass
class AscentTarget:
    ascent_id: str
    crag_name: str
    sector_name: Optional[str]
    sector_candidates: list[str]
    route_name: str
    route_aliases: list[str]
    grade: str
    status: str  # canonical | needs_review


def _split_semi(s: str) -> list[str]:
    """Split semicolon-separated string, strip, drop empty/dash."""
    return [x.strip() for x in s.split(";") if x.strip() not in ("", "—", "-")]


def _parse_table_row(line: str) -> list[str]:
    """Parse a markdown table row into list of cell strings."""
    if not line.startswith("|"):
        return []
    return [c.strip() for c in line.split("|")[1:-1]]


def parse_crags(path: Path = FALESIE_MD) -> tuple[list[CragTarget], list[SectorTarget]]:
    text = path.read_text(encoding="utf-8")
    crags: list[CragTarget] = []
    sectors: list[SectorTarget] = []

    mode = None  # "crags" | "sectors" | None

    for raw_line in text.splitlines():
        line = raw_line.strip()

        if "## Falesie" in line:
            mode = "crags"
            continue
        if "## Settori" in line:
            mode = "sectors"
            continue
        if line.startswith("## ") and mode:
            mode = None
            continue

        if not line.startswith("|"):
            continue

        cols = _parse_table_row(line)
        if not cols:
            continue

        # Skip header and separator rows
        if cols[0].startswith("crag_id") or cols[0].startswith("sector_id") or set(cols[0]) <= set("-| "):
            continue

        if mode == "crags" and len(cols) >= 13:
            try:
                crags.append(CragTarget(
                    crag_id=cols[0],
                    country=cols[1],
                    region=cols[2],
                    province_or_area=cols[3],
                    municipality=cols[4],
                    crag_name=cols[5],
                    aliases=_split_semi(cols[6]),
                    sectors=_split_semi(cols[7]),
                    geo_confidence=cols[12],
                ))
            except IndexError:
                pass

        elif mode == "sectors" and len(cols) >= 7:
            try:
                sectors.append(SectorTarget(
                    sector_id=cols[0],
                    crag_id=cols[1],
                    crag_name=cols[2],
                    sector_name=cols[3],
                    sector_status=cols[4],
                ))
            except IndexError:
                pass

    return crags, sectors


def parse_ascents(path: Path = VIE_MD) -> list[AscentTarget]:
    text = path.read_text(encoding="utf-8")
    ascents: list[AscentTarget] = []
    in_table = False

    for raw_line in text.splitlines():
        line = raw_line.strip()

        if "| ascent_id |" in line:
            in_table = True
            continue

        if not in_table or not line.startswith("|"):
            if in_table and line.startswith("## "):
                in_table = False
            continue

        cols = _parse_table_row(line)
        if not cols or cols[0].startswith("---") or cols[0].startswith("ascent_id"):
            continue
        if len(cols) < 20:
            continue

        try:
            sector_raw = cols[7]
            ascents.append(AscentTarget(
                ascent_id=cols[0],
                crag_name=cols[6],
                sector_name=sector_raw if sector_raw not in ("—", "-", "") else None,
                sector_candidates=_split_semi(cols[8]),
                route_name=cols[9],
                route_aliases=_split_semi(cols[10]),
                grade=cols[11],
                status=cols[19],
            ))
        except IndexError:
            pass

    return ascents


if __name__ == "__main__":
    crags, sectors = parse_crags()
    ascents = parse_ascents()
    print(f"Crags: {len(crags)}, Sectors: {len(sectors)}, Ascents: {len(ascents)}")
    for c in crags:
        print(f"  {c.crag_id}: {c.crag_name} ({c.country}, {c.region})")
