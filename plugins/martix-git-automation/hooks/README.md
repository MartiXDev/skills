# Hook adapters

These scripts are deterministic adapters for the `martix-git-automation`
plugin. They inspect or mutate local Git state through argument-based native
process calls and emit JSON when invoked with `-Json`.

## Shared behavior

- PowerShell 7+ is required.
- Mutating scripts use `ShouldProcess`; `-Apply` requests a mutation but does
  not bypass confirmation.
- Planned mutations report `Decision`, `Confirmation`, `Result`, `Command`,
  and `Arguments` where applicable.
- Exit code `0` means the requested operation completed, was skipped safely,
  or produced a valid read-only plan.
- Exit code `1` means policy or preflight blocked the request.
- Exit code `2` means the adapter could not complete its own validation or
  execution contract.
- Command output is bounded by `common.ps1` before it is returned.

## Read-only adapters

- `common.ps1`: shared configuration, native-process, output, and command
  parsing helpers. It is dot-sourced by the other scripts.
- `validate-config.ps1`: validates `.martix-git.json` against schema version 1.
- `validate-commit-message.ps1`: validates a message file against the
  configured Conventional Commit policy. Invalid messages return exit code 1.
- `validate-branch-name.ps1`: validates a branch against the pinned
  Conventional Branch version and `git check-ref-format --branch`.
- `inspect-repository.ps1`: reports branch, HEAD, base, upstream, divergence,
  status, and local policy state.
- `inspect-pr.ps1`: reports local PR identity and structured GitHub evidence.
  Missing or unauthenticated `gh` is valid local output with remote evidence
  marked unavailable; it is never reported as success for a remote action.
- `plan-pr-workflow.ps1`: composes repository and PR inspection into a
  read-only branch-to-PR phase table and emits exact arguments for the atomic
  adapters. It never performs a mutation.
- `inspect-git-worktrees.ps1`: delegates registered worktree classification to
  `scripts/git-cleanup.ps1` and reports configured-root directories separately.

## Local Git adapters

- `create-branch.ps1`: validates and plans `git switch -c` or
  `git worktree add -b`, then verifies branch, HEAD, path, and clean status.
- `stage-paths.ps1`: stages only explicit paths after a dry-run and confirmation.
- `commit-staged.ps1`: validates a reviewed message and creates one commit from
  the staged diff after expected-HEAD and confirmation checks.
- `push-ref.ps1`: plans or performs a non-force push after upstream, divergence,
  and expected-HEAD checks.

## Pull request and release adapters

- `create-pr.ps1`: checks authentication, duplicate open PRs, head identity,
  and explicit title/body/head/base fields before creating a PR.
- `release-plan.ps1`: performs release preflight only. It does not publish.
- `release-publish.ps1`: runs the release preflight and then performs a dry run
  unless explicit publication is requested from an approved context.

## Native hook lifecycle

- `commit-msg.ps1`: thin runtime entrypoint used by the installed native
  `commit-msg` hook. It delegates to `validate-commit-message.ps1` and preserves
  its exit code.
- `pre-commit.ps1`: runs configured bounded commands in order and stops at the
  first failure.
- `pre-push.ps1`: runs the one configured bounded command or reports a safe
  skip when none is configured.
- `install-hooks.ps1`: installs reviewed launchers and runtime files only when
  hooks are enabled. It marks owned launchers and backs up user-owned hooks
  only with `-ReplaceExisting`.
- `uninstall-hooks.ps1`: removes only marked launchers and retains changed
  content. `-RestoreBackup` restores a backup created during replacement.

Native launchers live under `../templates/hooks/`. CI and pull-request
examples live under `../templates/`; they are opt-in examples and are not
installed automatically.
