---
name: martix-dotnet-csharp
description: Standalone-first .NET 10+ and C# 14+ guidance for code review, modernization, refactoring, and scaffolding. Use when working on SDK-style projects, ASP.NET Core, minimal APIs, EF Core, async flows, diagnostics, testing, security, or modern C# features. Trigger this skill for questions about the options pattern, TypedResults, `ValidateOnStart()`, HTTP resilience, `WebApplicationFactory`, extension blocks, channels, problem details, middleware ordering, or common app bootstrap defaults.
license: Complete terms in LICENSE.txt
---

## MartiX .NET 10 and C# 14 router

- Standalone-first skill package focused on released .NET 10+ and C# 14+
  practices.
- Keep decisions grounded in the bundled rule files and Microsoft-backed
  reference maps.
- Use [AGENTS.md](./AGENTS.md) when the task crosses multiple domains or needs a
  longer review flow.

## When to use this skill

- Review or modernize SDK-style .NET projects.
- Shape ASP.NET Core or Minimal API services.
- Refactor async code, cancellation flows, or background work.
- Tune hot paths, spans, collections, or allocation-sensitive code.
- Review EF Core, JSON contracts, diagnostics, testing, or security defaults.
- Answer concrete bootstrap questions such as options binding,
  `ValidateOnStart()`, TypedResults, problem details, `WebApplicationFactory`,
  HTTP client resilience, extension blocks, or channels.

## Quick-start defaults

Use this section for the first pass, then move into the domain rules and maps
below for the specific change.

### Minimal `.csproj` baseline

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>net10.0</TargetFramework>
    <LangVersion>14</LangVersion>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
  </PropertyGroup>
</Project>
```

### Short `Program.cs` bootstrap

```csharp
using System.ComponentModel.DataAnnotations;

var builder = WebApplication.CreateBuilder(args);

builder.Services
    .AddOptions<ApiOptions>()
    .BindConfiguration(ApiOptions.SectionName)
    .ValidateDataAnnotations()
    .ValidateOnStart();

builder.Services.AddProblemDetails();
builder.Services.AddOpenApi();
builder.Services.AddHttpClient("weather")
    .AddStandardResilienceHandler();

var app = builder.Build();

app.UseExceptionHandler();

app.MapGet("/health", () => TypedResults.Ok(new { status = "ok" }));

app.Run();

sealed class ApiOptions
{
    public const string SectionName = "Api";

