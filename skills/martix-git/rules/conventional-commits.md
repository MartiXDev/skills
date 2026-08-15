# Conventional Commits

## Purpose

Use this rule when the request concerns a commit message, staged diff,
breaking-change explanation, commit-message policy, or release-significant
commit text. Conventional Commits 1.0.0 is the owning specification for the
message format. It is not a branch, pull-request, hook, or release
specification.

## Specification

The canonical shape is:

```text
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

The `type` is required. `feat` describes a new feature and `fix` describes a
bug fix. Other types are allowed by the specification; their meaning is a
repository choice unless the message also declares a breaking change. A
scope is optional and is a noun in parentheses. The description follows a
colon and one space. A body follows one blank line. Footers follow trailer-like
syntax and are separated from the body by one blank line.

Breaking changes may be marked with `!` before the colon, for example
`feat(api)!: replace the response envelope`, or with a `BREAKING CHANGE:`
footer. `BREAKING-CHANGE:` is the synonymous footer token. Keep the required
uppercase spelling for that footer token and preserve other valid trailers.

## Policy boundary

The specification does not choose a MartiX type allow-list, scope list,
imperative style, subject length, capitalization rule, or body requirement.
Treat those as repository policy in `.martix-git.json`, commitlint
configuration, or documented maintainer guidance. Empty configured type or
scope lists mean that dimension is unrestricted.

A valid Conventional Commit can inform changelog or release automation, but it
does not guarantee that a release is produced. Release impact belongs to the
configured analyzer and release policy in
[semver-and-semantic-release.md](./semver-and-semantic-release.md).

Do not parse a PR body as one Conventional Commit, and do not require a branch
name to match the commit parser. Branch naming belongs to
[conventional-branches.md](./conventional-branches.md).

## Workflow

1. Inspect `git status --short`, the current branch, and
   `git diff --cached --`. Use only the staged diff as evidence for a commit
   proposal.
2. Draft one message whose type, scope, subject, body, and footers match the
   change. Identify a breaking API or behavior change explicitly.
3. Validate the message against the repository policy and the Conventional
   Commits structure. Keep user-authored trailers unless they are malformed or
   the user asks for a correction.
4. Show the complete message and the proposed effect. Write reviewed
   multi-line content to a temporary file and use `git commit --file <path>`.
5. Ask for confirmation immediately before the commit. After the command,
   report hook output, commit identity, resulting status, and any failure.

No staged change is a useful diagnostic, not a reason to stage the worktree or
create an empty commit. A declined path selection stops dependent commit work.

## Examples

Valid:

```text
feat(search): add saved-query filters

Users can now save and reuse a filter set.

Refs: #42
```

```text
fix(auth)!: reject expired refresh tokens

Clients must request a new token when the refresh token has expired.

BREAKING CHANGE: expired refresh tokens are no longer renewed.
Reviewed-by: Example
```

Invalid under the base structure:

```text
add saved-query filters
```

The message has no required type and colon separator. Whether a message is
imperative or whether `add` is an allowed type is repository policy only after
the structural defect is fixed.

```text
feat(search): add saved-query filters
BREAKING CHANGE: clients must migrate
```

The footer is not separated from the subject by a blank line. Preserve the
meaning, then repair the layout rather than silently dropping the footer.

## Review checklist

- The staged diff supports the chosen type and scope.
- The subject states the change without inventing unrelated work.
- Body and footers are separated by blank lines.
- Breaking impact appears as `!`, a breaking footer, or both when policy asks.
- Repository-specific limits are labeled as policy, not as the standard.
- The final message is shown before confirmation and is passed through a file.

## Source anchors

See [source-map.md](../references/source-map.md) for the Conventional Commits
1.0.0 source, repository evidence, and evidence labels.
