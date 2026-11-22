"""Tests for ingest.egazette's download path: _fetch_bytes (requests, with the
curl fallback on SSL errors), the on-disk cache in fetch(), and main().
`requests.get`, `subprocess.run` and `time.sleep` are all faked."""
import sys
from types import SimpleNamespace

import pytest
import requests

from ingest import egazette as eg

PDF = b"%PDF-1.7 fake body"
GID = "CG-DL-E-03092026-275956"


class FakeResp:
    def __init__(self, content=PDF, ctype="application/pdf", status_ok=True):
        self.content = content
        self.headers = {"content-type": ctype}
        self._ok = status_ok

    def raise_for_status(self):
        if not self._ok:
            raise requests.exceptions.HTTPError("404")


@pytest.fixture
def sleeps(monkeypatch):
    s = []
    monkeypatch.setattr(eg.time, "sleep", lambda x: s.append(x))
    return s


def test_looks_like_pdf_checks_magic_prefix_only():
    assert eg._looks_like_pdf(b"%PDF-1.4")
    assert not eg._looks_like_pdf(b"%PDF")  # 4 bytes: header incomplete
    assert not eg._looks_like_pdf(b" %PDF-")
    assert not eg._looks_like_pdf(b"")


def test_fetch_bytes_returns_content_and_sends_user_agent_and_timeout(monkeypatch):
    seen = {}

    def fake_get(url, headers, timeout):
        seen.update(url=url, headers=headers, timeout=timeout)
        return FakeResp()

    monkeypatch.setattr(requests, "get", fake_get)
    assert eg._fetch_bytes("https://x/y.pdf", 12.5) == PDF
    assert seen == {"url": "https://x/y.pdf", "headers": {"User-Agent": eg._USER_AGENT}, "timeout": 12.5}


def test_fetch_bytes_rejects_html_content_type(monkeypatch):
    monkeypatch.setattr(requests, "get", lambda *a, **k: FakeResp(b"<html>", "text/html"))
    with pytest.raises(RuntimeError, match="not a PDF"):
        eg._fetch_bytes("https://x", 1)


def test_fetch_bytes_rejects_pdf_content_type_with_bad_body(monkeypatch):
    monkeypatch.setattr(requests, "get", lambda *a, **k: FakeResp(b"<html>oops", "application/pdf"))
    with pytest.raises(RuntimeError, match="not a PDF"):
        eg._fetch_bytes("https://x", 1)


def test_fetch_bytes_rejects_pdf_body_with_wrong_content_type(monkeypatch):
    monkeypatch.setattr(requests, "get", lambda *a, **k: FakeResp(PDF, "application/octet-stream"))
    with pytest.raises(RuntimeError, match="not a PDF"):
        eg._fetch_bytes("https://x", 1)


def test_fetch_bytes_accepts_content_type_with_charset_suffix(monkeypatch):
    monkeypatch.setattr(requests, "get", lambda *a, **k: FakeResp(PDF, "application/pdf; charset=binary"))
    assert eg._fetch_bytes("https://x", 1) == PDF


def test_fetch_bytes_http_error_propagates_without_curl(monkeypatch):
    monkeypatch.setattr(requests, "get", lambda *a, **k: FakeResp(status_ok=False))
    monkeypatch.setattr(eg.subprocess, "run", lambda *a, **k: pytest.fail("curl must not run for non-SSL errors"))
    with pytest.raises(requests.exceptions.HTTPError):
        eg._fetch_bytes("https://x", 1)


def test_fetch_bytes_connection_error_propagates_without_curl(monkeypatch):
    def boom(*a, **k):
        raise requests.exceptions.ConnectionError("dns")

    monkeypatch.setattr(requests, "get", boom)
    monkeypatch.setattr(eg.subprocess, "run", lambda *a, **k: pytest.fail("no curl"))
    with pytest.raises(requests.exceptions.ConnectionError):
        eg._fetch_bytes("https://x", 1)


def _ssl_fail(monkeypatch):
    def boom(*a, **k):
        raise requests.exceptions.SSLError("unable to verify")

    monkeypatch.setattr(requests, "get", boom)


def test_fetch_bytes_falls_back_to_curl_on_ssl_error(monkeypatch):
    _ssl_fail(monkeypatch)
    seen = {}

    def fake_run(cmd, **kw):
        seen.update(cmd=cmd, kw=kw)
        return SimpleNamespace(returncode=0, stdout=PDF, stderr=b"")

    monkeypatch.setattr(eg.subprocess, "run", fake_run)
    assert eg._fetch_bytes("https://x/y.pdf", 59.9) == PDF
    assert seen["cmd"] == ["curl", "-sS", "-A", eg._USER_AGENT, "--max-time", "59", "https://x/y.pdf"]
    assert "-k" not in seen["cmd"] and "--insecure" not in seen["cmd"]  # never disables verification
    assert seen["kw"]["capture_output"] is True and seen["kw"]["check"] is False


