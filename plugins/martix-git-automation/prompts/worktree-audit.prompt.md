---
name: martix-git worktree audit
description: Audit registered worktrees, unattached branches, and configured-root orphan directories safely.
---

# /martix-git worktree audit

Run `hooks/inspect-git-worktrees.ps1` in audit mode. It delegates registered
worktree and branch classification to `scripts/git-cleanup.ps1`. Keep Git
inventory, branch tips, remote/PR evidence, ownership, and configured-root
orphan observations separate.

Return path, branch, HEAD, state, merge evidence, ownership evidence, reason
for retention, and candidate action. NUL-safe inventory, dirty/untracked,
current, main/protected, locked, detached, active, externally owned, unknown,
open-PR, and ambiguous states remain retained. Missing worktrees and
unregistered directories are not proof of ownership; only empty ordinary
non-reparse directories below configured scan roots may be reported as
candidates, and this adapter does not delete them.

`worktree apply` is a separate explicit mutation. Require selected branch
names, show the expected object IDs and exact cleanup action, use
`SupportsShouldProcess`, revalidate immediately before each item, and treat a
candidate removed by another process as a reconciled no-op. Never delete a
branch while attached or without both verified merge evidence and a fresh
result showing that no open PR remains.
