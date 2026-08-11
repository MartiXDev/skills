# Generated-solution lifecycle and migrations

## Purpose

Protect application ownership after generation and make schema or Platform
evolution explicit, reviewable, and recoverable.

## Default guidance

- The generated application becomes application-owned. Do not reapply the
  template over it; evolve it through explicit Platform Migrations or normal
  application changes.
- Keep the one-shot Migrator commands exactly `validate`, `script`, and `apply`
  for the current modular-monolith fixture. The API must not migrate or seed at
  startup.
- Use the migration connection string for migration operations and the runtime
  connection string for the API. Make preconditions and postconditions visible.
- For a Platform Migration, inspect the current manifest and generated state,
  plan a candidate, show the diff, stop on ambiguity, apply once, and verify
  the postconditions. Preserve the original manifest, playbook, backups, and
  immutable candidate evidence.
- “Never reapply” means a migration is recorded and not blindly replayed over
  user-owned source. A repeated invocation is an idempotent no-op or an
  explicit ambiguity/failure when preconditions no longer match.
- Keep Native AOT/trimming claims tied to the exact generated profile; schema
  migration and persistence profiles remain JIT-first until verified.

## Avoid

- Do not make API startup a hidden deployment tool.
- Do not overwrite application-owned files by rerunning a template.
- Do not promise rollback for irreversible data changes; document recovery and
  operator action instead.
- Do not treat a NuGet version bump as proof that schema, configuration, or
  generated topology is compatible.

## Review checklist

- [ ] Generated solution ownership is explicit.
- [ ] `validate`, `script`, and `apply` behavior is separately tested.
- [ ] API startup does not migrate or seed.
- [ ] Migration plan, evidence, backups, and ambiguity behavior are recorded.
- [ ] Release/package compatibility and generated-state compatibility are
  evaluated separately.

## Related files

- [Quality gates and release policy](./quality-gates-release-policy.md)
- [Authority and status](./foundation-authority-and-status.md)
- [Migration and support model](../references/migration-and-support-model.md)
- [Generated solution checklist](../references/generated-solution-checklist.md)

## Source anchors

- `C:\Git\MartiXDev\Platform\tests\fixtures\ModularMonolithGeneratedSolution\README.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\migration-roadmap.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\tickets\016-generated-solution-lifecycle.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\tickets\114-release-migration-policy.md`
