# martix-git Plugin Plan

<!-- markdownlint-disable MD013 -->

> **Research date**: 2026-07-22
>
> **Status**: Implementation-ready proposal. Supersedes the narrower
> `sandcastle-aligned-plugin-plan.md` conceptually; that document remains
> unmodified for audit purposes.
>
> **Observed lifecycle update**: Archiving Copilot app sessions may deregister
> their clean worktrees and remove the directories. It may leave an empty
> directory, and it does not delete the associated local branches. The plugin
> therefore reconciles external lifecycle changes instead of assuming it owns
> every cleanup transition.

---

## Executive decision

**Yes — replace the proposed `martix-git-worktree-maintenance` plugin with a
broader `martix-git` plugin.** The worktree-maintenance proposal was one slice
of a workflow the user repeats daily: branching, committing conventionally,
creating pull requests, managing worktrees, and running pre-commit checks. A
single plugin owns the lifecycle hooks, prompts, and agent assets that compose
these operations into safe automation, while a new standalone
`skills/martix-conventional-commit` owns the reusable domain knowledge that any
plugin or skill can invoke.

Key rationale:

1. The user's workflow spans branch -> commit -> PR -> cleanup in a single session
   and crosses multiple tool owners (Git, GitHub CLI, Sandcastle, VS Code). A
   plugin is the correct artifact because it bundles hooks, prompts,
   instructions, and an agent around a shared session lifecycle.
2. The Conventional Commits specification is domain knowledge useful in many
   project families. Repository rules require standalone skills for reusable
   domain knowledge. Therefore `martix-conventional-commit` is standalone; the
   plugin depends on it.
3. Native Git hooks enforce local commit policy across VS Code, Copilot CLI,
  Sandcastle, terminals, and Git GUIs. Agent hooks add Copilot-specific
  guardrails but do not replace Git hooks.
4. The worktree maintenance engine remains the highest-risk module and ships
  first as report-only, consistent with the preceding plan.
5. Scope is bounded by an explicit product boundary and non-goals (below).

---

## Artifact-boundary decision: Conventional Commits

### Decision: standalone skill + plugin composition

| Option | Verdict | Reason |
| --- | --- | --- |
| (a) Standalone `skills/martix-conventional-commit` | **Selected** | Reusable across plugin contexts. Repository rules demand standalone for domain knowledge. |
| (b) Plugin-local skill in `plugins/martix-git/skills/` | Rejected | Violates reusability rule; other plugins could not invoke it. |
| (c) Instructions/prompts only | Rejected | Too shallow — conventional commits deserve rules, validation examples, scope vocabulary, footer conventions, and eval scenarios. |

The standalone skill:

