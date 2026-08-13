# Generated Solution map

Use this map to review a generated modular monolith before adding a feature or
calling the output production-ready.

## Current fixture shape

The current fixture demonstrates:

- one API project;
- one one-shot Migrator project;
- one project per genuine Business Module;
- one consolidated test project;
- explicit API composition of the Migrator boundary and module composition;
- module Contracts as the only cross-module dependency surface;
- module-owned Domain, Features, Infrastructure, endpoints, `DbContext`,
  mappings, migrations, and schema concerns.

The fixture's preview contract and provider must be checked before assuming it
is a supported template output.

## Runtime and migration boundaries

| Concern | Owner | Contract |
| --- | --- | --- |
| HTTP composition | API | Calls explicit module `AddServices` and `MapEndpoints` |
| Migration execution | Migrator | Exactly `validate`, `script`, and `apply` in the current fixture |
| Runtime database | API | `ConnectionStrings:Database` |
| Migration database | Migrator | `ConnectionStrings:MigrationDatabase` |
| Module persistence | Module | Own context, mappings, migrations, and schema |
| Cross-module use | Consumer module | Reference Contracts only |

The API does not migrate or seed during startup. Generation and migration are
not the same lifecycle, and application-owned source must not be overwritten by
rerunning a template.

## Feature shape

Within a module, prefer:

```text
Features\
  CancelOrder\
    CancelOrderEndpoint.cs
    CancelOrderOperation.cs
    CancelOrderRequest.cs
    CancelOrderResponse.cs
    CancelOrderTests.cs
```

Names and exact files can vary, but the use case should remain one discoverable
slice with a thin endpoint and an internal sealed operation.

## Review questions

- Does every project correspond to a real boundary?
- Can a module compile without another module's implementation?
- Is optional infrastructure absent when not selected?
- Are migrations invoked only by the Migrator?
- Are HTTP, persistence, security, and test contracts visible?

## Source anchors

- `C:\Git\MartiXDev\Platform\tests\fixtures\ModularMonolithGeneratedSolution\README.md`
- `C:\Git\MartiXDev\Platform\tests\fixtures\ModularMonolithGeneratedSolution\AGENTS.md`
- `C:\Git\MartiXDev\Platform\tests\fixtures\ModularMonolithGeneratedSolution\martix.platform.json`
