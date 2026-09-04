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

3. "supersession-preamble": the citing document says it is issued "in
   supersession of the notification of the [Government of India in the]
   Ministry of <any ministry — the superseded notification need not be
   this ministry's own> ... vide number <citation> ... except as respects
   things done or omitted to be done before such supersession". This is
   the same boilerplate extract.cross_ref already matches for CBIC-style
   numbering (find_candidate_links there) — generalized here to scan via
   find_gazette_citations (G.S.R./S.O./S.R.O.) instead of find_citations
   (CBIC's own "No. X/YYYY-Customs" form), after two independent real
   Ministry of Skill Development and Entrepreneurship notifications
   (Apprentices Act industry-coverage supersession, Central Apprenticeship
   Council reconstitution) both used it verbatim. Unlike the other two
   ministry-anchored templates, this one does NOT anchor on a ministry
   name — the superseded notification is often issued by a *different*
   ministry (e.g. Skill Development superseding a Ministry of Labour
   notification), so anchoring on "ministry of <self>" would miss it.

4. "bare-citation-reference": the citing document names its target with no
   ministry-name anchor at all — just "vide notification number
   <citation>" or "In the Notification <citation>", often because the
   ministry is already established by context rather than restated.
   Confirmed independently across two different ministries in one
   research pass: Ministry of Statistics and Programme Implementation
   ("...vide notification number S.O. 1398(E) dated..." and "In the
   Notification S.O. 174(E) dated...", two DIFFERENT lead-in phrasings)
   and Ministry of Ports, Shipping and Waterways ("...in the notification
   vide S.O.1935(E) dated..."). Because there is no ministry name to
   anchor on, the window here is deliberately tight (60 chars, versus 100-
   300 for the ministry-anchored templates) — the citation always follows
   almost immediately in every real example seen, and a wider window would
   risk picking up an unrelated citation elsewhere in a longer document.

5. "note-chain": a Rules/Order instrument's amending notification closes
   with a trailing "Note[:.-]" (any punctuation) naming its own history —
   "The principal rules were published ... vide number <citation1>, dated
   <date1> and [subsequently/last] amended vide [number(s)] <citation2>[,
   <citation3>, ...]". Confirmed independently across nine real
   ministries before being written (MCA, Agriculture, Steel, Power,
   Consumer Affairs, Civil Aviation, Housing, Communications, Culture) —
   deferred that long deliberately, per this module's own header history,
   rather than designed from one example. Returns the ordered citation
   list found in the Note; the caller builds the chain edges (each item
   amends the one before it, and the citing document amends the last item)
   because only the caller knows which citation is "self".
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


_SUPERSESSION_ANCHOR = 'in supersession of'
# Real preambles enumerate the superseded notification(s) then close with
# this exact legal boilerplate before moving on to the new rule's own body
# — same terminator extract.cross_ref uses for CBIC's version of this
# shape, for the same reason: a fixed window either cuts off a long
# enumerated list or (with no cap at all) runs into the citing document's
# own body text and picks up unrelated citations.
_SUPERSESSION_TERMINATOR = 'except as respects'
_SUPERSESSION_FALLBACK_WINDOW = 4000


def find_supersession_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    text = _normalize(text)
    lower = text.lower()
    citations = find_gazette_citations(text)
    out: list[TemplateLink] = []
    start = 0
    while True:
        idx = lower.find(_SUPERSESSION_ANCHOR, start)
        if idx == -1:
            break
        search_from = idx + len(_SUPERSESSION_ANCHOR)
        term_idx = lower.find(_SUPERSESSION_TERMINATOR, search_from)
        window_end = term_idx if term_idx != -1 else search_from + _SUPERSESSION_FALLBACK_WINDOW
        for c in citations:
            if search_from <= c.start < window_end and c.normalized != self_citation:
                out.append(TemplateLink(target_citation=c.normalized))
        start = search_from

    seen = set()
    deduped = []
    for link in out:
        if link.target_citation not in seen:
            seen.add(link.target_citation)
            deduped.append(link)
    return deduped


# Two different real lead-ins, both with no ministry name in between the
# connective and the citation — 'in the notification' also covers
# extract.railways_patterns' shape when no ministry-name scope guard is
# added by the caller.
_BARE_CITATION_ANCHORS = ('vide notification number', 'in the notification', 'vide')
_BARE_CITATION_WINDOW_CHARS = 60


def find_bare_citation_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    text = _normalize(text)
    lower = text.lower()
    citations = find_gazette_citations(text)
    out: list[TemplateLink] = []
    for anchor in _BARE_CITATION_ANCHORS:
        start = 0
        while True:
            idx = lower.find(anchor, start)
            if idx == -1:
                break
            window_end = idx + len(anchor) + _BARE_CITATION_WINDOW_CHARS
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


_NOTE_ANCHOR = re.compile(r'\bnote\b\s*[:.\-]')


def find_note_chain(text: str) -> list[str]:
    """Ordered citation list from a trailing "Note[:.-] The principal
    rules/order were published ... vide number X, dated ... and
    [subsequently/last] amended vide number(s) Y[, Z, ...]" clause.

    No self_citation/ministry_name parameter, unlike the other two
    templates: a Note lists OTHER documents' citations (the instrument's own
    history), so there is nothing here to exclude, and the phrasing is
    ministry-agnostic (an Order, Rules, or Scheme, not tied to one drafting
    office's name). Returns the citations in the order printed — principal
    first, each subsequent amendment after — from the anchor to the end of
    the document (a Note is a closing clause; scanning to end-of-text rather
    than a fixed window avoids under-reading long numbered histories, like
    an 18-item one seen in real Ministry of Coal text).

    Building chain edges (item[i] amends item[i-1], the citing document
    amends the last item) is the caller's job, because only the caller
    knows which citation is the citing document's own ("self").
    """
    text = _normalize(text)
    m = _NOTE_ANCHOR.search(text.lower())
    if not m:
        return []
    tail = text[m.end():]
    seen = set()
    out = []
    for c in find_gazette_citations(tail):
        if c.normalized not in seen:
            seen.add(c.normalized)
            out.append(c.normalized)
    return out
