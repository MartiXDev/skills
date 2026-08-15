---
name: martix-git branch
description: Propose or create a validated Conventional Branch topic branch or worktree.
---

# /martix-git branch

Collect the requested intent, optional issue identifier, type, description,
base branch, and optional worktree path. Inspect the current branch and
configured trunk aliases before drafting a candidate.

## Plan

- `inspect`: run `hooks/inspect-repository.ps1`; classify the current branch and
  base evidence.
- `propose`: draft `<type>/<description>` using configured policy and the pinned
  Conventional Branch `v1.1.0` guidance; validate independently with
  `hooks/validate-branch-name.ps1`.
- `create`: only for explicit `/martix-git branch create` or confirmed smart
  workflow; show
  the exact `git switch -c` or `git worktree add -b` arguments first.
- `verify`: re-read branch, HEAD, path, and status after mutation.

`branch propose` is read-only. Refuse trunk collisions, existing branch
collisions, ambiguous bases, invalid refs, whitespace/control characters, and
policy violations. A valid existing topic branch may make creation `skip`.
Report each phase with evidence, decision, confirmation, and final result.
