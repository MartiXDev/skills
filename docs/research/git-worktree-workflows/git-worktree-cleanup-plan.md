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
- Reconcile worktrees removed externally by Copilot or another lifecycle owner.
- Treat local branches left after external worktree removal as separate cleanup
  candidates requiring their own merge evidence.
- Report empty orphan directories under explicit scan roots; never infer
  ownership or delete non-empty paths from location alone.

## Why this fits the repo

The repository already uses worktrees, plugin automation, and agent-oriented
workflows. A cleanup flow should be opt-in, conservative, and documented under
the docs tree.

Observed Copilot app behavior reinforces the split lifecycle: archiving a
session may deregister and remove its clean worktree while preserving the local
branch, and it may leave an empty directory. Automation must be idempotent when
that transition happens between inspection and application.
