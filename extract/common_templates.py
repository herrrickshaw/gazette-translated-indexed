"""
Shared drafting-template matchers, factored out only after real evidence
from two independent ministries confirmed each template — not written
speculatively ahead of that evidence.

Two templates confirmed so far:

1. "amendment-in-notification": the citing document says it "hereby makes
   the following amendment[s] in the notification of the Government of
   India ... Ministry of <name> ... [vide] number <citation>, dated
   <date>". Confirmed for MoRTH (extract.morth_patterns) and Ministry of
   Home Affairs (extract.mha_patterns) — same shape, different ministry
   name and singular/plural "amendment(s)".

2. "corrigendum-substitution": the citing document says "In the
   notification of the Government of India in the Ministry of <name>
   [vide] number <citation>, dated <date> ... for [old text] read/
   substituted [new text]". Confirmed for MoEFCC (extract.moefcc_patterns)
   and Ministry of Health and Family Welfare (extract.health_patterns).

A ministry whose real text doesn't fit either shape (e.g. Railways, where
the citation can appear *before* "issued by the Ministry of Railways" rather
than after "Ministry of X number Y") gets its own dedicated module instead
of being forced into one of these — see extract/railways_patterns.py.
"""
from __future__ import annotations

from dataclasses import dataclass

from .citation_patterns import find_gazette_citations

_WINDOW_CHARS = 300


@dataclass(frozen=True)
class TemplateLink:
    target_citation: str


def _find_after_anchor(text: str, anchor: str, self_citation: str | None) -> list[TemplateLink]:
    lower = text.lower()
    citations = find_gazette_citations(text)
    out: list[TemplateLink] = []
    start = 0
    while True:
        idx = lower.find(anchor, start)
        if idx == -1:
            break
        window_end = idx + len(anchor) + _WINDOW_CHARS
        for c in citations:
            if idx < c.start < window_end and c.normalized != self_citation:
                out.append(TemplateLink(target_citation=c.normalized))
        start = idx + len(anchor)

    seen = set()
    deduped = []
    for link in out:
        if link.target_citation not in seen:
            seen.add(link.target_citation)
            deduped.append(link)
    return deduped


def find_amendment_in_notification_links(
    text: str, ministry_name: str, self_citation: str | None = None
) -> list[TemplateLink]:
    """ministry_name: lowercase fragment, e.g. 'road transport and highways'."""
    # "amendment" not "amendment in" / "amendments in" — a fixed suffix would
    # miss the singular/plural split real ministries actually use.
    anchor = f'hereby makes the following amendment'
    # Anchor on the ministry-name fragment too, so a document that mentions
    # amendments to some OTHER ministry's notification doesn't false-positive.
    if ministry_name.lower() not in text.lower():
        return []
    return _find_after_anchor(text, anchor, self_citation)


def find_corrigendum_substitution_links(
    text: str, ministry_name: str, self_citation: str | None = None
) -> list[TemplateLink]:
    """ministry_name: lowercase fragment, e.g. 'environment, forest and climate change'.

    Anchored on "ministry of <name>" alone, not "in the ministry of <name>" —
    real text varies ("...in the Ministry of Environment..." for MoEFCC vs.
    "...Government of India, Ministry of Health and Family Welfare,..." for
    MoHFW, no "in the" at all). Assuming identical connective wording across
    ministries was itself a bug, caught the same way as the others: by
    testing against a second ministry's real text instead of stopping at one.
    """
    anchor = f'ministry of {ministry_name.lower()}'
    return _find_after_anchor(text, anchor, self_citation)
