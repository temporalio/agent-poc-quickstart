# Temporal PoC agent instructions

Build a working Temporal prototype for the user's use case, show it to them,
shape it into what they actually want, then move it to Temporal Cloud.

The start page they fetched carries their profile: `use_case`, `sdk`, `os`. Keep
that context for the whole session. Don't re-ask it, and don't ask what they
want to build before they have something to look at.

## Fetch

Base: `https://raw.githubusercontent.com/ericdrosado/temporal-use-case-matrix/main/`

- `use-cases/<use_case>.yaml` — the default prototype, plus goals for shaping later
- `patterns.yaml` — the patterns referenced by that file
- `templates/DESIGN.md` — fill in and write into the user's project
- `cloud-setup.md` — at step 6 and step 7

Fetch only what the profile calls for. Language specifics come from the
temporal-developer skill's `references/{language}/`. The pattern docs carry no
code sample for dotnet, ruby, or rust — tell the user when that applies.

## Steps

1. **Install what's missing.** `temporal --version`; install per their OS if
   absent (see `cloud-setup.md`). Skill or plugin:
   https://docs.temporal.io/with-ai. The SDK comes with the project in step 2.

2. **Build the default prototype.** Create a new project directory and build
   the `default_prototype` from the use-case file. One Workflow, the fewest
   Activities, all external and model calls mocked so it is deterministic and
   costs nothing. Task Queue and namespace as configuration, never hardcoded.
   Read each pattern's `url` before implementing it; `when`, `shape`, and
   `caveats` are compressed and omit detail that will bite you. Write
   `DESIGN.md` from the template as you build, not after.

   **Build something that works.** Do not inject failures, flaky steps, or
   retry demonstrations. This is a proof of concept, not a tutorial. If the user
   wants to see failure and recovery, they will ask.

3. **Run it on the local dev server.** Start `temporal server start-dev`, run
   the Worker and the starter, and confirm the Workflow completes. Never report
   a run you did not observe.

4. **Present the prototype and the design.** Show the completed Workflow, walk
   through `DESIGN.md`, and say what is mocked. Then ask: use this as is, or
   change it? Keep it short — they have working code in front of them.

5. **Shape it to their problem, re-sharing the design every round.** Each time
   the user gives input: match what they said to a goal in the use-case file,
   take that goal's patterns where the `when` holds, rewrite `DESIGN.md`, and
   present the revised design **before** building. Never build from the
   conversation alone — the written design is what keeps you consistent as the
   session grows. The prototype is the scaffold: rename it to their domain,
   replace mocks with their real calls, adjust the steps. Add another pattern
   only when their context requires it — volume past a stated limit, a
   downstream system to protect, a human to approve something.

6. **Move it to Temporal Cloud.** Once they are happy with the prototype,
   follow `cloud-setup.md`. Narrate each step as you go — what you are
   creating, why it is needed, what it does — then re-run the Workflow so they
   see it in the Cloud UI. **Prefix any namespace you create with `tpoc-`.** If
   they point you at a namespace they already have, use it as named.

7. **Decide where the Worker lives.** Options, and the constraint to explain
   first, are in `cloud-setup.md`.

## Rules

- Model and tool calls go in Activities, never in Workflow code.
- Disable client-library retries; Temporal owns retry.
- Idempotency key on any retried call with side effects.
- Activities, not Child Workflows, unless a `when` says otherwise.
- Never print or commit an API key.
- Define Workflow versus Activity once, in two sentences, the first time each
  appears, and state the determinism rule the first time they write Workflow
  code. No lecturing beyond that.
- If a run fails, show the output. If you skipped something, say so.
