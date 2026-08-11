# Capability and provider matrix

The target Platform is capability-driven, but the current bootstrap manifest
does not claim broad support. Treat this as a design-review matrix, not a list
of available package APIs.

| Area | Default | Optional seam | Evidence required |
| --- | --- | --- | --- |
| Modular monolith | Preferred production shape | Business Modules | Generated topology and dependency checks |
| API transport | Minimal APIs | FastEndpoints adapter | Contract and parity tests |
| Persistence | None in Kernel | EF Core provider | Real-provider migrations, transactions, and concurrency |
| Database provider | Explicit selection | PostgreSQL or SQL Server profile | Provider-specific quality gates |
| Identity | None by default | Provider-independent actor seam | Threat model, authn/authz, and audit evidence |
| Cache | None by default | Declared provider | Failure, health, invalidation, and absence tests |
| Jobs | None by default | Declared scheduler/provider | Retry, shutdown, persistence, and absence tests |
| Broker | None by default | Declared adapter | Delivery, deduplication, recovery, and absence tests |
| UI | Separate `full-stack` preset | Explicit UI capability | Build, accessibility, and capability-absence tests |
| Observability | Secure baseline | Exporter/provider | Redaction, bounded cardinality, health, and trace tests |

## Admission questions

1. Is the capability needed by the selected preset, or can it remain absent?
2. Does the provider change application code or only an explicit adapter?
3. What happens when the provider is unavailable, misconfigured, or removed?
4. Which generated files, references, configuration, secrets, health checks,
   migrations, and tests prove presence and absence?
5. Which exact quality-gate profile supports the claim?

## Source anchors

- `C:\Git\MartiXDev\Platform\martix.platform.json`
- `C:\Git\MartiXDev\Platform\eng\quality-gates.json`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\platform-blueprint.md`
