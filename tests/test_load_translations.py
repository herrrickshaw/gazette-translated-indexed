"""render.load_translations: JSONL -> notification_translation upsert loader."""
import json
import sqlite3
import sys
from pathlib import Path

import pytest

from render import load_translations as lt

SCHEMA = Path(__file__).parent.parent / "db" / "schema.sql"


@pytest.fixture
def conn():
    c = sqlite3.connect(":memory:")
    c.execute("PRAGMA foreign_keys = ON")
    c.executescript(SCHEMA.read_text())
    for gid in ("g1", "g2"):
        c.execute("INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, publish_date) "
                  "VALUES (?, 'S', ?, 2025, 'so-only', '2025-01-01')", (gid, gid))
    yield c
    c.close()


def write(path, lines):
    path.write_text("\n".join(l if isinstance(l, str) else json.dumps(l, ensure_ascii=False) for l in lines) + "\n",
                    encoding="utf-8")


def rows(conn):
    conn.row_factory = sqlite3.Row
    return {(r["gazette_id"], r["lang"]): dict(r) for r in conn.execute("SELECT * FROM notification_translation")}


def test_load_file_loads_valid_lines_and_counts_skips(conn, tmp_path):
    f = tmp_path / "hi.jsonl"
    write(f, [
        {"gazette_id": "g1", "summary": "नमस्ते", "summary_en": "hello"},
        "",                                                    # blank: neither loaded nor skipped
        "not json",                                            # skipped
        {"summary": "x", "summary_en": "y"},                   # no gazette_id: skipped
        {"gazette_id": "g2", "summary": "t"},                  # missing *_en original: skipped
        {"gazette_id": "g2", "summary": "", "summary_en": "e"},  # empty translation: skipped
        {"gazette_id": "g2", "ministry": "M-hi", "ministry_en": "M", "other": "z"},
    ])
    assert lt.load_file(conn, f, "hi", "krutrim") == (2, 4)
    got = rows(conn)
    assert got[("g1", "hi")]["summary"] == "नमस्ते" and got[("g1", "hi")]["backend"] == "krutrim"
    assert got[("g2", "hi")]["ministry"] == "M-hi" and got[("g2", "hi")]["summary"] is None


def test_load_file_only_translatable_fields_are_stored(conn, tmp_path):
    f = tmp_path / "hi.jsonl"
    write(f, [{"gazette_id": "g1", "summary": "S", "summary_en": "s", "thread": "T", "thread_en": "t",
               "gsr_or_so": "X", "gsr_or_so_en": "Y"}])
    lt.load_file(conn, f, "hi", "b")
    r = rows(conn)[("g1", "hi")]
    assert (r["summary"], r["thread"], r["ministry"], r["instrument"]) == ("S", "T", None, None)


def test_load_file_is_idempotent_and_merges_fields_across_runs(conn, tmp_path):
    f = tmp_path / "hi.jsonl"
    write(f, [{"gazette_id": "g1", "summary": "S1", "summary_en": "s"}])
    lt.load_file(conn, f, "hi", "krutrim")
    lt.load_file(conn, f, "hi", "krutrim")
    assert len(rows(conn)) == 1
    write(f, [{"gazette_id": "g1", "ministry": "M", "ministry_en": "m"}])
    lt.load_file(conn, f, "hi", "libretranslate")
    r = rows(conn)[("g1", "hi")]
    assert r["summary"] == "S1" and r["ministry"] == "M" and r["backend"] == "libretranslate"


def test_load_file_empty_file(conn, tmp_path):
    f = tmp_path / "hi.jsonl"
    f.write_text("")
    assert lt.load_file(conn, f, "hi", "b") == (0, 0)


def _main(monkeypatch, argv):
    monkeypatch.setattr(sys, "argv", ["load_translations", *argv])
    lt.main()


@pytest.fixture
def dbfile(tmp_path):
    p = tmp_path / "g.db"
    c = sqlite3.connect(p)
    c.executescript(SCHEMA.read_text())
    for gid in ("g1", "g2"):
        c.execute("INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, publish_date) "
                  "VALUES (?, 'S', ?, 2025, 'so-only', '2025-01-01')", (gid, gid))
    c.commit()
    c.close()
    return str(p)


def test_main_globs_dir_skipping_failed_logs_and_sorted(monkeypatch, tmp_path, dbfile, capsys):
    d = tmp_path / "tr"
    d.mkdir()
    write(d / "mr.jsonl", [{"gazette_id": "g1", "summary": "m", "summary_en": "s"}])
    write(d / "hi.jsonl", [{"gazette_id": "g1", "summary": "h", "summary_en": "s"}, "garbage"])
    write(d / "hi.failed.jsonl", [{"gazette_id": "g2", "error": "x"}])
    (d / "notes.txt").write_text("ignored")
    _main(monkeypatch, ["--db", dbfile, "--dir", str(d)])
    out = capsys.readouterr().out.splitlines()
    assert out[0] == f"[hi] loaded 1, skipped 1 (from {d / 'hi.jsonl'})"
    assert out[1] == f"[mr] loaded 1, skipped 0 (from {d / 'mr.jsonl'})"
    assert out[2] == "total: loaded 2, skipped 1"
    c = sqlite3.connect(dbfile)
    assert c.execute("SELECT lang, backend FROM notification_translation ORDER BY lang").fetchall() == [
        ("hi", "krutrim"), ("mr", "krutrim")]


def test_main_langs_filter_missing_file_and_backend_override(monkeypatch, tmp_path, dbfile, capsys):
    d = tmp_path / "tr"
    d.mkdir()
    write(d / "hi.jsonl", [{"gazette_id": "g1", "summary": "h", "summary_en": "s"}])
    write(d / "mr.jsonl", [{"gazette_id": "g2", "summary": "m", "summary_en": "s"}])
    _main(monkeypatch, ["--db", dbfile, "--dir", str(d), "--langs", "hi,ta,,", "--backend", "libretranslate"])
    out = capsys.readouterr().out.splitlines()
    assert out[0].startswith("[hi] loaded 1, skipped 0")
    assert out[1] == f"[ta] {d / 'ta.jsonl'} not found, skipping"
    assert out[2] == "total: loaded 1, skipped 0"
    c = sqlite3.connect(dbfile)
    assert c.execute("SELECT lang, backend FROM notification_translation").fetchall() == [("hi", "libretranslate")]


def test_main_no_files_prints_zero_totals(monkeypatch, tmp_path, dbfile, capsys):
    d = tmp_path / "empty"
    d.mkdir()
    _main(monkeypatch, ["--db", dbfile, "--dir", str(d)])
    assert capsys.readouterr().out == "total: loaded 0, skipped 0\n"


@pytest.mark.xfail(strict=True, raises=AssertionError,
                   reason="load_translations.py:61 builds the path from the unstripped code, so 'hi, ta' looks for ' ta.jsonl' "
                          "(bulk_translate.py strips each code; this module only strips for the emptiness check)")
def test_main_langs_with_spaces_after_commas_are_stripped(monkeypatch, tmp_path, dbfile, capsys):
    d = tmp_path / "tr"
    d.mkdir()
    write(d / "hi.jsonl", [{"gazette_id": "g1", "summary": "h", "summary_en": "s"}])
    write(d / "ta.jsonl", [{"gazette_id": "g1", "summary": "t", "summary_en": "s"}])
    _main(monkeypatch, ["--db", dbfile, "--dir", str(d), "--langs", "hi, ta"])
    assert capsys.readouterr().out.splitlines()[-1] == "total: loaded 2, skipped 0"
