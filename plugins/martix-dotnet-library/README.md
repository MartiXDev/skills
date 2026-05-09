# MartiX .NET Library plugin

`martix-dotnet-library` is a thin plugin bundle for creating, updating, reviewing, testing, and documenting .NET library projects.

## Composed skills

| Skill | Use |
| --- | --- |
| `martix-dotnet-csharp` | SDK-style project structure, modern C#, API design, packaging, diagnostics, and security defaults. |
| `martix-tunit` | Test authoring, lifecycle, parallel execution, and framework comparison. |
| `martix-fluentvalidation` | Validator authoring when the library exposes validation contracts. |
| `martix-powershell` | Optional compiled cmdlet or module automation around the library. |
| `martix-markdown` | README, release notes, package docs, and markdownlint-aware cleanup. |

## Model-tier guidance

| Work | Tier |
| --- | --- |
| Library architecture, public API shape, package boundary decisions | `premium` |
| Implementing approved project, test, validation, or documentation slices | `medium` |
| Metadata sync, link checks, JSON validation, package inventory checks | `cheap` |

## Parallel guidance

- Use one worktree per package or concern.
- Keep `.github\plugin\marketplace.json` edits in a shared-file coordinator branch.
- Run repository validation before merging plugin changes.

## Validation

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1
```
