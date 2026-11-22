"""render.translate: credential/model resolution, backend status probes, the
language listing, record fetch, dispatch and the CLI. urlopen is faked."""
import io
import json
import sqlite3
import sys
import urllib.error
from pathlib import Path

import pytest

from render import translate as T

SCHEMA = Path(__file__).parent.parent / "db" / "schema.sql"


class Resp(io.BytesIO):
    def __enter__(self):
        return self

    def __exit__(self, *a):
        return False


@pytest.fixture
def creds(monkeypatch):
    store = {}
    monkeypatch.setattr(T, "_read_credential", lambda name: store.get(name))
    return store


@pytest.fixture
def probe(monkeypatch):
    state = {"calls": [], "raise": None}

    def fake_urlopen(url, timeout=None):
        state["calls"].append((url, timeout))
        if state["raise"]:
            raise state["raise"]
        return Resp(b"{}")

    monkeypatch.setattr(T.urllib.request, "urlopen", fake_urlopen)
    return state


# ----------------------------------------------------------- translate_record

def _capture_gemini(monkeypatch):
    calls = []
    monkeypatch.setattr(T, "_translate_text", lambda text, lang_name, key, model: calls.append((text, lang_name, key, model)) or f"<{text}>")
    return calls


def test_translate_record_without_any_key_exits(creds):
    with pytest.raises(SystemExit, match="GEMINI_API_KEY not found"):
        T.translate_record({"summary": "s"}, lang="hi")


def test_translate_record_uses_credential_store_key_and_default_model(creds, monkeypatch):
    creds["GEMINI_API_KEY"] = "stored-key"
    creds["GEMINI_MODEL"] = "pinned-free-tier-model"  # must be ignored on purpose
    calls = _capture_gemini(monkeypatch)
    out = T.translate_record({"gazette_id": "g", "summary": "hello"}, lang="hi", fields=("summary",))
    assert calls == [("hello", "Hindi", "stored-key", "gemini-flash-latest")]
    assert out["summary"] == "<hello>" and out["summary_en"] == "hello" and out["lang"] == "hi"


def test_translate_record_explicit_key_and_model_win(creds, monkeypatch):
    creds["GEMINI_API_KEY"] = "stored"
    calls = _capture_gemini(monkeypatch)
    T.translate_record({"summary": "x"}, lang="fr", api_key="mine", model="m2", fields=("summary",))
    assert calls == [("x", "French", "mine", "m2")]


def test_translate_record_lang_name_free_text_is_used_as_label(creds, monkeypatch):
    calls = _capture_gemini(monkeypatch)
    out = T.translate_record({"summary": "x"}, lang_name="Swahili", api_key="k", fields=("summary",))
    assert calls[0][1] == "Swahili" and out["lang"] == "Swahili"


def test_translate_record_default_fields_cover_all_four(creds, monkeypatch):
    calls = _capture_gemini(monkeypatch)
    rec = {"ministry": "M", "instrument": "I", "thread": "T", "summary": "S", "gazette_id": "g", "year": 2025}
    out = T.translate_record(rec, lang="hi", api_key="k")
    assert [c[0] for c in calls] == ["M", "I", "T", "S"]
    assert out["gazette_id"] == "g" and out["year"] == 2025  # non-text fields untouched
    assert T.TRANSLATABLE_FIELDS == ("ministry", "instrument", "thread", "summary")


def test_translate_record_none_and_empty_fields_skipped_and_input_not_mutated(creds, monkeypatch):
    calls = _capture_gemini(monkeypatch)
    rec = {"ministry": None, "instrument": "", "summary": "S"}
    out = T.translate_record(rec, lang="hi", api_key="k")
    assert [c[0] for c in calls] == ["S"]
    assert "ministry_en" not in out and "instrument_en" not in out
    assert rec == {"ministry": None, "instrument": "", "summary": "S"}


def test_translate_record_neither_or_both_lang_args_rejected(creds):
    with pytest.raises(ValueError, match="exactly one"):
        T.translate_record({}, api_key="k")
    with pytest.raises(ValueError, match="exactly one"):
        T.translate_record({}, lang="hi", lang_name="Hindi", api_key="k")


def test_unsupported_code_error_lists_choices_and_hints_lang_name(creds):
    with pytest.raises(ValueError, match=r"unsupported language code 'xx'.*lang_name="):
        T.translate_record({}, lang="xx", api_key="k")


