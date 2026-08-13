# Generated Solution review checklist

Use this before accepting a generated or migrated application.

## Selection and topology

- [ ] Preset, Platform version, provider, capabilities, and modules are recorded.
- [ ] Invalid combinations fail before generation.
- [ ] Unselected capabilities leave no projects, references, configuration,
      startup registration, or secret placeholders.
- [ ] One API, one Migrator, one project per genuine module, and one
      consolidated test project are present unless a boundary justifies more.
- [ ] Module graph is acyclic and cross-module references target Contracts only.

## Runtime and contracts

- [ ] API composes modules explicitly through `AddServices` and
      `MapEndpoints`.
- [ ] Features use vertical slices with thin endpoints and sealed operations.
- [ ] Result/Error codes are typed, owned, lower-case, and documented.
- [ ] Problem Details and exception handling are explicit.
- [ ] Authorization, audit, correlation, health, and redaction are testable.

## Persistence and delivery

- [ ] Module owns its context, schema, mappings, and migrations.
- [ ] API uses `ConnectionStrings:Database`.
- [ ] Migrator uses `ConnectionStrings:MigrationDatabase`.
- [ ] API does not migrate or seed at startup.
- [ ] Outbox, attempts, leases, inbox receipts, retry, and idempotency are
      provider-tested where enabled.

## Verification

- [ ] TDD slice tests pass.
- [ ] Real-provider integration tests cover database claims.
- [ ] Capability presence and absence tests pass.
- [ ] Quality-gate profile and evidence are recorded.
- [ ] AOT/performance claims name the exact verified profile.
- [ ] No secrets or generated artifacts are accidentally committed.
