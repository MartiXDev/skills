# MartiX Markdown Automation hooks

This folder contains deterministic hook scripts for Markdown validation.

## Scripts

`markdown-check.ps1` detects changed Markdown files, auto-fixes supported
markdownlint findings, reruns checks, and reports remaining issues.

## Modes

```powershell
# Auto-fix changed Markdown files, then report remaining issues.
powershell -ExecutionPolicy Bypass `
  -File .\plugins\martix-markdown-automation\hooks\markdown-check.ps1

# Check changed Markdown files without editing them.
powershell -ExecutionPolicy Bypass `
  -File .\plugins\martix-markdown-automation\hooks\markdown-check.ps1 `
  -CheckOnly

# Auto-fix and check every Markdown file in the repository.
powershell -ExecutionPolicy Bypass `
  -File .\plugins\martix-markdown-automation\hooks\markdown-check.ps1 `
  -All
```

Hook metadata in `hooks.json` uses an event-keyed `version: 1` shape. If a
target runtime requires different event casing or command fields, keep the local
script behavior unchanged and adapt only the hook wrapper.
