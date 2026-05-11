# Plugin bundle strategy

MartiX skills stay standalone by default. Plugins exist to make repeatable
project families easy to install and to add only the project-level instructions,
prompts, hooks, agents, or MCP configuration that cannot live cleanly in one
skill.

## Decision rules

### Keep a standalone skill when

- The capability is useful across more than one project family.
- The domain is focused: C#, FastEndpoints, FluentValidation, TUnit,
  PowerShell, Markdown, SPFx, PnP, or SharePoint Server.
- The package can be installed and used independently.
- The package does not need plugin-level hooks, prompts, MCP configuration, or
  bundled agents.
- The guidance has enough depth to justify its own `rules\`, `references\`,
  `templates\`, `assets\`, and `evals\`.

### Create a plugin bundle when

- A future project type repeatedly needs several standalone skills together.
- The bundle represents a MartiX project archetype, such as .NET library,
  web API, full-stack web app, SharePoint Server, or SharePoint Online.
- The bundle needs project-level setup guidance, prompts, instructions, hooks,
  agents, or validation workflow.
- The bundle reduces setup friction without duplicating standalone skill content.
- The bundle can add concise model-tier, `/fleet`, worktree, AFK/HITL, or
  validation orchestration.

### Do not create a plugin bundle when

- One standalone skill is enough.
- The bundle would only duplicate skill documentation.
- The included skills have no natural shared project workflow.
- The plugin would force unrelated work into the same context and increase
  token usage.

If a plugin reveals a reusable capability gap, create the standalone skill
first. For example, a complete `martix-webapp` plugin should depend on a
reusable React/TypeScript skill rather than hiding frontend guidance inside the
plugin.

## Current and proposed bundles

### Existing bundles

- `martix-markdown-automation`: automatic Markdown check and fix workflow for
  projects that want workspace-level Markdown enforcement. Uses
  `martix-markdown`.
- `martix-dotnet-library`: .NET library creation, modernization, validation,
  testing, docs, and release readiness. Uses `martix-dotnet-csharp`,
  `martix-fluentvalidation` when validation matters, `martix-tunit`,
  `martix-markdown`, and optional `martix-powershell`.
- `martix-webapi`: .NET backend/API projects, especially FastEndpoints-based
  APIs. Uses `martix-dotnet-csharp`, `martix-fastendpoints`,
  `martix-fluentvalidation`, `martix-tunit`, and `martix-markdown`.

### Proposed bundles

- `martix-webapp`: full-stack web apps with C#/.NET backend and
  React/TypeScript frontend. Uses .NET, validation, testing, Markdown, and a
  future React/TypeScript skill.
- `martix-sharepoint-server-suite`: SharePoint Server on-premises farm
  solutions, WSP packaging, PowerShell automation, and documentation.
- `martix-sharepoint-online-suite`: SharePoint Online, SPFx, PnP provisioning,
  Teams/Viva-connected work, and docs.
- `martix-app-dev-core`: generic application-development workflow bundle for
  planning, documentation, testing, validation, and codebase hygiene.

## Existing plugin implementation order

Start with the existing installable plugin names:

1. `martix-dotnet-library`
2. `martix-webapi`
3. `martix-markdown-automation`

For each existing plugin:

- Add `README.md` with the bundle purpose, composed skills, install commands,
  model-tier guidance, and validation command.
- Add `instructions\README.md` with concise bundle-level instruction rules.
- Add `prompts\README.md` with planned prompt assets or a note that prompts are
  intentionally not included yet.
- Add `hooks\README.md` with planned hook assets or a note that hooks are
  intentionally not included yet.
- Keep the plugin thin; link to standalone skills instead of copying their full
  content.

## Proposed plugin readiness

Do not register proposed plugins in `.github\plugin\marketplace.json` until
they have real package folders and installable manifests.

- `martix-webapp`: not ready for marketplace registration. It needs a reusable
  React/TypeScript frontend skill.
- `martix-sharepoint-server-suite`: ready to design. Existing skills cover the
  core package.
- `martix-sharepoint-online-suite`: ready to design. Existing SPFx and PnP
  skills cover the core; a React/TypeScript skill would improve it.
- `martix-app-dev-core`: not ready for marketplace registration. It needs
  dedicated workflow skills for planning, architecture, TDD, and issue slicing,
  or an explicit decision to depend on external skills.

## Cost and parallel guidance

- Use a premium model for initial bundle boundary decisions.
- Use medium models for package-local bundle README and instruction implementation.
- Use cheap models for validation, link checks, and mechanical metadata synchronization.
- Assign one plugin folder per `/fleet` agent or git worktree.
- Treat `.github\plugin\marketplace.json`, root README files, shared templates,
  and validation scripts as shared-file coordinator work.
- Run repository validation before merging bundle work:

  ```powershell
  powershell -ExecutionPolicy Bypass `
    -File .\scripts\validate-repository.ps1
  ```
