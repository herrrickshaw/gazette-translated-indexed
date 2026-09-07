"""
Citation extraction for Ministry of External Affairs (MEA) notifications.

Combines four existing templates (see extract.common_templates), since real
examples from this ministry fit all four:
  - corrigendum-substitution: "...notification of the Government of India
    in the Ministry of External Affairs, number G.S.R. 216(E) ... for X
    read Y."
  - amendment-in-notification: "...makes the following amendments in the
    notification of the Government of India in the Ministry of External
    Affairs, ... vide number S.O. 135(E)..."
  - supersession-preamble: "...in supersession of the notifications of the
    Government of India in the Ministry of External Affairs number G.S.R.
    662(E) ... and G.S.R. 370(E)..." — a real example of superseding TWO
    prior notifications at once; the template's while-loop over all
    citations in the (here, fallback-window) range already returns both.
  - note-chain: MEA's UNSC-sanctions Orders (Terrorism, Sudan, and — added
    in the 2026-09-07 depth-pass return trip — Democratic Republic of
    Congo, Libya, Haiti, and Iraq) each close with a trailing "Note:— The
    [Order] ... was published ... vide notification number X ... and last
    amended vide notification number Y" clause naming only the origin and
    the immediately-preceding amendment. Confirmed independently across all
    six Order families (see db/seed_external_affairs.sql for every quoted
    Note and its provenance) before being wired in here — this module's
    prior version flagged the shape as real but deferred adding it "since
    seed-only modeling was sufficient" for the first pass; the return trip
    that found 4 more independent real confirmations is exactly the
    trigger this file's own history said would justify wiring it up.
    find_note_chain has no ministry-name anchor (a Note lists the
    instrument's OWN history, not another ministry's notification), so
    every citation it returns except self is a candidate target — for the
    common two-citation Note shape (origin + last-amended), that is
    correctly just the last-amended citation once self is excluded.

Verified against real examples (see db/seed_external_affairs.sql).
"""
from __future__ import annotations

from .common_templates import (
    TemplateLink,
    find_amendment_in_notification_links,
    find_corrigendum_substitution_links,
    find_note_chain,
    find_supersession_links,
)

MINISTRY_NAME = 'external affairs'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    links = find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
    links += find_amendment_in_notification_links(text, MINISTRY_NAME, self_citation=self_citation)
    links += find_supersession_links(text, self_citation=self_citation)
    links += [
        TemplateLink(target_citation=c)
        for c in find_note_chain(text)
        if c != self_citation
    ]
    seen = set()
    out = []
    for l in links:
        if l.target_citation not in seen:
            seen.add(l.target_citation)
            out.append(l)
    return out
