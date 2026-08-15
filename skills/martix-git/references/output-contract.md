# Output contract

Use this structure for commit, branch, PR, release, policy, and cleanup
requests. A prose explanation may accompany it, but it must not replace the
state and confirmation record.

## Required result

```text
Route: <primary workflow and rule file>
Intent: <explicit target or unresolved intent>
Evidence:
  - <repository, Git, GitHub, policy, or capability fact>
Source labels:
  - requirement: <owning specification or repository contract>
  - policy: <configured repository choice>
  - recommendation: <proposed choice>
  - inference: <combined conclusion>
  - gap: <unverified fact>

Phase: <phase>
Decision: <perform/skip/ask/block>
Evidence: <current state>
Action: <exact command or no-op>
Confirmation: <required, received, declined, or n/a>
Result: <completed, skipped, blocked, failed, or unresolved>

Validation:
  - <exact command or check that ran>
Remaining uncertainty:
  - <unknown, blocked, or unresolved evidence>
```

Use `perform`, `skip`, `ask`, and `block` exactly. Use `completed`, `skipped`,
`blocked`, `failed`, and `unresolved` for result language. A drafted command is
not a completed command. A skipped phase includes the evidence that made it
unnecessary.

## Mutation record

Before a state change, show:

- target repository, worktree, branch, remote, ref, path, or PR;
- expected current HEAD or object ID when deletion or publication is involved;
- exact argument-based command or temporary-file boundary;
- expected effect and rollback/refusal behavior;
- required confirmation.

After a state change, re-read the relevant state and report the observed
identity, status, hooks, URL, tag, or cleanup result. A candidate that
vanishes externally is a reconciled no-op, not permission to broaden the set.

## Cleanup result

Cleanup reports should add:

| Field | Meaning |
| --- | --- |
| Path | Registered worktree or configured orphan path. |
| Branch | Local branch or detached state. |
| HEAD | Observed object ID. |
| Ownership | Local, remote, external, or unknown evidence. |
| Merge | Ancestry, GitHub PR, ambiguous, or unavailable evidence. |
| Retention | Protected state and reason. |
| Candidate | Report-only action, selected apply action, or no-op. |
| Revalidation | Fresh state and expected-object-ID result. |

## Related files

- [smart-command-map.md](./smart-command-map.md) defines phase decisions.
- [worktree-lifecycle.md](../rules/worktree-lifecycle.md) defines retention.
