"""
Regression test for extract.common_templates.find_note_chain against a
real Ministry of Ayush Note clause (NCISM Act appointments), quoted
verbatim by a research agent per the instruction to capture the whole
clause, not just its first citation.
"""
from extract.common_templates import find_note_chain

AYUSH_NCISM_NOTE = (
    "Note: The principal notification was published in the Gazette of India, Extraordinary, Part II, "
    "Section 3, Sub-section (ii) vide number S.O, 2281(E), dated the 11th June, 2021 and was last amended "
    "vide notification number S.O, 221(E), dated the 19th March, 2024."
)


def test_two_item_chain_survives_the_comma_typo_after_so():
    # Real text writes "S.O, 2281(E)" and "S.O, 221(E)" — a comma where a
    # period belongs, evidently a keying error in the source gazette
    # itself. The citation regex's "S\.?" already tolerates a missing
    # trailing period; kept as printed, not silently corrected.
    assert find_note_chain(AYUSH_NCISM_NOTE) == ['S.O. 2281(E)', 'S.O. 221(E)']
