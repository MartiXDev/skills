# Git worktree cleanup automation notes

## Design direction

A future automation flow should be conservative and opt-in.

- Start with a report-only mode that lists candidate worktrees and branches.
- Require explicit confirmation before removing anything.
- Protect the current branch, `main`, and any locked worktree by default.
- Allow a user or workflow to provide an override for explicitly approved cleanup.
- Expect Copilot or another lifecycle owner to remove a worktree between audit
  and apply. Reconcile an already-absent registration as a no-op.
- Keep branch deletion independent from worktree removal. Observed Copilot
  archive cleanup preserved the associated local branches.
- Report empty orphan directories under explicitly configured roots separately
  from registered Git worktrees.

## Suggested implementation shape

1. Collect worktree metadata with `git worktree list --porcelain -z`.
2. Collect local branch metadata independently from registered worktrees.
3. Use graph reachability plus merged pull-request evidence for squash or
  rebase merges; `git branch --merged main` is insufficient by itself.
4. Filter out protected branches and worktrees.
5. Optionally scan explicit roots for unregistered directories, but classify
  them as orphans rather than worktrees.
6. Print a summary of actions that would be taken.
7. Re-read state immediately before each mutation.
8. Only execute destructive steps after confirmation.

## GitHub Actions trigger options

The workflow can be triggered by:

- `workflow_dispatch` for manual runs
- `pull_request` with `types: [closed]` when the goal is to respond to merged
  PRs (check `github.event.pull_request.merged == true`)
- `delete` for branch deletion events (fires only if the workflow exists on the
  default branch)

The official GitHub Actions docs note that `pull_request` closed events can be
used to detect merges, while `delete` can be used to react to branch deletion.
Keep the workflow conservative because the repository may contain work in
progress or protected branches.

GitHub Actions cannot remove developer-machine worktrees. Copilot app archival
is a local client behavior and must not be generalized into a remote workflow
capability.