# ----------------------------------------------------------- status probes

def test_libretranslate_status_ready_uses_default_url_and_timeout(creds, probe):
    assert T.libretranslate_status() == "ready"
    assert probe["calls"] == [("http://127.0.0.1:5001/languages", 5.0)]


def test_libretranslate_status_uses_credential_url_and_strips_trailing_slash(creds, probe):
    creds["LIBRETRANSLATE_URL"] = "http://lt.example:9/"
    T.libretranslate_status(timeout=1.5)
    assert probe["calls"] == [("http://lt.example:9/languages", 1.5)]


def test_libretranslate_status_down_on_any_error(creds, probe):
    probe["raise"] = urllib.error.URLError("refused")
    assert T.libretranslate_status() == "endpoint_down"
    probe["raise"] = RuntimeError("weird")
    assert T.libretranslate_status() == "endpoint_down"


def test_krutrim_status_ready_default_url(creds, probe):
    assert T.krutrim_status() == "ready"
    assert probe["calls"] == [("http://127.0.0.1:5002/health", 5.0)]


def test_krutrim_status_credential_url_and_down(creds, probe):
    creds["KRUTRIM_URL"] = "https://k.example///"
    probe["raise"] = TimeoutError()
    assert T.krutrim_status(timeout=2) == "endpoint_down"
    assert probe["calls"][0] == ("https://k.example///".rstrip("/") + "/health", 2)


# ----------------------------------------------------------- backend dispatch

def test_resolve_backend_priority_boundaries():
    # krutrim wins for its codes even where libretranslate also covers them (bn, hi)
    assert T.resolve_backend("hi") == "krutrim" and T.resolve_backend("bn") == "krutrim"
    assert T.resolve_backend("ur") == "libretranslate"  # only libretranslate
    assert T.resolve_backend("fr") == "libretranslate"
    assert T.resolve_backend("or") == "gemini" and T.resolve_backend("si") == "gemini"
    with pytest.raises(ValueError, match="unsupported language code 'xx'"):
        T.resolve_backend("xx")


def test_translate_record_auto_calls_resolved_backend_with_lang_and_fields(monkeypatch):
    seen = []
    monkeypatch.setitem(T.BACKEND_FNS, "krutrim", lambda record, lang, fields: seen.append(("k", record, lang, fields)) or "K")
    monkeypatch.setitem(T.BACKEND_FNS, "gemini", lambda record, lang, fields: seen.append(("g", lang, fields)) or "G")
    assert T.translate_record_auto({"a": 1}, "hi", fields=("summary",)) == "K"
    assert T.translate_record_auto({"a": 1}, "si") == "G"
    assert seen == [("k", {"a": 1}, "hi", ("summary",)), ("g", "si", T.TRANSLATABLE_FIELDS)]


def test_backend_fns_table_maps_names_to_functions():
    assert T.BACKEND_FNS == {"krutrim": T.translate_record_krutrim,
                             "libretranslate": T.translate_record_libretranslate,
                             "gemini": T.translate_record}


# ----------------------------------------------------------- listing / fetch

def test_print_language_list_is_sorted_by_name_with_both_sections(capsys):
    T._print_language_list()
    out = capsys.readouterr().out.splitlines()
    assert out[0] == "Indian languages (Eighth Schedule, priority 1):"
    ind = out[1:1 + len(T.INDIAN_LANGUAGES)]
    assert ind[0] == "  as    Assamese"
    names = [line.split(None, 1)[1] for line in ind]
    assert names == sorted(names)
    assert "Foreign languages (priority 2):" in out
    foreign = out[out.index("Foreign languages (priority 2):") + 1:][:len(T.FOREIGN_LANGUAGES)]
    assert [l.split(None, 1)[1] for l in foreign] == sorted(T.FOREIGN_LANGUAGES.values())
    assert out[-1] == 'Any other language: pass --lang-name "<language>" instead of --lang'


@pytest.fixture
def dbfile(tmp_path):
    p = tmp_path / "g.db"
    c = sqlite3.connect(p)
    c.executescript(SCHEMA.read_text())
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('fin', 'Ministry of Finance')")
    c.execute("INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id) "
              "VALUES ('cus-45', 'Customs', '45/2025', 2025, '4-digit-year', '2025-10-24', 'G.S.R. 781(E)', 'fin')")
    c.commit()
    c.close()
    return str(p)


