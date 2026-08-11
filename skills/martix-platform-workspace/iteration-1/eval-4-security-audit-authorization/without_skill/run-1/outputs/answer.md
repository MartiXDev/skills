# CancelOrder security contract

## Security invariants

- The actor is taken from the authenticated, server-validated principal (`subjectId`, tenant, and current permissions). `customerId`, `actorId`, role, or authorization basis must not be accepted from the request body.
- A customer may cancel only an order whose persisted `customerId` equals the principal subject and only while the principal has `orders.cancel.own`.
- An administrator with `orders.cancel.any` may cancel an order in the administrator's tenant/scope. The administrator permission does not depend on a customer-supplied ownership claim.
- Authorization is evaluated before invoking the cancellation domain operation or performing any business mutation. A denied request cannot update the order, create an `OrderCancelled` outbox message, or publish an integration event.
- The operation is fail-closed: no successful cancellation is committed unless its durable audit record and outbox record are also durably committed.

## Endpoint policy

`POST /v1/orders/{orderId}/cancel`

1. Require an authenticated principal. Missing or invalid credentials return `401 Unauthorized`.
2. Apply a coarse endpoint policy requiring the cancel capability (`orders.cancel.own` or `orders.cancel.any`). A principal with neither capability receives `403 Forbidden`.
3. Pass the trusted principal, route `orderId`, correlation/trace ID, and optional idempotency key to the application operation. Do not authorize from a controller-only role check, and do not trust route/body ownership data.
4. The endpoint may use a resource-based authorization handler, but the application operation must repeat the decisive ownership/administrator check. This prevents another caller or job from bypassing the HTTP endpoint.

For a customer, the application can fetch by `orderId` scoped to the authenticated subject (`id = ? AND customerId = ?`); this also avoids disclosing another customer's order. An administrator may fetch by `id` within the permitted tenant/scope. A caller that cannot pass this resource check returns `403` (or the service's deliberate non-disclosing `404`) before cancellation logic. The response must not reveal another customer's order state.

## Application operation contract

`CancelOrder(orderId, principal, idempotencyKey, correlationId)` is the authoritative security boundary:

1. Validate the principal and capability.
2. In a transaction, load and lock the order (or use an equivalent optimistic version predicate), and evaluate the resource authorization against persisted ownership and the principal's administrator permission.
3. If unauthorized, stop immediately; do not call `order.cancel()`, change state, or create a success audit/outbox record.
4. Only after authorization, validate that the current state is cancellable. A stale version or concurrent cancellation returns the documented conflict/idempotent result.
5. Create the order state transition, immutable audit event, and `OrderCancelled` outbox message, then commit them together.

Authorization must precede business-state validation where state or existence could disclose information to an unauthorized caller. The domain method should still enforce its own invariants; endpoint authorization is not a substitute for domain authorization.

## Immutable audit event

A successful cancellation emits one append-only audit event, for example `OrderCancellationSucceeded`. A denied decision may emit `OrderCancellationDenied` without an order snapshot. Every event has server-generated, immutable fields:

- `auditEventId` (globally unique), `eventType`, and `schemaVersion`;
- `occurredAtUtc` from the service/database, never from the caller;
- `action = CancelOrder`, `outcome` (`Succeeded`, `Denied`, or `Failed`), and a stable `reasonCode`;
- actor `subjectId`, tenant, principal type, and the permission/basis used (`owner` or `administrator`);
- target resource type and `orderId` (and tenant), with no unnecessary payment or personal data;
- request/correlation/trace IDs, source service/endpoint, and idempotency key when present;
- for a success, the persisted `beforeStatus`, `afterStatus = Cancelled`, and order version/transaction identifier; for a denial, omit data the caller was not authorized to see;
- creation metadata such as `createdByService` and, where supported, a tamper-evident digest.

Events are append-only: no update or delete is used to correct history; corrections are separate compensating events. Values are server-derived and schema-validated, not arbitrary request metadata.

## Durable audit, logs, and outbox

The audit ledger is a durable, access-controlled, append-only store with retention and restricted readers. It is the compliance/security record and is queryable by `auditEventId`, order, actor, and correlation ID.

Application logs are operational diagnostics only. They may be rotated, sampled, delayed, or lost; they must be redacted and must not contain secrets or be treated as proof that cancellation occurred. Logs should include the audit/correlation ID and failure details sufficient for operations. The audit event and the integration outbox message are different records: the audit describes authorization/business history, while `OrderCancelled` is for downstream delivery.

Prefer one database transaction containing:

```text
order update + immutable audit row + outbox row
```

The outbox row has a unique event ID/aggregate version and is relayed after commit with retry and idempotent delivery. If the canonical audit sink is external, first persist an authoritative local audit row (or audit outbox) in this same transaction and asynchronously project it to the external sink; do not claim distributed atomicity that is not provided.

## Failure handling

- **Audit insert/store unavailable, timeout, or rejected for an authorized cancellation:** roll back the order update and outbox insert; return `503 Service Unavailable` with a retryable, non-sensitive error (and `Retry-After` where appropriate). Never cancel without durable audit. The idempotency key makes client retry safe.
- **Outbox relay unavailable after commit:** return success once the local transaction commits; leave the outbox pending, alert, and retry. The order and audit remain consistent even though consumers are delayed.
- **Audit projection unavailable after the local audit row commits:** retry by immutable event ID; do not create a second cancellation or mutate the original audit event.
- **Operational log sink unavailable:** do not fail a valid cancellation; durable audit and the transaction remain the source of truth.
- **Denied/unauthenticated request:** return `401`/`403` and never perform the business operation. Attempt a separate denied-attempt audit record if available. If policy requires every denial to be durably recorded, return `503` when that record cannot be persisted, but still fail closed and never authorize the request.
- **Unknown commit result:** require the client to retry with the same idempotency key; reconcile from the order/audit/outbox transaction before deciding whether to repeat. Do not issue a second cancellation event.
