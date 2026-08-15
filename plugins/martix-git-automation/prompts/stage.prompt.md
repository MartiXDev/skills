---
name: martix-git stage
description: Inspect and explicitly stage selected paths or hunks for a reviewed Git change.
---

# /martix-git stage

Inspect staged and unstaged paths before proposing a selection. Keep unrelated
and untracked files visible. Ask for paths or hunks when the requested scope is
mixed or unclear.

- `stage` is a smart workflow: classify inspection, selection, staging, and
  verification as `perform`, `skip`, `ask`, or `block`.
- `stage add` is atomic: stage only explicit path arguments through
  `hooks/stage-paths.ps1`; never translate an unclear request into `git add .`.
- If the required paths are already staged or the worktree is clean, report
  `skip` with evidence.
- Before staging, show the exact path set and expected index effect. Require
  confirmation. Re-read status and the cached diff afterward.

Declining staging blocks dependent commit and PR phases without a hidden
fallback. Report completed, skipped, blocked, failed, and unresolved phases.
