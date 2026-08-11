---
description: "Companion guide for the MartiX Platform standalone skill package"
---

# MartiX Platform companion guide

This package distills the MartiX.Platform repository into an activation router,
atomic rules, decision maps, and authoring templates. It is intentionally
conservative because the library and its template system are still in preview.

## Source priority

Use [authority-map](./references/authority-map.md) before making a claim about
the Platform. The short order is:

1. The consuming application's checked-in source, package references, and
   manifest.
2. The Platform repository's current README, `AGENTS.md`, `CONTEXT.md`,
   `martix.platform.json`, source package READMEs, tests, and quality gates.
3. The approved Wayfinder blueprint and migration roadmap for target direction.
4. Historical Wayfinder files only for provenance and rationale.

When sources disagree, report the disagreement and choose the most conservative
path that can be verified in the current checkout. Never invent an extension
method, package, capability, provider, or migration from the blueprint.

## Working model

The Platform is a dependency-light base for future .NET web apps:

- `MartiX.Platform` is the framework-independent Kernel. Keep it free of
  hosting, DI, logging, JSON, ASP.NET Core, EF Core, and third-party concerns.
- `MartiX.Platform.AspNetCore` adapts Kernel failures to HTTP and Problem
  Details. Keep transport behavior at the edge.
- `MartiX.Platform.EntityFrameworkCore` owns persistence and reliable-event
  primitives. Keep persistence ownership inside each module.
- `MartiX.Platform.Analyzers` provides compile-time error-code diagnostics; do
  not treat analyzer presence as a substitute for runtime verification.

The current repository is a bootstrap/preview, not a promise that every
blueprint feature exists. The generated modular-monolith fixture is useful
evidence of shape, but it is not permission to apply templates over a live
application.

## Application review route

For a new or changed web application, work in this order:

1. Establish preset, capabilities, providers, module list, and dependency
   direction.
2. Draw the one-way composition graph: API -> module composition and Migrator;
   module Contracts may be referenced by other modules; implementation details
   stay internal.
3. Shape one use case as a vertical slice before multiplying abstractions.
4. Decide the failure contract, validation owner, persistence boundary, and
   idempotency/concurrency behavior.
5. Add focused tests first, then real-provider or host tests where behavior
   depends on EF Core, HTTP, serialization, migrations, or delivery.
6. Review security, diagnostics, health, cancellation, performance evidence,
   and migration operations before calling the slice complete.

## Composition rules

- Prefer concrete internal sealed types and small deep modules.
- Compose modules through explicit `AddServices` and `MapEndpoints` methods.
- Register concrete Application Operations directly. Add an interface only when
  a real boundary, multiple implementations, or a test seam requires it.
- Keep transport validation separate from application and domain rules.
- Use direct EF Core from an Application Operation when persistence is the
  use-case concern. Do not add a repository or unit-of-work layer by reflex.
- Treat a module's Contracts assembly as its public dependency surface. A
  module must not reference another module's Domain, Features, Infrastructure,
  endpoints, or `DbContext`.

## Reliability and operations

Reliable Events are observable at-least-once delivery primitives. They do not
claim exactly-once transport, global ordering, or a generic scanned event bus.
Make handlers idempotent and make delivery attempts, failures, retries, and
inbox receipts observable.

The API must not migrate or seed the database during startup. Keep migration
execution in the one-shot Migrator with explicit `validate`, `script`, and
`apply` commands. Keep secrets out of source and manifests; use environment or
managed secret configuration.

## Cross-skill boundaries

Use this package for architecture and Platform-specific decisions. Hand off
implementation details when another MartiX skill has the narrower authority:

- `martix-dotnet-csharp` for generic language, SDK, ASP.NET Core, EF Core, async,
  diagnostics, or security guidance.
- `martix-fastendpoints` for FastEndpoints-specific endpoint APIs.
- `martix-fluentvalidation` for validator design and localization.
- `martix-tunit` for TUnit and Microsoft.Testing.Platform mechanics.
- `martix-markdown` for package documentation maintenance.

Do not widen a small Platform question into a generic framework tutorial.