- Codifies the [Conventional Commits 1.0.0 specification](https://www.conventionalcommits.org/en/v1.0.0/) as rules and examples.
- Provides MartiX-owned routing so the user need not depend on the externally
  installed `/conventional-commit` skill.
- Does **not** copy any third-party skill text. It references the upstream
  specification directly and provides its own original guidance.

The plugin's commit prompt uses the standalone skill when the runtime has
installed and activated it. Prompt frontmatter must not claim a skill dependency
mechanism unless the target runtime documents one.

### Dependency and installation

```sh
# Install the standalone skill (works alone or with the plugin)
npx skills add https://github.com/MartiXDev/skills --skill martix-conventional-commit

# Install the plugin
copilot plugin install martix-git@martix-skills
```

The plugin README documents the companion skill. Installation does not
auto-install standalone skills unless a future verified plugin manifest contract
adds that capability, so the user currently installs both. The plugin prompt
must still explain its required output contract and fail clearly when the skill
is unavailable; it must not silently copy the standalone rule library.

---

## Product boundary

### In scope (capability modules)

| Module | Deterministic | Model-guided | Delivery phase |
| --- | --- | --- | --- |
| **Commit** - conventional commit message generation | Specification and repository-policy validation | Scope/type selection, body generation | Phase 1 |
| **Branch** - safe branch creation and switching | `git check-ref-format`, repository policy | Naming suggestion | Phase 1 |
| **Local gates** - native Git hook setup | Hook installation and configured project checks | Setup guidance only | Phase 2 |
| **Pull request** - PR creation and description | `gh pr create` orchestration | Title/body drafting | Phase 2 |
| **Worktree** - lifecycle audit, reconciliation, and cleanup | Report engine, state machine | Result explanation only | Phase 3 |
| **GitHub** - remote state queries | `gh` CLI wrapper | PR/issue summary | Phase 3 |
| **Copilot guardrails** - agent tool policy | Structured hook input checks | None | Phase 3 |

### Non-goals (explicit exclusions)

- **Replacement of Git**: the plugin calls Git, never reimplements it.
- **Replacement of `gh` CLI**: composition, not replacement.
- **Replacement of Sandcastle**: the plugin never creates, closes, or manages
  Sandcastle worktrees/sandboxes. It only reads evidence.
- **Replacement of native Git hooks, Husky, lint-staged, or commitlint**: the
  plugin configures or composes with the appropriate repository tool.
- **General CI/CD pipeline management**: the plugin may scaffold a narrow
  commit-policy check because local hooks can be bypassed, but does not own
  deployment or general CI pipelines.
- **Multi-repo management**: one repository at a time.
- **Interactive rebase UI**: too complex, too risky.
- **Age-based or heuristic-based automatic deletion**: never.

### When a capability should remain external

A capability stays external when:

- It is owned by another tool's contract (Sandcastle lifecycle, VS Code session
  linking, Husky hook execution).
- It is useful to non-Git/non-GitHub contexts (Markdown linting, .NET testing).
- It would require reimplementing behavior that a CLI already provides reliably
  (`git`, `gh`, `husky`).

---

## User journeys

### J1: Conventional commit (daily, HITL)

1. User makes changes, stages files.
2. Invokes `/commit` prompt or an agent suggests a commit.
3. Plugin reads `git diff --cached` and requests
  `martix-conventional-commit` guidance when that skill is installed.
4. User confirms or edits the message.
5. Plugin writes the reviewed message to a temporary file and invokes
  `git commit --file <path>`, preserving body and footer structure without
  shell interpolation.

### J2: Feature branch + PR (daily, HITL)

1. User describes feature intent.
2. `/branch` prompt suggests a branch name, creates it.
3. User works, commits (J1 repeats).
4. `/pr` prompt drafts a PR title/body from commit log, calls
  `gh pr create --draft --body-file <path>` after user review.
5. User reviews and publishes.

### J3: Worktree audit (weekly, report-only)

1. User invokes `/audit-worktrees` or a `Stop` hook fires a bounded report.
2. Report engine enumerates registered worktrees and local branches, then
  reconciles worktrees removed externally since the previous observation.
3. The report distinguishes registered worktrees, branches left unattached by
  client cleanup, and empty orphan directories under configured roots.
4. User optionally selects candidates for cleanup with confirmation.

### J4: Pre-commit quality gate (automatic, every commit)

1. A repository-native `pre-commit` hook runs configured staged-file or project
  checks regardless of which client invokes Git.
2. A repository-native `commit-msg` hook validates the proposed message.
3. A repository-native `pre-push` hook may run a bounded verification command.
4. CI repeats required policy because local Git hooks can be bypassed with
  `--no-verify` or changed locally.

---

## Proposed package layout

### Plugin: `plugins/martix-git/`

```text
plugins/martix-git/
├── plugin.json
├── hooks.json
├── README.md
├── hooks/
│   ├── README.md
│   ├── inspect-git-worktrees.ps1
│   ├── copilot-git-guard.ps1
│   └── session-stop-report.ps1
├── instructions/
│   ├── README.md
│   └── git-workflow.instructions.md
├── prompts/
│   ├── README.md
│   ├── commit.prompt.md
│   ├── branch.prompt.md
│   ├── pr.prompt.md
│   ├── setup-git-policy.prompt.md
│   └── audit-worktrees.prompt.md
├── templates/
│   └── policy/
│       ├── commitlint.config.mjs
│       └── commit-policy.yml
└── tests/
    ├── fixtures/
    │   ├── normal-merge-repo/
    │   ├── squash-merge-repo/
    │   ├── locked-worktree/
    │   ├── dirty-worktree/
    │   └── unicode-paths/
    ├── inspect-git-worktrees.Tests.ps1
    └── copilot-git-guard.Tests.ps1
```

