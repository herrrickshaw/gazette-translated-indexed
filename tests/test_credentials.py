"""ingest.credentials.read_credential: env first, then a name=value line in the store."""
import os

from ingest import credentials as cr


def _store(tmp_path, text):
    p = tmp_path / "credentials.env"
    p.write_text(text, encoding="utf-8")
    return str(p)


def test_env_wins_over_file(tmp_path, monkeypatch):
    monkeypatch.setenv("GZ_KEY", "from-env")
    assert cr.read_credential("GZ_KEY", _store(tmp_path, "GZ_KEY=from-file\n")) == "from-env"


def test_empty_env_value_falls_through_to_file(tmp_path, monkeypatch):
    monkeypatch.setenv("GZ_KEY", "")
    assert cr.read_credential("GZ_KEY", _store(tmp_path, "GZ_KEY=from-file\n")) == "from-file"


def test_file_value_is_stripped_and_split_on_first_equals_only(tmp_path, monkeypatch):
    monkeypatch.delenv("GZ_KEY", raising=False)
    assert cr.read_credential("GZ_KEY", _store(tmp_path, "GZ_KEY =x\nGZ_KEY=  a=b==c \n")) == "a=b==c"


def test_prefix_of_another_name_does_not_match(tmp_path, monkeypatch):
    monkeypatch.delenv("GZ_KEY", raising=False)
    assert cr.read_credential("GZ_KEY", _store(tmp_path, "GZ_KEY_2=nope\nXGZ_KEY=nope\n")) is None


def test_first_matching_line_wins(tmp_path, monkeypatch):
    monkeypatch.delenv("GZ_KEY", raising=False)
    assert cr.read_credential("GZ_KEY", _store(tmp_path, "GZ_KEY=one\nGZ_KEY=two\n")) == "one"


def test_missing_file_and_missing_key_give_none(tmp_path, monkeypatch):
    monkeypatch.delenv("GZ_KEY", raising=False)
    assert cr.read_credential("GZ_KEY", str(tmp_path / "absent.env")) is None
    assert cr.read_credential("GZ_KEY", _store(tmp_path, "OTHER=1\n")) is None


def test_empty_value_in_file_is_returned_as_empty_string(tmp_path, monkeypatch):
    monkeypatch.delenv("GZ_KEY", raising=False)
    assert cr.read_credential("GZ_KEY", _store(tmp_path, "GZ_KEY=\n")) == ""


def test_default_store_path_is_user_config_and_used_when_not_given(tmp_path, monkeypatch):
    assert cr.CREDENTIALS_FILE == os.path.expanduser("~/.config/market-secrets/credentials.env")
    monkeypatch.delenv("GZ_KEY", raising=False)
    monkeypatch.setattr(cr, "CREDENTIALS_FILE", _store(tmp_path, "GZ_KEY=default-store\n"))
    assert cr.read_credential("GZ_KEY") == "default-store"
