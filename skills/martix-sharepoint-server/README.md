## Package overview

`martix-sharepoint-server` is the canonical standalone-first source package for
the MartiX SharePoint Server skill. It stores the authored entrypoints, rule
library, reference maps, templates, eval seeds, and machine-readable taxonomy
that standalone installs should consume directly.

- Canonical source root: `skills\martix-sharepoint-server`
- Primary install surface: standalone `skills` CLI
- Secondary install surface: Copilot CLI plugin marketplace metadata
- Discovery key: `martix-sharepoint-server`

## Package structure

| Path | Purpose |
| --- | --- |
| [SKILL.md](./SKILL.md) | Activation router for classic SharePoint server-side scope |
| [AGENTS.md](./AGENTS.md) | Companion guide for cross-workstream review and maintenance |
| [rules/](./rules) | Six rule files across six workstreams plus support scaffolds |
| [references/](./references) | Six reference files covering sources, routing, maps, and anti-patterns |
| [templates/](./templates) | Author scaffolds for new rules, research packs, and comparisons |
| [assets/](./assets) | Taxonomy and preferred ordering data |
| [metadata.json](./metadata.json) | Package identity, inventory, and distribution metadata |
| [evals/](./evals) | Starter prompts for smoke-checking routing and answer quality |

## Maintainer notes

- The shared rule contract lives in [rules/_sections.md](./rules/_sections.md).
- The recommended workstream ordering lives in
  [assets/section-order.json](./assets/section-order.json).
- The domain taxonomy lives in
  [assets/taxonomy.json](./assets/taxonomy.json).
- The approved source boundaries and precedence rules live in
  [references/doc-source-index.md](./references/doc-source-index.md).
- The registration-ready inventory lives in [metadata.json](./metadata.json).

## Installation

### Copilot CLI marketplace flow

Use the marketplace flow for normal GitHub Copilot CLI installs.

```powershell
copilot plugin marketplace add MartiXDev/skills
copilot plugin marketplace list
copilot plugin marketplace browse martix-skills
copilot plugin install martix-sharepoint-server@martix-skills
```

### Standalone skills CLI flow

Use repo-root skill selection for standalone skill installs.

```powershell
npx skills add https://github.com/MartiXDev/skills --skill martix-sharepoint-server
```

### Direct source path flow

Use a direct package path only for local validation or development.

```powershell
npx skills add C:\Git\MartiXDev\skills\skills\martix-sharepoint-server -a github-copilot -y
npx skills add C:\Git\MartiXDev\skills\skills\martix-sharepoint-server -a github-copilot --copy -y
```

For validation from GitHub, point at the package folder:
`https://github.com/MartiXDev/skills/tree/main/skills/martix-sharepoint-server`.

Only the following slash-command equivalents are documented in the reviewed
research, so keep marketplace browsing as a shell command for now.

```text
/plugin marketplace add MartiXDev/skills
/plugin marketplace list
/plugin install martix-sharepoint-server@martix-skills
/plugin marketplace remove martix-skills
```

## Verification

### Package-local JSON validation

Use package-local checks before attempting any install flow:

```powershell
Get-Content .\skills\martix-sharepoint-server\metadata.json | ConvertFrom-Json | Out-Null
Get-Content .\skills\martix-sharepoint-server\assets\taxonomy.json | ConvertFrom-Json | Out-Null
Get-Content .\skills\martix-sharepoint-server\assets\section-order.json | ConvertFrom-Json | Out-Null
Get-Content .\skills\martix-sharepoint-server\evals\evals.json | ConvertFrom-Json | Out-Null
```

### Optional standalone install smoke test

If you want to smoke-test the package locally after the files are in place, use
the standalone flow:

```powershell
npx skills add C:\Git\MartiXDev\skills\skills\martix-sharepoint-server --list
npx skills list
```

Expect to see an installed entry named `martix-sharepoint-server` after a
successful install.

## Update and uninstall

### Standalone update

```powershell
npx skills check
npx skills update
```

### Standalone uninstall

```powershell
npx skills remove martix-sharepoint-server
npx skills rm martix-sharepoint-server
```

Add `-g` when removing a global standalone install.

## Discovery precedence and same-name conflicts

Copilot deduplicates by the skill `name` declared in `SKILL.md`, not by folder
path. A project or personal standalone install can load before a later package
with the same name from another source.

- A standalone `martix-sharepoint-server` install can shadow any later package
  published under the same name.
- For marketplace validation, use a clean environment or remove the standalone
  copy first.
- If multiple surfaces must coexist later, the package names must stay
  distinct.

## Troubleshooting

| Symptom | Likely cause | What to do |
| --- | --- | --- |
| `npx skill add` fails | The documented binary is `skills`, not `skill` | Use `npx skills add <source>` exactly as shown |
| Repo-root install discovery fails | `Skills` is not a documented default discovery root | Install from a direct folder path or direct GitHub tree URL |
| Windows relative path is treated like a git source | The `skills` CLI interprets `.\skills\...` as a git-like source on Windows | Use the full absolute path instead |
| Marketplace install is unavailable | Shared marketplace metadata has not been updated yet | Restore or update the shared marketplace manifests in a separate task |
