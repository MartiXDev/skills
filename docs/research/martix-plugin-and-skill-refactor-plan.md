# MartiX plugin and skill refactor plan

<!-- markdownlint-disable MD013 -->

> **Research date**: 2026-07-24  
> **Status**: Proposal for repository refactoring and future skill packaging

## Executive summary

The repository should keep a clear boundary between reusable standalone skills and workflow-oriented plugin bundles. The current repository already points in that direction: standalone skills live under the skills tree, while plugins bundle project-family workflows, prompts, instructions, hooks, or agents that are not reusable enough to justify their own standalone skill package. The next refactor step should make that boundary explicit for the future MartiX Git and Platform capabilities so the catalog stays organized as more skills are added.

### Key conclusion

- Keep reusable domain knowledge as standalone skills.
- Keep plugin bundles for repeatable workflows and project-family setup.
- Treat MartiX Git as a workflow plugin, not as a replacement for the reusable skill layer.
- Treat MartiX Platform as a standalone skill first, and only promote it to a plugin bundle if you later need bundle-level prompts, hooks, or agents.
- Do not keep a separate dotnet-library plugin in the target architecture; your client-facing library work should center on MartiX Platform instead.

## Source basis

- The repository’s plugin strategy says standalone skills are the default and plugins are for project-family bundles that need workflow-level assets: [docs/plugin-bundle-strategy.md](../plugin-bundle-strategy.md).
- The repository overview states that skills belong under the skills tree and plugins belong under the plugins tree, with marketplace entries aligned to package manifests: [docs/repo-overview.md](../repo-overview.md).
- The existing Git worktree research already recommends a broader martix-git plugin and a standalone conventional-commit skill: [docs/research/git-worktree-workflows/martix-git-plugin-plan.md](./git-worktree-workflows/martix-git-plugin-plan.md).
- The Platform blueprint describes MartiX Platform as a standalone skill source in the Platform repository and as a canonical knowledge/router package, not as a thin plugin wrapper: <https://github.com/MartiXDev/Platform/blob/main/docs/wayfinder/martix-platform/platform-blueprint.md>.

## Current state

The repository already has two active plugin bundles and a growing skill catalog:

- Existing plugin bundles: martix-markdown-automation and martix-webapi.
- Existing standalone skills: markdown, dotnet-csharp, fastendpoints, fluentvalidation, tunit, powershell, typescript, fluent-ui, essl, sharepoint-server, sharepoint-spfx, and sharepoint-pnp.
- The dotnet-library bundle is no longer part of the target plan because your library work will be centered on MartiX Platform rather than client-side .NET library packages.

That structure is workable, but it would benefit from a more explicit taxonomy so future packages do not get mixed into the wrong layer.

## Proposed package taxonomy

### A. Standalone skills

Create or keep standalone skills for reusable capabilities that can be used in more than one project family.

Recommended standalone skills:

| Skill | Why it should stay standalone |
| --- | --- |
| martix-markdown | Cross-cutting documentation and linting guidance. |
| martix-dotnet-csharp | General .NET and C# guidance used across libraries, APIs, and apps. |
| martix-fastendpoints | Reusable endpoint-framework guidance. |
| martix-fluentvalidation | Validation guidance reused across web, library, and API workflows. |
| martix-tunit | Test authoring guidance reused across many .NET packages. |
| martix-powershell | Useful outside any one plugin. |
| martix-typescript | Reusable front-end and library guidance. |
| martix-fluent-ui | Reusable design-system guidance. |
| martix-essl | Domain-specific compliance guidance. |
| martix-sharepoint-server | Domain-specific server-side SharePoint guidance. |
| martix-sharepoint-spfx | Domain-specific SPFx guidance. |
| martix-sharepoint-pnp | Domain-specific SharePoint automation guidance. |
| martix-conventional-commit | Reusable commit-policy and message-formatting knowledge. |
| martix-platform | Reusable platform architecture and implementation guidance for the MartiX Platform ecosystem. |

### B. Plugin bundles

Create or keep plugins for workflow bundles that combine several skills and add bundle-specific prompts, instructions, hooks, or agents.

Recommended plugin bundles:

| Plugin | Purpose |
| --- | --- |
| martix-markdown-automation | Markdown enforcement workflow. |
| martix-webapi | API and backend workflow. |
| martix-git | Git, GitHub, conventional commit, branch, PR, and worktree workflow. |
| martix-dotnet-webapp | Future .NET and web-app workflow with backend and frontend assets. |
| martix-sharepoint-server-suite | Future SharePoint Server workflow bundle. |
| martix-sharepoint-online-suite | Future SharePoint Online / SPFx / PnP workflow bundle. |

## Proposed refactor for the new capabilities

### 1. Split Git into plugin + skill

The Git-related work should be split exactly as the existing Git plan recommends:

- Keep the workflow package as a plugin named martix-git.
- Keep reusable commit-policy guidance in the standalone skill martix-conventional-commit.

The plugin should center on one smart command that covers both of your most common workflows:

1. Working directly in the main branch in VS Code and then finishing with a single "create branch, commit, push, and open PR" flow. In this path, the command should detect that no dedicated worktree is active yet, create a new branch from the current state, stage and commit everything, push it, and open a pull request in one go.
2. Already having a dedicated worktree created in Copilot, the CLI, or Codex. In this path, the command should detect the existing worktree context, skip branch creation, and focus on the remaining steps: review the pending changes, commit and push them, and then merge or hand off the changes back to main at the end.

