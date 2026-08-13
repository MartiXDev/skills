# Orders and Catalog: MartiX application plan

## Planning stance

No consuming application repository or Platform package version was provided.
This is therefore an application-owned target plan, not a claim that a
particular generator or extension method is already shipped. Before
implementation, verify the target framework, package references,
`martix.platform.json`, generated manifest, and the current Platform checkout.
The topology and lifecycle below follow the current modular-monolith fixture
shape; exact package APIs must be checked against that evidence.

## Selected profile

- **Preset:** `modular-monolith`.
- **Transport:** ASP.NET Core Minimal APIs.
- **Database:** PostgreSQL through EF Core/Npgsql, with a schema owned by each
  module.
- **Business modules:** `Orders` and `Catalog`; add another module only for a
  genuine business capability.
- **Processes/projects:** one API, one one-shot Migrator, one project per
  genuine Business Module, and one consolidated test project. Do not create a
  project merely for a technical layer.
- **Capabilities/providers:** record the selected preset, PostgreSQL provider,
  modules, and Platform version in the manifest. An unselected capability must
  leave no packages, configuration, startup registration, or secret
  placeholders behind.

## Solution topology

```text
OrdersCatalog.sln
├─ src/
│  ├─ OrdersCatalog.Api/
│  │  └─ Program.cs                         # HTTP composition root
│  ├─ OrdersCatalog.Migrator/
│  │  └─ Program.cs                         # validate | script | apply
│  └─ Modules/
│     ├─ Orders/
│     │  ├─ Orders.csproj                    # one genuine module project
│     │  ├─ Contracts/                       # only public cross-module surface
│     │  ├─ Domain/
│     │  ├─ Features/
│     │  │  └─ CancelOrder/
│     │  └─ Infrastructure/                  # DbContext, mappings, migrations
│     └─ Catalog/
│        ├─ Catalog.csproj
│        ├─ Contracts/
│        ├─ Domain/
│        ├─ Features/
│        └─ Infrastructure/
└─ tests/
   └─ OrdersCatalog.Tests/                   # unit, slice, HTTP, provider tests
```

`Contracts` is the module's public surface (a separate Contracts assembly is
also acceptable if the verified template emits one). Domain, features,
endpoints, infrastructure, `DbContext`, mappings, migrations, and schemas
remain internal to the owning module. The API contains composition and
transport policy, not order or catalog behavior.

## Dependency rules

```text
OrdersCatalog.Api      ──compose──> Orders, Catalog
OrdersCatalog.Migrator ──migrate──> Orders, Catalog
Orders                   ─────────> Catalog.Contracts (optional)
Catalog                  ─────────> (none by default)
OrdersCatalog.Tests     ──test────> host and module seams
```

1. The graph is explicit, acyclic, and compile-time visible.
2. A module may reference another module's **Contracts only**. It must not
   reference the other module's Domain, Features, Infrastructure, endpoints,
   `DbContext`, tables, or migrations.
3. `Orders` should not depend on `Catalog` for `CancelOrder`; if a future order
   workflow needs catalog data, expose the smallest stable Catalog contract and
   keep the dependency one-way.
4. The API and Migrator may call deliberate module composition entry points,
   but they do not become shared business layers.
5. Keep the Platform kernel framework-independent. Do not move ASP.NET Core,
   EF Core, logging, or provider concerns into it.

## `CancelOrder` vertical slice

Keep the request, operation, mapping, validation, and focused tests together:

```text
Modules/Orders/Features/CancelOrder/
├─ CancelOrderEndpoint.cs
├─ CancelOrderRequest.cs
├─ CancelOrderOperation.cs
├─ CancelOrderResponse.cs       # only if the contract needs a body
└─ CancelOrderTests.cs
```

An illustrative flow is:

1. `POST /orders/{orderId}/cancel` binds the route/body and cancellation token.
   The endpoint performs transport validation only.
2. The endpoint invokes the explicitly registered, `internal sealed`
   `CancelOrderOperation`.
3. The operation performs the application authorization/ownership check,
   loads the smallest required order shape from `OrdersDbContext`, and calls a
   domain method such as `order.Cancel(actor, utcNow)`.
4. The domain owns invariants (for example, a shipped or already terminal order
   cannot be cancelled). The operation saves the change and owns the
   transaction boundary.
5. The operation returns a typed `Result`/`Result<T>`. The endpoint maps it at
   the HTTP edge: success to the documented success status (for example
   `204 No Content`), not-found to `404`, a violated cancellation invariant or
   concurrency conflict to an explicit `409`, and failures to RFC 9457 Problem
   Details with lower-case `orders.*` error codes.

Do not serialize Kernel results, EF entities, exceptions, or provider errors
directly. Keep authorization, response status, OpenAPI metadata, and error
responses explicit. If cancellation must be retry-safe, define an
operation-specific idempotency policy and test it; do not add a global
idempotency mechanism without a requirement.

## Explicit DI and endpoint composition

The exact names below are application-owned pseudocode; verify the installed
Platform surface before choosing helper APIs.

