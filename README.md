# grok-cli-skills

A standalone OpenClaw skill for using the local **Grok CLI** in clean, headless, repo-aware workflows.

This repository packages a reusable skill that helps an OpenClaw agent:

- run `grok -p` headless prompts
- target a specific repository with `--dir`
- strip ANSI/session/progress noise from text output
- reuse prompt templates for repo summaries, code review, bug triage, and refactor planning

## Why this exists

OpenClaw already has first-class xAI-powered search tools, but sometimes you specifically want the **local Grok CLI** behavior on your own machine:

- use the installed `grok` binary directly
- run repo-aware prompts against a local working tree
- keep behavior aligned with Grok CLI sessions and models
- wrap Grok CLI in a cleaner headless workflow for agent use

This repo isolates that workflow into a small skill that can be installed, shared, and versioned separately.

## Source / upstream

This skill is built **for** the local Grok CLI and documents how to use it from OpenClaw.

Upstream Grok CLI project:
- <https://github.com/superagent-ai/grok-cli>

This repository is **not** the Grok CLI itself. It is a companion OpenClaw skill for using that CLI more effectively.

## Contents

- `grok-cli/SKILL.md` — trigger description and operating instructions
- `grok-cli/scripts/grok-headless-clean.sh` — wrapper that removes ANSI/session/progress noise
- `grok-cli/references/usage.md` — prompt templates, examples, and model-selection notes
- `dist/grok-cli.skill` — packaged skill artifact for distribution

## Install

### Option A — use the packaged `.skill` artifact

Download the latest release asset:
- `grok-cli.skill`

Then install it with your preferred OpenClaw skill workflow.

### Option B — copy the skill folder manually

Copy the `grok-cli/` directory into your skills location and reload/refresh skills in your OpenClaw environment.

## Requirements

- OpenClaw
- A local `grok` CLI installation on PATH
- Valid Grok/xAI credentials configured for the CLI

This skill was verified on a machine where:

- `grok -V` returned `1.0.0-rc5`
- `grok models` worked
- headless prompt execution worked via `grok -p ...`

## Example usage

Wrapper script:

```bash
./grok-cli/scripts/grok-headless-clean.sh \
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
