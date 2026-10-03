# Agent PoC Quickstart

> [!WARNING]
> This project is experimental and will change.

Give your coding agent one URL and get a working Temporal proof of concept for
your use case. The agent builds it, runs it locally, explains it, and moves it
to Temporal Cloud when you're ready.

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

For best results, install the Temporal skill for your agent first:
[docs.temporal.io/with-ai](https://docs.temporal.io/with-ai).

## What your agent does

1. **Builds a working prototype right away.** No questions first. Model, API,
   and data-source calls are mocked, so the first run is deterministic and free.
2. **Runs it on a local Temporal dev server** and confirms it completes.
3. **Walks you through the pieces** (Workflow, Activities, Task Queue, Worker)
   in terms of your use case, and writes a `DESIGN.md` into your project.
4. **Shapes it to what you're building.** Describe your real problem; the agent
   updates the design, shows it to you, then changes the code.
5. **Moves it to Temporal Cloud** when you're happy with it, explaining each
   step, and helps you decide where the Worker should run.

Step 5 needs a Temporal Cloud account. The agent installs the Temporal CLI if
it's missing.

## Use cases

| Use case | Starting prototype |
|---|---|
| **AI agents & applications** | Plans topics, researches three in parallel, and synthesizes a report |
| **Data pipelines, ETL, or background processing** | Splits a record set into chunks, processes each in a child Workflow, and totals the results |

From there, the agent matches what you describe to Temporal
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
| `use-cases/*.yaml` | Each use case's starting prototype and goals, mapped to patterns |
| `patterns.yaml` | Pattern definitions, with the conditions and limits for choosing each |
| `cloud-setup.md` | CLI install, Temporal Cloud connection, Worker hosting options |
| `templates/DESIGN.md` | The design document the agent writes into your project |
| `start/` | Generated start pages. Don't edit by hand. |

## Contributing

To add a use case, add a file under `use-cases/`, add its id and label to
`scripts/generate-start-pages.sh`, and run the script.

## License

MIT
