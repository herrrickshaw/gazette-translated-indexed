"""Structural tests for render/translate.py that don't call the network --
the language-priority lists and translate_record's argument validation."""
from render.translate import (
    INDIAN_LANGUAGES,
    FOREIGN_LANGUAGES,
    SUPPORTED_LANGUAGES,
    LIBRETRANSLATE_CODES,
    translate_record,
    translate_record_libretranslate,
)


def test_all_22_eighth_schedule_languages_present():
    # The actual constitutional list, not a "major languages" shortlist.
    expected = {
        "as", "bn", "brx", "doi", "gu", "hi", "kn", "ks", "kok", "mai", "ml",
        "mni", "mr", "ne", "or", "pa", "sa", "sat", "sd", "ta", "te", "ur",
    }
    assert set(INDIAN_LANGUAGES) == expected
    assert len(INDIAN_LANGUAGES) == 22


def test_no_overlap_between_indian_and_foreign_lists():
    assert set(INDIAN_LANGUAGES) & set(FOREIGN_LANGUAGES) == set()


def test_supported_languages_is_the_union():
    assert SUPPORTED_LANGUAGES == {**INDIAN_LANGUAGES, **FOREIGN_LANGUAGES}


def test_translate_record_requires_exactly_one_of_lang_or_lang_name():
    record = {"gazette_id": "x", "summary": "test"}
    try:
        translate_record(record)
        assert False, "should have raised with neither lang nor lang_name"
    except ValueError:
        pass
    try:
        translate_record(record, lang="hi", lang_name="Hindi")
        assert False, "should have raised with both lang and lang_name"
    except ValueError:
        pass


def test_translate_record_rejects_unknown_language_code():
    record = {"gazette_id": "x", "summary": "test"}
    try:
        translate_record(record, lang="xx")
        assert False, "should have raised for an unknown language code"
    except ValueError as e:
        assert "xx" in str(e)


def test_libretranslate_codes_are_a_subset_of_supported_languages():
    # confirmed live against Argos Translate's own package index: only 3 of
    # 22 INDIAN_LANGUAGES and 8 of 11 FOREIGN_LANGUAGES actually have an
    # en-> Argos model, so this must be a strict subset, not equal to either.
    assert set(LIBRETRANSLATE_CODES) <= set(SUPPORTED_LANGUAGES)
    assert LIBRETRANSLATE_CODES == {"bn", "hi", "ur", "fr", "es", "ar", "zh", "ru", "pt", "de", "ja"}


def test_translate_record_libretranslate_rejects_unsupported_language():
    record = {"gazette_id": "x", "summary": "test"}
    try:
        translate_record_libretranslate(record, lang="mr", url="http://example.invalid")
        assert False, "should have raised for a language with no Argos model (Marathi)"
    except ValueError as e:
        assert "mr" in str(e)
