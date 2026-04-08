---
name: grok-cli
description: Use the locally installed Grok CLI (`grok`) for headless one-shot prompts, repo-aware coding/review prompts, model listing, and lightweight automation on this machine. Trigger when the user explicitly asks to use Grok CLI / grok-cli / `grok`, wants a local Grok run instead of Codex built-in tools, wants a prompt executed inside Grok against a working directory, or wants Grok CLI-specific behavior like `grok -p`, `grok models`, or resuming a Grok session.
---

# Grok CLI

Use the local `grok` binary on this machine for direct Grok CLI workflows from Codex.

## Installed facts for this machine

- Binary path: `/home/deck/.nvm/versions/node/v22.22.0/bin/grok`
- Verified working version: `1.0.0-rc5`
- Basic headless prompt works: `grok -p "Reply with exactly: GROK_CLI_OK"`
- Default workspace to use unless the user specifies another path: `/home/deck`

## Default behavior

Prefer **headless mode** for agent use:

- Use `grok -p "..."` for one-shot prompts
- Add `-d <dir>` when repo context matters
- Use `--format text` unless machine-readable output is explicitly useful
- Use `--format json` only when you plan to parse structured events

Avoid launching the interactive TUI unless the user explicitly wants the TUI.

## Safe command patterns

### 1) Version / sanity check

```bash
grok -V
grok models
```

### 2) One-shot Q&A or summaries

```bash
grok -p "Summarize the purpose of this repository in 5 bullets." -d /path/to/repo --format text
```

### 3) Repo-aware coding or review prompt

```bash
grok -p "Review the current codebase and list the top 5 risks." -d /path/to/repo --format text
```

### 4) Structured output for downstream parsing

```bash
grok -p "Summarize the repo state" -d /path/to/repo --format json
```

### 5) Resume a Grok session

```bash
grok -s latest
grok -s <session-id>
```

Use session resume only when the user explicitly wants to continue prior Grok CLI context.

## Working directory rules

- Always set `-d` / `--directory` when the task is about a specific repo or folder.
- Default to `/home/deck` if the user does not specify a path.
- If the task references another repo, resolve the path first and then pass it explicitly.

## Output handling

- Grok CLI may print cosmetic ANSI color codes or a session line before the final answer.
- When relaying results to the user, strip terminal noise and return the useful answer.
- If the user asks for raw output, provide it explicitly.

## Suggested exec usage

Prefer the bundled wrapper for text mode so output is clean:

```bash
./scripts/grok-headless-clean.sh \
  --prompt "<prompt>" \
  --dir /some/path
```

Use raw `grok` directly when you need native behavior such as `grok models`, `grok -V`, or explicit session resume.

If a run may take longer, give `exec_command` a larger `yield_time_ms` or poll the spawned process instead of tight loops.

## Bundled resources

- Script: `scripts/grok-headless-clean.sh`
  - Use for headless text prompts with ANSI/session/progress noise stripped
  - Supports `--prompt`, `--dir`, `--format`, `--model`, `--session`
- Reference: `references/usage.md`
  - Read when you need prompt templates, common command patterns, or model-selection hints

## When not to use this skill

Do not use Grok CLI when Codex first-class tools are better:

- Use `web` for ordinary web research
- Use built-in coding tools for local editing, testing, and repo inspection

Use this skill when the user specifically wants the **local Grok CLI** behavior, session model, or repo-aware headless prompt execution.
