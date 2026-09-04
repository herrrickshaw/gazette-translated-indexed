"""
Regression test for extract.mines_patterns against a real Ministry of Mines
corrigendum (see db/seed_mines.sql for provenance), quoted from primary
"Full Text" by a research agent.
"""
from extract.mines_patterns import find_candidate_links

CONCESSION_RULES_CORRIGENDUM = (
    "G.S.R. 255(E).— In the notification of the Government of India, Ministry of Mines, "
    "published in the Gazette of India, Extraordinary, Part II, Section 3, Sub-section (i) "
    "vide number G.S.R. 222(E), dated the 30th March, 2026, in the English Version,— at page "
    "number 9, in line 51, for \"for\" read \"from\"."
)


def test_finds_the_real_corrigendum_link():
    links = find_candidate_links(CONCESSION_RULES_CORRIGENDUM, self_citation='G.S.R. 255(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 222(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(CONCESSION_RULES_CORRIGENDUM, self_citation='G.S.R. 255(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all'
    assert 'G.S.R. 255(E)' not in targets