A good command name for this behavior would be something like "git-finalize" or "finalize-git-workflow". The key idea is that the command should be smart enough to infer whether branch creation is still needed or whether the current worktree context is already the right place to continue.

Why this is the right shape:

- The Git plan already frames Git/PR/worktree operations as a bundled workflow lifecycle, not just a single skill: [docs/research/git-worktree-workflows/martix-git-plugin-plan.md](./git-worktree-workflows/martix-git-plugin-plan.md).
- The repository rules say reusable domain knowledge should stay standalone: [docs/plugin-bundle-strategy.md](../plugin-bundle-strategy.md).

Recommended implementation shape:

- Plugin: plugins/martix-git/
  - prompts for commit, branch, PR, and worktree audit
  - instructions for safe Git workflow behavior
  - optional hooks for guardrails or reporting
  - no reusable commit rules copied into the plugin
  - one smart command entry point such as "git-finalize" that can detect whether it should:
    - create a new branch from the current main-branch context, stage and commit all changes, push the branch, and open a PR in one flow, or
    - skip branch creation because a dedicated worktree or branch context already exists and continue with commit, push, and merge-or-handoff steps back to main
- Standalone skill: skills/martix-conventional-commit/
  - rules for type/scope/body/footer conventions
  - examples and validation guidance
  - reusable by plugins and other skills
  - used by the git plugin to generate the commit message and verify the final commit shape

### 2. Make MartiX Platform a standalone skill first

Treat martix-platform as the primary package for the Platform guidance, not as a plugin wrapper.

Why:

- The Platform blueprint describes the Platform repository as owning a single editable skill source for its agent guidance and canonical knowledge, and it positions Platform as a reusable knowledge package: <https://github.com/MartiXDev/Platform/blob/main/docs/wayfinder/martix-platform/platform-blueprint.md>.
- The repo’s own package rules prefer standalone skills for reusable guidance that can be installed independently: [docs/plugin-bundle-strategy.md](../plugin-bundle-strategy.md).

Recommended implementation shape:

- Standalone skill: skills/martix-platform/
  - routing guidance for Platform concepts
  - architecture and capability-selection guidance
  - quality-gate and migration guidance
  - references to Platform repository documents and schemas
- Plugin only later if you need plugin-level workflow assets such as a generated-app workflow, scaffolding prompts, or a bundle-specific agent

### 3. Add one or two new reusable skills before creating more plugins

The next useful additions are the ones that make future plugins thinner and more consistent.

Recommended additions:

| Suggested skill | Why it would help |
| --- | --- |
| martix-solution-planning | Reusable guidance for selecting the right architecture, capability matrix, and project shape before implementation begins. |
| martix-quality-gates | Reusable quality, verification, and release-evidence guidance for libraries, APIs, and platform projects. |

These are good candidates because the Platform blueprint emphasizes capability selection, quality gates, and evidence-driven delivery; they fit the repository’s existing pattern of reusable domain knowledge rather than workflow-only plugin content: <https://github.com/MartiXDev/Platform/blob/main/docs/wayfinder/martix-platform/platform-blueprint.md>.

## Plugin refactor rules to apply going forward

### Rule 1: start with the skill layer

If the capability is reusable across multiple contexts, create a standalone skill first.

### Rule 2: use plugins for workflows

If the package is a repeatable workflow bundle that needs prompts, instructions, hooks, or agents, create a plugin.

### Rule 3: keep plugin content thin

Plugins should compose existing skills rather than duplicate the full guidance. The current plugin strategy already expects thin bundles that link to standalone skills rather than copying full skill content: [docs/plugin-bundle-strategy.md](../plugin-bundle-strategy.md).

### Rule 4: keep naming consistent

Use a predictable naming pattern:

- skills/martix-<capability>/ for reusable skills
- plugins/martix-<workflow>/ for workflow bundles

### Rule 5: avoid premature plugin expansion

Do not create a new plugin just because a couple of skills are used together. Create the plugin only when the bundle has a real user-facing workflow, such as setup, automation, or orchestration.

## Suggested implementation order

### Phase 1 — normalize the current structure

1. Document the skill/plugin boundary in the repository README and package documentation.
2. Keep the current plugin bundles but make each README explicitly list the composed skills and the plugin-only assets.
3. Ensure every new skill package follows the standard standalone layout.

### Phase 2 — add the first new reusable skills

1. Add martix-conventional-commit as a standalone skill.
2. Add martix-platform as a standalone skill.
3. Add martix-solution-planning if you want a reusable architecture and project-shaping skill.

### Phase 3 — introduce the first workflow plugin

1. Create martix-git as the workflow plugin for Git, PRs, and worktrees.
2. Keep commit-policy rules inside martix-conventional-commit instead of copying them into the plugin.
3. Keep plugin prompts and instructions focused on orchestration and safety.

### Phase 4 — add future domain-focused bundles only when they earn it

1. Add martix-dotnet-webapp when a broader .NET and web-app workflow needs a real bundle.
2. Add sharepoint suite plugins only when the workflow is broad enough to justify a bundle.
3. Avoid making a plugin just to group a few standalone skills without a real workflow.

## Bottom line

The cleanest long-term structure is:

- standalone skills for reusable expertise;
- plugins for workflow bundles;
- a small number of future skills for platform, solution planning, and quality gates before expanding the plugin surface.

That structure is consistent with both the repository’s existing plugin strategy and the Platform blueprint’s emphasis on reusable canonical knowledge.
