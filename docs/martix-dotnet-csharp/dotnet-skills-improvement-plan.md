## MartiX dotnet-skills improvement plan

### Goal

This plan turns the Aaronontheweb `dotnet-skills` comparison into a
practical backlog for `skills\martix-dotnet-csharp`. For the source
comparison, see
[`dotnet-skills-comparison.md`](./dotnet-skills-comparison.md).

The goal is to deepen the current MartiX package where the findings show
repeated, general-purpose .NET/C# gaps, while keeping niche tool workflows
and ecosystem-specific material outside the core router.

### Planning principles

- Preserve the unified `martix-dotnet-csharp` package. The findings support
  targeted expansion, not a split into many narrow skills.
- Prefer compact maps, checklists, and recipe pages over turning rule files
  into tutorials.
- Adapt ideas from the external skills without copying wording or importing
  package-specific bias.
- Keep the package centered on general .NET/C#, ASP.NET Core, EF Core,
  configuration, DI, testing, and SDK-style repo guidance.
- Add new surface area only when it fits existing routes and can be linked
  from `SKILL.md` and `AGENTS.md` without making discovery noisier.
- Treat tool workflows, Linux distro troubleshooting, reverse engineering,
  and ecosystem-specific guidance as future-skill candidates or non-goals.
- Avoid blanket defaults that the findings explicitly rejected, such as
  `Result<T>` everywhere, universal `readonly record struct`, or
  no-tracking-by-default as a global EF Core rule.

### Current-state snapshot

| Signal from the findings | Concrete evidence | Plan impact |
| --- | --- | --- |
| MartiX already covers the main .NET/C# lanes | `external_skill_inventory` classifies 9 skills as `direct overlap`, and `skill_comparison_findings` shows local coverage across language/style, concurrency, type design, API design, EF Core, configuration, DI, and serialization | Keep the current package shape and invest in targeted deepening |
| The biggest gap is decision density | The repeated gaps are quick-reference selectors, compatibility notes, and copy-ready examples rather than missing top-level domains | Prioritize maps, appendices, and recipes before adding more rules |
| A small set of adjacent topics belongs in the package | `skill_findings` marks 5 areas as `add`: project structure, database performance, package management, snapshot testing, and Testcontainers | Treat these as the main expansion backlog for the existing package |
| Some useful topics should still remain separate | `skill_findings` marks 5 areas as `separate future skill`: local tools, dev-certificate trust, ILSpy, Slopwatch, and CRAP analysis | Keep the current skill focused and push tool workflows outward |
| The core package has firm scope boundaries | `external_skill_inventory` marks 15 skills as `out-of-scope`, led by Akka.NET, Aspire, MJML, Playwright, and marketplace-meta content | Record clear non-goals so later work does not drift |

| Gap cluster | Evidence from findings | Practical backlog |
| --- | --- | --- |
| Language and type design | `language-style` and `type-design-performance` call for record-vs-class-vs-struct heuristics, null-guard patterns, pattern-matching recipes, sealing rationale, deferred enumeration examples, and frozen collections | Add a compact language/type quick reference and deepen the relevant rule files with only the most reusable snippets |
| Concurrency decisions | `concurrency` asks for a one-screen selector and examples for `Parallel.ForEachAsync`, bounded `Channel<T>` workers, and primitive tradeoffs | Expand `async-map.md` and the async rules into a sharper chooser |
| Contract design | `API design` asks for compatibility/versioning guidance, deprecation flow, and API approval testing | Add an API compatibility appendix and link it from design and testing surfaces |
| Configuration and DI | `Configuration` and `Dependency injection` call for `IValidateOptions` dependencies, named options, `PostConfigure`, keyed services, and test override patterns | Add focused configuration and DI decision aids instead of a separate DI skill |
| Data and serialization | `EF Core` and `Serialization` call for no-tracking tradeoffs, split queries, bulk updates, concurrency/retry patterns, source generation, polymorphism, and tolerant-reader guidance | Expand existing data rules and add targeted recipe appendices |

### Priority overview

| Priority | Theme | Outcome |
| --- | --- | --- |
| P1 | Deepen the direct-overlap gaps | Better decision support in the domains MartiX already claims to cover |
| P2 | Absorb adjacent topics that fit the package | Small, high-value additions without splitting the router |
| P3 | Keep future-skill candidates and non-goals out of the core | Preserve package coherence and avoid tool-workflow bloat |

### P1 - Deepen the current core package