### Standalone skill: `skills/martix-conventional-commit/`

```text
skills/martix-conventional-commit/
├── plugin.json
├── metadata.json
├── README.md
├── SKILL.md
├── AGENTS.md
├── rules/
│   ├── commit-types.md
│   ├── scope-conventions.md
│   └── breaking-changes.md
├── references/
│   └── specification-map.md
├── templates/
│   └── commit-message.md
├── assets/
│   ├── taxonomy.json
│   └── section-order.json
└── evals/
    └── evals.json
```

---

## Target plugin manifest

Phase 1 omits `hooks` because no runtime hook has been validated yet. Add the
field below only when Phase 3 supplies a tested `hooks.json`.

```jsonc
// plugins/martix-git/plugin.json
{
  "name": "martix-git",
  "description": "Git and GitHub workflow automation plugin. Provides conventional commits, branch management, PR creation, worktree maintenance, and pre-commit quality gates for Copilot CLI and VS Code agent sessions.",
  "version": "0.1.0",
  "author": { "name": "MartiXDev" },
  "license": "MIT",
  "keywords": [
    "martix", "git", "github", "conventional-commits", "worktree",
    "pull-request", "branch", "pre-commit", "hooks", "automation"
  ],
  "repository": "https://github.com/MartiXDev/skills",
  "hooks": "hooks.json"
}
```

Do not add undocumented manifest fields. Add an agent only after prompts prove
insufficient for a distinct, recurring coordination role.

## Hook configuration

```jsonc
// plugins/martix-git/hooks.json
{
  "version": 1,
  "hooks": {
    "stop": [
      {
        "type": "command",
        "powershell": "pwsh -NoProfile -File hooks/session-stop-report.ps1",
        "timeoutSec": 30
      }
    ]
  }
}
```

This is the Copilot CLI plugin form: lower-camel event names, `powershell`, and
`timeoutSec`. VS Code documents conversion to its PascalCase event names and
Windows command field. The package must test both clients before shipping this
hook; until then, omit `hooks.json` from version 1.

An optional `PreToolUse` agent hook may deny or ask for confirmation on a small
set of unambiguously destructive Copilot tool calls. It is not a pre-commit
quality gate: VS Code currently ignores hook matchers, tool names and input
shapes differ by runtime, and agent hooks do not cover commits made outside the
agent. Quality enforcement belongs in native Git hooks and CI.

---

## Command / prompt / hook matrix

| Asset | Event/Trigger | Input | Output | Deterministic? |
| --- | --- | --- | --- | --- |
| `commit.prompt.md` | User invokes `/commit` | Staged diff | Commit message + `git commit` | Hybrid: validation is deterministic, message generation is model-guided |
| `branch.prompt.md` | User invokes `/branch` | Intent description | Branch name + `git switch -c` | Hybrid |
| `pr.prompt.md` | User invokes `/pr` | Commit log, branch | PR title/body + `gh pr create` | Hybrid |
| `audit-worktrees.prompt.md` | User invokes `/audit-worktrees` | Repository path | Worktree report | Deterministic engine, model presents results |
| `session-stop-report.ps1` | `Stop` hook event | Session JSON stdin | Console warning or no-op | Fully deterministic |
| `setup-git-policy.prompt.md` | User invokes setup | Project stack and policy choices | Native hooks and CI configuration | Hybrid setup; generated enforcement is deterministic |
| `copilot-git-guard.ps1` | `PreToolUse` (opt-in) | Documented tool input JSON | Allow, ask, or deny | Fully deterministic and runtime-specific |
| `inspect-git-worktrees.ps1` | Script (also called by prompt/hook) | `-RepositoryPath`, `-Format` | Structured report | Fully deterministic |

---

## Configuration schema

