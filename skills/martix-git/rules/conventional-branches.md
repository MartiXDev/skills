# Conventional Branches and Git refs

## Purpose

Use this rule for branch names, topic-branch creation, branch candidates, or
branch-policy review. Conventional Branch is a separate specification from
Conventional Commits. Validate both the versioned branch policy and Git's ref
rules before mutation.

## Specification and policy

Pin the initial Conventional Branch contract to
`https://conventionalbranch.org/v1.1.0/spec.json`. Do not use an unversioned
latest endpoint as a reproducibility contract. The common form is
`<type>/<description>`. Trunk names such as `main`, `master`, and `develop`
are exceptions rather than prefixed topic branches.

The exact prefix list, lowercase requirement, description length, issue
identifier form, aliases, and agent-origin prefixes are configurable policy.
The relationship between `feature/` and `feat:` is a useful workflow
convention, not a requirement that the two specifications share a parser.

Git independently decides whether a candidate is a valid ref. Always run:

```text
git check-ref-format --branch <candidate>
```

Reject whitespace, control characters, ambiguous separators, policy-disallowed
prefixes, invalid Git refs, trunk collisions, and existing branch collisions
before asking to create or switch. Do not present a repository prefix or issue
format as universal Conventional Branch behavior.

## Workflow

1. Collect the requested purpose, optional issue identifier, description,
   branch type, base branch, and optional worktree path.
2. Detect the repository's trunk from local evidence and confirm it when more
   than one candidate or an unusual default exists. A topic request must not
   silently land on a trunk branch.
3. Assemble a candidate under the pinned policy. Normalize only when the
   transformation is visible and reversible; preserve user intent.
4. Run the pinned policy validation and `git check-ref-format --branch` as
   independent checks. Check the candidate and base for collisions.
5. Show the exact target and either `git switch -c <candidate>` or
   `git worktree add -b <candidate> <path> <base>`, using argument-based
   invocation. Ask for confirmation before creating or switching.
6. Re-read the branch, HEAD, base, and worktree after the mutation. Report
   the observed result rather than assuming the command succeeded.

`branch propose` is read-only. `branch create` is the atomic mutation form.
The smart branch workflow skips creation when the current branch is already a
valid non-protected topic branch matching the request, and reports the skip.

## Examples

```text
feature/oauth-callback
bugfix/parser-null-input
chore/update-dependencies
```

These are candidates, not universal allow-list entries. A repository may use a
different configured vocabulary. `Add OAuth callback support` is description
input, not a valid candidate until it is converted and independently checked.

## Avoid

- Treating a Conventional Commit such as `feat(api): ...` as a branch name.
- Using the moving latest branch specification in an automated validator.
- Creating a trunk branch when the request is for a topic branch.
- Using a directory name, issue number, or agent name as ownership proof.
- Embedding an untrusted candidate in a shell command string.

## Review checklist

- Intent and base branch are evidenced.
- The candidate is valid under the pinned policy and Git ref rules.
- Policy choices are labeled separately from specification facts.
- Existing branch and worktree collisions are checked.
- The exact command and target are shown before confirmation.
- The post-create branch and worktree state is observed.

## Source anchors

See [source-map.md](../references/source-map.md) for Conventional Branch
v1.1.0, Git ref validation, and the local policy evidence.
