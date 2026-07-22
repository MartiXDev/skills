# Git worktree cleanup automation notes

## Design direction

A future automation flow should be conservative and opt-in.

- Start with a report-only mode that lists candidate worktrees and branches.
- Require explicit confirmation before removing anything.
- Protect the current branch, `main`, and any locked worktree by default.
- Allow a user or workflow to provide an override for explicitly approved cleanup.

## Suggested implementation shape

1. Collect worktree metadata with `git worktree list --porcelain -z`.
2. Collect branch metadata with `git branch --merged main` and `git branch --list`.
3. Filter out protected branches and worktrees.
4. Print a summary of actions that would be taken.
5. Only execute destructive steps after confirmation.

## GitHub Actions trigger options

The workflow can be triggered by:

- `workflow_dispatch` for manual runs
- `pull_request` with `types: [closed]` when the goal is to respond to merged
  PRs (check `github.event.pull_request.merged == true`)
- `delete` for branch deletion events (fires only if the workflow exists on the default branch)

The official GitHub Actions docs note that `pull_request` closed events can be
used to detect merges, while `delete` can be used to react to branch deletion.
Keep the workflow conservative because the repository may contain work in
progress or protected branches.
