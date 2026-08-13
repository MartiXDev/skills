# Current Platform surface map

This is a compact map of the implementation that was available when this
skill was authored. Verify the consuming package version and current source
before using an API.

| Project | Role | Boundary |
| --- | --- | --- |
| `MartiX.Platform` | Kernel contracts | Framework-independent `Result`, `Result<T>`, `Error`, and `ErrorKind`; no host, DI, logging, JSON, ASP.NET Core, or EF Core dependency |
| `MartiX.Platform.AspNetCore` | HTTP adapter | Problem Details and exception/failure mapping at the transport edge |
| `MartiX.Platform.EntityFrameworkCore` | Persistence adapter | EF Core naming, UTC/concurrency primitives, Specifications, and reliable-event persistence primitives |
| `MartiX.Platform.Analyzers` | Compile-time diagnostics | `netstandard2.0` analyzer package; `MXP001` validates error-code shape and `MXP002` protects reserved `platform.` codes |

## Kernel contracts

- Keep `Result` and `Result<T>` immutable, sealed, and factory-created.
- Keep `Error` immutable and pair it with an explicit `ErrorKind`.
- Error codes are lower-case, owner-prefixed, dot-separated segments. The
  `platform.` prefix is reserved for Platform-owned errors.
- Do not serialize Kernel results directly. Translate them into the consuming
  HTTP or messaging contract.

## HTTP adapter behavior

- Register Problem Details explicitly.
- Map typed failures to RFC 9457 Problem Details.
- Keep `UseExceptionHandler()` ordering visible and verified.
- Keep transport validation, application validation, and domain invariants
  separate.

## Persistence behavior

- Prefer deterministic names, UTC timestamps, and application-managed
  concurrency tokens.
- Specifications are immutable query descriptions and do not materialize
  themselves.
- Reliable Events use Outbox Messages, Delivery Attempts, and Inbox Receipts.
  They provide observable at-least-once delivery, not exactly-once transport.

## Current source anchors

- `C:\Git\MartiXDev\Platform\src\MartiX.Platform\README.md`
- `C:\Git\MartiXDev\Platform\src\MartiX.Platform.AspNetCore\README.md`
- `C:\Git\MartiXDev\Platform\src\MartiX.Platform.EntityFrameworkCore\README.md`
- `C:\Git\MartiXDev\Platform\src\MartiX.Platform.Analyzers\README.md`
