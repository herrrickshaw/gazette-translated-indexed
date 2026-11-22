"""Tests for ingest.pdf_text: scanned-PDF detection thresholds (fake PyMuPDF so
page text is exact) plus one smoke test through the real library."""
import sys
from pathlib import Path

import pytest

from ingest import pdf_text as pt


class FakePage:
    def __init__(self, text):
        self._t = text

    def get_text(self):
        return self._t


class FakeDoc(list):
    def __enter__(self):
        return self

    def __exit__(self, *a):
        self.closed = True
        return False


@pytest.fixture
def fake_fitz(monkeypatch):
    state = {"opened": []}
    mod = type(sys)("fitz")

    def fake_open(path):
        state["opened"].append(path)
        return FakeDoc(FakePage(t) for t in state["pages"])

    mod.open = fake_open
    monkeypatch.setitem(sys.modules, "fitz", mod)
    return state


OK = "x" * pt.MIN_CHARS_PER_PAGE
THIN = "x" * (pt.MIN_CHARS_PER_PAGE - 1)


def test_threshold_constant():
    assert pt.MIN_CHARS_PER_PAGE == 20


def test_extract_text_joins_pages_with_markers(fake_fitz, tmp_path):
    fake_fitz["pages"] = ["  first page text that is long enough  ", "second page text that is long enough\n"]
    out = pt.extract_text(tmp_path / "a.pdf")
    assert out == ("<!-- page 1 -->\nfirst page text that is long enough\n\n"
                   "<!-- page 2 -->\nsecond page text that is long enough")
    assert fake_fitz["opened"] == [tmp_path / "a.pdf"]


def test_extract_text_accepts_str_path(fake_fitz):
    fake_fitz["pages"] = [OK]
    pt.extract_text("some/file.pdf")
    assert fake_fitz["opened"] == [Path("some/file.pdf")]


def test_page_of_exactly_min_chars_is_not_thin(fake_fitz, tmp_path):
    fake_fitz["pages"] = [OK, OK, OK]
    assert pt.extract_text(tmp_path / "a.pdf").count("<!-- page") == 3


def test_page_one_char_short_is_thin_and_all_thin_raises(fake_fitz, tmp_path):
    fake_fitz["pages"] = [THIN]
    with pytest.raises(pt.LikelyScannedError, match=r"a\.pdf: 1/1 pages had under 20 characters"):
        pt.extract_text(tmp_path / "a.pdf")


def test_exactly_half_thin_is_accepted(fake_fitz, tmp_path):
    fake_fitz["pages"] = [OK, THIN]  # 1/2 = 0.5, not > 0.5
    out = pt.extract_text(tmp_path / "a.pdf")
    assert "<!-- page 2 -->\n" + THIN in out


def test_more_than_half_thin_raises(fake_fitz, tmp_path):
    fake_fitz["pages"] = [OK, THIN, THIN]
    with pytest.raises(pt.LikelyScannedError, match="2/3 pages"):
        pt.extract_text(tmp_path / "a.pdf")


def test_whitespace_only_page_counts_as_thin_after_strip(fake_fitz, tmp_path):
    fake_fitz["pages"] = ["   \n" * 30]  # 150 raw chars but empty once stripped
    with pytest.raises(pt.LikelyScannedError):
        pt.extract_text(tmp_path / "a.pdf")


def test_zero_page_document_returns_empty_string(fake_fitz, tmp_path):
    fake_fitz["pages"] = []
    assert pt.extract_text(tmp_path / "a.pdf") == ""


def test_main_usage_error_when_wrong_arg_count(monkeypatch, capsys):
    monkeypatch.setattr(sys, "argv", ["pdf_text"])
    assert pt.main() == 1
    assert "usage: python3 -m ingest.pdf_text <file.pdf>" in capsys.readouterr().err
    monkeypatch.setattr(sys, "argv", ["pdf_text", "a", "b"])
    assert pt.main() == 1


def test_main_prints_text(monkeypatch, capsys, fake_fitz):
    fake_fitz["pages"] = [OK]
    monkeypatch.setattr(sys, "argv", ["pdf_text", "a.pdf"])
    assert pt.main() == 0
    assert capsys.readouterr().out == f"<!-- page 1 -->\n{OK}\n"


def test_main_scanned_returns_2_with_message_on_stderr(monkeypatch, capsys, fake_fitz):
    fake_fitz["pages"] = [THIN]
    monkeypatch.setattr(sys, "argv", ["pdf_text", "scan.pdf"])
    assert pt.main() == 2
    out, err = capsys.readouterr()
    assert out == "" and "scan.pdf: 1/1 pages" in err and "ingest.ocr_fallback" in err


def test_real_pymupdf_roundtrip(tmp_path):
    fitz = pytest.importorskip("fitz")
    pdf = tmp_path / "real.pdf"
    doc = fitz.open()
    for n in range(2):
        page = doc.new_page()
        page.insert_text((72, 72), f"Notification page {n} body text here")
    doc.save(str(pdf))
    doc.close()
    out = pt.extract_text(pdf)
    assert "<!-- page 1 -->\nNotification page 0 body text here" in out
    assert "<!-- page 2 -->\nNotification page 1 body text here" in out

    blank = tmp_path / "blank.pdf"
    d2 = fitz.open()
    d2.new_page()
    d2.save(str(blank))
    d2.close()
    with pytest.raises(pt.LikelyScannedError):
        pt.extract_text(blank)
