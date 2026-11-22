"""render.bulk_translate: checkpointed per-language JSONL translation run.
Backends are replaced by fakes; sleeps are recorded, not executed."""
import json
import sqlite3
import sys
from pathlib import Path

import pytest

from render import bulk_translate as bt

SCHEMA = Path(__file__).parent.parent / "db" / "schema.sql"


@pytest.fixture
def dbfile(tmp_path):
    p = tmp_path / "g.db"
    c = sqlite3.connect(p)
    c.executescript(SCHEMA.read_text())
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('fin', 'Ministry of Finance')")
    for gid, date in (("c", "2025-03-01"), ("a", "2025-01-01"), ("b", "2025-02-01")):
        c.execute("INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, publish_date, "
                  "gsr_or_so, ministry_id) VALUES (?, 'S', ?, 2025, 'so-only', ?, 'S.O. 1(E)', 'fin')", (gid, gid, date))
    c.commit()
    c.close()
    return str(p)


@pytest.fixture
def sleeps(monkeypatch):
    s = []
    monkeypatch.setattr(bt.time, "sleep", lambda x: s.append(x))
    return s


def fake_backend(calls, fail_ids=()):
    def fn(record, lang, fields):
        calls.append((record["gazette_id"], lang, fields))
        if record["gazette_id"] in fail_ids:
            raise RuntimeError(f"boom {record['gazette_id']}")
        return {"gazette_id": record["gazette_id"], "lang": lang, "summary": f"tr-{record['gazette_id']}",
                "summary_en": record["summary"]}
    return fn


def lines(path):
    return [json.loads(l) for l in Path(path).read_text(encoding="utf-8").splitlines() if l.strip()]


# --------------------------------------------------------------- helpers

def test_constants():
    assert bt.TOP_LANGUAGES == ["hi", "bn", "mr", "te", "ta", "gu", "kn", "ml", "pa"]
    assert bt.FIELDS == ("summary",)
    assert set(bt.TOP_LANGUAGES) == set(bt.KRUTRIM_CODES)  # every language krutrim supports
    assert set(bt.BACKEND_FNS) == {"krutrim", "libretranslate"}


def test_all_notifications_ordered_by_gazette_id_with_joined_names(dbfile):
    conn = sqlite3.connect(dbfile)
    rows = bt._all_notifications(conn)
    assert [r["gazette_id"] for r in rows] == ["a", "b", "c"]
    assert rows[0]["ministry_name"] == "Ministry of Finance" and rows[0]["instrument_title"] is None


def test_all_notifications_includes_archived_rows(dbfile):
    conn = sqlite3.connect(dbfile)
    conn.execute("UPDATE gazette_notification SET archived_at = 'x' WHERE gazette_id = 'a'")
    assert [r["gazette_id"] for r in bt._all_notifications(conn)] == ["a", "b", "c"]


def test_done_ids_missing_file_is_empty(tmp_path):
    assert bt._done_ids(tmp_path / "nope.jsonl") == set()


def test_done_ids_skips_blank_bad_json_and_keyless_lines(tmp_path):
    f = tmp_path / "x.jsonl"
    f.write_text('{"gazette_id": "a"}\n\n   \nnot json\n{"other": 1}\n{"gazette_id": "b"}\n', encoding="utf-8")
    assert bt._done_ids(f) == {"a", "b"}


# --------------------------------------------------------------- run()

def test_run_writes_one_line_per_record_with_summary_field_only(dbfile, tmp_path, monkeypatch, sleeps, capsys):
    calls = []
    monkeypatch.setitem(bt.BACKEND_FNS, "krutrim", fake_backend(calls))
    out = tmp_path / "out" / "nested"
    bt.run(dbfile, str(out), ["hi"], 0.0, "krutrim")
    assert [c[0] for c in calls] == ["a", "b", "c"]
    assert all(c[1] == "hi" and c[2] == ("summary",) for c in calls)
    got = lines(out / "hi.jsonl")
    assert [g["gazette_id"] for g in got] == ["a", "b", "c"] and got[0]["summary"] == "tr-a"
    assert (out / "hi.failed.jsonl").read_text() == ""
    log = capsys.readouterr().out.splitlines()
    assert log[0] == "[hi] Hindi (krutrim): 0 already done, 3 remaining"
    assert log[-2] == "[hi] 3/3" and log[-1] == "done"
    assert sleeps == []  # delay 0 => never sleeps


