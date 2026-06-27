"""Match target crag/route names against Climbook candidates."""
from __future__ import annotations

from dataclasses import dataclass
from typing import Optional

from normalizers import normalize_crag_name, normalize_route_name, match_score


@dataclass
class CragMatch:
    target_name: str
    matched_name: Optional[str]
    matched_url: Optional[str]
    matched_id: Optional[int]
    score: float
    confidence: str   # "high" | "medium" | "low"
    needs_review: bool
    note: str


def find_best_crag(target_name: str, candidates: list[dict]) -> CragMatch:
    """
    Find best crag match from candidates list [{name, url, crag_id}].
    Does NOT auto-select when multiple candidates score >= 0.7.
    """
    if not candidates:
        return CragMatch(
            target_name=target_name,
            matched_name=None, matched_url=None, matched_id=None,
            score=0.0, confidence="low", needs_review=True,
            note="No candidates available.",
        )

    t_norm = normalize_crag_name(target_name)
    scored = sorted(
        ((match_score(t_norm, normalize_crag_name(c["name"])), c) for c in candidates),
        key=lambda x: -x[0],
    )

    best_score, best = scored[0]

    if best_score >= 0.99:
        return CragMatch(
            target_name=target_name,
            matched_name=best["name"], matched_url=best["url"], matched_id=best.get("crag_id"),
            score=best_score, confidence="high", needs_review=False,
            note="Exact match.",
        )

    top = [s for s, _ in scored if s >= 0.7]
    if len(top) > 1:
        note = f"{len(top)} candidates with score ≥ 0.7 — verify manually."
        return CragMatch(
            target_name=target_name,
            matched_name=best["name"], matched_url=best["url"], matched_id=best.get("crag_id"),
            score=best_score, confidence="medium", needs_review=True,
            note=note,
        )

    if best_score >= 0.7:
        return CragMatch(
            target_name=target_name,
            matched_name=best["name"], matched_url=best["url"], matched_id=best.get("crag_id"),
            score=best_score, confidence="medium", needs_review=False,
            note=f"Fuzzy match (score {best_score:.2f}).",
        )

    if best_score >= 0.3:
        return CragMatch(
            target_name=target_name,
            matched_name=best["name"], matched_url=best["url"], matched_id=best.get("crag_id"),
            score=best_score, confidence="low", needs_review=True,
            note=f"Low score ({best_score:.2f}) — verify manually.",
        )

    return CragMatch(
        target_name=target_name,
        matched_name=None, matched_url=None, matched_id=None,
        score=best_score, confidence="low", needs_review=True,
        note=f"No match (best score {best_score:.2f}).",
    )


def route_in_logbook(route_name: str, logbook_norm: set[str]) -> tuple[bool, float]:
    """Check if a Climbook route name matches any logbook route (normalized). Return (matched, best_score)."""
    r_norm = normalize_route_name(route_name)
    if r_norm in logbook_norm:
        return True, 1.0
    # Fuzzy fallback for alias-like differences
    best = max((match_score(r_norm, lb) for lb in logbook_norm), default=0.0)
    return best >= 0.85, best
