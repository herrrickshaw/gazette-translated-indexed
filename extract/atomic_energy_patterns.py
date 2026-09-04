"""
Citation extraction for Department of Atomic Energy amendment notifications.

Uses the "amendment-in-notification" template (see extract.common_templates)
— real text reads "...makes the following amendments in the Order of the
Government of India, Department of Atomic Energy vide number S.O.
3943(E)...". The Department of Atomic Energy is not "a Ministry of X" (it
reports directly to the Prime Minister), so ministry_name is passed as
'department of atomic energy' — the template's scope guard is a plain
substring check, not tied to the word "ministry".

Verified against two real examples (see db/seed_atomic_energy.sql). A
third real pair (Driver Cadre Recruitment Rules amendment) is a plain
note-chain, modeled via extract.common_templates.find_note_chain instead.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_amendment_in_notification_links

MINISTRY_NAME = 'department of atomic energy'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_amendment_in_notification_links(text, MINISTRY_NAME, self_citation=self_citation)
