"""
Regression test for extract.mohua_patterns against one real MoHUA
corrigendum (see db/seed_mohua.sql for provenance: S.O. 4041(E) corrects
S.O. 3379(E)), quoted from primary "Full Text" by a research agent.
"""
from extract.mohua_patterns import find_candidate_links

EXAMPLE = (
    "S.O. 4041(E).— In the English version of the notification of the Government of India, Ministry of "
    "Housing and Urban Affairs, Directorate of Estates published in the Gazette of India, Extraordinary, "
    "Part II, section 3, sub-section (ii) dated the 24th June, 2026 vide Notification number S.O. "
    "3379(E) dated the 24th June, 2026,— (a) for \"serial number 36\" read \"serial number 15\"; and "
    "(b) for \"the Public Premises (Eviction of Unauthorised Occupants) Act, 1971 (40 of 1971)\" read "
    "\"the Requisitioning and Acquisition of Immovable Property Act, 1952 (30 of 1952)\"."
)


def test_finds_the_real_corrigendum_link():
    links = find_candidate_links(EXAMPLE, self_citation='S.O. 4041(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 3379(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(EXAMPLE, self_citation='S.O. 4041(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all — would make this exclusion check vacuous'
    assert 'S.O. 4041(E)' not in targets
