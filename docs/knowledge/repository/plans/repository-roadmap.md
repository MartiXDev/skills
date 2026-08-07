# Repository roadmap

This document contains planned repository improvements. Stable architecture and
maintenance guidance belongs in
[Repository knowledge](../knowledge.md); dated investigations belong in
[`research/`](../research/).

## 1. Normalize package completeness

Define and validate a required package checklist for every standalone skill:

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

Decide whether `evals\evals.json` is mandatory for every skill or explicitly
optional for early packages.

## 2. Make plugin bundles real bundles

For each plugin, define the standalone skills it composes and add plugin-scoped
agents, instructions, hooks, prompts, or MCP configuration only where they add
workflow value. Keep bundle decisions aligned with the
[plugin bundle strategy](../../../architecture/plugin-bundle-strategy.md).

## 3. Add instruction and hook patterns

Use Markdown enforcement as the first reusable example:

- Keep `martix-markdown` as the reusable standalone skill.
- Add a plugin bundle only when automatic file-event behavior is needed.
- Put plugin policy under `instructions\`.
- Put file-event automation under `hooks\` and configure it with `hooks.json`.

## 4. Standardize evals

Use one repository eval shape for trigger prompts, negative activation prompts,
expected routing behavior, package-specific quality checks, and regression
prompts. Use the evals to improve skill triggering and release confidence.

## 5. Add validation automation

Add checks that:

- parse every JSON and YAML file;
- compare marketplace entries with source `plugin.json` values;
- verify marketplace sources and required package files;
- check README links and Markdown fence balance; and
- compare taxonomy and section-order assets with actual package paths.

These checks should become the quality gate before publishing or opening release
PRs.

## 6. Prepare external registry readiness

Improve package discoverability with clear descriptions, concise keywords,
stable install instructions, license clarity, representative prompts, links to
package entrypoints, consistent versions, and the `martix-` naming convention.
Remain compatible with Copilot CLI marketplace metadata while keeping standalone
skills easy to evaluate in other registries.

## 7. Add templates for future packages

Create templates for standalone skills, plugin bundles, `plugin.json`,
`metadata.json`, `SKILL.md`, `AGENTS.md`, `README.md`, `evals\evals.json`,
taxonomy and section-order assets, and plugin-local instruction, prompt, hook,
and agent assets.

## 8. Keep model usage efficient

Use [Execution and routing](../../../guides/execution-and-routing.md) to route:

- premium models to ambiguous planning, architecture, security, and high-risk
  review;
- medium models to approved package-local implementation; and
- cheap models to validation, metadata synchronization, link checks, and
  mechanical cleanup.

Use `/fleet` and worktree-ready slices for scoped implementation work.

## Recommended implementation order

1. Add package completeness and marketplace consistency validation.
2. Normalize eval coverage across all standalone skills.
3. Define real contents for `martix-dotnet-library` and `martix-webapi`.
4. Add reusable templates for new skills and plugins.
5. Add plugin-level instruction and hook examples where automation is required.
6. Polish registry-facing metadata and examples for each package.
