"""ingest.ocr_fallback with a fake ~/ocr client (the real one is an opt-in remote
GPU service). The module is imported fresh under a controlled sys.modules and
everything it touches (sys.modules, sys.path, the ingest package attribute)
is restored afterwards."""
import importlib
import sys
from pathlib import Path
from types import ModuleType

import pytest

import ingest


@pytest.fixture
def load(monkeypatch):
    saved_mod = sys.modules.get("ingest.ocr_fallback")
    saved_attr = getattr(ingest, "ocr_fallback", None)
    monkeypatch.setattr(sys, "path", list(sys.path))

    def _load(client=None):
        sys.modules.pop("ingest.ocr_fallback", None)
        if client is None:
            monkeypatch.setitem(sys.modules, "ocr", None)  # None => ImportError on import
            monkeypatch.setitem(sys.modules, "ocr.unlimited_ocr", None)
        else:
            pkg = ModuleType("ocr")
            pkg.__path__ = []
            monkeypatch.setitem(sys.modules, "ocr", pkg)
            monkeypatch.setitem(sys.modules, "ocr.unlimited_ocr", client)
        return importlib.import_module("ingest.ocr_fallback")

    yield _load
    sys.modules.pop("ingest.ocr_fallback", None)
    if saved_mod is not None:
        sys.modules["ingest.ocr_fallback"] = saved_mod
    if saved_attr is not None:
        ingest.ocr_fallback = saved_attr
    elif hasattr(ingest, "ocr_fallback"):
        del ingest.ocr_fallback


def client(configured=True, up=True, text="TRANSCRIPT"):
    m = ModuleType("ocr.unlimited_ocr")
    m.calls = []
    m.is_configured = lambda: configured
    m.ping = lambda timeout=10.0: up
    m.ocr_pdf = lambda path: m.calls.append(path) or text
    return m


def test_home_dir_is_put_first_on_sys_path(load):
    load(client())
    assert sys.path[0] == str(Path.home())


def test_status_not_configured_wins_over_ping(load):
    mod = load(client(configured=False, up=True))
    assert mod.ocr_status() == "not_configured"


def test_status_endpoint_down_when_configured_but_unreachable(load):
    assert load(client(configured=True, up=False)).ocr_status() == "endpoint_down"


def test_status_ready(load):
    assert load(client()).ocr_status() == "ready"


def test_import_failure_degrades_to_not_configured(load):
    mod = load(None)
    assert mod.ocr_pdf is None
    assert mod.is_configured() is False
    assert mod.ping() is False
    assert mod.ocr_status() == "not_configured"
    assert mod.try_ocr("x.pdf") == (None, "not_configured")


def test_try_ocr_returns_transcript_and_passes_path(load):
    c = client(text="HELLO")
    mod = load(c)
    assert mod.try_ocr("a.pdf") == ("HELLO", "ready")
    assert c.calls == ["a.pdf"]


@pytest.mark.parametrize("configured,up,status", [(False, True, "not_configured"), (True, False, "endpoint_down")])
def test_try_ocr_does_not_call_ocr_when_not_ready(load, configured, up, status):
    c = client(configured=configured, up=up)
    mod = load(c)
    assert mod.try_ocr("a.pdf") == (None, status)
    assert c.calls == []


def test_main_usage(load, monkeypatch, capsys):
    mod = load(client())
    monkeypatch.setattr(sys, "argv", ["ocr_fallback"])
    assert mod.main() == 1
    assert "usage: python3 -m ingest.ocr_fallback <file.pdf>" in capsys.readouterr().err
    monkeypatch.setattr(sys, "argv", ["ocr_fallback", "a", "b"])
    assert mod.main() == 1


def test_main_prints_transcript(load, monkeypatch, capsys):
    mod = load(client(text="line1\nline2"))
    monkeypatch.setattr(sys, "argv", ["ocr_fallback", "a.pdf"])
    assert mod.main() == 0
    out, err = capsys.readouterr()
    assert out == "line1\nline2\n" and err == ""


def test_main_reports_skip_status_and_returns_2(load, monkeypatch, capsys):
    mod = load(client(up=False))
    monkeypatch.setattr(sys, "argv", ["ocr_fallback", "a.pdf"])
    assert mod.main() == 2
    out, err = capsys.readouterr()
    assert out == "" and err == "OCR skipped: endpoint_down\n"


def test_empty_transcript_is_printed_not_treated_as_skip(load, monkeypatch, capsys):
    # an empty string is a real (if useless) transcript; only None means "skipped"
    mod = load(client(text=""))
    monkeypatch.setattr(sys, "argv", ["ocr_fallback", "a.pdf"])
    assert mod.main() == 0
    assert capsys.readouterr().out == "\n"
