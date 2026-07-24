# Repository agent guide

<!--
role: normative
verified: 2026-07-22
-->

Use this file as the preflight router for repository work. Package-local
`AGENTS.md`, `SKILL.md`, and `README.md` files add domain guidance but do not
replace repository contracts.

When writing plans or reporting information to me, be extremely concise.
Sacrifice grammar for the sake of concision.

## Before editing

1. Read [CONTEXT.md](./CONTEXT.md) for repository terminology.
2. Read [the repository overview](./docs/repo-overview.md) for architecture and
  ownership.
3. For custom AI artifacts, read
  [the artifact rules](./docs/custom-ai-artifact-rules.md).
4. For files under `skills/` or `plugins/`, read that package's `SKILL.md`,
  `AGENTS.md`, and `README.md` before changing it.
5. Check scoped instructions under `.github/instructions/` and preserve
  unrelated worktree changes.

Use [the documentation index](./docs/README.md) to load only additional guides
needed by the task.

## Standalone skill contract

- Put reusable domain knowledge in `skills/martix-*`; use `plugins/martix-*`
 only for bundled agents, prompts, instructions, hooks, MCP/LSP, or composed
 workflows.
- Start new packages from `templates/skill-package/` and keep the required
 package inventory aligned with the repository validator.
- Keep `SKILL.md` compact and routing-oriented. Put normative detail in
 `rules/`, supporting maps and dated facts in `references/`, and reusable
 scaffolds in `templates/`.
- Keep identity synchronized across `plugin.json`, `metadata.json`, package
 docs, and marketplace metadata when the task owns those surfaces.
- Update `metadata.json`, `assets/taxonomy.json`,
 `assets/section-order.json`, and evals when routes or package inventory move.

## Canonical eval contract

- A skill package has exactly one committed eval definition:
 `skills/<package>/evals/evals.json`.
- Use the repository schema from `templates/skill-package/evals/evals.json`:
 top-level `skill`, then an `evals` array with stable string IDs.
- Every eval declares `prompt`, `expected_output` or `expected_sections`,
 `model_tier`, `token_budget`, and boolean `parallel_safe`.
- Put positive and negative trigger scenarios in that same array. Mark negative
 cases with `negative_activation: true`; do not create `trigger-evals.json` or
 another package-local eval format.
- Generic skill-authoring tools may generate a temporary
 `query`/`should_trigger` array for description optimization. Treat it as a
 transient benchmark input outside the package, then merge durable scenarios
 into canonical `evals.json` using the repository schema.
- Changing the schema is a repository-level decision. Stop and request HITL
 instead of introducing a second format in one package.

## Ownership and parallel work

- Keep package-local work inside one package when possible.
- Treat `.github/plugin/marketplace.json`, root README files, shared templates,
 repository strategy docs, and `scripts/validate-repository.ps1` as
 coordinator-owned surfaces. See
 [parallel worktree guidance](./docs/parallel-worktree-guidance.md).
- Keep repository documentation in the docs tree. New research, planning,
  investigation, or comparison notes should be added under
  [docs/research](./docs/research/) or the relevant package folder under
  [docs](./docs/).
- Do not revert edits you did not make. Coordinate when concurrent changes
 overlap the same contract.

## Validation

Run focused checks first, then the repository completion signal:

```powershell
powershell -ExecutionPolicy Bypass `
 -File .\plugins\martix-markdown-automation\hooks\markdown-check.ps1 `
 -CheckOnly `
 -Path <changed-markdown-files>

powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1
```

Do not claim completion when validation fails. Report unrelated pre-existing
failures separately from failures caused by the current change.

## Agent skills

### Issue tracker

Issues are tracked in GitHub Issues; external pull requests are not a triage
request surface. See [issue tracker guidance](./docs/agents/issue-tracker.md).

### Triage labels

Triage uses `needs-triage`, `needs-info`, `ready-for-agent`,
`ready-for-human`, and `wontfix`. See
[triage label guidance](./docs/agents/triage-labels.md).

### Domain docs

This is a single-context repository with a root [CONTEXT.md](./CONTEXT.md).
Domain documentation and ADRs are created lazily; follow
[domain documentation guidance](./docs/agents/domain.md).
