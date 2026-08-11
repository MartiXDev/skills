# Orders and Catalog: modular-monolith plan

## Baseline decisions

- Use the current supported .NET LTS, Minimal APIs, and one deployable web process.
- Use one PostgreSQL database initially, with a schema and `DbContext` owned by each
  module.
- Treat Orders and Catalog as bounded modules inside the process, not as services.
- Keep the first slice narrow: prove `CancelOrder` end to end before adding more
  order or catalog operations.
- Use TDD: domain invariants first, then the use-case handler, then the HTTP and
  PostgreSQL integration boundary.

## Solution topology

```text
MartiX.OrdersCatalog.sln
├── src/
│   ├── MartiX.OrdersCatalog.Api/
│   │   ├── Program.cs
│   │   ├── Composition/
│   │   └── Middleware/
│   ├── Modules/
│   │   ├── Orders/
│   │   │   ├── MartiX.Orders.csproj
│   │   │   ├── OrdersModule.cs              # public composition surface
│   │   │   ├── Domain/
│   │   │   │   ├── Order.cs
│   │   │   │   └── OrderStatus.cs
│   │   │   ├── Features/
│   │   │   │   └── CancelOrder/
│   │   │   └── Persistence/
│   │   │       ├── OrdersDbContext.cs
│   │   │       ├── Configurations/
│   │   │       └── Migrations/
│   │   └── Catalog/
│   │       ├── MartiX.Catalog.csproj
│   │       ├── CatalogModule.cs
│   │       ├── Domain/
│   │       ├── Features/
│   │       └── Persistence/
│   └── MartiX.SharedKernel/                  # optional, primitives only
├── tests/
│   ├── Architecture/
│   ├── Orders.UnitTests/
│   ├── Catalog.UnitTests/
│   └── Api.IntegrationTests/
└── build/                                    # CI/build scripts if needed
```

Each module is initially one assembly so its vertical slices remain easy to
navigate. If a module becomes large, split it into `Domain`, `Application`, and
`Infrastructure` projects without changing the dependency rules below. Module
implementation types should be `internal`; `OrdersModule` and `CatalogModule`
are the small public facades.

Catalog owns products, SKUs, prices, and catalog availability. Orders owns the
order aggregate and order lifecycle. When an order is created, it should store
the product facts needed for the order (for example, product ID and price
snapshot), rather than querying Catalog tables directly.

## Dependency rules

The intended project-level graph is:

```text
OrdersCatalog.Api ──> Orders
                   └─> Catalog
Orders ────────────> SharedKernel (only if genuinely needed)
Catalog ───────────> SharedKernel (only if genuinely needed)
```

Within a module:

1. Domain code contains invariants and value objects. It does not reference
   ASP.NET, EF Core, PostgreSQL, configuration, or an HTTP status code.
2. A feature handler depends on its domain and on module-owned ports/interfaces.
   It returns an application result, not `IResult`, `HttpResponse`, or an EF
   entity.
3. Persistence implements those ports and owns the module's `DbContext`,
   mappings, SQL, and migrations.
4. The endpoint is an adapter: bind/validate the request, call the handler, and
   map the result to HTTP.
5. The API host may compose modules and shared middleware, but must not reach
   into a module's `DbContext`, repositories, entities, or feature internals.
6. Orders and Catalog have no project reference to one another and do not share
   tables, EF entities, or cross-module foreign keys. Cross-module interaction,
   if later required, goes through an explicit public contract/facade or an
   in-process event. The receiving module owns the data it persists.
7. `SharedKernel` is not a dumping ground: it may contain stable technical
   primitives (for example, a clock abstraction), never Orders- or
   Catalog-specific policy.

Architecture tests should fail the build if these references or namespace
boundaries are violated.

## Vertical slice: `CancelOrder`

The feature should be organized around the use case rather than around a
global `Controllers`, `Services`, or `Repositories` directory:

```text
Modules/Orders/Features/CancelOrder/
├── CancelOrderEndpoint.cs       # POST /orders/{orderId}/cancel
├── CancelOrderRequest.cs
├── CancelOrderCommand.cs
├── CancelOrderHandler.cs
├── CancelOrderValidator.cs
├── CancelOrderResult.cs
└── CancelOrderTests.cs          # unit tests can live in the test project instead
```

The handler loads the order through an Orders-owned port, calls something such
as `Order.Cancel(reason, clock.UtcNow)`, and commits once. The aggregate, not
the endpoint, decides whether cancellation is allowed. A useful initial
contract is:

- missing order: `NotFound`;
- `Pending` or `Confirmed`: transition to `Cancelled`, return success;
- already `Cancelled`: return an idempotent success;
- `Shipped`, `Completed`, or another non-cancellable state: return a conflict;
- invalid ID/reason: validation failure.

