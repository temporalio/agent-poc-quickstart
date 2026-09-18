# Temporal CLI install, Cloud connection, and where the Worker lives

## CLI install

| OS | Command |
|---|---|
| macOS | `brew install temporal` |
| Linux | Download the archive from `https://temporal.download/cli/archive/latest?platform=linux&arch=amd64` (or `arch=arm64`), extract, and `sudo mv temporal /usr/local/bin` |
| Windows | Download from `https://temporal.download/cli/archive/latest?platform=windows&arch=amd64` (or `arch=arm64`), extract, add `temporal.exe` to PATH |

Verify with `temporal --version`.

## Moving the prototype to Temporal Cloud

The user already has a Cloud account. Do this once they are happy with the
prototype, and **narrate each step** - what you are creating, why it is needed,
what it does. For most users this is their first time seeing any of it.

### 1. Log in

```
temporal cloud login
```

**Run it yourself.** It opens a browser for the user to finish signing in, then
prints `Login successful!` and stores the token locally. Tell them a tab is
opening and why - don't hand them the command to type.

### 2. Namespace

> A namespace is an isolated environment. Workflow history, Task Queues, and
> visibility all live inside it, and nothing crosses between namespaces.

```
temporal cloud namespace list
```

If they have one they want to use, use it as named. Otherwise create one and
**prefix the name with `tpoc-`**:

```
temporal cloud namespace create \
  --name tpoc-<something> \
  --region <region> \
  --retention-days 30 \
  --api-key-auth-enabled
```

### 3. Connection details

```
temporal cloud namespace get -n <namespace> -o json
```

Take `endpoints.grpcAddress` and confirm `spec.apiKeyAuth.enabled`. The endpoint
is regional - check `activeRegion`.

### 4. Credentials

> An API key is how the Worker proves who it is when it connects. Without it,
> Cloud has no reason to trust the process polling for work.

Check what exists first - **an expired key is the most common reason a Worker
will not connect**:

```
temporal cloud apikey list
```

Mint one when needed:

```
temporal cloud apikey create-for-me \
  --display-name <name> \
  --expiry-duration <duration>
```

Beyond a PoC, prefer `temporal cloud apikey create-for-service-account`. If they
would rather use certificates, mTLS is the alternative - the namespace exposes a
separate `mtlsGrpcAddress`.

Put the namespace, endpoint, and key in a **gitignored `.env`** and load them
from the environment with the SDK's environment-config loader. Never hardcode
them, never print the key back to the user, never commit it.

### 5. Prove the connection, then re-run

List Workflows in the namespace with the CLI. An empty list is success - it
means you authenticated and reached the namespace.

> Nothing about the Workflow code changes. The same build now points at Cloud
> instead of the dev server - that is the only difference.

Start the Worker against Cloud, run the Workflow, and show it in the Cloud UI.

### If it does not connect

- **A newly minted key or namespace needs a moment to propagate.** The first
  call can fail and the same call succeed ~10 seconds later. Retry once before
  concluding the credentials are wrong - otherwise you will start fixing a key
  that was fine.
- **Expired or disabled API key** - check the state column in `apikey list`.
- **Wrong endpoint** - the gRPC address is regional, and the mTLS address is
  different from the API-key address.
- **Namespace not API-key enabled** - confirm `spec.apiKeyAuth.enabled`.
- **Stale config overriding you** - a leftover profile in `temporal.toml`, or
  pre-existing `TEMPORAL_*` environment variables pointing elsewhere. Both win
  silently over what you just set.

## Where the Worker lives

Explain the constraint before the options:

> A Worker is a long-lived process that polls a Task Queue. It is not a request
> handler. The code that *starts* Workflows can live anywhere, including a
> serverless function - but something has to keep polling.

| Option | When it fits |
|---|---|
| Local process | A PoC, and day-to-day development |
| Container platform kept warm - Cloud Run with minimum instances, ECS, Fly, Railway, Render | The usual answer when someone says "serverless" |
| Their own Kubernetes or VMs | It has to sit beside existing services |
| Per-request serverless function | Not viable for a Worker. Say so, and offer the warm-container option |

Whichever they choose, deliver the command or manifest that runs the Worker
there, how the credentials reach that environment (a secret manager or platform
environment variables, not a committed file), and the Task Queue name as
configuration so the same build can point at a different queue or namespace.
