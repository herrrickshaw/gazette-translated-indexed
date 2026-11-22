"""ingest.mistral_extract: response parsing, the three backends and the 'auto'
fallback order. urlopen and the credential store are faked."""
import io
import json
import sys
import urllib.error

import pytest

from ingest import mistral_extract as me

GOOD = {"relation": "amends", "target_number": "S.O. 1(E)", "target_date": None, "quote": "q"}


class Resp(io.BytesIO):
    def __enter__(self):
        return self

    def __exit__(self, *a):
        return False


@pytest.fixture
def creds(monkeypatch):
    store = {}
    monkeypatch.setattr(me, "_read_credential", lambda name: store.get(name))
    return store


@pytest.fixture
def net(monkeypatch):
    state = {"script": [], "calls": []}

    def fake_urlopen(req_or_url, timeout=None):
        state["calls"].append((req_or_url, timeout))
        item = state["script"].pop(0)
        if isinstance(item, Exception):
            raise item
        return Resp(json.dumps(item).encode())

    monkeypatch.setattr(me.urllib.request, "urlopen", fake_urlopen)
    return state


# ------------------------------------------------------------- _parse_response

def test_parse_plain_array_keeps_only_known_relations_and_dicts():
    raw = json.dumps([GOOD, {"relation": "bogus"}, {"no_relation": 1}, "str", 3, None,
                      {"relation": "cites"}])
    assert [c["relation"] for c in me._parse_response(raw)] == ["amends", "cites"]


@pytest.mark.parametrize("rel", me.RELATION_TYPES)
def test_every_relation_type_accepted(rel):
    assert me._parse_response(json.dumps([{"relation": rel}])) == [{"relation": rel}]


def test_relation_type_tuple_is_exact():
    assert me.RELATION_TYPES == ("amends", "supersedes", "corrigendum", "rescinds", "repeals", "cites")


def test_parse_strips_whitespace():
    assert me._parse_response("  \n" + json.dumps([GOOD]) + "\n ") == [GOOD]


def test_parse_dict_wrapper_takes_first_list_value():
    raw = json.dumps({"note": "x", "candidates": [GOOD], "other": [{"relation": "cites"}]})
    assert me._parse_response(raw) == [GOOD]


def test_parse_dict_without_lists_gives_empty():
    assert me._parse_response(json.dumps({"a": 1, "b": "x"})) == []


def test_parse_empty_object_and_empty_array():
    assert me._parse_response("{}") == []
    assert me._parse_response("[]") == []


def test_parse_scalar_json_gives_empty():
    assert me._parse_response("42") == []
    assert me._parse_response('"text"') == []
    assert me._parse_response("null") == []


def test_parse_recovers_array_wrapped_in_prose():
    raw = "Sure! Here you go:\n" + json.dumps([GOOD]) + "\nHope that helps."
    assert me._parse_response(raw) == [GOOD]


def test_parse_prose_without_brackets_gives_empty():
    assert me._parse_response("no citations found") == []


def test_parse_only_closing_bracket_before_opening_is_not_sliced():
    # find('[') == -1 -> []
    assert me._parse_response("oops ]") == []


def test_parse_malformed_bracketed_block_raises_json_error():
    with pytest.raises(json.JSONDecodeError):
        me._parse_response("x [ not json ] y")


# ------------------------------------------------------------- credentials / colab

def test_is_colab_configured_reflects_credential(creds):
    assert me.is_colab_configured() is False
    creds["MISTRAL_COLAB_URL"] = "https://x"
    assert me.is_colab_configured() is True


def test_load_api_key(creds):
    assert me._load_api_key() is None
    creds["MISTRAL_API_KEY"] = "k"
    assert me._load_api_key() == "k"


def test_colab_status_not_configured_makes_no_request(creds, net):
    assert me.colab_status() == "not_configured"
    assert net["calls"] == []


def test_colab_status_ready_probes_api_tags_with_timeout(creds, net):
    creds["MISTRAL_COLAB_URL"] = "https://t.example/"
    net["script"] = [{}]
    assert me.colab_status(timeout=2.5) == "ready"
    assert net["calls"] == [("https://t.example/api/tags", 2.5)]


