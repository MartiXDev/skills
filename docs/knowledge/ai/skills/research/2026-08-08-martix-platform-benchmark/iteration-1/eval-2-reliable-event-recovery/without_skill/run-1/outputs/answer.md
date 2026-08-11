# Orders-to-Notifications recovery and test strategy

## Review position

The broker/consumer path must be treated as **at-least-once delivery**. The desired stronger property is **exactly-once logical business effect per consumer and deduplication key**, not exactly-once transport delivery. A lease/visibility timeout is a liveness mechanism, not a mutual-exclusion lock: after it expires, the old worker may still be running while a replacement receives the message.

The event envelope should contain an immutable `event_id`, `order_id`, `order_version` (or sequence), event type, and correlation ID. If a producer retry can occur after an unknown commit outcome, derive the event ID deterministically from the business fact (for example, `order_id + order_version + event_type`) or enforce that business key uniquely in the producer database. A retry that creates a new event ID defeats Inbox-only deduplication.

## Recovery protocol

1. **Producer transaction**
   - Update the order and insert its Outbox row in one local database transaction.
   - Give the Outbox row a stable event ID and immutable payload. Do not mark it published until the broker confirms acceptance.
   - Claim/publish with a lease and a fencing token. A stale dispatcher may not change `published_at`, retry state, or lease ownership unless its token still matches.

2. **Consumer transaction**
   - Receive the message, but do not acknowledge/complete it yet.
   - In the consumer database, use `Inbox(consumer_name, event_id)` with a unique constraint. The Inbox row and the internal business effect must be committed in the same transaction.
   - Insert the Inbox row, apply the business change, and insert a consumer Notification Outbox row using a stable `notification_id`/business dedupe key. Enforce uniqueness on that key as well as on `event_id`.
   - Mark the Inbox row complete and commit. Only after a successful commit acknowledge the broker message.
   - On a duplicate, verify that the existing Inbox record is complete, commit a no-op, and acknowledge. Do not acknowledge an observable `processing` record unless the implementation has a safe, fenced recovery path; otherwise the original effect could have been lost.

   Conceptually:

   ```text
   BEGIN
     insert Inbox(consumer, event_id) if absent
     if an already-committed Inbox row exists:
       COMMIT and ACK                         -- duplicate delivery
     insert NotificationOutbox(notification_id, event_id, dedupe_key) if absent
     update notification/order projection idempotently
     mark Inbox complete
   COMMIT
   ACK
   ```

   Prefer not to expose an intermediate Inbox row: insert it and complete it in the same transaction. A concurrent redelivery then waits on the provider's uniqueness/transaction rules and sees either the committed complete row or the rolled-back absence. If the work spans transactions, use an explicit state machine with an expiry/fencing token and retry any non-complete state.

3. **External notification provider**
   - Do not call email/SMS/push directly before the consumer transaction commits. The consumer Notification Outbox makes the provider call recoverable.
   - Use the stable notification ID as the provider idempotency key, when the provider supports one. Record the provider request/response and reconcile `accepted`, `failed`, and `unknown` outcomes.
   - If the provider has no idempotency facility, a timeout after acceptance is fundamentally ambiguous. Retrying can duplicate the notification; the system must not claim exactly-once delivery. Use provider reconciliation, a sending ledger, or an explicit manual-review path.

### Expected outcomes for the stated failure

| Failure point | Durable state | Redelivery result |
|---|---|---|
| Database fails before consumer commit | Inbox and business effect roll back | Replacement consumer processes normally |
| Commit succeeds, acknowledgement is lost or lease expires | One complete Inbox row and one logical effect | Replacement sees the duplicate and no-ops, then acknowledges |
| Old worker continues after lease expiry | It may still run, but cannot create a second unique effect; fenced finalization is rejected | New worker is authoritative |
| Provider accepted the request, then the worker/dispatcher fails | Notification Outbox remains pending or unknown | Retry with the same provider idempotency key, or reconcile before retrying |

The old worker should be cancelled when possible, but cancellation is not a correctness requirement. Correctness must come from the database constraints, atomic transaction, idempotent effect, and fencing checks.

## Provider-specific concurrency evidence

Do not rely on a generic statement that “the database is ACID.” Record the deployed database and broker versions, isolation level, DDL, lock/timeout settings, and an integration trace showing the race. At minimum, prove all of the following against the actual provider:

- concurrent Inbox inserts for the same `(consumer_name, event_id)` serialize or produce one unique-key winner;
- the losing transaction cannot commit a business effect;
- rollback removes the tentative Inbox/effect so a retry can succeed;
- stale lease tokens cannot update or settle a message;
- deadlock/serialization/lock-timeout errors are retried as whole transactions, not partially replayed;
- broker settlement/visibility behavior after expiry matches the recovery assumptions.

Examples of provider evidence to obtain (use only the row matching the deployed provider):

