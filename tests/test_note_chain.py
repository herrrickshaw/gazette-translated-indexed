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

# Real Ministry of Mines text: an eight-item amendment history (principal +
# seven amendments) joined by semicolons, with "and" before the final item
# ("...16th April, 2025; and 7. G.S.R. 449(E)..."). The regex-based citation
# scan doesn't anchor on connectives at all, but this is the longest real
# chain seen so far and the first with an "and" conjunction, worth its own
# confirmation rather than assuming the 2-3 item cases generalize.
MINES_MCDR_NOTE = (
    "Note: - The principal rules were published in the Gazette of India, Extraordinary, Part II, "
    "Section 3, Sub-section (i), vide notification number G.S.R. 169 (E) dated the 27th February, 2017 "
    "and were subsequently amended as follows:– 1. G.S.R. 289 (E), dated the 27th March, 2018; "
    "2. G.S.R. 570 (E), dated the 13th August, 2019; 3. G.S.R. 780 (E), dated the 3rd November, 2021; "
    "4. G.S.R. 294 (E), dated the 11th April, 2022; 5. G.S.R. 51 (E), dated the 21st January, 2024; "
    "6. G.S.R. 232 (E), dated the 16th April, 2025; and 7. G.S.R. 449 (E), dated the 5th June, 2026."
)

# Real Ministry of Defence text: same shape as Culture/Consumer Affairs but
# the first ministry confirmed to cite exclusively via S.R.O. rather than
# G.S.R./S.O. — confirms find_note_chain works through the shared
# find_gazette_citations scan regardless of which of the three series is
# used, without any change to this function itself.
DEFENCE_NAVY_ACT_NOTE = (
    "Note: The principal notification was published in the Gazette of India, Extraordinary, Part II, "
    "section 4, dated the 23rd June, 2022 vide number S.R.O. 9(E), dated the 23rd June, 2022."
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


def test_eight_item_chain_with_and_conjunction_before_last_item():
    assert find_note_chain(MINES_MCDR_NOTE) == [
        'G.S.R. 169(E)', 'G.S.R. 289(E)', 'G.S.R. 570(E)', 'G.S.R. 780(E)',
        'G.S.R. 294(E)', 'G.S.R. 51(E)', 'G.S.R. 232(E)', 'G.S.R. 449(E)',
    ]


def test_sro_series_note_chain():
    assert find_note_chain(DEFENCE_NAVY_ACT_NOTE) == ['S.R.O. 9(E)']
