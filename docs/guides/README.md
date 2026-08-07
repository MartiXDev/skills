# Maintainer guides

This folder contains operational procedures that are useful across packages.
Package-specific behavior remains in package `SKILL.md`, `AGENTS.md`, and
`README.md` files.

| Guide | Use when |
| --- | --- |
| [Execution and routing](./execution-and-routing.md) | Choosing model tier, task type, token budget, routing surface, or parallel-safety value. |
| [Parallel worktree guidance](./parallel-worktree-guidance.md) | Splitting package work across agents, `/fleet`, branches, or worktrees. |
| [Skills installation](./skills-installation.md) | Importing external skills into a target repository. |

Keep this folder procedural. Current architecture belongs in
`docs/knowledge/repository/`; dated proposals belong in its `plans/` or
`research/` folders.
