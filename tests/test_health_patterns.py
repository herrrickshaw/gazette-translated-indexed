"""
Regression test for extract.health_patterns against one real MoHFW
corrigendum (see db/seed_health.sql for provenance: G.S.R. 11(E) corrects
G.S.R. 10(E)). Quote is the notification's own primary text, as reported by
a research agent.
"""
from extract.health_patterns import find_candidate_links

EXAMPLE = (
    "G.S.R. 11(E). In the draft notification of the Government of India, Ministry of Health and Family "
    "Welfare, published in the Gazette of India, Extraordinary Part II, Section 3, Sub-Section(i) vide "
    "G.S.R. 10(E) dated the 4th January, 2025. In the said notification in para 4 for the words \"in "
    "exercise of the powers conferred by sections 12 and 13 of the Drugs and Cosmetics Act, 1940 (23 of "
    "1940)\" the following shall be substituted as, :- \"in exercise of the powers conferred by sections "
    "12 and 33 of the Drugs and Cosmetics Act, 1940 (23 of 1940)\"."
)


def test_finds_the_real_corrigendum_link():
    links = find_candidate_links(EXAMPLE, self_citation='G.S.R. 11(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 10(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(EXAMPLE, self_citation='G.S.R. 11(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all — would make this exclusion check vacuous'
    assert 'G.S.R. 11(E)' not in targets