def test_run_resumes_skipping_checkpointed_ids(dbfile, tmp_path, monkeypatch, sleeps, capsys):
    calls = []
    monkeypatch.setitem(bt.BACKEND_FNS, "krutrim", fake_backend(calls))
    out = tmp_path / "o"
    out.mkdir()
    (out / "hi.jsonl").write_text(json.dumps({"gazette_id": "b", "summary": "old"}) + "\n", encoding="utf-8")
    bt.run(dbfile, str(out), ["hi"], 0.0, "krutrim")
    assert [c[0] for c in calls] == ["a", "c"]
    got = lines(out / "hi.jsonl")
    assert [g["gazette_id"] for g in got] == ["b", "a", "c"]  # appended, existing line preserved
    assert got[0]["summary"] == "old"
    assert "[hi] Hindi (krutrim): 1 already done, 2 remaining" in capsys.readouterr().out


def test_run_failure_logged_and_run_continues(dbfile, tmp_path, monkeypatch, sleeps, capsys):
    calls = []
    monkeypatch.setitem(bt.BACKEND_FNS, "krutrim", fake_backend(calls, fail_ids={"b"}))
    out = tmp_path / "o"
    bt.run(dbfile, str(out), ["hi"], 0.0, "krutrim")
    assert [c[0] for c in calls] == ["a", "b", "c"]
    assert [g["gazette_id"] for g in lines(out / "hi.jsonl")] == ["a", "c"]
    assert lines(out / "hi.failed.jsonl") == [{"gazette_id": "b", "error": "boom b"}]
    assert "[hi] FAILED b: boom b" in capsys.readouterr().out


def test_run_failed_record_is_retried_on_next_run(dbfile, tmp_path, monkeypatch, sleeps):
    out = tmp_path / "o"
    calls = []
    monkeypatch.setitem(bt.BACKEND_FNS, "krutrim", fake_backend(calls, fail_ids={"b"}))
    bt.run(dbfile, str(out), ["hi"], 0.0, "krutrim")
    calls.clear()
    monkeypatch.setitem(bt.BACKEND_FNS, "krutrim", fake_backend(calls))
    bt.run(dbfile, str(out), ["hi"], 0.0, "krutrim")
    assert [c[0] for c in calls] == ["b"]


def test_run_progress_every_25_and_at_end(dbfile, tmp_path, monkeypatch, sleeps, capsys):
    conn = sqlite3.connect(dbfile)
    for i in range(30):
        conn.execute("INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, publish_date) "
                     "VALUES (?, 'S', 'n', 2025, 'so-only', '2025-01-01')", (f"z{i:02d}",))
    conn.commit()
    conn.close()
    monkeypatch.setitem(bt.BACKEND_FNS, "krutrim", fake_backend([]))
    bt.run(dbfile, str(tmp_path / "o"), ["hi"], 0.0, "krutrim")
    progress = [l for l in capsys.readouterr().out.splitlines() if l.startswith("[hi] ") and "/" in l]
    assert progress == ["[hi] 25/33", "[hi] 33/33"]


def test_run_delay_applied_after_every_record_including_failures(dbfile, tmp_path, monkeypatch, sleeps):
    monkeypatch.setitem(bt.BACKEND_FNS, "krutrim", fake_backend([], fail_ids={"a"}))
    bt.run(dbfile, str(tmp_path / "o"), ["hi"], 1.5, "krutrim")
    assert sleeps == [1.5, 1.5, 1.5]


def test_run_multiple_languages_get_separate_files(dbfile, tmp_path, monkeypatch, sleeps):
    calls = []
    monkeypatch.setitem(bt.BACKEND_FNS, "krutrim", fake_backend(calls))
    out = tmp_path / "o"
    bt.run(dbfile, str(out), ["hi", "bn"], 0.0, "krutrim")
    assert (out / "hi.jsonl").exists() and (out / "bn.jsonl").exists()
    assert [(c[0], c[1]) for c in calls] == [(g, l) for l in ("hi", "bn") for g in "abc"]


