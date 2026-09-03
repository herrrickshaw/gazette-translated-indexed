"""
Regression test for extract.railways_patterns against one real Railways
corrigendum (see db/seed_railways.sql for provenance: S.O. 4815(E) corrects
survey numbers in S.O. 2950(E)) — a South Western Railway (Construction
Organisation) notification, quoted from its primary "Full Text" by a
research agent. This is the exact "minor survey-number correction, hard to
trace back" pattern this whole project targets.

Note the source document itself contains an internal date inconsistency
(S.O. 2950(E) is dated "08.09.2026", after this corrigendum's own 31 Aug
2026 date, which is impossible) — flagged by the research agent as a likely
OCR/typo artifact in the primary text, not resolved here; the date is kept
as printed rather than silently corrected.
"""
from extract.railways_patterns import find_candidate_links

EXAMPLE = (
    "MINISTRY OF RAILWAYS [(South Western Railway (Construction Organisation)] CORRIGENDUM Bengaluru, "
    "the 31st August, 2026 (In Regard to E-Gazette Notification No. 2856 dated JUNE 9, 2026) "
    "S.O. 4815(E).— In the Notification S.O. 2950 (E), dated 08.09.2026, issued by the Ministry of "
    "Railways [South Western Railway (Construction Organisation)], the following Survey numbers to be "
    "read as mentioned in the column No. (7)."
)


def test_finds_the_real_corrigendum_link():
    links = find_candidate_links(EXAMPLE, self_citation='S.O. 4815(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 2950(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(EXAMPLE, self_citation='S.O. 4815(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all — would make this exclusion check vacuous'
    assert 'S.O. 4815(E)' not in targets


def test_scope_guard_ignores_unrelated_ministry_text():
    unrelated = "In the Notification S.O. 999(E), dated 1.1.2020, issued by the Ministry of Textiles."
    assert find_candidate_links(unrelated) == []