| Backlog item | Why now | Likely landing zones |
| --- | --- | --- |
| Add a language/type quick reference | Two findings rows ask for record/class/struct, null-guard, pattern matching, struct-vs-class, sealing, and frozen-collection heuristics | `references/csharp-language-map.md`, `references/design-map.md`, `rules/lang-modern-features.md`, `rules/lang-pattern-matching.md`, `rules/design-api-type-design.md`, `rules/runtime-collections-immutability.md` |
| Add a concurrency selector with copy-ready examples | The concurrency finding explicitly calls out missing selection guidance and snippets | `references/async-map.md`, `rules/async-tasks-valuetasks.md`, `rules/async-concurrency-channels.md`, `AGENTS.md` |
| Add an API compatibility and approval-testing appendix | The API design finding asks for versioning, deprecation, and approval patterns | new `references/api-compatibility-checklist.md`, `rules/design-api-type-design.md`, `rules/testing-unit-integration.md`, `references/libraries-catalog.md` |
| Add focused configuration and DI decision aids | Both findings call for named options, `IValidateOptions`, keyed services, and test override reuse | new `references/configuration-recipes.md`, new `references/di-lifetime-map.md`, `references/web-stack-map.md`, `SKILL.md`, `AGENTS.md` |
| Add EF Core and serialization recipe depth | Both findings ask for more operational examples inside domains already owned by MartiX | new `references/efcore-recipes.md`, new `references/serialization-recipes.md`, `rules/data-efcore.md`, `rules/data-serialization.md` |

### P2 - Fold in adjacent topics that fit the current package

| Add candidate | Planned scope inside `martix-dotnet-csharp` | Likely landing zones |
| --- | --- | --- |
| `project-structure` | Compact guidance on repo-root defaults, `.slnx`, `Directory.Build.*`, `Directory.Packages.props`, `global.json`, SourceLink, and `NuGet.Config` | `references/dotnet-sdk-map.md`, `rules/sdk-project-system.md`, `README.md` |
| `package-management` | CPM defaults, `VersionOverride` escape hatch, vulnerability and deprecation checks, and when to inspect `NuGet.Config` | `references/dotnet-sdk-map.md`, `rules/sdk-build-test-pack-publish.md`, `rules/sdk-project-system.md` |
| `database-performance` | Projection-first queries, read-path no-tracking decisions, row limits, split queries, and N+1 avoidance | `rules/data-efcore.md`, `references/data-stack-map.md`, `references/anti-patterns-quick-reference.md` |
| `snapshot-testing` | Approval testing for API surface, serialized output, HTML or email rendering, and scrubbing dynamic values | `rules/testing-unit-integration.md`, `references/testing-bootstrap-recipes.md`, `references/libraries-catalog.md` |
| `testcontainers` | When SQLite is not enough, fixture lifetime, random ports, and realistic database or broker tests | `rules/testing-unit-integration.md`, `references/testing-bootstrap-recipes.md`, `references/libraries-catalog.md` |

### Better as separate future MartiX skills

| Future skill candidate | Why separate | Current package stance |
| --- | --- | --- |
| `local-tools` | Useful, but mostly a repo-tooling workflow around `.config\dotnet-tools.json` and `dotnet tool restore` | Keep at most a brief mention in core docs; move the full workflow to a future repo-tooling skill |
| `dotnet-devcert-trust` | Distro-specific operational troubleshooting, especially for Linux or Aspire setups | Keep out of `martix-dotnet-csharp`; revisit only in a future dev-environment skill |
| `ilspy-decompile` | Reverse-engineering and inspection workflow, not day-to-day coding guidance | Treat as a future diagnostics or reverse-engineering skill |
| `slopwatch` | Valuable AI-quality gate, but tied to one specialized tool and workflow | Keep only general anti-slop principles in core; move setup and hooks elsewhere |
| `crap-analysis` | Coverage and hotspot reporting are useful, but the workflow is mainly coverlet plus ReportGenerator orchestration | Save the operational guidance for a future quality-analysis skill |

### Explicit non-goals and rejections

- Topic-level non-goals:
  - Do not pull Akka.NET skills into `martix-dotnet-csharp`.
  - Do not add Aspire-specific configuration, service-defaults, or
    integration-testing guidance to the core package.
  - Do not widen the package into MJML email authoring, Playwright Blazor
    or CI caching, or marketplace-publishing workflow documentation.
  - Do not absorb `verify-email-snapshots`; keep that tied to a future email
    or template-testing skill if demand appears.
