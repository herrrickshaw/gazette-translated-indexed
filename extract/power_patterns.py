"""
Citation extraction for Ministry of Power amendment/corrigendum/repeal
notifications.

Combines two templates (see extract.common_templates):

  - amendment-in-notification, ministry_name='ministry of power' (NOT bare
    'power' — the anchor phrase itself, "in exercise of the *powers*
    conferred by...", contains "power" as a substring, which would make a
    bare 'power' scope guard match almost any ministry's boilerplate.
    Caught before it became a bug, not after.)
  - corrigendum-substitution, ministry_name='power' — safe here because
    this template builds its anchor as the exact contiguous string
    "ministry of power" rather than doing a raw substring scope-guard
    check, so it doesn't share the "powers conferred" false-positive risk.
    Confirmed via a real repeal clause ("hereby repeals the notification
    ... Ministry of Power ... vide notification number S.O. 1033(E)")
    and a real amendment clause using "further to amend" rather than
    "makes the following amendment" (Standards and Labelling Programme
    chains), neither of which fit the amendment-in-notification anchor.

Verified against real examples across several subject areas — protected
systems (IT Act), Standards and Labelling Programme repeals (Tubular
Fluorescent Lamps, LED lamps, induction hobs), and JERC salary rules (see
db/seed_power.sql for full provenance). Several further real chains
(Electricity Rules 2005, Energy Conservation Rules 2012/PAT scheme, Bhakra
Beas Management Board Rules) cite their target only in a trailing Note with
no ministry-name anchor in the main clause — modeled via
extract.common_templates.find_note_chain instead, no new code needed.
"""
from __future__ import annotations

from .common_templates import (
    TemplateLink,
    find_amendment_in_notification_links,
    find_corrigendum_substitution_links,
)


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    links = find_amendment_in_notification_links(text, 'ministry of power', self_citation=self_citation)
    links += find_corrigendum_substitution_links(text, 'power', self_citation=self_citation)
    seen = set()
    out = []
    for l in links:
        if l.target_citation not in seen:
            seen.add(l.target_citation)
            out.append(l)
    return out
