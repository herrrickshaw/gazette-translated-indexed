"""
Regression test for extract.morth_patterns against the one real MoRTH
corrigendum sentence this pilot has been verified against (observed on a
live public gazette-tracking feed, 2026-09-03 — see db/seed_morth.sql for
full provenance notes). One example, not a validated pattern: see GATES.md G4
before trusting this against unseen MoRTH text.
"""
from extract.morth_patterns import find_candidate_links

REAL_OBSERVED_SENTENCE = (
    "The Central Government issues a corrigendum, S.O. 4848(E) dated 1st "
    "September, 2026, under the National Highways Act, 1956, to amend "
    "notification S.O 4872(E) dated 24.10.2025 by correcting incorrect "
    "village names."
)


def test_finds_the_real_corrigendum_link():
    links = find_candidate_links(REAL_OBSERVED_SENTENCE, self_so='S.O. 4848(E)')
    targets = {l.target_so for l in links}
    assert 'S.O. 4872(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(REAL_OBSERVED_SENTENCE, self_so='S.O. 4848(E)')
    targets = {l.target_so for l in links}
    assert 'S.O. 4848(E)' not in targets


def test_relation_type_is_corrigendum():
    links = find_candidate_links(REAL_OBSERVED_SENTENCE, self_so='S.O. 4848(E)')
    assert all(l.relation_type == 'corrigendum' for l in links)