```jsonc
// .martix-git.json (workspace root, optional)
{
  "$schema": "https://raw.githubusercontent.com/MartiXDev/skills/main/plugins/martix-git/schema.json",
  "conventionalCommit": {
    "types": ["feat", "fix", "docs", "style", "refactor", "perf", "test", "build", "ci", "chore", "revert"],
    "scopes": [],                    // empty = freeform; non-empty = enforced
    "requireScope": false,
    "maxHeaderLength": 72
  },
  "branch": {
    "prefixes": ["feature/", "fix/", "chore/", "docs/"],
    "separator": "/",
    "maxLength": 60
  },
  "preCommit": {
    "enabled": false,                // opt-in
    "checks": ["lint", "typecheck"],
    "timeout": 60
  },
  "worktree": {
    "enableRemoteEvidence": false,   // gh CLI queries
    "reportOnSessionStop": true,
    "protectedBranches": ["@default"], // resolve from remote/repository evidence
    "scanRoots": []                  // explicit roots for report-only orphan detection
  },
  "pullRequest": {
    "defaultDraft": true,
    "bodyFromCommits": true
  }
}
```

**Defaults**: report-only, no destructive actions, no network queries unless
explicitly enabled.

The type list, lowercase preference, imperative style, and 72-character limit
are MartiX repository policy, not requirements of Conventional Commits 1.0.0.
The specification requires the structural prefix and reserves semantic release
meaning for `feat`, `fix`, and breaking changes while allowing other types.

---

## Ownership model

### Git

Owns repository state, worktree list, branch graph, commit history, lock files.
The plugin **reads** via `git` commands with argument arrays (never interpolated
shell strings). It **writes** only through explicit user-confirmed commands.

### GitHub (remote)

Owns PR state, branch protection rules, merge evidence. The plugin queries via
`gh` CLI when `enableRemoteEvidence` is true and `gh auth status` succeeds.
Degrades gracefully to `unknown` classification when unavailable.

### Sandcastle

Owns the worktree and sandbox handles it creates. Positive evidence is a live
handle known to the caller, a recorded lifecycle result, or
`CloseResult.preservedWorktreePath`. Directory location and branch naming are
not ownership evidence. Without an explicit adapter record, the plugin
classifies the owner as `unknown` and does not remove the worktree.

