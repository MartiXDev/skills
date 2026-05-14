---
name: "AFK Factory setup"
description: "Setup and usage guidance for the martix-afk-factory plugin."
applyTo: ".github/agents/**,.github/hooks/**,.github/workflows/triage.yml,.github/workflows/dispatch-agent.yml,.github/workflows/poll-agent.yml,.github/workflows/cleanup-merged.yml,.github/agent-config.json"
---

# AFK Dev Factory — setup guidance

This file is loaded when editing AFK factory artifacts installed from the
`martix-afk-factory` plugin. Follow these rules for all changes.

## agent-config.json

- Is a **shared coordinator file**. Edit it on `main` only — never in a worktree.
- `tiers` keys must be literal model names accepted by the cloud agent tasks API.
- `sharedFiles` must list every file that must not be edited in parallel.
- `branchPrefix` must match the pattern used in `cleanup-merged.yml`.

## Agent persona files (.agent.md)

- One file per role (backend, frontend, test, docs, ops).
- Each agent must reference `docs/execution-profiles.md` in its Rules section.
- Each agent must include the repository completion signal command.
- Each agent must escalate to `hitl` on ambiguous scope or shared-file conflict.
- Keep the body concise — point to docs, not embed them.

## Hooks

- `hooks.json` uses `version: 1` event-keyed format.
- `validate-session.ps1` must exit 0 always — failures are warnings, not hard stops.
- `start-afk-sessions.ps1` reads `.github/agent-config.json`. Do not rename that file.

## Workflows

| File | Trigger | Key secret |
|------|---------|-----------|
| `triage.yml` | `issues: [opened, edited, labeled]` | none |
| `dispatch-agent.yml` | `issues.labeled == afk/ready` | `COPILOT_AGENT_TOKEN` (user PAT) |
| `poll-agent.yml` | cron `*/15 * * * *` + `workflow_dispatch` | `COPILOT_AGENT_TOKEN` |
| `cleanup-merged.yml` | `pull_request.closed` where merged==true | `GITHUB_TOKEN` |

`COPILOT_AGENT_TOKEN` **must** be a user Personal Access Token with `copilot`
scope. The `GITHUB_TOKEN` (server-to-server installation token) is explicitly
rejected by the cloud agent tasks API.

## Issue templates

- `micro-task.md`: the only template dispatched automatically. Requires both a
  `tier/*` and an `area/*` label. The `<!-- agent-prompt -->` block is extracted
  verbatim by `dispatch-agent.yml` and the local orchestrator. Keep it ≤ 400 chars.
- `feature-root.md` and `hitl-decision.md` carry the `hitl` label and are
  skipped by `triage.yml`.

## Model tier guidance

| Work | Tier |
|------|------|
| `agent-config.json` routing changes | `premium` |
| Agent authoring, workflow changes | `medium` |
| Label sync, hook execution, triage | `cheap` |
