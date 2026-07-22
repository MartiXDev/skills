# Git worktree operational checklist

Use this checklist when reviewing or cleaning up local worktrees and branches.

## Before cleanup

1. Confirm the current branch and protect it from removal.
2. Protect the default branch (`main`) from cleanup.
3. Review the worktree list and identify any locked or detached worktrees.
4. Prefer a dry-run or report-only pass before making deletions.
5. Re-read `git worktree list --porcelain` after archiving Copilot sessions;
  the client may already have removed their worktrees.
6. Inventory local branches separately because client cleanup may leave them
  behind.

## Safe removal order

1. Let the owning client close or remove its linked worktrees when practical.
2. Reconcile registrations that disappeared externally; do not treat absence
  as permission to delete a branch.
3. Delete only branches whose merge status is independently confirmed.
4. Leave branches that still have active work or open PRs alone.
5. Remove an orphan directory only when it is empty, is not a reparse point,
  contains no `.git` entry, and was explicitly selected.
6. Re-run `git worktree list` and `git branch --list` after cleanup.

## Guardrails

- Never delete the main worktree.
- Never delete the current branch's worktree.
- Never delete a locked worktree without explicit intent.
- Do not remove local branches just because they have no remote tracking
  branch; confirm merge status first.
- Do not use `git branch --merged` as the only evidence for squash- or
  rebase-merged pull requests.
- Do not infer ownership from a directory path or branch prefix.

## Useful commands

```powershell
# List all worktrees
git worktree list

# List local branches
git branch --list

# Reachability only; does not detect squash or rebase merges
git branch --merged main

# Show authoritative registered-worktree records
git worktree list --porcelain

# Preview stale remote-tracking ref cleanup
git remote prune origin --dry-run
```
