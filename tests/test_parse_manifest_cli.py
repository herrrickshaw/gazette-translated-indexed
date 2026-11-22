"""ingest.parse_manifest.main(): --update-db path, exit code 1 when a modeled claim is
missed, and the per-row output flags. extract_text is stubbed; PDFs are placeholders."""
import csv
import sqlite3
from pathlib import Path

import pytest

from ingest import parse_manifest as pm

GID = "CG-DL-E-03092026-275956"
SCHEMA = Path(__file__).parent.parent / "db" / "schema.sql"
TEXT = ("S.O. 4848(E).- The Central Government hereby makes the following amendments in the notification "
        "of the Government of India in the Ministry of Road Transport and Highways, number S.O. 4872(E), dated 1st Jan 2020.")


def _row(**kw):
    base = {"gazette_id": GID, "ministry_id": "road-transport-highways", "self_citation": "S.O. 4848(E)",
            "expected_targets": "S.O. 4872(E)", "modeled": "1", "note": ""}
    base.update(kw)
    return base


def _manifest(tmp_path, rows):
    p = tmp_path / "m.csv"
    with p.open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(_row()))
        w.writeheader()
        w.writerows(rows)
    return p


@pytest.fixture
def pdfs(tmp_path):
    d = tmp_path / "pdf"
    (d / "2026").mkdir(parents=True)
    (d / "2026" / f"{GID}.pdf").write_bytes(b"%PDF-stub")
    return d


def _run(monkeypatch, tmp_path, pdfs, rows, *extra):
    monkeypatch.setattr(pm, "extract_text", lambda p: TEXT)
    monkeypatch.setattr("sys.argv", ["pm", str(_manifest(tmp_path, rows)), "--pdf-dir", str(pdfs),
                                     "--md-dir", str(tmp_path / "md"), "--report", str(tmp_path / "rep.md"), *extra])
    return pm.main()


def test_main_prints_recovery_fraction_per_row(monkeypatch, tmp_path, pdfs, capsys):
    assert _run(monkeypatch, tmp_path, pdfs, [_row()]) == 0
    line = capsys.readouterr().out.splitlines()[0]
    assert line == f"{GID:<26} {'RECOVERED':<11} rec=1/1"


def test_main_flags_row_whose_self_citation_is_not_in_the_pdf(monkeypatch, tmp_path, pdfs, capsys):
    _run(monkeypatch, tmp_path, pdfs, [_row(self_citation="S.O. 1111(E)", modeled="0")])
    assert capsys.readouterr().out.splitlines()[0].endswith("  <-- SELF-CITATION NOT IN PDF")


def test_main_exit_1_when_a_modeled_claim_is_not_recovered(monkeypatch, tmp_path, pdfs):
    assert _run(monkeypatch, tmp_path, pdfs, [_row(expected_targets="S.O. 9999(E)")]) == 1


def test_main_unmodeled_miss_does_not_fail_the_run(monkeypatch, tmp_path, pdfs):
    assert _run(monkeypatch, tmp_path, pdfs, [_row(expected_targets="S.O. 9999(E)", modeled="0")]) == 0


def test_main_update_db_reports_upgraded_count(monkeypatch, tmp_path, pdfs, capsys):
    db = tmp_path / "g.db"
    c = sqlite3.connect(db)
    c.executescript(SCHEMA.read_text())
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('m', 'M')")
    for gid, so in (("a", "S.O. 4848(E)"), ("b", "S.O. 4872(E)")):
        c.execute("INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, publish_date, "
                  "gsr_or_so, ministry_id) VALUES (?, 'S', ?, 2026, 'so-only', '2026-01-01', ?, 'm')", (gid, so, so))
    c.execute("INSERT INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by) "
              "VALUES ('a', 'b', 'amends', 'aggregator')")
    c.commit()
    c.close()
    assert _run(monkeypatch, tmp_path, pdfs, [_row()], "--update-db", str(db)) == 0
    assert "provenance upgraded on 1 cross_reference row(s)" in capsys.readouterr().out


def test_main_without_update_db_prints_no_provenance_line(monkeypatch, tmp_path, pdfs, capsys):
    _run(monkeypatch, tmp_path, pdfs, [_row()])
    assert "provenance upgraded" not in capsys.readouterr().out
