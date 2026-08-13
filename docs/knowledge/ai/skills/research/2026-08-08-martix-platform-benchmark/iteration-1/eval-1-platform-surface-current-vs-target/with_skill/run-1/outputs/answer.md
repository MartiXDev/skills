# MartiX.Platform surface: current versus target

## Current package surface

The safe rule is **use only the API present in the consumer's exact package/source version, and treat this checkout as preview evidence—not as a stable support promise**. Inspect the consumer's target framework, package references, `martix.platform.json`, generated-solution manifest, and composition first.

| Package | Safe boundary today | Status |
| --- | --- | --- |
| `MartiX.Platform` | Framework-independent Kernel contracts: immutable, sealed, factory-created `Result`, `Result<T>`, `Error`, and transport-neutral `ErrorKind`. It has no hosting, DI, logging, JSON, ASP.NET Core, EF Core, or third-party dependency. | Current source/API evidence; preview. |
| `MartiX.Platform.AspNetCore` | ASP.NET Core edge adapter. It explicitly registers Problem Details, maps `Result`, `Result<T>`, and `Error` failures to `ProblemHttpResult`, exposes `ProducesMartiXProblemDetails(...)`, and adds the OpenAPI Problem Details contract. | Current adapter source/API evidence; preview. |
| `MartiX.Platform.EntityFrameworkCore` | EF Core adapter for deterministic naming, UTC timestamps, application-managed concurrency, immutable non-materializing Specifications, and the Reliable Events persistence module. DbContexts, mappings, schemas, migrations, providers, subscriptions, and event contracts remain module-owned. | Current adapter source/API evidence; preview. |
| `MartiX.Platform.Analyzers` | `netstandard2.0` build-only Roslyn analyzer package; it has no runtime assembly/dependency. `MXP001` checks literal error-code shape and `MXP002` checks unauthorized `platform.` ownership. | Current analyzer evidence; warnings by default. |

The current source projects are packable as `0.1.0-preview.1`, but the canonical repository manifest is still `0.0.0-bootstrap` with empty `capabilities`, `providers`, and `supportClaims`. That is not a stable Supported release. Pin and verify the exact artifact/feed rather than using an unqualified “latest”.

## Current versus fixture versus target status

- **Current:** The four source projects, their READMEs, public API baselines, and compatibility tests prove the contracts listed above exist in the current checkout. This does not by itself prove production support for an arbitrary consumer.
- **Preview:** The Lean API Release Loop is an internal `0.1.0-preview` with no stability or public compatibility promise. The Modular Monolith Development Baseline is the first development-usable Experimental alpha, and is explicitly not production-ready.
- **Fixture evidence:** `tests\fixtures\ModularMonolithGeneratedSolution` demonstrates a generated API/Migrator/module/test shape and selected relational/reliable-event capabilities. Its manifest is `0.1.0-preview.1` but still has `supportClaims: []`. `RepositoryBootstrapGeneratedSolution` is a `0.0.0-bootstrap` fixture. A fixture proves shape and acceptance behavior; it is not a supported public API and is not permission to reapply templates over an application.
- **Target:** The approved Wayfinder blueprint is direction, not an implemented API. Its future package roles include `MartiX.Platform.AspNetCore.FastEndpoints`, `MartiX.Platform.IntegrationEvents.RabbitMq`, `MartiX.Platform.Templates`, and `MartiX.Platform.Tool`. Do not reference those, or target migration/tool commands, unless the exact package/source, public API, version, and gates exist in the checkout.

When the source, manifest, fixture, and blueprint disagree, the consumer and current Platform source/manifest win. An absent target API is a design/Platform-Migration item, not an extension method to invent.

## Error and HTTP contract guidance

