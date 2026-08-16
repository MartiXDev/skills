---
name: MartiX Git workflow
applyTo: "**/*"
---

# MartiX Git workflow

Use `/martix-git` for Git, GitHub, commit policy, release, hook, and worktree
requests when the request is substantive. Read the smallest relevant local
state first and keep Git state, GitHub state, client lifecycle state, and model
drafts separate.

Every operation has a plan. Classify each phase as `perform`, `skip`, `ask`, or
`block`, show evidence and the exact action, and require confirmation before
mutation. Re-read state after every performed phase and recompute later phases.
Report completed, skipped, blocked, failed, and unresolved phases separately.

Use deterministic scripts for Git/GitHub parsing, validation, command execution,
revalidation, and cleanup. Use the companion `skills/martix-git` package for
source-backed guidance and language drafts when it is available. Never treat a
draft as validated state, infer ownership from names or age, interpolate user
text into shell commands, or silently broaden a path/candidate set.

Cleanup is report-first. Keep dirty, untracked, current, protected, locked,
detached, active, externally owned, open-PR, ambiguous, and unknown states. Do
not use force removal, hard reset, destructive clean, force push, hook bypass,
or release publishing from pull-request validation.
