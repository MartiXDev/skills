# Parallel worktree guidance

Use this guide when splitting MartiX skill or plugin work across Copilot CLI `/fleet`, multiple agents, or multiple git worktrees.

## Goals

- Keep parallel work package-scoped and mergeable.
- Avoid simultaneous edits to shared files.
- Give each agent a clear validation-based completion signal.
- Use cheaper models for deterministic package-local tasks.

## Work classification

| Label | Meaning | Example |
| --- | --- | --- |
| `AFK` | The agent can finish without more human decisions. | Add evals from an approved template for one skill. |
| `HITL` | A human decision is required before implementation. | Decide whether React/TypeScript guidance is a new skill or plugin-local content. |
| `Coordinator` | The task owns shared files or merge ordering. | Update marketplace metadata after package branches land. |

## Worktree rules

1. Use one worktree per package or vertical slice.
2. Use a unique branch name per worktree.
3. Keep writes inside the assigned package unless the task is explicitly a coordinator task.
4. Run validation before marking the branch complete.
5. Merge shared contract changes before branches that depend on them.

## Branch naming

Use short branch names that identify the scope:

```text
roadmap/validation-script
roadmap/evals-martix-tunit
roadmap/plugin-martix-webapi
roadmap/templates
roadmap/metadata-coordinator
```

## Shared-file coordinator ownership

Only one active task should own these at a time:

- `.github\plugin\marketplace.json`
- root `README.md`
- `skills\README.md`
- `plugins\README.md`
- `docs\repo-overview.md`
- `docs\plugin-layout.yaml`
- `docs\execution-profiles.md`
- shared templates under `templates\`
- `scripts\validate-repository.ps1`

Package-local agents may propose changes to shared files, but the coordinator applies them.

## Good `/fleet` slices

Good slices are narrow and independently verifiable:

- Add evals for one skill.
- Polish metadata for one skill.
- Add README/instructions/prompts/hooks docs for one plugin.
- Validate one package's taxonomy and section order.
- Apply one template to one new package.

Avoid assigning broad repository-wide rewrites to many parallel agents unless a coordinator owns the shared output.

## Completion signal

Every parallel slice should end with:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1
```

If the slice is intentionally running before all roadmap assets exist, use baseline flags only when the parent plan explicitly allows it:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1 -AllowIncompletePlugins
```

Do not treat baseline warnings as final success.

## Model-tier guidance

| Work | Recommended tier |
| --- | --- |
| Cross-package planning, bundle boundaries, architecture decisions | `premium` |
| Package-local implementation from an approved plan | `medium` |
| Mechanical metadata edits, link fixes, validation runs | `cheap` |

Use premium requests sparingly. A premium planning task should produce enough detail that medium or cheap agents can complete the follow-up slices.
