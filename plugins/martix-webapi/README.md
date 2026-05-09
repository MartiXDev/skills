# MartiX Web API plugin

`martix-webapi` is a thin plugin bundle for planning, implementing, testing, and documenting .NET backend/API projects, especially FastEndpoints-based services.

## Composed skills

| Skill | Use |
| --- | --- |
| `martix-dotnet-csharp` | .NET host shape, ASP.NET Core defaults, C# guidance, diagnostics, testing, and security. |
| `martix-fastendpoints` | Endpoint contracts, startup, request pipeline, transport choices, OpenAPI, security, testing, versioning, and AOT. |
| `martix-fluentvalidation` | Request validation, RuleSets, async validation, localization, validator tests, and validation metadata. |
| `martix-tunit` | API and service test authoring with parallel-friendly TUnit patterns. |
| `martix-markdown` | API docs, README, and markdownlint-aware cleanup. |

## Model-tier guidance

| Work | Tier |
| --- | --- |
| API architecture, project boundaries, security posture, and cross-service design | `premium` |
| Implementing approved endpoint, validator, test, or documentation slices | `medium` |
| Metadata sync, link checks, JSON validation, package inventory checks | `cheap` |

## Parallel guidance

- Use one worktree per vertical slice when endpoint areas do not overlap.
- Keep shared host, marketplace, and template edits in coordinator branches.
- Run repository validation before merging plugin changes.

## Validation

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1
```
