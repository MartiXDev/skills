# Orders-to-Notifications reliable-event recovery

## Delivery contract

Assume the producer publishes an immutable, versioned `OrderUpdated.v1` integration
contract. The event has a stable `EventId`, `OrderId`, aggregate version, occurred-at
UTC timestamp, correlation ID, and the data the Notifications module needs. A
redelivery keeps the same `EventId`; only the delivery-attempt ID changes.

The contract is **at-least-once delivery per subscription**. The durable state should
make the subscription, attempt, lease owner/token, lease expiry, retry time, and
outcome explicit. An acknowledgement is sent only after the consumer has durably
completed its work. A timeout, process crash, database failure, lease expiry, or lost
acknowledgement can therefore produce another delivery of the same event. Wire the
producer and consumer explicitly through their module composition surfaces; do not
introduce an assembly-scanned generic event bus.

## Producer transaction

The Orders module owns its context, schema, and Outbox. The order change and the
Outbox Message must be in one database transaction:

```text
BEGIN
  update Orders ...
  insert OutboxMessage(EventId, Type, Version, AggregateId, Payload, CreatedAtUtc)
  COMMIT
```

If the transaction rolls back, neither the order update nor the event is visible. If
it commits, the Outbox row remains durable even when the dispatcher or downstream
Notifications database is unavailable. Do not publish inline before commit, and do
not mark the Outbox message delivered merely because a send was attempted. The
publisher records a per-subscription delivery attempt and marks success only after
the consumer acknowledgement.

The event contract is independent of Orders' entity types. Notifications must not
query the Orders context or tables directly; the event must contain the required
contract data (or use an explicit contract/API boundary).

## Lease, retry, and Inbox recovery

### Failure timeline

1. A dispatcher claims an eligible subscription attempt with a lease and a unique
   lease token. It records the attempt before delivery.
2. Notifications starts handling the event, but its database fails. The transaction
   containing the business effect and Inbox receipt does not commit, so no ack is
   sent. The attempt records the failure (without secrets or raw provider details).
3. A sweeper or dispatcher observes the expired lease, changes the attempt to
   retryable, increments the attempt count, and sets a bounded exponential-backoff
   `NextAttemptAtUtc` (with jitter). It must not silently discard the Outbox row.
4. A later worker atomically reclaims the subscription and delivers the same
   `EventId` with a new attempt ID. Completion updates are conditional on the current
   lease token, so a stale worker cannot complete an attempt after its lease was
   taken over.

A lease that is longer than the handler's expected work should be renewed only with
an ownership token and cancellation handling. Shutdown and lost-renewal paths must
stop the old worker from acknowledging a lease it no longer owns.

### Durable Inbox deduplication

Notifications has an Inbox Receipt keyed by a unique `(SubscriptionId, EventId)`
(or an equivalent durable idempotency key). The business effect and the receipt are
committed in the same Notifications transaction when the effect is local:

1. Read an already-processed receipt. If present, perform no business work and ack
   the duplicate.
2. If absent, apply the effect and insert/mark the receipt as `Processed` in the
   same transaction, then ack only after commit.
3. If two attempts race, let the real provider's unique constraint/row locking or
   isolation resolve the race. The loser re-reads the committed receipt and acks;
   it must not treat an uncommitted or merely `InProgress` row as success. A receipt
   must never be committed as processed before the effect is durable.

If a handler crashes before commit, both effect and receipt roll back and the retry
can process the event. If it crashes after commit but before acknowledgement, the
retry sees the Inbox receipt and does not repeat the effect. This is the normal
recovery path for an expired lease or an uncertain acknowledgement.

The effect itself must be idempotent, not merely the receipt lookup. Choose a
business key that matches the event semantics: for example, a unique notification
intent keyed by `(OrderId, NotificationPurpose, AggregateVersion)` or by `EventId`
when every update is a distinct notification. Do not use only `OrderId` if legitimate
updates must each produce a notification. Prefer a deterministic upsert/set of the
desired state over an increment or append that changes on every replay.

