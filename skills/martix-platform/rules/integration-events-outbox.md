# Integration events and delivery semantics

## Purpose

Give reliable-event consumers a precise at-least-once contract and keep
business idempotency separate from transport guarantees.

## Default guidance

- Treat an Outbox Message as a durable record committed with the producer's
  business transaction.
- Treat delivery as at least once. A consumer may receive duplicates after
  lease expiry, timeout, crash, or uncertain acknowledgement.
- Use a per-subscription delivery attempt and lease with explicit retry and
  recovery behavior. Record failure and next-attempt state rather than hiding it
  in a background loop.
- Deduplicate at the consumer with an Inbox Receipt or equivalent durable key,
  then make the business effect idempotent. Exactly-once business effect is an
  application property built on this evidence, not a transport claim.
- Keep event contracts stable, versioned, and independent of internal entity
  types. Keep event publication and consumption in the owning module's
  composition surface.

## Avoid

- Do not claim exactly-once delivery, global ordering, or zero-loss recovery.
- Do not use a process-local dictionary as the deduplication store.
- Do not add a generic event bus or assembly-scanned subscriptions when the
  application has one explicit module composition graph.
- Do not swallow a failed handler or mark a receipt before the business effect
  is durable.

## Review checklist

- [ ] Producer update and Outbox Message commit atomically.
- [ ] Subscription, attempt, lease, retry, and receipt keys are explicit.
- [ ] Consumer side effects are idempotent and tested after failure/replay.
- [ ] Poison messages and operator recovery are observable.
- [ ] The answer states what the transport does not guarantee.

## Related files

- [Persistence and reliable events](./persistence-efcore-reliable-events.md)
- [Testing and quality](./testing-quality-performance.md)
- [Security and operations](./security-operations.md)

## Source anchors

- `C:\Git\MartiXDev\Platform\CONTEXT.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\platform-blueprint.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\tickets\109-integration-event-delivery.md`
