# Scope decision

`martix-platform` should **not** own this answer. The request is explicitly for a non-Martix application and concerns general C#/.NET, ASP.NET Core, and FluentValidation guidance. The skill directs such work to specialized handoffs.

## Smallest handoff

- **Task → ValueTask refactoring** and the **generic ASP.NET Core resilience policy**: hand off to `martix-dotnet-csharp`.
- **Detailed FluentValidation RuleSets**: hand off to `martix-fluentvalidation`.

No `martix-platform` involvement is needed unless the request later becomes MartiX.Platform-specific or asks about MartiX architecture, contracts, or conventions.
