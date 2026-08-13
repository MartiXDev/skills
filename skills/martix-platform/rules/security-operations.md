# Security, observability, and operations

## Purpose

Make secure defaults, useful diagnostics, and operator recovery part of the
application contract instead of a post-release cleanup phase.

## Default guidance

- Start from a threat model and data classification. Verify authentication,
  authorization, tenant/resource ownership, secret handling, and abuse
  controls for each exposed capability.
- Fail fast on invalid required configuration. Keep secrets out of source,
  manifests, generated examples, logs, traces, Problem Details, and audit
  events; use environment or managed-secret configuration.
- Emit structured logs, traces, metrics, and health signals with correlation
  context and bounded cardinality. Redact sensitive values.
- Make readiness, liveness, graceful shutdown, cancellation, dependency
  failures, migration status, and reliable-event backlog observable.
- Treat security audit events as a separate durable contract when the threat
  model requires it. Make audit persistence failure explicit and observable.
- Keep rate limits, timeouts, idempotency, and retry policy at the correct
  boundary; do not add them globally without a measured reason.

## Avoid

- Do not use logs as a substitute for a durable audit trail.
- Do not return stack traces, secrets, raw provider errors, or PII in HTTP
  failures.
- Do not hide configuration errors behind empty defaults or catch-all recovery.
- Do not add telemetry with unbounded user, request, or entity labels.

## Review checklist

- [ ] Threat model and data classification are stated.
- [ ] Authn, authz, secret, and ownership checks are testable.
- [ ] Logs, traces, metrics, and health endpoints support diagnosis.
- [ ] Failure and recovery paths are fail-fast or explicitly recoverable.
- [ ] Audit events and sensitive data handling meet the required durability.

## Related files

- [Identity and authorization](./identity-authorization-seams.md)
- [Testing and quality](./testing-quality-performance.md)
- [Capability/provider matrix](../references/capability-provider-matrix.md)

## Source anchors

- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\platform-blueprint.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\tickets\111-security-observability-baseline.md`
- `C:\Git\MartiXDev\Platform\martix.platform.json`
