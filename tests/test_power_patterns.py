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


def test_repeal_shape_via_corrigendum_substitution():
    # Real text: "hereby repeals the notification ... Ministry of Power ...
    # vide notification number X" — doesn't say "makes the following
    # amendment" at all, so only corrigendum-substitution's verb-agnostic
    # ministry-name-then-citation anchor catches it.
    repeal_text = (
        "S.O. 2979(E).— In exercise of the powers conferred by clause (b) and clause (d) of section "
        "14 of the Energy Conservation Act, 2001 (52 of 2001), the Central Government, in consultation "
        "with the Bureau of Energy Efficiency, hereby repeals the notification of the Government of "
        "India, Ministry of Power, published in the Gazette of India, Extraordinary, Part II, Section "
        "3, Sub-section (ii), vide notification number S.O. 1033(E), dated the 9th March, 2018, "
        "relating to the Standards and Labelling Program for Tubular Fluorescent Lamps."
    )
    links = find_candidate_links(repeal_text, self_citation='S.O. 2979(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 1033(E)' in targets


def test_further_to_amend_shape_via_corrigendum_substitution():
    # Real text: "further to amend the notification ... Ministry of Power
    # ... vide number X" — not "makes the following amendment" either.
    amendment_text = (
        "S.O. 2976(E). — In exercise of the powers conferred by clause (a) of section 14 of the "
        "Energy Conservation Act, 2001 (52 of 2001), the Central Government, in consultation with the "
        "Bureau of Energy Efficiency, further to amend the notification of the Government of India, "
        "Ministry of Power published in the Gazette of India, Extraordinary, Part II, Section 3, "
        "Sub-section (ii), vide number S.O. 4097(E), dated the 27th December, 2017, namely:—"
    )
    links = find_candidate_links(amendment_text, self_citation='S.O. 2976(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 4097(E)' in targets
