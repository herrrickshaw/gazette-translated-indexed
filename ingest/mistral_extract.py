"""
Mistral-based citation-candidate extractor for gazette notification text.

Purpose: for any future research pass on this project (a freshness update,
a new ministry, one of the 3 abandoned ministries if the schema ever grows
a new citation form), most of a research agent's token cost is spent
reading pages that turn out to have no real citation at all, or restating
a citation an LLM only needs to *locate*, not *judge*. This script uses
Mistral to do that first mechanical pass: given cleaned notification text,
propose candidate (relation, target number, target date, quoted sentence)
tuples. Three backends, in this preference order when "auto":

1. **colab** -- Ollama running on a Colab T4 GPU, tunneled via Cloudflare
   (notebooks/serve_mistral_colab.ipynb). ~2-10s/page vs ~45-60s/page on Mac
   CPU. Same standard already used in this environment for GPU work (see
   ~/ocr/serve/serve_unlimited_ocr_colab.ipynb) -- opt-in, never blocks: if
   the tunnel isn't up this falls through to local instead of failing.
2. **local** -- Ollama on this machine (`ollama pull mistral`, ~4.1GB
   one-time). Always available once pulled, just slow on CPU.
3. **cloud** -- the Mistral API, if MISTRAL_API_KEY is set. Requested last
   in "auto" order only because the key already in this account's
   credential store is shared with another automated process and has been
   consistently rate-limited (HTTP 429) in testing -- pass
   `--backend cloud` explicitly if you have a dedicated key.

This is a CANDIDATE generator, not a verifier. Every candidate must still
be checked against the primary source before it goes into a seed file --
same discipline as extract/cross_ref.py's regex candidates, just from a
model instead of a pattern. Never write a candidate straight to a
gazette_notification/cross_reference row.

Usage:
    python3 -m ingest.mistral_extract path/to/trafilatura_output.txt
    echo "$TEXT" | python3 -m ingest.mistral_extract -
    python3 -m ingest.mistral_extract --backend local path/to/file.txt
    python3 -m ingest.mistral_extract --backend colab path/to/file.txt

MISTRAL_API_KEY and MISTRAL_COLAB_URL are read from the environment, or
from the canonical credential store
(~/.config/market-secrets/credentials.env) if not already exported --
never printed, read line-by-line for just the one key needed.
"""
from __future__ import annotations

import json
import os
import sys
import urllib.request

OLLAMA_PATH = "/api/generate"
LOCAL_OLLAMA_URL = "http://127.0.0.1:11434"
MISTRAL_API_URL = "https://api.mistral.ai/v1/chat/completions"
OLLAMA_MODEL = "mistral"
MISTRAL_CLOUD_MODEL = "mistral-small-latest"
CREDENTIALS_FILE = os.path.expanduser("~/.config/market-secrets/credentials.env")

RELATION_TYPES = ("amends", "supersedes", "corrigendum", "rescinds", "repeals", "cites")


def _read_credential(name: str) -> str | None:
    value = os.environ.get(name)
    if value:
        return value
    if os.path.exists(CREDENTIALS_FILE):
        with open(CREDENTIALS_FILE, encoding="utf-8") as f:
            for line in f:
                if line.startswith(f"{name}="):
                    return line.split("=", 1)[1].strip()
    return None


def _load_api_key() -> str | None:
    return _read_credential("MISTRAL_API_KEY")


def is_colab_configured() -> bool:
    return bool(_read_credential("MISTRAL_COLAB_URL"))


def colab_status(timeout: float = 5.0) -> str:
    """One of: 'not_configured', 'endpoint_down', 'ready'. Never raises."""
    url = _read_credential("MISTRAL_COLAB_URL")
    if not url:
        return "not_configured"
    try:
        with urllib.request.urlopen(f"{url.rstrip('/')}/api/tags", timeout=timeout):
            return "ready"
    except Exception:
        return "endpoint_down"

PROMPT_TEMPLATE = """You are extracting citation candidates from an Indian government gazette notification's text. Find every place where THIS notification names another notification by its own S.O./G.S.R./S.R.O. number and/or date (a citation naming only a title, an Act name, or a file number without a G.S.R./S.O./S.R.O. is NOT a candidate -- skip it).

For each real number-or-date citation found, output one JSON object with these fields:
- "relation": one of {relations}
- "target_number": the cited number exactly as printed (e.g. "S.O. 274(E)", "G.S.R. 128(E)"), or null if only a date is given
- "target_date": the cited date in the text's own words (e.g. "28th February, 2004"), or null if not given
- "quote": the exact sentence containing the citation, verbatim, no paraphrasing

Output ONLY a JSON array of these objects, nothing else. If there are no real citations, output [].

TEXT:
---
{text}
---

JSON array:"""


