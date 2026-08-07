# MartiX Skills Repository Knowledge

<!-- markdownlint-disable MD013 MD024 -->

## Purpose

This document is the current repository architecture and maintenance guide for
the MartiX catalog of reusable AI skills and GitHub Copilot CLI plugin packages.
It supports three install and discovery paths, preferred in this order:

1. GitHub Copilot CLI marketplace installs through the `martix-skills` marketplace.
2. Repo-root standalone skill installs with `npx skills add ... --skill ...`.
3. Direct repository-path installs for local validation or development.

The repository is intentionally organized around reusable standalone skills first. Plugin packages are reserved for bundles that need plugin-scoped agents, bundled skills, instructions, hooks, prompts, or MCP configuration.

## Install surfaces

### Add the Copilot CLI marketplace

```sh
copilot plugin marketplace add MartiXDev/skills
```

After adding the marketplace, install packages by marketplace name:

```sh
copilot plugin install martix-markdown@martix-skills
copilot plugin install martix-dotnet-csharp@martix-skills
copilot plugin install martix-dotnet-library@martix-skills
```

### Install standalone skills

Use repo-root skill selection as the preferred standalone install pattern:

```sh
npx skills add https://github.com/MartiXDev/skills --skill martix-markdown
npx skills add https://github.com/MartiXDev/skills --skill martix-dotnet-csharp
```

For local validation or development, point directly at a skill folder:

```sh
npx skills add .\skills\martix-markdown -a github-copilot -y
npx skills add https://github.com/MartiXDev/skills/tree/main/skills/martix-markdown -a github-copilot -y
```

### Install directly from repository paths

Direct repository-path installs are for local validation or development:

```sh
copilot plugin install MartiXDev/skills:skills/martix-markdown
copilot plugin install MartiXDev/skills:plugins/martix-dotnet-library
```

## Repository layout

```text
.github/
  plugin/
    marketplace.json
docs/
  README.md
  policy/
  guides/
  architecture/
  knowledge/
  plugin-layout.yaml
skills/
  martix-markdown/
  martix-dotnet-csharp/
  martix-fastendpoints/
  martix-fluentvalidation/
  martix-tunit/
  martix-powershell/
  martix-typescript/
  martix-fluent-ui/
  martix-essl/
  martix-sharepoint-server/
  martix-sharepoint-spfx/
  martix-sharepoint-pnp/
plugins/
  martix-markdown-automation/
  martix-dotnet-library/
  martix-webapi/
```

The machine-readable layout policy is `docs\plugin-layout.yaml`. It defines:

