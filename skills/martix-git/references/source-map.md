# MartiX Git source map

Read this file when a response needs a factual source anchor. The rules state
how to act; this map states which contract owns each fact. Preserve the label
when converting a source into repository guidance:

- **Requirement**: the owning source defines the behavior.
- **Implementation evidence**: code or a local artifact demonstrates behavior.
- **Recommendation**: MartiX policy proposed from the evidence.
- **Inference**: a conclusion combined from multiple sources.
- **Gap**: requested evidence that was not verified.

## Authority order

1. Git, GitHub, Conventional Commits, Conventional Branch, SemVer, and
   semantic-release own the behavior they define.
2. Repository policy owns package layout, validation, and ownership.
3. The requirements baseline owns MartiX product defaults.
4. A model suggestion remains a proposal until validated and confirmed.

## Owning sources

| ID | Contract | Source |
| --- | --- | --- |
| CC-1 | Commit-message format | [Conventional Commits 1.0.0][cc] |
| CB-1 | Branch concepts and grammar | [Conventional Branch][cb] |
| CB-3 | Pinned branch policy | [Conventional Branch v1.1.0][cb-spec] |
| SV-1 | Version syntax and precedence | [SemVer 2.0.0][semver] |
| SR-1 | Release workflow | [semantic-release introduction][sr-intro] |
| SR-2 | Release configuration | [semantic-release configuration][sr-config] |
| SR-6 | Analyzer and release rules | [commit-analyzer][sr-analyzer] |
| GIT-2 | Commit and hook behavior | [git-commit][git-commit] |
| GIT-3 | Native hook lifecycle | [githooks][githooks] |
| GIT-4 | Worktree state and inventory | [git-worktree][git-worktree] |
| GIT-8 | Ref validation | [git-check-ref-format][git-ref] |
| GH-1 | Issue-linking keywords | [GitHub issue links][gh-issues] |
| GH-3 | PR fields and API | [GitHub pull requests API][gh-api] |
| GH-4 | CLI PR commands | [GitHub CLI gh pr][gh-cli] |
| GH-5 | Merge history | [GitHub merge methods][gh-merge] |
| GH-6 | Protected branches | [GitHub protected branches][gh-protection] |
| GH-7 | Rulesets | [GitHub rulesets][gh-rulesets] |
| GH-8 | Actions event behavior | [GitHub Actions events][gh-events] |
| GH-9 | Remote branch settings | [GitHub repository API][gh-repo-api] |
| LOCAL-1 | Cleanup implementation evidence | [git-cleanup.ps1][cleanup] |
| Repo-1 | Package ownership | [repository knowledge][repo-knowledge] |

## Working gaps

The requested legacy semantic-release GitBook pages are discontinued. Current
release claims use `semantic-release.org` and the live source repository. Some
older GitHub PR best-practices and automatic-deletion URLs returned 404 in the
research snapshot; do not present them as verified evidence. No stable source
was verified for an agent session-stop event that owns local deletion, so any
future session hook stays advisory and report-only until its runtime contract is
tested.

## Related evidence

The dated research snapshot contains the retrieval date, section anchors, and
complete source table:

- [MartiX Git research](../../../docs/martix/martix-git/martix-git-research.md)
- [MartiX Git requirements](../../../docs/martix/martix-git/martix-git-requirements.md)

[cc]: https://www.conventionalcommits.org/en/v1.0.0/
[cb]: https://conventionalbranch.org/
[cb-spec]: https://conventionalbranch.org/v1.1.0/spec.json
[semver]: https://semver.org/
[sr-intro]: https://semantic-release.org/intro/
[sr-config]: https://semantic-release.org/usage/configuration/
[sr-analyzer]: https://github.com/semantic-release/commit-analyzer
[git-commit]: https://git-scm.com/docs/git-commit
[githooks]: https://git-scm.com/docs/githooks
[git-worktree]: https://git-scm.com/docs/git-worktree
[git-ref]: https://git-scm.com/docs/git-check-ref-format
[gh-issues]: https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue
[gh-api]: https://docs.github.com/en/rest/pulls/pulls?apiVersion=2022-11-28
[gh-cli]: https://cli.github.com/manual/gh_pr
[gh-merge]: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/about-merge-methods-on-github
[gh-protection]: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches
[gh-rulesets]: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets
[gh-events]: https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows
[gh-repo-api]: https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28
[cleanup]: ../../../../scripts/git-cleanup.ps1
[repo-knowledge]: ../../../knowledge/repository/knowledge.md
