"""
Regression test for extract.meity_patterns against one real MeitY
corrigendum (see db/seed_meity.sql for provenance: G.S.R. 148(E) corrects
G.S.R. 120(E)), quoted from primary "Full Text" by a research agent.
"""
from extract.meity_patterns import find_candidate_links

EXAMPLE = (
    "G.S.R. 148(E). — In the notification of the Government of India in the Ministry of Electronics and "
    "Information Technology, dated the 10th February, 2026, published in the Gazette of India, "
    "Extraordinary, Part II, Section 3, Sub-section (i), vide number G.S.R. 120(E), dated the 10th "
    "February, 2026, Issue No. 114, in page 10— (a) lines 10 and 11, for \"the Bharatiya Nagarik "
    "Suraksha Sanhita, 2023 (46 of 2023)\", read \"the Bharatiya Nyaya Sanhita, 2023 (45 of 2023) read "
    "with the Bharatiya Nagarik Suraksha Sanhita, 2023 (46 of 2023)\"."
)


def test_finds_the_real_corrigendum_link():
    links = find_candidate_links(EXAMPLE, self_citation='G.S.R. 148(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 120(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(EXAMPLE, self_citation='G.S.R. 148(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all — would make this exclusion check vacuous'
    assert 'G.S.R. 148(E)' not in targets
