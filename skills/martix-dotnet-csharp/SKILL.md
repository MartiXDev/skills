---
name: martix-dotnet-csharp
description: Standalone-first .NET 10+ and C# 14+ guidance for code review, modernization, refactoring, and scaffolding. Use when working on SDK-style projects, ASP.NET Core, minimal APIs, EF Core, async flows, diagnostics, testing, security, or modern C# features. Trigger for options pattern, TypedResults, `ValidateOnStart()`, HTTP resilience, `WebApplicationFactory`, channels, problem details, or middleware ordering. Do not trigger for FastEndpoints-specific routing or FluentValidation validator authoring; hand off to martix-fastendpoints or martix-fluentvalidation instead.
license: Complete terms in LICENSE.txt
---

## MartiX .NET 10 and C# 14 router

- Standalone-first package for released .NET 10+ and C# 14+ practices.
- Ground decisions in the bundled rule files and Microsoft-backed reference
  maps.
- Use [AGENTS.md](./AGENTS.md) when the task crosses domains or needs a longer
  review flow.

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

Use this section for the first pass, then open the domain rule or map needed.

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

1. Read the [source index and guardrails](./references/doc-source-index.md).
2. Pick the closest domain map below.
3. Read only the linked rules needed for the current change.
4. Open [AGENTS.md](./AGENTS.md) for cross-domain review routes and package
   maintenance notes.

## Bootstrap and reference routes

- Use the quick references below for copy-ready entrypoint patterns, then return
  to the rule library for detailed review guidance.
- References:
  - [Anti-patterns quick reference](./references/anti-patterns-quick-reference.md)
  - [Web bootstrap recipes](./references/web-bootstrap-recipes.md)
  - [Testing bootstrap recipes](./references/testing-bootstrap-recipes.md)
  - [Libraries catalog](./references/libraries-catalog.md)

## Domain routing table

| Domain | Rule files | When |
| --- | --- | --- |
| Language | [lang-modern-features](./rules/lang-modern-features.md), [lang-pattern-matching](./rules/lang-pattern-matching.md), [lang-nullability](./rules/lang-nullability.md) | Modernizing syntax, branch clarity, or nullability contracts |
| SDK and build | [sdk-project-system](./rules/sdk-project-system.md), [sdk-build-test-pack-publish](./rules/sdk-build-test-pack-publish.md) | Editing `.csproj`, `global.json`, or build workflow |
| Runtime and performance | [runtime-memory-spans](./rules/runtime-memory-spans.md), [runtime-collections-immutability](./rules/runtime-collections-immutability.md) | Hot paths, spans, large buffers, or collection choices |
| Async and concurrency | [async-tasks-valuetasks](./rules/async-tasks-valuetasks.md), [async-cancellation-timeouts](./rules/async-cancellation-timeouts.md), [async-concurrency-channels](./rules/async-concurrency-channels.md) | `Task` vs `ValueTask`, cancellation, channels, or background work |
| Design | [design-api-type-design](./rules/design-api-type-design.md), [design-exceptions-validation](./rules/design-exceptions-validation.md) | New public APIs, DI boundaries, or exception contracts |
| Web | [web-aspnet-core](./rules/web-aspnet-core.md), [web-http-resilience](./rules/web-http-resilience.md) | ASP.NET Core shape, Minimal APIs, or outbound HTTP |
| Data | [data-serialization](./rules/data-serialization.md), [data-efcore](./rules/data-efcore.md) | JSON contracts or EF Core modeling and queries |
| Quality and security | [testing-unit-integration](./rules/testing-unit-integration.md), [diagnostics-logging-tracing](./rules/diagnostics-logging-tracing.md), [security-auth-authz](./rules/security-auth-authz.md) | Testing strategy, observability, or auth defaults |

See [AGENTS.md](./AGENTS.md) for cross-domain review routes, maps, and package maintenance notes.

## Handoff triggers

| Hand off to | When |
| --- | --- |
| `martix-fastendpoints` | The API surface is explicitly FastEndpoints — `IEndpoint`, endpoint groups, pre/post-processors, or FastEndpoints-specific route configuration. |
| `martix-fluentvalidation` | Validation is a first-class design topic with reusable validators, RuleSets, async rules, localization, or `FluentValidation.TestHelper` usage. |
