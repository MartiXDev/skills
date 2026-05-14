---
name: "Start AFK local sessions"
description: "Guides running the local worktree orchestrator for Track B AFK sessions."
model: gpt-4o-mini
tools:
  - runCommands
---

# Start AFK local sessions (Track B)

Run the local AFK orchestrator to create git worktrees and open VS Code
sessions for all `afk/ready` issues.

## Prerequisites check

Before running, verify:

```powershell
gh auth status
git --version
code --version
Test-Path .github/agent-config.json
```

If any check fails, fix it before continuing.

## Run the orchestrator

```powershell
# Preview without making changes
.\hooks\start-afk-sessions.ps1 -DryRun

# Start up to 3 sessions (default)
.\hooks\start-afk-sessions.ps1

# Start up to N sessions
.\hooks\start-afk-sessions.ps1 -MaxSessions 5

# Check current session state
.\hooks\start-afk-sessions.ps1 -Monitor
```

## After running

For each VS Code window that opens:

1. Open the **Agents** panel (sidebar).
2. Start a new session — read `COPILOT_START.md` for the task prompt.
3. Run `/remote on` to enable monitoring from `github.com/mobile`.

## Monitor progress

```powershell
# Local session state
.\hooks\start-afk-sessions.ps1 -Monitor

# GitHub issue state
gh issue list --label afk/in-progress --state open
```

When an agent finishes, it opens a PR targeting `main`.
The `cleanup-merged.yml` workflow closes the issue and adds `afk/done` on merge.
