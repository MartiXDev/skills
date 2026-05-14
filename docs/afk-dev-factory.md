# AFK Dev Factory

End-to-end guide for the autonomous agent workflows implemented in this repository.
Two tracks are available: **Track A** (cloud agents via GitHub Actions) and
**Track B** (local Copilot CLI sessions via git worktrees).

---

## Prerequisites

### One-time repository setup

**1. Create GitHub labels.**
Every workflow and the local orchestrator depend on these label names being present
in the repository. Create them at `github.com/<owner>/skills/labels`.

| Group | Labels |
| --- | --- |
| AFK state | `afk/ready` `afk/in-progress` `afk/review` `afk/done` |
| Human-in-the-loop | `hitl` |
| Tier (cost) | `tier/cheap` `tier/medium` `tier/premium` |
| Area (agent) | `area/backend` `area/frontend` `area/test` `area/docs` `area/ops` |

**2. Add the `COPILOT_AGENT_TOKEN` secret (Track A only).**
Go to `Settings → Secrets → Actions → New repository secret`.
The value must be a **user Personal Access Token** with the `copilot` scope.
`GITHUB_TOKEN` is a server-to-server installation token and is explicitly rejected
by the GitHub cloud agent tasks API.
A **Copilot Business or Enterprise** subscription is required for the API.

**3. Install local tools (Track B only).**

```powershell
gh auth login          # GitHub CLI
git --version          # git ≥ 2.38 (worktree support)
code --version         # VS Code with Copilot extension
```

---

## Key files

