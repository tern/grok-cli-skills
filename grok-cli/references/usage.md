# Grok CLI Usage Reference

## Quick commands

### Sanity check

```bash
grok -V
grok models
/home/deck/.openclaw/workspace/skills/grok-cli/scripts/grok-headless-clean.sh --prompt "Reply with exactly: OK"
```

### Headless one-shot

```bash
/home/deck/.openclaw/workspace/skills/grok-cli/scripts/grok-headless-clean.sh \
  --prompt "Summarize this repo in 5 bullets" \
  --dir /path/to/repo
```

### Use a specific model

```bash
/home/deck/.openclaw/workspace/skills/grok-cli/scripts/grok-headless-clean.sh \
  --prompt "Review the codebase and list top risks" \
  --dir /path/to/repo \
  --model grok-code-fast-1
```

### Structured output

```bash
/home/deck/.openclaw/workspace/skills/grok-cli/scripts/grok-headless-clean.sh \
  --prompt "Summarize the repo state" \
  --dir /path/to/repo \
  --format json
```

## Prompt templates

### 1) Repo summary

```text
Summarize this repository in 5 bullets:
- purpose
- main stack
- key entrypoints
- current risks
- suggested next step
```

### 2) Code review

```text
Review this codebase and report:
1. top 5 technical risks
2. likely bugs
3. missing tests
4. architecture smells
5. highest-leverage next fixes
Keep it concise and actionable.
```

### 3) Bug triage

```text
Inspect this project for the likely cause of <BUG>.
Return:
- probable root cause
- files to inspect first
- smallest safe fix
- how to verify
```

### 4) Refactor planning

```text
Propose a minimal-risk refactor plan for <TARGET>.
Return:
- current problems
- phased plan
- rollback points
- validation checklist
```

### 5) PR / diff review

```text
Review the current changes in this repo.
Focus on:
- correctness
- regression risk
- edge cases
- missing tests
- whether the change is actually complete
```

## Operational notes

- Prefer the wrapper script for `--format text`; it strips ANSI color codes and common session/progress noise.
- For `--format json`, use the wrapper too; it passes JSON through unchanged.
- Always set `--dir` for repo-specific tasks.
- Default fallback directory is `/home/deck/.openclaw/workspace`.
- Verified on this machine after installation:
  - `grok -V` -> `1.0.0-rc5`
  - `grok models` works
  - headless prompt works via wrapper script

## Suggested model choices

- `grok-code-fast-1`: code review, debugging, repo work
- `grok-4-1-fast-reasoning`: broader reasoning with lower cost
- `grok-4.20-0309-reasoning`: deeper analysis when latency/cost is less important

## When to escalate beyond Grok CLI

Use other tools instead when appropriate:

- OpenClaw `web_search` for plain web research
- OpenClaw `x_search` for X/Twitter search
- OpenClaw ACP / coding agents for long-running implementation loops
