"""Tests for render.llm_export: record shape, relation key naming, the plain-English
summary sentence, archived/ministry filtering and the CLI."""
import json
import sqlite3
import sys
from pathlib import Path

import pytest

from db.crud import archive_notification, create_cross_reference
from render import llm_export as le

SCHEMA = Path(__file__).parent.parent / "db" / "schema.sql"


def _add(c, gid, series, number, year, date, gsr=None, ministry=None, instrument=None, thread=None):
    c.execute(
        "INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, "
        "ministry_id, instrument_id, thread_id) VALUES (?,?,?,?,?,?,?,?,?,?)",
        (gid, series, number, year, "4-digit-year", date, gsr, ministry, instrument, thread))


@pytest.fixture
def conn():
    c = sqlite3.connect(":memory:")
    c.execute("PRAGMA foreign_keys = ON")
    c.executescript(SCHEMA.read_text())
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('fin', 'Ministry of Finance')")
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('steel', 'Ministry of Steel')")
    c.execute("INSERT INTO act_or_rule (instrument_id, title) VALUES ('ca62', 'Customs Act, 1962')")
    c.execute("INSERT INTO subject_thread (thread_id, subject_summary) VALUES ('t1', 'Duty exemptions')")
    _add(c, "a", "Customs", "45/2025", 2025, "2025-10-24", "G.S.R. 781(E)", "fin", "ca62", "t1")
    _add(c, "b", "Customs", "31/2024", 2024, "2024-05-01", "G.S.R. 100(E)", "fin")
    _add(c, "c", "Customs", "10/2023", 2023, "2023-01-01", None, "fin")
    _add(c, "d", "Steel", "S.O. 9(E)", 2026, "2026-02-02", "S.O. 9(E)", "steel")
    _add(c, "e", "Orphan", "7", 2022, "2022-02-02", None, None)
    yield c
    c.close()


def rec(conn, gid):
    return next(r for r in le.export(conn) if r["gazette_id"] == gid)


def test_record_has_core_fields_and_linked_names(conn):
    r = rec(conn, "a")
    assert {k: r[k] for k in ("gazette_id", "series", "number", "year", "publish_date", "gsr_or_so",
                              "ministry", "instrument", "thread")} == {
        "gazette_id": "a", "series": "Customs", "number": "45/2025", "year": 2025,
        "publish_date": "2025-10-24", "gsr_or_so": "G.S.R. 781(E)", "ministry": "Ministry of Finance",
        "instrument": "Customs Act, 1962", "thread": "Duty exemptions"}


def test_unlinked_ministry_instrument_thread_are_none(conn):
    r = rec(conn, "e")
    assert r["ministry"] is None and r["instrument"] is None and r["thread"] is None


def test_summary_without_crossrefs(conn):
    assert rec(conn, "a")["summary"] == "Ministry of Finance 45/2025 (G.S.R. 781(E), 2025-10-24) has no recorded cross-references."


def test_summary_falls_back_to_series_and_placeholder_gsr(conn):
    assert rec(conn, "e")["summary"] == "Orphan 7 (no G.S.R./S.O. confirmed, 2022-02-02) has no recorded cross-references."


def test_forward_relations_keys_summary_and_peer_shape(conn):
    create_cross_reference(conn, "a", "b", "supersedes")
    create_cross_reference(conn, "a", "c", "supersedes")
    create_cross_reference(conn, "a", "d", "cites")
    r = rec(conn, "a")
    assert r["supersedes"] == [
        {"gazette_id": "b", "number": "31/2024", "publish_date": "2024-05-01", "gsr_or_so": "G.S.R. 100(E)"},
        {"gazette_id": "c", "number": "10/2023", "publish_date": "2023-01-01", "gsr_or_so": None},
    ]
    assert r["cites"][0]["gazette_id"] == "d"
    assert r["summary"] == ("Ministry of Finance 45/2025 (G.S.R. 781(E), 2025-10-24) "
                            "supersedes 2 notifications; cites 1 notification.")


