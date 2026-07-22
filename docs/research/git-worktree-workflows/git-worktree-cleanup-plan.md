# Git worktree and branch cleanup automation plan

## Goal

Add a safe, repeatable cleanup workflow for local Git worktrees and stale
branches in this repository.

## Recommended approach

- Add a local PowerShell cleanup script with a dry-run mode first.
- Protect the current branch, `main`, and locked worktrees by default.
- Only remove branches that are merged into `main` or explicitly approved by
the user.
- Warn about stale worktrees before deletion.
- Optionally add a PR-close workflow later for remote branch cleanup.

## Why this fits the repo

The repository already uses worktrees, plugin automation, and agent-oriented
workflows. A cleanup flow should be opt-in, conservative, and documented under
the docs tree.
