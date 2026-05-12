# Custom AI artifact rules

## Status

This document is the phase 2 specification for custom AI artifacts in this
repository. It combines upstream artifact requirements with MartiX repository
overlays.

Use this document when creating or updating:

- repository custom instructions
- file-based instructions
- prompt files
- custom agents and subagents
- standalone Agent Skills
- Copilot CLI plugin bundles
- hooks
- MCP configuration
- LSP configuration
- metadata, evals, templates, and validation rules

## Resources

Keep this section as the wiki-style source list used to create or revise these
rules.

### Primary source pages

- [VS Code Copilot customization overview](https://code.visualstudio.com/docs/copilot/customization/overview)
- [GitHub Copilot customization overview](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-copilot-overview)
- [Agent Skills specification](https://agentskills.io/specification)
- [GitHub Copilot CLI plugins overview](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-cli-plugins)

### VS Code Copilot customization

- [Customization overview](https://code.visualstudio.com/docs/copilot/customization/overview)
- [Customization concepts](https://code.visualstudio.com/docs/copilot/concepts/customization)
- [Custom instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
- [Prompt files](https://code.visualstudio.com/docs/copilot/customization/prompt-files)
- [Agent skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [Custom agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
- [Subagents](https://code.visualstudio.com/docs/copilot/agents/subagents)
- [Language models](https://code.visualstudio.com/docs/copilot/customization/language-models)
- [Agent plugins](https://code.visualstudio.com/docs/copilot/customization/agent-plugins)
- [MCP servers](https://code.visualstudio.com/docs/copilot/customization/mcp-servers)
- [MCP configuration reference](https://code.visualstudio.com/docs/copilot/reference/mcp-configuration)
- [Hooks](https://code.visualstudio.com/docs/copilot/customization/hooks)
- [Customize AI for your project](https://code.visualstudio.com/docs/copilot/guides/customize-copilot-guide)
- [Troubleshoot agent issues](https://code.visualstudio.com/docs/copilot/troubleshooting)
- [Chat Debug view](https://code.visualstudio.com/docs/copilot/chat/chat-debug-view)

### GitHub Copilot customization

- [Customize Copilot overview](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-copilot-overview)
- [Customization cheat sheet](https://docs.github.com/en/copilot/reference/customization-cheat-sheet)
- [About customizing GitHub Copilot responses](https://docs.github.com/en/copilot/concepts/prompting/response-customization)
- [Custom instructions support reference](https://docs.github.com/en/copilot/reference/custom-instructions-support)
- [Add repository instructions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions/add-repository-instructions)
- [Add personal instructions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions/add-personal-instructions)
- [About custom agents](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-custom-agents)
- [Create custom agents](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/create-custom-agents)
- [Custom agents configuration reference](https://docs.github.com/en/copilot/reference/custom-agents-configuration)
- [About agent skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)
- [Add skills](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/add-skills)
- [MCP and cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/mcp-and-cloud-agent)
- [Extend cloud agent with MCP](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/extend-cloud-agent-with-mcp)
- [Configure secrets and variables for Copilot cloud agent](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/configure-secrets-and-variables)
- [About hooks](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-hooks)
- [About GitHub Copilot Spaces](https://docs.github.com/en/copilot/concepts/about-organizing-and-sharing-context-with-copilot-spaces)
- [Create Copilot Spaces](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/copilot-spaces/create-copilot-spaces)
- [Collaborate with Copilot Spaces](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/copilot-spaces/collaborate-with-others)
- [Copilot plans](https://docs.github.com/en/copilot/about-github-copilot/subscription-plans-for-github-copilot)
- [Cloud agent access management](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/access-management)

### Agent Skills

- [Agent Skills overview](https://agentskills.io/home.md)
- [Specification](https://agentskills.io/specification.md)
- [Quickstart](https://agentskills.io/skill-creation/quickstart.md)
- [Best practices for skill creators](https://agentskills.io/skill-creation/best-practices.md)
- [Optimizing skill descriptions](https://agentskills.io/skill-creation/optimizing-descriptions.md)
- [Using scripts in skills](https://agentskills.io/skill-creation/using-scripts.md)
- [Evaluating skill output quality](https://agentskills.io/skill-creation/evaluating-skills.md)
- [How to add skills support to your agent](https://agentskills.io/client-implementation/adding-skills-support.md)
- [Client showcase](https://agentskills.io/clients.md)
- [Documentation index](https://agentskills.io/llms.txt)
- [skills-ref reference library](https://github.com/agentskills/agentskills/tree/main/skills-ref)

### GitHub Copilot CLI plugins

- [CLI customization overview](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/overview)
- [Comparing CLI features](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features)
- [About CLI plugins](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-cli-plugins)
- [Creating a plugin](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-creating)
- [Creating a plugin marketplace](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-marketplace)
- [CLI plugin reference](https://docs.github.com/en/copilot/reference/cli-plugin-reference)
- [Finding and installing plugins](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-finding-installing)
- [Enterprise plugin standards](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-enterprise-plugin-standards)
- [Configuring enterprise plugin standards](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/manage-agents/configure-enterprise-plugin-standards)
- [About custom agents for Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-custom-agents)
- [Creating custom agents for Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli)
- [Custom agents configuration reference](https://docs.github.com/en/copilot/reference/custom-agents-configuration)
- [Adding agent skills for Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-skills)
- [Adding custom instructions for Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions)
- [Using hooks with Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-hooks)
- [Hooks configuration reference](https://docs.github.com/en/copilot/reference/hooks-configuration)
- [CLI hooks reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-hooks-reference)
- [Adding MCP servers for Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers)
- [LSP servers](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/lsp-servers)
- [Adding LSP servers for Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/add-lsp-servers)
- [GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli)

## Decision model

Use the narrowest artifact that satisfies the requirement.

- Repository-wide conventions used in every session:
  `.github\copilot-instructions.md`.
- File or folder scoped behavior:
  `.github\instructions\<name>.instructions.md`.
- Repeatable user-invoked workflow:
  `.github\prompts\<name>.prompt.md` or plugin prompt.
- Specialized role with distinct tools, model, or handoff behavior:
  custom agent.
- Reusable domain capability or knowledge: standalone skill.
- Bundled installable workflow with plugin-scoped assets: plugin bundle.
- Automatic lifecycle check or policy enforcement: hook.
- External tool or data access: MCP configuration.
- Language intelligence server: LSP configuration.

Repository rule: prefer standalone skills for reusable domain knowledge. Create
plugin bundles only when plugin scoping, lifecycle hooks, agents, prompts, MCP,
LSP, or one-step installation is required.

## Repository source boundaries

1. Keep reusable domain knowledge in `skills\<martix-name>\`.
2. Keep plugin-scoped agents, skills, instructions, prompts, hooks, MCP, and LSP
   configuration in `plugins\<martix-name>\`.
3. Keep marketplace metadata in `.github\plugin\marketplace.json`.
4. Do not place installable source files under `.github\plugin\`.
5. Keep shared templates in `templates\`.
6. Keep architecture and repository policy in `docs\`.

## Artifact specifications

### Repository custom instructions

Purpose: always-on repository context for Copilot sessions.

Allowed location:

- `.github\copilot-instructions.md`

Rules:

- Use this file only for rules that should apply broadly across the repository.
- Include repository structure, build/test/lint commands, and conventions that
  are not obvious from one file.
- Keep package-specific rule libraries in package docs, not in this file.
- Do not use front matter for this repository file unless a future upstream
  source requires it.

Validation:

- Markdown hook for the file.
- Repository validation for Markdown fence and link checks where applicable.

### File-based instructions

Purpose: scoped behavior for files, folders, languages, or artifact families.

Allowed repository location:

- `.github\instructions\<name>.instructions.md`

Upstream fields:

- YAML front matter may include `applyTo`.
- GitHub repository instructions may include `excludeAgent`.
- VS Code also recognizes optional `name` and `description`.

Repository rules:

- Use `applyTo` for every file-based instruction.
- Keep `applyTo` globs narrow enough to avoid cross-package surprise.
- Prefer repo-wide `copilot-instructions.md` for universal policy.
- Prefer package docs for package-specific knowledge.

Example:

```yaml
---
applyTo: "skills/martix-markdown/**/*.md"
---
```

### Agent instruction files

Purpose: agent-specific persistent instructions recognized by some clients.

Relevant upstream files:

- `AGENTS.md`
- `CLAUDE.md`
- `GEMINI.md`

Repository rules:

- `AGENTS.md` is required in standalone skill packages as maintainer and
  companion-agent guidance.
- Package `AGENTS.md` files are package documentation first. Do not assume every
  Copilot surface auto-loads them.
- Use `.github\copilot-instructions.md` for repository-wide Copilot behavior.
- Use `.github\instructions\*.instructions.md` for file-scoped behavior.

### Prompt files

Purpose: repeatable user-invoked workflows.

Upstream locations:

- `.github\prompts\<name>.prompt.md` for repository-discovered prompts.
- User-profile prompt locations are client-specific.

Plugin repository location:

- `plugins\<plugin>\prompts\`

Upstream front matter fields include:

- `description`
- `name`
- `argument-hint`
- `agent`
- `model`
- `tools`

Repository rules:

- Use `.github\prompts\*.prompt.md` when the prompt must be discovered as a
  repository prompt.
- Use `plugins\<plugin>\prompts\` for plugin-owned prompt assets.
- Plugin prompt assets are not assumed to be auto-discovered unless the plugin
  manifest or target runtime supports that path.
- Keep each prompt focused on one workflow outcome.
- Include expected inputs, outputs, and validation commands.
- Do not use prompts for automatic enforcement; use hooks or instructions.

### Custom agents and subagents

Purpose: specialized assistants with distinct role, tools, model, or handoff
behavior.

Upstream locations include:

- `.github\agents\<name>.agent.md`
- `.github\agents\<name>.md` for some cloud-agent examples
- `plugins\<plugin>\agents\` for plugin-bundled agents

Upstream front matter fields include:

- `name`
- `description`
- `tools`
- `mcp-servers`
- `model`
- `target`
- `agents`
- `argument-hint`
- `user-invocable`
- `disable-model-invocation`
- `handoffs`
- `hooks`

Repository rules:

- Put plugin-bundled agents in `plugins\<plugin>\agents\`.
- Use `.agent.md` for custom agent files unless an upstream target requires
  plain `.md`.
- Create an agent only when a specialized role reduces ambiguity or controls
  tools/model access.
- Keep the agent body concise and point to package-local docs instead of
  embedding whole rule libraries.
- Use `agents`, `user-invocable`, and `disable-model-invocation` deliberately
  when designing subagent behavior.
- Treat agent-scoped hooks as preview behavior and document the client/runtime
  that supports them.

### Standalone skills

Purpose: reusable capability or domain knowledge.

Repository location:

- `skills\<martix-name>\`

Upstream `SKILL.md` requirements:

- `SKILL.md` is required.
- YAML front matter is required.
- `name` is required.
- `description` is required.
- `license`, `compatibility`, `metadata`, and `allowed-tools` are optional in
  the Agent Skills specification.

Upstream `name` constraints:

- 1 to 64 characters.
- Lowercase letters, numbers, and hyphens only.
- No leading or trailing hyphen.
- No consecutive hyphens.
- Must match the parent directory name for Agent Skills compatibility.

Upstream `description` constraints:

- 1 to 1024 characters.
- Describes what the skill does and when to use it.
- Should contain task keywords that help routing.

Repository-required standalone skill items:

- `plugin.json`
- `metadata.json`
- `README.md`
- `SKILL.md`
- `AGENTS.md`
- `LICENSE.txt`
- `rules\`
- `references\`
- `templates\`
- `assets\taxonomy.json`
- `assets\section-order.json`
- `evals\evals.json`

Repository rules:

- Directory and package name must use the `martix-` prefix.
- `SKILL.md` is the activation router, not the full knowledge base.
- Durable detail belongs in the closest `rules\` or `references\` file.
- Reusable examples and scaffolds belong in `templates\`.
- Machine-readable routing and ordering data belongs in `assets\`.
- Update `metadata.json`, `assets\taxonomy.json`,
  `assets\section-order.json`, and evals when rules or routes move.
- Use progressive disclosure: route from `SKILL.md` to the smallest relevant
  supporting file.

### Skill scripts

Purpose: executable helpers bundled with skills.

Upstream rules:

- Reference scripts by relative path from the skill root.
- Make scripts non-interactive.
- Provide useful `--help` output when the script is agent-callable.
- Pin or declare dependencies in the script or package.
- Use exit codes to signal success or failure.

Repository rules:

- Prefer scripts only for deterministic operations.
- Document script invocation in `README.md` or the nearest reference file.
- Keep scripts package-local unless they are repository validators.

### Evals

Purpose: regression coverage for skill routing and expected output quality.

Upstream Agent Skills eval schema differs from this repository's current schema.

Repository eval shape:

- top-level `skill`
- `evals` array
- each eval has a string `id`
- each eval has `prompt`
- each eval has `expected_output` or `expected_sections`
- optional fields include `files`, `model_tier`, and `parallel_safe`

Repository rules:

- Keep existing repository eval schema unless a deliberate migration is planned.
- Add or update evals when skill routing, trigger behavior, or expected answer
  quality changes.
- Use evals to cover package-specific mistakes and boundary decisions.

### Plugin bundles

Purpose: installable Copilot CLI bundles containing agents, skills, hooks,
prompts, MCP, LSP, or workflow-specific configuration.

Repository location:

- `plugins\<martix-name>\`

Required repository plugin items:

- `plugin.json`
- `README.md`
- `agents\`
- `skills\`
- `prompts\`
- `instructions\`
- `hooks\`

Plugin manifest fields from upstream and repo practice:

- `name`
- `description`
- `version`
- `author`
- `license`
- `keywords`
- `repository`
- `agents`
- `skills`
- `hooks`
- `mcpServers`

Repository rules:

- Directory and plugin name must use the `martix-` prefix.
- Keep plugins thin and link to standalone skills instead of duplicating rule
  libraries.
- Use plugin-local `instructions\` as guidance unless the target runtime
  documents automatic discovery for that path.
- Use plugin-local `prompts\` as bundled assets unless the target runtime
  documents automatic discovery for that path.
- Add marketplace registration only after the plugin folder is installable.
- Keep marketplace `name`, `version`, and `description` synchronized with
  source `plugin.json`.

### Marketplace metadata

Purpose: Copilot CLI marketplace index for this repository.

Repository location:

- `.github\plugin\marketplace.json`

Repository rules:

- Marketplace name is `martix-skills`.
- Each entry `source` points to either `skills\<skill>` or `plugins\<plugin>`.
- Keep source paths out of `.github\plugin\`.
- Keep `name`, `version`, and `description` aligned with source `plugin.json`.
- Tags should be concise, searchable, and registry-friendly.

### Hooks

Purpose: deterministic lifecycle automation or policy enforcement.

Upstream hook locations vary by surface:

- VS Code uses `.github\hooks\*.json` for workspace hooks.
- Copilot CLI supports hook configuration through `hooks.json`.
- Plugins may ship hook configuration as a manifest path or hook asset.

Upstream hook schema themes:

- hook configuration uses `version: 1`
- hooks are keyed by lifecycle event
- command hooks define command text, shell-specific command fields, working
  directory, environment, and timeout
- hook input is JSON
- hook output is JSON
- nonzero or structured block/deny output can stop or alter execution

Repository rules:

- Use hooks for deterministic checks, formatting, policy enforcement, or
  repeatable lifecycle commands.
- Provide check-only mode when a hook can modify files.
- Re-run validation after auto-fix.
- Exit nonzero when remaining issues require action.
- Keep hook output concise enough for CI and cheap-model validation.
- Document local hook commands in plugin `README.md` and `hooks\README.md`.
- Do not use the older placeholder schema with `trigger` as the primary event
  contract for new hooks.

### MCP configuration

Purpose: connect agents to external tools, data, APIs, and services.

Common upstream locations:

- `.vscode\mcp.json` for VS Code workspace MCP.
- GitHub cloud agent repository settings JSON for cloud-agent MCP.
- Copilot CLI user config such as `~\.copilot\mcp-config.json`.
- plugin manifests or plugin-local files when a plugin bundles MCP setup.

Upstream schema concepts:

- MCP servers are keyed objects.
- Server types include local or stdio, HTTP, and SSE depending on surface.
- Local servers define command, args, and env.
- Remote servers define URL and headers.
- Tool allowlists can limit exposed tools.
- Some surfaces support input variables, secret substitution, or sandbox
  settings.

Repository rules:

- Add MCP only when static guidance is insufficient.
- Keep credentials out of committed config.
- Document required secrets, variables, tools, and environment constraints.
- For GitHub cloud agent MCP secrets and variables, use the `COPILOT_MCP_`
  prefix where required by upstream docs.
- Keep MCP config package-local only when plugin packaging is intentional;
  otherwise document the repository or user-level target location.

### LSP configuration

Purpose: language intelligence for agents and Copilot CLI.

Common upstream locations:

- project `.github\lsp.json`
- plugin-provided LSP configuration
- user `~\.copilot\lsp-config.json`

Upstream schema concepts:

- LSP servers are keyed objects.
- Server config includes command, args, file extensions, environment, root URI,
  initialization options, and request timeout depending on surface.
- Loading priority can differ between project, plugin, and user configs.

Repository rules:

- Add LSP only when a package needs language intelligence beyond static docs.
- Document required language server installation or package dependencies.
- Prefer plugin-local LSP only for installable plugin workflows.
- Keep LSP config out of standalone skills unless the skill documents how a
  consumer should configure it externally.

## Repository overlays

These rules are stricter than upstream docs and are intentional repository
conventions.

- Naming: packages use `martix-` and lowercase kebab-case.
- Package model: standalone skills are preferred over plugin bundles.
- Skill completeness: skills require metadata, AGENTS, license, rules,
  references, templates, assets, and evals.
- Plugin completeness: plugins require standard asset folders even when
  initially empty.
- Evals: this repo uses `skill`, string eval IDs, `model_tier`, and
  `parallel_safe`.
- Context: `SKILL.md` stays routing-oriented; details move to rules or
  references.
- Marketplace: marketplace entries must match source manifests.
- Parallel work: shared files are coordinator-owned; package folders are safer
  worktree slices.

## Open questions and cautions

- `plugins\<plugin>\instructions\*.md` are guidance assets unless a target
  runtime documents automatic discovery for that plugin path.
- `plugins\<plugin>\prompts\` assets are not assumed to be repository prompt
  files unless the target runtime discovers them through the plugin.
- `skills\<skill>\` is this repository's publishing layout, not the universal
  Agent Skills discovery location.
- Existing hook metadata that uses a `trigger` field should be treated as a
  transitional placeholder, not the exact upstream hook schema.
- Hook event names and casing differ across VS Code and Copilot CLI docs.
- Plugin-local `.mcp.json` auto-loading should be verified before relying on it
  for a marketplace package.
- Marketplace `metadata.homepage` is useful repo metadata but should be treated
  as a repository extension unless supported by the target marketplace schema.

## Validation matrix

- Markdown docs:
  `plugins\martix-markdown-automation\hooks\markdown-check.ps1`.
- Repository contract: `scripts\validate-repository.ps1`.
- JSON manifests: repository validation parses all JSON files.
- YAML files: repository validation parses YAML when PyYAML is available;
  otherwise lightweight checks run.
- Marketplace entries: repository validation checks source existence and
  manifest alignment.
- Skill completeness: repository validation checks required skill files and
  folders.
- Plugin completeness: repository validation checks required plugin folders.
- Eval files: repository validation checks top-level skill and required eval
  fields.
- Taxonomy references: repository validation checks referenced package paths.

Current validation gaps:

- `SKILL.md` front matter constraints are not fully validated.
- `*.instructions.md` front matter is not validated.
- `.prompt.md` front matter is not validated.
- `.agent.md` front matter is not validated.
- Hook schema is not validated against event-keyed upstream schemas.
- MCP and LSP schemas are not validated.
- Repository-specific marketplace metadata extensions are not explicitly
  classified.

## Template alignment

Keep templates aligned with this specification.

Update or add templates when implementing the next template pass:

- `templates\skill-package\SKILL.md`
- `templates\skill-package\metadata.json`
- `templates\skill-package\evals\evals.json`
- `templates\skill-package\AGENTS.md`
- `templates\plugin-package\plugin.json`
- `templates\plugin-package\instructions\README.md`
- `templates\plugin-package\prompts\README.md`
- `templates\plugin-package\hooks\README.md`
- future `.github\instructions\*.instructions.md` template
- future `.github\prompts\*.prompt.md` template
- future `.agent.md` template
- future MCP and LSP configuration templates

Do not rewrite existing packages only to match a template unless the
specification introduces a required contract change.

## Standard validation commands

Run repository validation before publishing, opening a PR, or changing shared
contracts:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1
```

Run Markdown validation for this document:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\plugins\martix-markdown-automation\hooks\markdown-check.ps1 `
  -CheckOnly `
  -Path .\docs\custom-ai-artifact-rules.md
```
