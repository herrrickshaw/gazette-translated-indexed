"""render.pages: HTML regeneration from the database (history/amendment tables)."""
import sqlite3
import sys
from pathlib import Path

import pytest

from render import pages as pg

SCHEMA = Path(__file__).parent.parent / "db" / "schema.sql"


def add(c, gid, number, series, date, form, gsr=None):
    c.execute("INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so) "
              "VALUES (?,?,?,?,?,?,?)", (gid, series, number, int(date[:4]), form, date, gsr))


def xref(c, src, tgt, rel):
    c.execute("INSERT INTO cross_reference (source_gazette_id, target_gazette_id, relation_type) VALUES (?,?,?)", (src, tgt, rel))


@pytest.fixture
def conn():
    c = sqlite3.connect(":memory:")
    c.execute("PRAGMA foreign_keys = ON")
    c.executescript(SCHEMA.read_text())
    add(c, "cur", "45/2025", "Customs", "2025-10-24", "4-digit-year", "G.S.R. 781(E)")
    add(c, "old1", "207/89", "Customs", "1989-03-05", "bare", "G.S.R. 10(E)")
    add(c, "old2", "100/90", "Customs", "1990-01-02", "2-digit-year")
    add(c, "mid", "31/2024", "Customs", "2024-05-01", "4-digit-year", "G.S.R. 100(E)")
    add(c, "amd2", "50/2025", "Customs", "2025-12-01", "4-digit-year", "G.S.R. 900(E)")
    add(c, "amd1", "46/2025", "Customs", "2025-11-01", "4-digit-year", "G.S.R. 800(E)")
    add(c, "other", "9/2020", "Customs", "2020-01-01", "4-digit-year")
    xref(c, "cur", "old2", "supersedes")
    xref(c, "cur", "old1", "supersedes")
    xref(c, "cur", "mid", "supersedes")
    xref(c, "cur", "other", "cites")        # not 'supersedes': must not appear in history
    xref(c, "amd2", "cur", "amends")
    xref(c, "amd1", "cur", "amends")
    xref(c, "other", "cur", "supersedes")   # reverse direction: must not appear
    yield c
    c.close()


def test_fetch_notification_found_and_missing(conn):
    assert pg._fetch_notification(conn, "Customs", "45/2025")["gazette_id"] == "cur"
    with pytest.raises(SystemExit, match="no notification found for Customs 46/2099"):
        pg._fetch_notification(conn, "Customs", "46/2099")
    with pytest.raises(SystemExit):
        pg._fetch_notification(conn, "Other", "45/2025")  # series must match too


def test_absorbed_history_only_supersedes_targets_oldest_first(conn):
    assert [r["gazette_id"] for r in pg._absorbed_history(conn, "cur")] == ["old1", "old2", "mid"]
    assert pg._absorbed_history(conn, "mid") == []


def test_amendments_only_amends_sources_oldest_first(conn):
    assert [r["gazette_id"] for r in pg._amendments(conn, "cur")] == ["amd1", "amd2"]
    assert pg._amendments(conn, "old1") == []


def test_row_html_formats_date_number_and_gsr(conn):
    conn.row_factory = sqlite3.Row
    row = conn.execute("SELECT * FROM gazette_notification WHERE gazette_id = 'cur'").fetchone()
    assert pg._row_html(row) == ('<tr><td>No. 45/2025&#8209;Customs</td><td class="num">24 Oct 2025</td>'
                                 '<td class="num">G.S.R. 781(E)</td></tr>')


def test_row_html_day_not_zero_padded_and_unconfirmed_gsr_placeholder(conn):
    conn.row_factory = sqlite3.Row
    row = conn.execute("SELECT * FROM gazette_notification WHERE gazette_id = 'old2'").fetchone()
    html = pg._row_html(row)
    assert '<td class="num">2 Jan 1990</td>' in html
    assert '<span style="opacity:.6">unconfirmed</span>' in html


def test_row_html_as_listed_adds_order_cell_first(conn):
    conn.row_factory = sqlite3.Row
    row = conn.execute("SELECT * FROM gazette_notification WHERE gazette_id = 'cur'").fetchone()
    assert pg._row_html(row, as_listed="7th").startswith('<tr><td class="order">7th</td><td>No. 45/2025')
    assert 'class="order"' not in pg._row_html(row, as_listed=None)
    assert 'class="order"' not in pg._row_html(row, as_listed="")


