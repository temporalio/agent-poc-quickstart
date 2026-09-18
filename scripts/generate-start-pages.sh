#!/usr/bin/env bash
# Generates start/<use-case>/<sdk>/<os>.md - the routing stubs the UI links to.
#
# These files carry no content. They record the profile from the URL and send the
# agent to AGENTS.md. Never hand-edit them; edit this script and re-run.
#
#   ./scripts/generate-start-pages.sh

set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/ericdrosado/temporal-use-case-matrix/main"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

USE_CASES=(ai-agents data-pipelines)
SDKS=(typescript python go java dotnet ruby rust)
OSES=(macos linux windows)

label() {
  case "$1" in
    ai-agents)      echo "AI agents & applications" ;;
    data-pipelines) echo "Data pipelines, ETL, or background processing" ;;
    typescript)     echo "TypeScript" ;;
    python)         echo "Python" ;;
    go)             echo "Go" ;;
    java)           echo "Java" ;;
    dotnet)         echo ".NET" ;;
    ruby)           echo "Ruby" ;;
    rust)           echo "Rust" ;;
    macos)          echo "macOS" ;;
    linux)          echo "Linux" ;;
    windows)        echo "Windows" ;;
    *)              echo "$1" ;;
  esac
}

rm -rf "$ROOT/start"
count=0

for uc in "${USE_CASES[@]}"; do
  for sdk in "${SDKS[@]}"; do
    mkdir -p "$ROOT/start/$uc/$sdk"
    for os in "${OSES[@]}"; do
      cat > "$ROOT/start/$uc/$sdk/$os.md" <<EOF
# Temporal PoC — $(label "$uc") · $(label "$sdk") · $(label "$os")

Context from this URL. Keep it for the whole session:

- use_case: $uc
- sdk: $sdk
- os: $os

Now read and follow: $REPO_RAW/AGENTS.md
EOF
      count=$((count + 1))
    done
  done
done

echo "generated $count start pages under start/"
