# Vertical slice template

Use this as a planning scaffold, then adapt names to the module and use case.

## Slice identity

- Module:
- Operation:
- Actor and authorization policy:
- Route and HTTP verb:
- Success response:
- Failure codes:

## Suggested shape

```text
<Module>\
  Features\
    <Operation>\
      <Operation>Endpoint.cs
      <Operation>Operation.cs
      <Operation>Request.cs
      <Operation>Response.cs
      <Operation>Validator.cs        # only when complex validation needs it
      <Operation>Tests.cs
```

## Design prompts

- Does the endpoint only bind, invoke, and map?
- Is the operation internal and sealed unless a real boundary says otherwise?
- Which transport validations differ from application/domain invariants?
- What is the smallest EF Core projection or write?
- Which transaction, concurrency, idempotency, or Outbox behavior is required?
- Which authorization, audit, telemetry, health, and cancellation behavior is
  observable?
- Which unit, host, real-provider, and failure-injection tests prove it?

## Completion evidence

- [ ] Explicit registration and endpoint mapping exist.
- [ ] Result/Error and Problem Details behavior is covered.
- [ ] Module dependency direction remains valid.
- [ ] Positive and negative tests pass.
- [ ] No new generic abstraction was added without a concrete reason.
