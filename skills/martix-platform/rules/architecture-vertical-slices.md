# Vertical slices and use-case ownership

## Purpose

Keep behavior discoverable by use case while preserving module boundaries and
avoiding ceremony that does not improve the application.

## Default guidance

- Organize module behavior under `Features\<Operation>` (or the repository's
  equivalent) so request, operation, mapping, validation, and tests for one
  use case stay close.
- Keep the endpoint thin: bind transport input, invoke the operation, and map
  the typed result to the HTTP contract.
- Keep the Application Operation internal and sealed by default. It owns the
  use-case orchestration, authorization decision that belongs to the
  application, persistence call, and transaction boundary.
- Register the concrete operation explicitly. A mandatory mediator, command bus,
  or one-interface-per-handler layer is not part of the default architecture.
- Keep transport validation separate from application/domain invariants. Use
  FluentValidation only when complex or reusable validation justifies it.
- Let a slice project the data it needs from EF Core; do not materialize a
  universal aggregate or introduce a repository for a query-shaped use case.

## Avoid

- Do not create horizontal `Controllers`, `Services`, `Repositories`, and
  `Validators` folders that scatter one use case across the module.
- Do not put business rules in endpoint binders, global filters, middleware,
  or serializers.
- Do not add mediator wrappers, generic handlers, or interfaces solely to
  satisfy a pattern.
- Do not leak module implementation types through Contracts or HTTP responses.

## Review checklist

- [ ] One slice owns one operation and its focused tests.
- [ ] Endpoint, operation, validation, persistence, and result mapping have
  distinct responsibilities.
- [ ] Authorization and invariants run at the right layer.
- [ ] The slice uses the smallest query and response shape.
- [ ] The slice composes without scanning or hidden registration.

## Related files

- [Results, errors, and HTTP](./http-openapi-contract.md)
- [Persistence and reliable events](./persistence-efcore-reliable-events.md)
- [Vertical slice template](../templates/vertical-slice-template.md)
- [Generated solution map](../references/generated-solution-map.md)

## Source anchors

- `C:\Git\MartiXDev\Platform\tests\fixtures\ModularMonolithGeneratedSolution\`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\platform-blueprint.md`