def test_reverse_relations_use_by_suffix_and_past_participle(conn):
    create_cross_reference(conn, "a", "b", "supersedes")
    create_cross_reference(conn, "c", "b", "amends")
    r = rec(conn, "b")
    assert "supersedes" not in r and "amends" not in r
    assert [p["gazette_id"] for p in r["supersedes_by"]] == ["a"]
    assert [p["gazette_id"] for p in r["amends_by"]] == ["c"]
    assert r["summary"].endswith("superseded by 1 notification; amended by 1 notification.")  # ref_id order


@pytest.mark.parametrize("rel,phrase", sorted(le.REVERSE_PHRASING.items()))
def test_every_reverse_phrase_is_used(conn, rel, phrase):
    create_cross_reference(conn, "a", "b", rel)
    assert f"{phrase} 1 notification." in rec(conn, "b")["summary"]


def test_reverse_phrasing_table_is_exact():
    assert le.REVERSE_SUFFIX == "_by"
    assert le.REVERSE_PHRASING == {
        "amends": "amended by", "supersedes": "superseded by", "corrigendum": "corrigendum issued by",
        "rescinds": "rescinded by", "repeals": "repealed by", "cites": "cited by"}


def test_forward_and_reverse_for_same_relation_coexist(conn):
    create_cross_reference(conn, "b", "c", "amends")
    create_cross_reference(conn, "a", "b", "amends")
    r = rec(conn, "b")
    assert [p["gazette_id"] for p in r["amends"]] == ["c"]
    assert [p["gazette_id"] for p in r["amends_by"]] == ["a"]
    assert "amends 1 notification; amended by 1 notification." in r["summary"]


def test_pluralisation_boundary_one_vs_many(conn):
    create_cross_reference(conn, "a", "b", "cites")
    assert rec(conn, "a")["summary"].endswith("cites 1 notification.")
    create_cross_reference(conn, "a", "c", "cites")
    assert rec(conn, "a")["summary"].endswith("cites 2 notifications.")


def test_archived_crossrefs_are_excluded_from_record(conn):
    ref = create_cross_reference(conn, "a", "b", "cites")
    conn.execute("UPDATE cross_reference SET archived_at = 'x' WHERE ref_id = ?", (ref["ref_id"],))
    r = rec(conn, "a")
    assert "cites" not in r and r["summary"].endswith("has no recorded cross-references.")


def test_export_orders_by_gazette_id_and_hides_archived(conn):
    assert [r["gazette_id"] for r in le.export(conn)] == ["a", "b", "c", "d", "e"]
    archive_notification(conn, "b")
    assert [r["gazette_id"] for r in le.export(conn)] == ["a", "c", "d", "e"]


def test_export_ministry_filter(conn):
    assert [r["gazette_id"] for r in le.export(conn, ministry_id="steel")] == ["d"]
    assert [r["gazette_id"] for r in le.export(conn, ministry_id="fin")] == ["a", "b", "c"]
    assert list(le.export(conn, ministry_id="nope")) == []


def test_export_ministry_filter_none_means_all(conn):
    assert len(list(le.export(conn, ministry_id=None))) == 5


def _main(monkeypatch, tmp_path, argv):
    db = tmp_path / "g.db"
    if not db.exists():
        c = sqlite3.connect(db)
        c.executescript(SCHEMA.read_text())
        c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('fin', 'Ministry of Finance')")
        _add(c, "a", "Customs", "1", 2025, "2025-01-01", "G.S.R. 1(E)", "fin")
        _add(c, "z", "Steel", "नमस्ते", 2025, "2025-01-02", None, None)
        c.commit()
        c.close()
    monkeypatch.setattr(sys, "argv", ["llm_export", "--db", str(db), *argv])
    le.main()


def test_main_prints_jsonl_unescaped_and_count_on_stderr(monkeypatch, tmp_path, capsys):
    _main(monkeypatch, tmp_path, [])
    out, err = capsys.readouterr()
    lines = out.splitlines()
    assert [json.loads(l)["gazette_id"] for l in lines] == ["a", "z"]
    assert "नमस्ते" in lines[1]  # ensure_ascii=False
    assert err.strip() == "2 record(s) exported."


def test_main_ministry_filter(monkeypatch, tmp_path, capsys):
    _main(monkeypatch, tmp_path, ["--ministry", "fin"])
    out, err = capsys.readouterr()
    assert [json.loads(l)["gazette_id"] for l in out.splitlines()] == ["a"]
    assert err.strip() == "1 record(s) exported."
