## Package overview

`martix-sharepoint-pnp` is the canonical standalone-first source package for the
MartiX SharePoint PnP skill. It stores the authored entrypoints, rule
library, reference maps, templates, and machine-readable taxonomy that
standalone skill installs should consume directly.

- Canonical source root: `skills\martix-sharepoint-pnp`
- Primary install surface: standalone `skills` CLI
- Secondary install surface: Copilot CLI plugin marketplace
- Discovery key: `martix-sharepoint-pnp`

## Package structure

| Path | Purpose |
| --- | --- |
| [SKILL.md](./SKILL.md) | Activation router |
| [AGENTS.md](./AGENTS.md) | Companion guide |
| [rules/](./rules) | 6 rule files across 5 domains plus support scaffolds |
| [references/](./references) | 6 reference files (source index, maps, and quick reference) |
| [templates/](./templates) | Author scaffolds |
| [assets/](./assets) | Taxonomy and ordering data |
| [metadata.json](./metadata.json) | Package metadata |
| [evals/](./evals) | Starter eval prompts for skill review |

## Maintainer notes

- The shared rule contract lives in [rules/_sections.md](./rules/_sections.md).
- The recommended workstream ordering lives in [assets/section-order.json](./assets/section-order.json).
- The domain taxonomy lives in [assets/taxonomy.json](./assets/taxonomy.json).
- The approved source boundaries and precedence rules live in [references/doc-source-index.md](./references/doc-source-index.md).
- The registration-ready inventory lives in [metadata.json](./metadata.json).
- Marketplace registration should point directly at this folder as the single source of truth when the shared marketplace metadata is updated.

## Installation

### Standalone skills CLI flow

Use the standalone flow as the primary install surface for this package.

- Official docs currently show `npx skills add <source>`.
- Official docs do **not** currently show `npx skill add <source>`.
- Because this repository stores the package under `skills\...`, prefer an absolute folder path or direct GitHub tree URL instead of repo-root discovery. In this environment, a Windows relative path such as `.\skills\martix-sharepoint-pnp` is treated like a git source by the `skills` CLI and fails preview or install.

```powershell
npx skills add C:\Git\MartiXDev\skills\skills\martix-sharepoint-pnp -a github-copilot -y
npx skills add C:\Git\MartiXDev\skills\skills\martix-sharepoint-pnp -a github-copilot --copy -y
```

To use a GitHub tree URL, use the direct path to the `martix-sharepoint-pnp`
folder in the repository.

### Copilot CLI plugin marketplace flow

Use the marketplace flow against the same standalone source package when
the shared marketplace metadata is restored. The marketplace entry should
point directly at `skills\martix-sharepoint-pnp`.

```powershell
copilot plugin marketplace add MartiXDev/skills
copilot plugin marketplace list
copilot plugin marketplace browse martix-skills
copilot plugin install martix-sharepoint-pnp@martix-skills
```

Only the following slash-command equivalents are documented in the reviewed
research, so keep marketplace browsing as a shell command for now.

```text
/plugin marketplace add MartiXDev/skills
/plugin marketplace list
/plugin install martix-sharepoint-pnp@martix-skills
/plugin marketplace remove martix-skills
```

## Verification

### Standalone validation

Preview or verify the standalone package with these commands:

```powershell
npx skills add C:\Git\MartiXDev\skills\skills\martix-sharepoint-pnp --list
npx skills list
```

Expect to see an installed entry named `martix-sharepoint-pnp` after a
successful install.

### Marketplace validation

Verify marketplace registration and plugin installation with these commands:

```powershell
copilot plugin marketplace list
copilot plugin marketplace browse martix-skills
copilot plugin list
```

## Update

```powershell
npx skills check
npx skills update
```

## Uninstall

```powershell
npx skills remove martix-sharepoint-pnp
npx skills rm martix-sharepoint-pnp
```

Add `-g` when removing a global standalone install.

## Discovery precedence and same-name conflicts

Copilot deduplicates by the skill `name` declared in `SKILL.md`, not by
folder path. A project or personal standalone install can load before a
later marketplace-delivered copy with the same name.

- A standalone `martix-sharepoint-pnp` install can shadow the marketplace version of `martix-sharepoint-pnp`.
- For marketplace validation, use a clean environment or remove the standalone copy first.
- If both surfaces must coexist, the eventual package names must stay distinct.

## Troubleshooting

### `npx skill add` fails

- Cause: The documented binary is `skills`, not `skill`.
- Solution: Use `npx skills add <source>` exactly as shown.

### Repo-root install discovery fails

- Cause: `Skills` is not a default discovery root.
- Solution: Use absolute folder path or GitHub tree URL.

### Windows relative path treated as git source

- Cause: `skills` CLI interprets `.\skills\martix-sharepoint-pnp` as a git URL on Windows.
- Solution: Use the full absolute path, e.g. `C:\Git\MartiXDev\skills\skills\martix-sharepoint-pnp`.
