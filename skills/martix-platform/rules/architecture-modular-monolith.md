# Modular monolith application shape

## Purpose

Give a new MartiX web application a clear production-oriented boundary without
forcing distributed-system infrastructure before it is justified.

## Default guidance

- Start with one API, one one-shot Migrator, one project per genuine Business
  Module, and one consolidated test project. Add another process or project
  only when a real boundary requires it.
- Keep the API as the composition root. It composes modules and the migration
  boundary; it does not own module internals.
- Model modules around business capabilities, not technical layers or tables.
  A module owns its Contracts, Domain, Features, Infrastructure, endpoints,
  EF Core context, mappings, migrations, and schema concerns.
- Allow module-to-module dependencies only through the referenced module's
  Contracts. Keep the graph acyclic and reject cycles before generation.
- Keep migration execution separate from API startup. The API reads
  `ConnectionStrings:Database`; migration operations use
  `ConnectionStrings:MigrationDatabase`.
- Keep UI, brokers, cloud services, Kubernetes, and distributed caches
  optional. A modular monolith is not a failed microservice system.

## Avoid

- Do not create `Shared`, `Common`, or `Application` dumping grounds that own
  business behavior for every module.
- Do not let the API query another module's `DbContext` or bypass its Contracts.
- Do not run migrations or seed data as a hidden startup side effect.
- Do not split into microservices, add a broker, or require Kubernetes without a
  measurable boundary and an operational plan.

## Review checklist

- [ ] The module list reflects business ownership.
- [ ] The project topology and dependency graph are explicit.
- [ ] Each module owns persistence and schema decisions.
- [ ] API and Migrator responsibilities are separate.
- [ ] The chosen preset does not contain accidental optional infrastructure.

## Related files

- [Vertical slices](./architecture-vertical-slices.md)
- [Composition and ownership](./platform-composition-ownership.md)
- [Generated solution map](../references/generated-solution-map.md)
- [Module checklist](../templates/module-slice-checklist.md)

## Source anchors

- `C:\Git\MartiXDev\Platform\tests\fixtures\ModularMonolithGeneratedSolution\README.md`
- `C:\Git\MartiXDev\Platform\tests\fixtures\ModularMonolithGeneratedSolution\AGENTS.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\platform-blueprint.md`
