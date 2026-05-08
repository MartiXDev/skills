# Package overview

`martix-tunit` is the canonical standalone-first source package for the
MartiX TUnit skill. It stores the authored entrypoints, rule library,
reference maps, templates, and machine-readable taxonomy that standalone skill
installs should consume directly.

- Canonical source root: `src\skills\martix-tunit`
- Primary install surface: standalone `skills` CLI
- Secondary install surface: Copilot CLI plugin marketplace
- Discovery key: `martix-tunit`

## Package structure

| Path | Purpose |
| --- | --- |
| [SKILL.md](./SKILL.md) | Activation router |
| [AGENTS.md](./AGENTS.md) | Companion guide |
| [rules/](./rules) | 15 rule files across 7 domains plus support scaffolds |
| [references/](./references) | 10 reference files (domain maps, attribute matrix, cookbook, seed-skill harvest memo) |
| [templates/](./templates) | Author scaffolds |
| [assets/](./assets) | Taxonomy data |
| [metadata.json](./metadata.json) | Package metadata |

## Maintainer notes

- The shared rule contract lives in
  [rules/_sections.md](./rules/_sections.md).
- The recommended workstream ordering lives in
  [assets/section-order.json](./assets/section-order.json).
- The domain taxonomy lives in
  [assets/taxonomy.json](./assets/taxonomy.json).
- The approved source boundaries and precedence rules live in
  [references/doc-source-index.md](./references/doc-source-index.md).
- The registration-ready inventory lives in
  [metadata.json](./metadata.json).
- Marketplace registration points directly at this folder as the single source of
  truth.

## Installation

## Standalone skills CLI flow

Use the standalone flow as the primary install surface for this package.

- Official docs currently show `npx skills add <source>`.
- Official docs do **not** currently show `npx skill add <source>`.
- Because this repository stores the package under `src\skills\...`, prefer an
  absolute folder path or direct GitHub tree URL instead of repo-root
  discovery. In this environment, a Windows relative path such as
  `.\src\skills\martix-tunit` is treated like a git source by the `skills` CLI
  and fails preview or install.

```powershell
npx skills add C:\Git\MartiXDev\ai-marketplace\src\skills\martix-tunit -a github-copilot -y
npx skills add C:\Git\MartiXDev\ai-marketplace\src\skills\martix-tunit -a github-copilot --copy -y

# Or from GitHub:
# npx skills add <github-tree-url> -a github-copilot -y
```

To use a GitHub tree URL, use the direct path to the `martix-tunit`
folder in the repository.

## Copilot CLI plugin marketplace flow

Use the marketplace flow against the same standalone source package. The
marketplace entry points directly at `src\skills\martix-tunit`.

```powershell
copilot plugin marketplace add MartiXDev/ai-marketplace
copilot plugin marketplace list
copilot plugin marketplace browse martix-ai-marketplace
copilot plugin install martix-tunit@martix-ai-marketplace
```

Only the following slash-command equivalents are documented in the reviewed
research, so keep marketplace browsing as a shell command for now.

```text
/plugin marketplace add MartiXDev/ai-marketplace
/plugin marketplace list
/plugin install martix-tunit@martix-ai-marketplace
/plugin marketplace remove martix-ai-marketplace
```

## Verification

## Standalone validation

Preview or verify the standalone package with these commands:

```powershell
npx skills add C:\Git\MartiXDev\ai-marketplace\src\skills\martix-tunit --list
npx skills list
```

Expect to see an installed entry named `martix-tunit` after a
successful install.

## Marketplace validation

Verify marketplace registration and plugin installation with these commands:

```powershell
copilot plugin marketplace list
copilot plugin marketplace browse martix-ai-marketplace
copilot plugin list
```

## Update

```powershell
npx skills check
npx skills update
```

## Uninstall

```powershell
npx skills remove martix-tunit
npx skills rm martix-tunit
```

Add `-g` when removing a global standalone install.

## Discovery precedence and same-name conflicts

Copilot deduplicates by the skill `name` declared in `SKILL.md`, not by folder
path. A project or personal standalone install can load before a later
marketplace-delivered copy with the same name.

- A standalone `martix-tunit` install can shadow the marketplace version of
  `martix-tunit`.
- For marketplace validation, use a clean environment or remove the standalone
  copy first.
- If both surfaces must coexist, the eventual package names must stay distinct.

## Troubleshooting

### `npx skill add` fails

- Cause: The documented binary is `skills`, not `skill`
- Solution: Use `npx skills add <source>` exactly as shown

### Repo-root install discovery fails

- Cause: `src\skills` is not a default discovery root
- Solution: Use absolute folder path or GitHub tree URL

### Windows relative path treated as git source

- Cause: `skills` CLI interprets `.\src\skills\...` as a git URL on Windows
- Solution: Use the full absolute path, e.g.
  `C:\Git\MartiXDev\ai-marketplace\src\skills\martix-tunit`

### Standalone install linked instead of copied

- Cause: `skills` CLI uses symlink installs by default
- Solution: Re-run with `--copy` for copied layout

### Skill updates missing after marketplace work

- Cause: Same-name standalone install takes precedence
- Solution: Remove standalone copy or use clean environment
