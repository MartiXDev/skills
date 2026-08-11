# Platform migration lifecycle

## Upgrade classification

First establish the baseline from the consuming repository: target framework, exact `MartiX.Platform` package references and lock file, `martix.platform.json`/Generated Solution manifest, generated source, current composition, and database schema state. The preview version and the current bootstrap manifest make support claims conservative; current source, tests, fixtures, and quality gates outrank a blueprint or a capability name.

Use these categories:

- **Compatible package upgrade:** a same-major minor/patch update with no deprecated contract use and no change to generated source, dependencies, configuration, schema, or operational contracts. Verify the package, manifest, generated diff, and tests.
- **Platform Migration (migrated upgrade):** the selected change alters any of those surfaces and therefore needs an explicit, reviewable migration.
- **Breaking upgrade:** a cross-major or otherwise incompatible contract change, requiring the release policy and an application migration plan.
- **Unknown:** evidence is missing; stop and inspect rather than infer compatibility.

For this case, merely installing a later package while retaining the exact existing profile and leaving Quartz unselected might be a compatible package upgrade. **Selecting Quartz durable jobs is normally a Platform Migration**, because it can add package references, generated registration/configuration, durable storage/schema, and scheduler health, failure, deployment, and recovery contracts. Confirm that classification against the target release's manifest, source, tests, and quality-gate profile. Do not call Quartz Supported merely because the release or Wayfinder describes it; it must have the named evidence and support state (Supported, Experimental, or Deferred).

## Current fixture versus target workflow

The current modular-monolith fixture has one API, one one-shot Migrator, module-owned persistence, and explicit composition. Its evidenced Migrator command names are exactly:

```text
validate
script
apply
```

The API must not migrate or seed at startup. The API uses `ConnectionStrings:Database`; the Migrator uses `ConnectionStrings:MigrationDatabase`.

The target migration lifecycle is a **workflow model**, not additional current fixture CLI evidence:

```text
inspect -> plan (candidate and diff) -> apply once -> verify postconditions
```

`inspect` records the baseline and `plan` describes a candidate; they are not commands to invent for this fixture. Likewise, there is no evidenced fixture `migrate` command. Use the fixture's `validate`, `script`, and `apply` commands as documented, and do not relabel them as target `inspect` or `plan`. The word `apply` appears in both vocabularies, but the target phase means applying an approved candidate after its preconditions pass.

## Plan, apply, and verification evidence

### Inspect and plan

Record an immutable baseline containing the original `0.1.0-preview.1` manifest, package versions/lock file, target framework, preset (`modular-monolith`), PostgreSQL provider, Minimal APIs, selected modules/capabilities, and the intentional absence of UI and auth. Capture generated-file hashes or a clean source snapshot, migration history/schema snapshot, configuration shape, connection-string ownership, and the current quality-gate result.

Inspect the exact target release and its migration playbook—not only a target blueprint. Compare the old and new manifest, generated/configuration/dependency diff, schema or migration script, and operational changes. Determine whether Quartz is optional, which provider combinations are valid, what it persists, how startup and shutdown behave, and what health, telemetry, security, retry, and recovery behavior is promised. Reject invalid selections before generation. A negative generation check must show that an unselected Quartz capability leaves no projects, package references, configuration, registration, health checks, or secret placeholders; a selected-capability check must show only the intended additions.

The plan should identify application-owned files requiring a deliberate merge, preconditions, postconditions, deployment order, known limitations, and every irreversible operation. Stop on an ambiguous baseline, unsupported combination, missing schema evidence, or missing quality-gate evidence.

### Apply prerequisites and evidence

Before applying an approved candidate, preserve:

- the original manifest and exact package/source versions;
- the migration playbook and generated/configuration/schema diff;
- a schema/database backup or provider-appropriate snapshot where the candidate changes persistence;
- an immutable candidate record containing source/version, manifest, commands, environment, provider, tests, generated diff, and known limitations;
- explicit limits for destructive or otherwise irreversible operations, with operator actions;
- a tested recovery or forward-fix procedure and the previous runnable application artifact.

Use the Migrator and the migration connection string, never hidden API startup work. Apply once, atomically where PostgreSQL and the deployment boundary permit it; do not imply that source deployment and a database change are universally atomic. Keep secrets in environment/managed configuration.

### Verify and recover

Postcondition evidence should cover source/build/tests, schema version/state, health, runtime behavior, and the exact modular-monolith/PostgreSQL/Minimal-API/Quartz profile. Include positive, negative, failure, and recovery paths: durable job behavior across the relevant restart/failure cases, database/provider failures, bounded or fail-fast scheduler behavior, observability, and absence of UI/auth artifacts. Re-run real PostgreSQL integration/provider tests for schema, transactions, concurrency, and recovery claims; InMemory or SQLite alone is not proof. Record the immutable results and known limitations.

Recovery is evidence, not a promise of universal rollback. Retain the backup, prior manifest/packages/binary, candidate ID, migration history, logs, failed-postcondition output, and restore/forward-fix steps. Destructive data changes may require restore or an explicitly documented forward fix and operator intervention; never claim that every migration can be reversed.

## Ownership and the never-reapply rule

Generation is the initial scaffold boundary. Once accepted, the Generated Solution is application-owned. Rerunning a template must not overwrite application changes, silently regenerate topology, or merge Quartz into user-owned source. Adopt the capability through an explicit Platform Migration and normal application commits, with human review of the candidate diff.

A recorded migration must not be blindly replayed. Repeating it should be an idempotent no-op when the recorded version and postconditions already hold, or an explicit ambiguity/precondition failure when the source, manifest, or schema no longer matches. This protects both source ownership and durable data.

## NuGet versus Platform Migration

A NuGet version bump changes the package graph; it can be sufficient when the application profile and all generated, schema, configuration, and operational contracts remain unchanged. It still needs restore/build/test and compatibility verification, but it does not regenerate application-owned files or prove schema compatibility.

A Platform Migration is the coordinated evolution of the Generated Solution and, when applicable, its configuration, dependencies, schema, runtime behavior, and operational contracts. A package update may be one step inside it, but is not a substitute for inspect/plan/apply/verify evidence, backups, postconditions, and recovery planning. Thus, “upgrade the package” is not evidence that Quartz durable jobs are generated, persisted, observable, recoverable, or supported.
