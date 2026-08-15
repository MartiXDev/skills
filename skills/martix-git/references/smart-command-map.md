# Smart command map

Read this file for a bare `/martix-git` request, a composed workflow, or a
phase decision. The command grammar is:

```text
/martix-git [workflow] [action] [options]
```

## Entry modes

| Entry | Mode | First result |
| --- | --- | --- |
| `/martix-git` | Smart | Intent/state report; ask if needed. |
| `/martix-git status` | Atomic | Read-only repository and policy state. |
| `/martix-git branch` | Smart | Candidate or skip if the topic is valid. |
| `/martix-git stage` | Smart | Explicit path or hunk proposal. |
| `/martix-git commit` | Smart | Staged message or no-change diagnostic. |
| `/martix-git push` | Smart | Upstream and divergence plan. |
| `/martix-git pr` | Smart | Preferred conditional branch-to-PR workflow. |
| `/martix-git policy setup` | Smart | Audit and policy proposal. |
| `/martix-git worktree audit` | Atomic | Report-only inventory. |
| `/martix-git release plan` | Atomic | Prerequisites and impact report. |

Atomic mutation forms are explicit: `branch create`, `stage add`,
`commit create`, `push publish`, `pr create`, `worktree apply`, and
`release publish`. They keep the same validation and confirmation boundaries.

## Preferred delivery command

Use `/martix-git pr` when the goal is to finish the current change with the
fewest decisions. The automation plugin's `hooks/plan-pr-workflow.ps1` is the
read-only coordinator for this route. It inspects the repository and, when the
branch and base are resolvable, structured PR evidence; it emits one phase row
for `inspect`, `branch`, `stage`, `commit`, `push`, and `pr` plus the exact
atomic adapter arguments for any `perform` phase.

The command is conditional rather than a fixed script sequence. It skips a
valid topic branch, an already-selected index, an existing reviewable commit,
an upstream that already contains HEAD, and an existing matching open PR. It
asks for a branch name, explicit path set, commit message, remote/ref target,
or PR fields only when evidence cannot decide them. It blocks on divergence,
invalid refs, missing capabilities, unsafe scope, or unresolved prerequisites.
After every confirmed mutation, rerun the planner and use the new evidence.

## Phase decisions

Classify every relevant phase as `perform`, `skip`, `ask`, or `block`.

| Decision | Meaning |
| --- | --- |
| `perform` | Evidence supports the displayed action after confirmation. |
| `skip` | Evidence proves the phase is unnecessary; report why. |
| `ask` | A user choice or missing intent is required. |
| `block` | A safety, policy, capability, or state prerequisite fails. |

For PR workflows, evaluate phases in order:

```text
inspect -> branch -> stage -> commit -> push -> pr
```

The sequence is conditional, not mandatory. A clean valid topic branch with
reviewable commits and a synchronized remote skips branch, stage, commit, and
push. An existing open PR skips creation and returns its URL.

## Dispatch algorithm

1. Read explicit user constraints and target.
2. Inspect only the local and remote state needed for that target.
3. Route to one primary workflow and the smallest relevant rule file.
4. Build the phase table with evidence, action, confirmation, and result.
5. Show commands, paths, assumptions, and expected effects.
6. Confirm each mutation or the displayed grouped set.
7. Re-read state after every performed phase and recompute later phases.
8. Report completed, skipped, blocked, failed, and unresolved results.

A bare command with no actionable intent is read-only and asks one focused
question. A dirty worktree does not imply staging, committing, branching,
pushing, PR creation, release, or cleanup. Missing `gh` or remote evidence
makes affected phases unknown or blocked; it does not authorize a workaround.

## Common options

Support options such as `--plan`, `--dry-run`, `--base`, `--remote`,
`--branch`, `--issue`, `--type`, `--scope`, `--worktree`, `--paths`,
`--draft`, and `--body-file` only when the command owns them. Pass them as
structured arguments. Options cannot weaken confirmation, validation,
protection, ownership, or revalidation.

## Related files

- [output-contract.md](./output-contract.md) defines the returned plan.
- [configuration-boundary.md](./configuration-boundary.md) defines repository
  policy and runtime settings.
- [git-workflows-and-hooks.md](../rules/git-workflows-and-hooks.md) defines
  command safety and hook boundaries.