def test_fetch_bytes_curl_nonzero_exit_reports_stderr(monkeypatch):
    _ssl_fail(monkeypatch)
    monkeypatch.setattr(eg.subprocess, "run",
                        lambda *a, **k: SimpleNamespace(returncode=6, stdout=b"", stderr=b" Could not resolve \xff\n"))
    with pytest.raises(RuntimeError, match=r"curl failed for https://x: Could not resolve"):
        eg._fetch_bytes("https://x", 5)


def test_fetch_bytes_curl_non_pdf_output_rejected(monkeypatch):
    _ssl_fail(monkeypatch)
    monkeypatch.setattr(eg.subprocess, "run", lambda *a, **k: SimpleNamespace(returncode=0, stdout=b"<html>", stderr=b""))
    with pytest.raises(RuntimeError, match="curl response is not a PDF"):
        eg._fetch_bytes("https://x", 5)


# ---------------------------------------------------------------- fetch()

def test_fetch_downloads_into_year_subdir_after_delay(tmp_path, monkeypatch, sleeps):
    urls = []
    monkeypatch.setattr(eg, "_fetch_bytes", lambda url, timeout: urls.append((url, timeout)) or PDF)
    out = eg.fetch(GID, out_dir=tmp_path, delay_s=3.5, timeout=44)
    assert out == tmp_path / "2026" / f"{GID}.pdf"
    assert out.read_bytes() == PDF
    assert urls == [("https://egazette.gov.in/WriteReadData/2026/275956.pdf", 44)]
    assert sleeps == [3.5]


def test_fetch_default_delay_and_timeout(tmp_path, monkeypatch, sleeps):
    urls = []
    monkeypatch.setattr(eg, "_fetch_bytes", lambda url, timeout: urls.append(timeout) or PDF)
    eg.fetch(GID, out_dir=str(tmp_path))  # str out_dir accepted
    assert sleeps == [eg.DEFAULT_DELAY_S] == [2.0]
    assert urls == [60.0]


def test_fetch_reuses_cache_without_network_or_sleep(tmp_path, monkeypatch, sleeps):
    dest = tmp_path / "2026" / f"{GID}.pdf"
    dest.parent.mkdir(parents=True)
    dest.write_bytes(b"cached")
    monkeypatch.setattr(eg, "_fetch_bytes", lambda *a: pytest.fail("cache hit must not fetch"))
    assert eg.fetch(GID, out_dir=tmp_path) == dest
    assert dest.read_bytes() == b"cached"
    assert sleeps == []


def test_fetch_refetches_zero_byte_cache_file(tmp_path, monkeypatch, sleeps):
    dest = tmp_path / "2026" / f"{GID}.pdf"
    dest.parent.mkdir(parents=True)
    dest.write_bytes(b"")
    monkeypatch.setattr(eg, "_fetch_bytes", lambda url, timeout: PDF)
    eg.fetch(GID, out_dir=tmp_path)
    assert dest.read_bytes() == PDF


def test_fetch_invalid_id_raises_before_any_io(tmp_path, monkeypatch, sleeps):
    monkeypatch.setattr(eg, "_fetch_bytes", lambda *a: pytest.fail("no fetch"))
    with pytest.raises(ValueError):
        eg.fetch("bogus", out_dir=tmp_path)
    assert sleeps == [] and list(tmp_path.iterdir()) == []


def test_fetch_failure_leaves_no_partial_file(tmp_path, monkeypatch, sleeps):
    def boom(url, timeout):
        raise RuntimeError("net")

    monkeypatch.setattr(eg, "_fetch_bytes", boom)
    with pytest.raises(RuntimeError):
        eg.fetch(GID, out_dir=tmp_path)
    assert not (tmp_path / "2026" / f"{GID}.pdf").exists()


# ---------------------------------------------------------------- main()

def _main(monkeypatch, argv):
    monkeypatch.setattr(sys, "argv", ["egazette", *argv])
    return eg.main()


def test_main_success_prints_path_and_size(tmp_path, monkeypatch, capsys):
    monkeypatch.setattr(eg, "_fetch_bytes", lambda url, timeout: PDF)
    monkeypatch.setattr(eg.time, "sleep", lambda s: None)
    rc = _main(monkeypatch, [GID, "--out", str(tmp_path), "--delay", "0"])
    assert rc == 0
    out, err = capsys.readouterr()
    assert out.strip() == f"{GID}: {tmp_path / '2026' / (GID + '.pdf')} ({len(PDF)} bytes)"
    assert err == ""


