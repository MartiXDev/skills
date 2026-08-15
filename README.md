# MartiX Skills

<!-- markdownlint-configure-file { "MD013": { "tables": false } } -->

MartiX AI Skills and Plugins for GitHub Copilot CLI — marketplace-ready skill
packages and plugin bundles for .NET, Power Platform, SharePoint, Markdown, and
more.

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
copilot plugin install martix-dotnet-csharp@martix-skills
copilot plugin install martix-essl@martix-skills
copilot plugin install martix-fastendpoints@martix-skills
copilot plugin install martix-fluent-ui@martix-skills
copilot plugin install martix-fluentvalidation@martix-skills
copilot plugin install martix-git@martix-skills
copilot plugin install martix-markdown@martix-skills
copilot plugin install martix-platform@martix-skills
copilot plugin install martix-power-platform@martix-skills
copilot plugin install martix-powershell@martix-skills
copilot plugin install martix-sharepoint-pnp@martix-skills
copilot plugin install martix-sharepoint-server@martix-skills
copilot plugin install martix-sharepoint-spfx@martix-skills
copilot plugin install martix-tunit@martix-skills
copilot plugin install martix-typescript@martix-skills

# Plugins (full bundles)
copilot plugin install martix-dotnet-library@martix-skills
copilot plugin install martix-git-automation@martix-skills
copilot plugin install martix-markdown-automation@martix-skills
copilot plugin install martix-webapi@martix-skills
```

For standalone skill installs, use repo-root skill selection:

```sh
npx skills add https://github.com/MartiXDev/skills --skill martix-dotnet-csharp
npx skills add https://github.com/MartiXDev/skills --skill martix-essl
npx skills add https://github.com/MartiXDev/skills --skill martix-fastendpoints
npx skills add https://github.com/MartiXDev/skills --skill martix-fluent-ui
npx skills add https://github.com/MartiXDev/skills --skill martix-fluentvalidation
npx skills add https://github.com/MartiXDev/skills --skill martix-git
npx skills add https://github.com/MartiXDev/skills --skill martix-markdown
npx skills add https://github.com/MartiXDev/skills --skill martix-platform
npx skills add https://github.com/MartiXDev/skills --skill martix-power-platform
npx skills add https://github.com/MartiXDev/skills --skill martix-powershell
npx skills add https://github.com/MartiXDev/skills --skill martix-sharepoint-pnp
npx skills add https://github.com/MartiXDev/skills --skill martix-sharepoint-server
npx skills add https://github.com/MartiXDev/skills --skill martix-sharepoint-spfx
npx skills add https://github.com/MartiXDev/skills --skill martix-tunit
npx skills add https://github.com/MartiXDev/skills --skill martix-typescript
```

For local validation or development, install directly from a repository path:

```sh
copilot plugin install MartiXDev/skills:plugins/martix-dotnet-library
copilot plugin install MartiXDev/skills:plugins/martix-git-automation
copilot plugin install MartiXDev/skills:plugins/martix-markdown-automation
copilot plugin install MartiXDev/skills:plugins/martix-webapi
copilot plugin install MartiXDev/skills:skills/martix-dotnet-csharp
copilot plugin install MartiXDev/skills:skills/martix-essl
copilot plugin install MartiXDev/skills:skills/martix-fastendpoints
copilot plugin install MartiXDev/skills:skills/martix-fluent-ui
copilot plugin install MartiXDev/skills:skills/martix-fluentvalidation
copilot plugin install MartiXDev/skills:skills/martix-git
copilot plugin install MartiXDev/skills:skills/martix-markdown
copilot plugin install MartiXDev/skills:skills/martix-platform
copilot plugin install MartiXDev/skills:skills/martix-power-platform
copilot plugin install MartiXDev/skills:skills/martix-powershell
copilot plugin install MartiXDev/skills:skills/martix-sharepoint-pnp
copilot plugin install MartiXDev/skills:skills/martix-sharepoint-server
copilot plugin install MartiXDev/skills:skills/martix-sharepoint-spfx
copilot plugin install MartiXDev/skills:skills/martix-tunit
copilot plugin install MartiXDev/skills:skills/martix-typescript
```

## Plugin-to-Skill Matrix

Legend: 🟢 bundled in the plugin, 🔴 not bundled in that plugin.

| Skill \ Plugin | `martix-markdown-automation` | `martix-dotnet-library` | `martix-webapi` | `martix-git-automation` |
| --- | --- | --- | --- | --- |
| `martix-dotnet-csharp` | 🔴 | 🟢 | 🟢 | 🔴 |
| `martix-essl` | 🔴 | 🔴 | 🔴 | 🔴 |
| `martix-fastendpoints` | 🔴 | 🔴 | 🟢 | 🔴 |
| `martix-fluent-ui` | 🔴 | 🔴 | 🔴 | 🔴 |
| `martix-fluentvalidation` | 🔴 | 🟢 | 🟢 | 🔴 |
| `martix-git` | 🔴 | 🔴 | 🔴 | 🔴 |
| `martix-markdown` | 🟢 | 🟢 | 🟢 | 🔴 |
| `martix-platform` | 🔴 | 🔴 | 🔴 | 🔴 |
| `martix-power-platform` | 🔴 | 🔴 | 🔴 | 🔴 |
| `martix-powershell` | 🔴 | 🟢 | 🔴 | 🔴 |
| `martix-sharepoint-pnp` | 🔴 | 🔴 | 🔴 | 🔴 |
| `martix-sharepoint-server` | 🔴 | 🔴 | 🔴 | 🔴 |
| `martix-sharepoint-spfx` | 🔴 | 🔴 | 🔴 | 🔴 |
| `martix-tunit` | 🔴 | 🟢 | 🟢 | 🔴 |
| `martix-typescript` | 🔴 | 🔴 | 🔴 | 🔴 |

## Uninstall or Remove

Use the following commands to remove a plugin or one or more installed skills.
For the authoritative CLI reference, see
[GitHub Copilot CLI plugin reference - GitHub Docs](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference).
For the standalone skills workflow, see
[vercel-labs/skills: The open agent skills tool - npx skills](https://github.com/vercel-labs/skills).

### Remove a Copilot CLI plugin

```sh
copilot plugin uninstall martix-dotnet-library
copilot plugin uninstall martix-git-automation
copilot plugin uninstall martix-markdown-automation
copilot plugin uninstall martix-webapi
```

### Remove one or more installed skills

```sh
npx skills list
npx skills remove martix-dotnet-csharp
npx skills remove martix-dotnet-csharp martix-markdown
npx skills remove --global martix-dotnet-csharp martix-essl \
  martix-fastendpoints martix-fluent-ui martix-fluentvalidation \
  martix-markdown martix-platform martix-power-platform martix-powershell \
  martix-sharepoint-pnp \
  martix-sharepoint-server martix-sharepoint-spfx martix-tunit martix-typescript
