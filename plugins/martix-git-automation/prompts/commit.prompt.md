---
name: martix-git commit
description: Draft and create one reviewed Conventional Commit from the current staged diff.
---

# /martix-git commit

Run `hooks/inspect-repository.ps1` and inspect `git diff --cached` before
writing language. If no staged changes exist, return `skip` with a diagnostic;
do not create an empty commit.

Draft the subject, body, breaking-change explanation, and trailers from the
staged diff and configured policy only. Use `skills/martix-git` guidance when
available and say when it is unavailable. Show the complete message for
review.

- `commit propose` is read-only and validates with
  `hooks/validate-commit-message.ps1`.
- `commit create` writes the reviewed content to a temporary message file and
  delegates to `hooks/commit-staged.ps1`.
- Require confirmation before the commit. Do not stage, amend, rewrite history,
  or use `--no-verify` unless separately requested and risk-reviewed.
- Re-read commit identity, HEAD, hooks, and status after success.

Report hook results and all phase classifications separately. A message draft
is not a commit and a validator result is not proof that a commit ran.
