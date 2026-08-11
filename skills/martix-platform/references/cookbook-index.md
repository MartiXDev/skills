# MartiX Platform cookbook index

Use the smallest route for common work.

| Scenario | Route |
| --- | --- |
| New web app | [presets](../rules/foundation-preset-capabilities.md) -> [modular monolith](../rules/architecture-modular-monolith.md) -> [generated checklist](./generated-solution-checklist.md) |
| New module | [module checklist](../templates/module-slice-checklist.md) -> [composition](../rules/platform-composition-ownership.md) |
| New use case | [vertical slice template](../templates/vertical-slice-template.md) -> [HTTP contract](../rules/http-openapi-contract.md) -> [testing](../rules/testing-quality-performance.md) |
| New Result/Error | [Platform surface](./platform-surface-map.md) -> [HTTP contract](../rules/http-openapi-contract.md) |
| EF Core write | [persistence](../rules/persistence-efcore-reliable-events.md) -> [testing](../rules/testing-quality-performance.md) |
| Integration event | [event template](../templates/integration-event-consumer.md) -> [reliable events](../rules/integration-events-outbox.md) |
| New capability/provider | [capability proposal](../templates/platform-capability-proposal.md) -> [quality gates](../rules/quality-gates-release-policy.md) |
| Platform upgrade | [authority](../rules/foundation-authority-and-status.md) -> [migration model](./migration-and-support-model.md) |
| Security review | [identity seams](../rules/identity-authorization-seams.md) -> [security operations](../rules/security-operations.md) |
| Performance/AOT review | [AOT matrix](../rules/native-aot-performance-matrix.md) -> [quality](../rules/testing-quality-performance.md) |