def test_fetch_record_returns_built_record(dbfile):
    conn = sqlite3.connect(dbfile)
    rec = T._fetch_record(conn, "cus-45")
    assert rec["gazette_id"] == "cus-45" and rec["ministry"] == "Ministry of Finance"
    assert rec["summary"].startswith("Ministry of Finance 45/2025 (G.S.R. 781(E), 2025-10-24)")


def test_fetch_record_missing_exits_with_id(dbfile):
    with pytest.raises(SystemExit, match="no notification found for gazette_id 'nope'"):
        T._fetch_record(sqlite3.connect(dbfile), "nope")


class Args:
    def __init__(self, backend="gemini", lang=None, lang_name=None):
        self.backend, self.lang, self.lang_name = backend, lang, lang_name


@pytest.mark.parametrize("backend", ["krutrim", "libretranslate"])
def test_dispatch_selfhosted_backends_get_lang_only(backend, monkeypatch):
    seen = []
    monkeypatch.setitem(T.BACKEND_FNS, backend, lambda record, lang: seen.append((record, lang)) or "R")
    assert T._dispatch({"r": 1}, Args(backend, lang="hi")) == "R"
    assert seen == [({"r": 1}, "hi")]


def test_dispatch_gemini_passes_both_lang_and_lang_name(monkeypatch):
    seen = []
    monkeypatch.setattr(T, "translate_record", lambda record, lang, lang_name: seen.append((lang, lang_name)) or "G")
    assert T._dispatch({}, Args("gemini", lang="hi")) == "G"
    assert T._dispatch({}, Args("gemini", lang_name="Swahili")) == "G"
    assert seen == [("hi", None), (None, "Swahili")]


# ----------------------------------------------------------- CLI

def _main(monkeypatch, argv):
    monkeypatch.setattr(sys, "argv", ["translate", *argv])
    return T.main()


def test_main_list_languages_needs_no_id(monkeypatch, capsys):
    _main(monkeypatch, ["--list-languages"])
    assert "Indian languages (Eighth Schedule, priority 1):" in capsys.readouterr().out


@pytest.mark.parametrize("argv", [["cus-45"], ["--lang", "hi"], ["--lang-name", "Swahili"]])
def test_main_requires_id_and_a_language(monkeypatch, capsys, argv):
    with pytest.raises(SystemExit) as ei:
        _main(monkeypatch, argv)
    assert ei.value.code == 2
    assert "gazette_id and one of --lang/--lang-name are required unless --list-languages" in capsys.readouterr().err


@pytest.mark.parametrize("backend", ["krutrim", "libretranslate"])
def test_main_selfhosted_backend_rejects_lang_name(monkeypatch, capsys, backend):
    with pytest.raises(SystemExit) as ei:
        _main(monkeypatch, ["cus-45", "--lang-name", "Swahili", "--backend", backend])
    assert ei.value.code == 2
    assert f"--backend {backend} requires --lang, not --lang-name" in capsys.readouterr().err


def test_main_lang_and_lang_name_are_mutually_exclusive(monkeypatch):
    with pytest.raises(SystemExit) as ei:
        _main(monkeypatch, ["cus-45", "--lang", "hi", "--lang-name", "Hindi"])
    assert ei.value.code == 2


def test_main_rejects_unknown_lang_code(monkeypatch):
    with pytest.raises(SystemExit) as ei:
        _main(monkeypatch, ["cus-45", "--lang", "xx"])
    assert ei.value.code == 2


def test_main_prints_translated_json_unescaped(monkeypatch, dbfile, capsys):
    seen = []

    def fake_dispatch(record, args):
        seen.append((record["gazette_id"], args.backend, args.lang))
        return {"gazette_id": record["gazette_id"], "summary": "नमस्ते"}

    monkeypatch.setattr(T, "_dispatch", fake_dispatch)
    _main(monkeypatch, ["cus-45", "--lang", "hi", "--db", dbfile])
    out = capsys.readouterr().out
    assert seen == [("cus-45", "gemini", "hi")]  # default backend
    assert json.loads(out) == {"gazette_id": "cus-45", "summary": "नमस्ते"}
    assert "नमस्ते" in out and out.startswith('{\n  "gazette_id"')  # indent=2, ensure_ascii=False


def test_main_unknown_gazette_id_exits(monkeypatch, dbfile):
    with pytest.raises(SystemExit, match="no notification found"):
        _main(monkeypatch, ["nope", "--lang", "hi", "--db", dbfile])
