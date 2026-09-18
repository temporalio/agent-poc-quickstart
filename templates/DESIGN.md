# Design: <name>

<!--
Fill this in and write it to DESIGN.md in the user's project while you build,
not afterwards. Rewrite and re-share it every time the user gives new input -
it is what keeps you consistent as the session grows.
-->

**What this builds:** <one or two sentences, in the user's words once they have
given you any>

## Workflow

`<workflowName>(<input>) -> <output>`

<What it orchestrates, in two or three lines.>

## Activities

| Activity | Arguments | Timeout | Retry | Idempotent? |
|---|---|---|---|---|
| `<name>` | `<args>` | `<Xs>` | `<policy, or default>` | yes / no / n/a |

<Mark which are mocked, and what they will call for real.>

## State and messages

- **State the Workflow holds:** <or "none">
- **Signals:** <name and purpose, or "none">
- **Queries:** <name and what it returns, or "none">
- **Updates:** <name and what it returns, or "none">

## Failure

<What happens when each step fails permanently. Which errors retry, which do
not.>

## Patterns

| Pattern | Why it applies here |
|---|---|
| `<pattern-id>` | <the `when` clause that made it apply> |

## Verify

<What proves this works: the Workflow reaching Completed, the result value, the
child Workflows visible in the UI.>

## Not yet

<What this version leaves out, and what would trigger adding it.>

## Changed this round

<What the user asked for and what you changed in response. Keep the last entry
only - the point is to show them their input landed.>