def test_colab_status_endpoint_down_on_any_exception(creds, net):
    creds["MISTRAL_COLAB_URL"] = "https://t.example"
    net["script"] = [urllib.error.URLError("refused")]
    assert me.colab_status() == "endpoint_down"
    net["script"] = [ValueError("weird")]
    assert me.colab_status() == "endpoint_down"


# ------------------------------------------------------------- backends

def test_ollama_request_shape_and_text_truncation(net):
    net["script"] = [{"response": json.dumps([GOOD])}]
    long_text = "  " + "a" * 13000
    out = me.extract_candidates_ollama(long_text, "http://h:1/", timeout=7)
    assert out == [GOOD]
    req, timeout = net["calls"][0]
    assert req.full_url == "http://h:1/api/generate" and timeout == 7
    assert req.headers["Content-type"] == "application/json"
    body = json.loads(req.data)
    assert body["model"] == "mistral" and body["stream"] is False and body["format"] == "json"
    assert body["options"] == {"temperature": 0.0}
    assert "a" * 12000 in body["prompt"] and "a" * 12001 not in body["prompt"]  # stripped then cut at 12000
    assert str(list(me.RELATION_TYPES)) in body["prompt"]
    assert body["prompt"].rstrip().endswith("JSON array:")


def test_ollama_missing_response_key_defaults_to_empty(net):
    net["script"] = [{}]
    assert me.extract_candidates_ollama("t", "http://h") == []


def test_local_uses_localhost_ollama_and_default_timeout(net):
    net["script"] = [{"response": "[]"}]
    assert me.extract_candidates_local("t") == []
    req, timeout = net["calls"][0]
    assert req.full_url == "http://127.0.0.1:11434/api/generate" and timeout == 120


def test_colab_requires_configured_url(creds):
    with pytest.raises(SystemExit, match="MISTRAL_COLAB_URL"):
        me.extract_candidates_colab("t")


def test_colab_posts_to_configured_url_with_60s_timeout(creds, net):
    creds["MISTRAL_COLAB_URL"] = "https://t.example"
    net["script"] = [{"response": json.dumps([GOOD])}]
    assert me.extract_candidates_colab("t") == [GOOD]
    req, timeout = net["calls"][0]
    assert req.full_url == "https://t.example/api/generate" and timeout == 60


def test_cloud_request_shape_and_parsing(net):
    net["script"] = [{"choices": [{"message": {"content": json.dumps({"results": [GOOD]})}}]}]
    assert me.extract_candidates_cloud("hello", "KEY", timeout=9) == [GOOD]
    req, timeout = net["calls"][0]
    assert req.full_url == me.MISTRAL_API_URL and timeout == 9
    assert req.headers["Authorization"] == "Bearer KEY"
    body = json.loads(req.data)
    assert body["model"] == "mistral-small-latest" and body["temperature"] == 0.0
    assert body["response_format"] == {"type": "json_object"}
    assert body["messages"][0]["role"] == "user" and "hello" in body["messages"][0]["content"]


def test_cloud_default_timeout_is_60(net):
    net["script"] = [{"choices": [{"message": {"content": "[]"}}]}]
    me.extract_candidates_cloud("t", "k")
    assert net["calls"][0][1] == 60


# ------------------------------------------------------------- dispatch

def _stub_backends(monkeypatch, **fns):
    calls = []
    for name in ("colab", "local", "cloud"):
        def f(*a, _n=name, **k):
            calls.append((_n, a))
            r = fns.get(_n, [])
            if isinstance(r, Exception):
                raise r
            return r
        monkeypatch.setattr(me, f"extract_candidates_{name}", f)
    return calls


def test_explicit_colab_and_local_skip_status_checks(monkeypatch, creds):
    calls = _stub_backends(monkeypatch, colab=[GOOD], local=[GOOD, GOOD])
    monkeypatch.setattr(me, "colab_status", lambda *a, **k: pytest.fail("status not consulted"))
    assert me.extract_candidates("t", backend="colab") == [GOOD]
    assert len(me.extract_candidates("t", backend="local")) == 2
    assert [c[0] for c in calls] == ["colab", "local"]


