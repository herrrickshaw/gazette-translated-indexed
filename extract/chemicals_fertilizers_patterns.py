"""
Citation extraction for Ministry of Chemicals and Fertilizers notifications
— National Pharmaceutical Pricing Authority (NPPA) corrigenda/addenda plus
Department of Chemicals and Petrochemicals Quality Control Order
rescissions.

Combines two anchor scans:
  - NPPA anchor (custom, not a shared template): real text reads "In/The
    National Pharmaceutical Pricing Authority's notification/Order No.
    <target>, dated <date> ... is to be read as follows" / "is henceforth
    to be read with the following additions". This never names "the
    Ministry of Chemicals and Fertilizers" at all — it names the statutory
    authority (NPPA) instead — so the shared corrigendum-substitution
    template's "ministry of <name>" anchor would miss it. Reuses
    extract.common_templates.find_after_anchor, same as
    extract.railways_patterns.
  - corrigendum-substitution, ministry_name='chemicals and fertilizers' —
    a real, distinct Department of Chemicals and Petrochemicals shape:
    "hereby rescinds the notification of the Government of India in the
    Ministry of Chemicals and Fertilizers number <target> ... with
    immediate effect" (Quality Control Order rescissions). Confirmed
    against six real examples in one gazette (see
    db/seed_chemicals_fertilizers.sql).

Verified against real examples spanning NPPA price-fixation corrigenda/
addenda and Quality Control Order rescissions.
"""
from __future__ import annotations

from .common_templates import (
    TemplateLink,
    find_after_anchor,
    find_corrigendum_substitution_links,
)

_NPPA_ANCHOR = 'national pharmaceutical pricing authority'
_NPPA_WINDOW_CHARS = 150  # the citation follows almost immediately: "...Authority's notification S.O. X, dated..."


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    links = find_after_anchor(text, _NPPA_ANCHOR, self_citation, window_chars=_NPPA_WINDOW_CHARS)
    links += find_corrigendum_substitution_links(text, 'chemicals and fertilizers', self_citation=self_citation)
    seen = set()
    out = []
    for l in links:
        if l.target_citation not in seen:
            seen.add(l.target_citation)
            out.append(l)
    return out
