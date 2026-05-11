# Plugins

This folder contains full plugin packages for GitHub Copilot CLI.

Each subdirectory is a self-contained plugin with a `plugin.json` manifest and
may include agents, skills, hooks, and MCP server configurations.

## Available Plugins

| Plugin | Description | Status |
| --- | --- | --- |
| [martix-markdown-automation](./martix-markdown-automation/) | Automatic Markdown check and fix workflow using martix-markdown guidance | Available |
| [martix-dotnet-library](./martix-dotnet-library/) | Unified plugin for .NET library create, update, and review workflows | Available |
| [martix-webapi](./martix-webapi/) | Unified plugin for planning and implementing .NET 10 web apps | Available |

## Installation

Add the marketplace and install a plugin:

```sh
copilot plugin marketplace add MartiXDev/skills
copilot plugin install martix-markdown-automation@martix-skills
copilot plugin install martix-dotnet-library@martix-skills
copilot plugin install martix-webapi@martix-skills
```

Or install directly from the repository path:

```sh
copilot plugin install MartiXDev/skills:plugins/martix-dotnet-library
copilot plugin install MartiXDev/skills:plugins/martix-webapi
copilot plugin install MartiXDev/skills:plugins/martix-markdown-automation
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