```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddProblemDetails();
builder.Services.AddExceptionHandler<ProblemDetailsExceptionHandler>();

OrdersModule.AddServices(builder.Services, builder.Configuration);
CatalogModule.AddServices(builder.Services, builder.Configuration);

var app = builder.Build();

app.UseExceptionHandler();
OrdersModule.MapEndpoints(app);
CatalogModule.MapEndpoints(app);

app.Run();
```

`OrdersModule.AddServices` explicitly registers the concrete
`CancelOrderOperation` (normally scoped) and the module's PostgreSQL
`DbContext`; `CatalogModule.AddServices` does the same for Catalog. The module
composition methods are deliberate public entry points, while operation,
domain, persistence, and endpoint implementation types remain internal.

Do not use assembly scanning, reflection discovery, a service locator, a
mandatory mediator/command bus, or an interface-per-handler layer. Introduce
an interface only for a real boundary, multiple implementations, or a
meaningful test seam.

## Persistence and migration boundary

- `Orders` owns `OrdersDbContext`, deterministic table/index names, UTC
  timestamps, its application-managed concurrency token, PostgreSQL schema,
  and its migrations. `Catalog` owns the corresponding artifacts.
- Direct EF Core from a slice operation is preferred when persistence is the
  use case. Do not add a generic repository or `IUnitOfWork`.
- Keep runtime and migration credentials/configuration distinct:
  - API: `ConnectionStrings:Database`.
  - Migrator: `ConnectionStrings:MigrationDatabase`.
  They may point at the same PostgreSQL server/database, but the migration
  identity should have only the deployment privileges it needs.
- The one-shot Migrator is the sole migration executor and exposes exactly
  `validate`, `script`, and `apply` for the current fixture shape. It invokes
  each module's migrations in an explicit order.
- API startup **must not migrate or seed**. Schema changes are a deployment
  step with visible preconditions, reviewed scripts/backups, and recorded
  postconditions. If seed data is required, make it an explicit operator
  command or deployment step, never a hidden startup side effect.
- If cancellation later publishes an integration event, write the business
  change and an Outbox message in one transaction and make consumers
  idempotent. Do not claim exactly-once transport.

## TDD and first verification steps

1. **Freeze the profile.** Verify the actual target framework, Platform/Npgsql
   package versions, manifest capabilities, connection names, module list, and
   whether the current checkout supports the intended generated shape. Reject
   unsupported combinations before writing source.
2. **Verify topology and boundaries.** Generate or scaffold the solution, then
   inspect project references and compile-time checks: exactly one API, one
   Migrator, Orders and Catalog module projects, and one consolidated test
   project; no module implementation or `DbContext` reference crosses a
   boundary; no dependency cycle exists.
3. **Start with red tests for the slice.** Add fast domain tests for allowed and
   forbidden order states, then operation/slice tests for success, missing
   order, authorization/ownership, repeated cancellation policy, cancellation
   token propagation, and optimistic-concurrency conflict. Add the smallest
   implementation to make them pass, then refactor.
4. **Run host and HTTP tests.** Verify explicit DI registration, route binding,
   status codes, Problem Details, OpenAPI response metadata, authorization, and
   exception handling. Confirm the endpoint remains thin and no scanner or
   mediator is required.
5. **Prove PostgreSQL behavior with PostgreSQL.** Run EF Core transaction,
   migration, concurrency, rollback, and any reliability tests against the
   configured PostgreSQL provider (an isolated disposable PostgreSQL instance
   is suitable). InMemory and SQLite can cover limited pure behavior but cannot
   prove provider semantics.
6. **Exercise the migration lifecycle.** Against an empty disposable database,
   run `validate`, inspect `script`, run `apply`, rerun validation, and verify
   the API can start without changing the schema. Check runtime and migration
   connection strings separately and verify no startup seed/migration occurs.
7. **Run production checks before calling the slice complete.** Verify fail-fast
   required configuration, secret redaction, structured logs/traces/metrics,
   readiness/liveness, graceful shutdown and request cancellation, bounded
   health/diagnostic output, and a threat-modelled authorization path.

The evidence should record the exact commands, provider/version, database
disposition, generated artifacts, and pass/fail result. A passing unit suite
alone is not evidence for PostgreSQL, migration, HTTP, concurrency, or
delivery claims.

## Intentionally not added by default

Do **not** start with microservices or a service per module, Kubernetes,
containers-as-architecture, a message broker, distributed cache/Redis, cloud
services, a UI/full-stack preset, a job scheduler, or a second API process.
Also omit generic repositories, `IUnitOfWork`, a mandatory mediator, global
scanning, catch-all `Shared`/`Common`/`Application` projects, speculative
abstractions, hidden startup migrations/seeding, a reliable-event subsystem
without an event requirement, broad global retries/rate limits, and Native AOT
or trimming claims that have not been verified for this exact profile.

FastEndpoints may be added later only as an adapter with the same HTTP and
failure contract; Minimal APIs remain the canonical transport for this plan.
