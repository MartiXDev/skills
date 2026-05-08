## Package overview

`martix-sharepoint-spfx` is the canonical standalone-first source package for
the MartiX SharePoint Framework skill. It stores the authored router,
companion guide, rule library, reference maps, templates, eval seeds, and
machine-readable taxonomy that direct standalone installs should consume.

- Canonical source root: `Skills\martix-sharepoint-spfx`
- Primary install surface: standalone `skills` CLI
- Secondary install surface: Copilot CLI plugin marketplace via shared
  repository metadata
- Discovery key: `martix-sharepoint-spfx`
- Shared marketplace registration: managed outside this package

## Package structure

| Path | Purpose |
| --- | --- |
| [SKILL.md](./SKILL.md) | Activation router for SPFx scope, workstreams, and quick defaults |
| [AGENTS.md](./AGENTS.md) | Companion playbook for cross-workstream review and maintenance |
| [rules/](./rules) | Eleven high-signal rule files across ten SPFx workstreams plus support scaffolds |
| [references/](./references) | Ten reference maps covering sources, support boundaries, components, toolchains, data clients, deployment, Teams or Viva, and migration |
| [templates/](./templates) | Author scaffolds for new rules, research packs, and comparisons |
| [assets/](./assets) | Taxonomy, preferred ordering, and host-support matrix data |
| [metadata.json](./metadata.json) | Package identity, taxonomy, artifact inventory, and distribution handoff notes |
| [evals/](./evals) | Starter prompts for smoke-checking routing and answer quality |

## Maintainer notes

- The shared rule contract lives in [rules/_sections.md](./rules/_sections.md).
- The approved source boundaries and precedence rules live in
  [references/doc-source-index.md](./references/doc-source-index.md).
- Taxonomy, workstream ordering, and host-support notes live in
  [assets/taxonomy.json](./assets/taxonomy.json),
  [assets/section-order.json](./assets/section-order.json), and
  [assets/host-support-matrix.json](./assets/host-support-matrix.json).
- The canonical package inventory lives in [metadata.json](./metadata.json).
- Shared marketplace registration is maintained outside this folder; when those
  repository-level entries exist, they should point directly at this package
  source.

## Installation

### Standalone skills CLI flow

Use the standalone flow as the primary install surface for this package.

- Official docs currently show `npx skills add <source>`.
- Official docs do **not** currently show `npx skill add <source>`.
- Because this repository keeps the package under `Skills\...`, prefer an
  absolute folder path or a direct GitHub tree URL instead of repo-root
  discovery. In this environment, a Windows relative path such as
  `.\Skills\martix-sharepoint-spfx` is treated like a git source by the
  `skills` CLI and fails preview or install.

```powershell
npx skills add C:\Git\MartiXDev\skills\Skills\martix-sharepoint-spfx -a github-copilot -y
npx skills add C:\Git\MartiXDev\skills\Skills\martix-sharepoint-spfx -a github-copilot --copy -y
```

After the package is committed to a public branch, the same folder can also be
installed from a direct GitHub tree URL.

### Copilot CLI plugin marketplace flow

Use the marketplace flow against the same standalone source package when the
repository-level SharePoint marketplace entries are present. Shared marketplace
metadata lives outside this folder and should point directly at
`Skills\martix-sharepoint-spfx`.

```powershell
copilot plugin marketplace add MartiXDev/skills
copilot plugin marketplace list
copilot plugin marketplace browse martix-skills
copilot plugin install martix-sharepoint-spfx@martix-skills
```

Treat those commands as the shared-registration handoff, not as package-local
proof that the SharePoint marketplace entry is already live.

## Verification

### Package-local JSON validation

Use package-local checks before attempting any install flow:

```powershell
Get-Content .\Skills\martix-sharepoint-spfx\metadata.json | ConvertFrom-Json | Out-Null
Get-Content .\Skills\martix-sharepoint-spfx\assets\taxonomy.json | ConvertFrom-Json | Out-Null
Get-Content .\Skills\martix-sharepoint-spfx\assets\section-order.json | ConvertFrom-Json | Out-Null
Get-Content .\Skills\martix-sharepoint-spfx\assets\host-support-matrix.json | ConvertFrom-Json | Out-Null
Get-Content .\Skills\martix-sharepoint-spfx\evals\evals.json | ConvertFrom-Json | Out-Null
```

### Optional standalone install smoke test

If you want to smoke-test the package locally after the package files are in
place, use the standalone flow only:

```powershell
npx skills add C:\Git\MartiXDev\skills\Skills\martix-sharepoint-spfx --list
npx skills list
```

Expect to see an installed entry named `martix-sharepoint-spfx` after a
successful install.

## Update and uninstall

### Standalone update

```powershell
npx skills check
npx skills update
```

### Standalone uninstall

```powershell
npx skills remove martix-sharepoint-spfx
npx skills rm martix-sharepoint-spfx
```

Add `-g` when removing a global standalone install.

## Discovery precedence and same-name conflicts

Copilot deduplicates by the skill `name` declared in `SKILL.md`, not by folder
path. A project or personal standalone install can load before a later package
with the same name from another source.

- A standalone `martix-sharepoint-spfx` install can shadow any later package
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
| Windows relative path is treated like a git source | The `skills` CLI interprets `.\Skills\...` as a git-like source on Windows | Use the full absolute path instead |
| On-prem guidance looks contradictory | Current SPFx docs mix Subscription Edition statements between pages | Use this package's conservative support notes and call out the ambiguity explicitly |
| Plugin marketplace install looks wrong or the package is missing | Shared repository marketplace metadata does not currently expose the SharePoint entry, or a same-name standalone install is shadowing it | Validate with the standalone flow first. If shared registration exists, remove the standalone copy or test in a clean environment |
