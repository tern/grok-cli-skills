#!/usr/bin/env bash
set -euo pipefail

DEFAULT_DIR="/home/deck"
DEFAULT_GROK_BIN="/home/deck/.nvm/versions/node/v22.22.0/bin/grok"
DIR="$DEFAULT_DIR"
FORMAT="text"
MODEL=""
SESSION=""
PROMPT=""

if [[ -x "$DEFAULT_GROK_BIN" ]]; then
  GROK_BIN="$DEFAULT_GROK_BIN"
else
  GROK_BIN="$(command -v grok || true)"
fi

usage() {
  cat <<'EOF'
Usage: grok-headless-clean.sh --prompt "..." [--dir PATH] [--format text|json] [--model MODEL] [--session ID]

Runs Grok CLI in headless mode and strips common terminal noise from text output.
- Default directory: /home/deck
- Default format: text
- For --format json, raw JSON lines are passed through unchanged.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --prompt|-p)
      PROMPT="${2:-}"
      shift 2
      ;;
    --dir|-d|--directory)
      DIR="${2:-}"
      shift 2
      ;;
    --format)
      FORMAT="${2:-}"
      shift 2
      ;;
    --model|-m)
      MODEL="${2:-}"
      shift 2
      ;;
    --session|-s)
      SESSION="${2:-}"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$PROMPT" ]]; then
  echo "Missing required --prompt" >&2
  usage >&2
  exit 2
fi

if [[ -z "${GROK_BIN:-}" ]]; then
  echo "Could not find Grok CLI binary. Checked: $DEFAULT_GROK_BIN and PATH." >&2
  exit 127
fi

CMD=("$GROK_BIN" -p "$PROMPT" -d "$DIR" --format "$FORMAT")
if [[ -n "$MODEL" ]]; then
  CMD+=( -m "$MODEL" )
fi
if [[ -n "$SESSION" ]]; then
  CMD+=( -s "$SESSION" )
fi

if [[ "$FORMAT" == "json" ]]; then
  exec "${CMD[@]}"
fi

"${CMD[@]}" 2>&1 | python3 -c 'import re,sys
ansi = re.compile("\x1b\\[[0-9;]*[A-Za-z]")
for raw in sys.stdin:
    line = ansi.sub("", raw).rstrip("\n")
    stripped = line.strip()
    if not stripped:
        continue
    if stripped.startswith("Session:"):
        continue
    if stripped in {"⏳ Processing...", "Processing..."}:
        continue
    print(stripped)
'
