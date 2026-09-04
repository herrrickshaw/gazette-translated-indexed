"""
Regression test for extract.heavy_industries_patterns against two real
Ministry of Heavy Industries notifications (see
db/seed_heavy_industries.sql for provenance), quoted from primary "Full
Text" by a research agent — one Hindi-text-only corrigendum, one
substantive "partial modification" amendment.
"""
from extract.heavy_industries_patterns import find_candidate_links

HINDI_CORRIGENDUM = (
    "S.O. 1636(E). — In the Notification of the Ministry of Heavy Industries, Government of "
    "India, S.O.1334 (E) dated the 13th March, 2024, published in the Gazette of India, "
    "Extraordinary, Part-II, Section-3, Sub-section(ii), the following amendments in the Hindi "
    "version are hereby made: 1. In para 6, the word may be read as corrected."
)

PARTIAL_MODIFICATION = (
    "S.O. 5486 (E).—In partial modification of the Production Linked Incentive (PLI) Scheme for "
    "Automobile and Auto Component industry (PLI-AUTO) which was notified by the Ministry of "
    "Heavy Industries vide S.O. No. 3946 (E) dated 23rd September 2021, the following amendments "
    "are made with effect from date of its publication in the Official Gazette."
)


def test_finds_the_real_corrigendum_link():
    links = find_candidate_links(HINDI_CORRIGENDUM, self_citation='S.O. 1636(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 1334(E)' in targets


def test_finds_the_real_partial_modification_link():
    links = find_candidate_links(PARTIAL_MODIFICATION, self_citation='S.O. 5486(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 3946(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(HINDI_CORRIGENDUM, self_citation='S.O. 1636(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all'
    assert 'S.O. 1636(E)' not in targets
