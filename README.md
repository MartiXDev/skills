# MartiX Skills

MartiX AI Skills and Plugins for GitHub Copilot CLI — standalone-first skill packages
and plugin bundles for .NET, SharePoint, Markdown, and more.

## Marketplace

This repository is a GitHub Copilot CLI plugin marketplace. The marketplace name
is **`martix-skills`**.

Add the marketplace to your Copilot CLI:

```sh
copilot plugin marketplace add MartiXDev/skills
```

## Quick Install

Install a specific skill or plugin after adding the marketplace:

```sh
# Skills (standalone)
copilot plugin install martix-markdown@martix-skills
copilot plugin install martix-dotnet-csharp@martix-skills
copilot plugin install martix-fastendpoints@martix-skills
copilot plugin install martix-fluentvalidation@martix-skills
copilot plugin install martix-tunit@martix-skills
copilot plugin install martix-powershell@martix-skills
copilot plugin install martix-sharepoint-server@martix-skills
copilot plugin install martix-sharepoint-spfx@martix-skills
copilot plugin install martix-sharepoint-pnp@martix-skills

# Plugins (full bundles)
copilot plugin install martix-dotnet-library@martix-skills
copilot plugin install martix-webapi@martix-skills
```

Or use the `npx skills` CLI to add individual skills:

```sh
npx skills add https://github.com/MartiXDev/skills --skill martix-markdown
npx skills add https://github.com/MartiXDev/skills --skill martix-dotnet-csharp
```

Or install directly from the repository without adding the marketplace:

```sh
copilot plugin install MartiXDev/skills:skills/martix-markdown
copilot plugin install MartiXDev/skills:skills/martix-dotnet-csharp
copilot plugin install MartiXDev/skills:plugins/martix-dotnet-library
```

## Repository Structure

```text
.github/
  plugin/
    marketplace.json        # Marketplace definition (name: "martix-skills")
skills/
  martix-markdown/          # Markdownlint authoring and accessibility review
  martix-dotnet-csharp/     # .NET 10+ and C# 14+ modernization and review
  martix-fastendpoints/     # FastEndpoints startup, contracts, and AOT
  martix-fluentvalidation/  # FluentValidation authoring and testing
  martix-tunit/             # TUnit test authoring and parallel execution
  martix-powershell/        # PowerShell cmdlet development
  martix-sharepoint-server/ # SharePoint Server on-prem farm solutions
  martix-sharepoint-spfx/   # SharePoint Framework (SPFx) development
  martix-sharepoint-pnp/    # SharePoint PnP PowerShell, CLI for M365, PnPjs
plugins/
  martix-dotnet-library/    # .NET library create, update, and review
  martix-webapi/            # .NET 10 web app planning and implementation
```

Each entry in `skills/` is a standalone skill package with a `plugin.json`,
root-level `SKILL.md`, `AGENTS.md`, and supporting rules, references, templates,
assets, and metadata. Each entry in `plugins/` is a plugin bundle with
`plugin.json` and plugin-scoped agents, skills, hooks, or configuration as
needed.