- `skills\` as the standalone skill root.
- `plugins\` as the plugin package root.
- `plugin.json` as the package manifest filename.
- `martix-` as the required package-name prefix.
- `.github\plugin\marketplace.json` as metadata only, not a place for source files.

Related maintainer guides:

- [Execution and routing](../../guides/execution-and-routing.md) for model-tier,
  routing, token-budget, decision-based task classification, `/fleet`, and
  worktree guidance.
- [Plugin bundle strategy](../../architecture/plugin-bundle-strategy.md) for
  MartiX project-family bundles and skill-versus-plugin decision rules.
- [Parallel worktree guidance](../../guides/parallel-worktree-guidance.md) for
  splitting work across agents and isolated worktrees.

## Package types

### Standalone skills

Create or update `skills\<skill-name>\` when the package can work as a self-contained skill. A standalone skill should contain:

| Path | Purpose |
| --- | --- |
| `plugin.json` | Copilot CLI package manifest for marketplace and direct installs. |
| `metadata.json` | Rich package inventory, taxonomy, release notes, and registry-facing metadata. |
| `README.md` | User and maintainer guidance for the package. |
| `SKILL.md` | Primary skill instructions and routing entrypoint. |
| `AGENTS.md` | Maintainer and companion-agent guidance. |
| `rules\` | Domain rules and reusable guidance. |
| `references\` | Source maps, decision maps, compatibility notes, and supporting references. |
| `templates\` | Authoring scaffolds and repeatable examples. |
| `assets\` | Machine-readable taxonomy, section ordering, and related data. |
| `evals\evals.json` | Evaluation prompts and expected behavior where available. |

Prefer standalone skills when:

- The package is useful on its own.
- It does not need file hooks, plugin-level instructions, MCP servers, or custom agent packaging.
- It can be published directly through the marketplace metadata.
- It should also be eligible for external skill registries.

### Plugin bundles

Create or update `plugins\<plugin-name>\` when the package needs a plugin wrapper around multiple assets. Plugin bundles may contain:

| Path | Purpose |
| --- | --- |
| `plugin.json` | Plugin manifest with package identity and asset roots. |
| `agents\` | Custom agents owned by the plugin. |
| `skills\` | Plugin-scoped skills or bundled skill copies when required. |
| `instructions\` | Plugin-local behavior policies. |
| `prompts\` | Reusable prompt assets. |
| `hooks\` | Automation hooks, such as file-event checks. |
| `hooks.json` | Hook configuration, if the plugin needs hooks. |
| `.mcp.json` | MCP server configuration, if needed. |

Prefer a plugin bundle when:

- A workflow needs several skills installed as one unit.
- Instructions must apply across a plugin workflow.
- Hooks must react to file changes or command events.
- Custom agents, prompts, or MCP configuration are part of the package.
- The bundle has a user-facing purpose beyond a single standalone skill.

## Marketplace model

The marketplace index is `.github\plugin\marketplace.json`. It registers both standalone skill sources and plugin bundle sources under the `martix-skills` marketplace.

Each marketplace entry should stay aligned with its source manifest:

- `name` must match the source `plugin.json`.
- `version` must match the source `plugin.json`.
- `description` should match the source `plugin.json` unless there is a deliberate marketplace-specific reason.
- `source` must point to either `skills\<skill-name>` or `plugins\<plugin-name>`.
- `tags` should be concise, searchable, and registry-friendly.

Standalone skills can be listed directly in the marketplace. Plugin bundles should be listed when they provide an installable bundle, workflow, agent set, instruction set, hook set, or other plugin-scoped behavior.

## Current package catalog

### Standalone skills

| Skill | Focus |
| --- | --- |
| `martix-markdown` | Markdownlint authoring, lint repair, config decisions, custom rules, and accessibility-aware review. |
| `martix-dotnet-csharp` | .NET 10+ and C# 14+ authoring, modernization, and review. |
| `martix-fastendpoints` | FastEndpoints startup, endpoint contracts, processors, testing, versioning, and Native AOT workflows. |
| `martix-fluentvalidation` | FluentValidation authoring, RuleSets, ASP.NET Core integration, async validation, localization, and testing. |
| `martix-tunit` | TUnit test authoring, parameterized tests, lifecycle hooks, parallel execution, and framework comparison. |
| `martix-powershell` | PowerShell cmdlet authoring, advanced functions, parameters, pipeline behavior, errors, and ShouldProcess patterns. |
| `martix-typescript` | TypeScript 7 configuration, migration, libraries, advanced types, runtime boundaries, and TS6 compiler-API compatibility. |
| `martix-fluent-ui` | React-first Fluent UI v9 design-system, accessibility, styling, SSR, and migration guidance. |
| `martix-essl` | Czech eSSL compliance, metadata, WS API, SIP, and attestation readiness. |
| `martix-sharepoint-server` | SharePoint Server farm solutions, WSP packaging, feature framework, event receivers, branding, and site artifacts. |
| `martix-sharepoint-spfx` | SharePoint Framework development with React, TypeScript, web parts, extensions, Teams, Viva, deployment, theming, and modernization. |
| `martix-sharepoint-pnp` | PnP PowerShell, CLI for Microsoft 365, PnPjs, provisioning, automation, authentication, and cross-tool delivery. |

### Plugin bundles

| Plugin | Focus |
| --- | --- |
| `martix-markdown-automation` | Workspace-level Markdown check and fix workflows. |
| `martix-dotnet-library` | Unified .NET library create, update, and review workflows. |
| `martix-webapi` | Planning and implementation workflows for new .NET 10 web apps. |

## Maintenance rules

1. Keep package identity synchronized across `plugin.json`, `metadata.json`, README files, and marketplace entries.
2. Keep standalone skill source under `skills\<skill-name>\` unless plugin scoping is required.
3. Keep plugin-scoped agents, skills, instructions, prompts, hooks, and MCP configuration under `plugins\<plugin-name>\`.
4. Do not place installable source files under `.github\`; keep `.github\plugin\marketplace.json` as marketplace metadata.
5. Update `assets\taxonomy.json` and `assets\section-order.json` whenever rules, references, templates, or eval routes move.
6. Add or update `evals\evals.json` when a skill's routing, trigger behavior, or expected answer quality changes.
7. Keep installation examples stable and prefer the repo-root `npx skills add ... --skill ...` form for standalone skill docs.
8. Keep descriptions short enough for marketplace browsing but specific enough for search and external registries.
9. Keep package instructions concise: route from `SKILL.md` to the smallest necessary rule or reference instead of loading broad context by default.
10. Use execution profiles to route premium models to planning/review, medium models to standard implementation, and cheap models to deterministic validation or cleanup.

## Roadmap

The current repository roadmap is maintained separately from stable architecture
guidance. See [Repository roadmap](./plans/repository-roadmap.md) for planned
package, plugin, validation, and registry work.
