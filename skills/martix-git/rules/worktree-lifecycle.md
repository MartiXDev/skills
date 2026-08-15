# Worktree lifecycle and cleanup

## Purpose

Use this rule for worktree audits, stale branch reconciliation, post-merge
cleanup, orphan directories, or local versus remote cleanup. Cleanup is
report-first. Unknown and protected states remain untouched.

## State model

Classify each registered worktree and candidate branch with evidence for path,
branch, HEAD, current status, lock, attachment, ownership, upstream, open PR,
and merge state. Distinguish these states:

- main, current, protected, active, dirty, locked, detached, missing/prunable;
- externally owned, unknown, clean eligible, or ambiguous;
- local branch tip, remote-tracking ref, remote branch, and tag;
- ancestry reachability versus GitHub merged-PR evidence;
- removed worktree registration versus the local branch left behind;
- registered worktrees versus unregistered directories below configured scan
  roots.

Use `git worktree list --porcelain -z` or an equivalent NUL-safe inventory.
Paths may contain spaces, Unicode, newlines, and other valid Git content.
Do not let a model parse the porcelain stream or decide whether a candidate is
safe to delete; use a deterministic adapter.

## Retention rules

Retain the main, current, protected, dirty, untracked, locked, detached,
unverifiable, active, externally owned, unknown, open-PR, and
ambiguous-merge states. Do not remove a branch while a worktree remains
attached. A missing worktree is a reconciliation result, not permission to
delete its branch.

An ordinary empty orphan directory may be reported for explicit removal only
when it is below a configured scan root, is not a reparse point, contains no
`.git` entry, and is still empty after revalidation. Keep non-empty,
Git-bearing, reparse-point, or unknown directories untouched.

## Audit and apply

1. Audit registered worktrees, local branches, and configured orphan roots.
   Report path, branch, HEAD, evidence, retention reason, and candidate
   action. Use the existing [git-cleanup.ps1](../../../scripts/git-cleanup.ps1)
   as the initial repository reference engine.
2. Keep local cleanup separate from remote cleanup. `git fetch --prune`,
   worktree metadata pruning, local branch deletion, remote branch deletion,
   and object garbage collection are separate operations with different
   owners. A remote workflow cannot delete a developer's local directory.
3. Offer an explicit apply mode only for operator-selected candidates. Use
   `SupportsShouldProcess`, per-item confirmation, no force removal, and
   compare-and-delete or expected-object-ID protection for local refs.
4. Re-read repository identity, HEAD, path, lock, status, attachment,
   protection, open PR, ownership, merge evidence, and selected candidate
   immediately before each mutation. If anything changes, abort or reconcile
   safely and explain it.
5. Report completed, retained, skipped, failed, and externally reconciled
   items. A second audit should be idempotent and explain any difference.

## Review checklist

- Inventory parsing is NUL-safe and deterministic.
- Audit happens before apply and is report-only by default.
- Protected, unknown, and ambiguous states are retained.
- Local and remote ownership are separate.
- Selection, confirmation, revalidation, and expected object identity exist.
- No force removal, hard reset, destructive clean, or hidden branch deletion
  is available.

## Source anchors

See [source-map.md](../references/source-map.md) for Git worktree, GitHub
merge, cleanup ownership, and local script evidence.
