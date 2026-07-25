# Repository agent guide

Use this as the preflight router. Keep responses concise. Package-local
`AGENTS.md`, `SKILL.md`, and `README.md` add package guidance; they do not
override repository contracts.

## Before editing

1. Read [CONTEXT.md](./CONTEXT.md), [the repository overview](./docs/repo-overview.md),
   and applicable [.github/instructions](./.github/instructions/).
2. For custom AI artifacts, read [the artifact rules](./docs/custom-ai-artifact-rules.md).
3. For `skills/` or `plugins/`, read that package's `SKILL.md`, `AGENTS.md`, and
   `README.md`.
4. Check the current branch and worktree. Preserve unrelated edits; never revert
   changes you did not make.

Load deeper guides through the [documentation index](./docs/README.md) only
when the task needs them.

## Package contracts

- Reusable domain knowledge belongs in `skills/martix-*`.
- Use `plugins/martix-*` for bundled agents, prompts, instructions, hooks,
  MCP/LSP, or composed workflows.
- Keep `SKILL.md` compact and routing-oriented; put detail in `rules/`,
  `references/`, and `templates/`.
- Keep package identity synchronized across `plugin.json`, `metadata.json`,
  package docs, assets, evals, and marketplace metadata when owned by the task.
- A skill has one canonical `skills/<package>/evals/evals.json` using the
  repository schema. Do not add alternate trigger-eval formats or change the
  schema without human approval.

See [custom AI artifact rules](./docs/custom-ai-artifact-rules.md) for the
full inventory and eval requirements.

## Ownership and documentation

- Keep package work inside one package where possible.
- Coordinator-owned surfaces include `.github/plugin/marketplace.json`, root
  READMEs, shared templates, repository strategy docs, and
  `scripts/validate-repository.ps1`; see [parallel worktree guidance](./docs/parallel-worktree-guidance.md).
- Put new research, plans, and comparisons under `docs/research/` or the
  relevant package's `docs/` folder.
- Issues are tracked in GitHub Issues. Use the [issue tracker guidance](./docs/agents/issue-tracker.md)
  and [triage labels](./docs/agents/triage-labels.md).

## Validation

Run focused checks first, then:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\plugins\martix-markdown-automation\hooks\markdown-check.ps1 `
  -CheckOnly -Path <changed-markdown-files>

powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1
```

Do not claim completion when validation fails; separate unrelated pre-existing
failures from failures caused by the change.
