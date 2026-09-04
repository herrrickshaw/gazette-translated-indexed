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

import re
from dataclasses import dataclass

from .citation_patterns import find_gazette_citations

_WINDOW_CHARS = 300

# PDF text extraction line-wraps mid-phrase — a real Ministry of Home
# Affairs notification prints "hereby makes the following \namendments"
# with the line break landing between "following" and "amendments". Every
# anchor here is a literal substring match, which silently fails against
# any such wrap even though both citations are plainly present in the
# text — caught only by running the extractors against real PDF-extracted
# text end-to-end, not by any synthetic fixture (fixtures are hand-typed as
# one line and never wrap). Normalizing all whitespace runs (including
# newlines) to a single space, once, before every anchor and citation
# search fixes this for every template at once rather than patching each
# phrase's spelling of "the following amendment" individually.
_WS_RE = re.compile(r'\s+')


def _normalize(text: str) -> str:
    return _WS_RE.sub(' ', text)


@dataclass(frozen=True)
class TemplateLink:
    target_citation: str


def find_after_anchor(text: str, anchor: str, self_citation: str | None,
                       window_chars: int = _WINDOW_CHARS) -> list[TemplateLink]:
    """Shared anchor-then-nearby-citation scan, normalizing whitespace first.
    Public (no leading underscore) so extract.railways_patterns can reuse it
    with its own anchor/window instead of maintaining a parallel copy of
    this loop with its own copy of the same whitespace bug."""
    text = _normalize(text)
    lower = text.lower()
    citations = find_gazette_citations(text)
    out: list[TemplateLink] = []
    start = 0
    while True:
        idx = lower.find(anchor, start)
        if idx == -1:
            break
        window_end = idx + len(anchor) + window_chars
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
    # Dropped "hereby" from the anchor entirely — a real Ministry of
    # Agriculture notification's own primary text has "the Central
    # Government herby makes the following amendments" (missing the second
    # "e"), presumably an OCR/transcription artifact in the source gazette
    # itself. "makes the following amendment" alone is still specific
    # enough to avoid false positives, and is a strict substring of every
    # correctly-spelled example already verified, so this only adds
    # coverage, it doesn't remove any.
    anchor = 'makes the following amendment'
    # Anchor on the ministry-name fragment too, so a document that mentions
    # amendments to some OTHER ministry's notification doesn't false-positive.
    # Checked against normalized text for the same reason as the anchor
    # itself — a long ministry name can wrap across a line too.
    if ministry_name.lower() not in _normalize(text).lower():
        return []
    return find_after_anchor(text, anchor, self_citation)


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
    return find_after_anchor(text, anchor, self_citation)
