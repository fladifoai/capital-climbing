"""Polite HTTP client for Climbook with rate limiting and local cache."""
from __future__ import annotations

import hashlib
import logging
import random
import time
from pathlib import Path
from typing import Optional

import urllib3
import requests

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

from config import (
    BASE_URL, USER_AGENT,
    REQUEST_DELAY_MIN, REQUEST_DELAY_MAX,
    MAX_RETRIES, REQUEST_TIMEOUT, CACHE_DIR,
)

logger = logging.getLogger(__name__)

_last_request_time: float = 0.0


def _cache_path(url: str) -> Path:
    key = hashlib.md5(url.encode()).hexdigest()
    return CACHE_DIR / f"{key}.html"


def _throttle() -> None:
    global _last_request_time
    elapsed = time.time() - _last_request_time
    delay = random.uniform(REQUEST_DELAY_MIN, REQUEST_DELAY_MAX)
    if elapsed < delay:
        sleep_for = delay - elapsed
        logger.debug(f"Throttle: sleeping {sleep_for:.1f}s")
        time.sleep(sleep_for)
    _last_request_time = time.time()


class ClimbookClient:
    def __init__(self, use_cache: bool = True, dry_run: bool = False):
        self.use_cache = use_cache
        self.dry_run = dry_run
        self._session = requests.Session()
        self._session.headers["User-Agent"] = USER_AGENT
        self._session.verify = False
        CACHE_DIR.mkdir(parents=True, exist_ok=True)
        self._stats: dict[str, int] = {"fetched": 0, "cache_hits": 0, "errors": 0, "skipped": 0}

    @property
    def stats(self) -> dict[str, int]:
        return dict(self._stats)

    def get_html(self, url: str) -> Optional[str]:
        if self.dry_run:
            logger.info(f"[DRY-RUN] Would GET: {url}")
            self._stats["skipped"] += 1
            return None

        cache_file = _cache_path(url)
        if self.use_cache and cache_file.exists():
            self._stats["cache_hits"] += 1
            logger.debug(f"Cache hit: {url}")
            return cache_file.read_text(encoding="utf-8")

        for attempt in range(MAX_RETRIES + 1):
            try:
                _throttle()
                logger.info(f"GET {url}")
                resp = self._session.get(url, timeout=REQUEST_TIMEOUT)
                resp.raise_for_status()
                html = resp.text
                if self.use_cache:
                    cache_file.write_text(html, encoding="utf-8")
                self._stats["fetched"] += 1
                return html
            except requests.HTTPError as e:
                logger.warning(f"HTTP {e.response.status_code} for {url}")
                self._stats["errors"] += 1
                return None
            except requests.RequestException as e:
                logger.warning(f"Attempt {attempt + 1}/{MAX_RETRIES + 1} failed: {e}")
                self._stats["errors"] += 1
                if attempt < MAX_RETRIES:
                    time.sleep(REQUEST_DELAY_MAX * (attempt + 1))

        return None

    def get_crag_routes(self, crag_id: int, crag_slug: str) -> Optional[str]:
        """Fetch all routes for a crag: /falesie/{id}/{slug}/vie"""
        url = f"{BASE_URL}/falesie/{crag_id}/{crag_slug}/vie"
        return self.get_html(url)

    def get_crag_page(self, crag_id: int, crag_slug: str) -> Optional[str]:
        """Fetch crag overview page: /falesie/{id}/{slug}"""
        url = f"{BASE_URL}/falesie/{crag_id}/{crag_slug}"
        return self.get_html(url)

    def search_routes(self, query: str) -> Optional[str]:
        """Search Climbook routes by keyword: /vie?q={query}"""
        url = f"{BASE_URL}/vie?q={requests.utils.quote(query)}"
        return self.get_html(url)

    def get_route_page(self, route_id: int, route_slug: str) -> Optional[str]:
        """Fetch individual route page: /vie/{id}/{slug}"""
        url = f"{BASE_URL}/vie/{route_id}/{route_slug}"
        return self.get_html(url)

    def get_region_page(self, region_id: int, region_slug: str) -> Optional[str]:
        """Fetch region page to discover crags: /regioni/{id}/{slug}"""
        url = f"{BASE_URL}/regioni/{region_id}/{region_slug}"
        return self.get_html(url)
