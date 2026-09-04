"""
Regression test for extract.steel_patterns against one real Ministry of
Steel corrigendum (see db/seed_steel.sql for provenance: S.O. 2685(E)
corrects an address in S.O. 1868(E)), quoted from primary "Full Text" by a
research agent. The agent's quote captured the operative clause but not the
notification's own opening self-citation line; that opening is prepended
using the real, agent-confirmed S.O. 2685(E) citation, per the same
universal-convention scaffolding used for the Home Affairs test.
"""
from extract.steel_patterns import find_candidate_links

EXAMPLE = (
    "S.O. 2685(E).— In notification of the Government of India in the Ministry of Steel, number "
    "S.O. 1868 (E), dated the 25th April, 2025 published in Gazette of India Extraordinary, Part II, "
    "Section 3, Sub-section(ii), Issue No. 1835, in line (b), for \"the Joint Plant Committee ... Ispat "
    "Niketan, 52/1A, Ballygunge Circular Road, Kolkata 700019\", read \"the Joint Plant Committee ... "
    "301-306, Third Floor, Aurobindo Place, Hauz Khas, New Delhi – 110 016\"."
)


def test_finds_the_real_corrigendum_link():
    links = find_candidate_links(EXAMPLE, self_citation='S.O. 2685(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 1868(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(EXAMPLE, self_citation='S.O. 2685(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all — would make this exclusion check vacuous'
    assert 'S.O. 2685(E)' not in targets
