---
name: martix-git pr
description: Plan, review, and create a draft or ready GitHub pull request with duplicate detection.
---

# /martix-git pr

`/martix-git pr` is the preferred end-to-end delivery command. Start with the
read-only deterministic planner:

```powershell
pwsh -NoProfile -File hooks/plan-pr-workflow.ps1 -RepositoryPath <repo> -Json
```

The planner invokes the repository and PR inspectors, then returns the complete
`inspect -> branch -> stage -> commit -> push -> pr` phase table. It does not
mutate Git or GitHub state.

Classify each phase using these rules:

- `branch`: perform for a detached, protected, or invalid topic branch; skip for
  a suitable topic branch; ask or block when intent, base, or collision is
  ambiguous.
- `stage`: perform only for explicitly selected paths; skip when required
  changes are already staged; ask when scope is mixed or unclear.
- `commit`: perform when a staged reviewable delta needs a commit; skip when a
  clean branch already has the delta; ask or block for ambiguous message,
  hooks, or reviewable range.
- `push`: perform when ahead with an explicit upstream or remote/ref target, or
  when the remote head is absent and its target is known; skip when the remote
  has the required HEAD; ask when upstream or the target is missing; block on
  divergence or remote and authentication failure.
- `pr`: perform when no duplicate exists and the branch is pushed and
  reviewable; skip for a matching open PR; ask or block for missing `gh`, closed
  coverage, or policy ambiguity.

Draft title and body as separate GitHub fields. Use summary, motivation,
implementation, tests, risk, migration/breaking-change notes, and issue
references. Keep `Refs #123` separate from intentional `Fixes`/`Closes` keywords.
Default to a draft unless policy or explicit user choice says ready.

Show the complete plan and exact adapter arguments before any mutation. Ask
only for the unresolved input that controls the next phase: a branch name,
explicit paths or hunks, a reviewed commit message, a remote/ref target, or
separate PR title and body. Do not turn a missing answer into an implicit
default such as `git add .`.

After the user confirms the displayed grouped set, invoke the planner's
atomic adapter arguments in phase order. Re-run the planner after every
performed adapter and use the new state to decide later phases. An existing PR
is `skip`, not a second create. Missing or unauthenticated `gh` is
unknown/blocking evidence, never success. The PR adapter must receive separate
`--title`, `--body-file`, `--head`, and `--base` values and must remain draft by
default.