Sending email/SMS/push to an external provider is not atomic with a database
transaction. In that case, the consumer transaction should create the durable local
notification intent (or a Notifications Outbox) and its Inbox receipt; a separate
sender uses a provider-supported idempotency key derived from the event/business
key and reconciles uncertain results. Without provider idempotency, duplicate
external sends remain possible; the Inbox alone cannot prevent them.

After a bounded retry budget, quarantine a poison message/dead-letter it with its
attempt history and a safe failure code. Provide controlled operator replay after the
cause is fixed, retaining the original event ID and receipts; never “fix” a stuck
message by deleting the receipt blindly.

## Provider-specific TDD evidence

Use unit tests for pure event mapping and idempotency rules, but use the actual
configured relational provider and two or more real database connections for claims
about transactions, leases, locks, and concurrency. InMemory and SQLite are useful
for limited logic tests; they are not evidence for these behaviors.

The focused integration suite should test, at minimum:

| Behavior | Evidence to capture |
| --- | --- |
| Producer atomicity | Inject a failure before commit and verify neither order nor Outbox row; commit successfully and verify both are durable. |
| Rollback and retry | Fail the Notifications transaction after the attempted effect but before commit; verify no receipt/effect remains and a later attempt succeeds. |
| Lease expiry | Hold or fail a real connection, let the lease expire, reclaim with a new token, and verify the same event is redelivered and the old token cannot acknowledge it. |
| Concurrent redelivery | Start two handlers behind a barrier for one event; verify the provider's unique Inbox key/locking yields one committed effect and one duplicate acknowledgement, with both attempts observable. |
| Lost acknowledgement | Commit effect plus receipt, drop the ack, redeliver, and verify no second effect. |
| Retry and poison recovery | Verify backoff, attempt limits, quarantine, alert state, and an operator replay after remediation. |
| External-provider uncertainty | Exercise timeout/unknown response and verify the provider idempotency key and reconciliation behavior, or document that duplicate sends are possible. |

The concurrency test must be run against the selected provider and its production
isolation/locking configuration. For example, a PostgreSQL deployment should prove
its row-lock/`SKIP LOCKED`, unique-index, isolation, and serialization/deadlock
behavior; a SQL Server deployment should prove the corresponding lock/isolation and
unique-index behavior. These are examples, not portable promises: use the provider's
actual SQL and capture the schema, isolation level, database version, test command,
and result. Record failures, retries, and lease transitions as test assertions, not
just log output.

## Operational observability

Every attempt, retry, lease expiration, duplicate Inbox hit, success, failure, and
quarantine transition should emit structured telemetry containing bounded/safe
fields such as event type/version, subscription, attempt ID, event ID, correlation
ID, lease outcome, and a classified error code. Do not put payload secrets or PII in
logs or metric labels.

Expose metrics and health signals for Outbox backlog and oldest age, delivery
attempts, lease expirations, retry rate, handler latency/failures, Inbox duplicate
rate, and poison/dead-letter count. Trace the producer transaction, dispatch, and
consumer transaction with the correlation ID. Alert on an aging backlog, repeated
lease expiry, retry exhaustion, or dead-letter growth. Keep attempt and receipt
history sufficient for an operator to determine whether an event was never handled,
handled and ack was lost, or quarantined.

## Non-guarantees

- This design does **not** provide exactly-once transport. Duplicates and delayed
  delivery are expected.
- It does not provide global ordering (or per-subscription ordering unless a separate,
  explicitly tested ordering contract exists).
- Atomic order-plus-Outbox commit makes a committed event durable; it does not make
  the network, consumer database, or external provider available forever, and it
  cannot recover data lost with the durable store itself.
- One committed local business effect per Inbox key is an application property that
  depends on a durable unique key, an atomic effect/receipt transaction, and the
  provider evidence above. It is not an exactly-once delivery claim.
- An external notification provider without an idempotency contract cannot be
  promised exactly once; the honest guarantee is durable intent plus at-least-once
  delivery/attempts and observable reconciliation.
- Retry exhaustion requires operator action; poison-message quarantine is recovery,
  not proof that every message will eventually succeed.
