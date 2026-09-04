"""
Citation extraction for Ministry of Steel corrigenda.

An eighth confirmation of the "corrigendum-substitution" template (see
extract.common_templates), alongside MoEFCC, MoHFW, MCA, Labour, MeitY,
Civil Aviation, and Housing.

Verified against one real example: S.O. 2685(E) corrects an address in
S.O. 1868(E), a Collection of Statistics Act notification (see
db/seed_steel.sql for provenance). A research agent found two further real
pairs (both amendments to the Steel and Steel Products (Quality Control)
Order, 2024) that cite their principal order in a trailing "Note" rather
than a direct corrigendum-substitution clause — the same consolidated-
instrument shape already deferred for MCA, Agriculture, Petroleum, and
Coal — not modeled here.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

# Bare name here, unlike extract.power_patterns' 'ministry of power': the
# substitution template builds its own "ministry of <name>" anchor, whereas
# the amendment template uses the name only as a scope-guard substring.
# Passing 'ministry of steel' produced the anchor "ministry of ministry of
# steel" and matched nothing — caught by the test, not by inspection.
MINISTRY_NAME = 'steel'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
