---
name: "Plugin Package Rules"
description: "Rules for maintaining MartiX Copilot CLI plugin bundles"
applyTo: "plugins/**"
---

# Plugin package rules

Before changing a plugin package, read `docs\plugin-bundle-strategy.md` and
`docs\custom-ai-artifact-rules.md`.

## Model-tier guidance

| Work | Tier |
| --- | --- |
| Hook config sync, README link fixes, metadata checks | `cheap` |
| Plugin-scoped asset implementation | `medium` |
| New bundle boundaries or shared project-family design | `premium` |

Apply these overlays:

- Keep plugins thin and link to standalone skills instead of duplicating rule
  libraries.
- Use plugin assets only for plugin-scoped agents, skills, instructions,
  prompts, hooks, MCP, LSP, or setup.
- Treat plugin-local `instructions\` and `prompts\` as bundled guidance unless
  the target runtime documents automatic discovery.
- Use event-keyed `version: 1` hook configuration for new hook files.
- Keep plugin `name`, `version`, and `description` synchronized with marketplace
  entries after registration.

Validate with the Markdown hook for changed Markdown files and
`scripts\validate-repository.ps1`.
