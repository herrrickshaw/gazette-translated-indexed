"""verify.review_queue: human accept / reject / skip loop (input() is scripted)."""
import builtins
import sqlite3
import sys
from pathlib import Path

import pytest

from db.crud import NotificationFields, create_cross_reference, create_notification, get_cross_reference
from verify import review_queue as rq

SCHEMA = Path(__file__).parent.parent / "db" / "schema.sql"


@pytest.fixture
def conn():
    c = sqlite3.connect(":memory:")
    c.execute("PRAGMA foreign_keys = ON")
    c.executescript(SCHEMA.read_text())
    for gid in ("a", "b", "c"):
        create_notification(c, gid, "S", gid, "2026-01-01", "so-only", NotificationFields())
    yield c
    c.close()


def _answers(monkeypatch, answers):
    prompts = []
    it = iter(answers)
    monkeypatch.setattr(builtins, "input", lambda prompt="": prompts.append(prompt) or next(it))
    return prompts


def test_pending_lists_only_unverified_unarchived(conn):
    r1 = create_cross_reference(conn, "a", "b", "amends")
    create_cross_reference(conn, "a", "c", "amends", verified_by="someone")
    r3 = create_cross_reference(conn, "b", "c", "cites")
    conn.execute("UPDATE cross_reference SET archived_at = 'x' WHERE ref_id = ?", (r3["ref_id"],))
    assert [r["ref_id"] for r in rq.pending(conn)] == [r1["ref_id"]]


def test_review_nothing_pending_prints_message_and_never_prompts(conn, monkeypatch, capsys):
    monkeypatch.setattr(builtins, "input", lambda p="": pytest.fail("no prompt expected"))
    rq.review(conn, "rev")
    assert capsys.readouterr().out == "Nothing pending review.\n"


def test_review_accept_reject_skip_each_apply_and_commit(conn, monkeypatch, capsys):
    acc = create_cross_reference(conn, "a", "b", "amends")
    rej = create_cross_reference(conn, "a", "c", "supersedes")
    skp = create_cross_reference(conn, "b", "c", "cites")
    conn.commit()
    prompts = _answers(monkeypatch, ["a", "r", "s"])
    rq.review(conn, "alice")
    out = capsys.readouterr().out
    assert "3 candidate link(s) pending review." in out
    assert f"[{acc['ref_id']}] a --amends--> b" in out
    assert f"[{rej['ref_id']}] a --supersedes--> c" in out
    assert prompts == ["  accept / reject / skip? [a/r/s] "] * 3
    ok = get_cross_reference(conn, acc["ref_id"])
    assert ok["verified_by"] == "alice" and ok["verified_at"] is not None
    assert get_cross_reference(conn, rej["ref_id"]) is None  # hard-deleted
    kept = get_cross_reference(conn, skp["ref_id"])
    assert kept is not None and kept["verified_by"] is None
    # committed: a second connection to the same transaction state sees the changes
    assert conn.in_transaction is False


def test_review_answer_is_case_and_whitespace_insensitive(conn, monkeypatch):
    r1 = create_cross_reference(conn, "a", "b", "amends")
    r2 = create_cross_reference(conn, "a", "c", "amends")
    _answers(monkeypatch, ["  A \n", " R"])
    rq.review(conn, "bob")
    assert get_cross_reference(conn, r1["ref_id"])["verified_by"] == "bob"
    assert get_cross_reference(conn, r2["ref_id"]) is None


def test_review_unknown_answer_leaves_row_pending(conn, monkeypatch):
    r1 = create_cross_reference(conn, "a", "b", "amends")
    _answers(monkeypatch, ["yes"])  # not a/r/s: must not be treated as accept
    rq.review(conn, "bob")
    row = get_cross_reference(conn, r1["ref_id"])
    assert row is not None and row["verified_by"] is None


def test_review_empty_answer_leaves_row_pending(conn, monkeypatch):
    r1 = create_cross_reference(conn, "a", "b", "amends")
    _answers(monkeypatch, [""])
    rq.review(conn, "bob")
    assert get_cross_reference(conn, r1["ref_id"])["verified_by"] is None


def test_main_uses_cli_reviewer_default_and_closes_connection(tmp_path, monkeypatch):
    db = tmp_path / "g.db"
    c = sqlite3.connect(db)
    c.executescript(SCHEMA.read_text())
    for gid in ("a", "b"):
        create_notification(c, gid, "S", gid, "2026-01-01", "so-only", NotificationFields())
    create_cross_reference(c, "a", "b", "amends")
    c.commit()
    c.close()
    _answers(monkeypatch, ["a"])
    monkeypatch.setattr(sys, "argv", ["review_queue", "--db", str(db)])
    assert rq.main() == 0
    c = sqlite3.connect(db)
    assert c.execute("SELECT verified_by FROM cross_reference").fetchone() == ("cli-reviewer",)
    c.close()


def test_main_passes_explicit_reviewer(tmp_path, monkeypatch):
    seen = []
    monkeypatch.setattr(rq, "review", lambda conn, reviewer: seen.append(reviewer))
    db = tmp_path / "g.db"
    sqlite3.connect(db).close()
    monkeypatch.setattr(sys, "argv", ["review_queue", "--db", str(db), "--reviewer", "carol"])
    assert rq.main() == 0
    assert seen == ["carol"]


def test_main_requires_db(monkeypatch):
    monkeypatch.setattr(sys, "argv", ["review_queue"])
    with pytest.raises(SystemExit) as ei:
        rq.main()
    assert ei.value.code == 2


def test_main_closes_connection_when_review_raises(tmp_path, monkeypatch):
    holder = {}
    real = sqlite3.connect

    class Spy:
        def __init__(self, c):
            self._c = c
            self.closed = False

        def execute(self, *a):
            return self._c.execute(*a)

        def close(self):
            self.closed = True
            self._c.close()

    def fake_connect(p):
        holder["c"] = Spy(real(":memory:"))
        return holder["c"]

    monkeypatch.setattr(rq.sqlite3, "connect", fake_connect)
    monkeypatch.setattr(rq, "review", lambda conn, reviewer: (_ for _ in ()).throw(RuntimeError("boom")))
    monkeypatch.setattr(sys, "argv", ["review_queue", "--db", "x"])
    with pytest.raises(RuntimeError):
        rq.main()
    assert holder["c"].closed is True
