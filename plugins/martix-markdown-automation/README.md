# MartiX Markdown Automation plugin

`martix-markdown-automation` is a thin companion plugin for automatic
Markdown check and fix workflows.

Use this plugin when a project should validate Markdown whenever agents create
or update `.md` files. Keep Markdown rule knowledge in the standalone
[`martix-markdown`](../../skills/martix-markdown/) skill.

## Composed skill

| Skill | Use |
| --- | --- |
| `martix-markdown` | markdownlint routing, repair, and review guidance. |

## Default behavior

The hook script auto-fixes first, reruns checks, and reports remaining issues.

Use check-only mode for CI, dry runs, or conservative projects:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\plugins\martix-markdown-automation\hooks\markdown-check.ps1 `
  -CheckOnly
```

## Install

```sh
copilot plugin install martix-markdown-automation@martix-skills
```

## Local validation

Run against changed Markdown files:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\plugins\martix-markdown-automation\hooks\markdown-check.ps1
```

Run against all Markdown files:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\plugins\martix-markdown-automation\hooks\markdown-check.ps1 `
  -All
```

## Model and parallel guidance

| Work | Tier |
| --- | --- |
| Hook policy or schema decisions | `premium` |
| Hook implementation and package docs | `medium` |
| Hook execution, validation, and link checks | `cheap` |

The plugin is worktree-safe when package-local files are edited. Marketplace
registration is shared-file coordinator work.
