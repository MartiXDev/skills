---
name: martix-git
description: Smart entrypoint for safe Git and GitHub branch, staging, commit, push, PR, policy, release, and worktree workflows.
---

# /martix-git

Route the user's explicit intent to one primary workflow. When intent is
missing or ambiguous, run the read-only repository inspector and ask one
focused question. Do not infer a mutation from a dirty worktree.

Use `/martix-git pr` as the composed branch-to-PR workflow when the user wants
to finish current changes. It runs `hooks/plan-pr-workflow.ps1` first, skips
phases proved unnecessary, asks for only missing choices, and delegates each
confirmed mutation to its existing atomic adapter. `/martix-git branch`,
`/martix-git commit`, and `/martix-git push` are the corresponding smart
single-workflow shortcuts; `branch create`, `commit create`, `push publish`,
and `pr create` remain explicit atomic forms.

## Procedure

1. Inspect the smallest relevant state with `hooks/inspect-repository.ps1` and,
   when the request needs it, `hooks/inspect-pr.ps1` or
   `hooks/inspect-git-worktrees.ps1`.
2. Identify the applicable `skills/martix-git` rule or report that the
   standalone skill is unavailable. Keep source fact, repository policy,
   recommendation, inference, and gap labels distinct.
3. Build a phase table. Each phase must contain `Phase`, `Decision`, `Evidence`,
   `Action`, `Confirmation`, and `Result`. Decisions are `perform`, `skip`,
   `ask`, or `block`.
4. Show commands, arguments, targets, assumptions, and expected effects before
   any state-changing phase. Obtain confirmation for each mutation or for the
   displayed grouped set.
5. Invoke only the deterministic adapter for the confirmed phase. Re-read state
   immediately afterward and recompute later phases.
6. Report completed, skipped, blocked, failed, and unresolved phases separately.

Use argument-safe adapters and temporary files for multi-line content. Never
stage all files implicitly, bypass hooks, force-push, delete worktrees without
an explicit confirmed `worktree apply`, publish from PR validation, or claim
remote evidence when `gh` is missing or unauthenticated.