def _parse_response(raw: str) -> list[dict]:
    raw = raw.strip()
    try:
        candidates = json.loads(raw)
    except json.JSONDecodeError:
        # model sometimes wraps the array in prose despite format=json; take the first [...] block
        start, end = raw.find("["), raw.rfind("]")
        candidates = json.loads(raw[start : end + 1]) if start != -1 and end != -1 else []
    if isinstance(candidates, dict):
        # JSON-mode models sometimes wrap the array under an arbitrary key
        # ("candidates", "data", "results", ...) instead of returning it bare.
        list_values = [v for v in candidates.values() if isinstance(v, list)]
        candidates = list_values[0] if list_values else []
    if not isinstance(candidates, list):
        candidates = []
    return [c for c in candidates if isinstance(c, dict) and c.get("relation") in RELATION_TYPES]


def extract_candidates_ollama(text: str, base_url: str, timeout: int = 120) -> list[dict]:
    """Call an Ollama-compatible server (local or Colab-tunneled); unverified candidates."""
    prompt = PROMPT_TEMPLATE.format(relations=list(RELATION_TYPES), text=text.strip()[:12000])
    payload = json.dumps({
        "model": OLLAMA_MODEL,
        "prompt": prompt,
        "stream": False,
        "format": "json",
        "options": {"temperature": 0.0},
    }).encode()
    req = urllib.request.Request(
        f"{base_url.rstrip('/')}{OLLAMA_PATH}", data=payload, headers={"Content-Type": "application/json"}
    )
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        body = json.loads(resp.read())
    return _parse_response(body.get("response", "[]"))


def extract_candidates_local(text: str, timeout: int = 120) -> list[dict]:
    return extract_candidates_ollama(text, LOCAL_OLLAMA_URL, timeout=timeout)


def extract_candidates_colab(text: str, timeout: int = 60) -> list[dict]:
    """Call the Colab-tunneled Ollama endpoint. Raises if not configured/reachable --
    callers should check colab_status() first and fall through, same as ocr_fallback."""
    url = _read_credential("MISTRAL_COLAB_URL")
    if not url:
        raise SystemExit("MISTRAL_COLAB_URL not found in environment or credential store")
    return extract_candidates_ollama(text, url, timeout=timeout)


def extract_candidates_cloud(text: str, api_key: str, timeout: int = 60) -> list[dict]:
    """Call the Mistral cloud API; return a list of candidate dicts (unverified)."""
    prompt = PROMPT_TEMPLATE.format(relations=list(RELATION_TYPES), text=text.strip()[:12000])
    payload = json.dumps({
        "model": MISTRAL_CLOUD_MODEL,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.0,
        "response_format": {"type": "json_object"},
    }).encode()
    req = urllib.request.Request(
        MISTRAL_API_URL,
        data=payload,
        headers={"Content-Type": "application/json", "Authorization": f"Bearer {api_key}"},
    )
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        body = json.loads(resp.read())
    content = body["choices"][0]["message"]["content"]
    return _parse_response(content)


def extract_candidates(text: str, backend: str = "auto") -> list[dict]:
    if backend == "colab":
        return extract_candidates_colab(text)
    if backend == "cloud":
        key = _load_api_key()
        if not key:
            raise SystemExit("MISTRAL_API_KEY not found in environment or credential store")
        return extract_candidates_cloud(text, key)
    if backend == "local":
        return extract_candidates_local(text)
    # auto: colab (fastest, GPU) if up -> local (always works once pulled) -> cloud last
    # (deprioritized: the stored key is shared with another process and gets rate-limited)
    if colab_status() == "ready":
        return extract_candidates_colab(text)
    try:
        return extract_candidates_local(text)
    except Exception:
        key = _load_api_key()
        if key:
            return extract_candidates_cloud(text, key)
        raise


def main() -> None:
    args = sys.argv[1:]
    backend = "auto"
    if args and args[0] == "--backend":
        backend = args[1]
        args = args[2:]
    if len(args) != 1:
        print(__doc__)
        raise SystemExit(1)
    src = args[0]
    text = sys.stdin.read() if src == "-" else open(src, encoding="utf-8").read()
    candidates = extract_candidates(text, backend=backend)
    print(json.dumps(candidates, indent=2, ensure_ascii=False))
    print(f"\n{len(candidates)} candidate(s) -- UNVERIFIED, check each against primary text before modeling.", file=sys.stderr)


if __name__ == "__main__":
    main()
