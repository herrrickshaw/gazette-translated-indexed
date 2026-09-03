"""
Regression test for extract.civil_aviation_patterns against one real
Civil Aviation corrigendum (see db/seed_civil_aviation.sql for provenance:
G.S.R. 124(E) corrects G.S.R. 77(E)). The research agent's quote captured
the operative clause but not the notification's own opening self-citation
line; that opening is prepended here using the real, agent-confirmed
G.S.R. 124(E) citation, per the same universal-convention scaffolding used
for the Home Affairs test.
"""
from extract.civil_aviation_patterns import find_candidate_links

EXAMPLE = (
    "G.S.R. 124(E). In the english version of the Notification of the Government of India, Ministry of "
    "Civil Aviation, G.S.R. 77(E), dated the 30th January, 2026, published in Gazette of India "
    "Extraordinary, Part II, Section 3, Sub-Section (i), dated the 31st January, 2026, (a) at page 13, "
    "line 38 for \"3. Non-consensual rights or interests under the Convention. — (1)\" read \"3. "
    "Non-consensual rights or interests under the Convention. -\"."
)


def test_finds_the_real_corrigendum_link():
    links = find_candidate_links(EXAMPLE, self_citation='G.S.R. 124(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 77(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(EXAMPLE, self_citation='G.S.R. 124(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all — would make this exclusion check vacuous'
    assert 'G.S.R. 124(E)' not in targets