def test_explicit_cloud_needs_key(monkeypatch, creds):
    _stub_backends(monkeypatch)
    with pytest.raises(SystemExit, match="MISTRAL_API_KEY"):
        me.extract_candidates("t", backend="cloud")


def test_explicit_cloud_passes_key(monkeypatch, creds):
    creds["MISTRAL_API_KEY"] = "KEY"
    calls = _stub_backends(monkeypatch, cloud=[GOOD])
    assert me.extract_candidates("txt", backend="cloud") == [GOOD]
    assert calls == [("cloud", ("txt", "KEY"))]


def test_auto_prefers_colab_when_ready(monkeypatch, creds):
    monkeypatch.setattr(me, "colab_status", lambda: "ready")
    calls = _stub_backends(monkeypatch, colab=[GOOD])
    assert me.extract_candidates("t") == [GOOD]
    assert [c[0] for c in calls] == ["colab"]


@pytest.mark.parametrize("status", ["not_configured", "endpoint_down"])
def test_auto_falls_to_local_when_colab_not_ready(monkeypatch, creds, status):
    monkeypatch.setattr(me, "colab_status", lambda: status)
    calls = _stub_backends(monkeypatch, local=[GOOD])
    assert me.extract_candidates("t") == [GOOD]
    assert [c[0] for c in calls] == ["local"]


def test_auto_falls_to_cloud_when_local_fails_and_key_present(monkeypatch, creds):
    monkeypatch.setattr(me, "colab_status", lambda: "not_configured")
    creds["MISTRAL_API_KEY"] = "KEY"
    calls = _stub_backends(monkeypatch, local=urllib.error.URLError("no ollama"), cloud=[GOOD])
    assert me.extract_candidates("t") == [GOOD]
    assert [c[0] for c in calls] == ["local", "cloud"]


def test_auto_reraises_local_error_without_key(monkeypatch, creds):
    monkeypatch.setattr(me, "colab_status", lambda: "not_configured")
    calls = _stub_backends(monkeypatch, local=urllib.error.URLError("no ollama"))
    with pytest.raises(urllib.error.URLError, match="no ollama"):
        me.extract_candidates("t")
    assert [c[0] for c in calls] == ["local"]


def test_unknown_backend_behaves_like_auto(monkeypatch, creds):
    monkeypatch.setattr(me, "colab_status", lambda: "not_configured")
    calls = _stub_backends(monkeypatch, local=[GOOD])
    assert me.extract_candidates("t", backend="whatever") == [GOOD]
    assert [c[0] for c in calls] == ["local"]


# ------------------------------------------------------------- main

def test_main_reads_file_and_prints_json_and_count(monkeypatch, tmp_path, capsys):
    f = tmp_path / "in.txt"
    f.write_text("नमस्ते text", encoding="utf-8")
    seen = []
    monkeypatch.setattr(me, "extract_candidates", lambda text, backend: seen.append((text, backend)) or [dict(GOOD, quote="नमस्ते")])
    monkeypatch.setattr(sys, "argv", ["me", str(f)])
    me.main()
    out, err = capsys.readouterr()
    assert seen == [("नमस्ते text", "auto")]
    assert json.loads(out) == [dict(GOOD, quote="नमस्ते")] and "नमस्ते" in out  # ensure_ascii=False
    assert "1 candidate(s) -- UNVERIFIED" in err


def test_main_backend_flag_and_stdin(monkeypatch, capsys):
    seen = []
    monkeypatch.setattr(me, "extract_candidates", lambda text, backend: seen.append((text, backend)) or [])
    monkeypatch.setattr(sys, "stdin", io.StringIO("from stdin"))
    monkeypatch.setattr(sys, "argv", ["me", "--backend", "local", "-"])
    me.main()
    assert seen == [("from stdin", "local")]
    assert "0 candidate(s)" in capsys.readouterr().err


@pytest.mark.parametrize("argv", [[], ["a", "b"], ["--backend", "local"]])
def test_main_usage_exits_1(monkeypatch, capsys, argv):
    monkeypatch.setattr(sys, "argv", ["me", *argv])
    with pytest.raises(SystemExit) as ei:
        me.main()
    assert ei.value.code == 1
    assert "Mistral-based citation-candidate extractor" in capsys.readouterr().out
