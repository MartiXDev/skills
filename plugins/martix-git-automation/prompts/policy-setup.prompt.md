---
name: martix-git policy setup
description: Inspect existing repository tooling and propose bounded Git hook and CI policy setup.
---

# /martix-git policy setup

Inspect package manager, language, `.martix-git.json`, existing Git hooks,
`core.hooksPath`, CI workflows, and available validators before proposing
policy. Prefer existing Husky, lint-staged, commitlint, native commands, and
repository CI over a parallel framework.

Present separate proposals for `commit-msg`, bounded staged checks,
optional bounded `pre-push`, CI parity, and GitHub protection. Show every file,
command, dependency, permission, installation step, bypass path, uninstall
path, and failure exit code.

Use `hooks/validate-config.ps1` before enabling policy. Installation is a
separate confirmed phase delegated to `hooks/install-hooks.ps1`; existing
user-owned hooks require explicit replacement approval and are backed up. Do
not install cleanup, release publishing, network-only checks, hook bypass, or
an unbounded full build. Classify `inspect`, `propose`, `install`, and `verify`
as `perform`, `skip`, `ask`, or `block`. Support `--dry-run` as a report-only
plan. After installation, re-read the configured hooks, ownership markers,
backups, and effective configuration, then report the final observed state.
