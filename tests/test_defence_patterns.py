"""
Regression test for extract.defence_patterns against a real Ministry of
Defence corrigendum (see db/seed_defence.sql for provenance), quoted from
primary "Full Text" by a research agent.
"""
from extract.defence_patterns import find_candidate_links

CANTONMENT_BOARD_AMENDMENT = (
    "the Central Government hereby makes the following amendment in the notification of the "
    "Government of India in the Ministry of Defence vide number S.R.O. 19(E), dated the 12nd "
    "November, 2025, published in the Gazette of India (Extraordinary), Part II, Section 4, "
    "dated the 12nd November, 2025, namely:- (i) in serial number 3, in column (3), for clause "
    "(c), the following clause shall be substituted, namely:- \"(c) Shri Rishi Dutt Sharma\"."
)


def test_finds_the_real_amendment_link():
    links = find_candidate_links(CANTONMENT_BOARD_AMENDMENT, self_citation='S.R.O. 18(E)')
    targets = {l.target_citation for l in links}
    assert 'S.R.O. 19(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(CANTONMENT_BOARD_AMENDMENT, self_citation='S.R.O. 18(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all'
    assert 'S.R.O. 18(E)' not in targets
