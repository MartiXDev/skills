# Skill display name agents guide

Replace the title with the package display name. Use this guide for maintainer
workflows, cross-skill handoffs, and longer review routes.

Before changing this package, read the repository root `AGENTS.md`, this
package's `SKILL.md`, and its `README.md`. Repository contracts override generic
skill-authoring tool defaults.

## Maintainer contract

- Keep `SKILL.md` as the compact activation router.
- Put normative guidance in `rules/`, supporting maps and dated facts in
 `references/`, and reusable scaffolds in `templates/`.
- Keep `plugin.json`, `metadata.json`, README, taxonomy, and section ordering
 synchronized when package identity or routes change.
- Keep all behavior and trigger regressions in the single canonical
 `evals/evals.json`; use `negative_activation: true` for should-not-trigger
 prompts. Do not add `trigger-evals.json`.
- Treat tool-specific trigger query arrays as temporary benchmark inputs, not
 package artifacts.

## Cost-aware routing

| Work | Tier |
| --- | --- |
| Planning and high-risk review | `premium` |
| Package-local implementation | `medium` |
| Validation and cleanup | `cheap` |

## Parallel guidance

- Keep work package-local where possible.
- Use separate branches or worktrees for independent package tasks.
- Treat shared files as coordinator-owned.

## Validation

Run focused checks for changed examples or templates, then:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1
```

Do not open or merge a pull request until validation passes. If a failure is
unrelated and pre-existing, report its exact file and error.
