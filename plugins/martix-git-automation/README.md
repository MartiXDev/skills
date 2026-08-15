# MartiX Git Automation

`martix-git-automation` is the optional workflow companion for the standalone
[`martix-git`](../../skills/martix-git/) skill. It owns user-invoked prompts,
deterministic Git and GitHub adapters, opt-in native hook templates, CI
examples, and report-first worktree orchestration.

The standalone skill remains independently useful. This plugin does not copy
its rule library and does not silently install a dependency on it.

## Requirements

- Git 2.30 or later with a repository on the local machine.
- PowerShell 7+ for the Windows adapters and cleanup wrapper.
- `gh` only for remote PR evidence or PR creation; local planning works
  without it but marks remote decisions as unknown.
- An authenticated `gh` session when a command needs GitHub state.
- The repository's existing package manager and validation tools for hook or CI
  checks. The plugin does not install dependencies without approval.

## Install

Add the marketplace and install the plugin:

```powershell
copilot plugin marketplace add MartiXDev/skills
copilot plugin install martix-git-automation@martix-skills
```

Install the reusable skill separately:

```powershell
npx skills add https://github.com/MartiXDev/skills `
  --skill martix-git
```

For local development, install the package from the repository path after
checking the package files:

```powershell
copilot plugin install C:\Git\MartiXDev\skills:plugins/martix-git-automation
npx skills add C:\Git\MartiXDev\skills\skills\martix-git `
  -a github-copilot --copy -y
```

## Supported clients

Native Git hooks apply to terminal Git, VS Code, Copilot CLI, Sandcastle,
GUI-created commits, and CI-created commits when installed in the repository.
The prompts in this package are Copilot plugin assets and are not universal
Git enforcement. VS Code agent hooks and session-stop hooks are not shipped as
runtime contracts because their event and input schemas have not been
validated. Claude Code is an external compatibility target, not a primary
runtime requirement.

## Command surface

The canonical namespace is:

```text
/martix-git [workflow] [action] [options]
```

The prompts cover:

- smart routing, status, and the composed `/martix-git pr` branch-to-PR workflow;
- branch proposal and creation;
- explicit staging, commit proposal, and commit creation;
- push planning and publication without force-push fallback;
- PR preflight, draft creation, duplicate detection, and issue-link review;
- policy setup for hooks and CI parity;
- report-only worktree audit and explicit apply;
- release planning and verify-then-release guidance.

A prompt may draft language, but deterministic adapters validate state and the
user confirms every mutation.

## Safety defaults

- Bare `/martix-git` is read-only when intent is unclear.
- Worktree and branch cleanup is audit-first and report-only by default.
- Dirty, untracked, locked, current, protected, detached, active, externally
  owned, unknown, open-PR, and ambiguous states are retained.
- Staging uses explicit paths or hunks; no implicit whole-worktree staging.
- No force push, hard reset, destructive clean, empty commit, hook bypass, or
  hidden fallback is exposed by the standard prompts.
- Native hooks never publish releases or delete worktrees.
- GitHub protection and required CI remain authoritative over local hooks.

## State-changing commands

| Command | Default effect |
| --- | --- |
| `/martix-git pr` | Composed branch-to-PR workflow. |
| `branch create` | Creates one confirmed branch or worktree. |
| `stage add` | Stages only displayed paths or hunks. |
| `commit create` | Commits the current reviewed staged diff. |
| `push publish` | Pushes a confirmed non-divergent ref. |
| `pr create` | Creates a reviewed draft by default. |
| `worktree apply` | Delegates selected cleanup to the safe engine. |
| `release publish` | Publishes only from approved release context. |

Refusal and rollback behavior:

- `branch create`: refuse invalid refs, collisions, trunk ambiguity, and
  failed revalidation.
- `stage add`: declining selection stops dependent commit and PR phases.
- `commit create`: no staged diff, failed hooks, or declined confirmation
  leaves state unchanged.
- `push publish`: refuse force-push, divergence, missing auth, or changed HEAD.
- `pr create`: report an existing PR; missing `gh` blocks without claiming
  success.
- `worktree apply`: retain protected or unknown states and use `ShouldProcess`.
- `release publish`: refuse PR validation, unprotected branches, missing rules,
  or credentials.

Every mutation shows its target, arguments, expected effect, confirmation point,
and post-mutation validation. The plan is recomputed after each performed phase.

## Hooks and rollback

Hook setup is opt-in. The installer refuses to overwrite an existing hook
without explicit replacement approval and writes a marker for safe uninstall.
It keeps a backup when replacing a hook. Uninstall removes only a hook owned by
MartiX Git and restores its backup when one exists.

Native hook templates are bounded and local:

- `commit-msg` validates the message and preserves trailers.
- `pre-commit` checks staged files through configured repository commands.
- `pre-push` is optional and bounded.
- CI repeats critical checks because local hooks can be absent or bypassed.

See [hook adapters](./hooks/README.md) for the deterministic script surface
and exit-code contract.

No hook installs cleanup, release publishing, network-only checks, or an
unbounded full build by default. If setup fails, the installer reports the
path and leaves the existing hook unchanged.

## Configuration

An optional `.martix-git.json` uses `schemaVersion: 1`. Start with
[`martix-git.json`](./templates/martix-git.json) and validate it before enabling
policy:

```powershell
pwsh -NoProfile -File .\plugins\martix-git-automation\hooks\validate-config.ps1
```

Unknown schema versions and properties fail with a path, expected type, and
remediation. Empty type and scope arrays mean unrestricted dimensions. Release
integration, remote worktree evidence, and session-stop reporting are disabled
by default. Configuration cannot disable safety retention or confirmation.

## Worktree ownership

The local lane audits and reconciles local worktrees and branches. A remote
GitHub workflow may observe merged PRs, notify a developer, or remove a remote
head branch under repository policy, but it cannot remove a developer's local
worktree. The adapter delegates to
[`scripts/git-cleanup.ps1`](../../scripts/git-cleanup.ps1) rather than forking
its state machine.

## Validation

Focused checks from the repository root:

```powershell
$plugin = '.\plugins\martix-git-automation'
Get-ChildItem $plugin -Recurse -Filter *.json | ForEach-Object {
  Get-Content $_.FullName -Raw | ConvertFrom-Json | Out-Null
}
$markdown = @(Get-ChildItem $plugin -Recurse -Filter *.md -File |
  ForEach-Object { $_.FullName })
& .\plugins\martix-markdown-automation\hooks\markdown-check.ps1 `
  -CheckOnly -Path $markdown
```

Run the deterministic PowerShell tests when Pester 5+ is available:

```powershell
Invoke-Pester .\plugins\martix-git-automation\tests
```

Then run the repository validator:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\validate-repository.ps1
```

## Known gaps

- `hooks.json` is intentionally omitted until a target runtime event and input
  contract are validated.
- The plugin does not install `gh`, PowerShell, commitlint, Husky, lint-staged,
  semantic-release, or any package manager dependency.
- Release publishing remains optional and requires explicit analyzer policy,
  protected branches, full history where needed, dry-run verification, and
  least-privilege credentials.
- Runtime hooks are advisory only until fixture-tested against the real client.
