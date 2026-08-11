# Composition and ownership

## Purpose

Keep Platform packages and generated applications explicit, dependency-light,
and easy to reason about as the number of modules grows.

## Default guidance

- Prefer composition over inheritance, internal and sealed types by default,
  small deep modules, and compile-time composition.
- Keep `MartiX.Platform` framework-independent. Do not pull hosting, DI,
  logging, JSON, ASP.NET Core, EF Core, or third-party dependencies into the
  Kernel to make an adapter convenient.
- Compose each module through explicit `AddServices` and `MapEndpoints`
  methods. The API calls those methods deliberately; do not use a generic
  `IModule`, reflection discovery, or assembly scanning.
- Register concrete Application Operations directly. Add an interface only for a
  real boundary, multiple implementations, or a meaningful test seam.
- Keep a module's Contracts assembly as its public surface. Domain, Features,
  Infrastructure, endpoints, mappings, migrations, and persistence details stay
  internal to that module.
- Apply SOLID as a reasoned constraint: dependencies point inward, policies are
  explicit, and abstractions are introduced only when they remove a real
  coupling or variation.

## Avoid

- Do not use service location, hidden startup hooks, broad `AddDefaults`, or
  reflection-based registration to make composition look shorter.
- Do not add interface-per-class wrappers, universal base entities, catch-all
  shared projects, or speculative abstractions.
- Do not let one module reach another module's implementation assembly or
  persistence context.

## Review checklist

- [ ] The composition graph is visible at compile time.
- [ ] Kernel dependencies remain framework-independent.
- [ ] Module public surfaces are limited to Contracts and explicit composition.
- [ ] Concrete registrations and visibility choices are intentional.
- [ ] A proposed abstraction has a current consumer or variation.

## Related files

- [Modular monolith](./architecture-modular-monolith.md)
- [Vertical slices](./architecture-vertical-slices.md)
- [Generated solution map](../references/generated-solution-map.md)
- [Anti-patterns](../references/anti-patterns.md)

## Source anchors

- `C:\Git\MartiXDev\Platform\src\MartiX.Platform\README.md`
- `C:\Git\MartiXDev\Platform\tests\fixtures\ModularMonolithGeneratedSolution\AGENTS.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\platform-blueprint.md`
