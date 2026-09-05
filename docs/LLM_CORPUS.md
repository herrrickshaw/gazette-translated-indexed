# The LLM corpus

`render/llm_export.py` projects the citation graph as a JSONL file, one
notification per line, meant to be read by an LLM or ingested into a
RAG/retrieval system rather than queried relationally. It's a read-only view
of `gazette.db` — nothing in this file is a new source of truth, and nothing
written here gets read back into the database.

## Why this exists, separately from the database

`schema.sql` and `db/crud.py` are relational and built for exact lookups and
writes — the right shape for the seed files and the CLI pipeline. But a single
row of `gazette_notification` or `cross_reference` means nothing to an LLM on
its own: you'd need three joins (ministry, instrument, thread) plus a lineage
query just to know what a `gazette_id` *is*. This export does those joins
once, ahead of time, so a retriever can hand a model one line and the model
has everything it needs.

## Generating it

```bash
# the whole corpus
python3 -m render.llm_export --db gazette.db > data/exports/llm_corpus.jsonl

# one ministry only
python3 -m render.llm_export --db gazette.db --ministry steel > steel.jsonl
```

Safe to re-run any time after a seed-file update — it only reads the
database. `data/exports/` is gitignored (the export is regenerable, like
`data/raw/`'s PDF cache); the built file is instead mirrored to Dropbox and
Google Drive alongside `gazette.db` itself.

## Record shape

```json
{
  "gazette_id": "cus-45-2025",
  "series": "Customs", "number": "45/2025", "year": 2025,
  "publish_date": "2025-10-24", "gsr_or_so": "G.S.R. 781(E)",
  "ministry": "Ministry of Finance",
  "instrument": "Customs Act, 1962 — section 25(1) duty exemptions",
  "thread": "Customs duty exemption notifications under section 25(1)",
  "supersedes": [ { "gazette_id": "cus-1-2025", "number": "1/2025", "publish_date": "2025-01-16", "gsr_or_so": "G.S.R. 63(E)" }, "... 30 more" ],
  "amends_by": [ { "gazette_id": "cus-2-2026", "number": "2/2026", "publish_date": "2026-02-01", "gsr_or_so": "G.S.R. 83(E)" }, "... 5 more" ],
  "corrigendum_by": [ "... 2 entries" ],
  "cites_by": [ "... 1 entry" ],
  "summary": "Customs 45/2025 (G.S.R. 781(E), 2025-10-24) supersedes 31 notifications; amended by 6 notifications; corrigendum issued by 2 notifications; cited by 1 notification."
}
```

| Field | Meaning |
|---|---|
| `gazette_id` | This project's stable identifier — the join key everywhere else in the repo |
| `series`, `number`, `year` | As printed on the notification |
| `publish_date` | ISO date — the one the *citing* text actually quotes, not necessarily the gazette's own masthead date where the two differ (see individual seed files for documented cases) |
| `gsr_or_so` | The G.S.R./S.O./S.R.O. number, or `null` if genuinely unconfirmed (never guessed) |
| `ministry`, `instrument`, `thread` | Plain-text context, already joined — no lookup needed |
| `<relation>` (`amends`, `supersedes`, `cites`, `corrigendum`, `rescinds`, `repeals`) | Present only when non-empty. Each entry is this node acting *on* the target |
| `<relation>_by` | The reverse direction: `amends_by` means "amended by" — these notifications amend *this* one |
| `summary` | One generated sentence combining every relation direction present, for keyword/semantic retrieval without re-deriving it from the lists |

Only relation keys that actually apply to a given notification appear — a
notification with no incoming amendments simply has no `amends_by` key,
rather than an empty list.

## Using it

**As a RAG corpus.** Each line is a self-contained chunk — embed the
`summary` field (or the whole line) per record; the `gazette_id` gives you a
stable citation to point back to when a retrieved chunk is used in an answer.

**For citation QA.** Load the file, index by `gazette_id`, and you can answer
"what did X amend / get amended by" without touching SQL:

```python
import json

corpus = {}
with open("data/exports/llm_corpus.jsonl") as f:
    for line in f:
        record = json.loads(line)
        corpus[record["gazette_id"]] = record

node = corpus["cus-45-2025"]
print(node["summary"])
for target in node.get("supersedes", []):
    print("  supersedes:", target["number"], target["publish_date"])
```

**As an LLM's own context.** The whole corpus is 2,591 lines / ~1.7MB —
small enough to paste a filtered subset (one ministry, one thread) directly
into a prompt instead of building a retrieval layer at all, for one-off
questions.

## What it deliberately doesn't do

- No translation. Every field is the English text already in the database.
  See `render/translate.py` and the "Reading it in another language" section
  of the main README for translating a single record's fields on demand.
- No transitive chain-walking. `amends`/`amends_by` etc. are **one hop**,
  same as `db.crud.get_lineage()` — to walk a full chain, follow the `_by`
  links yourself or write a small recursive query. This mirrors the
  database's own one-hop convention rather than inventing a different one
  for the export.
- No confidence filtering. A `research-agent-quoted` edge and a
  `primary-source-full-text` edge look identical here — the `verified_by`
  provenance tier lives in the database, not in this export, so anything
  needing to reason about confidence should query `gazette.db` directly
  (or extend `render/llm_export.py`'s `build_record()` to inline it).
