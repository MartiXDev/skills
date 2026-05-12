# Documentation index

Use this low-token map to choose the smallest useful maintainer document.
Detailed package behavior belongs in each `skills\martix-*` or
`plugins\martix-*` package.

## Always-on context

- `.github\copilot-instructions.md` is the concise repository policy for agents.
- `.github\instructions\*.instructions.md` applies automatically by file scope.
- Package `SKILL.md`, `AGENTS.md`, and `README.md` are the active source for
  package behavior.

## Active maintainer guides

| Guide | Use when |
| --- | --- |
| [Repository overview](./repo-overview.md) | Understanding layout, package rules, installs, and roadmap. |
| [Custom AI artifact rules](./custom-ai-artifact-rules.md) | Creating or updating skills, plugins, agents, prompts, hooks, metadata, templates, or evals. |
| [Execution profiles](./execution-profiles.md) | Choosing model tier, token budget, AFK/HITL labels, or worktree safety. |
| [LLM routing strategy](./llm-routing-strategy.md) | Reviewing cost-aware routing policy and unsupported routing locations. |
| [Plugin bundle strategy](./plugin-bundle-strategy.md) | Deciding standalone skill versus plugin bundle boundaries. |
| [Parallel worktree guidance](./parallel-worktree-guidance.md) | Splitting package work across agents or branches. |
| [Skill portfolio coordination](./skill-portfolio-coordination-plan.md) | Coordinating related skills and handoffs. |
| [Recommended skills](./recommended-skills.md) | Reviewing external skill or plugin candidates. |
| [Plugin layout policy](./plugin-layout.yaml) | Checking machine-readable package layout assumptions. |

## Domain research folders

Read these on demand when changing the related package or reviewing its history.

| Folder | Scope |
| --- | --- |
| `martix-dotnet-csharp\` | .NET/C# comparisons, plans, and research. |
| `martix-fastendpoints\` | FastEndpoints improvement planning. |
| `martix-fluentvalidation\` | FluentValidation improvement planning. |
| `martix-markdown\` | Markdown automation and package split notes. |
| `martix-csharp\` | Earlier standalone C# skill planning artifacts. |

## Read-on-demand package docs

- Use package `rules\` for enforceable guidance loaded by topic.
- Use package `references\` for maps, recipes, source indexes, and anti-patterns.
- Use package `templates\`, `assets\`, and `evals\` when changing generation or
  validation behavior.

## Common maintainer starting points

| Task | Start with |
| --- | --- |
| Understand the repository | [Repository overview](./repo-overview.md) |
| Change a skill or plugin artifact | [Custom AI artifact rules](./custom-ai-artifact-rules.md) |
| Choose skill versus plugin ownership | [Plugin bundle strategy](./plugin-bundle-strategy.md) |
| Plan parallel package work | [Execution profiles](./execution-profiles.md) |
| Update one package | Package `README.md`, `SKILL.md`, and `AGENTS.md` |