- Rule-level rejections from the findings:
  - Do not adopt blanket functional-style defaults or require `Result<T>`
    everywhere.
  - Do not turn `readonly record struct`, `struct`, or `sealed` into
    universal rules without semantic context.
  - Do not route the main concurrency or API guidance into Akka.NET or Rx
    patterns.
  - Do not make `AsNoTracking` the global EF Core default for every path.
  - Do not push Protobuf or MessagePack as broad defaults; keep
    `System.Text.Json` as the default and treat other formats as escalation
    paths.
  - Do not split configuration into a separate top-level MartiX skill unless
    routing data later shows the unified package is failing discovery.

### Suggested file-level targets

| Path | Change type | Reason |
| --- | --- | --- |
| `skills\martix-dotnet-csharp\SKILL.md` | Update | Add trigger terms for configuration and DI specifics, project structure, snapshot testing, and Testcontainers while keeping non-goals explicit |
| `skills\martix-dotnet-csharp\AGENTS.md` | Update | Route to the new appendices and keep future-skill handoffs clear |
| `skills\martix-dotnet-csharp\README.md` | Update | Keep the package summary and scope aligned after new references land |
| `skills\martix-dotnet-csharp\metadata.json` | Review and maybe update | Keep discoverability text and maturity notes consistent with the package surface |
| `skills\martix-dotnet-csharp\references\async-map.md` | Expand | Add the concurrency selector and example routes |
| `skills\martix-dotnet-csharp\references\dotnet-sdk-map.md` | Expand | Add project-structure and package-management guidance |
| `skills\martix-dotnet-csharp\references\testing-bootstrap-recipes.md` | Expand | Add Testcontainers and snapshot-testing decision points |
| `skills\martix-dotnet-csharp\references\libraries-catalog.md` | Expand | Add `Verify.*`, `Testcontainers.*`, and related package guidance |
| `skills\martix-dotnet-csharp\rules\design-api-type-design.md` | Expand | Add API compatibility, deprecation, and type-design heuristics |
| `skills\martix-dotnet-csharp\rules\data-efcore.md` | Expand | Add database-performance and advanced EF Core guidance |
| `skills\martix-dotnet-csharp\rules\data-serialization.md` | Expand | Add source generation, polymorphism, and tolerant-reader guidance |
| `skills\martix-dotnet-csharp\rules\testing-unit-integration.md` | Expand | Add snapshot-testing and infrastructure-test patterns |
| `skills\martix-dotnet-csharp\rules\sdk-build-test-pack-publish.md` | Expand | Add package-management checks and repo hygiene guidance |
| `skills\martix-dotnet-csharp\rules\sdk-project-system.md` | Expand | Add modern repo-shape guidance |
| `skills\martix-dotnet-csharp\references\api-compatibility-checklist.md` | New file | Capture API versioning, deprecation, approval testing, and PR checks |
| `skills\martix-dotnet-csharp\references\configuration-recipes.md` | New file | Cover `IValidateOptions` dependencies, named options, `PostConfigure`, and validator tests |
| `skills\martix-dotnet-csharp\references\di-lifetime-map.md` | New file | Cover lifetimes, keyed services, factory registrations, and test overrides |

### Recommended implementation order

1. Add the small, reusable decision aids that close the repeated
   direct-overlap gaps: concurrency, language or type design, API
   compatibility, configuration, and DI.
2. Expand existing data and testing surfaces with EF Core depth,
   serialization depth, snapshot testing, and Testcontainers.
3. Extend SDK and build surfaces with project-structure and
   package-management guidance.
4. Update `SKILL.md`, `AGENTS.md`, `README.md`, and `metadata.json` so the
   new content is discoverable and the scope stays clear.
5. Record separate future-skill items and explicit non-goals so later work
   does not backslide into tool-workflow sprawl.

### Definition of done

The improvement work should be considered complete when:

- each P1 and P2 backlog item has landed in a concrete file target or has an
  explicit defer decision with rationale
- `SKILL.md` and `AGENTS.md` route to the new maps and recipes without
  expanding into noise
- the package covers the approved `skill_findings` additions without
  absorbing the separate-skill or out-of-scope topics
- `README.md` and `metadata.json` match the final package scope
- non-goals remain explicit: no Akka.NET, Aspire, Playwright,
  marketplace-meta, or blanket one-size-fits-all rules in the core package
- the backlog remains traceable to the comparison findings tables and the
  linked comparison document