npx skills remove --all
```

### Remove a marketplace registration

```sh
copilot plugin marketplace remove martix-skills
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
  martix-git/               # Safe Git and GitHub workflow guidance
  martix-tunit/             # TUnit test authoring and parallel execution
  martix-powershell/        # PowerShell cmdlet development
  martix-typescript/        # TypeScript 7 engineering and migration
  martix-fluent-ui/         # React-first Fluent UI v9 engineering
  martix-essl/              # Czech eSSL compliance and implementation
  martix-platform/          # MartiX.Platform architecture and .NET web apps
  martix-power-platform/    # Power Platform flows and custom connectors
  martix-sharepoint-server/ # SharePoint Server on-prem farm solutions
  martix-sharepoint-spfx/   # SharePoint Framework (SPFx) development
  martix-sharepoint-pnp/    # SharePoint PnP PowerShell, CLI for M365, PnPjs
plugins/
  martix-markdown-automation/ # Automatic Markdown check and fix workflow
  martix-dotnet-library/    # .NET library create, update, and review
  martix-git-automation/   # Report-first Git and GitHub workflow automation
  martix-webapi/            # .NET 10 web app planning and implementation
```

Each entry in `skills/` is a standalone skill package with a `plugin.json`,
root-level `SKILL.md`, `AGENTS.md`, and supporting rules, references, templates,
assets, and metadata. Each entry in `plugins/` is a plugin bundle with
`plugin.json` and plugin-scoped agents, skills, hooks, or configuration as
needed.

## Maintainer Guides

For a compact entry point to the documentation tree, see the
[docs index](./docs/README.md). It is the detailed maintainer router for the
canonical role-based documentation tree.

| Guide | Purpose |
| --- | --- |
| [Repository knowledge](./docs/knowledge/repository/knowledge.md) | Architecture, package rules, marketplace model, and current maintenance guidance. |
| [Custom AI artifact rules](./docs/policy/custom-ai-artifact-rules.md) | Rules for instructions, skills, plugins, agents, prompts, hooks, MCP/LSP, metadata, templates, and evals. |
| [Custom AI artifact resources](./docs/policy/custom-ai-artifact-resources.md) | Primary-source links for reviewing and refreshing artifact rules. |
| [Execution and routing](./docs/guides/execution-and-routing.md) | Model-tier, routing, token-budget, decision-based task classification, `/fleet`, and worktree guidance. |
| [Plugin bundle strategy](./docs/architecture/plugin-bundle-strategy.md) | MartiX project-family bundles and skill-versus-plugin decision rules. |
| [Parallel worktree guidance](./docs/guides/parallel-worktree-guidance.md) | Splitting package work across agents and worktrees. |
| [Skills installation](./docs/guides/skills-installation.md) | Stable installation and verification mechanics for imported skills. |
| [Skill portfolio coordination](./docs/knowledge/repository/plans/skill-portfolio-coordination-plan.md) | Cross-skill routing and companion-skill handoff planning. |
| [Recommended skills research](./docs/knowledge/ai/ecosystem/research/2026-03-25-recommended-skills.md) | Dated external skill/plugin ecosystem shortlist. |
| [Skill evaluation research](./docs/knowledge/ai/skills/research/2026-07-20-skill-evals-quality.md) | Dated evidence and quality criteria for skill evaluations. |
| [Plugin layout policy](./docs/plugin-layout.yaml) | Machine-readable layout policy and validation assumptions. |

## Documentation Map

The [docs index](./docs/README.md) is the detailed maintainer map. Canonical
documentation is organized by role, while package-scoped source research and
implementation plans remain under [`docs/martix/`](./docs/martix/):

| Folder | Purpose |
| --- | --- |
| [`docs/policy/`](./docs/policy/README.md) | Normative artifact rules and their primary-source registry. |
| [`docs/guides/`](./docs/guides/README.md) | Operational maintainer procedures. |
| [`docs/architecture/`](./docs/architecture/README.md) | Stable package-boundary and composition decisions. |
| [`docs/knowledge/`](./docs/knowledge/README.md) | Unified topic maps, source registries, current knowledge, and dated research. |
| [`docs/agents/`](./docs/agents/) | Issue tracking, triage, and agent-domain operating guidance. |
| [`docs/martix/martix-dotnet-csharp/`](./docs/martix/martix-dotnet-csharp/) | .NET/C# comparisons and plans. |
| [`docs/martix/martix-fastendpoints/`](./docs/martix/martix-fastendpoints/) | FastEndpoints improvement plan. |
| [`docs/martix/martix-fluentvalidation/`](./docs/martix/martix-fluentvalidation/) | FluentValidation improvement plan. |
| [`docs/martix/martix-fluent-ui/`](./docs/martix/martix-fluent-ui/) | Fluent UI research and skill blueprint. |
| [`docs/martix/martix-essl/`](./docs/martix/martix-essl/) | Czech eSSL source research and compliance maps. |
| [`docs/martix/martix-markdown/`](./docs/martix/martix-markdown/) | Markdown automation and package split rationale. |
| [`docs/martix/martix-csharp/`](./docs/martix/martix-csharp/) | Planning artifacts for the standalone C# skill. |
| [`docs/martix/martix-power-platform/`](./docs/martix/martix-power-platform/) | Power Platform and custom connector source research. |
| [`docs/martix/martix-typescript/`](./docs/martix/martix-typescript/) | TypeScript skill planning and source research. |

Canonical package behavior lives in each `skills/martix-*` package, especially
its `SKILL.md`, `AGENTS.md`, rules, references, metadata, and evals.

## Which Doc Should I Read?

| Task | Start with |
| --- | --- |
| Understand repository structure | [Repository knowledge](./docs/knowledge/repository/knowledge.md) and [Plugin layout policy](./docs/plugin-layout.yaml) |
| Create or update a skill, plugin, or AI artifact | [Custom AI artifact rules](./docs/policy/custom-ai-artifact-rules.md) |
| Decide skill versus plugin boundaries | [Plugin bundle strategy](./docs/architecture/plugin-bundle-strategy.md) |
| Assign model tier or split fleet work | [Execution and routing](./docs/guides/execution-and-routing.md) |
| Coordinate multiple skills | [Skill portfolio coordination](./docs/knowledge/repository/plans/skill-portfolio-coordination-plan.md) |
