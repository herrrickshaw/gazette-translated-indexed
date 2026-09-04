"""
Citation extraction for National Pharmaceutical Pricing Authority (NPPA)
corrigenda, issued under the Ministry of Chemicals and Fertilizers
(Department of Pharmaceuticals).

A genuinely distinct drafting shape, not a fit for the corrigendum-
substitution template in extract.common_templates: real text reads "In the
National Pharmaceutical Pricing Authority's notification S.O. <target>,
dated <date> ... is to be read as follows" / "is to be henceforth, read
as ...". This never names "the Ministry of Chemicals and Fertilizers" at
all — it names the statutory authority (NPPA) instead — so the shared
template's "ministry of <name>" anchor would miss every real example.
Reuses extract.common_templates.find_after_anchor for the scan itself,
same as extract.railways_patterns.

Verified against three real examples, all single-hop corrigenda correcting
one Table entry each in an NPPA price-fixation order (see
db/seed_chemicals_fertilizers.sql).
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_after_anchor

_ANCHOR = 'national pharmaceutical pricing authority'
_WINDOW_CHARS = 150  # the citation follows almost immediately: "...Authority's notification S.O. X, dated..."


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_after_anchor(text, _ANCHOR, self_citation, window_chars=_WINDOW_CHARS)
