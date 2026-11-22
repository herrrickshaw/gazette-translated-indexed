"""ingest.register_new.main(): ministry iteration, outcome printing and the stderr summary."""
import sqlite3
import sys
from pathlib import Path

import pytest

from ingest import register_new as rn

SCHEMA = Path(__file__).parent.parent / "db" / "schema.sql"


@pytest.fixture
def dbfile(tmp_path):
    p = tmp_path / "g.db"
    c = sqlite3.connect(p)
    c.executescript(SCHEMA.read_text())
    c.commit()
    c.close()
    return str(p)


def _main(monkeypatch, argv):
    monkeypatch.setattr(sys, "argv", ["register_new", *argv])
    return rn.main()


def test_main_single_ministry_prints_non_registered_lines_and_summary(monkeypatch, dbfile, capsys):
    seen = []

    def fake_register(conn, mid, series):
        seen.append((mid, series))
        return [{"gazette_id": "g1", "status": "registered"},
                {"gazette_id": "g2", "status": "already_registered"},
                {"gazette_id": "g3", "status": "skipped_needs_ocr"},
                {"gazette_id": "g4", "status": "registered"}]

    monkeypatch.setattr(rn, "register_for_ministry", fake_register)
    assert _main(monkeypatch, ["--db", dbfile, "--ministry", "steel", "--series", "Steel"]) == 0
    out, err = capsys.readouterr()
    assert seen == [("steel", "Steel")]
    # only 'already_registered' is suppressed from the per-item lines
    assert out == "[steel] g1: registered\n[steel] g3: skipped_needs_ocr\n[steel] g4: registered\n"
    assert err.splitlines() == ["", "Summary:", "  already_registered: 1", "  registered: 2", "  skipped_needs_ocr: 1"]


def test_main_all_ministries_sorted_with_default_series_none(monkeypatch, dbfile, capsys):
    seen = []
    monkeypatch.setattr(rn, "MINISTRY_TRACKER_SLUGS", {"zinc": "z", "alpha": "a", "mid": "m"})
    monkeypatch.setattr(rn, "register_for_ministry",
                        lambda conn, mid, series: seen.append((mid, series)) or [])
    assert _main(monkeypatch, ["--db", dbfile]) == 0
    assert seen == [("alpha", None), ("mid", None), ("zinc", None)]
    out, err = capsys.readouterr()
    assert out == "" and err == "\nSummary:\n"


def test_main_counts_accumulate_across_ministries(monkeypatch, dbfile, capsys):
    monkeypatch.setattr(rn, "MINISTRY_TRACKER_SLUGS", {"a": "a", "b": "b"})
    monkeypatch.setattr(rn, "register_for_ministry",
                        lambda conn, mid, series: [{"gazette_id": mid, "status": "registered"}])
    _main(monkeypatch, ["--db", dbfile])
    assert "  registered: 2" in capsys.readouterr().err


def test_main_commits_and_closes_connection(monkeypatch, dbfile):
    """Rows created via register_for_ministry must be durable once main() returns."""
    def fake_register(conn, mid, series):
        conn.execute("INSERT INTO ministry (ministry_id, name) VALUES ('m', 'M')")
        return [{"gazette_id": "x", "status": "registered"}]

    monkeypatch.setattr(rn, "register_for_ministry", fake_register)
    _main(monkeypatch, ["--db", dbfile, "--ministry", "m"])
    c = sqlite3.connect(dbfile)
    assert c.execute("SELECT COUNT(*) FROM ministry").fetchone()[0] == 1
    c.close()


def test_main_enables_foreign_keys(monkeypatch, dbfile):
    flags = []
    monkeypatch.setattr(rn, "register_for_ministry",
                        lambda conn, mid, series: flags.append(conn.execute("PRAGMA foreign_keys").fetchone()[0]) or [])
    _main(monkeypatch, ["--db", dbfile, "--ministry", "m"])
    assert flags == [1]


def test_main_default_db_name(monkeypatch, tmp_path):
    monkeypatch.chdir(tmp_path)
    opened = []
    real = sqlite3.connect
    monkeypatch.setattr(rn.sqlite3, "connect", lambda p: opened.append(p) or real(":memory:"))
    monkeypatch.setattr(rn, "MINISTRY_TRACKER_SLUGS", {})
    _main(monkeypatch, [])
    assert opened == ["gazette.db"]
