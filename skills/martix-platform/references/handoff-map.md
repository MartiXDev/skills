# MartiX skill handoff map

| Primary concern | Use |
| --- | --- |
| MartiX.Platform architecture, Generated Solutions, module boundaries, Platform contracts, capabilities, migrations, or quality claims | `martix-platform` |
| General C#/.NET, SDK, ASP.NET Core, EF Core, async, diagnostics, or security practice | `martix-dotnet-csharp` |
| FastEndpoints endpoint types, processors, transport, or adapter configuration | `martix-fastendpoints` |
| FluentValidation rules, RuleSets, localization, or validator testing | `martix-fluentvalidation` |
| TUnit or Microsoft.Testing.Platform mechanics | `martix-tunit` |
| MartiX Fluent 2 UI component design | `martix-fluent-ui` |
| Markdown package maintenance | `martix-markdown` |

Keep the Platform skill as the lead when the question crosses several rows but
the architectural decision is still Platform-specific. Hand off only the
narrow implementation detail, then return to the Platform boundary for review.
