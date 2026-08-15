---
description: 'Maintainer and companion guide for the martix-git standalone skill package'
---

# MartiX Git companion

Read the repository root [AGENTS.md](../../AGENTS.md), this package's
[SKILL.md](./SKILL.md), and [README.md](./README.md) before changing the
package. Keep reusable Git and GitHub knowledge here; keep workflow prompts,
adapters, hooks, and generated policy assets in the companion
[martix-git-automation plugin](../../plugins/martix-git-automation/README.md).

## Maintainer contract

- Keep `SKILL.md` compact and routing-focused.
- Put normative domain behavior in `rules/`, source and decision maps in
  `references/`, and reusable scaffolds in `templates/`.
- Keep Git, GitHub, Conventional Commits, Conventional Branch, SemVer, and
  semantic-release source ownership distinct from repository policy.
- Treat model-generated branch names, commit messages, PR text, and release
  plans as proposals until deterministic validation and human review pass.
- Keep cleanup report-first and reuse the repository cleanup engine's safety
  invariants rather than creating a second mutation model.
- Update metadata, taxonomy, section ordering, and evals when routes or package
  coverage change.

## Cross-surface handoffs

| Concern | Owner |
| --- | --- |
| Workflow assets | [martix-git-automation](../../plugins/martix-git-automation/README.md) |
| Repository policy | The consuming repository |
| Sandcastle lifecycle | Sandcastle |
| Deployment and general CI/CD | The relevant project skill or workflow |

- Hand off workflow assets when the task needs a prompt, script, native hook,
  CI template, or plugin-specific workflow.
- Hand off repository policy when the decision depends on local protection,
  allowed types or scopes, merge method, or release configuration.
- Hand off Sandcastle lifecycle work when the task asks to create, close,
  archive, or mutate a Sandcastle session or worktree.
- Hand off deployment and general CI/CD when the request is not about Git
  policy, release evidence, or lifecycle safety.

## Validation

Run focused JSON and Markdown checks for changed files, then:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1
```

The repository validator may report unrelated missing links under generated
or ignored worktree content. Separate those baseline findings from package
failures before reporting completion.
