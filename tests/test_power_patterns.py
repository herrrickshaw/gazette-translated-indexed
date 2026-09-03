"""
Regression test for extract.power_patterns against one real Ministry of
Power amendment (see db/seed_power.sql for provenance: S.O. 3520(E) amends
S.O. 5852(E)), quoted from primary "Full Text" by a research agent.
"""
from extract.power_patterns import find_candidate_links

EXAMPLE = (
    "S.O. 3520(E). In exercise of the powers conferred by sub-section (1) of section 70 of the "
    "Information Technology Act, 2000 (21 of 2000), the Central Government hereby makes the following "
    "amendment in the notification of the Government of India, Ministry of Power number S.O. 5852(E), "
    "dated the 13th December, 2022, namely:-"
)


def test_finds_the_real_amendment_link():
    links = find_candidate_links(EXAMPLE, self_citation='S.O. 3520(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 5852(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(EXAMPLE, self_citation='S.O. 3520(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all — would make this exclusion check vacuous'
    assert 'S.O. 3520(E)' not in targets


def test_scope_guard_bare_word_power_does_not_false_positive():
    # The anchor phrase "...powers conferred by..." contains "power" as a
    # substring — confirm the scope guard requires the multi-word ministry
    # name, not the bare word, so this doesn't fire on any ministry's text.
    unrelated = (
        "In exercise of the powers conferred by the Ministry of Textiles, the Central Government "
        "hereby makes the following amendment in the notification of the Government of India, Ministry "
        "of Textiles number S.O. 1(E), dated 1.1.2020."
    )
    assert find_candidate_links(unrelated) == []
