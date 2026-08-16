# MartiX Git

`martix-git` is the canonical standalone skill for safe Git and GitHub
lifecycle decisions. It covers Conventional Commits, Conventional Branch,
branch and worktree practice, staged commits, pull requests and issue links,
SemVer, optional semantic-release, native hooks, CI policy, and report-first
cleanup.

## Package shape

| Layer | Purpose |
| --- | --- |
| [SKILL.md](./SKILL.md) | Compact activation router and safety contract. |
| [AGENTS.md](./AGENTS.md) | Maintainer routes and cross-surface boundaries. |
| [rules/](./rules/) | Normative domain guidance grouped by workflow. |
| [references/](./references/) | Source maps, planner decisions, and configuration boundaries. |
| [templates/](./templates/) | Commit, PR, branch-policy, and repository-config scaffolds. |
| [assets/](./assets/) | Machine-readable taxonomy and section ordering. |
| [evals/evals.json](./evals/evals.json) | Canonical routing and behavior scenarios. |

## Use it

Start with [SKILL.md](./SKILL.md), then open only the routed rule file. The
canonical command namespace for the companion automation workflows is:

```text
/martix-git [workflow] [action] [options]
```

The standalone skill provides guidance; it does not install hooks, run Git
commands, create branches, open pull requests, publish releases, or delete
worktrees by itself. Mutations require the consuming workflow to show the
proposed action and obtain confirmation.

## Install

```powershell
npx skills add https://github.com/MartiXDev/skills --skill martix-git
```

For local package validation:

```powershell
npx skills add C:\Git\MartiXDev\skills\skills\martix-git `
  -a github-copilot --copy -y
```

The optional automation companion is installed separately:

```powershell
copilot plugin marketplace add MartiXDev/skills
copilot plugin install martix-git-automation@martix-skills
```

The plugin does not claim an automatic dependency-installation contract. Keep
this skill installed when using its commit, branch, PR, policy, release, or
worktree prompts.

## Validation

Validate the package Markdown with the repository hook:

```powershell
$paths = @(Get-ChildItem -LiteralPath .\skills\martix-git `
  -Recurse -File -Filter *.md | ForEach-Object { $_.FullName })
& .\plugins\martix-markdown-automation\hooks\markdown-check.ps1 `
  -CheckOnly -Path $paths
```

Run the repository contract check before publishing:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1
```

## Safety defaults

- Inspect first; report-only is the default for cleanup and planning.
- Use explicit paths, temporary message files, and argument-safe invocation.
- Preserve dirty, locked, current, protected, detached, active, externally
  owned, unknown, and ambiguous states.
- Revalidate immediately before each mutation.
- Keep local cleanup separate from remote branch and pull-request cleanup.
- Treat GitHub protection and required CI as authoritative over local hooks.
