"""
Regression test for extract.mha_patterns against one real MHA amendment
(see db/seed_mha.sql for provenance: S.O. 3778(E) amends S.O. 3987(E)).

The research agent's quote captured the operative clause but not the
notification's own opening self-citation line. Every real example seen in
this project so far (CBIC, MoRTH, MoEFCC) opens with "<citation>. In
exercise of powers conferred by..." — a near-universal convention — so that
opening is prepended here using the real, agent-confirmed S.O. 3778(E)
citation, to make the self-exclusion test meaningful rather than vacuously
true. This is standard-convention scaffolding around a real quote, not a
fabricated fact.
"""
from extract.mha_patterns import find_candidate_links

EXAMPLE = (
    "S.O. 3778(E). In exercise of powers conferred by the Passport (Entry into India) Act, 1920, "
    "the Central Government hereby makes the following amendments in the notification of the "
    "Government of India, Ministry of Home Affairs, published in the Gazette of India, Extraordinary, "
    "Part II, Section 3, Sub-section (ii) vide number S.O.3987(E), dated the 1st September, 2025, "
    "namely:- in the said notification, after serial number 38 and the entries relating thereto, the "
    "following serial number and entry shall be inserted, namely:- \"39. Bhogapuram (Andhra Pradesh)\"."
)


def test_finds_the_real_amendment_link():
    links = find_candidate_links(EXAMPLE, self_citation='S.O. 3778(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 3987(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(EXAMPLE, self_citation='S.O. 3778(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all — would make this exclusion check vacuous'
    assert 'S.O. 3778(E)' not in targets
