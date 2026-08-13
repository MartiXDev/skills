# MartiX.Platform surface: current versus target

## Short answer

Do not treat the names in the question as a currently supported MartiX runtime API. In this checkout, `martix-platform` is a **standalone guidance/knowledge skill** under `skills\`; it is not a .NET implementation, NuGet package, analyzer distribution, or event-delivery runtime. `plugins\martix-*` are workflow bundles and do not establish ownership of platform assemblies. The Wayfinder material is blueprint/reference material, not a shipped contract.

Use a MartiX-specific API only when the target solution itself resolves a versioned package/project reference and a small compile/test probe confirms the exact namespace, visibility, target framework, and behavior.

## Evidence classification

| Claim | What can safely be concluded now |
|---|---|
| `Result<T>` and `ErrorKind` | Treat as proposed/preview surface unless the target repository supplies a versioned implementation. Do not assume a universal result type, error taxonomy, constructors, or serialization contract. |
| Problem Details | ASP.NET Core's standard Problem Details APIs are separate and can be used according to the installed ASP.NET Core version. A MartiX mapping/envelope from `Result<T>`/`ErrorKind` is preview or target guidance until its package and contract are verified. |
| `MXP001` / `MXP002` | Diagnostic IDs are **fixture/analyzer evidence**, not proof of a released analyzer package. A fixture can demonstrate that a sample analyzer emitted an ID; it does not promise package identity, severity, code fixes, or diagnostic stability. |
| EF Core Specifications | Treat the MartiX specification abstraction as a target/preview capability, not as an API that is safe to reference from the name alone. Verify the actual EF Core package, supported providers, and expression semantics first. |
| Reliable events in the Wayfinder blueprint | Target-only architecture. The blueprint is not evidence that a runtime, outbox, dispatcher, or delivery guarantee exists today. |

“Preview” means design or early implementation evidence that may change. “Fixture evidence” means a sample/fixture compiled or passed a check. Neither is a compatibility promise.

## Target-only behavior to verify before coding

Before depending on any of these surfaces, make a minimal probe in the **actual target solution** and pin the result:

- **Package boundary:** exact assembly/package ID, version, namespace, public types, target frameworks, transitive dependencies, and whether the package is actually published/restorable.
- **Results/errors:** success and failure construction, null/exception behavior, error aggregation, mapping to status codes and Problem Details fields, serialization, and compatibility/versioning rules.
- **Analyzers:** package activation, compiler/SDK compatibility, diagnostic severity and default configuration, code fixes, generated-code/nullable behavior, and whether MXP001/MXP002 are stable IDs or fixture-only IDs. Do not build CI gates or suppressions around them until this is proven.
- **Specifications:** query translation, parameterization, composition, includes, tracking/no-tracking, async and cancellation behavior, provider differences, and interaction with compiled queries/AOT.
- **Reliable events:** transactional outbox boundary, commit-versus-publish ordering, persistence and deduplication, retries/backoff, poison/dead-letter handling, idempotent consumers, ordering/partitioning, recovery after crashes, observability, schema versioning, and the actual delivery guarantee (at-most-once, at-least-once, or effectively-once). “Reliable” must not be inferred from the blueprint name.

Until those checks pass against a concrete package or source project, use standard .NET/ASP.NET Core/EF Core APIs and keep MartiX-specific references behind an explicitly provisional adapter.
