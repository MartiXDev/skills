# MartiX Platform skill package

`martix-platform` is the standalone-first knowledge package for the
MartiX.Platform .NET base library and the web applications built around it. It
keeps the activation router small and puts durable architecture, contracts,
operations, and migration guidance in progressive-disclosure files.

## Package structure

| Path | Purpose |
| --- | --- |
| [SKILL.md](./SKILL.md) | Activation router and handoff map |
| [AGENTS.md](./AGENTS.md) | Companion guidance for cross-domain work |
| [rules/](./rules) | Atomic Platform and application guardrails |
| [references/](./references) | Authority, API, topology, and anti-pattern maps |
| [templates/](./templates) | Review and planning checklists |
| [assets/](./assets) | Machine-readable taxonomy and ordering |
| [evals/evals.json](./evals/evals.json) | Canonical routing and quality scenarios |
| [metadata.json](./metadata.json) | Package identity and distribution metadata |

## Source boundary

The package was distilled from the MartiX.Platform main checkout and its
authored documentation:

- `C:\Git\MartiXDev\Platform\README.md`
- `C:\Git\MartiXDev\Platform\AGENTS.md`
- `C:\Git\MartiXDev\Platform\CONTEXT.md`
- `C:\Git\MartiXDev\Platform\martix.platform.json`
- `C:\Git\MartiXDev\Platform\eng\quality-gates.json`
- `C:\Git\MartiXDev\Platform\src\`
- `C:\Git\MartiXDev\Platform\tests\fixtures\ModularMonolithGeneratedSolution\`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\`

The Platform repository is still being implemented. Current source and fixture
evidence take precedence over the approved Wayfinder target. The skill must
label target-only behavior as target-only and ask the agent to verify the
consumer's actual package and manifest before editing code.

## Installation

For local validation on Windows:

```powershell
npx skills add C:\Git\MartiXDev\skills\skills\martix-platform `
  -a github-copilot --copy -y
```

For a repository source:

```powershell
npx skills add https://github.com/MartiXDev/skills `
  --skill martix-platform
```

If this package is later registered in the marketplace, keep its marketplace
entry synchronized with [plugin.json](./plugin.json) and `metadata.json`.
Marketplace registration is intentionally coordinator-owned and is not part of
this package change.

## Maintainer workflow

1. Keep `SKILL.md` a router; move durable detail to a focused rule or map.
2. Add or update an entry in `assets/taxonomy.json` and
   `assets/section-order.json` when files or routes change.
3. Use the templates for new rule and review material.
4. Add a positive or negative scenario to `evals/evals.json` when a boundary or
   activation behavior changes.
5. Run the Markdown hook for changed Markdown and
   `scripts\validate-repository.ps1` from the repository root.

Do not add a second trigger-eval format or copy the Platform source into this
package. Keep source anchors and rationale in references.
