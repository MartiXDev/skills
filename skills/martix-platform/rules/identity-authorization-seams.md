# Identity and authorization seams

## Purpose

Keep authentication-provider choices at the edge while making authorization
decisions explicit, testable, and safe inside a module.

## Default guidance

- Treat identity as an optional capability. Keep application code dependent on
  a small provider-independent actor or identity seam rather than a provider
  subject type.
- Perform transport authorization at the endpoint or policy boundary, then
  perform resource and business authorization in the Application Operation.
  The second check prevents a trusted transport claim from becoming ownership.
- Model authorization decisions with explicit permissions, resource ownership,
  tenant boundaries, and failure results. Make the actor and correlation
  context available without passing an HTTP context through the domain.
- Keep security audit events distinct from application logs, domain events, and
  integration events. Decide whether the threat model requires durable,
  append-only storage and whether it must commit atomically with the business
  change.
- Do not put provider identifiers, email addresses, tokens, or secrets in
  domain contracts or audit bodies unless a documented data-classification
  decision requires it.

## Avoid

- Do not make every generated app depend on a specific identity provider.
- Do not rely on endpoint policy alone for resource ownership or tenant checks.
- Do not treat a log line as a durable audit record.
- Do not silently drop audit persistence failures; choose fail-closed or an
  explicitly observed recovery path from the threat model.

## Review checklist

- [ ] Authentication and authorization are separate decisions.
- [ ] Endpoint and Application Operation checks both exist where required.
- [ ] Actor, target, action, outcome, timestamp, and correlation are explicit.
- [ ] Audit data is classified and free of unnecessary PII/secrets.
- [ ] Failure behavior is tested and observable.

## Related files

- [Security and operations](./security-operations.md)
- [HTTP and OpenAPI](./http-openapi-contract.md)
- [Testing and quality](./testing-quality-performance.md)
- [Capability proposal template](../templates/platform-capability-proposal.md)

## Source anchors

- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\platform-blueprint.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\tickets\005-identity-seams-and-providers.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\tickets\111-security-observability-baseline.md`
