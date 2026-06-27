"""HTML parsers for Climbook pages."""
from __future__ import annotations

import re
import logging
from dataclasses import dataclass, field
from typing import Optional

from bs4 import BeautifulSoup, Tag

from normalizers import is_community_grade, normalize_grade

logger = logging.getLogger(__name__)

BASE_URL = "https://www.climbook.com"


@dataclass
class ClimbookRoute:
    name: str
    url: str
    climbook_id: Optional[int]
    official_grade: Optional[str]
    community_grade: Optional[str]
    length_m: Optional[float] = None
    bolts: Optional[int] = None
    pitches: Optional[int] = None
    sector_name: Optional[str] = None


@dataclass
class ClimbookCrag:
    name: str
    crag_id: Optional[int]
    url: str
    country: Optional[str] = None
    region: Optional[str] = None
    province: Optional[str] = None
    sectors: list[str] = field(default_factory=list)
    routes: list[ClimbookRoute] = field(default_factory=list)


def _abs_url(href: str) -> str:
    if href.startswith("http"):
        return href
    return BASE_URL + href


def _extract_id(url: str) -> Optional[int]:
    m = re.search(r"/(\d+)/", url)
    return int(m.group(1)) if m else None


def _grade_pair(raw: str) -> tuple[Optional[str], Optional[str]]:
    """Split a grade string into (official, community)."""
    if not raw or raw in ("N.D.", "n.d.", "—", "-", ""):
        return None, None
    if is_community_grade(raw):
        return normalize_grade(raw), raw
    return raw, None


def parse_crag_routes_page(html: str, crag_url: str) -> ClimbookCrag:
    """Parse /falesie/{id}/{slug}/vie — full route list."""
    soup = BeautifulSoup(html, "html.parser")
    crag_id = _extract_id(crag_url)

    # Crag name from <title>
    title_tag = soup.find("title")
    raw_title = title_tag.get_text(strip=True) if title_tag else ""
    # "Vie della falesia di Pietrasecca (Vena Cionca) (L'Aquila) - Climbook"
    crag_name = re.sub(r"^Vie della falesia di\s*", "", raw_title)
    crag_name = re.sub(r"\s*-\s*Climbook$", "", crag_name)
    # Remove trailing location in parens "(L'Aquila)"
    crag_name = re.sub(r"\s*\([A-Z][^)]+\)\s*$", "", crag_name).strip()

    # Breadcrumb location (look for patterns like "L'Aquila · Abruzzo · Italy")
    country = region = province = None
    for elem in soup.find_all(["p", "span", "div", "small", "nav"]):
        text = elem.get_text(" ", strip=True)
        # Match "Province · Region · Country" or "Province, Region, Country"
        m = re.search(
            r"([\w'\s]+)\s*[·,]\s*([\w'\s]+)\s*[·,]\s*(Italia?|Italy|Spagna|Spain|France|Francia)",
            text,
        )
        if m:
            province = m.group(1).strip()
            region = m.group(2).strip()
            country = m.group(3).strip()
            break

    # Collect sector headers
    sectors: list[str] = []
    seen_sectors: set[str] = set()
    for h in soup.find_all(["h2", "h3", "h4"]):
        txt = h.get_text(strip=True)
        if txt and len(txt) < 80 and txt.lower() not in ("vie", "settori", "falesia", "climbook"):
            if txt not in seen_sectors:
                seen_sectors.add(txt)
                sectors.append(txt)

    # Collect routes from table rows
    routes: list[ClimbookRoute] = []
    seen_urls: set[str] = set()
    current_sector: Optional[str] = None

    for elem in soup.find_all(["h2", "h3", "h4", "tr"]):
        tag_name = elem.name

        # Track current sector from headings
        if tag_name in ("h2", "h3", "h4"):
            txt = elem.get_text(strip=True)
            if txt and txt not in seen_sectors:
                current_sector = txt

        if tag_name == "tr":
            # Find route link
            a_tag = elem.find("a", href=lambda h: h and "/vie/" in h)
            if not a_tag:
                continue
            href = a_tag["href"]
            route_url = _abs_url(href)
            if route_url in seen_urls:
                continue
            seen_urls.add(route_url)

            route_name = a_tag.get_text(strip=True)
            route_id = _extract_id(route_url)

            # Extract grades from table cells
            cells = elem.find_all("td")
            official_grade = community_grade = None
            length_m = bolts = pitches = None

            for cell in cells:
                txt = cell.get_text(strip=True)
                if not txt or txt == route_name:
                    continue
                # Grade cell: "6b", "7a+", "6c+/7a", "6b.5", "N.D."
                if re.match(r"^\d[a-c][+]?(?:/\d[a-c][+]?)?(?:\.\d+)?$", txt):
                    off, comm = _grade_pair(txt)
                    if comm and not community_grade:
                        community_grade = comm
                    elif off and not official_grade:
                        official_grade = off
                # Length: "25m", "30 m"
                m = re.match(r"^(\d+)\s*m$", txt, re.I)
                if m:
                    length_m = float(m.group(1))
                # Bolts: "8 spit", "10 fix"
                m = re.match(r"^(\d+)\s*(spit|fix|bolt|chit)s?$", txt, re.I)
                if m:
                    bolts = int(m.group(1))

            if route_name and route_url:
                routes.append(ClimbookRoute(
                    name=route_name,
                    url=route_url,
                    climbook_id=route_id,
                    official_grade=official_grade,
                    community_grade=community_grade,
                    length_m=length_m,
                    bolts=bolts,
                    pitches=pitches,
                    sector_name=current_sector,
                ))

    # Fallback: collect all /vie/ links if table parsing yielded nothing
    if not routes:
        logger.debug("Table parsing empty — falling back to link scan")
        for a in soup.find_all("a", href=True):
            href = a["href"]
            if "/vie/" not in href:
                continue
            route_url = _abs_url(href)
            if route_url in seen_urls:
                continue
            seen_urls.add(route_url)
            route_name = a.get_text(strip=True)
            route_id = _extract_id(route_url)
            if route_name and route_id:
                routes.append(ClimbookRoute(
                    name=route_name,
                    url=route_url,
                    climbook_id=route_id,
                    official_grade=None,
                    community_grade=None,
                ))

    return ClimbookCrag(
        name=crag_name or raw_title,
        crag_id=crag_id,
        url=crag_url,
        country=country,
        region=region,
        province=province,
        sectors=sectors,
        routes=routes,
    )