def test_main_passes_delay_to_fetch(tmp_path, monkeypatch):
    seen = []
    monkeypatch.setattr(eg, "fetch", lambda gid, out_dir, delay_s: seen.append((gid, out_dir, delay_s)) or tmp_path / "x.pdf")
    monkeypatch.setattr(sys, "argv", ["egazette", GID, "--out", "o", "--delay", "0.25"])
    # path.stat() on a missing file would fail; make it exist
    (tmp_path / "x.pdf").write_bytes(b"1")
    assert eg.main() == 0
    assert seen == [(GID, "o", 0.25)]


def test_main_failure_isolated_per_id_and_returns_1(tmp_path, monkeypatch, capsys):
    good = "CG-DL-E-04092026-111111"

    def fake_fetch(gid, out_dir, delay_s):
        if gid == GID:
            raise RuntimeError("blocked")
        p = tmp_path / "ok.pdf"
        p.write_bytes(b"12345")
        return p

    monkeypatch.setattr(eg, "fetch", fake_fetch)
    rc = _main(monkeypatch, [GID, good])
    out, err = capsys.readouterr()
    assert rc == 1
    assert f"{GID}: FAILED — blocked" in err
    assert f"{good}: {tmp_path / 'ok.pdf'} (5 bytes)" in out


def test_main_extract_writes_markdown_with_front_matter(tmp_path, monkeypatch, capsys):
    pdf = tmp_path / "a.pdf"
    pdf.write_bytes(PDF)
    monkeypatch.setattr(eg, "fetch", lambda gid, out_dir, delay_s: pdf)
    import ingest.pdf_text as pt

    monkeypatch.setattr(pt, "extract_text", lambda p: "BODY TEXT")
    monkeypatch.chdir(tmp_path)
    rc = _main(monkeypatch, [GID, "--extract"])
    assert rc == 0
    md = (tmp_path / "data" / "raw_md" / f"{GID}.md").read_text()
    assert md == (f"---\nsource_url: https://egazette.gov.in/WriteReadData/2026/275956.pdf\ngazette_id: {GID}\n"
                  "extraction_method: ingest.pdf_text (PyMuPDF)\n---\n\nBODY TEXT")
    assert f"{GID}: extracted -> " in capsys.readouterr().out


def test_main_extract_scanned_pdf_returns_2_and_reports_ocr(tmp_path, monkeypatch, capsys):
    pdf = tmp_path / "a.pdf"
    pdf.write_bytes(PDF)
    monkeypatch.setattr(eg, "fetch", lambda gid, out_dir, delay_s: pdf)
    import ingest.pdf_text as pt

    def scanned(p):
        raise pt.LikelyScannedError("looks scanned")

    monkeypatch.setattr(pt, "extract_text", scanned)
    # fake module: the real one prepends the user's home dir to sys.path on import
    monkeypatch.setitem(sys.modules, "ingest.ocr_fallback", SimpleNamespace(ocr_status=lambda: "not_configured"))
    monkeypatch.chdir(tmp_path)
    rc = _main(monkeypatch, [GID, "--extract"])
    assert rc == 2
    err = capsys.readouterr().err
    assert f"{GID}: needs OCR (looks scanned); ocr endpoint: not_configured" in err
    assert not (tmp_path / "data" / "raw_md" / f"{GID}.md").exists()


def test_main_without_extract_never_touches_pdf_text(tmp_path, monkeypatch):
    pdf = tmp_path / "a.pdf"
    pdf.write_bytes(PDF)
    monkeypatch.setattr(eg, "fetch", lambda gid, out_dir, delay_s: pdf)
    monkeypatch.chdir(tmp_path)
    _main(monkeypatch, [GID])
    assert not (tmp_path / "data").exists()


def test_main_scanned_does_not_mask_earlier_failure_rc(tmp_path, monkeypatch):
    # first id fails (rc=1), second is scanned (rc=2): final rc is the last assignment (2)
    pdf = tmp_path / "a.pdf"
    pdf.write_bytes(PDF)
    other = "CG-DL-E-04092026-222222"

    def fake_fetch(gid, out_dir, delay_s):
        if gid == GID:
            raise RuntimeError("x")
        return pdf

    monkeypatch.setattr(eg, "fetch", fake_fetch)
    import ingest.pdf_text as pt

    monkeypatch.setattr(pt, "extract_text", lambda p: (_ for _ in ()).throw(pt.LikelyScannedError("s")))
    monkeypatch.setitem(sys.modules, "ingest.ocr_fallback", SimpleNamespace(ocr_status=lambda: "ready"))
    monkeypatch.chdir(tmp_path)
    assert _main(monkeypatch, [GID, other, "--extract"]) == 2
