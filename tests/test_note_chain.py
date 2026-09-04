"""
Regression test for extract.common_templates.find_note_chain against two
real "Note[:.-]" amendment-history clauses — Ministry of Culture (National
Monuments Authority rules, a 2-item chain) and Department of Food and
Public Distribution (Legal Metrology Rules, a different connective word
for the same shape: "was last amended" vs. "subsequently amended"), both
quoted from primary "Full Text" by research agents. This template was
deliberately deferred across nine real ministries before being written —
see the module's own docstring — so both real examples are used here
rather than one, the same discipline the other two templates got.
"""
from extract.common_templates import find_note_chain

CULTURE_NMA = (
    "Whereas the National Monuments Authority (Conditions of Service of Chairman and Members of the "
    "Authority and Conduct of Business) Rules, 2011 were notified under section 38 of the Ancient "
    "Monuments and Archaeological Sites and Remains Act, 1958 (24 of 1958) vide notification of the "
    "Government of India in the Ministry of Culture number G.S.R.635 (E), dated the 23rd August, 2011. "
    "Note: The principal rules were published in the Gazette of India, Extraordinary, Part II, Section 3, "
    "Sub-section (i), vide notification number G.S.R. 635(E), dated the 23rd August, 2011 and subsequently "
    "amended vide notification number G.S.R. 1034(E), dated the 11th October, 2018."
)

CONSUMER_AFFAIRS_LEGAL_METROLOGY = (
    "G.S.R. 418(E). — In exercise of the powers conferred by sub-section (1) read with clauses (j) and (q) "
    "of sub-section (2) of section 52 of the Legal Metrology Act, 2009 (1 of 2010), the Central Government "
    "hereby makes the following rules further to amend the Legal Metrology (Packaged Commodities) Rules, "
    "2011. Note: The principal rules were published in the Gazette of India, Extraordinary, Part II, "
    "Section 3, Sub-section (i) vide number G.S.R. 202 (E), dated the 7th March, 2011 and was last amended "
    "vide number G.S.R. 312(E), dated 27th April, 2026."
)


def test_two_item_chain_in_order():
    assert find_note_chain(CULTURE_NMA) == ['G.S.R. 635(E)', 'G.S.R. 1034(E)']


def test_different_connective_word_same_shape():
    # "was last amended" vs. "subsequently amended" — the template doesn't
    # anchor on the connective, only on "note" itself, so both work.
    assert find_note_chain(CONSUMER_AFFAIRS_LEGAL_METROLOGY) == ['G.S.R. 202(E)', 'G.S.R. 312(E)']


def test_self_citation_before_the_note_is_not_included():
    # G.S.R. 418(E) (this document's own opening citation) appears before
    # "Note:" and must not leak into the chain — the function has no
    # self_citation parameter precisely because scanning from the anchor
    # onward already excludes it structurally.
    assert 'G.S.R. 418(E)' not in find_note_chain(CONSUMER_AFFAIRS_LEGAL_METROLOGY)


def test_no_note_clause_returns_empty():
    assert find_note_chain('S.O. 1(E). A notification with no Note clause at all.') == []


def test_note_as_a_word_inside_other_text_is_not_a_false_anchor():
    # "noteworthy" contains "note" but not as the standalone word the
    # regex requires (\bnote\b) — must not treat it as the anchor.
    assert find_note_chain('This is noteworthy: G.S.R. 1(E), dated 1.1.2020.') == []
