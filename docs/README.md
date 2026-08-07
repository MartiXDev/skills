# Documentation index

Use this map to choose the smallest useful maintainer document. Detailed
package behavior belongs in each `skills\martix-*` or `plugins\martix-*` package.

## Always-on context

- `.github\copilot-instructions.md` is the concise repository policy for agents.
- `.github\instructions\*.instructions.md` applies automatically by file scope.
- Package `SKILL.md`, `AGENTS.md`, and `README.md` are the active source for
  package behavior.

## Canonical knowledge and research

The unified documentation tree is [knowledge](./knowledge/README.md). Each
topic may contain:

- `README.md` for scope and navigation.
- `resources.md` for canonical upstream links.
- `knowledge.md` for the current synthesis or decision layer.
- `research/` for dated, source-backed snapshots.

Start with the [knowledge map](./knowledge/README.md), then use the topic map
for the relevant domain:

| Topic | Scope |
| --- | --- |
| [AI-assisted development](./knowledge/ai/README.md) | AI usage, hooks, LLMs, plugins, skills, tools, and Copilot. |
| [Matt Pocock](./knowledge/matt-pocock/README.md) | Matt Skills, Sandcastle, and related workflow research. |
| [Repository](./knowledge/repository/README.md) | Repository architecture, maintenance, and Git workflow research. |

Research snapshots are non-normative. Revalidate volatile upstream claims
before moving them into active guidance, and add a new dated snapshot rather
than silently rewriting an older baseline.

## Active maintainer guides

| Guide | Use when |
| --- | --- |
| [Repository knowledge](./knowledge/repository/knowledge.md) | Understanding layout, package rules, installs, and current architecture. |
| [Execution and routing](./guides/execution-and-routing.md) | Choosing model tier, routing surface, token budget, task classification, or worktree safety. |
| [Parallel worktree guidance](./guides/parallel-worktree-guidance.md) | Splitting package work across agents or branches. |
| [Skills installation](./guides/skills-installation.md) | Importing external skills into a target repository. |
| [Custom AI artifact rules](./policy/custom-ai-artifact-rules.md) | Creating or updating skills, plugins, agents, prompts, hooks, metadata, templates, or evals. |
| [Custom AI artifact resources](./policy/custom-ai-artifact-resources.md) | Primary-source links for artifact authoring and host behavior. |
| [Plugin bundle strategy](./architecture/plugin-bundle-strategy.md) | Deciding standalone skill versus plugin bundle boundaries. |
| [Repository roadmap](./knowledge/repository/plans/repository-roadmap.md) | Tracking planned repository, package, validation, and registry work. |
| [Skill portfolio coordination](./knowledge/repository/plans/skill-portfolio-coordination-plan.md) | Coordinating related skills and handoffs. |
| [Recommended skills research](./knowledge/ai/ecosystem/research/2026-03-25-recommended-skills.md) | Reviewing dated external skill or plugin candidates. |
| [Skill evaluation research](./knowledge/ai/skills/research/2026-07-20-skill-evals-quality.md) | Reviewing evidence and quality criteria for skill evaluations. |
| [Plugin layout policy](./plugin-layout.yaml) | Checking machine-readable package layout assumptions. |

The old root-level guide paths remain short compatibility facades for existing
links. New links should use the canonical locations above.

## Package and domain source documents

Read these on demand when changing the related package or reviewing its
history. Package behavior remains canonical in the package itself.

| Folder | Scope |
| --- | --- |
| [agents](./agents/) | Issue tracking, triage, and agent-domain operating guidance. |
| [martix-dotnet-csharp](./martix/martix-dotnet-csharp/) | .NET/C# comparisons and plans. |
| [martix-fastendpoints](./martix/martix-fastendpoints/) | FastEndpoints improvement planning. |
| [martix-fluentvalidation](./martix/martix-fluentvalidation/) | FluentValidation improvement planning. |
| [martix-fluent-ui](./martix/martix-fluent-ui/) | Fluent UI research, evidence, and skill blueprint. |
| [martix-essl](./martix/martix-essl/) | Czech eSSL source research and compliance maps. |
| [martix-markdown](./martix/martix-markdown/) | Markdown automation and package split notes. |
| [martix-csharp](./martix/martix-csharp/) | Earlier standalone C# skill planning artifacts. |
| [martix-typescript](./martix/martix-typescript/) | TypeScript skill planning and source research. |

## Read-on-demand package docs

- Use package `rules\` for enforceable guidance loaded by topic.
- Use package `references\` for maps, recipes, source indexes, and anti-patterns.
- Use package `templates\`, `assets\`, and `evals\` when changing generation or
  validation behavior.

## Common maintainer starting points

| Task | Start with |
| --- | --- |
| Understand the repository | [Repository knowledge](./knowledge/repository/knowledge.md) |
| Find current knowledge or research | [Knowledge map](./knowledge/README.md) |
| Create or update a skill or plugin artifact | [Custom AI artifact rules](./policy/custom-ai-artifact-rules.md) |
| Choose skill versus plugin ownership | [Plugin bundle strategy](./architecture/plugin-bundle-strategy.md) |
| Plan parallel package work | [Execution and routing](./guides/execution-and-routing.md) |
| Update one package | Package `README.md`, `SKILL.md`, and `AGENTS.md` |
