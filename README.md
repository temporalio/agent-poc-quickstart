# Agent PoC Quickstart

> [!WARNING]
> This project is experimental and will change.

Give your coding agent one URL, tell it what you want to build, and get a
working Temporal proof of concept. The agent builds it, runs it locally, and
moves it to Temporal Cloud when you're ready.

## Quick start

Paste this into your coding agent, replacing the three values:

```
fetch https://raw.githubusercontent.com/temporalio/agent-poc-quickstart/main/start/<use-case>/<sdk>/<os>.md
```

| Value | Options |
|---|---|
| `<use-case>` | `ai-agents`, `data-pipelines` |
| `<sdk>` | `typescript`, `python`, `go`, `java`, `dotnet`, `ruby`, `rust` |
| `<os>` | `macos`, `linux`, `windows` |

For example, an AI agent in Python on macOS:

```
fetch https://raw.githubusercontent.com/temporalio/agent-poc-quickstart/main/start/ai-agents/python/macos.md
```

Add what you want to build after the URL and the agent starts right away;
otherwise it asks you once:

```
fetch https://raw.githubusercontent.com/temporalio/agent-poc-quickstart/main/start/ai-agents/python/macos.md — I want to summarize support tickets with an LLM
```

For best results, install the Temporal skill for your agent first:
[docs.temporal.io/with-ai](https://docs.temporal.io/with-ai).

## What your agent does

1. **Finds out what you're building,** from your prompt or by asking you once,
   with options for your use case.
2. **Writes a `DESIGN.md`** into your project and shows it to you.
3. **Builds it and runs it on a local Temporal dev server.** Model, API, and
   data-source calls are mocked, so the first run is deterministic and free.
4. **Changes it as you describe your real problem,** updating the design and
   showing it to you before changing the code.
5. **Moves it to Temporal Cloud,** explaining each step, in a `tpoc-` namespace
   of your own.
6. **Helps you decide where the Worker should run.**

Step 5 needs a Temporal Cloud account. The agent installs the Temporal CLI if
it's missing.

## Use cases

| Use case | Example goals |
|---|---|
| **AI agents & applications** | Coordinate multiple AI, tool, or agent steps; keep durable state for an agent or session; retry flaky model calls safely |
| **Data pipelines, ETL, or background processing** | Process many records reliably; run work in parallel while controlling concurrency; resume after partial failure |

The agent matches what you describe to Temporal
[design patterns](https://docs.temporal.io/design-patterns): retries,
rate limiting, batching, durable agent state, and more.

## How it works

Each start page records your use case, SDK, and OS, then points the agent to
the procedure in this repo. Pattern guidance links to
[docs.temporal.io](https://docs.temporal.io/design-patterns), and
language-specific guidance comes from the
[Temporal developer skill](https://github.com/temporalio/skill-temporal-developer),
so this repo only maps use cases to patterns.

| Path | Contents |
|---|---|
| `AGENTS.md` | The steps the agent follows |
| `use-cases/*.yaml` | Each use case's goals, mapped to patterns |
| `patterns.yaml` | Pattern definitions, with the conditions and limits for choosing each |
| `cloud-setup.md` | CLI install, Temporal Cloud connection, Worker hosting options |
| `templates/DESIGN.md` | The design document the agent writes into your project |
| `start/` | Generated start pages. Don't edit by hand. |

## Contributing

To add a use case, add a file under `use-cases/`, add its id and label to
`scripts/generate-start-pages.sh`, and run the script.

## License

MIT
