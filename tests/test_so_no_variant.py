"""
Regression test for extract.citation_patterns' "S.O. No. NNNN(E)" variant —
a real Ministry of Social Justice and Empowerment Note clause (Rehabilitation
Council of India General Council reconstitution) writes "S.O. No. 1436 (E)"
with an extra "No." that every other ministry modeled so far omits.
"""
from extract.common_templates import find_note_chain

RCI_NOTE = (
    "Note: The principal notification was issued vide notification number S.O. 1102 (E), "
    "dated 21st October, 2002, and last amended vide notification number S.O. No. 1436 (E), "
    "dated 26th March, 2025."
)


def test_so_no_variant_is_recognized():
    assert find_note_chain(RCI_NOTE) == ['S.O. 1102(E)', 'S.O. 1436(E)']
