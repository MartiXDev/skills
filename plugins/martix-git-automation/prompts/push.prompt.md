---
name: martix-git push
description: Plan or publish a confirmed non-force Git ref push after divergence and upstream checks.
---

# /martix-git push

Inspect branch, HEAD, upstream, ahead/behind, remote, and status with
`hooks/inspect-repository.ps1` and `hooks/push-ref.ps1`.

- `push plan` is read-only and classifies synchronized state as `skip`, missing
  upstream as `ask`, ahead state as `perform`, and divergence, unavailable
  remotes, or authentication failure as `block` or `unknown`.
- `push publish` shows the exact remote and ref, requires confirmation, and
  delegates only a non-force push. Revalidate HEAD and divergence immediately
  before the operation.
- Never add `--force`, `--force-with-lease`, `reset --hard`, or a hidden remote
  fallback.

Re-read branch and remote evidence after publishing. Report the final remote
head, upstream, and all skipped or blocked phases.
