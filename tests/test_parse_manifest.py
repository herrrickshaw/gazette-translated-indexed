"""Characterisation tests for ingest.parse_manifest using synthetic text.
extract_text is stubbed and PDFs are empty placeholder files: no network,
no real PDF parsing."""
import csv
import sqlite3
from pathlib import Path

import pytest

from ingest import parse_manifest as pm
from ingest.pdf_text import LikelyScannedError

GID = "CG-DL-E-03092026-275956"
SCHEMA = Path(__file__).parent.parent / "db" / "schema.sql"
TEXT = (
    "S.O. 4848(E).- The Central Government hereby makes the following amendments in the "
    "notification of the Government of India in the Ministry of Road Transport and Highways, "
    "number S.O. 4872(E), dated 1st Jan 2020."
)


def _row(**kw):
    base = {"gazette_id": GID, "ministry_id": "road-transport-highways", "self_citation": "S.O. 4848(E)",
            "expected_targets": "S.O. 4872(E)", "modeled": "1", "note": ""}
    base.update(kw)
    return base


@pytest.fixture
def dirs(tmp_path):
    pdf_dir, md_dir = tmp_path / "pdf", tmp_path / "md"
    (pdf_dir / "2026").mkdir(parents=True)
    (pdf_dir / "2026" / f"{GID}.pdf").write_bytes(b"%PDF-stub")
    return pdf_dir, md_dir


def test_no_pdf(tmp_path):
    r = pm.parse_row(_row(), tmp_path, tmp_path / "md")
    assert r["status"] == "NO_PDF" and r["citations"] == []


def test_needs_ocr(dirs, monkeypatch):
    def boom(_):
        raise LikelyScannedError("scanned")
    monkeypatch.setattr(pm, "extract_text", boom)
    assert pm.parse_row(_row(), *dirs)["status"] == "NEEDS_OCR"


def test_recovered_and_transcript_written(dirs, monkeypatch):
    monkeypatch.setattr(pm, "extract_text", lambda p: TEXT)
    r = pm.parse_row(_row(), *dirs)
    assert r["status"] == "RECOVERED" and r["recovered"] == ["S.O. 4872(E)"] and r["missing"] == []
    assert r["self_found"] is True and r["citations"] == ["S.O. 4848(E)", "S.O. 4872(E)"]
    assert r["found_all"] == ["S.O. 4872(E)"]
    md = (dirs[1] / f"{GID}.md").read_text()
    assert md.startswith(
        f"---\nsource_url: https://egazette.gov.in/WriteReadData/2026/275956.pdf\ngazette_id: {GID}\n"
        "extraction_method: ingest.pdf_text (PyMuPDF)\n---\n\n")
    assert md.endswith(TEXT)


def test_partial_missed_target_only_and_generic(dirs, monkeypatch):
    monkeypatch.setattr(pm, "extract_text", lambda p: TEXT)
    assert pm.parse_row(_row(expected_targets="S.O. 4872(E);S.O. 1(E)"), *dirs)["status"] == "PARTIAL"
    assert pm.parse_row(_row(expected_targets="S.O. 2(E)"), *dirs)["status"] == "MISSED"
    assert pm.parse_row(_row(expected_targets=""), *dirs)["status"] == "TARGET_ONLY"
    g = pm.parse_row(_row(ministry_id="no-such-ministry"), *dirs)
    assert g["status"] == "GENERIC" and g["found_all"] == ["S.O. 4872(E)"] and g["recovered"] == ["S.O. 4872(E)"]


def test_self_not_found(dirs, monkeypatch):
    monkeypatch.setattr(pm, "extract_text", lambda p: TEXT)
    assert pm.parse_row(_row(self_citation="S.O. 9999(E)"), *dirs)["self_found"] is False


def test_report_format(dirs, monkeypatch, tmp_path):
    monkeypatch.setattr(pm, "extract_text", lambda p: TEXT)
    res = [pm.parse_row(_row(), *dirs), pm.parse_row(_row(self_citation="S.O. 9(E)"), *dirs)]
    out = tmp_path / "r.md"
    pm.write_report(res, out)
    lines = out.read_text().splitlines()
    assert lines[0] == "# Parse report — official egazette.gov.in PDFs vs. the index"
    assert lines[2] == ("Rows: 2 · modeled claims: 2 · modeled recovered: 2 · self-citation found "
                        "in own PDF: 1/2 · needs OCR: 0 · no PDF: 0")
    assert lines[6] == f"| {GID} | road-transport-highways | S.O. 4848(E) | yes | S.O. 4872(E) | S.O. 4872(E) | — | RECOVERED | 1 |"
    assert "**NO**" in lines[7]


def test_update_db_upgrades_only_recovered_modeled(dirs, monkeypatch, tmp_path):
    db = tmp_path / "g.db"
    c = sqlite3.connect(db)
    c.executescript(SCHEMA.read_text())
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('m', 'M')")
    for gid, so in (("a", "S.O. 4848(E)"), ("b", "S.O. 4872(E)")):
        c.execute("INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, "
                  "publish_date, gsr_or_so, ministry_id) VALUES (?, 'S', ?, 2026, 'so-only', '2026-01-01', ?, 'm')",
                  (gid, so, so))
    cols = [r[1] for r in c.execute("PRAGMA table_info(cross_reference)")]
    assert "verified_by" in cols
    c.execute("INSERT INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by) "
              "VALUES ('a', 'b', 'amends', 'aggregator')")
    c.commit()
    c.close()
    monkeypatch.setattr(pm, "extract_text", lambda p: TEXT)
    res = [pm.parse_row(_row(), *dirs), pm.parse_row(_row(modeled="0"), *dirs)]
    assert pm.update_db(res, db) == 1
    c = sqlite3.connect(db)
    assert c.execute("SELECT verified_by FROM cross_reference").fetchone()[0] == "primary-source-egazette"
    assert pm.update_db(res, db) == 0  # idempotent


def test_main_exit_code_and_report(dirs, monkeypatch, tmp_path, capsys):
    monkeypatch.setattr(pm, "extract_text", lambda p: TEXT)
    man = tmp_path / "m.csv"
    with man.open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(_row()))
        w.writeheader()
        w.writerow(_row())
    rep = tmp_path / "rep.md"
    monkeypatch.setattr("sys.argv", ["pm", str(man), "--pdf-dir", str(dirs[0]), "--md-dir", str(dirs[1]), "--report", str(rep)])
    assert pm.main() == 0
    assert f"{GID}" in capsys.readouterr().out and rep.exists()