    [Required]
    public string BaseUrl { get; init; } = string.Empty;
}
```

### Middleware ordering reminder

- Put exception handling and problem details early so failures are translated
  consistently.
- Run HTTPS, static files, CORS, authentication, authorization, rate limiting,
  and similar cross-cutting middleware before endpoint mapping.
- Keep endpoint registration near the end so the request pipeline stays easy to
  trace.

## Default patterns

| Concern | Default | Escalate when |
| --- | --- | --- |
| Web entrypoint | Start with minimal APIs for focused HTTP surfaces. | Use controllers when filters, conventions, or richer MVC features pay off. |
| HTTP results | Prefer TypedResults and problem details for explicit contracts. | Introduce a result envelope only when the API needs a stable shared error shape. |
| Configuration | Use the options pattern with validation and `ValidateOnStart()`. | Switch option lifetime or refresh behavior only when the host truly needs it. |
| Outbound HTTP | Use typed clients with `IHttpClientFactory` and standard HTTP resilience. | Add custom retry, timeout, hedging, or circuit-breaker policy only when measured. |
| Testing | Start host-level API tests with `WebApplicationFactory<Program>`. | Add narrower unit tests or broader infrastructure tests as the behavior demands. |
| Concurrency | Use channels for producer-consumer pipelines with backpressure needs. | Use other primitives only when contention or ownership makes channels a poor fit. |
| Modern C# | Use current toolchain defaults and small readability wins first. | Reach for extension blocks only on .NET 10+ when they reduce noise clearly. |
| Failure handling | Validate early, throw precise exceptions, and log useful context. | Use alternate result types when failure is expected and not exceptional. |

## Start with the source boundary

1. Read the
   [source index and guardrails](./references/doc-source-index.md).
2. Pick the closest domain map below.
3. Read only the linked rules needed for the current change.
4. Open [AGENTS.md](./AGENTS.md) for cross-domain review routes and package
   maintenance notes.

## Bootstrap and reference routes

- Use the quick references below when you need copy-ready entrypoint patterns,
  then return to the rule library for detailed review guidance.
- References:
  - [Anti-patterns quick reference](./references/anti-patterns-quick-reference.md)
  - [Web bootstrap recipes](./references/web-bootstrap-recipes.md)
  - [Testing bootstrap recipes](./references/testing-bootstrap-recipes.md)
  - [Libraries catalog](./references/libraries-catalog.md)

## Rule library by domain

### Language

- Use for released-feature adoption, branch clarity, and nullability contracts.
- Rules:
  - [Modern C# features](./rules/lang-modern-features.md)
  - [Pattern matching](./rules/lang-pattern-matching.md)
  - [Nullability and contracts](./rules/lang-nullability.md)
- Map: [C# language map](./references/csharp-language-map.md)

### SDK and build

- Use before changing `.csproj`, `global.json`, shared props or targets, or
  validation commands.
- Rules:
  - [SDK-style projects and repository build structure](./rules/sdk-project-system.md)
  - [Build, test, pack, and publish](./rules/sdk-build-test-pack-publish.md)
- Map: [Dotnet SDK and build map](./references/dotnet-sdk-map.md)

### Runtime and performance

- Use for spans, memory ownership, collection choice, immutability, and hot-path
  work.
- Rules:
  - [Memory, spans, and hot-path performance](./rules/runtime-memory-spans.md)
  - [Collections, concurrency, and immutability](./rules/runtime-collections-immutability.md)
- Map: [Runtime and BCL map](./references/runtime-bcl-map.md)

### Async and concurrency

- Use for `Task` vs `ValueTask`, streaming, cancellation, synchronization, and
  channels.
- Rules:
  - [Tasks, ValueTasks, async streams, and API shape](./rules/async-tasks-valuetasks.md)
  - [Cancellation and timeouts](./rules/async-cancellation-timeouts.md)
  - [Concurrency, synchronization, and channels](./rules/async-concurrency-channels.md)
- Map: [Async and concurrency map](./references/async-map.md)

### Design

- Use for API shape, type boundaries, validation, exception behavior, and
  dependency decisions.
- Rules:
  - [API and type design](./rules/design-api-type-design.md)
  - [Exceptions, validation, and failure contracts](./rules/design-exceptions-validation.md)
- Map: [Design map](./references/design-map.md)

### Web, data, quality, and security

- Web:
  - [HTTP clients and resilience](./rules/web-http-resilience.md)
  - [ASP.NET Core application shape](./rules/web-aspnet-core.md)
  - [Web stack map](./references/web-stack-map.md)
- Data:
  - [Serialization and payload contracts](./rules/data-serialization.md)
  - [Entity Framework Core](./rules/data-efcore.md)
  - [Data and serialization map](./references/data-stack-map.md)
- Quality and security:
  - [Unit and integration testing](./rules/testing-unit-integration.md)
  - [Logging, metrics, tracing, and health signals](./rules/diagnostics-logging-tracing.md)
  - [Authentication, authorization, and secure defaults](./rules/security-auth-authz.md)
  - [Quality, diagnostics, and security map](./references/quality-security-map.md)

## Package conventions

- Every rule follows the same section contract in
  [rules/_sections.md](./rules/_sections.md): `Purpose`, `Default guidance`,
  `Avoid`, `Review checklist`, `Related files`, and `Source anchors`.
- Use [the rule template](./templates/rule-template.md) for new rules,
  [the research pack template](./templates/research-pack-template.md) for future
  research packs, and
  [the comparison matrix template](./templates/comparison-matrix-template.md)
  for external comparisons.
- The taxonomy and preferred ordering live in
  [assets/taxonomy.json](./assets/taxonomy.json) and
  [assets/section-order.json](./assets/section-order.json).

## Standalone-first note

- This skill is authored as a standalone package under `src\skills`.
- If you document or install the package directly, use
  `npx skills add <source>` rather than `npx skill add`.
- The highest-priority local brief remains
  [docs\martix-dotnet-csharp\martix-dotnet-csharp.md](../../../docs/martix-dotnet-csharp/martix-dotnet-csharp.md).
