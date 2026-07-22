# Git worktree operational checklist

Use this checklist when reviewing or cleaning up local worktrees and branches.

## Before cleanup

1. Confirm the current branch and protect it from removal.
2. Protect the default branch (`main`) from cleanup.
3. Review the worktree list and identify any locked or detached worktrees.
4. Prefer a dry-run or report-only pass before making deletions.

## Safe removal order

1. Close or remove stale linked worktrees.
2. Delete only branches that are already merged into `main`.
3. Leave branches that still have active work or open PRs alone.
4. Re-run `git worktree list` and `git branch --list` after cleanup.

## Guardrails

- Never delete the main worktree.
- Never delete the current branch's worktree.
- Never delete a locked worktree without explicit intent.
- Do not remove local branches just because they have no remote tracking
  branch; confirm merge status first.

## Useful commands

```powershell
# List all worktrees
git worktree list

# List local branches
git branch --list

# List branches merged into main (reachability only; does not detect squash/rebase merges)
git branch --merged main
```
