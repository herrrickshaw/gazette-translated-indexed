"""render.query_translation: cache read/merge/upsert and on-demand fill. The
translation backends are replaced with fakes (no network)."""
import json
import sqlite3
import sys
from pathlib import Path

import pytest

from render import query_translation as qt

SCHEMA = Path(__file__).parent.parent / "db" / "schema.sql"


@pytest.fixture
def conn():
    c = sqlite3.connect(":memory:")
    c.execute("PRAGMA foreign_keys = ON")
    c.executescript(SCHEMA.read_text())
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('fin', 'Ministry of Finance')")
    c.execute("INSERT INTO act_or_rule (instrument_id, title) VALUES ('ca', 'Customs Act')")
    c.execute("INSERT INTO subject_thread (thread_id, subject_summary) VALUES ('t', 'Duty')")
    c.execute("INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, "
              "ministry_id, instrument_id, thread_id) VALUES ('cus-45', 'Customs', '45/2025', 2025, '4-digit-year', "
              "'2025-10-24', 'G.S.R. 781(E)', 'fin', 'ca', 't')")
    c.execute("INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, publish_date) "
              "VALUES ('bare', 'Bare', '1', 2025, 'so-only', '2025-01-01')")
    yield c
    c.close()


class FakeBackend:
    def __init__(self):
        self.calls = []

    def __call__(self, record, lang, fields):
        self.calls.append((lang, fields))
        out = dict(record)
        for f in fields:
            out[f] = f"{lang}:{record[f]}"
        return out


@pytest.fixture
def fake(monkeypatch):
    fb = FakeBackend()
    for name in list(qt.BACKEND_FNS):
        monkeypatch.setitem(qt.BACKEND_FNS, name, fb)
    return fb


def test_now_is_utc_iso_seconds():
    s = qt._now()
    assert s.endswith("+00:00") and "." not in s


# ------------------------------------------------------------ cache primitives

def test_get_cached_translation_miss_then_hit(conn):
    assert qt.get_cached_translation(conn, "cus-45", "hi") is None
    qt.upsert_translation(conn, "cus-45", "hi", {"summary": "S"}, "krutrim")
    row = qt.get_cached_translation(conn, "cus-45", "hi")
    assert row["summary"] == "S" and row["backend"] == "krutrim" and row["ministry"] is None
    assert qt.get_cached_translation(conn, "cus-45", "bn") is None  # other language
    assert qt.get_cached_translation(conn, "bare", "hi") is None  # other notification


def test_list_cached_languages_sorted_and_scoped(conn):
    for lang in ("ta", "hi", "bn"):
        qt.upsert_translation(conn, "cus-45", lang, {"summary": "x"}, "b")
    qt.upsert_translation(conn, "bare", "mr", {"summary": "x"}, "b")
    assert qt.list_cached_languages(conn, "cus-45") == ["bn", "hi", "ta"]
    assert qt.list_cached_languages(conn, "nope") == []


def test_upsert_merges_fields_instead_of_overwriting_siblings(conn):
    qt.upsert_translation(conn, "cus-45", "hi", {"ministry": "M1", "summary": "S1"}, "krutrim")
    qt.upsert_translation(conn, "cus-45", "hi", {"summary": "S2", "thread": "T"}, "libretranslate")
    row = qt.get_cached_translation(conn, "cus-45", "hi")
    assert (row["ministry"], row["summary"], row["thread"], row["instrument"]) == ("M1", "S2", "T", None)
    assert row["backend"] == "libretranslate"  # records whichever backend wrote last
    assert conn.execute("SELECT COUNT(*) FROM notification_translation").fetchone()[0] == 1


def test_upsert_commits_and_stamps_time(conn):
    qt.upsert_translation(conn, "cus-45", "hi", {"summary": "S"}, "b")
    assert conn.in_transaction is False
    assert qt.get_cached_translation(conn, "cus-45", "hi")["translated_at"].endswith("+00:00")


