# Skills

This folder contains standalone skill packages for GitHub Copilot CLI.

Each subdirectory is a self-contained skill package with a `plugin.json`
manifest, root-level `SKILL.md`, `AGENTS.md`, and supporting package assets.

## Available Skills

| Skill | Description | Status |
| --- | --- | --- |
| [martix-markdown](./martix-markdown/) | Markdownlint authoring, lint repair, and accessibility-aware review | Available |
| [martix-dotnet-csharp](./martix-dotnet-csharp/) | .NET 10+ and C# 14+ modernization and review | Available |
| [martix-fastendpoints](./martix-fastendpoints/) | FastEndpoints startup, contracts, and AOT workflows | Available |
| [martix-fluentvalidation](./martix-fluentvalidation/) | FluentValidation authoring, RuleSets, and testing | Available |
| [martix-tunit](./martix-tunit/) | TUnit test authoring, parameterized tests, and parallel execution | Available |
| [martix-powershell](./martix-powershell/) | PowerShell cmdlet development and advanced functions | Available |
| [martix-sharepoint-server](./martix-sharepoint-server/) | SharePoint Server on-prem farm solutions and WSP packaging | Available |
| [martix-sharepoint-spfx](./martix-sharepoint-spfx/) | SharePoint Framework (SPFx) development with React and TypeScript | Available |
| [martix-sharepoint-pnp](./martix-sharepoint-pnp/) | SharePoint PnP PowerShell, CLI for M365, and PnPjs | Available |

## Installation

Install a specific skill using the `npx skills` CLI:

```sh
npx skills add https://github.com/MartiXDev/skills --skill martix-markdown
```

Or install via the `copilot plugin` commands after adding the marketplace:

```sh
copilot plugin marketplace add MartiXDev/skills
copilot plugin install martix-markdown@martix-skills
```

## Structure

Each skill package follows this layout:

```text
skills/
  skill-name/
    plugin.json        # Plugin manifest
    SKILL.md           # Copilot skill instructions
    AGENTS.md          # Companion maintainer and routing guide
    metadata.json      # Package inventory and distribution notes
    rules/             # Skill rule library
    references/        # Source maps and supporting references
    templates/         # Authoring scaffolds
    assets/            # Machine-readable taxonomy and ordering data
```

## Migration Source

Skills in this folder are being migrated from
[MartiXDev/ai-marketplace](https://github.com/MartiXDev/ai-marketplace) (`skills/`).
