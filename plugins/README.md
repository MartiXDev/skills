# Plugins

This folder contains full plugin packages for GitHub Copilot CLI.

Each subdirectory is a self-contained plugin with a `plugin.json` manifest and
may include agents, skills, hooks, and MCP server configurations.

## Available Plugins

| Plugin | Description | Status |
| --- | --- | --- |
| [martix-dotnet-library](./martix-dotnet-library/) | Unified plugin for .NET library create, update, and review workflows | Migration pending |
| [martix-webapi](./martix-webapi/) | Unified plugin for planning and implementing .NET 10 web apps | Migration pending |

## Installation

Add the marketplace and install a plugin:

```sh
copilot plugin marketplace add MartiXDev/skills
copilot plugin install martix-dotnet-library@martix-skills
copilot plugin install martix-webapi@martix-skills
```

Or install directly from the repository path:

```sh
copilot plugin install MartiXDev/skills:plugins/martix-dotnet-library
copilot plugin install MartiXDev/skills:plugins/martix-webapi
```

## Structure

Each plugin package follows this layout:

```text
plugin-name/
  plugin.json        # Plugin manifest (name, version, agents, skills, hooks)
  agents/            # Custom agents (optional)
  skills/            # Plugin-specific skills (optional)
  hooks.json         # Hook configuration (optional)
  .mcp.json          # MCP server config (optional)
```

## Migration Source

Plugins in this folder are being migrated from
[MartiXDev/skills](https://github.com/MartiXDev/skills) (`plugins/`).
