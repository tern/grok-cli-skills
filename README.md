# grok-cli-skills

Standalone skill bundles for using the local **Grok CLI** in clean, headless, repo-aware workflows.

This repository packages reusable skill variants for both OpenClaw and Codex that help an agent:

- run `grok -p` headless prompts
- target a specific repository with `--dir`
- strip ANSI/session/progress noise from text output
- reuse prompt templates for repo summaries, code review, bug triage, and refactor planning

## Why this exists

OpenClaw and Codex already have strong built-in tools, but sometimes you specifically want the **local Grok CLI** behavior on your own machine:

- use the installed `grok` binary directly
- run repo-aware prompts against a local working tree
- keep behavior aligned with Grok CLI sessions and models
- wrap Grok CLI in a cleaner headless workflow for agent use

This repo isolates that workflow into small skills that can be installed, shared, and versioned separately.

## Source / upstream

These skills are built **for** the local Grok CLI and document how to use it from OpenClaw or Codex.

Upstream Grok CLI project:
- <https://github.com/superagent-ai/grok-cli>

This repository is **not** the Grok CLI itself. It is a companion skill bundle for using that CLI more effectively.

## Contents

- `grok-cli/` — OpenClaw skill
- `codex/grok-cli/` — Codex skill
- `grok-cli/SKILL.md` — OpenClaw trigger description and operating instructions
- `codex/grok-cli/SKILL.md` — Codex trigger description and operating instructions
- `grok-cli/scripts/grok-headless-clean.sh` — OpenClaw wrapper that removes ANSI/session/progress noise
- `codex/grok-cli/scripts/grok-headless-clean.sh` — Codex wrapper that removes ANSI/session/progress noise
- `grok-cli/references/usage.md` — OpenClaw prompt templates, examples, and model-selection notes
- `codex/grok-cli/references/usage.md` — Codex prompt templates, examples, and model-selection notes
- `dist/grok-cli.skill` — packaged skill artifact for distribution

## Install

### Option A — use the packaged `.skill` artifact

Download the latest release asset:
- `grok-cli.skill`

Then install it with your preferred OpenClaw skill workflow.

### Option B — copy the skill folder manually

For OpenClaw:

Copy the `grok-cli/` directory into your skills location and reload/refresh skills in your OpenClaw environment.

For Codex:

Copy `codex/grok-cli/` into your Codex skills location, typically `~/.codex/skills/grok-cli/`.

## Requirements

- OpenClaw or Codex
- A local `grok` CLI installation on PATH
- Valid Grok/xAI credentials configured for the CLI

This skill was verified on a machine where:

- `grok -V` returned `1.0.0-rc5`
- `grok models` worked
- headless prompt execution worked via `grok -p ...`

## Example usage

OpenClaw wrapper script:

```bash
./grok-cli/scripts/grok-headless-clean.sh \
  --prompt "Summarize this repo in 5 bullets" \
  --dir /path/to/repo
```

Codex wrapper script:

```bash
./codex/grok-cli/scripts/grok-headless-clean.sh \
  --prompt "Summarize this repo in 5 bullets" \
  --dir /path/to/repo
```

Raw Grok CLI:

```bash
grok -p "Review this codebase and list top risks" -d /path/to/repo --format text
```

## Release artifacts

Each release may include:

- packaged `.skill` file for import/distribution
- source files for manual inspection or installation

## License

MIT
