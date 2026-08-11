# MartiX Platform anti-patterns

Use this list for a fast first-pass review before opening deeper rules.

| Smell | Why it is risky | Route |
| --- | --- | --- |
| Template re-applied over a live app | Overwrites application-owned source | [Migrations](../rules/delivery-migrations-aot.md) |
| API migrates on startup | Couples deploy, schema, and traffic; hides failure | [Generated solution](../rules/architecture-modular-monolith.md) |
| Module references another implementation | Breaks ownership and makes extraction impossible | [Composition](../rules/platform-composition-ownership.md) |
| Generic repository or `IUnitOfWork` | Hides query shape and EF behavior | [Persistence](../rules/persistence-efcore-reliable-events.md) |
| Assembly scanning or service locator | Hides the composition graph and complicates trimming | [Composition](../rules/platform-composition-ownership.md) |
| Mandatory mediator or interface-per-class | Adds indirection without a boundary | [Vertical slices](../rules/architecture-vertical-slices.md) |
| Kernel references ASP.NET Core/EF Core | Makes the base contract host-dependent | [Platform surface](../references/platform-surface-map.md) |
| Result serialized directly | Leaks internal failure shape | [HTTP contracts](../rules/http-openapi-contract.md) |
| `platform.` error code owned by an app | Collides with reserved namespace | [Platform surface](../references/platform-surface-map.md) |
| Exactly-once event claim | Confuses at-least-once transport with idempotent effect | [Reliable events](../rules/integration-events-outbox.md) |
| InMemory/SQLite proves lease/concurrency semantics | Fakes cannot model provider isolation and locking | [Testing](../rules/testing-quality-performance.md) |
| Optional capability leaves packages/config behind | Generated output is not deterministic or safe | [Capabilities](../rules/foundation-preset-capabilities.md) |
| All presets claim Native AOT | Unsupported dependency/profile promise | [AOT](../rules/native-aot-performance-matrix.md) |
| Secrets in manifests or examples | Leaks credentials and creates unsafe defaults | [Security](../rules/security-operations.md) |

## Fast triage

1. Classify the smell as current behavior, target behavior, or unsupported.
2. Fix ownership or contract shape before optimizing implementation details.
3. Add the smallest focused test that would prevent recurrence.
