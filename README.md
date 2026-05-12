# MartiX Skills

MartiX AI Skills and Plugins for GitHub Copilot CLI — marketplace-ready skill
packages and plugin bundles for .NET, SharePoint, Markdown, and more.

## Marketplace

This repository is a GitHub Copilot CLI plugin marketplace. The marketplace name
is **`martix-skills`**.

Add the marketplace to your Copilot CLI:

```sh
copilot plugin marketplace add MartiXDev/skills
```

## Quick Install

Install paths are preferred in this order:

1. Marketplace installs for normal Copilot CLI users.
2. Repo-root `npx skills add ... --skill ...` for standalone skill installs.
3. Direct repository-path installs for local validation or development.

Install a specific skill or plugin after adding the marketplace:

```sh
# Skills (standalone)
copilot plugin install martix-markdown@martix-skills
copilot plugin install martix-dotnet-csharp@martix-skills
copilot plugin install martix-fastendpoints@martix-skills
copilot plugin install martix-fluentvalidation@martix-skills
copilot plugin install martix-tunit@martix-skills
copilot plugin install martix-powershell@martix-skills
copilot plugin install martix-sharepoint-server@martix-skills
copilot plugin install martix-sharepoint-spfx@martix-skills
copilot plugin install martix-sharepoint-pnp@martix-skills

# Plugins (full bundles)
copilot plugin install martix-markdown-automation@martix-skills
copilot plugin install martix-dotnet-library@martix-skills
copilot plugin install martix-webapi@martix-skills
```

For standalone skill installs, use repo-root skill selection:

```sh
npx skills add https://github.com/MartiXDev/skills --skill martix-markdown
npx skills add https://github.com/MartiXDev/skills --skill martix-dotnet-csharp
```

For local validation or development, install directly from a repository path:

```sh
copilot plugin install MartiXDev/skills:skills/martix-markdown
copilot plugin install MartiXDev/skills:skills/martix-dotnet-csharp
copilot plugin install MartiXDev/skills:plugins/martix-dotnet-library
```

## Repository Structure

```text
.github/
  plugin/
    marketplace.json        # Marketplace definition (name: "martix-skills")
skills/
  martix-markdown/          # Markdownlint authoring and accessibility review
  martix-dotnet-csharp/     # .NET 10+ and C# 14+ modernization and review
  martix-fastendpoints/     # FastEndpoints startup, contracts, and AOT
  martix-fluentvalidation/  # FluentValidation authoring and testing
  martix-tunit/             # TUnit test authoring and parallel execution
  martix-powershell/        # PowerShell cmdlet development
  martix-sharepoint-server/ # SharePoint Server on-prem farm solutions
  martix-sharepoint-spfx/   # SharePoint Framework (SPFx) development
  martix-sharepoint-pnp/    # SharePoint PnP PowerShell, CLI for M365, PnPjs
plugins/
  martix-markdown-automation/ # Automatic Markdown check and fix workflow
  martix-dotnet-library/    # .NET library create, update, and review
  martix-webapi/            # .NET 10 web app planning and implementation
```

Each entry in `skills/` is a standalone skill package with a `plugin.json`,
root-level `SKILL.md`, `AGENTS.md`, and supporting rules, references, templates,
assets, and metadata. Each entry in `plugins/` is a plugin bundle with
`plugin.json` and plugin-scoped agents, skills, hooks, or configuration as
needed.

## Maintainer Guides

For a compact entry point to the documentation tree, see the
[docs index](./docs/README.md).

| Guide | Purpose |
| --- | --- |
| [Repository overview](./docs/repo-overview.md) | Architecture, package rules, marketplace model, and roadmap. |
| [Custom AI artifact rules](./docs/custom-ai-artifact-rules.md) | Rules for instructions, skills, plugins, agents, prompts, hooks, MCP/LSP, metadata, templates, and evals. |
| [Execution profiles](./docs/execution-profiles.md) | Model-tier, token-budget, AFK/HITL, `/fleet`, and worktree guidance. |
| [LLM routing strategy](./docs/llm-routing-strategy.md) | Cost-aware model tier policy and unsupported routing anti-patterns. |
| [Plugin bundle strategy](./docs/plugin-bundle-strategy.md) | MartiX project-family bundles and skill-versus-plugin decision rules. |
| [Parallel worktree guidance](./docs/parallel-worktree-guidance.md) | Splitting package work across agents and worktrees. |
| [Skill portfolio coordination](./docs/skill-portfolio-coordination-plan.md) | Cross-skill routing and companion-skill handoff planning. |
| [Recommended skills](./docs/recommended-skills.md) | External skill/plugin ecosystem shortlist and install notes. |
| [Plugin layout policy](./docs/plugin-layout.yaml) | Machine-readable layout policy and validation assumptions. |

## Documentation Map

The root docs above are the active maintainer guides. Domain folders under
`docs/` contain source research, comparisons, or implementation plans that
informed the installable packages:

| Folder | Purpose |
| --- | --- |
| `docs/martix-dotnet-csharp/` | .NET/C# comparisons and plans. |
| `docs/martix-fastendpoints/` | FastEndpoints improvement plan. |
| `docs/martix-fluentvalidation/` | FluentValidation improvement plan. |
| `docs/martix-markdown/` | Markdown automation and package split rationale. |
| `docs/martix-csharp/` | Planning artifacts for the standalone C# skill. |

Canonical package behavior lives in each `skills/martix-*` package, especially
its `SKILL.md`, `AGENTS.md`, rules, references, metadata, and evals.

## Which Doc Should I Read?

| Task | Start with |
| --- | --- |
| Understand repository structure | [Repository overview](./docs/repo-overview.md) and [Plugin layout policy](./docs/plugin-layout.yaml) |
| Create or update a skill, plugin, or AI artifact | [Custom AI artifact rules](./docs/custom-ai-artifact-rules.md) |
| Decide skill versus plugin boundaries | [Plugin bundle strategy](./docs/plugin-bundle-strategy.md) |
| Assign model tier or split fleet work | [Execution profiles](./docs/execution-profiles.md) and [LLM routing strategy](./docs/llm-routing-strategy.md) |
| Coordinate multiple skills | [Skill portfolio coordination](./docs/skill-portfolio-coordination-plan.md) |