def parse_route_search_page(html: str) -> list[dict]:
    """Parse /vie?q=... search results. Return list of {name, url, route_id}."""
    soup = BeautifulSoup(html, "html.parser")
    results = []
    seen: set[str] = set()
    for a in soup.find_all("a", href=True):
        href = a["href"]
        if "/vie/" not in href:
            continue
        url = _abs_url(href)
        if url in seen:
            continue
        seen.add(url)
        route_id = _extract_id(url)
        name = a.get_text(strip=True)
        if name and route_id:
            results.append({"name": name, "url": url, "route_id": route_id})
    return results


def parse_route_page_for_crag(html: str) -> Optional[dict]:
    """Extract crag info from a single route page. Return {crag_name, crag_url, crag_id}."""
    soup = BeautifulSoup(html, "html.parser")
    for a in soup.find_all("a", href=True):
        href = a["href"]
        if "/falesie/" in href and re.search(r"/falesie/\d+/", href):
            url = _abs_url(href)
            crag_id = _extract_id(url)
            # Slug → display name heuristic
            slug = href.split("/")[-1] if href.split("/")[-1] else href.split("/")[-2]
            name = slug.replace("-", " ").title()
            label = a.get_text(strip=True)
            return {"crag_name": label or name, "crag_url": url, "crag_id": crag_id}
    return None


def parse_region_page(html: str) -> list[dict]:
    """Extract crag links from a region page. Return list of {name, url, crag_id}."""
    soup = BeautifulSoup(html, "html.parser")
    crags = []
    seen: set[str] = set()
    for a in soup.find_all("a", href=True):
        href = a["href"]
        if "/falesie/" not in href or not re.search(r"/falesie/\d+/", href):
            continue
        url = _abs_url(href)
        if url in seen:
            continue
        seen.add(url)
        crag_id = _extract_id(url)
        name = a.get_text(strip=True)
        if name and crag_id:
            crags.append({"name": name, "url": url, "crag_id": crag_id})
    return crags
