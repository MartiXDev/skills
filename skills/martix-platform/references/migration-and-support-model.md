# Migration and support model

Use this map when a Platform version, generated topology, schema, or capability
changes.

## Upgrade categories

| Category | Meaning | Required action |
| --- | --- | --- |
| Compatible upgrade | Same-major minor/patch change with no deprecated contract use | Verify package, manifest, generated diff, and tests |
| Migrated upgrade | Requires an explicit Platform Migration | Inspect, plan, apply once, and verify postconditions |
| Breaking upgrade | Cross-major or incompatible contract change | Follow the release policy and application migration plan |
| Unknown | Evidence is missing | Stop and inspect; do not infer compatibility |

A NuGet package bump is not automatically a Generated Solution or schema
upgrade. A Platform Migration is distinct when source topology, configuration,
dependencies, schema, or operational contracts change together.

## Migration workflow

1. `inspect`: record Platform version, manifest, selected profile, generated
   state, and current schema.
2. Plan one candidate and show the generated/configuration/schema diff.
3. Stop on ambiguity or missing preconditions.
4. Apply the approved candidate atomically where the provider permits it.
5. Verify source, schema, health, tests, and runtime postconditions.
6. Preserve the original manifest, playbook, backups, candidate evidence, and
   known irreversible operations.

The current fixture's operational commands are `validate`, `script`, and
`apply`; do not invent an `inspect` or `migrate` command for that fixture.
Those names describe the target lifecycle workflow, not current CLI evidence.

## Never reapply

Once a migration is recorded, do not blindly replay it over user-owned source.
A repeated invocation should be an idempotent no-op or an explicit ambiguity
failure when preconditions no longer match. Templates are never reapplied over
an application-owned Generated Solution.

## Source anchors

- `C:\Git\MartiXDev\Platform\CONTEXT.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\migration-roadmap.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\tickets\016-generated-solution-lifecycle.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\tickets\114-release-migration-policy.md`
