"""
Regression test for extract.skill_development_patterns against three real
Ministry of Skill Development and Entrepreneurship notifications (see
db/seed_skill_development.sql for provenance), quoted from primary "Full
Text" by a research agent — one plain corrigendum, two supersessions under
the Apprentices Act, 1961 (one superseding a DIFFERENT ministry's
notification, confirming the supersession template must not anchor on a
ministry name).
"""
from extract.skill_development_patterns import find_candidate_links

CORRIGENDUM = (
    "CORRIGENDUM New Delhi, the 8th October, 2025 G.S.R. 744(E). In the notification of the "
    "Government of India in the Ministry of Skill Development and Entrepreneurship, vide number "
    "G.S.R. 130 (E), dated the 11th February, 2025, published in the Gazette of India, "
    "Extraordinary, Part II, Section 3, Sub-section (i), dated 11th February, 2025, in line 3 of "
    "Page 12, for \"2024\", substitute \"2025\"."
)

SUPERSESSION_OTHER_MINISTRY = (
    "In exercise of the powers conferred by clause(a) of sub-section(4) of section 1 of the "
    "Apprentices Act, 1961(52 of 1961), and in supersession of the notification of the Ministry "
    "of Labour, Directorate General of Employment and Training; published in the Gazette of "
    "India, Extraordinary Part II, section 3, sub-section (i) vide number G.S.R. 479(E) dated "
    "the 30th June, 1999, except as respects things done or omitted to be done before such "
    "supersession, the Central Government hereby specifies the following groups of industries."
)

SUPERSESSION_SELF_MINISTRY = (
    "In exercise of the powers conferred by sub-sections (1) and (2) of section 24 of the "
    "Apprentices Act, 1961 (52 of 1961) read with rules 3 and 4 of the Central Apprenticeship "
    "Council Rules, 1962 and in supersession of the notification of the Government of India in "
    "the Ministry of Skill Development and Entrepreneurship number S.O. 1348(E), dated the 8th "
    "March, 2019, except as respects things done or omitted to be done before such supersession, "
    "the Central Government hereby reconstitutes the Central Apprenticeship Council."
)


def test_corrigendum_shape():
    links = find_candidate_links(CORRIGENDUM, self_citation='G.S.R. 744(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 130(E)' in targets


def test_supersession_of_a_different_ministrys_notification():
    # The superseded notification was issued by the Ministry of Labour, not
    # Skill Development — the template must not anchor on "ministry of
    # skill development" the way the other two templates do, or this link
    # would be missed entirely.
    links = find_candidate_links(SUPERSESSION_OTHER_MINISTRY, self_citation='S.O. 4072(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 479(E)' in targets


def test_supersession_of_the_same_ministrys_own_notification():
    links = find_candidate_links(SUPERSESSION_SELF_MINISTRY, self_citation='S.O. 4560(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 1348(E)' in targets
    assert 'S.O. 4560(E)' not in targets
