# <Skill Display Name> agents guide

Use this guide for maintainer workflows, cross-skill handoffs, and longer review routes.

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
- Run repository validation before merge.
