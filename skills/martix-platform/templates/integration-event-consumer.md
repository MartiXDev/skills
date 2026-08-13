# Reliable-event consumer template

Use this for a module consumer that must tolerate duplicate delivery.

## Contract

- Event name/version:
- Owning module:
- Consumer module:
- Subscription identity:
- Idempotency key:
- Expected business effect:

## Consumer flow

1. Receive a delivery attempt with correlation and lease metadata.
2. Check the durable Inbox Receipt for the idempotency key.
3. If a receipt exists, acknowledge the duplicate without repeating the effect.
4. Otherwise perform the business effect and receipt write in the required
   transaction boundary.
5. Record success, failure, retry, and next-attempt state explicitly.

## Failure and recovery

- What happens if the handler crashes before the receipt?
- What happens if the receipt commits but acknowledgement is lost?
- How does lease expiry allow recovery?
- How are poison messages surfaced to operators?
- Which provider-specific test proves the behavior?

## Review checklist

- [ ] The producer Outbox write is atomic with its business change.
- [ ] Delivery is described as at least once.
- [ ] Business effect is idempotent.
- [ ] Inbox, attempts, leases, retries, and metrics are observable.
- [ ] No exactly-once transport or global ordering claim is made.
