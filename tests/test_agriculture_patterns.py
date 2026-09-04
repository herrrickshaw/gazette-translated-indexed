"""
Regression test for extract.agriculture_patterns against one real
Ministry of Agriculture and Farmers Welfare amendment (see
db/seed_agriculture.sql for provenance: S.O. 3666(E) amends S.O. 1018(E),
a Fertiliser (Control) Order, 1985 notification), quoted from primary
"Full Text" by a research agent.
"""
from extract.agriculture_patterns import find_candidate_links

EXAMPLE = (
    "In pursuance of sub-clause (c) of clause 22 of Fertiliser (Inorganic, Organic or Mixed) (Control) "
    "Order, 1985, the Central Government herby makes the following amendments in the notifications of "
    "Government of India in the Ministry of Agriculture and Farmers Welfare, published in the Gazette of "
    "India, vide number S.O. 1018 (E) dated 25th Feburary,2026, namely, in the said notification."
)


def test_finds_the_real_amendment_link():
    links = find_candidate_links(EXAMPLE, self_citation='S.O. 3666(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 1018(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(EXAMPLE, self_citation='S.O. 3666(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all — would make this exclusion check vacuous'
    assert 'S.O. 3666(E)' not in targets


def test_corrigendum_shape_no_amendment_verb():
    # Real text: "for X read Y" with no "makes the following amendment" at
    # all — only corrigendum-substitution catches this.
    corrigendum = (
        "S.O. 1935(E). — In the Notification of the Government of India, Ministry of Agriculture and "
        "Farmers Welfare, published in the Gazette of India, Extraordinary, Part II, Section 3, "
        "Sub-section (ii), vide number S.O. 1177(E), dated the 6th March, 2026, at page 3, in "
        "paragraph (c), for the words \"National Institute of Occupational Hazard\", read \"National "
        "Institute of Occupational Health\"."
    )
    links = find_candidate_links(corrigendum, self_citation='S.O. 1935(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 1177(E)' in targets
