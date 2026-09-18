# Temporal use-case matrix

Routing layer that turns a profiled user into a working Temporal proof of
concept. Profiling happens in the UI; the user is handed a URL that encodes
their answers and types `fetch <url>` to their coding agent.

```
start/<use-case>/<sdk>/<os>.md
```

That start page records the profile and sends the agent to `AGENTS.md`. The agent
builds a prototype for their use case, runs it on the local dev server, presents
it with a design, shapes it to what they actually want, then moves it to Temporal
Cloud.

## Layout

| File | Contents |
|---|---|
| `AGENTS.md` | The procedure the agent follows |
| `patterns.yaml` | Design patterns, defined once: docs URL, shape, limits, caveats |
| `use-cases/*.yaml` | Per use case: the default prototype, plus goals mapped to patterns with `when` conditions |
| `cloud-setup.md` | CLI install, Temporal Cloud connection, Worker placement |
| `templates/DESIGN.md` | The design the agent writes into the user's project |
| `start/**` | Generated routing stubs — never hand-edit |
| `scripts/generate-start-pages.sh` | Regenerates `start/` |

## What lives here, and what doesn't

This repo holds **only** the mapping from a user's use case to Temporal patterns,
plus the procedure for building a PoC.

- **Pattern content** belongs to [docs.temporal.io/design-patterns](https://docs.temporal.io/design-patterns). `patterns.yaml` carries a compressed `when`, `shape`, and `caveats`, then links out; the agent reads the page before implementing.
- **Language specifics** — install, layout, determinism, idioms — belong to the temporal-developer skill (`references/<sdk>/`). Nothing language-specific is stored here.

Any docs page is available as raw Markdown by appending `.md` to its URL.

## Design notes

**`when` conditions, not one recommendation.** Several patterns can fit one goal
for different reasons. Each carries the condition under which it applies, with
the real numbers — 1,000 children per parent, 2,000 pending Activities, 51,200
history events — so the choice is arithmetic rather than taste.

**Prototype first, questions later.** The agent builds from the profile alone and
shows working code before asking anything. The first question the user gets is
"use this as is, or change it?"

**The design is the anchor.** `DESIGN.md` is rewritten and re-shared every time
the user gives input, which keeps the agent consistent as the session grows.

**No injected failures.** The prototype works on the first run. This is a proof
of concept, not a tutorial.

## Status

Interim, and a team PoC. Adding a use case means one file under `use-cases/` and
a re-run of the generator.
