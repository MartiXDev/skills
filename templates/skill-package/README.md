# <Skill Display Name>

`<skill-name>` is a standalone MartiX skill for <domain>.

## Install

For normal Copilot CLI installs, use the marketplace. For standalone skill
installs, use repo-root skill selection. Use direct package paths only for local
validation or development.

```sh
copilot plugin marketplace add MartiXDev/skills # one-time: register MartiXDev/skills as a plugin source
copilot plugin install <skill-name>@martix-skills
npx skills add https://github.com/MartiXDev/skills --skill <skill-name>
```

## Package layout

| Path | Purpose |
| --- | --- |
| `SKILL.md` | Concise routing entrypoint. |
| `AGENTS.md` | Maintainer and companion-agent guidance. |
| `plugin.json` | Package identity and install metadata (for example: name, version, publisher). |
| `metadata.json` | Skill-facing metadata and descriptors (for example: title, summary, tags, capabilities). |
| `LICENSE.txt` | Required package license file. |
| `rules\` | Domain rules. |
| `references\` | Source maps and supporting references. |
| `templates\` | Authoring scaffolds. |
| `assets\` | Taxonomy and ordering data. |
| `evals\evals.json` | Trigger and quality evals. |

`plugin.json` is used for install/discovery metadata, while `metadata.json` captures skill-facing descriptors used after installation.

## Model and parallel guidance

- Use premium models for ambiguous planning and high-risk review.
- Use medium models for approved implementation.
- Use cheap models for validation and mechanical cleanup.
- Package-local work is worktree safe unless a shared file is edited.
