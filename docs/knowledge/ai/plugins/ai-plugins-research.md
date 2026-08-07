# Creating new agent plugins

## Executive guidance

Use a **standalone skill** when the reusable value is domain knowledge. Create a
**plugin bundle** only when the installable unit needs several skills together,
plugin-scoped agents, prompts, instructions, hooks, MCP/LSP configuration, or a
project-level workflow. This is the central MartiX rule: do not create a plugin
merely to rename or duplicate one skill. [MartiX `docs/plugin-bundle-strategy.md:3-43`](../../../../docs/plugin-bundle-strategy.md)

There are three contracts to keep separate:

| Contract | Scope | Key point |
| --- | --- | --- |
| Agent Plugins v1 | Portable format | Skills and MCP only |
| Claude Code | Client superset | Adds agents, hooks, LSP, monitors |
| MartiX Skills | Repository conventions | Names, completeness, marketplace |

The resource index supplied for this investigation is
`docs/knowledge/ai/plugins/ai-plugins-resources.md:1-6`; it links to the
Claude Code plugins reference, the Agent Plugins specification, and the
specification source repository.

## 1. Decide whether the artifact is a plugin

Start with the narrowest artifact that satisfies the requirement:

1. Use a standalone skill for reusable domain knowledge.
2. Use a custom agent when a specialized role, tool set, model, or handoff is
   the actual requirement.
3. Use a plugin bundle when those assets must be installed and distributed as
   one workflow.
4. Use hooks for deterministic lifecycle checks or enforcement, not for
   descriptive guidance.

This decision model and the repository source boundaries are normative for this
repository. Reusable knowledge belongs under `skills\martix-*`; plugin-scoped
agents, skills, prompts, instructions, hooks, MCP, and LSP configuration belong
under `plugins\martix-*`; `.github\plugin\marketplace.json` is metadata only.
[MartiX `docs/custom-ai-artifact-rules.md:43-73`](../../../../docs/custom-ai-artifact-rules.md)

Create a bundle when a project archetype repeatedly needs several existing
skills, project-level setup, workflow prompts, instructions, agents, hooks, or
validation. Do not create one when one skill is enough, when it would duplicate
skill documentation, or when the included skills have no shared workflow.
[MartiX `docs/plugin-bundle-strategy.md:21-43`](../../../../docs/plugin-bundle-strategy.md)

## 2. Understand the portable Agent Plugins contract

