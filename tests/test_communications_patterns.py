"""
Regression test for extract.communications_patterns against one real
Ministry of Communications rescission (see db/seed_communications.sql:
G.S.R. 863(E) rescinds G.S.R. 796(E)), quoted from primary "Full Text" by a
research agent. Real text writes the target as "G.S.R.796(E)" — no space
before the digits.
"""
from extract.communications_patterns import find_candidate_links

EXAMPLE = (
    "G.S.R. 863(E).— In exercise of the powers conferred by clause (v) of sub-section (2) of section 56 "
    "of the Telecommunications Act, 2023 (44 of 2023), the Central Government hereby rescinds the "
    "notification of the Government of India, in the Ministry of Communications, Department of "
    "Telecommunications, dated the 22nd October, 2025 published in the Gazette of India, Extraordinary, "
    "Part II, Section 3, Sub-section (i), vide number G.S.R.796(E), dated the 29th October, 2025, except "
    "as respects things done or omitted to be done before such rescission."
)


def test_finds_the_real_rescission_link():
    links = find_candidate_links(EXAMPLE, self_citation='G.S.R. 863(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 796(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(EXAMPLE, self_citation='G.S.R. 863(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all — would make this exclusion check vacuous'
    assert 'G.S.R. 863(E)' not in targets
