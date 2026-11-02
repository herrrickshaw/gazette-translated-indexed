"""Synthetic notification text + a function that runs every extractor over it.

Used by tests/test_golden_extraction.py to prove refactors of the extraction
and matching modules reproduce the original outputs exactly. All text here is
hand-written synthetic text (no network, no real gazette content).
"""
from __future__ import annotations

import importlib
import pkgutil

import extract

SELF = "S.O. 100(E)"

TEXTS = {
    "amendment": (
        "S.O. 100(E).- The Central Government hereby makes the following\n"
        "amendments in the notification of the Government of India in the\n"
        "Ministry of Road Transport and Highways, number S.O. 55(E), dated "
        "1st Jan 2020 and G.S.R. 12(E) dated 2nd Feb 2021."
    ),
    "further_amendment": (
        "The Government makes the following further amendment in the notification "
        "of the Ministry of Power vide number S.O. 371(E) dated 3rd March 2022 "
        "and S.O. 100(E)."
    ),
    "corrigendum": (
        "In the notification of the Government of India in the Ministry of "
        "Environment, Forest and Climate Change vide number S.O. 7(E), dated "
        "4th April 2019, for 'old' read 'new'. Ministry of Health and Family "
        "Welfare, G.S.R. 9(E)."
    ),
    "supersession": (
        "In supersession of the notification of the Ministry of Labour vide "
        "S. O. 1436 (E), S.O, 2281(E) and G.S.R - 165(E), S.R.O. 44(E) except as "
        "respects things done before such supersession; S.O. 999(E) elsewhere."
    ),
    "bare": (
        "vide notification number S.O. 1398(E) dated x; In the Notification "
        "S.O. 174(E) dated y; in the notification vide S.O.1935(E) dated z. "
        + "filler " * 40 + "vide G.S.R. 77(E)."
    ),
    "note": (
        "Body text. Footnote: The principal rules were published vide number "
        "G.S.R. 1(E), dated 1st Jan 2000 and subsequently amended vide S.O. 2(E), "
        "S.O. 3(E), G.S.R. 1(E) and S.O. 100(E). noteworthy S.O. 5(E)"
    ),
    "railways": (
        "S.O. 100(E).- In the Notification S.O. 8(E), dated 1st May 2020, issued "
        "by the Ministry of Railways, South Western Railway, for 'a' read 'b'."
    ),
    "no_match": "Nothing citable here, ministry of power, makes the following amendment.",
    "cbic": (
        "G.S.R. 1(E). Notification No. 45/2025-Customs. In supersession of "
        "notification No. 207/89-Customs, No. 3-Customs and No. 12/2020 - Customs (ADD) "
        "dated x, except as respects things done. Further amend No. 7/2019-Customs; "
        "read with No. 9/2018 –Customs. In partial modification of No. 45/2025-Customs. "
        "The Central Government, on being satisfied No. 99/2001-Customs."
    ),
}


def _ser(obj):
    if isinstance(obj, (list, tuple)):
        return [_ser(o) for o in obj]
    if hasattr(obj, "__dataclass_fields__"):
        return {k: _ser(getattr(obj, k)) for k in obj.__dataclass_fields__}
    return obj


def run_all() -> dict:
    """Run every extractor on every synthetic text; return a JSON-able dict."""
    from extract import citation_patterns as cp
    from extract import common_templates as ct
    from extract import cross_ref

    out: dict = {}
    for name, text in TEXTS.items():
        r: dict = {}
        r["citations"] = _ser(cp.find_citations(text))
        r["gazette_citations"] = _ser(cp.find_gazette_citations(text))
        r["gazette_ids"] = cp.find_gazette_ids(text)
        for self_n in (None, "45/2025"):
            r[f"cross_ref[{self_n}]"] = _ser(cross_ref.find_candidate_links(text, self_n))
        for self_c in (None, SELF):
            r[f"supersession[{self_c}]"] = _ser(ct.find_supersession_links(text, self_c))
            r[f"bare[{self_c}]"] = _ser(ct.find_bare_citation_links(text, self_c))
            r[f"after_anchor[{self_c}]"] = _ser(ct.find_after_anchor(text, "vide", self_c, 80))
            for m in ("road transport and highways", "power", "ministry of power"):
                r[f"amend[{m}|{self_c}]"] = _ser(ct.find_amendment_in_notification_links(text, m, self_c))
                r[f"corrig[{m}|{self_c}]"] = _ser(ct.find_corrigendum_substitution_links(text, m, self_c))
        r["note_chain"] = ct.find_note_chain(text)
        for info in sorted(pkgutil.iter_modules(extract.__path__), key=lambda i: i.name):
            if not info.name.endswith("_patterns") or info.name == "citation_patterns":
                continue
            mod = importlib.import_module(f"extract.{info.name}")
            fn = getattr(mod, "find_candidate_links", None)
            if fn is None:
                continue
            for self_c in (None, SELF):
                r[f"{info.name}[{self_c}]"] = _ser(fn(text, self_c))
        out[name] = r
    return out
