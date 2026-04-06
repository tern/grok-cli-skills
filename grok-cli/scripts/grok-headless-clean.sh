#!/usr/bin/env bash
set -euo pipefail

DEFAULT_DIR="/home/deck/.openclaw/workspace"
DIR="$DEFAULT_DIR"
FORMAT="text"
MODEL=""
SESSION=""
PROMPT=""

usage() {
  cat <<'EOF'
Usage: grok-headless-clean.sh --prompt "..." [--dir PATH] [--format text|json] [--model MODEL] [--session ID]

Runs Grok CLI in headless mode and strips common terminal noise from text output.
- Default directory: /home/deck/.openclaw/workspace
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

CMD=(grok -p "$PROMPT" -d "$DIR" --format "$FORMAT")
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
