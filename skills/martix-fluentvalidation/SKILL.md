---
name: martix-fluentvalidation
description: Standalone-first FluentValidation guidance for `AbstractValidator<T>` authoring, built-in validator selection, RuleSets and cascade behavior, `ValidateAsync(...)`, `ValidationProblem` mapping, ASP.NET Core integration, `FluentValidation.TestHelper`, error codes, severity, custom state, localization, extensibility, and FluentValidation 11/12 upgrade planning. Use when writing, reviewing, debugging, testing, or upgrading FluentValidation usage in .NET applications.
license: Complete terms in LICENSE.txt
---

# MartiX FluentValidation router

- Standalone-first skill package focused on FluentValidation-specific decisions
  for .NET 10+, C# 14+, ASP.NET Core, and FluentValidation-based applications.
- Keep decisions grounded in the bundled rule files and FluentValidation
  reference maps.
- Use [AGENTS.md](./AGENTS.md) when the task crosses multiple workstreams or
  needs the long-form review routes, package inventory, or maintainer guidance.

## When to use this skill

- Review or scaffold `AbstractValidator<T>` implementations and shared
  validator libraries.
- Choose built-in validators before reaching for `Must`, `Custom`, or reusable
  property validators.
- Tune RuleSets, conditions, cascade behavior, messages, property paths, and
  downstream validation metadata.
- Review `ValidateAsync(...)` call paths, API-boundary mapping with
  `ValidationProblem`, `FluentValidation.TestHelper` coverage, runtime metadata,
  or FluentValidation 11/12 upgrade decisions.

## Quick-start routes

Use the closest row first, then open the linked workstream map for details.

| Task | Start with | Add when |
| --- | --- | --- |
| New validator | [Validator basics](./rules/foundation-validator-basics.md) + [built-in validators map](./references/built-in-validators-map.md) | [Collections and composition](./rules/foundation-collections-composition.md) for child validators or collection rules. |
| API boundary | [ASP.NET Core integration](./rules/integration-aspnet-core.md) + [Web bootstrap recipes](./references/web-bootstrap-recipes.md) | [Async validation](./rules/integration-async-validation.md) when any rule or dependency is async. |
| Validator tests | [Test helper usage](./rules/testing-validator-testhelper.md) + [Testing bootstrap recipes](./references/testing-bootstrap-recipes.md) | Boundary tests only when DI, filters, controllers, or Minimal API behavior is part of the contract. |
| Async bug | [Async validation](./rules/integration-async-validation.md) + [Anti-patterns quick reference](./references/anti-patterns-quick-reference.md) | Verify callers use `ValidateAsync(...)` and pass the ambient `CancellationToken`. |
| Upgrade | [Current baseline](./rules/upgrade-current-baseline.md), [breaking-change history](./rules/upgrade-breaking-changes-history.md), and [compatibility matrix](./references/compatibility-matrix.md) | Scope affected validators, integrations, and tests with the [upgrade map](./references/upgrade-map.md). |

## Default patterns

| Concern | Default | Escalate when |
| --- | --- | --- |
| API boundary validation | Prefer manual validation at the boundary before legacy MVC auto-validation, then map failures to `ValidationProblem` or `Results.ValidationProblem(...)`. | Review legacy MVC auto-validation only for existing code or migration-constrained paths. |
| Async rules | Use `ValidateAsync(...)` and pass the ambient `CancellationToken` whenever any rule or dependency is async. | Keep `Validate(...)` only when the validator and its dependencies are fully synchronous. |
| Rule authoring | Choose built-in validators before `Must`, `Custom`, or reusable custom validators. | Extend only when the built-in validators cannot express the contract clearly. |
| Testing | Start with validator black-box tests via `FluentValidation.TestHelper` before framework-boundary tests. | Add framework-boundary tests only when DI wiring, filters, controllers, or Minimal API behavior is part of the contract. |

## Bootstrap and quick review references

Use [Anti-patterns quick reference](./references/anti-patterns-quick-reference.md),
[Web bootstrap recipes](./references/web-bootstrap-recipes.md), or
[Testing bootstrap recipes](./references/testing-bootstrap-recipes.md) for fast
starts, then return to the rule library for source-backed guidance.

## Start with the closest workstream

Pick the closest map, read only rules needed for the change, and use
[AGENTS.md](./AGENTS.md) for multi-workstream or official-versus-ecosystem
source-boundary reviews.

## Rule library by workstream

## Foundation and composition

- Use for package setup, version baselines, validator shape, nesting,
  collections, and same-root composition.
- Rules:
  - [FluentValidation installation and versioning baseline](./rules/foundation-installation-versioning.md)
  - [FluentValidation validator basics](./rules/foundation-validator-basics.md)
  - [FluentValidation collections and composition](./rules/foundation-collections-composition.md)
