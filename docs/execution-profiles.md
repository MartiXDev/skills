# Execution profiles

Execution profiles describe how MartiX skills and plugins should be used by agents without wasting premium model requests, tokens, memory, or parallel-agent capacity.

Use this document when adding or reviewing package metadata, evals, templates, plugin bundle instructions, and `/fleet` work plans.

## Goals

- Route work to the cheapest model tier that can safely complete it.
- Keep skill entrypoints concise and push detail into supporting files.
- Make package-scoped work safe for parallel agents and separate git worktrees.
- Mark tasks as AFK or HITL before handing them to agents.
- Make validation deterministic enough for cheap or medium models.

## Model tiers

Use generic tier names instead of vendor-specific model names.

| Tier | Use for | Avoid using for |
| --- | --- | --- |
| `cheap` | Deterministic cleanup, JSON/YAML formatting, link checks, package inventory, applying existing templates, simple README synchronization. | Ambiguous design, cross-package architecture, security-sensitive review, or tasks with unclear acceptance criteria. |
| `medium` | Standard implementation, documentation updates, eval authoring from an approved pattern, metadata normalization, package-local refactors. | High-risk decisions, new plugin-family design, or changes that span many shared files without a plan. |
| `premium` | Planning, ambiguous architecture, security-sensitive review, final high-impact review, plugin-bundle boundary decisions, new reusable skill design. | Mechanical edits, repeated template application, formatting, or validation-only work. |
| `mixed` | Workflows that should begin with premium planning and split into medium or cheap implementation slices. | Single-step tasks that can be assigned directly to one tier. |

## Task types

Use these labels in docs, evals, package metadata, and issue breakdowns:

| Task type | Meaning | Typical tier |
| --- | --- | --- |
| `planning` | Resolve scope, boundaries, architecture, package ownership, or task breakdown. | `premium` |
| `implementation` | Apply an approved change to a package or plugin. | `medium` |
| `review` | Check correctness, safety, and cross-package consistency. | `medium` or `premium` |
| `validation` | Run deterministic checks and report failures. | `cheap` |
| `cleanup` | Apply mechanical formatting, metadata, or link fixes. | `cheap` |

## AFK and HITL labels

| Label | Meaning | Examples |
| --- | --- | --- |
| `AFK` | Agent can complete the task without more human decisions. | Add missing evals from an approved template, run validation, update package-local metadata. |
| `HITL` | Human input is required before or during execution. | Decide whether a new capability is standalone or bundled, approve plugin-family boundaries, choose a model-tier policy. |

Prefer AFK slices when the acceptance criteria are clear. Mark a slice HITL when a decision would otherwise be guessed.

## Parallel and worktree safety

| Value | Meaning | Use when |
| --- | --- | --- |
| `single-package` | Safe to run in parallel with other package-scoped tasks. | Editing only `skills\martix-tunit\...` or only `plugins\martix-webapi\...`. |
| `multi-package-readonly` | Reads multiple packages but writes only reports or one owned file. | Audits, inventories, bundle planning docs. |
| `shared-file-coordinator` | Owns a shared file that many package tasks depend on. | `.github\plugin\marketplace.json`, root `README.md`, shared templates, validation script. |
| `not-parallel-safe` | Should not run concurrently because it touches many shared files or changes global contracts. | Repository-wide schema migrations before the contract is stable. |

For `/fleet` or multiple git worktrees:

1. Assign one package or one shared-file coordinator per branch.
2. Give each branch a clear completion signal, usually repository validation passing.
3. Avoid simultaneous edits to `.github\plugin\marketplace.json`, root README files, shared templates, or validation scripts.
4. Merge dependency branches before branches that rely on their contracts.

## Token-budget guidance

| Budget | Meaning | Skill/plugin design rule |
| --- | --- | --- |
| `small` | The agent should need only the entrypoint plus one or two referenced files. | Keep `SKILL.md` short and direct. |
| `medium` | The agent may read a few rules, references, or templates. | Provide routing tables and explicit file pointers. |
| `large` | The agent may need broad package or cross-package context. | Use only for planning/review tasks; split follow-up work into smaller slices. |

Avoid large token budgets for normal package use. If a skill often needs a large context, split it into clearer routing and smaller references.

## Context strategy

Every skill and plugin should make context loading explicit:

- Start with `SKILL.md` for routing.
- Open `README.md` only for install, verification, or maintainer workflow.
- Open `rules\` for task-specific guidance.
- Open `references\` for source maps, compatibility, or decision details.
- Open `templates\` only when creating new content.
- Avoid loading all rules or references unless the task is an audit or planning pass.

## Suggested metadata shape

Use this shape in `metadata.json` when execution profiles are added to packages:

```json
{
  "executionProfile": {
    "modelTier": "mixed",
    "taskTypes": [
      "planning",
      "implementation",
      "review",
      "validation"
    ],
    "parallelSafety": "single-package",
    "fleetReady": true,
    "worktreeSafe": true,
    "tokenBudget": "medium",
    "contextStrategy": [
      "Start with SKILL.md.",
      "Open only the routed rule or reference file for the requested task.",
      "Use README.md for install and validation guidance."
    ]
  }
}
```

Keep the field concise. It should help agents route work, not become another long instruction surface.
