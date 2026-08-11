# Business Module checklist

Use this before adding a module or accepting a generated module boundary.

## Identity

- [ ] Module represents a genuine business capability.
- [ ] Contracts are intentionally public and implementation types are internal.
- [ ] Dependencies on other modules target Contracts only.
- [ ] The dependency graph remains acyclic.

## Ownership

- [ ] Domain rules, Features, Infrastructure, endpoints, and tests are local.
- [ ] The module owns its `DbContext`, mappings, migrations, naming, schema, and
      concurrency decisions.
- [ ] Cross-module behavior uses an explicit Contract or reliable event.
- [ ] No catch-all shared project owns module behavior.

## Composition

- [ ] `AddServices` registers concrete services explicitly.
- [ ] `MapEndpoints` maps the module's routes explicitly.
- [ ] No assembly scanning, service locator, hidden startup hook, or broad
      default registration is required.
- [ ] Optional providers and capabilities are absent when not selected.

## Verification

- [ ] A vertical-slice test covers the primary use case.
- [ ] Host/API tests cover transport and authorization.
- [ ] Real-provider tests cover persistence claims.
- [ ] Security, diagnostics, migration, and performance evidence is recorded.
