# Pull requests and issues

## Purpose

Use this rule for PR planning, drafting, creation, review state, merge policy,
or issue references. GitHub owns PR fields and issue-linking behavior; a PR is
not a Conventional Commit.

## Field boundary

Treat `title`, `body`, `head`, and `base` as separate values. GitHub may use a
PR title or body when constructing a merge or squash commit according to the
repository's merge settings. A Conventional Commit-shaped title is therefore
repository policy, and is required only when the selected merge method makes
the title release-significant or the repository explicitly adopts that rule.

The body should explain summary, motivation, implementation, tests, risk,
migration or breaking-change notes, and issue references. Do not force the body
into commit-message grammar or duplicate release metadata without a reason.

`Refs #123` or `Related to #123` navigates without requesting automatic issue
closure. `Fixes #123`, `Closes #123`, and equivalent closing keywords request
closure under GitHub's rules. Ask before adding a closing keyword; never add it
just to make a PR look complete. Default-branch limitations and cross-repo
references must be checked from the target repository context.

## Smart PR workflow

Run a read-only preflight over current branch, base, commit range, status,
staged paths, upstream, remote divergence, existing PRs, and title/merge
policy. Return one row for each phase:

| Phase | Perform when |
| --- | --- |
| `branch` | Detached, protected/trunk, or unsuitable for intent. |
| `stage` | Relevant paths or approved hunks are selected. |
| `commit` | Reviewed staged work needs a commit. |
| `push` | The remote lacks the required HEAD or upstream. |
| `pr` | No matching open PR exists and the branch is reviewable. |

Classify each phase as `perform`, `skip`, `ask`, or `block`, and include
evidence, the exact proposed action, confirmation state, result, and final
observed state. Re-read and recompute after every performed phase. A clean
topic branch with pushed commits skips branch, stage, commit, and push when
the evidence supports those skips.

Draft PRs by default unless explicit user intent or repository policy says
otherwise. Prefer a draft while review is pending. Use structured GitHub CLI
or API fields, for example `gh pr create` with explicit `--title`, `--base`,
`--head`, and `--body-file` values. Do not scrape rendered PR text when a
structured field is available.

Before creation, check for an existing open PR with the same head and base.
Report its URL instead of creating a duplicate. If `gh` is missing or
unauthenticated, continue with local evidence but classify remote and PR
decisions as unknown or blocked; never claim that a PR was created.

## Review checklist

- Head and base are explicit and suitable.
- Title policy is conditional and documented.
- Body sections cover context, tests, risk, migration, and issue intent.
- `Refs` is used when closure is not intended.
- Existing PR, remote, and authentication evidence are current.
- The user reviews title, body, draft state, and issue-linking intent.

## Source anchors

See [source-map.md](../references/source-map.md) for GitHub PR fields,
issue-linking, merge methods, and repository policy evidence.
