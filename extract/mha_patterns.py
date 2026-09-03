"""
Citation extraction for Ministry of Home Affairs amendment notifications.

Uses the shared "amendment-in-notification" template (see
extract.common_templates) — same shape as MoRTH's (extract.morth_patterns),
confirming that template is a genuine cross-ministry drafting convention,
not a MoRTH idiosyncrasy. Real text uses "amendments" (plural) here, where
MoRTH's used "amendment" (singular) — the template's anchor doesn't require
either.

Verified against one real example: S.O. 3778(E) amending S.O. 3987(E) (see
db/seed_mha.sql for provenance). A research agent found two further real
MHA pairs (a multi-target disapplication order, and a File-Number-cited
Resolution amendment) that don't fit this schema as cleanly — noted in the
seed file as real leads, not modeled here yet.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_amendment_in_notification_links

MINISTRY_NAME = 'home affairs'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_amendment_in_notification_links(text, MINISTRY_NAME, self_citation=self_citation)
