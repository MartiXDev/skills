# HTTP, Results, and OpenAPI contracts

## Purpose

Keep transport behavior explicit while preserving the Kernel's typed failure
contract and a stable, documented HTTP surface.

## Default guidance

- Use Minimal APIs as the canonical generated transport. Keep FastEndpoints as
  an optional adapter that must preserve the same behavior and contracts.
- Return typed `Result` or `Result<T>` from application operations and map them
  at the edge. Use RFC 9457 Problem Details for failures.
- Register Problem Details explicitly and keep exception handling order visible.
  Never serialize Kernel `Result` objects directly as the wire shape.
- Keep transport validation at the HTTP boundary and application/domain
  validation in the operation. Use lower-case owner-prefixed dot-separated
  error codes; `platform.` is reserved for Platform-owned codes.
- Keep route, status, response, version, and authorization metadata explicit.
  Generate OpenAPI from the actual endpoint contract and review error responses
  as part of the API surface.
- If the current adapter or package does not expose a claimed helper, follow
  the authority rule and implement the mapping explicitly rather than guessing.

## Avoid

- Do not leak exceptions, EF entities, provider errors, or internal module
  types through HTTP.
- Do not use a catch-all success response or silently translate an unknown
  error into `200 OK`.
- Do not make OpenAPI documentation a separate, stale model from runtime
  behavior.
- Do not let FastEndpoints-specific advice replace the Platform's transport
  contract; hand off adapter mechanics to `martix-fastendpoints`.

## Review checklist

- [ ] Success and failure responses are typed and documented.
- [ ] Problem Details registration and exception-handler ordering are visible.
- [ ] Error codes satisfy Platform shape and ownership rules.
- [ ] Transport and application validation are separate.
- [ ] OpenAPI, authorization, versioning, and tests cover the endpoint.

## Related files

- [Vertical slices](./architecture-vertical-slices.md)
- [Platform surface map](../references/platform-surface-map.md)
- [Identity and authorization](./identity-authorization-seams.md)
- [FastEndpoints handoff](../references/handoff-map.md)

## Source anchors

- `C:\Git\MartiXDev\Platform\src\MartiX.Platform.AspNetCore\README.md`
- `C:\Git\MartiXDev\Platform\src\MartiX.Platform\README.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\platform-blueprint.md`
