"""
Regression test for extract.mca_patterns against one real MCA corrigendum
(see db/seed_mca.sql for provenance: G.S.R. 849(E) corrects a misspelled
name in G.S.R. 703(E)), quoted from primary "Full Text" by a research agent.
"""
from extract.mca_patterns import find_candidate_links

EXAMPLE = (
    'G.S.R. 849(E).—In the notification of the Government of India, Ministry of Corporate Affairs '
    'number G.S.R. 703 (E), dated the 22nd September, 2025, published in the Gazette of India, '
    'Extraordinary, Part II, Section 3, Sub-section (i), dated the 22nd September, 2025, at page 3, '
    'in the English version, in line 5, for "Ms. Deepna Gokularm" read "Ms. Deepna Gokulram".'
)


def test_finds_the_real_corrigendum_link():
    links = find_candidate_links(EXAMPLE, self_citation='G.S.R. 849(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 703(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(EXAMPLE, self_citation='G.S.R. 849(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all — would make this exclusion check vacuous'
    assert 'G.S.R. 849(E)' not in targets
