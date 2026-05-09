# <plugin-display-name> instructions

Use this file for plugin-level behavior that applies across the bundle.

## Routing rules

- Keep reusable domain guidance in standalone skills.
- Use this plugin only for bundle-level setup, orchestration, and project workflow.
- Read only the relevant standalone skill entrypoint before opening deeper rules.
- Prefer concise answers and link to package files instead of restating long guidance.

## Model-tier rules

| Task | Tier |
| --- | --- |
| Ambiguous planning, architecture, security, or bundle-boundary decisions | `premium` |
| Approved package-local implementation or documentation work | `medium` |
| Validation, metadata sync, and mechanical cleanup | `cheap` |

## Parallel rules

- Use one worktree per package or vertical slice.
- Mark unclear decisions as HITL before implementation.
- Treat shared files as coordinator-owned.
- Run repository validation before merge.