def test_upsert_unknown_notification_violates_fk(conn):
    with pytest.raises(sqlite3.IntegrityError):
        qt.upsert_translation(conn, "ghost", "hi", {"summary": "S"}, "b")


# ------------------------------------------------------------ record + split

def test_fetch_record_for_query_missing_raises_lookup_error(conn):
    with pytest.raises(LookupError, match="no notification found for gazette_id 'nope'"):
        qt._fetch_record_for_query(conn, "nope")


def test_fetch_record_for_query_returns_build_record(conn):
    rec = qt._fetch_record_for_query(conn, "cus-45")
    assert rec["ministry"] == "Ministry of Finance" and rec["instrument"] == "Customs Act" and rec["thread"] == "Duty"
    assert rec["summary"].startswith("Ministry of Finance 45/2025")


def test_split_cached_and_missing_basic():
    rec = {"ministry": "M", "instrument": None, "thread": "T", "summary": "S", "gazette_id": "g"}
    out, missing = qt._split_cached_and_missing(rec, {"ministry": "M-hi", "thread": ""}, "hi", qt.TRANSLATABLE_FIELDS)
    assert out["lang"] == "hi" and out["gazette_id"] == "g"
    assert out["ministry"] == "M-hi" and out["ministry_en"] == "M"          # cached: swapped in
    assert out["thread"] == "T" and out["thread_en"] == "T"                 # empty cached string counts as missing
    assert out["summary"] == "S" and out["summary_en"] == "S"
    assert "instrument_en" not in out                                       # empty source skipped entirely
    assert missing == ["thread", "summary"]


def test_split_respects_narrowed_fields():
    rec = {"ministry": "M", "summary": "S"}
    out, missing = qt._split_cached_and_missing(rec, {}, "hi", ("summary",))
    assert missing == ["summary"] and "ministry_en" not in out and out["ministry"] == "M"


def test_split_does_not_mutate_input():
    rec = {"summary": "S"}
    qt._split_cached_and_missing(rec, {"summary": "X"}, "hi", ("summary",))
    assert rec == {"summary": "S"}


# ------------------------------------------------------------ fill

def test_fill_and_cache_uses_resolved_backend_and_persists_only_nonempty(conn, monkeypatch):
    seen = []

    def backend(record, lang, fields):
        seen.append(fields)
        return {"summary": "S-hi", "thread": ""}

    monkeypatch.setitem(qt.BACKEND_FNS, "krutrim", backend)
    new = qt._fill_and_cache(conn, "cus-45", "hi", {"summary": "S", "thread": "T"}, ["summary", "thread"], None)
    assert new == {"summary": "S-hi"}
    assert seen == [("summary", "thread")]  # tuple of exactly the missing fields
    row = qt.get_cached_translation(conn, "cus-45", "hi")
    assert row["summary"] == "S-hi" and row["thread"] is None and row["backend"] == "krutrim"


def test_fill_and_cache_explicit_backend_overrides_resolution(conn, monkeypatch):
    monkeypatch.setitem(qt.BACKEND_FNS, "gemini", lambda record, lang, fields: {"summary": "G"})
    monkeypatch.setitem(qt.BACKEND_FNS, "krutrim", lambda *a, **k: pytest.fail("must not use krutrim"))
    qt._fill_and_cache(conn, "cus-45", "hi", {"summary": "S"}, ["summary"], "gemini")
    assert qt.get_cached_translation(conn, "cus-45", "hi")["backend"] == "gemini"


def test_fill_and_cache_nothing_new_writes_nothing(conn, monkeypatch):
    monkeypatch.setitem(qt.BACKEND_FNS, "krutrim", lambda record, lang, fields: {})
    assert qt._fill_and_cache(conn, "cus-45", "hi", {"summary": "S"}, ["summary"], None) == {}
    assert conn.execute("SELECT COUNT(*) FROM notification_translation").fetchone()[0] == 0


