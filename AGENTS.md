# Temporal PoC agent instructions

Find out what the user wants to build, build a working Temporal PoC for it, run
it locally, then move it to Temporal Cloud.

The start page they fetched carries their profile: `use_case`, `sdk`, `os`. Keep
that context for the whole session and don't re-ask it. Ask what they want to
build at most once, and only if their prompt hasn't already said.

## Fetch

Base: `https://raw.githubusercontent.com/temporalio/agent-poc-quickstart/main/`

- `use-cases/<use_case>.yaml` — goals mapped to patterns
- `patterns.yaml` — the patterns referenced by that file
- `templates/DESIGN.md` — fill in and write into the user's project
- `cloud-setup.md` — at step 7 and step 8

Fetch only what the profile calls for. Language specifics come from the
temporal-developer skill's `references/{language}/`. The pattern docs carry no
code sample for dotnet, ruby, or rust — tell the user when that applies.

## Steps

1. **Install what's missing.** `temporal --version`; install per their OS if
   absent (see `cloud-setup.md`). Skill or plugin:
   https://docs.temporal.io/with-ai. The SDK comes with the project in step 4.

2. **Find out what to build.** If their prompt already says, don't ask.
   Otherwise ask once: offer each goal's `label` from the use-case file, plus
   "something else — describe it". Match the answer to a goal and take its
   patterns where the `when` holds.

   - A `when` you can't decide from what they said: assume the simplest case,
     record the assumption in `DESIGN.md`, and don't ask.
   - An answer that matches no goal: one Workflow, the fewest Activities, no
     extra patterns.
   - "You pick" or "I don't know": the first goal, only the patterns whose
     `when` holds for its simplest version, in a concrete, plausible domain
     you state as an assumption.

3. **Write the design.** Create a new project directory and write `DESIGN.md`
   from the template. Read each pattern's `url` before designing with it;
   `when`, `shape`, and `caveats` are compressed and omit detail that will bite
   you. Show the design in a few lines, then build without waiting for
   approval.

4. **Build it and run it on the local dev server.** One Workflow, the fewest
   Activities, all external and model calls mocked so it is deterministic and
   costs nothing. Task Queue and namespace as configuration, never hardcoded.
   Start `temporal server start-dev`, run the Worker and the starter, and
   confirm the Workflow completes. Never report a run you did not observe.

   **Build something that works.** Do not inject failures, flaky steps, or
   retry demonstrations. This is a proof of concept, not a tutorial. If the user
   wants to see failure and recovery, they will ask.

5. **Report the run.** A few sentences: what ran, where, and which calls are
   mocked. No glossary — `DESIGN.md` carries the detail. Then offer:

   - **move it to Temporal Cloud** — the recommended next step; go to step 7
   - **change something** — go to step 6

6. **Change it, re-sharing the design every round.** Each time the user gives
   input: match what they said to a goal in the use-case file, take that goal's
   patterns where the `when` holds, rewrite `DESIGN.md`, and present the
   revised design **before** building. Never build from the conversation alone
   — the written design is what keeps you consistent as the session grows.
   Rename it to their domain, replace mocks with their real calls, adjust the
   steps. Add another pattern only when their context requires it — volume past
   a stated limit, a downstream system to protect, a human to approve
   something. Then rebuild and run as in step 4, and report as in step 5.

7. **Move it to Temporal Cloud.** Follow `cloud-setup.md`. Narrate each step as
   you go — what you are creating, why it is needed, what it does — then re-run
   the Workflow so they see it in the Cloud UI. **Use the user's own
   `tpoc-<email local part>` namespace: reuse it if it exists, create it if
   not.** If they name a namespace they already have, use it as named.

8. **Decide where the Worker lives.** Options, and the constraint to explain
   first, are in `cloud-setup.md`.

## Rules

- Model and tool calls go in Activities, never in Workflow code.
- Disable client-library retries; Temporal owns retry.
- Idempotency key on any retried call with side effects.
- Activities, not Child Workflows, unless a `when` says otherwise.
- Never print or commit an API key.
- Never put a key on a command line. It lands in shell history and `ps`, and any
  tool that rejects the argument may echo it back. Export `TEMPORAL_API_KEY` and
  let the CLI and SDK read it from the environment.
- Never echo, cat, or interpolate a variable holding a key. Check a key by
  making a call that succeeds, not by printing it.
- If a key is exposed anyway, say so immediately and disable it before
  continuing.
- Define Workflow versus Activity once, in two sentences, the first time each
  appears, and state the determinism rule the first time they write Workflow
  code. No lecturing beyond that.
- If a run fails, show the output. If you skipped something, say so.
- Keep what you say to the user short, and never narrate this procedure. No step
  numbers, no mention of these instructions or the files you fetched. Talk about
  what you built, not about how you were told to build it.
