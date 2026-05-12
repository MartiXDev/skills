---
name: "Skill Package Rules"
description: "Rules for maintaining standalone MartiX skill packages"
applyTo: "skills/**"
---

# Skill package rules

Before changing a skill package, read the package `SKILL.md`, `AGENTS.md`, and
`README.md`. Use `docs\repo-overview.md` for repository maintenance rules and
`docs\custom-ai-artifact-rules.md` for AI artifact formats.

## Model-tier guidance

| Work | Tier |
| --- | --- |
| Metadata sync, eval formatting, link fixes, taxonomy updates | `cheap` |
| Rule authoring, reference updates, template application | `medium` |
| Package-boundary decisions and cross-skill routing | `premium` |

Apply these overlays:

- Keep reusable domain knowledge in standalone `skills\martix-*` packages.
- Keep `SKILL.md` compact and routing-oriented.
- Put durable detail in `rules\` or `references\`.
- Keep package identity synchronized across `plugin.json`, `metadata.json`,
  README, and marketplace entries.
- Update evals, `assets\taxonomy.json`, and `assets\section-order.json` when
  routing, rules, references, or templates move.

Validate with the Markdown hook for changed Markdown files and
`scripts\validate-repository.ps1`.