- `Result` and `Result<T>` represent application outcomes; use their factory methods and inspect `IsSuccess`/`Errors` before reading `Result<T>.Value` (a failed result has no value). `Error` is immutable and carries a code, `ErrorKind`, safe description, and optional validation target. `ErrorKind` is transport-neutral (`Validation`, `RuleViolation`, `NotFound`, `Conflict`, `AuthenticationRequired`, `Forbidden`, `RateLimited`, `Unavailable`, or `Unexpected`), not an HTTP status code.
- Application error codes are lowercase owner-prefixed dot-separated segments. `platform.` is reserved for Platform-owned errors. `Error.Create(...)` validates this at runtime. `MXP001` reports a provably invalid literal code; `MXP002` reports a literal using `platform.`. Both are warnings by default, and `TreatWarningsAsErrors` can fail the consumer build. Runtime variables are not guessed by the analyzer, so runtime validation still matters.
- Return Kernel results from Application Operations and adapt them at the outward seam. The ASP.NET Core adapter owns RFC 9457 Problem Details, exception/failure mapping, HTTP status/problem-type mapping, and OpenAPI metadata. Register Problem Details explicitly and keep `UseExceptionHandler()` ordering visible and tested.
- **Never serialize Kernel `Result`/`Result<T>` directly as the wire contract.** Use typed success DTOs/results and map expected failures to the adapter's Problem Details contract. Keep transport validation separate from application/domain validation. If a claimed helper is not in the exact installed adapter, write an explicit mapping or stop and verify; do not guess an API.

## Persistence and Reliable Events boundary

- Use `Specification<TEntity>` only as an immutable, composable query description when a reusable query shape is useful. It can carry criteria, includes, ordering, deterministic paging, projection, and tracking policy; `Apply` transforms an `IQueryable` and does not materialize it. It is not a repository, unit of work, inherited mini-repository, or permission to query another module's context/tables. Application Operations use their owning `DbContext` directly.
- A reliable event flow writes the business change and immutable **Outbox Message** in one transaction. Per-subscription **Delivery Attempts** are leased/fenced independently; the serialized envelope crosses the transport seam; the consumer's **Inbox Receipt** and business effect commit atomically; acknowledgement follows consumer commit.
- The current safe guarantee is **observable at-least-once delivery** with retries, leases, failures, recovery, and receipts visible to operators. Do not claim exactly-once transport, global ordering, or duplicate-free delivery. A single business effect can be claimed only where a real Inbox/idempotency transaction proves it; external effects need their own durable intent.
- Verify lease expiry, rollback, retry, concurrency, replay/redelivery, and idempotency against the actual relational provider. InMemory or SQLite tests cannot prove provider-specific locking, isolation, migrations, or reliable delivery. Do not add a generic scanned event bus, generic repository, or `IUnitOfWork` by default.

## Verification before coding

1. In the consuming repository, record the target framework, exact `MartiX.Platform*` package versions (including the analyzer), `martix.platform.json`, generated manifest, selected capabilities/providers, and existing composition. Resolve any package/source/manifest mismatch before editing.
2. Confirm the claimed symbols against the exact package's public API and README, then run the relevant consumer build/tests with warnings as errors. For HTTP, verify Problem Details registration, exception-handler order, status mapping, OpenAPI, and serialization. For analyzers, test both literal and runtime-generated codes.
3. For EF/reliable events, prove Specification translation and timestamps/concurrency with the selected provider; prove atomic Outbox creation, lease fencing/expiry, crash redelivery, transactional Inbox deduplication, bounded retry/terminal failure, and observability with real-provider tests.
4. For any Wayfinder-only behavior, require an implemented package/API, exact version, generated-output presence/absence checks, and the named quality-gate evidence before coding against it. The root `supportClaims: []` means “do not call this Supported.” If evidence is absent, record a design or Platform Migration instead of assuming the target.

### Source anchors

- `C:\Git\MartiXDev\Platform\martix.platform.json`
- `C:\Git\MartiXDev\Platform\eng\quality-gates.json`
- `C:\Git\MartiXDev\Platform\src\MartiX.Platform\README.md` and `Results\`
- `C:\Git\MartiXDev\Platform\src\MartiX.Platform.AspNetCore\README.md`
- `C:\Git\MartiXDev\Platform\src\MartiX.Platform.EntityFrameworkCore\README.md`, `Specifications\`, and `ReliableEvents\`
- `C:\Git\MartiXDev\Platform\src\MartiX.Platform.Analyzers\README.md` and `Diagnostics\ContractDiagnosticsAnalyzer.cs`
- `C:\Git\MartiXDev\Platform\tests\Compatibility\` and `tests\fixtures\`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\platform-blueprint.md` and `migration-roadmap.md` (target direction only)
