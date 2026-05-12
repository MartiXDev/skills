---
name: "Custom AI Artifact Rules"
description: "Rules for creating and updating custom AI artifacts in this repository"
applyTo: ".github/copilot-instructions.md,.github/instructions/**,.github/prompts/**,.github/agents/**,.github/hooks/**,.github/lsp.json,.vscode/mcp.json,docs/custom-ai-artifact-rules.md,**/SKILL.md,**/AGENTS.md,skills/**/plugin.json,skills/**/metadata.json,skills/**/assets/*.json,skills/**/evals/evals.json,plugins/**/plugin.json,plugins/**/hooks.json,plugins/**/agents/**,plugins/**/instructions/**,plugins/**/prompts/**,plugins/**/hooks/**,templates/**"
---

# Custom AI artifact rules

Before creating or updating custom AI artifacts, read
`docs\custom-ai-artifact-rules.md` and follow its decision model.

## Model-tier guidance

| Work | Tier |
| --- | --- |
| Metadata sync, link fixes, eval formatting | `cheap` |
| Package-local artifact implementation from approved rules | `medium` |
| New artifact type or cross-surface policy decisions | `premium` |

Apply these repository overlays:

- Prefer standalone skills for reusable domain knowledge.
- Keep plugin bundles thin and plugin-scoped.
- Use the `martix-` prefix for package names.
- Keep marketplace entries synchronized with source `plugin.json` files.
- Update evals, taxonomy, and section-order assets when skill routing changes.
- Use event-keyed `version: 1` hook configuration for new hook files.

Treat plugin-local `instructions\` and `prompts\` files as bundled guidance
unless the target runtime explicitly documents automatic discovery for that
plugin path.

After edits, run the relevant Markdown hook and repository validation commands
for changed files:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\plugins\martix-markdown-automation\hooks\markdown-check.ps1 `
  -CheckOnly `
  -Path <changed-markdown-files>

powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1
```
