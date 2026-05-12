# LLM routing strategy

Use this policy when assigning model tiers, writing evals, editing package
metadata, or deciding whether automation should be a hook instead of LLM work.

## Platform constraint

Copilot CLI plugins and Agent Skills do not provide native cost-aware model
routing. Do not add `"model": "cheap"` or similar aliases to `plugin.json` or to
Agent Skills `SKILL.md` front matter. Those locations do not select models for a
skill invocation.

Model selection can be expressed only in surfaces that explicitly document a
model field, such as supported `.agent.md` and `.prompt.md` files. In those
surfaces, use literal supported model names, not MartiX tier aliases.

## Canonical tiers

Use tier names in repo-owned metadata and evals. Do not duplicate vendor model
names across skill packages.

| Tier | Use for | Avoid using for |
| --- | --- | --- |
| `cheap` | Deterministic checks, metadata sync, and scope rejection. | Ambiguous scope, architecture, or security-sensitive review. |
| `medium` | Package-local implementation, docs, evals, and focused review. | New boundaries or broad shared-file migrations without a plan. |
| `premium` | Planning, architecture, security review, and package boundaries. | Mechanical edits, formatting, or validation-only work. |
| `mixed` | Premium planning split into medium or cheap follow-up slices. | Single-step tasks assignable directly to one tier. |

`medium` is the canonical middle tier. Treat `balanced` as a legacy or external
alias for `medium`; do not use it as the preferred value in new MartiX artifacts.

## Where routing is encoded

| Artifact | Responsibility |
| --- | --- |
| `docs\execution-profiles.md` | Full tier, budget, AFK/HITL, and parallel-safety vocabulary. |
| `metadata.json` `executionProfile` | Package-level routing contract. |
| `evals\evals.json` | Per-scenario tier, budget, safety, and escalation expectations. |
| `.github\instructions\*.instructions.md` | Path-scoped tier guidance. |
| `SKILL.md` body | Compact activation routing and file pointers. |
| `AGENTS.md` | Maintainer guidance and cross-skill handoff notes. |
| Hooks and validation scripts | Deterministic, zero-token automation for checks that do not require reasoning. |

Keep `.github\copilot-instructions.md` as a small pointer surface. It should link
to this policy instead of embedding the full routing rules.

## Hooks are zero-token routing

If a task can be checked deterministically, prefer a script or hook over LLM
reasoning. Markdown cleanup, JSON/YAML parsing, link checks, marketplace sync,
and metadata inventory checks should run as validation, not as premium-model
work. Hooks do not choose a model; they avoid model use entirely.

When a hook should apply only to specific files, filter inside the hook script
using the hook input payload or changed-file list. Do not rely on unsupported
file filters in hook configuration.

## Anti-patterns

- Do not create a `martix-llm-router` skill. Routing is repository policy, not
  reusable domain knowledge.
- Do not create a routing plugin bundle. It would add context without controlling
  runtime model selection.
- Do not put model aliases or vendor model names in skill `plugin.json` files.
- Do not put model aliases or vendor model names in Agent Skills `SKILL.md`
  front matter.
- Do not duplicate current pricing tables across packages.
- Do not load all skills or all package rules just to decide which one applies.
  Use `SKILL.md` descriptions, package metadata, and scoped instructions first.
- Do not use premium models for mechanical validation or formatting.

## Optional model alias map

A central alias map such as `docs\models.yaml` can be useful as repository
guidance, but Copilot does not consume such a file automatically. If added, it
must be documented as MartiX-maintained guidance unless a real runtime resolver
is introduced.

Package artifacts should continue to reference tiers (`cheap`, `medium`,
`premium`, `mixed`) rather than vendor model names.
