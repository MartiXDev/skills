# Git workflows and quality gates

## Purpose

Use this rule for branch, stage, commit, push, hook, CI, or repository-policy
workflow decisions. Keep the change small enough to review and test, and keep
state handling deterministic while language generation remains a proposal.

## Workflow practice

Before a mutation, inspect the smallest relevant evidence:

```text
git status --short
git branch --show-current
git diff --cached --
git diff --
git log -n 5 --oneline --decorate
git branch -vv
```

Use a topic branch for a nontrivial feature or fix. Prefer
`git switch -c <branch>` or `git worktree add -b <branch> <path> <base>` for
creation. Keep local branches, remote-tracking refs, remote branches, tags,
and unreachable objects distinct in reports.

Staging is explicit. Show paths or hunks, ask before `git add`, and do not
stage an entire dirty worktree because a composed workflow contains a commit
phase. A commit uses only the reviewed cached diff. A push uses an explicit
remote and ref, checks divergence, and never force-pushes as a fallback.

Use argument-based invocation for branch names, paths, issue titles, messages,
and PR text. Use temporary files for multi-line commit, PR, or release content.
The model may draft text and explain policy; deterministic adapters must parse
Git/GitHub output, validate inputs, revalidate state, and execute commands.

Every mutation has this shape: inspect, propose, show the exact target and
effect, confirm, execute, re-read, and report. Recompute later phases after a
performed phase. A skipped or declined phase is a result, not a hidden reason
to perform an alternative mutation.

## Hook and CI boundaries

- **`commit-msg`**: Validate messages; preserve trailers; no PR or release
  policy.
- **`pre-commit`**: Run bounded staged lint, format, secret, or cheap tests.
- Keep publishing, cleanup, and unbounded builds out by default.
- **`pre-push`**: Run bounded verification; CI remains authoritative.
- **CI**: Repeat required checks with least privilege and safe PR handling.
- **GitHub protection**: Enforce checks that local hooks cannot replace.
- **Agent/plugin hook**: Add advisory guardrails, never universal enforcement.

Prefer existing repository tooling. `commitlint`, Husky, `lint-staged`, and
third-party Actions are implementation options, not owners of the
Conventional Commits specification. Native hooks can be absent or bypassed
with `--no-verify`, so critical checks must have CI or server parity.

## Policy setup

Inspect the language, package manager, current hooks, CI, and validation
commands before proposing policy files. Show every file and command that would
change, preserve existing user-owned hooks, and provide install, bypass,
failure, and uninstall behavior. Generate `commit-msg`, bounded `pre-commit`,
and optional bounded `pre-push` separately. Never install cleanup or release
publishing in a native hook.

## Review checklist

- The requested intent and repository state are explicit.
- Staging uses selected paths or hunks.
- Commands pass structured arguments and bounded output is checked.
- Confirmation occurs before each mutation or displayed grouped set.
- Hooks are supplemental and CI/server policy is authoritative.
- Post-mutation state is re-read and each phase is reported.

## Source anchors

See [source-map.md](../references/source-map.md) for Git workflow, hook,
GitHub protection, and local cleanup evidence.
