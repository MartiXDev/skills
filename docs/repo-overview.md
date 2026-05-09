# MartiX Skills Repository Overview

## Purpose

This repository is the MartiX catalog for reusable AI skills and GitHub Copilot CLI plugin packages. It is designed to support three install and discovery paths:

- Standalone skill installs with `npx skills`.
- GitHub Copilot CLI marketplace installs through the `martix-skills` marketplace.
- Direct repository-path installs for local testing or targeted package use.

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

For local validation or tools that need an explicit package source, point directly at a skill folder:

```sh
npx skills add C:\Git\MartiXDev\skills\skills\martix-markdown -a github-copilot -y
npx skills add https://github.com/MartiXDev/skills/tree/main/skills/martix-markdown -a github-copilot -y
```

### Install directly from repository paths

Direct installs are useful when validating a source folder before relying on marketplace metadata:

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
  plugin-layout.yaml
  repo-overview.md
skills/
  martix-markdown/
  martix-dotnet-csharp/
  martix-fastendpoints/
  martix-fluentvalidation/
  martix-tunit/
  martix-powershell/
  martix-sharepoint-server/
  martix-sharepoint-spfx/
  martix-sharepoint-pnp/
plugins/
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

- [Execution profiles](./execution-profiles.md) for model-tier, token-budget, AFK/HITL, `/fleet`, and worktree guidance.
- [Plugin bundle strategy](./plugin-bundle-strategy.md) for MartiX project-family bundles and skill-versus-plugin decision rules.
- [Parallel worktree guidance](./parallel-worktree-guidance.md) for splitting work across agents and isolated worktrees.

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
| `martix-sharepoint-server` | SharePoint Server farm solutions, WSP packaging, feature framework, event receivers, branding, and site artifacts. |
| `martix-sharepoint-spfx` | SharePoint Framework development with React, TypeScript, web parts, extensions, Teams, Viva, deployment, theming, and modernization. |
| `martix-sharepoint-pnp` | PnP PowerShell, CLI for Microsoft 365, PnPjs, provisioning, automation, authentication, and cross-tool delivery. |

### Plugin bundles

| Plugin | Focus |
| --- | --- |
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

## Improvement roadmap

### 1. Normalize package completeness

Define a required package checklist for every standalone skill:

- `plugin.json`
- `metadata.json`
- `README.md`
- `SKILL.md`
- `AGENTS.md`
- `LICENSE.txt`
- `rules\`
- `references\`
- `templates\`
- `assets\taxonomy.json`
- `assets\section-order.json`
- `evals\evals.json`

Then decide whether `evals\evals.json` is mandatory for every skill or explicitly optional for early packages. The current repository has eval coverage for several skills but not all of them.

### 2. Make plugin bundles real bundles

The plugin folders already exist, but their `agents\` and `skills\` folders are placeholders. Improve them by defining the actual bundle purpose and contents:

- Identify which standalone skills each plugin should compose.
- Add plugin-scoped agents only when they add workflow value.
- Add plugin-local instructions for bundle-level behavior.
- Add hooks only for automation that cannot live inside a standalone skill.
- Document each bundle's relationship to standalone skill packages.
- Keep bundle strategy aligned with [Plugin bundle strategy](./plugin-bundle-strategy.md).

### 3. Add instruction and hook patterns

Create reusable patterns for plugin-level instructions and hooks. A high-value first example is Markdown enforcement:

- Keep `martix-markdown` as the reusable standalone skill.
- Add a plugin bundle only if automatic file-event behavior is needed.
- Put markdown policy instructions under a plugin-local `instructions\` folder.
- Put file-event automation under a plugin-local `hooks\` folder and configure it with `hooks.json`.

### 4. Standardize evals

Create a shared eval shape for all skills:

- Trigger prompts that should activate the skill.
- Negative prompts that should not activate the skill.
- Expected outputs for core routing decisions.
- Package-specific quality checks.
- Regression prompts for common mistakes.

Use evals to improve skill triggering, marketplace confidence, and future registry submissions.

### 5. Add validation automation

Add repository checks that can run locally and in CI:

- Parse every JSON file.
- Parse every YAML file.
- Check marketplace entries against source `plugin.json` values.
- Check that every marketplace `source` exists.
- Check required files for each skill and plugin.
- Check README relative links.
- Check Markdown code fence balance.
- Check taxonomy and section-order files against actual rule/reference/template paths.

These checks should become the quality gate before publishing or opening release PRs.

### 6. Prepare external registry readiness

Improve every package for discoverability in external catalogs:

- Clear one-line description.
- Concise keyword set.
- Stable install instructions.
- License clarity.
- Examples of ideal prompts or use cases.
- Links to README, `SKILL.md`, and key references.
- Consistent versioning.
- Consistent naming with the `martix-` prefix.

The repository should remain compatible with Copilot CLI marketplace metadata while keeping standalone skills easy to evaluate for other skill registries.

### 7. Add templates for future packages

Create templates for:

- New standalone skill package.
- New plugin bundle package.
- `plugin.json`.
- `metadata.json`.
- `SKILL.md`.
- `AGENTS.md`.
- `README.md`.
- `evals\evals.json`.
- Taxonomy and section-order assets.
- Plugin-local instruction, prompt, hook, and agent assets.

Templates reduce drift and make future packages easier to publish consistently.

### 8. Keep model usage efficient

Use [Execution profiles](./execution-profiles.md) to classify package work by task type, model tier, token budget, and parallel safety:

- Premium models for ambiguous planning, architecture, security, and high-risk review.
- Medium models for approved package-local implementation.
- Cheap models for validation, metadata sync, link checks, and mechanical cleanup.
- `/fleet` and worktree-ready slices for package-local AFK work.

## Recommended implementation order

1. Finalize this overview as the repository architecture guide.
2. Add package completeness and marketplace consistency validation.
3. Normalize eval coverage across all standalone skills.
4. Define execution profiles for model-tier and parallel-readiness guidance.
5. Define real contents for `martix-dotnet-library` and `martix-webapi` plugin bundles.
6. Add reusable templates for new skills and plugins.
7. Add plugin-level instruction and hook examples where automation is required.
8. Polish registry-facing metadata and examples for each package.
