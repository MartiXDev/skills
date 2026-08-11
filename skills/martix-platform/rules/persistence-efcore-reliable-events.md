# EF Core ownership and reliable events

## Purpose

Keep persistence behavior inside its owning module and make event delivery
reliable without overclaiming distributed guarantees.

## Default guidance

- Each module owns its `DbContext`, mappings, migrations, deterministic naming,
  schema concerns, UTC timestamps, and application-managed concurrency token.
- Use direct EF Core from the Application Operation when the use case needs
  persistence. Project only the fields needed by the slice.
- Keep Specifications immutable and non-materializing when a reusable query
  shape is genuinely useful. Do not turn them into inherited mini-repositories.
- Write the business change and its Outbox Message in one transaction. Model
  delivery attempts and per-subscription leasing explicitly; make recovery and
  retry observable.
- Use Inbox Receipts or an equivalent deduplication record so a handler can
  produce one business effect when a message is delivered more than once.
- Test lease expiry, rollback, retry, concurrency, and idempotency with the
  real provider when those behaviors matter.

## Avoid

- Do not introduce generic repositories, `IUnitOfWork`, universal base entities,
  or a generic scanned event bus by default.
- Do not claim exactly-once transport, global ordering, or reliable delivery
  from an in-memory or SQLite test.
- Do not let another module query this module's context or tables directly.
- Do not hide provider-specific isolation, locking, or migration behavior behind
  a fake that cannot prove it.

## Review checklist

- [ ] Module owns its context, mappings, migrations, and schema.
- [ ] UTC and concurrency behavior are explicit.
- [ ] Business and Outbox writes are atomic.
- [ ] Delivery attempts, leases, retries, and Inbox Receipts are observable.
- [ ] Consumer effects are idempotent.
- [ ] Provider-specific evidence exists for persistence claims.

## Related files

- [Modular monolith](./architecture-modular-monolith.md)
- [Testing and quality](./testing-quality-performance.md)
- [Migrations and AOT](./delivery-migrations-aot.md)
- [Integration event template](../templates/integration-event-consumer.md)

## Source anchors

- `C:\Git\MartiXDev\Platform\src\MartiX.Platform.EntityFrameworkCore\README.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\platform-blueprint.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\tickets\109-integration-event-delivery.md`
