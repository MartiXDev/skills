# Sandcastle-aligned worktree maintenance plugin plan

## Decision

Propose a new, optional `martix-git-worktree-maintenance` plugin after the
`martix-afk-factory` retirement.

The plugin is justified when users want an installable bundle containing a
worktree audit command, a guided cleanup prompt, and report-only lifecycle
hooks. A repository that only needs an occasional local audit should use the
core script directly and does not need the plugin.

This is a maintenance plugin, not an agent orchestrator. Matt Pocock Skills
provide composable engineering workflows, while Sandcastle owns agent,
sandbox, branch, and worktree lifecycle for Sandcastle runs.

## Why a separate plugin

The repository's artifact policy reserves plugins for one-step installation and
bundled prompts, instructions, hooks, or agents. This capability needs those
assets only when automatic warnings and a repeatable operator workflow are
desired.

Keeping it separate provides these boundaries:

- removing `martix-afk-factory` does not remove generic Git maintenance;
- installing worktree maintenance does not install an orchestrator;
- Sandcastle can evolve without a private session registry in this repository;
- the audit engine remains independently runnable and testable;
- destructive actions remain explicit rather than hook-driven.

## Ownership model

### Sandcastle

Evidence is a retained Sandcastle `Worktree` or `Sandbox` handle, a lifecycle
result, or `preservedWorktreePath`. The plugin reports only and preserves dirty
or cancelled worktrees.

### VS Code or Copilot

Evidence is a documented client session linked to the worktree. The plugin
reports only and lets the client remove the worktree after its final linked
session is archived or deleted.

### Plugin

Evidence would be an explicit ownership record created by a future plugin
operation. The plugin may clean only its own clean, inactive resources under
its documented policy. Version 1 should create no worktrees.

### User or unknown tool

When no positive owner evidence exists, the plugin reports the owner as unknown
and never removes the worktree automatically.

Paths, branch prefixes, a missing upstream, a closed editor, or a merged pull
request are useful signals but are not ownership proof.

## Sandcastle contract

Current Sandcastle documentation makes cleanup part of its public lifecycle:

- top-level `run()` handles its one-shot sandbox lifecycle;
- `sandbox.close()` and `await using` remove clean resources and preserve a
  worktree with uncommitted changes;
- `wt.close()` owns cleanup for `createWorktree()`;
- when `wt.createSandbox()` is used, `sandbox.close()` owns the container and
  `wt.close()` owns the worktree;
- cancellation preserves the worktree;
- `CloseResult.preservedWorktreePath` identifies a retained worktree.

The plugin must not rediscover or override these rules. Sandcastle integration
should consume an explicit retained-path result or a future documented manifest
or API. It must not infer Sandcastle ownership from directory names.

## Proposed package

```text
plugins/martix-git-worktree-maintenance/
|-- plugin.json
|-- README.md
|-- hooks.json
|-- hooks/
|   |-- inspect-git-worktrees.ps1
|   `-- README.md
|-- prompts/
|   |-- audit-worktrees.prompt.md
|   `-- README.md
|-- instructions/
|   `-- README.md
`-- tests/
    |-- fixtures/
    `-- inspect-git-worktrees.Tests.ps1
```

Do not add an agent in version 1. The operation is deterministic and does not
need a specialized model role. Do not add a standalone skill unless reusable
Git worktree guidance grows beyond the plugin workflow.

## Core command

`inspect-git-worktrees.ps1` should be the independently executable engine. Its
default behavior is report-only.

Suggested interface:

```powershell
./inspect-git-worktrees.ps1 `
  -RepositoryPath . `
  -Format Console

./inspect-git-worktrees.ps1 `
  -RepositoryPath . `
  -Format Json `
  -OutputPath .worktree-maintenance/report.json

./inspect-git-worktrees.ps1 `
  -RepositoryPath . `
  -Apply `
  -Confirm
