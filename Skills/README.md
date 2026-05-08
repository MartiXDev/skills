# Skills

This folder contains standalone skill packages for GitHub Copilot CLI.

Each subdirectory is a self-contained skill package with a `plugin.json` manifest
and a `skills/<skill-name>/SKILL.md` instruction file.

## Available Skills

| Skill | Description | Status |
| --- | --- | --- |
| [martix-markdown](./martix-markdown/) | Markdownlint authoring, lint repair, and accessibility-aware review | Migration pending |
| [martix-dotnet-csharp](./martix-dotnet-csharp/) | .NET 10+ and C# 14+ modernization and review | Migration pending |
| [martix-fastendpoints](./martix-fastendpoints/) | FastEndpoints startup, contracts, and AOT workflows | Migration pending |
| [martix-fluentvalidation](./martix-fluentvalidation/) | FluentValidation authoring, RuleSets, and testing | Migration pending |
| [martix-tunit](./martix-tunit/) | TUnit test authoring, parameterized tests, and parallel execution | Migration pending |
| [martix-powershell](./martix-powershell/) | PowerShell cmdlet development and advanced functions | Migration pending |
| [martix-sharepoint-server](./martix-sharepoint-server/) | SharePoint Server on-prem farm solutions and WSP packaging | Migration pending |
| [martix-sharepoint-spfx](./martix-sharepoint-spfx/) | SharePoint Framework (SPFx) development with React and TypeScript | Migration pending |
| [martix-sharepoint-pnp](./martix-sharepoint-pnp/) | SharePoint PnP PowerShell, CLI for M365, and PnPjs | Migration pending |

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

```
Skills/
  skill-name/
    plugin.json        # Plugin manifest (name, version, skills path)
    skills/
      skill-name/
        SKILL.md       # Copilot skill instructions
```

## Migration Source

Skills in this folder are being migrated from
[MartiXDev/ai-marketplace](https://github.com/MartiXDev/ai-marketplace) (`src/skills/`).
