"""
Regression test for extract.cooperation_patterns against two real
Ministry of Cooperation notifications (see db/seed_cooperation.sql for
provenance), quoted from primary "Full Text" by a research agent — an
amendment and a cross-ministry supersession.
"""
from extract.cooperation_patterns import find_candidate_links

NCDC_AMENDMENT = (
    "the Central Government hereby makes the following amendment in the Notification of the "
    "Ministry of Cooperation published vide G.S.R.93(E) dated 2nd February, 2024."
)

CROSS_MINISTRY_SUPERSESSION = (
    "G.S.R. 93(E). In exercise of the powers conferred by sub-section (4) of section 3 of the "
    "National Co-operative Development Corporation Act, 1962 (26 of 1962), read with rule 3 of "
    "the National Co-operative Development Corporation Rules, 1975, and in supersession of the "
    "notification of the Government of India, Ministry of Agriculture & Farmers Welfare "
    "(Department of Agriculture, Cooperation & Farmers Welfare) number G.S.R. 427(E), dated the "
    "1st July, 2020, the Central Government hereby notifies."
)


def test_finds_the_real_amendment_link():
    links = find_candidate_links(NCDC_AMENDMENT, self_citation='G.S.R. 275(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 93(E)' in targets


def test_finds_the_real_cross_ministry_supersession():
    links = find_candidate_links(CROSS_MINISTRY_SUPERSESSION, self_citation='G.S.R. 93(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 427(E)' in targets