def test_run_gemini_backend_falls_through_to_translate_record(dbfile, tmp_path, monkeypatch, sleeps):
    seen = []

    def fake_tr(record, lang, fields):
        seen.append((record["gazette_id"], lang, fields))
        return {"gazette_id": record["gazette_id"], "summary": "g"}

    monkeypatch.setattr(bt, "translate_record", fake_tr)
    bt.run(dbfile, str(tmp_path / "o"), ["fr"], 0.0, "gemini")
    assert seen == [(g, "fr", ("summary",)) for g in "abc"]


def test_run_unicode_is_written_unescaped(dbfile, tmp_path, monkeypatch, sleeps):
    monkeypatch.setitem(bt.BACKEND_FNS, "krutrim", lambda record, lang, fields: {"gazette_id": record["gazette_id"], "summary": "नमस्ते"})
    out = tmp_path / "o"
    bt.run(dbfile, str(out), ["hi"], 0.0, "krutrim")
    assert "नमस्ते" in (out / "hi.jsonl").read_text(encoding="utf-8")


def test_run_records_are_built_before_connection_closed(dbfile, tmp_path, monkeypatch, sleeps):
    seen = []
    monkeypatch.setitem(bt.BACKEND_FNS, "krutrim", lambda record, lang, fields: seen.append(record["summary"]) or {"gazette_id": record["gazette_id"]})
    bt.run(dbfile, str(tmp_path / "o"), ["hi"], 0.0, "krutrim")
    assert seen[0] == "Ministry of Finance a (S.O. 1(E), 2025-01-01) has no recorded cross-references."


# --------------------------------------------------------------- main()

def _main(monkeypatch, argv):
    monkeypatch.setattr(sys, "argv", ["bulk_translate", *argv])
    bt.main()


@pytest.fixture
def run_spy(monkeypatch):
    seen = []
    monkeypatch.setattr(bt, "run", lambda db, out, langs, delay, backend: seen.append((db, out, langs, delay, backend)))
    return seen


def test_main_defaults(monkeypatch, run_spy):
    _main(monkeypatch, [])
    assert run_spy == [("gazette.db", "data/translations", bt.TOP_LANGUAGES, 1.5, "gemini")]


@pytest.mark.parametrize("backend,delay", [("krutrim", 0.0), ("libretranslate", 0.0), ("gemini", 1.5)])
def test_main_default_delay_depends_on_backend(monkeypatch, run_spy, backend, delay):
    _main(monkeypatch, ["--backend", backend, "--langs", "hi"])
    assert run_spy[0][3] == delay


def test_main_explicit_zero_delay_is_respected_for_gemini(monkeypatch, run_spy):
    _main(monkeypatch, ["--delay", "0", "--langs", "hi"])
    assert run_spy[0][3] == 0.0


def test_main_langs_are_stripped_and_blanks_dropped(monkeypatch, run_spy):
    _main(monkeypatch, ["--langs", " hi , bn,, ", "--backend", "krutrim", "--db", "d.db", "--out", "o"])
    assert run_spy == [("d.db", "o", ["hi", "bn"], 0.0, "krutrim")]


@pytest.mark.parametrize("backend,lang", [("krutrim", "fr"), ("libretranslate", "mr"), ("gemini", "xx")])
def test_main_rejects_language_unsupported_by_backend(monkeypatch, run_spy, capsys, backend, lang):
    with pytest.raises(SystemExit) as ei:
        _main(monkeypatch, ["--backend", backend, "--langs", f"hi,{lang}" if backend != "libretranslate" else f"fr,{lang}"])
    assert ei.value.code == 2
    assert f"unsupported language code {lang!r} for --backend {backend}" in capsys.readouterr().err
    assert run_spy == []


def test_main_gemini_accepts_any_supported_language(monkeypatch, run_spy):
    _main(monkeypatch, ["--langs", "si,or,fr"])
    assert run_spy[0][2] == ["si", "or", "fr"]
