"""Characterisation tests for render.translate's three HTTP backends.

All network access is replaced by a fake urlopen; time.sleep is recorded
instead of executed. No live request is ever made.
"""
import io
import json
import urllib.error

import pytest

from render import translate as T


class _Resp(io.BytesIO):
    def __enter__(self):
        return self

    def __exit__(self, *a):
        return False


def _http_error(code):
    return urllib.error.HTTPError("http://x", code, "err", {}, io.BytesIO(b""))


@pytest.fixture
def net(monkeypatch):
    """Script a sequence of outcomes (bytes body or exception) for urlopen."""
    state = {"script": [], "calls": [], "sleeps": []}

    def fake_urlopen(req, timeout=None):
        state["calls"].append((req.full_url, json.loads(req.data), timeout))
        item = state["script"].pop(0)
        if isinstance(item, Exception):
            raise item
        return _Resp(json.dumps(item).encode())

    monkeypatch.setattr(T.urllib.request, "urlopen", fake_urlopen)
    monkeypatch.setattr(T.time, "sleep", lambda s: state["sleeps"].append(s))
    return state


GEMINI_OK = {"candidates": [{"content": {"parts": [{"text": " नमस्ते \n"}]}}]}
REC = {"gazette_id": "g1", "ministry": "Ministry of Power", "summary": "s", "thread": ""}


def test_gemini_success_and_record_shape(net):
    net["script"] = [GEMINI_OK, GEMINI_OK]
    out = T.translate_record(REC, lang="hi", api_key="k", fields=("ministry", "summary", "thread"))
    assert out["lang"] == "hi" and out["gazette_id"] == "g1"
    assert out["ministry"] == "नमस्ते" and out["ministry_en"] == "Ministry of Power"
    assert out["summary"] == "नमस्ते" and out["summary_en"] == "s"
    assert out["thread"] == "" and "thread_en" not in out  # empty field skipped
    assert "key=k" in net["calls"][0][0] and "gemini-flash-latest" in net["calls"][0][0]
    assert "Hindi" in net["calls"][0][1]["contents"][0]["parts"][0]["text"]


def test_gemini_retries_429_then_succeeds_with_backoff(net):
    net["script"] = [_http_error(429), _http_error(503), GEMINI_OK]
    assert T._translate_text("x", "Hindi", "k", "m") == "नमस्ते"
    assert net["sleeps"] == [2, 4]


def test_gemini_non_transient_http_error_raises_immediately(net):
    net["script"] = [_http_error(400)]
    with pytest.raises(urllib.error.HTTPError):
        T._translate_text("x", "Hindi", "k", "m")
    assert net["sleeps"] == []


def test_gemini_exhausted_retries_raise_timeout(net):
    net["script"] = [_http_error(429)] * 4
    with pytest.raises(TimeoutError, match="Gemini call failed after 4 attempts"):
        T._translate_text("x", "Hindi", "k", "m")
    assert net["sleeps"] == [2, 4, 8]


def test_gemini_urlerror_retries_without_sleeping(net):
    net["script"] = [urllib.error.URLError("down"), GEMINI_OK]
    assert T._translate_text("x", "Hindi", "k", "m") == "नमस्ते"
    assert net["sleeps"] == []


def test_libretranslate_success_and_validation(net):
    net["script"] = [{"translatedText": " hola "}]
    out = T.translate_record_libretranslate(REC, "es", url="http://h:1/", fields=("summary",))
    assert out["summary"] == "hola" and out["summary_en"] == "s" and out["lang"] == "es"
    assert net["calls"][0][0] == "http://h:1/translate"
    assert net["calls"][0][1] == {"q": "s", "source": "en", "target": "es", "format": "text"}
    with pytest.raises(ValueError):
        T.translate_record_libretranslate(REC, "ta")


def test_libretranslate_retries_any_error_then_raises(net):
    net["script"] = [_http_error(400)] * 4
    with pytest.raises(TimeoutError, match="LibreTranslate call failed after 4 attempts"):
        T._translate_text_libretranslate("x", "es", "http://h")
    assert net["sleeps"] == [2, 4, 8]


def test_krutrim_success_and_flores_code(net):
    net["script"] = [{"translation": " வணக்கம் "}]
    out = T.translate_record_krutrim(REC, "ta", url="http://k", fields=("summary",))
    assert out["summary"] == "வணக்கம்"
    assert net["calls"][0][1] == {"text": "s", "tgt_lang": "tam_Taml"}
    with pytest.raises(ValueError):
        T.translate_record_krutrim(REC, "fr")


def test_krutrim_timeout_then_success(net):
    net["script"] = [TimeoutError(), {"translation": "ok"}]
    assert T._translate_text_krutrim("x", "tam_Taml", "http://k") == "ok"
    assert net["sleeps"] == [2]


def test_auto_dispatch_and_resolve_backend():
    assert T.resolve_backend("hi") == "krutrim"
    assert T.resolve_backend("fr") == "libretranslate"
    assert T.resolve_backend("sa") == "gemini"
    with pytest.raises(ValueError):
        T.resolve_backend("xx")


def test_read_credential_env_then_file(tmp_path, monkeypatch):
    from ingest.credentials import read_credential

    f = tmp_path / "creds.env"
    f.write_text("A_KEY= from-file \nOTHER=x\n")
    monkeypatch.delenv("A_KEY", raising=False)
    assert read_credential("A_KEY", str(f)) == "from-file"
    monkeypatch.setenv("A_KEY", "from-env")
    assert read_credential("A_KEY", str(f)) == "from-env"
    assert read_credential("MISSING_KEY_XYZ", str(f)) is None
    assert read_credential("MISSING_KEY_XYZ", str(tmp_path / "nope")) is None
