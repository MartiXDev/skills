# MartiX AFK Factory plugin

`martix-afk-factory` is an installable plugin that turns any MartiX-style
repository into an autonomous dev factory with optimized model-tier costs.

Two dispatch tracks are provided:

| Track | Mechanism | AFK level |
| --- | --- | --- |
| A — Cloud | GitHub Actions → Cloud Agent REST API | Fully AFK |
| B — Local | PowerShell orchestrator → git worktrees → VS Code Agents Window | Semi-AFK |

## What the plugin installs

| Artifact | Location after install | Purpose |
| --- | --- | --- |
| 5 agent personas | `.github/agents/` | Backend, frontend, test, docs, ops roles |
| `hooks.json` | plugin root | Registers `postToolUse` validation hook |
| `validate-session.ps1` | `hooks/` | Runs repo validation after each tool use |
| `start-afk-sessions.ps1` | `hooks/` | Local worktree orchestrator |
| `agent-config.json` | plugin root (copy to `.github/`) | Label → model/agent routing |
| `afk-factory.instructions.md` | `instructions/` | File-scoped setup guidance |
| 2 prompt files | `prompts/` | Micro-task creation and session dispatch |
| 4 GitHub Actions workflows | `workflows/` | Triage, dispatch, poll, cleanup |
| 3 issue templates | `issue-templates/` | Micro-task, feature-root, hitl-decision |

## Composed skills

This plugin does not bundle standalone skills.
Install the skills appropriate to your repository:

```sh
copilot plugin install martix-dotnet-csharp@martix-skills
copilot plugin install martix-markdown@martix-skills
```

## Install

```sh
copilot plugin install martix-afk-factory@martix-skills
```

## One-time repository setup after install

**1. Create GitHub labels:**

```text
afk/ready   afk/in-progress   afk/review   afk/done   hitl
tier/cheap   tier/medium   tier/premium
area/backend   area/frontend   area/test   area/docs   area/ops
```

**2. Copy workflow and issue-template files into your repository:**

```powershell
# From your repo root, after plugin install:
Copy-Item plugins/martix-afk-factory/workflows/*.yml .github/workflows/
Copy-Item plugins/martix-afk-factory/issue-templates/*.md .github/ISSUE_TEMPLATE/
Copy-Item plugins/martix-afk-factory/agent-config.json .github/agent-config.json
Copy-Item plugins/martix-afk-factory/agents/*.agent.md .github/agents/
```

**3. Add repository secret `COPILOT_AGENT_TOKEN`** (Track A only):

Settings → Secrets → Actions → New repository secret.
Must be a **user PAT** with `copilot` scope.
`GITHUB_TOKEN` is unsupported by the cloud agent tasks API.
Requires **Copilot Business or Enterprise**.

## Usage summary

See `docs/afk-dev-factory.md` or read `instructions/afk-factory.instructions.md`
for the full workflow guide.

## Model and parallel guidance

| Work | Tier |
| --- | --- |
| Routing config, label schema, agent-config.json | `premium` |
| Agent authoring, prompt writing, workflow updates | `medium` |
| Issue triage, label sync, hook execution | `cheap` |

Agent persona files are package-local and worktree-safe.
`agent-config.json` is a shared coordinator file — edit it on `main` only.