# ------------------------------------------------------------ get_translation

def test_get_translation_rejects_unsupported_language(conn):
    with pytest.raises(ValueError, match="unsupported language code 'xx'"):
        qt.get_translation(conn, "cus-45", "xx")


def test_get_translation_unknown_notification(conn, fake):
    with pytest.raises(LookupError):
        qt.get_translation(conn, "nope", "hi")


def test_get_translation_cold_cache_fills_all_fields_and_marks_live(conn, fake):
    out = qt.get_translation(conn, "cus-45", "hi")
    assert fake.calls == [("hi", ("ministry", "instrument", "thread", "summary"))]
    assert out["ministry"] == "hi:Ministry of Finance" and out["ministry_en"] == "Ministry of Finance"
    assert out["_translated_live"] == ["instrument", "ministry", "summary", "thread"]  # sorted
    assert "_not_cached" not in out and out["lang"] == "hi"
    # a second call is served entirely from cache
    fake.calls.clear()
    again = qt.get_translation(conn, "cus-45", "hi")
    assert fake.calls == [] and "_translated_live" not in again
    assert again["ministry"] == "hi:Ministry of Finance"


def test_get_translation_partial_cache_only_translates_missing(conn, fake):
    qt.upsert_translation(conn, "cus-45", "hi", {"ministry": "CACHED-M", "thread": "CACHED-T"}, "krutrim")
    out = qt.get_translation(conn, "cus-45", "hi")
    assert fake.calls == [("hi", ("instrument", "summary"))]
    assert out["ministry"] == "CACHED-M" and out["thread"] == "CACHED-T"
    assert out["_translated_live"] == ["instrument", "summary"]
    row = qt.get_cached_translation(conn, "cus-45", "hi")
    assert row["ministry"] == "CACHED-M" and row["instrument"] == "hi:Customs Act"


def test_get_translation_no_fill_reports_not_cached_and_never_calls_backend(conn, fake):
    qt.upsert_translation(conn, "cus-45", "hi", {"ministry": "CACHED-M"}, "krutrim")
    out = qt.get_translation(conn, "cus-45", "hi", fill_missing=False)
    assert fake.calls == []
    assert out["_not_cached"] == ["instrument", "thread", "summary"]
    assert out["ministry"] == "CACHED-M" and out["instrument"] == "Customs Act"  # untranslated English left in place
    assert "_translated_live" not in out
    assert conn.execute("SELECT COUNT(*) FROM notification_translation").fetchone()[0] == 1


def test_get_translation_fully_cached_has_no_markers_even_without_fill(conn, fake):
    qt.upsert_translation(conn, "cus-45", "hi",
                          {"ministry": "a", "instrument": "b", "thread": "c", "summary": "d"}, "krutrim")
    out = qt.get_translation(conn, "cus-45", "hi", fill_missing=False)
    assert "_not_cached" not in out and "_translated_live" not in out


def test_get_translation_skips_empty_source_fields(conn, fake):
    out = qt.get_translation(conn, "bare", "hi")  # no ministry/instrument/thread linked
    assert fake.calls == [("hi", ("summary",))]
    assert "ministry_en" not in out and out["_translated_live"] == ["summary"]


def test_get_translation_narrowed_fields_and_backend_override(conn, monkeypatch):
    seen = []
    monkeypatch.setitem(qt.BACKEND_FNS, "libretranslate",
                        lambda record, lang, fields: seen.append(fields) or {"summary": "L"})
    out = qt.get_translation(conn, "cus-45", "fr", fields=("summary",), backend="libretranslate")
    assert seen == [("summary",)] and out["summary"] == "L"
    assert qt.get_cached_translation(conn, "cus-45", "fr")["backend"] == "libretranslate"


# ------------------------------------------------------------ CLI

