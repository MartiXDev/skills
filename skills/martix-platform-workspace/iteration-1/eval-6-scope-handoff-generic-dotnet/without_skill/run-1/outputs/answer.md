# Scope decision

`martix-platform` should **not** own this answer.

The request is generic C#/.NET work for a non-Martix application: a `Task`-to-`ValueTask` refactor, an ASP.NET Core resilience policy, and FluentValidation `RuleSet`s. It contains no MartiX platform integration, architecture, or operational concern.

## Smallest appropriate handoff

Route it to a general .NET/C# implementation agent (or answer directly without a MartiX skill). Preserve the three requested deliverables; no MartiX-specific context or escalation is needed.
