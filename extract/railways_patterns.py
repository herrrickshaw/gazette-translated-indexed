"""
Citation extraction for Ministry of Railways corrigenda.

A fourth, genuinely distinct drafting shape — not a fit for either shared
template in extract.common_templates. Real text: "S.O. <self>.— In the
Notification S.O. <target>, dated <date>, issued by the Ministry of
Railways [<zonal railway division>] ...". Two things make this different
from MoRTH/MHA/MoEFCC/MoHFW:

  1. The target citation follows "In the Notification" directly, not a
     "Ministry of <name>" phrase — "Ministry of Railways" comes *after*
     the citation here, reversed from every other ministry checked so far.
  2. Zonal railway divisions (Central Railway, Western Railway, South
     Western Railway, ...) draft their own corrigenda somewhat
     independently — a research agent found three real Railways
     corrigenda in three visibly different formats from three different
     divisions. This module is verified against exactly one of those
     (the South Western Railway survey-number correction) — see
     db/seed_railways.sql for the other two, left unmodeled as real leads.

Reuses extract.common_templates.find_after_anchor for the scan itself
(whitespace-normalized, so a PDF line-wrap mid-phrase can't silently break
it the way it once did) rather than keeping a second copy of that loop.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_after_anchor

_ANCHOR = 'in the notification'
_WINDOW_CHARS = 100  # the citation follows almost immediately: "In the Notification S.O. X, dated..."
_SCOPE_GUARD = 'ministry of railways'  # require this appear somewhere, so this module doesn't fire on unrelated text


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    if _SCOPE_GUARD not in text.lower():
        return []
    return find_after_anchor(text, _ANCHOR, self_citation, window_chars=_WINDOW_CHARS)
