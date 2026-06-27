"""Configuration constants for the Climbook importer."""
from pathlib import Path

BASE_URL = "https://www.climbook.com"
USER_AGENT = "CapitalClimbingPersonalImporter/0.1"

REQUEST_DELAY_MIN = 3.0   # seconds
REQUEST_DELAY_MAX = 5.0   # seconds
MAX_RETRIES = 2
REQUEST_TIMEOUT = 15      # seconds

PROJECT_ROOT = Path(__file__).parent.parent.parent
DATA_IMPORT_DIR = PROJECT_ROOT / "data" / "import"
DATA_RAW_DIR = PROJECT_ROOT / "data" / "raw"
DATA_PROCESSED_DIR = PROJECT_ROOT / "data" / "processed"
CACHE_DIR = DATA_RAW_DIR / "climbook_pages_cache"

TARGETS_CSV = DATA_RAW_DIR / "climbook_targets.csv"
SCRAPE_RAW_JSON = DATA_RAW_DIR / "climbook_scrape_raw.json"
OUTPUT_CSV = DATA_PROCESSED_DIR / "climbook_crags_sectors_routes.csv"
OUTPUT_JSON = DATA_PROCESSED_DIR / "climbook_crags_sectors_routes.json"
REPORT_MD = DATA_PROCESSED_DIR / "climbook_import_report.md"

FALESIE_OUTPUT_DIR = Path(r"C:\Users\fladi\OneDrive\Desktop\Claude\Capital climbing\falesie")
FALESIE_OUTPUT_CSV = FALESIE_OUTPUT_DIR / "climbook_crags_sectors_routes.csv"
FALESIE_OUTPUT_JSON = FALESIE_OUTPUT_DIR / "climbook_crags_sectors_routes.json"
FALESIE_REPORT_MD = FALESIE_OUTPUT_DIR / "climbook_import_report.md"

FALESIE_MD = DATA_IMPORT_DIR / "capital_climbing_falesie_settori.md"
VIE_MD = DATA_IMPORT_DIR / "capital_climbing_vie_scalate.md"

TODAY = "2026-06-27"
SOURCE = "climbook"

# Pre-seeded crag IDs discovered via manual exploration (2026-06-27)
# Maps normalize_crag_name(name) -> {id, slug}
KNOWN_CRAGS: dict[str, dict] = {
    # Abruzzo
    "pietrasecca":  {"id": 156,   "slug": "pietrasecca-vena-cionca"},
    "tagliacozzo":  {"id": 625,   "slug": "tagliacozzo-estrema-sinistra-grande-tetto-scudo-centrale-estrema-destra"},
    "pizzoferrato": {"id": 360,   "slug": "pizzoferrato"},
    "ovindoli":     {"id": 10341, "slug": "ovindoli-val-darano"},
    "petrella liri":{"id": 122,   "slug": "petrella-liri-placche-di-bini"},
    # Lazio
    "fortezza":     {"id": 10231, "slug": "la-fortezza"},
    "collepardo":   {"id": 162,   "slug": "collepardo-classica"},
    "norma":        {"id": 59,    "slug": "norma-placche-rosse"},
    "subiaco":      {"id": 117,   "slug": "subiaco-le-scalette"},
    "fraioli":      {"id": 90,    "slug": "fraioli"},
    "ripa majala":  {"id": 134,   "slug": "ripa-majala"},
    "caprile":      {"id": 97,    "slug": "caprile-eremo"},
    "grotti":       {"id": 21,    "slug": "grotti-il-canile"},
    # Umbria
    "ferentillo":   {"id": 1,     "slug": "ferentillo-isola"},
    # Sardegna
    "ulassai":      {"id": 7101,  "slug": "ulassai-il-canyon"},
    # Spagna - Baleari (Mallorca)
    "caimari":      {"id": 21661, "slug": "caimari-adalt-de-tot-adalt-es-raconet-placa-rotja"},
    "cala magraner":{"id": 9441,  "slug": "cala-magraner-estrema-sinistra-sense-voler-pipiricot-xorics"},
}

# Region page IDs for browsing crag lists
# Maps normalize_name(region) -> {id, slug}
KNOWN_REGIONS: dict[str, dict] = {
    "abruzzo":     {"id": 3,   "slug": "abruzzo"},
    # Others discovered at runtime
}

CSV_COLUMNS = [
    "source", "source_url", "country", "region", "province_or_area", "municipality",
    "crag_name", "crag_alias", "sector_name", "sector_alias",
    "route_name", "route_alias", "official_grade", "community_grade",
    "grade_votes", "length_m", "bolts", "pitches",
    "orientation", "rock_type", "style", "tags", "notes",
    "confidence", "needs_review", "in_user_logbook", "last_verified_at",
]
