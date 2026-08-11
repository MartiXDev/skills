# Platform migration lifecycle

## 1. Classify the change

The baseline is a generated solution on Platform `0.1.0-preview.1` with the
`modular-monolith` preset, PostgreSQL, Minimal APIs, no UI, and no auth. The
preset, API style, UI choice, auth choice, and database provider do not change.

Adopting the later release **and enabling Quartz durable jobs** should therefore
be classified as an **in-place, additive Platform capability migration**. It is
not a preset migration or a fresh-generation request. It is also operationally
significant: Quartz introduces host registration, configuration, worker
lifecycle, persistent job/trigger data, database schema, deployment, and
recovery concerns. “Optional” means the feature can remain disabled; it does
not make an enabled durable-job store a harmless package change.

The exact semantic-version category (patch/minor/major) cannot be inferred
without the target version and its compatibility notes. Starting from a preview
also argues against assuming semantic-version safety. The migration inspection
must determine whether the target is backward-compatible, requires source
changes, or has a database/schema boundary.

## 2. Keep fixture commands separate from migration commands

The commands that created the fixture are historical scaffolding commands. They
establish the baseline and must not be rerun against the existing solution.
Templates are not an upgrade mechanism.

Use the target lifecycle as separate workflow stages (with the installed CLI's
exact syntax):

1. `platform migration inspect`
2. `platform migration plan`
3. `platform migration apply`
4. `platform migration recover`

Verification and approval are gates around `apply`; none of these stages means
“generate the solution again.”

## 3. Inspect, then plan

`inspect` should be read-only and record the source fingerprint (Platform
version, generated manifest, preset/options, project and lock files, database
provider, deployment configuration, and the repository/customization diff).
Compare it with the selected target release, its release notes and upgrade
notes, supported runtime/provider versions, Quartz integration requirements, and
any breaking changes. Confirm whether PostgreSQL is a supported Quartz store,
which schema migration is required, and whether existing jobs/triggers need a
conversion or drain.

The inspection must distinguish generated files from team-owned edits. It
should also prove that the desired target is still `modular-monolith` +
PostgreSQL + Minimal APIs + no UI + no auth, with Quartz explicitly enabled or
left disabled.

`plan` should produce an approved, immutable diff containing the target package
set, source/config changes, Quartz registration and options, schema/data steps,
deployment order, compatibility/maintenance window, tests, and manual actions.
For durable jobs, include scheduler pause/drain behavior, job identity and
misfire policy, time-zone/cluster settings, secrets, worker count, and an
idempotency/duplicate-execution policy.

## 4. Evidence required before apply and for recovery

Before `apply`, retain:

- the exact source and target versions/commits and the inspect output;
- the approved plan and its hash, including release/compatibility evidence;
- a clean build, focused tests, and a staging/smoke result for enqueue, persist,
  restart, execute, retry, and (where applicable) misfire behavior;
- a verified PostgreSQL backup or snapshot, restore-point identifier, and a
  successful restore rehearsal;
- versioned migration SQL/schema checksums, deployment artifacts, lock files,
  and configuration/secrets readiness (not secret values);
- a baseline health report and an inventory/export of existing jobs and
  triggers.

`apply` should leave an audit trail: preflight and backup IDs, migration logs,
schema version/checksum, deployed artifact, health checks, and post-migration
smoke results.

Recovery must be designed before applying. Keep the previous deployable
artifact and configuration, the verified restore point, job/trigger inventory,
logs/telemetry, and a tested runbook. Rollback of application binaries is safe
only when the database schema is backward-compatible; otherwise recovery is a
coordinated database restore plus the previous artifact, or a forward fix.
Define how paused, running, and partially executed jobs are handled so recovery
does not silently lose work or duplicate non-idempotent work.

## 5. Why templates are never reapplied

A template is a one-time scaffold, not a desired-state reconciler. Reapplying
it can overwrite custom code and configuration, reset deliberate options,
duplicate registrations, discard migrations, and destroy or disconnect live
job data. It cannot infer which generated files were subsequently changed or
coordinate application code with database and deployment state. A migration
uses the existing solution as the source of truth, applies an explicit
versioned diff, preserves team-owned changes, and records evidence. If a fresh
template is needed for comparison, generate it in a separate disposable
solution and compare it; do not apply it over the deployed solution.

## 6. Difference from a NuGet version bump

A NuGet bump changes package references and the lock/restore result. It does not
inspect the generated Platform contract, reconcile preset choices or custom
edits, register Quartz, provision/upgrade its PostgreSQL schema, migrate or
protect durable job data, coordinate worker deployment, or establish backup and
recovery evidence. A package bump may be one implementation step inside the
Platform migration, but it is not a substitute for the inspect → plan → apply →
recover lifecycle. Only inspection can establish that a release is truly
package-only and that Quartz remains disabled.