The exact state policy should be captured by tests before implementation. The
endpoint should translate the application result to `204`, `404`, `409`, or
validation `400`/`422`; the handler must not know those codes. If cancellation
event publication is eventually needed, commit the aggregate first and add a
durable integration mechanism deliberately rather than hiding it in the
endpoint.

## DI and endpoint composition

The host owns process-wide concerns and invokes only module composition methods:

```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddProblemDetails();
builder.Services.AddAuthentication().AddJwtBearer();
builder.Services.AddAuthorization();
builder.Services.AddHealthChecks();

builder.Services.AddOrdersModule(builder.Configuration);
builder.Services.AddCatalogModule(builder.Configuration);

var app = builder.Build();
app.UseExceptionHandler();
app.UseAuthentication();
app.UseAuthorization();

app.MapOrdersEndpoints();
app.MapCatalogEndpoints();
app.MapHealthChecks("/health");
app.Run();
```

`AddOrdersModule` should explicitly register the Orders `DbContext`, options,
clock, feature handlers, validators, and persistence adapters. The Catalog
method does the same for Catalog. Prefer explicit registrations over
unbounded assembly scanning so startup behavior and module ownership are
visible. `MapOrdersEndpoints` should create a route group, apply the module's
authorization and endpoint metadata, and map feature endpoints. No module
should call `BuildServiceProvider`, resolve services from a service locator, or
mutate another module's registration.

The host can add common authentication, problem-details handling, structured
logging, rate limiting, tracing, and readiness/liveness checks. Module-specific
policies remain in the owning module.

## Persistence and migration boundary

Use one physical PostgreSQL database but isolate ownership:

```text
orders schema  -> OrdersDbContext, order tables, Orders migrations
catalog schema -> CatalogDbContext, catalog tables, Catalog migrations
```

Each module:

- sets its default schema explicitly;
- keeps its EF configurations and migrations in its own assembly;
- owns its migration history and database objects;
- exposes no `DbContext` to another module;
- uses module-local transactions for a use case.

Do not use `EnsureCreated` in production. In development and disposable
integration tests, a module-specific migrator may apply both contexts for
convenience. In deployment, run an explicit migration job (or an equivalent
release step) for `OrdersDbContext` and `CatalogDbContext` before switching the
application to code that requires the new schema. The web process should not
silently change production schema on every startup. Migrations must be
backward-compatible with the deployment sequence when rolling updates are
possible.

There should be no foreign key from `orders` to `catalog`. A workflow that
eventually spans both modules needs an explicit consistency decision (for
example, an outbox/in-process event) and tests for failure/retry behavior; it
must not be implemented as an accidental cross-module transaction.

## TDD and first verification steps

Implement in this order:

1. **Domain red tests:** cancellation is allowed for the selected states,
   forbidden after shipping/completion, records the cancellation data, and is
   idempotent if that is the chosen contract.
2. **Handler red tests:** missing order, successful cancellation, invalid
   command, forbidden state, and persistence failure. Use an in-memory fake
   for the port; do not use SQLite to pretend to be PostgreSQL.
3. **Endpoint tests:** verify route binding, authorization, result-to-status
   mapping, and problem-details responses.
4. **Database integration test:** start disposable PostgreSQL (for example,
   Testcontainers or a CI PostgreSQL service), apply the module migrations,
   execute `CancelOrder`, and read back the persisted state.
5. **Architecture and migration checks:** verify project references, create a
   fresh database, apply both module migration sets, and confirm health checks.

The first local/CI verification pass should be:

```text
dotnet restore
dotnet build --configuration Release --warnaserror
dotnet test tests/Architecture
dotnet test tests/Orders.UnitTests --filter CancelOrder
dotnet test tests/Api.IntegrationTests --filter CancelOrder
```

Then run the migration smoke test against a clean PostgreSQL instance and make
one HTTP request to `POST /orders/{id}/cancel`, checking the persisted status
and the health endpoint. CI should run the same tests against the supported
PostgreSQL version, not a different provider.

## Do not add by default

Do not start with microservices, one database per module, a service mesh, an
API gateway, Kubernetes, distributed transactions, or a message broker.
Also avoid a generic repository/unit-of-work framework, MediatR merely for
dispatching one handler, a full CQRS read/write platform, event sourcing,
event-sourced audit logs, Redis caching, Elasticsearch, a workflow engine,
background-job infrastructure, multi-tenancy, feature-flag infrastructure,
or a broad shared-kernel utility library.

Add an outbox, durable messaging, caching, search, or separate deployment only
when a concrete requirement and failure model justify it. The initial
production-oriented baseline is a small, explicit modular monolith with
strong boundaries, PostgreSQL-backed migrations, observable Minimal APIs, and
tests that prove the first vertical slice.
