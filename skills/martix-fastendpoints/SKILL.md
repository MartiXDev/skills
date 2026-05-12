---
name: martix-fastendpoints
description: Standalone-first FastEndpoints guidance for endpoint design, startup registration, DTO binding, validators, preprocessors, postprocessors, OpenAPI, files, SSE, RPC, security, testing, versioning, and Native AOT. Use when building or reviewing FastEndpoints services on ASP.NET Core.
license: Complete terms in LICENSE.txt
---

# MartiX FastEndpoints router

- Standalone-first skill package focused on FastEndpoints-specific decisions for
  .NET 10+, C# 14+, and ASP.NET Core services.
- Keep decisions grounded in the bundled rule files and FastEndpoints reference
  maps.
- Use [AGENTS.md](./AGENTS.md) when the task crosses multiple workstreams or
  needs a longer review flow.

## When to use this skill

- Review or scaffold FastEndpoints applications and feature slices.
- Shape request DTOs, validators, endpoint hooks, preprocessors, or
  postprocessors.
- Choose between standard HTTP endpoints, file flows, SSE, or RPC patterns.
- Review FastEndpoints OpenAPI, security, runtime policies, testing, or
  versioning behavior.

## Start with the closest workstream

1. Pick the closest workstream map below.
2. Read only the linked rules needed for the current change.
3. Pull cookbook recipes in only after the core workstream is chosen.
4. Open [AGENTS.md](./AGENTS.md) for cross-workstream review routes, package
   inventory, and maintainer guidance.

## Rule library by workstream

## Foundation and hosting

- Use for `AddFastEndpoints(...)`, `UseFastEndpoints(...)`, package setup,
  shared options, scaffolding, source generation, and Native AOT.
- Rules:
  - [FastEndpoints startup and registration](./rules/foundation-startup-registration.md)
  - [FastEndpoints configuration options](./rules/foundation-configuration-options.md)
  - [FastEndpoints source generation and Native AOT](./rules/foundation-source-generation-aot.md)
  - [FastEndpoints scaffolding](./rules/foundation-scaffolding.md)
- Map: [FastEndpoints foundation map](./references/foundation-map.md)

## Architecture and messaging

- Use for mapper layout, dependency resolution, command or event bus decisions,
  and queue-backed background execution.
- Rules:
  - [FastEndpoints request, entity, and response mapping](./rules/architecture-mapping.md)
  - [FastEndpoints dependency injection and service resolution](./rules/architecture-di-service-resolution.md)
  - [FastEndpoints job queues and background execution](./rules/architecture-job-queues.md)
  - [FastEndpoints commands, events, and bus composition](./rules/architecture-command-event-bus.md)
- Map: [FastEndpoints architecture map](./references/architecture-map.md)

## Request pipeline

- Use for request DTOs, model binding, validators, error contracts, endpoint
  helpers, and reusable pre or post processor flow.
- Rules:
  - [FastEndpoints request DTOs and binding](./rules/contracts-request-dtos-binding.md)
  - [FastEndpoints validation and error contracts](./rules/contracts-validation-errors.md)
  - [FastEndpoints endpoint conveniences and hooks](./rules/pipeline-endpoint-conveniences.md)
  - [FastEndpoints pre and post processors](./rules/pipeline-pre-post-processors.md)
- Map: [FastEndpoints request pipeline map](./references/request-pipeline-map.md)

## Transport and documentation

- Use for Swagger or NSwag setup, endpoint metadata, uploads, downloads,
  streaming, SSE, and RPC-versus-HTTP choices.
- Rules:
  - [Swagger and OpenAPI with FastEndpoints](./rules/docs-swagger-openapi.md)
  - [File handling, streaming, and server-sent events](./rules/transport-files-streaming-sse.md)
  - [RPC and HTTP transport patterns](./rules/transport-rpc-http-patterns.md)
- Map: [FastEndpoints transport and docs map](./references/transport-docs-map.md)

## Runtime and security

- Use for auth, authz, throttling, response caching, idempotency, and
  framework-specific exception handling.
- Rules:
  - [FastEndpoints response caching and rate limiting](./rules/runtime-caching-rate-limits.md)
  - [FastEndpoints idempotency and exception handling](./rules/runtime-idempotency-exceptions.md)
  - [FastEndpoints authentication, authorization, and secure defaults](./rules/security-authn-authz.md)
- Map: [FastEndpoints security and runtime map](./references/security-runtime-map.md)

## Testing and versioning

- Use for endpoint integration tests, handler-only unit tests, release groups,
  and built-in or package-based API versioning.
- Rules:
  - [FastEndpoints testing](./rules/testing-fastendpoints.md)
  - [FastEndpoints versioning and release groups](./rules/versioning-release-groups.md)
- Maps:
  - [FastEndpoints testing and versioning map](./references/testing-versioning-map.md)
  - [FastEndpoints cookbook index](./references/cookbook-index.md)

## Package conventions

- Every rule follows the shared section contract in
  [rules/_sections.md](./rules/_sections.md): `Purpose`, `Default guidance`,
  `Avoid`, `Review checklist`, `Related files`, and `Source anchors`.
- Use [the rule template](./templates/rule-template.md) for new rules,
  [the research pack template](./templates/research-pack-template.md) for
  scoped source inventories, and
  [the comparison matrix template](./templates/comparison-matrix-template.md)
  for external comparisons.
- The taxonomy and preferred ordering live in
  [assets/taxonomy.json](./assets/taxonomy.json) and
  [assets/section-order.json](./assets/section-order.json).

## Standalone-first note

- This skill is authored as a standalone package under `skills`.
- If you document or install the package directly, use
  `npx skills add <source>` rather than `npx skill add`.
- Keep FastEndpoints-specific guidance here. Pull broader ASP.NET Core or
  general .NET guidance only when the task clearly widens beyond this package.
