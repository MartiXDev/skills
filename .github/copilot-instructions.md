# Copilot instructions for MartiX Skills

MartiX Skills is a Copilot CLI marketplace named `martix-skills`.

Use `skills\martix-*` for reusable standalone skills. Use
`plugins\martix-*` only for plugin-scoped bundles, agents, prompts,
instructions, hooks, MCP, or LSP configuration.

## Generic guides

- Don’t assume. Don’t hide confusion. Surface tradeoffs.
- Minimum code that solves the problem. Nothing speculative.
- Touch only what you must. Clean up only your own mess.
- Define success criteria. Loop until verified.

## Commands

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1

powershell -ExecutionPolicy Bypass `
  -File .\plugins\martix-markdown-automation\hooks\markdown-check.ps1 `
  -CheckOnly
```

## Load deeper context only when needed

- Architecture and maintenance: `docs\repo-overview.md`.
- Custom AI artifacts: `docs\custom-ai-artifact-rules.md`.
- Skill versus plugin decisions: `docs\plugin-bundle-strategy.md`.
- Model tier, token budget, and worktrees: `docs\execution-profiles.md`.
- LLM routing policy and anti-patterns: `docs\llm-routing-strategy.md`.
- Package-local behavior: package `SKILL.md`, `AGENTS.md`, and `README.md`.

## High-risk shared files

Treat `.github\plugin\marketplace.json`, root README files, shared templates,
and `scripts\validate-repository.ps1` as coordinator-owned shared files.
Package folders are safer parallel/worktree slices.
