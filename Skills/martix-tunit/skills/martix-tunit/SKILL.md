---
name: martix-tunit
description: >
  Standalone-first TUnit guidance for test authoring, parameterized data-driven
  tests, lifecycle hooks, parallel-by-default execution, async assertions,
  dependency injection, mocking, extensibility, and xUnit/NUnit/MSTest migration.
  Use when writing, reviewing, or migrating TUnit tests on the Microsoft Testing
  Platform.
license: MIT
---

> **Migration pending** — Full skill content will be migrated from
> [MartiXDev/ai-marketplace — src/skills/martix-tunit](https://github.com/MartiXDev/ai-marketplace/tree/main/src/skills/martix-tunit).

## MartiX TUnit skill

This skill provides standalone-first TUnit guidance for:

- Authoring unit and integration tests using TUnit.
- Parameterizing tests with `[Arguments]`, `[MethodDataSource]`, and matrix data.
- Using lifecycle hooks (`[Before]`, `[After]`, `[ClassDataSource]`).
- Writing async test assertions with the TUnit assertion API.
- Managing test parallelism and dependency ordering.
- Injecting dependencies into test classes.
- Extending TUnit with custom data sources and reporters.
- Migrating from xUnit, NUnit, or MSTest to TUnit.

## When to use this skill

- Writing new tests with TUnit.
- Reviewing existing TUnit test structure and assertions.
- Migrating from other .NET test frameworks to TUnit.
- Debugging test parallelism or lifecycle ordering issues.
