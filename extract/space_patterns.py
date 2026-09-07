"""
Citation extraction for Department of Space (DoS) amendments to the
Department of Space Employees' (Classification, Control and Appeal) Rules,
1976.

Every real DoS amendment to these Rules found so far (S.O. 424(E)/2018,
S.O. 4235(E)/2019, S.O. 2018(E)/2022, S.O. 5979(E)/2025 — all four
independently pulled as their own primary-source PDFs, see
db/seed_space.sql) closes with a trailing "Note:The Principal rules were
published vide No.S.O.270(E) dated 01.04.1976 ... and have been
subsequently amended by:-" clause, printed as a TABLE (Sl. No. /
Notification No. [internal file number] / Date / S.O. No. / Date columns)
rather than the numbered prose list every other note-chain ministry modeled
so far uses (MCA, Agriculture, Steel, Power, ...) — see
extract.common_templates' find_note_chain docstring.

That table shape turns out NOT to need a new template at all: the
"vide No.S.O.270(E)" phrase immediately preceding the table already fits the
existing "bare-citation-reference" template (extract.common_templates'
find_bare_citation_links, anchor 'vide', 60-char window) — confirmed live
against the real 2022 filing's own extracted PDF text
(data/raw_md/CG-KA-E-30042022-235463.md), which correctly returns only
'S.O. 270(E)' and nothing from the table itself. The table's own row values
are naturally excluded rather than filtered out: this project's citation
regex (extract.citation_patterns._SO_RE) always requires a parenthetical
letter after the number ("270(E)", not "270"), and most of this table's
historical rows before ~2005 print a bare number with no "(E)" suffix at
all (e.g. "780", "229") — genuinely unmatchable, which is exactly why
db/seed_space.sql's own header has never tried to model those bare rows as
separate citation nodes.

This module exists as DoS's own dedicated wrapper (same pattern as
extract.defence_patterns for corrigendum-substitution) purely so a future
research pass over this ministry has one canonical entry point, rather than
each caller separately knowing "DoS uses find_bare_citation_links" via
this file's own commit history.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_bare_citation_links

MINISTRY_NAME = 'space'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_bare_citation_links(text, self_citation=self_citation)