- Map: [FluentValidation foundation map](./references/foundation-map.md)

## Built-in validator families

- Use for presence, comparison/range, length/format, enum, regex, and predicate
  decisions.
- Rules:
  - [FluentValidation null, empty, and presence validators](./rules/validators-null-empty.md)
  - [FluentValidation comparison and range validators](./rules/validators-comparison-range.md)
  - [FluentValidation length and format validators](./rules/validators-length-format.md)
  - [FluentValidation enum, predicate, and regex validators](./rules/validators-enum-predicate-regex.md)
- Map: [FluentValidation built-in validators map](./references/built-in-validators-map.md)

## Rule configuration and execution

- Use for messages, placeholders, property paths, RuleSets, conditions, cascade,
  inclusion, and dependent rules.
- Rules:
  - [FluentValidation messages and placeholders](./rules/configuration-messages-placeholders.md)
  - [FluentValidation property names and paths](./rules/configuration-property-names-paths.md)
  - [FluentValidation conditions and RuleSets](./rules/execution-conditions-rulesets.md)
  - [FluentValidation cascade, inclusion, and dependent rules](./rules/execution-cascade-dependent-inclusion.md)
- Map: [FluentValidation rule configuration map](./references/rule-configuration-map.md)

## Integration and application boundaries

- Use for DI, ASP.NET Core, async calls, Minimal APIs, MVC/Razor Pages, and
  Blazor ecosystem evaluation.
- Rules:
  - [FluentValidation DI registration and discovery](./rules/integration-di-registration.md)
  - [FluentValidation ASP.NET Core application integration](./rules/integration-aspnet-core.md)
  - [FluentValidation async validation integration](./rules/integration-async-validation.md)
- Map: [FluentValidation integration map](./references/integration-map.md)
- Ecosystem note:
  - [FluentValidation Blazor ecosystem note](./references/blazor-ecosystem-note.md)

## Extensibility and advanced behavior

- Use for `Must`, `Custom`, reusable extensions, property validators,
  inheritance, `PreValidate`, `RootContextData`, and exception shaping.
- Rules:
  - [FluentValidation custom validator selection](./rules/extensibility-custom-validators.md)
  - [FluentValidation reusable property validators and SetValidator](./rules/extensibility-property-validators.md)
  - [FluentValidation inheritance, pre-validation, and context hooks](./rules/extensibility-inheritance-prevalidate-context.md)
- Map: [FluentValidation extensibility map](./references/extensibility-map.md)

## Runtime metadata and localization

- Use for severity, error codes, custom state, localization, `LanguageManager`,
  and downstream contracts.
- Rules:
  - [FluentValidation severity, error codes, and custom state](./rules/runtime-severity-error-codes-state.md)
  - [FluentValidation localization and language manager](./rules/runtime-localization-language-manager.md)
- Map: [FluentValidation runtime metadata and localization map](./references/runtime-metadata-map.md)

## Testing and verification

- Use for black-box validator tests, `FluentValidation.TestHelper`, async
  paths, DI wiring, and boundary verification.
- Rules:
  - [FluentValidation validator test helper usage](./rules/testing-validator-testhelper.md)
  - [FluentValidation testing integration boundaries](./rules/testing-integration-boundaries.md)
- Map: [FluentValidation testing map](./references/testing-map.md)

## Upgrade and compatibility

- Use for current baselines, staged major upgrades, historical breakages, and
  FluentValidation 8-12 compatibility.
- Rules:
  - [FluentValidation current upgrade baseline](./rules/upgrade-current-baseline.md)
  - [FluentValidation upgrade breaking changes history](./rules/upgrade-breaking-changes-history.md)
- Maps:
  - [FluentValidation upgrade map](./references/upgrade-map.md)
  - [FluentValidation compatibility matrix](./references/compatibility-matrix.md)

## Package conventions

- Every rule follows the shared section contract in
  [rules/_sections.md](./rules/_sections.md): `Purpose`, `Default guidance`,
  `Avoid`, `Review checklist`, `Related files`, and `Source anchors`.
- Use [the rule template](./templates/rule-template.md) for new rules,
  [the research pack template](./templates/research-pack-template.md) for scoped
  source inventories, and
  [the comparison matrix template](./templates/comparison-matrix-template.md)
  for external comparisons.
- Use [metadata.json](./metadata.json) for entrypoints, workstream coverage, and
  distribution notes.

## Standalone-first note

- This is a standalone package under `skills`; install with
  `npx skills add <source>`, not `npx skill add`.
- Keep FluentValidation guidance here; pull broader .NET or ASP.NET Core
  guidance only when the task widens beyond validation behavior.
