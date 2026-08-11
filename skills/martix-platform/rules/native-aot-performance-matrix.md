# Native AOT and performance claims

## Purpose

Keep performance and trimming claims precise, measured, and limited to the
actual Platform profile that has evidence.

## Default guidance

- Treat the API-only preset as the primary early Native AOT candidate when its
  exact dependency set is verified. Treat EF Core persistence and full-stack
  profiles as JIT-oriented until their combinations are proven.
- State the exact target framework, runtime, provider, capabilities, linker
  settings, and runner for every AOT or benchmark claim.
- Prefer simple code, bounded work, projection, cancellation, and measured
  allocations before adding spans, pooling, `ValueTask`, custom serializers, or
  concurrency primitives.
- Keep benchmark budgets relative to a pinned environment and compare the same
  generated profile. Include startup, throughput, latency, allocation, and
  failure behavior where they matter.
- Verify trimming warnings and published artifact parity. Do not suppress a
  warning merely to make the publish succeed.

## Avoid

- Do not claim that every generated preset is Native AOT compatible.
- Do not optimize a cold or unmeasured path at the expense of clarity.
- Do not compare different providers, capabilities, runners, or build modes as
  if they were one benchmark.
- Do not use reflection or runtime discovery when compile-time composition is
  the design requirement.

## Review checklist

- [ ] Exact supported AOT/profile combination is named.
- [ ] Warnings, published artifact, and runtime smoke test are checked.
- [ ] Performance target and runner are reproducible.
- [ ] Optimization has a measured reason and preserves cancellation and errors.
- [ ] JIT-first profiles are not given unsupported AOT claims.

## Related files

- [Preset capabilities](./foundation-preset-capabilities.md)
- [Testing and quality](./testing-quality-performance.md)
- [Migrations and AOT](./delivery-migrations-aot.md)
- `martix-dotnet-csharp` runtime and SDK rules

## Source anchors

- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\platform-blueprint.md`
- `C:\Git\MartiXDev\Platform\eng\quality-gates.json`
