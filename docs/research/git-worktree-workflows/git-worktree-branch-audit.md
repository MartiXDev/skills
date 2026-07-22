# Git worktree and branch audit

## Current snapshot

This audit was taken from the repository state on 2026-07-22.

- Current branch: `chore/skill-planning-and-template-updates`
- Main branch: `main`
- Worktrees currently attached: 8
- Local branches present: 9 (plus `main`)
- Branches already merged into `main`: `codex/review-dotnet-csharp-docs`,
`martinmikes-improved-goggles`, `main`
- Branches not merged into `main`:
`chore/skill-planning-and-template-updates`,
`feat/add-essl-and-imported-skills`, `feat/martix-afk-factory`,
`fluent-ui-css-first`, `martinmikes-create-typescript-skill`,
`martinmikes-research-doc-drift-2026`,
`martinmikes-research-fluent-ui-skill`,
`martinmikes-setup-matt-pocock-skills-config`

## Worktree findings

- The main working tree is the active repository checkout and should not be
removed.
- Several Copilot and Codex worktrees are attached to branches that are no
longer tracking a remote branch.
- The detached Codex worktree should be inspected first because it suggests a
temporary agent session that may have been left behind.

## Cleanup priorities

1. Remove stale worktrees tied to abandoned branches.
2. Delete merged local branches after their worktrees are closed.
3. Keep the current branch and `main` protected from cleanup.
4. Use dry-run mode first for any automation.
