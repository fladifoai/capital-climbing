"""Name normalization for matching crag/sector/route names."""
import re
import unicodedata


def _strip_accents(text: str) -> str:
    return "".join(
        c for c in unicodedata.normalize("NFD", text)
        if unicodedata.category(c) != "Mn"
    )


def normalize_name(name: str) -> str:
    """Lowercase, trim, collapse spaces, normalize apostrophes, strip accents."""
    if not name:
        return ""
    s = name.strip().lower()
    s = re.sub(r"[''`’‘]", "'", s)  # normalize apostrophes
    s = re.sub(r"\s+", " ", s)
    s = _strip_accents(s)
    return s


def normalize_crag_name(name: str) -> str:
    """Normalize crag name, removing common suffixes and prefixes."""
    s = normalize_name(name)
    # Remove sector lists in parentheses: "Tagliacozzo (Estrema sinistra...)" -> "tagliacozzo"
    s = re.sub(r"\s*\([^)]+\)", "", s).strip()
    # Remove leading articles
    s = re.sub(r"^(la |il |lo |le |i |gli |l')", "", s)
    return s.strip()


def normalize_sector_name(name: str) -> str:
    s = normalize_name(name)
    # Remove "non specificato" / "unknown" placeholders
    if s in ("non specificato", "unknown", "—", "-"):
        return ""
    return s


def normalize_route_name(name: str) -> str:
    s = normalize_name(name)
    # Strip trailing pitch markers: "Rick e Tack L1" -> "rick e tack"
    s = re.sub(r"\s+l\d+(\+l\d+)*$", "", s)
    # Strip "l1+l2" in middle
    s = re.sub(r"\s+l\d+\+l\d+", "", s)
    return s.strip()


def normalize_grade(grade: str) -> str:
    if not grade:
        return ""
    # Remove community decimal: "6b.5" -> "6b", "7a+.3" -> "7a+"
    s = grade.strip().lower()
    s = re.sub(r"\.\d+$", "", s)
    return s


def is_community_grade(grade: str) -> bool:
    """Return True if grade has community decimal suffix (e.g. 6b.5, 7a+.3)."""
    return bool(re.search(r"\.\d+$", grade.strip()))


def match_score(a: str, b: str) -> float:
    """Simple similarity score 0.0-1.0 for two normalized strings."""
    na, nb = normalize_name(a), normalize_name(b)
    if not na or not nb:
        return 0.0
    if na == nb:
        return 1.0
    if na in nb or nb in na:
        return 0.8
    wa = set(na.split())
    wb = set(nb.split())
    overlap = len(wa & wb)
    return overlap / max(len(wa), len(wb)) if wa and wb else 0.0