def test_render_full_page_sections_and_order(conn):
    html = pg.render(conn, "Customs", "45/2025")
    assert html.startswith("<h2>No. 45/2025&#8209;Customs &mdash; generated from the database</h2>\n<h3>Current chain</h3>")
    chain = html.index("Current chain")
    pre = html.index("before 4-digit-year numbering (2 notifications)")
    post = html.index("4-digit-year numbering (1 notifications)")
    assert chain < pre < post
    # chain lists current first then amendments by date
    assert html.index("45/2025") < html.index("46/2025") < html.index("50/2025")
    # pre-1994 rows in date order: 207/89 (1989) before 100/90 (1990)
    assert html.index("207/89") < html.index("100/90")
    assert "31/2024" in html and "9/2020" not in html


def test_render_pre1994_includes_every_non_4digit_form(conn):
    html = pg.render(conn, "Customs", "45/2025")
    section = html[html.index("before 4-digit-year"):html.index("&middot; 4-digit-year")]
    assert "207/89" in section and "100/90" in section and "31/2024" not in section  # 'bare' and '2-digit-year'


def test_render_omits_empty_sections(conn):
    html = pg.render(conn, "Customs", "31/2024")  # no amendments, no history
    assert html == "<h2>No. 31/2024&#8209;Customs &mdash; generated from the database</h2>"


def test_render_only_post1994_history_and_no_amendments(conn):
    add(conn, "newer", "1/2026", "Customs", "2026-01-01", "4-digit-year")
    xref(conn, "newer", "mid", "supersedes")
    html = pg.render(conn, "Customs", "1/2026")
    assert "Current chain" not in html and "before 4-digit-year" not in html
    assert "4-digit-year numbering (1 notifications)" in html and "31/2024" in html


def test_render_translate_widget_prepended_only_when_asked(conn):
    plain = pg.render(conn, "Customs", "31/2024")
    assert "google_translate_element" not in plain
    with_widget = pg.render(conn, "Customs", "31/2024", translate_widget=True)
    assert with_widget == pg.TRANSLATE_WIDGET + "\n" + plain
    assert "translate.google.com/translate_a/element.js" in with_widget


def _main(monkeypatch, argv):
    monkeypatch.setattr(sys, "argv", ["pages", *argv])
    return pg.main()


@pytest.fixture
def dbfile(tmp_path):
    p = tmp_path / "g.db"
    c = sqlite3.connect(p)
    c.executescript(SCHEMA.read_text())
    add(c, "cur", "45/2025", "Customs", "2025-10-24", "4-digit-year", "G.S.R. 781(E)")
    c.commit()
    c.close()
    return str(p)


def test_main_prints_html_to_stdout(monkeypatch, dbfile, capsys):
    assert _main(monkeypatch, ["--db", dbfile, "--notification", "45/2025-Customs"]) == 0
    assert capsys.readouterr().out.startswith("<h2>No. 45/2025&#8209;Customs")


def test_main_splits_notification_on_first_hyphen_only(monkeypatch, dbfile, capsys):
    c = sqlite3.connect(dbfile)
    add(c, "ct", "12/2024", "Central Tax-Rate", "2024-01-01", "4-digit-year")
    c.commit()
    c.close()
    assert _main(monkeypatch, ["--db", dbfile, "--notification", "12/2024-Central Tax-Rate"]) == 0
    assert "No. 12/2024&#8209;Central Tax-Rate" in capsys.readouterr().out


def test_main_writes_out_file_and_prints_nothing(monkeypatch, dbfile, tmp_path, capsys):
    out = tmp_path / "page.html"
    assert _main(monkeypatch, ["--db", dbfile, "--notification", "45/2025-Customs", "--out", str(out),
                               "--translate-widget"]) == 0
    assert capsys.readouterr().out == ""
    text = out.read_text()
    assert text.startswith(pg.TRANSLATE_WIDGET) and "No. 45/2025" in text


def test_main_missing_notification_exits(monkeypatch, dbfile):
    with pytest.raises(SystemExit, match="no notification found for Customs 9/9"):
        _main(monkeypatch, ["--db", dbfile, "--notification", "9/9-Customs"])
