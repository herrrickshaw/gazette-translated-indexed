"""
Citation extraction for Ministry of Road Transport and Highways corrigenda.

Uses the shared "amendment-in-notification" template (see
extract.common_templates) — confirmed identical in shape to Ministry of Home
Affairs corrigenda (extract.mha_patterns), differing only in ministry name
and singular/plural "amendment(s)". Kept as its own thin module rather than
inlined so each ministry's test file and provenance notes stay separate.

Verified against three real examples (see db/seed_morth.sql for provenance
on each) spanning 2024-2026.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_amendment_in_notification_links

MINISTRY_NAME = 'road transport and highways'


def find_candidate_links(text: str, self_so: str | None = None) -> list[TemplateLink]:
    return find_amendment_in_notification_links(text, MINISTRY_NAME, self_citation=self_so)
