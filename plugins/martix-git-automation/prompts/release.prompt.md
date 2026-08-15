---
name: martix-git release
description: Plan and optionally publish a verified semantic-release release from an approved protected context.
---

# /martix-git release

`release plan` is read-only. Validate `.martix-git.json`, explicit analyzer
preset and rules, tag format, full-history requirements, protected release
branch, credentials boundary, and PR-validation context with
`hooks/release-plan.ps1`.

`release publish` must run the plan first, then require a dry run and explicit
confirmation. Delegate to `hooks/release-publish.ps1`; it never publishes when
semantic-release is unavailable, release integration is disabled, the branch
is unapproved/unprotected, analyzer policy is missing, or the context is a
pull-request validation. Keep SemVer `1.2.3` separate from tag spelling such as
`v1.2.3` and report the source of release-significant commit messages.

Report verification and publication as separate phases. A dry run is not a
published release, and a release recommendation is not a release result.
