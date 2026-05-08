---
name: martix-markdown
description: Standalone-first markdownlint guidance for Markdown authoring, lint repair, MD-code triage, config-vs-content decisions, custom rules, suppressions, Prettier coexistence, descriptive links, alt text, accessibility-aware review, and repo-local overlay comparisons. Use when the user mentions markdownlint, markdownlint-cli2, MD013, MD022, MD032, MD041, MD045, MD059, front matter, link fragments, table style, custom rule authoring, or whether a Markdown issue belongs in content, config, or bridge notes.
license: MIT
---

> **Migration pending** — Full skill content will be migrated from
> [MartiXDev/ai-marketplace — src/skills/martix-markdown](https://github.com/MartiXDev/ai-marketplace/tree/main/src/skills/martix-markdown).

## MartiX Markdown skill

This skill provides standalone-first markdownlint-specific guidance for:

- Authoring and repairing Markdown files following markdownlint rules.
- Deciding whether an issue belongs in content, repo config, an inline
  suppression, a custom rule, or a toolchain adjustment.
- Reviewing descriptive links, alt text, heading policy, and accessibility.
- Comparing repo-local overlays against upstream markdownlint defaults.

## When to use this skill

- Fix markdownlint or `markdownlint-cli2` findings by rule ID (`MD013`,
  `MD022`, `MD032`, `MD041`, `MD045`, `MD059`, and nearby families).
- Decide config-versus-content placement for a Markdown issue.
- Review or create custom rules and inline suppressions.
- Coexist with Prettier or other formatters without rule conflicts.

## Installation

```sh
# Add via npx skills CLI
npx skills add https://github.com/MartiXDev/skills --skill martix-markdown

# Or via copilot plugin after adding the marketplace
copilot plugin marketplace add MartiXDev/skills
copilot plugin install martix-markdown@martix-skills
```