The Agent Plugins specification is version 1.0.0 and is currently marked
**Working Draft**. It defines a self-contained plugin directory with a root
`plugin.json`. [Agent Plugins specification](https://agent-plugins.org/specification#1-status-and-version)

### Required package rules

- The root manifest is exactly `plugin.json`; a client loads it before
  discovering components.
- The manifest must contain `$schema` with the canonical 1.0.0 schema URL and a
  `name`.
- `name` must be 1-64 characters, lowercase `a-z`, digits, hyphens, or periods,
  start and end with an alphanumeric character, and contain neither `--` nor
  `..`.
- Plugin-relative paths must begin with `./` and resolve inside the plugin
  root. A path that escapes the root must be rejected.
- The portable manifest's defined top-level fields are `$schema`, `name`,
  `version`, `description`, `author`, `homepage`, `repository`, `license`,
  `keywords`, and `extensions`. Client-specific data belongs under a
  reverse-domain `extensions` namespace.

Sources: [package model, §4.1](https://agent-plugins.org/specification#41-general-requirements),
[manifest, §5.1-§5.6](https://agent-plugins.org/specification#5-manifest).

### Portable discovery rules

Agent Plugins v1 has exactly two portable component types:

```text
my-plugin/
├── plugin.json
├── skills/
│   └── summarize/
│       └── SKILL.md
└── mcp.json
```

`skills/` is scanned only one level deep: each immediate child directory with a
regular `SKILL.md` is one skill. The client must not recursively discover
deeper skills. `mcp.json` is the fixed root location for portable MCP
configuration. Missing fixed locations are allowed; an invalid present
location is reported without invalidating unrelated component types.
[Agent Plugins specification, §4.2 and §6](https://agent-plugins.org/specification#42-standard-layout)

Skills inside a plugin must follow the separate Agent Skills specification;
the Agent Plugins standard defines discovery, not the `SKILL.md` format.
[Agent Plugins specification, §7.1](https://agent-plugins.org/specification#71-skills)

For portable MCP configuration, use the required schema and `mcpServers`
object. A stdio server's `command` is one executable token, not a shell command
string; plugin-relative commands must start with `./`. Do not embed credentials
in committed environment or header values. [Agent Plugins specification,
§7.2](https://agent-plugins.org/specification#72-mcp-servers)

**Important boundary:** agents, hooks, prompts, and LSP are not portable
component types in Agent Plugins v1. Treat them as client extensions and
document the target client rather than claiming universal interoperability.
The specification source repository describes the same minimal portable shape:
`plugin.json` plus `skills/<name>/SKILL.md`.
[Agent Plugins spec repository README](https://github.com/agentplugins/agent-plugins-spec#readme)

## 3. Account for Claude Code differences

Claude Code's plugin system is a superset of the portable format. For local
Claude development, the manifest is normally
`.claude-plugin/plugin.json`; the other component directories stay at the
plugin root, not inside `.claude-plugin/`. The quickstart uses
`claude --plugin-dir ./my-first-plugin` and invokes a namespaced skill such as
`/my-first-plugin:hello`. [Claude Code create-plugin guide](https://code.claude.com/docs/en/plugins)

Claude Code supports:

- `skills/` directories containing `SKILL.md`;
- `agents/` Markdown definitions;
- `hooks/hooks.json`;
- `.mcp.json`;
- `.lsp.json`;
- experimental monitors and other client-specific settings.

Plugin agents support fields such as `name`, `description`, `model`, `effort`,
`maxTurns`, `tools`, `disallowedTools`, `skills`, `memory`, `background`, and
`isolation`. Plugin-shipped agents do **not** support `hooks`, `mcpServers`, or
`permissionMode`; do not put those fields in a Claude plugin agent.
[Claude Code plugins reference, Agents](https://code.claude.com/docs/en/plugins-reference#agents)

Claude hooks are lifecycle event handlers. They may be command, HTTP, MCP-tool,
prompt, or agent hooks, and plugin hooks targeting a bundled MCP server must use
the client's scoped tool name. [Claude Code plugins reference, Hooks](https://code.claude.com/docs/en/plugins-reference#hooks)

Claude's MCP and LSP file names differ from portable Agent Plugins:
Claude uses `.mcp.json` and `.lsp.json`, while portable Agent Plugins uses
`mcp.json` for its core MCP contract. Choose the target runtime before writing
the manifest or component files. [Claude Code plugins reference, MCP and LSP](https://code.claude.com/docs/en/plugins-reference#mcp-servers)

## 4. Apply the MartiX package contract

### Naming and location

Use lowercase kebab-case and the required `martix-` prefix. The machine-readable
layout policy defines:

- `plugins` as the plugin root;
- `skills` as the standalone-skill root;
- `plugin.json` as the manifest name;
- `plugins/<plugin>` and `skills/<skill-name>` as installable source roots;
- `agents`, `skills`, `prompts`, `instructions`, and `hooks` as required plugin
  directories.

Sources: [MartiX `docs/plugin-layout.yaml:1-22`](../../../../docs/plugin-layout.yaml);
[MartiX `AGENTS.md:20-31`](../../../../AGENTS.md).

### Required plugin skeleton

Create this shape even when some component directories initially contain only a
README:

```text
plugins/martix-<name>/
├── plugin.json
├── README.md
├── agents/
├── skills/
├── prompts/
├── instructions/
└── hooks/
```

The required plugin items and the rule to keep the bundle thin are documented
in [MartiX `docs/custom-ai-artifact-rules.md:326-370`](../../../../docs/custom-ai-artifact-rules.md).
The package README should state the bundle purpose, composed skills, install
commands, model-tier guidance, and validation command.
[MartiX `docs/plugin-bundle-strategy.md:80-90`](../../../../docs/plugin-bundle-strategy.md)

### Manifest for this repository

Start from `templates\plugin-package\plugin.json` and adapt only the identity
and components that actually exist:

```json
{
  "name": "martix-example",
  "description": "Concise purpose of the installable workflow bundle.",
  "version": "0.1.0",
  "author": {
    "name": "MartiXDev"
  },
  "license": "MIT",
  "keywords": [
    "martix",
    "project-family"
  ],
  "repository": "https://github.com/MartiXDev/skills",
  "agents": "agents/",
  "skills": "skills/",
  "hooks": "hooks.json"
}
```

Source: [MartiX plugin template, `templates/plugin-package/plugin.json:1-17`](../../../../templates/plugin-package/plugin.json).
The existing `martix-dotnet-library` manifest demonstrates the same pattern
without a hooks declaration because that bundle currently exposes only its
agent and skill roots. [Example manifest](../../../../plugins/martix-dotnet-library/plugin.json)

Do not blindly combine this MartiX manifest with the portable Agent Plugins
manifest. The portable standard requires `$schema` and restricts core
component discovery to `skills/` and `mcp.json`; the MartiX manifest uses
repository/client fields such as `agents`, `skills`, and `hooks`. If portability
is a requirement, produce a schema-conforming portable manifest and put
client-specific MartiX or Claude data in the documented client extension
surface. [Agent Plugins specification, §5.2 and §6.1](https://agent-plugins.org/specification#52-manifest-object)

### Agents

Put plugin-bundled agents in `plugins\martix-<name>\agents\`. MartiX prefers
`.agent.md` unless the target runtime requires plain `.md`. Keep the body
short, give the agent a distinct role, and link to package-local guidance
instead of copying a full rule library. Select `tools`, `model`, invocation,
handoff, and subagent settings deliberately. [MartiX
`docs/custom-ai-artifact-rules.md:180-218`](../../../../docs/custom-ai-artifact-rules.md)

A minimal repository agent definition can look like this, subject to the
target client's supported frontmatter:

```markdown
---
name: example-reviewer
description: Reviews the example workflow and reports actionable findings.
model: sonnet
tools: Read, Grep
---

Use the package references for the workflow's rules. Inspect the relevant files,
report evidence, and run the documented validation command before concluding.
```

For Claude Code specifically, use the supported plugin-agent fields and avoid
the unsupported `hooks`, `mcpServers`, and `permissionMode` fields noted above.

### Skills and progressive disclosure

Keep reusable domain guidance in a standalone `skills\martix-*` package. Add a
copy under `plugins\martix-<name>\skills\` only when it is genuinely
plugin-scoped. Keep `SKILL.md` as a compact activation/router entry point and
place durable detail in the smallest relevant `rules\` or `references\` file.
[MartiX `docs/custom-ai-artifact-rules.md:220-276`](../../../../docs/custom-ai-artifact-rules.md)

This avoids making every plugin invocation load unrelated context and preserves
the repository's standalone-first model. The repository glossary explicitly
defines a plugin as a distributable bundle and a skill as reusable instructions,
knowledge, and optional resources. [MartiX `CONTEXT.md:31-42`](../../../../CONTEXT.md)

### Instructions, prompts, hooks, MCP, and LSP

- Use `instructions\` for concise bundle-level guidance and `prompts\` for
  focused, user-invoked workflows. In this repository they are bundled assets;
  do not assume automatic discovery unless the target runtime documents it.
  [MartiX `docs/custom-ai-artifact-rules.md:147-178`](../../../../docs/custom-ai-artifact-rules.md)
- Use `hooks\` only for deterministic checks, formatting, policy enforcement,
  or repeatable lifecycle commands. New hook configuration should use
  event-keyed `version: 1` configuration, provide check-only behavior when it
  can modify files, return nonzero for unresolved failures, and document the
  command in the plugin README. [MartiX
  `docs/custom-ai-artifact-rules.md:388-418`](../../../../docs/custom-ai-artifact-rules.md)
- Add MCP only when static guidance is insufficient. Keep credentials out of
  committed configuration and document required secrets, variables, tools, and
  environment constraints. [MartiX
  `docs/custom-ai-artifact-rules.md:420-449`](../../../../docs/custom-ai-artifact-rules.md)
- Add LSP only when the workflow needs language intelligence beyond static
  documentation, and document installation of the external language server.
  [MartiX `docs/custom-ai-artifact-rules.md:451-474`](../../../../docs/custom-ai-artifact-rules.md)

## 5. Register and validate only an installable package

Add the marketplace entry only after the plugin directory has a valid,
installable manifest and the required package surfaces. The marketplace is
`.github\plugin\marketplace.json`; each entry's `source` must point to
`plugins/<plugin>` or `skills/<skill>`, never to `.github/plugin/`. The
entry's `name`, `version`, and `description` must match the source
`plugin.json`. [MartiX `docs/custom-ai-artifact-rules.md:372-387`](../../../../docs/custom-ai-artifact-rules.md)

Example:

```json
{
  "name": "martix-example",
  "description": "Concise purpose of the installable workflow bundle.",
  "version": "0.1.0",
  "source": "plugins/martix-example",
  "category": "development",
  "tags": [
    "martix",
    "project-family",
    "plugin-bundle"
  ]
}
```

The current marketplace contains both standalone skill sources and plugin
bundle sources, including `plugins/martix-dotnet-library` and
`plugins/martix-webapi`. [MartiX marketplace,
.github/plugin/marketplace.json:11-42,234-258`](../../../../.github/plugin/marketplace.json)

Run the focused Markdown check for changed Markdown files, then the repository
validator:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\plugins\martix-markdown-automation\hooks\markdown-check.ps1 `
  -CheckOnly -Path <changed-markdown-files>

powershell -ExecutionPolicy Bypass `
  -File .\scripts\validate-repository.ps1
```

Sources: [MartiX `AGENTS.md:47-60`](../../../../AGENTS.md);
[MartiX `docs/custom-ai-artifact-rules.md:511-578`](../../../../docs/custom-ai-artifact-rules.md).

## 6. Recommended creation sequence

Use this order for a new MartiX agent plugin:

1. **Write the boundary:** name the project workflow and list the existing
   standalone skills it composes. If the bundle adds no workflow value, stop and
   create or update a standalone skill instead.
2. **Create the package root:** `plugins\martix-<name>\` with the five required
   component directories and a README.
3. **Create the manifest:** copy the repository template, choose a unique
   lowercase `martix-` name, set the version and concise description, and expose
   only component roots that are real.
4. **Add agents:** create only specialized agents that reduce ambiguity or
   intentionally control tools/model/handoff behavior. Keep them small and
   target-runtime-specific.
5. **Compose skills:** link to existing standalone skills; add plugin-local
   skills only for truly bundle-specific knowledge.
6. **Add workflow assets:** add focused prompts and instructions. Add hooks,
   MCP, or LSP only when static guidance cannot provide the behavior.
7. **Document operation:** README must explain purpose, component inventory,
   installation, invocation, required variables/secrets, model-tier
   expectations, and validation.
8. **Check containment and secrets:** portable relative paths must remain inside
   the package; commands must use the target runtime's path rules; never commit
   credentials.
9. **Validate locally:** run Markdown and repository validation, then exercise
   the target client's local plugin loading path (for Claude Code,
   `claude --plugin-dir ...` and a namespaced invocation).
10. **Register last:** add and synchronize the marketplace entry only after the
    package is real and installable.

## 7. Caveats to record in the package README

- Agent Plugins v1.0.0 is a Working Draft, so portability claims should name the
  tested client and version. [Specification status](https://agent-plugins.org/specification#1-status-and-version)
- Portable Agent Plugins and Claude Code use different manifest/component
  locations (`plugin.json`/`mcp.json` versus Claude's
  `.claude-plugin/plugin.json`/`.mcp.json`).
- The MartiX `skills\` publishing layout is repository-specific; it is not a
  universal Agent Skills discovery location.
- MartiX plugin-local `instructions\` and `prompts\` are not assumed to be
  automatically discovered.
- Hook event names and casing vary by client. Verify the schema for the runtime
  that will execute the plugin; do not treat an older `trigger` placeholder as
  the current event-keyed contract.
- Plugin-local `.mcp.json` auto-loading must be verified for the target
  marketplace/runtime before it is made a dependency of the workflow.

These cautions are called out by the repository's canonical artifact rules.
[MartiX `docs/custom-ai-artifact-rules.md:495-509`](../../../../docs/custom-ai-artifact-rules.md)

## Source index

1. Resource index: `docs/knowledge/ai/plugins/ai-plugins-resources.md:1-6`
2. Agent Plugins specification: <https://agent-plugins.org/specification>
3. Agent Plugins source repository and minimal example:
   <https://github.com/agentplugins/agent-plugins-spec>
4. GitHub-search-pinned specification source:
   <https://github.com/agentplugins/agent-plugins-spec/blob/bd383552095128f6effe895b9257cfd580a6d179/spec/1.0.0.md>
5. Claude Code plugin creation guide: <https://code.claude.com/docs/en/plugins>
6. Claude Code plugin reference: <https://code.claude.com/docs/en/plugins-reference>
7. MartiX artifact rules: `docs/custom-ai-artifact-rules.md`
8. MartiX plugin strategy: `docs/plugin-bundle-strategy.md`
9. MartiX layout policy: `docs/plugin-layout.yaml`
10. MartiX plugin template: `templates/plugin-package/plugin.json`