| File | Role |
| --- | --- |
| [.github/agent-config.json](../.github/agent-config.json) | Single source of truth. Maps `tier/*` labels → model names, `area/*` labels → `.agent.md` files, and lists shared coordinator files. |
| [.github/agents/*.agent.md](../.github/agents/) | Custom agent personas. Each declares its scope, file boundaries, and escalation rules. |
| [.github/ISSUE_TEMPLATE/micro-task.md](../.github/ISSUE_TEMPLATE/micro-task.md) | Issue template for AFK-dispatchable work. |
| [.github/ISSUE_TEMPLATE/feature-root.md](../.github/ISSUE_TEMPLATE/feature-root.md) | Parent issue for feature branches. Carries `hitl` — never dispatched automatically. |
| [.github/ISSUE_TEMPLATE/hitl-decision.md](../.github/ISSUE_TEMPLATE/hitl-decision.md) | Architecture or planning decision requiring human input before agent work can begin. |
| [.github/workflows/triage.yml](../.github/workflows/triage.yml) | Validates micro-task issues and adds `afk/ready` when all conditions pass. |
| [.github/workflows/dispatch-agent.yml](../.github/workflows/dispatch-agent.yml) | Track A — dispatches `afk/ready` issues to the cloud agent REST API. |
| [.github/workflows/poll-agent.yml](../.github/workflows/poll-agent.yml) | Track A — polls in-progress cloud tasks every 15 minutes and updates labels. |
| [.github/workflows/cleanup-merged.yml](../.github/workflows/cleanup-merged.yml) | Closes the linked issue and applies `afk/done` when a `fix/issue-N` PR is merged. |
| [scripts/start-afk-sessions.ps1](../scripts/start-afk-sessions.ps1) | Track B — local orchestrator. Creates worktrees and opens VS Code per issue. |
| [.github/hooks/hooks.json](../.github/hooks/hooks.json) | Copilot CLI hook config. Runs the validation hook after each tool use. |
| [.github/hooks/validate-session.ps1](../.github/hooks/validate-session.ps1) | Hook script. Runs `scripts/validate-repository.ps1` and surfaces failures to the agent. |

---

## Track A — Cloud agents (fully AFK)

```text
Issue created → triage.yml validates → afk/ready added
  → dispatch-agent.yml posts to cloud API → afk/in-progress added
  → poll-agent.yml checks every 15 min
  → completed: afk/review added, PR link posted
  → PR merged: cleanup-merged.yml adds afk/done, closes issue
```

### Step 1 — Create a micro-task issue

Use the **Micro-task (AFK)** issue template. All fields are required.

| Field | Rule |
| --- | --- |
| Title | One line, action-oriented |
| Acceptance criteria | ≤ 3 bullets, each independently verifiable |
| Relevant file paths | ≤ 3 paths, only files the agent must read or modify |
| Labels | At least one `tier/*` and one `area/*` label |
| `agent-prompt` block | Replace the placeholder with a concise prompt ≤ 400 characters |

The `<!-- agent-prompt … -->` HTML comment block is extracted verbatim by
`dispatch-agent.yml` and sent as the task prompt to the cloud agent.
Keep it self-contained — the agent receives only this text plus its `.agent.md`.

### Step 2 — Choose tier and area labels

**Tier** controls model cost:

| Label | Model | Use for |
| --- | --- | --- |
| `tier/cheap` | gpt-4o-mini | Formatting, link checks, simple README sync, template application |
| `tier/medium` | gpt-4.1 | Package implementation, eval authoring, focused review |
| `tier/premium` | claude-opus-4 | Planning, ambiguous architecture, security-sensitive review |

**Area** selects the agent persona:

| Label | Agent | Scope |
| --- | --- | --- |
| `area/backend` | backend.agent.md | Skill packages, plugin bundles, rules, templates, metadata |
| `area/frontend` | frontend.agent.md | README files, user-facing markdown |
| `area/test` | test.agent.md | Evals, eval schemas, test coverage |
| `area/docs` | docs.agent.md | Architecture docs, strategy docs under `docs/` |
| `area/ops` | ops.agent.md | Workflows, validation scripts, hooks, scaffolding |

### Step 3 — Monitor from GitHub

Once dispatched, the issue comment contains the cloud agent task ID.
The `poll-agent.yml` workflow checks status every 15 minutes.
You can also watch from `github.com/mobile` using `/remote on` in a local session.

Terminal states the poller handles:

| State | Action |
| --- | --- |
| `completed` | Removes `afk/in-progress`, adds `afk/review`, posts PR link |
| `failed` / `timed_out` / `cancelled` | Removes `afk/in-progress`, adds `hitl`, posts explanation |
| `waiting_for_user` | Removes `afk/in-progress`, adds `hitl`, posts explanation |

### Step 4 — Review and merge

Open the PR linked in the issue comment. The branch is named `fix/issue-<N>`.
Merging it triggers `cleanup-merged.yml` which closes the issue and adds `afk/done`.

---

## Track B — Local sessions (semi-AFK)

Copilot CLI is an interactive tool — it cannot be started headlessly.
Track B automates everything up to opening VS Code at the isolated worktree;
you then start the CLI session from the **Agents Window**.

### Run the orchestrator

```powershell
# Start up to 3 sessions (default)
.\scripts\start-afk-sessions.ps1

# Start up to 5 sessions
.\scripts\start-afk-sessions.ps1 -MaxSessions 5

# Preview what would happen without making changes
.\scripts\start-afk-sessions.ps1 -DryRun

# Check current session state
.\scripts\start-afk-sessions.ps1 -Monitor
```

The orchestrator:

1. Reads `.github/agent-config.json`.
2. Fetches issues labeled `afk/ready` via the `gh` CLI.
3. Validates each issue (tier label, area label, filled prompt block).
4. Checks whether any touched file is a shared coordinator file — if so, escalates to `hitl`.
5. Creates a git worktree at `.worktrees/<issue-number>` on branch `fix/issue-<N>`.
6. Writes a `COPILOT_START.md` into the worktree with the task prompt.
7. Transitions the issue from `afk/ready` to `afk/in-progress`.
8. Opens VS Code at the worktree path.
9. Records the session in `.worktrees/sessions.json`.

### Start the Copilot CLI session

In the VS Code window that opens at the worktree:

1. Open the **Agents** view (sidebar).
2. Start a new session — the agent reads `COPILOT_START.md` automatically.
3. Run `/remote on` to enable monitoring from `github.com/mobile`.

The post-tool-use hook (`.github/hooks/validate-session.ps1`) runs
`scripts/validate-repository.ps1` after every tool call and surfaces failures
in the session output so the agent can self-correct without aborting.

---

## Shared coordinator files

The files below are owned by the repository coordinator and must **not** be
edited by parallel agent sessions. The orchestrator script and agent instructions
both enforce this by escalating to `hitl` when a task touches them.

```text
.github/plugin/marketplace.json
README.md
skills/README.md
plugins/README.md
docs/repo-overview.md
docs/plugin-layout.yaml
docs/execution-profiles.md
docs/llm-routing-strategy.md
scripts/validate-repository.ps1
templates/
```

To change what counts as a shared file, edit the `sharedFiles` array in
`.github/agent-config.json`.

---

## Adding a new area

1. Create `.github/agents/<name>.agent.md` following the pattern of the existing files.
2. Add an entry to the `areas` object in `.github/agent-config.json`.
3. Create the `area/<name>` label in the repository.
4. No workflow changes are required — `dispatch-agent.yml` reads the config at runtime.

## Changing a model

Edit only `.github/agent-config.json`. The model names must be literal strings
accepted by the cloud agent tasks API. Do not use MartiX tier aliases here.

---

## Related docs

- [docs/execution-profiles.md](execution-profiles.md) — AFK/HITL definitions, tier budget, parallel safety
- [docs/llm-routing-strategy.md](llm-routing-strategy.md) — routing policy and anti-patterns
- [docs/parallel-worktree-guidance.md](parallel-worktree-guidance.md) — coordinator file rules
- [docs/repo-overview.md](repo-overview.md) — overall repository architecture