@pytest.fixture
def dbfile(tmp_path, conn):
    p = tmp_path / "g.db"
    conn.commit()
    disk = sqlite3.connect(p)
    conn.backup(disk)
    disk.close()
    return str(p)


def _main(monkeypatch, argv):
    monkeypatch.setattr(sys, "argv", ["query_translation", *argv])
    qt.main()


@pytest.mark.parametrize("argv,msg", [
    ([], "pass --gazette-id, or both --series and --number"),
    (["--series", "Customs"], "pass --gazette-id, or both --series and --number"),
    (["--number", "45/2025"], "pass --gazette-id, or both --series and --number"),
    (["--gazette-id", "cus-45"], "--lang is required unless --languages"),
])
def test_main_argument_validation(monkeypatch, capsys, argv, msg):
    with pytest.raises(SystemExit) as ei:
        _main(monkeypatch, argv)
    assert ei.value.code == 2
    assert msg in capsys.readouterr().err


def test_main_by_gazette_id_prints_json(monkeypatch, dbfile, fake, capsys):
    _main(monkeypatch, ["--gazette-id", "cus-45", "--lang", "hi", "--db", dbfile])
    data = json.loads(capsys.readouterr().out)
    assert data["gazette_id"] == "cus-45" and data["lang"] == "hi" and data["summary"].startswith("hi:")


def test_main_by_series_and_number(monkeypatch, dbfile, fake, capsys):
    _main(monkeypatch, ["--series", "customs", "--number", "45/2025", "--lang", "hi", "--db", dbfile])
    assert json.loads(capsys.readouterr().out)["gazette_id"] == "cus-45"


def test_main_no_fill_flag_does_not_translate(monkeypatch, dbfile, fake, capsys):
    _main(monkeypatch, ["--gazette-id", "cus-45", "--lang", "hi", "--no-fill", "--db", dbfile])
    data = json.loads(capsys.readouterr().out)
    assert fake.calls == [] and data["_not_cached"] == ["ministry", "instrument", "thread", "summary"]


def test_main_backend_flag_forces_backend(monkeypatch, dbfile, capsys):
    seen = []
    monkeypatch.setitem(qt.BACKEND_FNS, "gemini", lambda record, lang, fields: seen.append("gemini") or {f: "g" for f in fields})
    _main(monkeypatch, ["--gazette-id", "cus-45", "--lang", "hi", "--backend", "gemini", "--db", dbfile])
    assert seen == ["gemini"]


def test_main_unknown_ids_exit_with_identifier(monkeypatch, dbfile):
    with pytest.raises(SystemExit, match="no notification found for gazette_id 'nope'"):
        _main(monkeypatch, ["--gazette-id", "nope", "--lang", "hi", "--db", dbfile])
    with pytest.raises(SystemExit, match="no notification found for 'Customs' '99/9999'"):
        _main(monkeypatch, ["--series", "Customs", "--number", "99/9999", "--lang", "hi", "--db", dbfile])


def test_main_languages_lists_cache_without_translating(monkeypatch, dbfile, fake, capsys):
    c = sqlite3.connect(dbfile)
    qt.upsert_translation(c, "cus-45", "ta", {"summary": "x"}, "b")
    qt.upsert_translation(c, "cus-45", "hi", {"summary": "x"}, "b")
    c.close()
    _main(monkeypatch, ["--gazette-id", "cus-45", "--languages", "--db", dbfile])
    out = capsys.readouterr().out.splitlines()
    assert out[0] == "gazette_id: cus-45"
    assert out[1] == "cached languages (2): hi, ta"
    assert out[2] == f"any of the {len(qt.SUPPORTED_LANGUAGES)} SUPPORTED_LANGUAGES can still be requested live with --lang"
    assert fake.calls == []


def test_main_languages_with_none_cached(monkeypatch, dbfile, capsys):
    _main(monkeypatch, ["--gazette-id", "cus-45", "--languages", "--db", dbfile])
    assert "cached languages (0): (none yet)" in capsys.readouterr().out