```

Implementation requirements:

- use `CmdletBinding(SupportsShouldProcess)`;
- parse `git worktree list --porcelain -z` as NUL-delimited records;
- invoke Git and GitHub CLI with argument arrays, not interpolated shell text;
- validate branch refs before passing them to destructive Git commands;
- emit structured records with state, evidence, owner, recommended action, and
  blocking reasons;
- write reports atomically;
- re-read state immediately before every mutation;
- never use force removal in automatic or hook paths.

## Classification

Protect these states unconditionally:

- main worktree;
- current worktree;
- dirty worktree;
- locked worktree;
- detached worktree without explicit operator review;
- active or externally owned worktree;
- unknown owner;
- branch with an open pull request;
- branch with ambiguous squash or rebase merge evidence.

An item is a cleanup candidate only when all applicable checks pass: it is not
protected, it is clean and unlocked, no owner is active, and branch completion
has positive evidence. Graph reachability is sufficient for a normal merge;
exact merged-PR evidence is needed when squash or rebase history breaks
reachability.

Version 1 should support two apply operations only:

1. prune stale administrative worktree records using Git's normal prune rules;
2. remove a clean worktree or merged branch selected and confirmed by the
   operator during that invocation.

No age-based deletion, missing-upstream deletion, bulk branch deletion, or
background cleanup belongs in version 1.

## Hook behavior

Hooks are advisory only:

- run a bounded report after a supported session-stop event;
- exit successfully when no attention is needed;
- warn with paths and recommended commands when retained work exists;
- never call the command with `-Apply`;
- never block Sandcastle or VS Code cleanup;
- avoid network calls unless explicitly enabled.

Hook schemas and event names differ across Copilot CLI plugins and VS Code
preview hooks. Before implementation, validate each target runtime separately.
Ship only the runtime configuration covered by an executable compatibility
test; document unsupported clients instead of assuming discovery.

## GitHub boundary

GitHub Actions may label, comment on, or report merged pull requests, but a
remote workflow cannot remove a developer's local worktree. PR-close events are
completion evidence only. They must not be presented as a local cleanup trigger.

The core command may query `gh pr list --state merged --head <branch>` when the
operator enables remote evidence. It should degrade to an explicit `unknown`
classification when GitHub CLI, authentication, or network access is absent.

## Implementation phases

### Phase 0: retire the old owner

- remove `martix-afk-factory` and its root-level launchers in a separate change;
- archive or rewrite AFK documentation that would otherwise direct users to the
  removed plugin;
- do not carry `.worktrees/sessions.json`, AFK issue labels, or AFK workflows
  into the new package.

### Phase 1: report engine

- implement the NUL-safe Git parser and protected-state classification;
- add console and JSON output;
- add fixture tests for spaces, Unicode paths, locked and prunable worktrees,
  detached HEAD, missing upstreams, and malformed Git output;
- keep all output report-only.

Acceptance signal: the engine can audit the current repository without changing
Git state and every listed item has a reasoned recommendation.

### Phase 2: explicit cleanup

- add `SupportsShouldProcess`, `-Apply`, and per-item confirmation;
- revalidate dirty, lock, owner, worktree, branch, and PR state before mutation;
- add tests for state changes between inspection and apply;
- prohibit force removal.

Acceptance signal: only a deliberately selected, still-safe candidate can be
removed, and cancellation leaves the repository unchanged.

### Phase 3: plugin bundle

- add the manifest, README, guided audit prompt, and runtime-scoped report hook;
- add a hook time budget and stable exit-code contract;
- validate installation and uninstallation without changing repository state;
- register marketplace metadata only after the package is installable.

Acceptance signal: installation adds the audit workflow, the hook only reports,
and uninstalling the plugin leaves no lifecycle state behind.

### Phase 4: optional Sandcastle adapter

Add an adapter only if Sandcastle exposes durable ownership evidence required
outside a live handle, or the local orchestration script explicitly records
`CloseResult.preservedWorktreePath`. The adapter may enrich reports; it must not
take over `sandbox.close()` or `wt.close()`.

Acceptance signal: Sandcastle-created resources are classified from explicit
evidence, and an absent or outdated adapter falls back to `unknown`, not
deletion.

## Validation gates

- Pester parser and decision-table tests pass on Windows PowerShell and
  PowerShell 7 where supported.
- A disposable Git repository test covers normal merge, squash merge,
  worktree locks, dirty state, stale metadata, and concurrent state changes.
- Hook tests prove no destructive command is invoked.
- Package metadata and documentation pass repository validation.
- A manual smoke test verifies Sandcastle's clean close, dirty preservation,
  and split `sandbox.close()`/`wt.close()` ownership before enabling any
  adapter.

## Recommendation

Proceed with the new plugin, but implement the report engine first. This order
tests whether the capability is useful without prematurely committing to hook
compatibility or marketplace surface area. Keep AFK Factory removal as a
separate change so retirement and replacement remain independently reviewable.

## Primary sources

- [Sandcastle README](https://github.com/mattpocock/sandcastle/blob/main/README.md)
- [Matt Pocock Skills README](https://github.com/mattpocock/skills/blob/main/README.md)
- [Git worktree documentation](https://git-scm.com/docs/git-worktree)
- [Git branch documentation](https://git-scm.com/docs/git-branch)
- [GitHub CLI pull request list manual](https://cli.github.com/manual/gh_pr_list)
- [VS Code agent hooks](https://code.visualstudio.com/docs/copilot/customization/hooks)
- [VS Code Copilot CLI sessions](https://code.visualstudio.com/docs/copilot/agents/copilot-cli)
