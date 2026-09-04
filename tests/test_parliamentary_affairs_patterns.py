"""
Regression test for extract.parliamentary_affairs_patterns against two
real Ministry of Parliamentary Affairs notifications (see
db/seed_parliamentary_affairs.sql for provenance), quoted from primary
"Full Text" by a research agent.
"""
from extract.parliamentary_affairs_patterns import find_candidate_links

RAJYA_SABHA_AMENDMENT = (
    "G.S.R. 281(E).— In partial modification of the notification of the Government of India, "
    "Ministry of Parliamentary Affairs, number G.S.R. 924(E), dated the 19th December, 2025, "
    "published in the Gazette of India, Extraordinary, Part II, Section 3, Sub-section (i), "
    "vide CG-DL-E-26122025-268836, No. 838, dated the 26th December, 2025, the following shall "
    "be substituted in place of Para 1(2)."
)

LOK_SABHA_SUPERSESSION = (
    "and in supersession of the Ministry of Parliamentary Affairs notification published in the "
    "Gazette of India Extraordinary Part II, Section 3, Sub-section (i) vide G.S.R. 923(E) "
    "dated the 26th December, 2025, except as respects things done or omitted to be done before "
    "such supersession, the said Ministry hereby notifies the following, namely:—"
)


def test_finds_the_real_amendment_link():
    links = find_candidate_links(RAJYA_SABHA_AMENDMENT, self_citation='G.S.R. 281(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 924(E)' in targets


def test_finds_the_real_supersession_link():
    links = find_candidate_links(LOK_SABHA_SUPERSESSION, self_citation='G.S.R. 168(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 923(E)' in targets
