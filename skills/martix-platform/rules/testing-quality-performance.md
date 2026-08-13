# TDD, quality gates, and evidence

## Purpose

Make architecture and operational claims verifiable, especially where fakes
cannot model provider, host, or concurrency behavior.

## Default guidance

- Use TDD for each vertical slice: start with the behavior contract, add the
  smallest implementation, then refactor only when the evidence supports it.
- Use TUnit with Microsoft.Testing.Platform where that is the Platform baseline;
  hand off framework mechanics to `martix-tunit`.
- Keep fast unit tests for pure rules and focused integration tests for module
  composition, HTTP, serialization, authorization, and migrations.
- Use the real configured provider for EF Core transaction, isolation,
  concurrency, lease, rollback, and reliable-event claims. InMemory and SQLite
  are useful for limited tests but cannot prove those database behaviors.
- Test both the presence and absence of each selected capability/provider.
  Validate generated topology, package references, configuration, startup
  registration, secrets, and runtime behavior.
- Treat quality gates as executable, fail-closed evidence. Record the exact
  command, environment, artifact, and result for release or migration claims.

## Avoid

- Do not call a passing unit suite proof of provider or deployment behavior.
- Do not skip a negative-capability test because the positive path works.
- Do not accept flaky timing tests, shared mutable fixtures, or unbounded
  parallelism without isolation and a reason.
- Do not mark a capability Supported from documentation alone.

## Review checklist

- [ ] Tests are written at the layer where the behavior is owned.
- [ ] Real-provider evidence covers persistence and delivery claims.
- [ ] Negative generation and configuration tests exist.
- [ ] Security, observability, migration, and performance checks are included.
- [ ] The quality result is reproducible and fail-closed.

## Related files

- [Persistence and reliable events](./persistence-efcore-reliable-events.md)
- [Reliable event semantics](./integration-events-outbox.md)
- [Native AOT and performance](./native-aot-performance-matrix.md)
- [Generated solution checklist](../references/generated-solution-checklist.md)

## Source anchors

- `C:\Git\MartiXDev\Platform\eng\quality-gates.json`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\migration-roadmap.md`
- `C:\Git\MartiXDev\Platform\tests\fixtures\ModularMonolithGeneratedSolution\`