Source: [Sandcastle `CloseResult` interface](https://github.com/mattpocock/sandcastle/blob/main/src/createSandbox.ts#L218-L221),
[`createWorktree` split ownership](https://github.com/mattpocock/sandcastle/blob/main/README.md#L471-L475).

### VS Code / Copilot

Owns linked agent sessions and may clean up their worktrees when sessions are
archived. In the observed 2026-07-22 behavior, the Copilot app deregistered four
clean worktrees, deleted three directories, left one empty directory, and
preserved all associated local branches. It also left unrelated dirty Codex
worktrees untouched.

This is observed behavior, not a stable API contract. The plugin does not track
Copilot sessions itself, infer ownership from an open window or process, or
attempt to race the client cleanup. Each audit treats `git worktree list
--porcelain -z` as authoritative for current registrations and independently
classifies branches that remain after external worktree removal.

### Plugin (`martix-git`)

May only remove worktrees it explicitly confirmed as safe candidates with
operator confirmation during that invocation. Version 1 creates no worktrees.
It must tolerate a candidate disappearing between inspection and application:
an already-absent registration is a reconciled no-op, not an error and not
permission to delete the associated branch.

### Orphan directories

An unregistered directory beneath an explicitly configured `scanRoots` entry
is reported separately from Git worktrees. Path location is not ownership
evidence. The plugin does not remove a non-empty directory, a reparse point, or
a directory containing a `.git` entry. An empty ordinary directory may be
offered for explicit operator-confirmed removal, but never from a hook or an
automatic path.

### Unknown

When no positive ownership evidence exists, owner is `unknown` and no removal
is permitted.

---

## Security and safety

### Shell injection

All Git and GitHub CLI invocations use **argument arrays**, never string
interpolation with branch names, commit messages, or PR titles from untrusted
sources. PowerShell uses direct invocation such as `& git @arguments` and checks
both exit status and output; it avoids `Invoke-Expression` and quoting-prone
reconstruction of one shell command string.

### Untrusted text

Branch names, commit messages, issue titles, and PR bodies may contain
attacker-controlled text. The plugin:

- Never passes them through `Invoke-Expression` or shell expansion.
- Removes or visibly escapes terminal control sequences before display, then
  applies bounded output limits.
- Validates candidate branch names with `git check-ref-format --branch` and
  applies configured prefixes as a separate repository policy.

### Hook permissions

Hooks run with the same permissions as VS Code
([VS Code hook security](https://code.visualstudio.com/docs/copilot/customization/hooks#_security-considerations)).
The plugin:

- Ships hooks as read-only scripts; does not self-modify.
- Documents that `chat.tools.edits.autoApprove` should exclude hook scripts.

### Secrets

No secrets are read, stored, or transmitted by the plugin. `gh auth status` is
the only authentication check; credentials are managed by `gh`.

### TOCTOU (time-of-check-time-of-use)

The worktree engine **re-reads state immediately before every mutation**. A
candidate classified as safe at inspection time must still be safe at apply
time. `SupportsShouldProcess` provides `-WhatIf` and confirmation semantics;
explicit implementation and tests provide the separate re-validation gate.
External clients may remove registrations and directories at any time. If a
candidate is already absent, the engine records `ReconciledExternalRemoval`
and continues without deleting its branch. Branch deletion requires a fresh,
independent merge and attachment decision after reconciliation.

### Protected states (unconditional)

- Main worktree identified from Git's worktree inventory
- Current worktree resolved from the invocation repository and worktree root
- Dirty worktree (uncommitted changes)
- Locked worktree (`git worktree lock`)
- Detached HEAD without explicit review
- Active/externally owned worktree
- Unknown owner
- Branch with open pull request
- Branch with ambiguous squash/rebase merge evidence
- Non-empty, reparse-point, or Git-bearing orphan directory

### Destructive operations

- `--force` is **never** used in hooks or automatic paths.
- A runtime-tested `PreToolUse` hook may deny a clearly parsed force push from
  Copilot. Server-side GitHub branch protection remains the authoritative
  control because local and agent hooks can be bypassed.
- The plugin does not expose wrappers for `git reset --hard`, `git clean -fd`,
  or general force deletion. Its own supported cleanup mutations require
  `ShouldProcess` and explicit candidate selection.
- Cleanup operations default to `-WhatIf` mode.

### Fail-open vs. fail-closed

| Context | Policy |
| --- | --- |
| Native Git hooks | **Fail-closed locally** when configured checks fail; document `--no-verify` bypass |
| CI commit-policy check | **Fail-closed** for the required branch protection check |
| Copilot agent guard | **Fail-closed only for positively matched high-risk operations; otherwise ask or warn** |
| Worktree cleanup | **Fail-open** (unknown → do nothing, report) |
| Session-stop report | **Fail-open** (errors → silent, no block) |
| Branch validation | **Fail-closed** (invalid name → refuse) |
| Network/auth absence | **Fail-open** (classify as `unknown`, continue) |

### Windows / PowerShell

Mutation-capable maintenance scripts target PowerShell 7+ and use
`CmdletBinding(SupportsShouldProcess)`. Read-only hook scripts do not claim
`ShouldProcess` semantics they cannot use.
Platform-specific hook entries use the `windows` property per
[VS Code OS-specific commands](https://code.visualstudio.com/docs/copilot/customization/hooks#_os-specific-commands).

---

## Deterministic vs. model-guided separation

| Layer | Responsibility | Enforced by |
| --- | --- | --- |
| **Hooks / scripts** | Parse Git output, classify state, invoke Git validation, block positively matched unsafe agent operations | PowerShell scripts with Pester tests |
| **Skills** | Conventional commit type selection, scope suggestion, PR body drafting, branch naming | `SKILL.md` rules and examples |
| **Prompts** | Orchestrate user interaction, compose skill + script | Prompt frontmatter, tool declarations |
| **Native Git hooks and CI** | Enforce repository checks and message policy across clients | Repository-selected tools such as Husky, lint-staged, and commitlint |

The model is **never** used for:

- Parsing `git worktree list --porcelain`
- Validating conventional commit structure and repository policy
- Deciding whether a worktree is dirty (`git status --porcelain`)
- Running lint/typecheck commands

---

## Phased implementation plan

### Phase 0: Prerequisites

- [ ] Remove `martix-afk-factory` in a separate change (already planned).
- [ ] Create `skills/martix-conventional-commit/` from template with `SKILL.md`,
      rules, evals.
- [ ] Validate standalone skill passes repository validation.

**Acceptance**: `martix-conventional-commit` is installable independently and
triggers correctly on commit-related prompts.

### Phase 1: Core plugin + commit + branch

- [ ] Create `plugins/martix-git/` scaffold with manifest, README, prompts, and
  instructions. Add `hooks.json` only for a validated runtime hook.
- [ ] Implement `commit.prompt.md` composing with the standalone skill.
- [ ] Implement `branch.prompt.md` with name validation.
- [ ] Add `git-workflow.instructions.md` with session-level Git safety rules.
- [ ] Add a versioned configuration schema (`.martix-git.json`) and reject
  unknown schema versions.
- [ ] Write fixture tests for branch name validation.

**Acceptance**: User can invoke `/commit` and `/branch` with safe, conventional
results. No destructive operations possible.

### Phase 2: Native Git policy + PR

- [ ] Implement `setup-git-policy.prompt.md` to detect the project stack and
  propose repository-owned native Git hooks.
- [ ] Use `pre-commit` for bounded staged/project checks, `commit-msg` for
  commit-message validation, and optional `pre-push` for bounded checks.
- [ ] Prefer existing repository tooling. For Node projects, compose with
  Husky, lint-staged, and commitlint rather than reimplementing them.
- [ ] Add an optional CI commit-policy check and document required-check setup.
- [ ] Implement `pr.prompt.md` with `gh pr create` orchestration.
- [ ] Add configuration for pre-commit checks and PR defaults.
- [ ] Test hook installation, `--no-verify` behavior, partially staged files,
  spaces and Unicode paths, and CI parity.

**Acceptance**: Native hooks apply from terminal and GUI clients, CI catches a
bypassed local hook, and the PR prompt creates a reviewed draft PR.

### Phase 3: Worktree maintenance + session hook

- [ ] Port `inspect-git-worktrees.ps1` from the previous plan's specification.
- [ ] Implement NUL-safe parser, state classifier, protected-state checks.
- [ ] Reconcile externally removed registrations without treating them as
  failures or implicitly deleting their branches.
- [ ] Classify branches left unattached after client cleanup independently from
  the removed worktree.
- [ ] Add report-only orphan scanning for explicit `scanRoots`; only empty,
  ordinary directories may enter an operator-confirmed removal path.
- [ ] Add `audit-worktrees.prompt.md` for guided cleanup.
- [ ] Add `session-stop-report.ps1` as advisory `Stop` hook.
- [ ] Add `SupportsShouldProcess` + `-Apply` path with per-item confirmation.
- [ ] Add Pester tests for all classification states.

**Acceptance**: Report engine audits correctly, hook only reports, apply path
requires explicit confirmation for each candidate.

### Phase 4: Runtime-specific guardrails + optional adapters

- [ ] Add `copilot-git-guard.ps1` only after recording and testing the target
  runtime's actual tool names and input schema.
- [ ] Add an optional Sandcastle evidence adapter based on explicit retained
  path records, never path inference.
- [ ] Register in marketplace metadata.

**Acceptance**: Guardrails deny only covered dangerous operations without false
positives, explicit Sandcastle records enrich classification, and the plugin is
installable from the marketplace.

---

## Migration from `martix-afk-factory`

| AFK Factory asset | Disposition |
| --- | --- |
| `hooks/validate-session.ps1` | Retire; reimplement only verified generic behavior with tests |
| `hooks/start-afk-sessions.ps1` | Retire (orchestration is external) |
| `prompts/start-afk-session.prompt.md` | Retire |
| `prompts/create-micro-task.prompt.md` | Retire (issue creation is GitHub-native) |
| `agents/*.agent.md` | Retire; no replacement until a distinct agent role is justified |
| `instructions/afk-factory.instructions.md` | Replace with `git-workflow.instructions.md` |
| `workflows/` | Retire; create any narrow commit-policy CI template from first principles |
| `issue-templates/` | Retire |

The retirement is a **separate change** that precedes the plugin creation. No
AFK Factory state (`.worktrees/sessions.json`, labels, workflows) carries into
`martix-git`.

---

## Tests / fixtures / compatibility

### Pester test matrix

| Test file | Covers |
| --- | --- |
| `inspect-git-worktrees.Tests.ps1` | NUL parser, classification, TOCTOU, Unicode paths, locks, detached HEAD, stale metadata |
| `copilot-git-guard.Tests.ps1` | Runtime fixtures, allow/ask/deny output, malformed input, timeout behavior |
| `commit-validation.Tests.ps1` | Specification parser, repository type/scope policy, breaking changes, length policy |
| `branch-validation.Tests.ps1` | `git check-ref-format --branch`, prefix policy, existing branch behavior |

### Fixture repositories

Disposable Git repos created in `$env:TEMP` covering:

- Normal merge (graph-reachable)
- Squash merge (needs `gh pr list --state merged` evidence)
- Locked worktree
- Dirty worktree
- Unicode directory names
- Concurrent state changes between inspect and apply
- Missing upstream remote
- Detached HEAD
- Worktree registration removed externally between inspect and apply
- Client-removed worktree with its local branch left behind
- Empty orphan directory under an explicit scan root
- Non-empty, reparse-point, and `.git`-bearing orphan directories

### Compatibility matrix

| Runtime | Hook format | Tested |
| --- | --- | --- |
| VS Code (Preview hooks) | `.github/hooks/*.json` with PascalCase events | Phase 2+ |
| Copilot CLI | `hooks.json` with lowerCamelCase events | Phase 1 |
| Claude Code | `.claude/settings.json` | Documented but not primary target |

VS Code hook support is [currently Preview](https://code.visualstudio.com/docs/copilot/customization/hooks).
The plugin ships only hook configurations that have been validated against a
running runtime. Unsupported runtimes are documented, not assumed.

---

## Marketplace and versioning

- **Name**: `martix-git`
- **Marketplace**: `martix-skills`
- **Initial version**: `0.1.0`
- **Versioning**: SemVer. Breaking changes to hook contracts or configuration
  schema bump major.
- **Registration**: Added to `.github/plugin/marketplace.json` only after
  Phase 1 is installable and passes repository validation.
- **Standalone skill**: `martix-conventional-commit` is registered separately.

---

## Acceptance criteria (overall)

1. `/commit` produces valid conventional commit messages with the MartiX-owned
  companion skill installed and does not depend on the original external
  `/conventional-commit` skill.
2. `/branch` creates branches matching configured prefix/naming rules.
3. `/pr` creates draft PRs with conventional titles.
4. `/audit-worktrees` reports all worktrees with correct classification.
5. Native Git hooks block configured failures from supported local clients, and
  CI catches commits created with local verification bypassed.
6. Session-stop hook reports advisory warnings without blocking.
7. No plugin-owned destructive operation executes without positive ownership
  evidence, state re-validation, candidate selection, and `ShouldProcess`.
8. Repository validation passes.
9. Pester tests pass on PowerShell 7+ on Windows.
10. No Sandcastle-owned worktree is ever automatically removed.
11. Copilot archive cleanup is reconciled idempotently: externally removed
  worktrees do not fail an audit, do not trigger implicit branch deletion,
  and any leftover directory is report-only by default.

---

## Risks and open questions

| Risk | Mitigation |
| --- | --- |
| VS Code hook API is Preview and may change | Pin to documented behavior; re-test on each VS Code release |
| Copilot CLI hook format may diverge from VS Code | Use the documented compatibility mapping (camelCase ↔ PascalCase) |
| `gh` CLI may not be installed or authenticated | Degrade to `unknown`; never fail the user's workflow |
| Squash/rebase merge evidence requires network | Classify as `ambiguous` when offline; never assume merged |
| Plugin scope creep into "everything Git" | Enforce product boundary; require HITL decision for new modules |
| Conventional commit skill triggers where unwanted | Negative eval scenarios; narrow `description` |
| Sandcastle ownership evidence is unavailable after a handle closes | Consume an explicit retained-path record or classify the owner as unknown |
| Copilot archive behavior changes between client versions | Treat observations as non-contractual; re-read Git state and keep cleanup idempotent |
| Client cleanup leaves an empty or partially removed directory | Scan only configured roots; report separately; require emptiness, no reparse point, no `.git`, and operator confirmation |

### Open questions

1. Which Copilot CLI plugin manifest fields are currently supported for skill
  dependencies? **Current decision**: declare none until first-party schema and
  installation behavior are verified.
2. Should the plugin compose with Matt Pocock's `setup-pre-commit` skill or use
  its own setup prompt? **Current decision**: own the MartiX setup prompt and
  reuse existing repository tooling; external skills remain optional.
3. Do branch -> commit -> PR flows demonstrate enough repeated coordination to
  justify a custom agent? **Current decision**: ship standalone prompts first
  and add an agent only from observed need.

---

## Primary sources

- [Conventional Commits 1.0.0 Specification](https://www.conventionalcommits.org/en/v1.0.0/) — CC BY 3.0
- [Git worktree documentation](https://git-scm.com/docs/git-worktree)
- [Git branch documentation](https://git-scm.com/docs/git-branch)
- [Git check-ref-format documentation](https://git-scm.com/docs/git-check-ref-format)
- [Git hooks documentation](https://git-scm.com/docs/githooks)
- [Git switch documentation](https://git-scm.com/docs/git-switch)
- [GitHub CLI manual — `gh pr create`](https://cli.github.com/manual/gh_pr_create)
- [GitHub CLI manual — `gh pr list`](https://cli.github.com/manual/gh_pr_list)
- [VS Code Agent Hooks (Preview)](https://code.visualstudio.com/docs/copilot/customization/hooks) — accessed 2026-07-22
- [VS Code Hooks Reference](https://code.visualstudio.com/docs/agents/reference/hooks-reference)
- [Sandcastle README — `createWorktree()` API](https://github.com/mattpocock/sandcastle/blob/main/README.md#L471-L491)
- [Sandcastle `CloseResult` interface](https://github.com/mattpocock/sandcastle/blob/main/src/createSandbox.ts#L218-L221)
- [Sandcastle `createSandboxFromWorktree` — split ownership](https://github.com/mattpocock/sandcastle/blob/main/src/createSandbox.ts#L732-L735)
- [Matt Pocock Skills — `setup-pre-commit`](https://github.com/mattpocock/skills/blob/main/skills/misc/setup-pre-commit/SKILL.md)
- [Matt Pocock Skills — `git-guardrails-claude-code`](https://github.com/mattpocock/skills/blob/main/skills/misc/git-guardrails-claude-code/SKILL.md)
- [Matt Pocock Skills — `resolving-merge-conflicts`](https://github.com/mattpocock/skills/blob/main/skills/engineering/resolving-merge-conflicts/SKILL.md)
- [Matt Pocock Skills — `implement`](https://github.com/mattpocock/skills/blob/main/skills/engineering/implement/SKILL.md)
- [Husky documentation](https://typicode.github.io/husky/) — referenced but not bundled
- [lint-staged documentation](https://github.com/lint-staged/lint-staged)
- [GitHub Copilot CLI — agent hooks format](https://code.visualstudio.com/docs/copilot/customization/hooks#_how-does-vs-code-handle-copilot-cli-hook-configurations)
- [commitlint/config-conventional](https://github.com/conventional-changelog/commitlint/tree/master/%40commitlint/config-conventional) — type list reference (Angular convention)
- [commitlint local setup](https://commitlint.js.org/guides/local-setup.html)
