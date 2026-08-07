# Repository knowledge and research

This topic contains repository-level investigation, maintenance plans, and
workflow evidence that informs the installable packages and repository policy.
The [resource registry](./resources.md) is the canonical list of upstream
references for this topic.

## Placement and roles

- Put current repository-wide guidance in this topic's `knowledge.md` when it
  is reusable and normative.
- Put dated investigations and proposals under
  [`research/`](./research/), preserving the date in each filename.
- Put package-specific source research under the relevant
  [`docs/martix/`](../../martix/) folder.
- Link every new document from this page or the [root docs map](../../README.md).
- Do not create a parallel research tree.

## Current subtopics

- [`ai-dev-factory/`](./research/ai-dev-factory/) — AFK/dev-factory automation
  and related workflows.
- [`git-worktree-workflows/`](./research/git-worktree-workflows/) — worktree
  inventory, cleanup planning, operational checklists, and automation notes.
- [`plans/`](./plans/) — repository roadmap and cross-skill coordination plans.

## Dated research snapshots

| Snapshot | Scope |
| --- | --- |
| [AI agent ecosystem and documentation review](./research/2026-07-22-ai-agent-ecosystem-and-documentation-review.md) | Documentation drift, Agent Skills, Copilot plugins and hooks, MCP, prompt caching, model costs, and evaluation strategy. |
| [Matt Skills and Sandcastle integration](./research/2026-07-22-matt-skills-and-sandcastle-integration.md) | Matt Skills planning workflow, Sandcastle orchestration, integration surfaces, and evidence gaps. |
| [MartiX plugin and skill refactor plan](./research/martix-plugin-and-skill-refactor-plan.md) | Repository package-boundary and refactor planning. |

## Current repository guidance

| Role | Document |
| --- | --- |
| Architecture and maintenance | [knowledge.md](./knowledge.md) |
| Roadmap | [repository-roadmap.md](./plans/repository-roadmap.md) |
| Cross-skill coordination | [skill-portfolio-coordination-plan.md](./plans/skill-portfolio-coordination-plan.md) |

## Refresh workflow

1. Update or add the relevant source link in `resources.md`.
2. Add a dated snapshot under `research/` for materially new evidence.
3. Promote only revalidated conclusions into current repository guidance.
4. Update this index when a topic or role changes.