- **PostgreSQL:** test the unique index with concurrent `INSERT ... ON CONFLICT`, transaction visibility, and `SELECT ... FOR UPDATE SKIP LOCKED` if used for claims. Inject a connection termination and verify that a serialization failure or aborted transaction causes a complete retry.
- **SQL Server:** test the unique constraint under the configured RCSI/snapshot or locking isolation; use and test `UPDLOCK`/`HOLDLOCK` or `SERIALIZABLE` where required for state transitions, and a `rowversion`/lease token for fencing. Exercise deadlock 1205 and snapshot-update conflicts. Do not assume an untested `MERGE` is safe for this protocol.
- **MySQL/InnoDB:** verify every table is InnoDB, then test the unique index and `INSERT ... ON DUPLICATE KEY UPDATE` behavior, record/gap locks, deadlocks, and lock-wait timeouts. Retry the complete transaction.
- **Message provider:** test the real lease/settlement semantics (for example, SQS visibility/receipt handles, Service Bus PeekLock expiry/renewal, or Kafka offset commits). Broker duplicate-detection windows, if available, are an optimization and do not replace the Inbox or business key.

The evidence should be repeatable in CI against a real provider container/emulator where it faithfully implements these semantics, and in a staging test against the managed service. Mocks can cover control flow but cannot establish concurrency guarantees.

## Test strategy

### Deterministic integration and race tests

1. **Producer atomicity:** force a failure before and after the order update; assert there is never a committed order update without its matching Outbox row, or vice versa.
2. **Rollback before commit:** hold the consumer transaction, fail the database connection, let the lease expire, and redeliver. Assert no first-attempt Inbox/effect remains and the second attempt commits one result.
3. **Commit-before-ack:** commit the consumer transaction, drop the acknowledgement/settlement response, and redeliver. Assert one Inbox row and one logical notification request.
4. **Concurrent lease expiry:** let consumer A hold the transaction while its lease expires; deliver to B. Assert the provider-specific unique-key race produces one winner and no second business mutation.
5. **Stale worker fencing:** allow A to resume after B owns the new lease. Assert A cannot mark the message complete, change the Outbox state, or acknowledge using an expired token/receipt.
6. **Duplicate and replay:** deliver the same event repeatedly and replay it from the DLQ. Assert no additional effect. Also submit two different event IDs for the same order/version and assert the business dedupe key prevents a duplicate.
7. **Ordering:** deliver order versions out of order. Assert a stale version cannot regress the notification state; use a conditional version update or an ordering mechanism.
8. **Outbox crash windows:** fail after broker acceptance but before `published_at`; assert a duplicate publication is harmless at the consumer. Fail during every dispatcher state transition and verify lease recovery.
9. **Provider unknown outcome:** make the provider accept a request and then timeout the response. With provider idempotency enabled, retry with the same key and assert one provider-side send. Without it, assert the result is recorded as unknown and routed to reconciliation rather than falsely reported as exactly once.
10. **Poison and recovery:** exhaust retry policy, move the message to a monitored DLQ, repair the cause, and replay it safely using the original event ID and dedupe key.

Inject faults at: before Inbox insert, after Inbox insert, after the internal effect, before commit, after commit/before acknowledgement, before provider request, after provider acceptance, and during database/broker failover. Use short deterministic lease durations or a controllable clock, not sleeps alone.

### Invariants and observability

Assert these invariants in every test and production audit:

- one committed Inbox row per consumer and event ID;
- one logical internal effect per event/business dedupe key;
- no acknowledgement until commit or confirmed duplicate completion;
- no stale lease holder can finalize state;
- every notification request is traceable to `event_id`, `order_id`, attempt, lease token, and provider request ID;
- retry age, duplicate count, lock/serialization failures, unknown provider outcomes, and DLQ depth are measured and alerted.

Provide an operator replay command that preserves the original envelope and is safe to run repeatedly. Keep enough audit data to distinguish “provider accepted” from “end user received.”

## Limits of the guarantee

This design provides **at-least-once event delivery plus effectively-once internal effects**, assuming the producer transaction, consumer database, broker retention, and retry/replay processes remain available. It does **not** provide global exactly-once delivery:

- a broker can redeliver after an acknowledgement loss, and a message can be delayed, reordered, expired, or dead-lettered;
- a committed Outbox row is not proof that the broker or notification provider eventually accepted it without a live dispatcher and reconciliation;
- Inbox deduplication does not recognize a new event ID representing the same business fact;
- an external send and a database commit cannot be made atomic by Inbox alone;
- provider acceptance is not proof of delivery to a mailbox, handset, or user;
- permanent failures, exhausted retention, deleted DLQ messages, or unrepaired infrastructure can still result in no notification.

The contract should therefore say: **the system retries until success or an explicit DLQ/unknown state, deduplicates committed effects, and exposes reconciliation—not that every notification is delivered exactly once.**