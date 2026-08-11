# Presets, capabilities, and providers

## Purpose

Make generated applications deterministic, explicit, and fail-closed when
presets, optional capabilities, providers, or module dependencies are selected.

## Default guidance

- Use the `modular-monolith` preset as the default production-oriented shape.
  Keep `api` and `full-stack` as separate presets rather than mixing UI or
  persistence into every application.
- Select only declared capabilities and providers. Validate the complete
  combination before generation and reject invalid combinations before writing
  source.
- Treat absence as a contract: test that an unselected capability, provider,
  UI, broker, cache, job system, or auth seam leaves no projects, references,
  configuration, startup registration, or secret placeholders behind.
- Keep provider-independent application code behind a small explicit seam.
  Provider adapters must declare their configuration, health, failure, and
  quality-gate evidence.
- Keep the module dependency graph explicit, acyclic, and visible in the
  manifest. A module may reference another module's Contracts only.
- Prefer deterministic generated output and a manifest that records the
  selected preset, capabilities, providers, modules, and Platform version.

## Avoid

- Do not generate infrastructure by default merely because it might be useful.
- Do not accept an invalid capability/provider combination and fail later at
  runtime or during a half-written generation.
- Do not leave dead package references, empty options, or hidden startup hooks
  when a capability is absent.
- Do not make every app depend on microservices, Kubernetes, brokers, cloud
  services, distributed caches, or a UI.

## Review checklist

- [ ] Preset and capability/provider choices are explicit and validated.
- [ ] Positive and negative presence tests cover the generated output.
- [ ] Provider adapters have a documented seam and evidence profile.
- [ ] The manifest is deterministic and contains no secrets.
- [ ] Unsupported combinations fail before files are emitted.

## Related files

- [Generated solution map](../references/generated-solution-map.md)
- [Capability/provider matrix](../references/capability-provider-matrix.md)
- [Generated solution checklist](../references/generated-solution-checklist.md)
- [Migrations and AOT](./delivery-migrations-aot.md)

## Source anchors

- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\platform-blueprint.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\migration-roadmap.md`
- `C:\Git\MartiXDev\Platform\tests\fixtures\ModularMonolithGeneratedSolution\martix.platform.json`
- `C:\Git\MartiXDev\Platform\eng\quality-gates.json`
