# Copilot instructions for MartiX Skills

MartiX Skills is the `martix-skills` Copilot CLI marketplace.

## Working rules

- Be concise; surface uncertainty and tradeoffs.
- Make the smallest change that meets explicit success criteria.
- Preserve unrelated worktree changes and never claim success without validation.
- Put reusable domain knowledge in `skills\martix-*`; reserve
  `plugins\martix-*` for bundled workflow assets.
- Treat `.github\plugin\marketplace.json`, root READMEs, shared templates,
  repository strategy docs, and `scripts\validate-repository.ps1` as
  coordinator-owned.

## Load on demand

- Repository structure: `docs\repo-overview.md`
- AI artifact contracts: `docs\custom-ai-artifact-rules.md`
- Skill/plugin boundary: `docs\plugin-bundle-strategy.md`
- Task tiers and worktrees: `docs\execution-profiles.md`
- Model routing: `docs\llm-routing-strategy.md`
- Package behavior: package `SKILL.md`, `AGENTS.md`, and `README.md`

## Validation

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\plugins\martix-markdown-automation\hooks\markdown-check.ps1 `
  -CheckOnly -Path <changed-markdown-files>

powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1
```

Keep new repository research, plans, and comparisons under `docs\research\`
or the relevant package's `docs\` folder.
