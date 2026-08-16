# SemVer and semantic-release

## Purpose

Use this rule for version impact, release planning, Git tags, changelog policy,
or semantic-release configuration. Keep message validity, branch naming, and
release impact as separate decisions.

## SemVer contract

SemVer 2.0.0 defines a public API version as `MAJOR.MINOR.PATCH` with
non-negative numeric components and no leading zeroes. A patch is a
backward-compatible bug fix; a minor version adds backward-compatible public
functionality or deprecation; a major version represents incompatible public
API change. Increasing major resets minor and patch; increasing minor resets
patch.

Pre-release identifiers follow a hyphen and have lower precedence than the
associated normal version. Build metadata follows a plus sign and does not
affect precedence. Released contents are immutable; a changed release needs a
new version.

`1.2.3` is the SemVer value. `v1.2.3` is a common Git tag spelling, not the
SemVer string itself. Keep tag formatting in release configuration rather than
branch or commit parsing.

## semantic-release policy

semantic-release is optional automation. It analyzes history, calculates
impact, generates notes, creates a tag, prepares and publishes through
configured plugins, and notifies configured systems. Its default analyzer uses
Angular commit conventions. A Conventional Commits preset or custom
`releaseRules` must be explicitly configured and tested.

Separate the pipeline into verification, last-release discovery,
commit-analysis, notes, version, tag, publish, and notification. A dry run may
show the pending version and notes while skipping mutating prepare and publish
steps. Use full history when tags and commit analysis require it.

Release branches must be protected, credentials must be least privilege, and
PR validation must never publish. A configured release branch is not enough:
the current CI context, branch protection, history, analyzer, tag format, and
credentials must all be verified. Installation of this skill or plugin never
publishes a release.

## Workflow

1. Identify the public API impact and the source of release-significant commit
   messages. Do not infer a version from a branch prefix alone.
2. Inspect configured analyzer preset, release rules, release branches,
   `tagFormat`, history depth, credentials, and CI event.
3. Run verification and dry-run analysis. Show the proposed version, notes,
   tag, and publish boundary.
4. Require confirmation for publishing and revalidate the protected branch,
   CI context, credentials, and expected history immediately before it.
5. Report the observed tag and publication result. If a prerequisite is
   missing, refuse publication and explain the smallest remediation.

## Review checklist

- SemVer value and Git tag spelling are not conflated.
- Message validity is separate from analyzer release impact.
- Analyzer preset and custom rules are explicit.
- Dry run and full-history requirements are addressed.
- Release branch and credentials are protected and least privilege.
- PR validation and unapproved branches cannot publish.

## Source anchors

See [source-map.md](../references/source-map.md) for SemVer 2.0.0,
semantic-release defaults, configuration, and CI evidence.
