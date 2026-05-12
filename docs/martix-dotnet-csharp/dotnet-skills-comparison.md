## MartiX vs Aaronontheweb dotnet-skills comparison

### Scope

This comparison reviews the canonical MartiX package in
`skills\martix-dotnet-csharp` against the Aaronontheweb comparison set named
in
[`martix-dotnet-csharp.md`](./martix-dotnet-csharp.md).

For the Aaronontheweb side, this report uses the stored overlap inventory in
`external_skill_inventory` and the lane summaries in
`skill_comparison_findings`. That inventory currently marks 9 skills as direct
overlap, 9 as adjacent supporting skills, and 15 as out of scope.

The comparison is intentionally limited to the approved MartiX source boundary
in
[`references/doc-source-index.md`](../../skills/martix-dotnet-csharp/references/doc-source-index.md)
plus the overlapping Aaronontheweb lanes above.

### Key files reviewed

- MartiX package surfaces:
  [`SKILL.md`](../../skills/martix-dotnet-csharp/SKILL.md),
  [`AGENTS.md`](../../skills/martix-dotnet-csharp/AGENTS.md),
  [`README.md`](../../skills/martix-dotnet-csharp/README.md),
  [`metadata.json`](../../skills/martix-dotnet-csharp/metadata.json),
  [`rules/_sections.md`](../../skills/martix-dotnet-csharp/rules/_sections.md),
  [`templates/comparison-matrix-template.md`](../../skills/martix-dotnet-csharp/templates/comparison-matrix-template.md),
  and
  [`references/doc-source-index.md`](../../skills/martix-dotnet-csharp/references/doc-source-index.md)
- MartiX lane evidence:
  [`lang-modern-features.md`](../../skills/martix-dotnet-csharp/rules/lang-modern-features.md),
  [`lang-nullability.md`](../../skills/martix-dotnet-csharp/rules/lang-nullability.md),
  [`lang-pattern-matching.md`](../../skills/martix-dotnet-csharp/rules/lang-pattern-matching.md),
  [`runtime-memory-spans.md`](../../skills/martix-dotnet-csharp/rules/runtime-memory-spans.md),
  [`runtime-collections-immutability.md`](../../skills/martix-dotnet-csharp/rules/runtime-collections-immutability.md),
  [`async-tasks-valuetasks.md`](../../skills/martix-dotnet-csharp/rules/async-tasks-valuetasks.md),
  [`async-concurrency-channels.md`](../../skills/martix-dotnet-csharp/rules/async-concurrency-channels.md),
  [`design-api-type-design.md`](../../skills/martix-dotnet-csharp/rules/design-api-type-design.md),
  [`design-exceptions-validation.md`](../../skills/martix-dotnet-csharp/rules/design-exceptions-validation.md),
  [`web-aspnet-core.md`](../../skills/martix-dotnet-csharp/rules/web-aspnet-core.md),
  [`web-http-resilience.md`](../../skills/martix-dotnet-csharp/rules/web-http-resilience.md),
  [`data-efcore.md`](../../skills/martix-dotnet-csharp/rules/data-efcore.md),
  [`data-serialization.md`](../../skills/martix-dotnet-csharp/rules/data-serialization.md),
  [`testing-unit-integration.md`](../../skills/martix-dotnet-csharp/rules/testing-unit-integration.md),
  [`sdk-project-system.md`](../../skills/martix-dotnet-csharp/rules/sdk-project-system.md),
  [`anti-patterns-quick-reference.md`](../../skills/martix-dotnet-csharp/references/anti-patterns-quick-reference.md),
  [`async-map.md`](../../skills/martix-dotnet-csharp/references/async-map.md),
  [`design-map.md`](../../skills/martix-dotnet-csharp/references/design-map.md),
  [`web-stack-map.md`](../../skills/martix-dotnet-csharp/references/web-stack-map.md),
  [`data-stack-map.md`](../../skills/martix-dotnet-csharp/references/data-stack-map.md),
  [`web-bootstrap-recipes.md`](../../skills/martix-dotnet-csharp/references/web-bootstrap-recipes.md),
  [`testing-bootstrap-recipes.md`](../../skills/martix-dotnet-csharp/references/testing-bootstrap-recipes.md),
  and
  [`libraries-catalog.md`](../../skills/martix-dotnet-csharp/references/libraries-catalog.md)
- Aaronontheweb overlap set from `external_skill_inventory`:
  `csharp-coding-standards`, `csharp-concurrency-patterns`,
  `csharp-api-design`, `csharp-type-design-performance`, `efcore-patterns`,
  `microsoft-extensions-configuration`,
  `microsoft-extensions-dependency-injection`, `project-structure`, and
  `serialization`, with adjacent context from `database-performance`,
  `package-management`, `local-tools`, `snapshot-testing`, `testcontainers`,
  and `crap-analysis`

### Executive summary

- MartiX now covers every direct-overlap Aaronontheweb lane with one integrated
  package: a trigger-rich
  [`SKILL.md`](../../skills/martix-dotnet-csharp/SKILL.md), review routing
  in
  [`AGENTS.md`](../../skills/martix-dotnet-csharp/AGENTS.md), 19 atomic
  rules, 13 reference docs, and explicit authoring and source-boundary
  contracts in
  [`metadata.json`](../../skills/martix-dotnet-csharp/metadata.json) and
  [`doc-source-index.md`](../../skills/martix-dotnet-csharp/references/doc-source-index.md).
- Aaronontheweb/dotnet-skills is still stronger when the question is narrow and
  immediate. Nine dedicated overlap skills are easier to auto-match from
  specific trigger terms such as configuration, dependency injection,
  serialization, or project structure.
- The stored findings show a stable pattern: MartiX leads on package
  architecture, source traceability, and cross-domain routing, while the
  external collection leads when a lane needs one-screen heuristics or deeper
  copy-ready recipes.
- The right reuse path is additive. MartiX should keep the integrated router and
  absorb the best dense-reference ideas into focused `references/*.md`
  appendices rather than splitting itself into many top-level skills.

### Current-state snapshot

| Dimension | MartiX | Aaronontheweb `dotnet-skills` | Takeaway |
| --- | --- | --- | --- |
| Comparison unit | One canonical standalone package with 19 rules, 13 references, recipes, templates, and assets | Nine direct-overlap focused skills plus adjacent operational skills | MartiX is more coherent; Aaronontheweb is easier to consume one lane at a time |
| Triggering model | Broad `SKILL.md` description with quick-start defaults and domain routing | Narrow skill names such as `microsoft-extensions-configuration` and `serialization` | Aaronontheweb is easier to auto-trigger for specific words; MartiX is better when work spans domains |
| Language and style | `lang-*` rules plus design cross-links and anti-pattern routing | Focused `csharp-coding-standards` lane | MartiX is broader; Aaronontheweb is denser |
| Concurrency | `async-*` rules, `async-map.md`, and anti-pattern quick reference | Focused `csharp-concurrency-patterns` lane | MartiX cross-links better; Aaronontheweb is faster for primitive selection |
| Type design and performance | Design, runtime, and async rules share one measured-performance posture | Focused `csharp-type-design-performance` lane | MartiX is safer and more conservative; Aaronontheweb is stronger on heuristics |
| API design | Web, design, failure-contract, and recipe guidance stay connected | Focused `csharp-api-design` lane | MartiX integrates API shape with app architecture; Aaronontheweb is sharper as a single checklist |
| EF Core and data | `data-efcore.md` plus testing and anti-pattern cross-links | `efcore-patterns` plus adjacent `database-performance` | Aaronontheweb is deeper on operational recipes; MartiX is better connected to tests and app shape |
| Configuration and DI | Bootstrap defaults, options map, anti-patterns, and testing overrides live in one package | Dedicated configuration and DI skills | Aaronontheweb is easier to navigate for host-wiring questions; MartiX keeps those choices tied to real app context |
| Serialization | Dedicated rule plus web and testing contract cross-links | Dedicated `serialization` skill | MartiX keeps contract guidance integrated; Aaronontheweb goes deeper on serializer-specific detail |
| Project structure and testing adjacency | SDK/project-system rule, package metadata, `WebApplicationFactory` recipes, and review routes | `project-structure`, `package-management`, `local-tools`, `snapshot-testing`, `testcontainers`, and `crap-analysis` | Aaronontheweb has broader operational add-ons; MartiX keeps the core scope tighter |

### Detailed findings

#### 1. Language and style

MartiX routes language work from
[`SKILL.md`](../../skills/martix-dotnet-csharp/SKILL.md) into
[`lang-modern-features.md`](../../skills/martix-dotnet-csharp/rules/lang-modern-features.md),
[`lang-nullability.md`](../../skills/martix-dotnet-csharp/rules/lang-nullability.md),
[`lang-pattern-matching.md`](../../skills/martix-dotnet-csharp/rules/lang-pattern-matching.md),
and
[`design-api-type-design.md`](../../skills/martix-dotnet-csharp/rules/design-api-type-design.md).
That gives the package one consistent modernization stance: released features
only, small diffs, contract-aware nullability, and readable pattern matching.

The stored `language-style` finding still highlights a real usability gap.
MartiX does not yet have a compact page that answers record vs class vs struct,
null-guard selection, and common pattern-matching shapes as quickly as a
focused `csharp-coding-standards` skill can. Aaronontheweb is stronger as a
concentrated field guide; MartiX is stronger as a conservative,
Microsoft-backed language router. MartiX should borrow density here, not
blanket rules.

#### 2. Concurrency

MartiX has solid concurrency coverage across
[`async-tasks-valuetasks.md`](../../skills/martix-dotnet-csharp/rules/async-tasks-valuetasks.md),
[`async-concurrency-channels.md`](../../skills/martix-dotnet-csharp/rules/async-concurrency-channels.md),
[`async-map.md`](../../skills/martix-dotnet-csharp/references/async-map.md),
and
[`anti-patterns-quick-reference.md`](../../skills/martix-dotnet-csharp/references/anti-patterns-quick-reference.md).
The package already handles `Task` vs `ValueTask`, bounded vs unbounded
channels, cancellation, backpressure, sync-over-async mistakes, and
fire-and-forget hazards with a Microsoft-first set of primitives.

The gap is selection speed. The stored `concurrency` finding is correct that
MartiX still lacks a one-screen selector for `Task.WhenAll`,
`Parallel.ForEachAsync`, `Channel<T>`, concurrent collections, `lock`, and
`SemaphoreSlim`, plus copy-ready worker patterns. Aaronontheweb remains stronger
when the user wants a quick primitive choice. MartiX should improve the
decision aid and still reject broader framework creep such as Akka.NET or Rx
inside the core router.

#### 3. Type design and performance

MartiX spreads type and performance guidance across
[`design-api-type-design.md`](../../skills/martix-dotnet-csharp/rules/design-api-type-design.md),
[`runtime-memory-spans.md`](../../skills/martix-dotnet-csharp/rules/runtime-memory-spans.md),
[`runtime-collections-immutability.md`](../../skills/martix-dotnet-csharp/rules/runtime-collections-immutability.md),
[`async-tasks-valuetasks.md`](../../skills/martix-dotnet-csharp/rules/async-tasks-valuetasks.md),
and the hot-path review routes in
[`AGENTS.md`](../../skills/martix-dotnet-csharp/AGENTS.md). That is a
strength: the package consistently pushes measurement first, explicit ownership,
and narrow abstractions before optimization tricks.

The stored `type-design-performance` finding also holds. MartiX is lighter on
fast heuristics such as struct-vs-class tables, sealing rationale, frozen or
read-only collection guidance, and a short catalog of value-like type patterns.
Aaronontheweb is stronger here as a focused rule card. MartiX should add a
compact quick reference but keep rejecting absolute rules such as "seal
everything" or "all value objects should be structs."

#### 4. API design

MartiX already connects API design to the host and failure model better than a
single-topic guide. Evidence sits in
[`design-api-type-design.md`](../../skills/martix-dotnet-csharp/rules/design-api-type-design.md),
[`design-exceptions-validation.md`](../../skills/martix-dotnet-csharp/rules/design-exceptions-validation.md),
[`web-aspnet-core.md`](../../skills/martix-dotnet-csharp/rules/web-aspnet-core.md),
[`web-bootstrap-recipes.md`](../../skills/martix-dotnet-csharp/references/web-bootstrap-recipes.md),
and
[`design-map.md`](../../skills/martix-dotnet-csharp/references/design-map.md).
Typed results, problem details, guard clauses, and thin endpoints all reinforce
the same contract-first direction.

The stored `API design` finding identifies the missing depth correctly:
MartiX does not yet expose explicit compatibility guidance, deprecation flow, or
API approval testing patterns. Aaronontheweb is stronger when the task is
strictly API surface design. MartiX should add a small compatibility appendix,
not a separate top-level API skill, and can use adjacent approval or snapshot
testing ideas only where they sharpen public-contract review.

#### 5. EF Core

MartiX gives EF Core a strong integrated route through
[`data-efcore.md`](../../skills/martix-dotnet-csharp/rules/data-efcore.md),
[`testing-unit-integration.md`](../../skills/martix-dotnet-csharp/rules/testing-unit-integration.md),
[`testing-bootstrap-recipes.md`](../../skills/martix-dotnet-csharp/references/testing-bootstrap-recipes.md),
and
[`anti-patterns-quick-reference.md`](../../skills/martix-dotnet-csharp/references/anti-patterns-quick-reference.md).
That package shape makes EF work easier to review in context: query behavior,
relational testing, context lifetime, and broader app wiring stay connected.

The external collection is still stronger on concrete EF operational depth. The
stored `EF Core` finding calls out the missing pieces accurately: no-tracking
trade-offs, split queries, migration runners, execution strategy plus
transactions, `ExecuteUpdate` or `ExecuteDelete`, and richer concurrency
examples. Aaronontheweb remains the sharper reference when the question is a
specific EF move. MartiX should add an EF recipes appendix while avoiding a
blanket no-tracking default.

#### 6. Configuration

MartiX now has meaningful configuration coverage in the entrypoint and recipes.
[`SKILL.md`](../../skills/martix-dotnet-csharp/SKILL.md) sets
`ValidateOnStart()` and options binding as a default,
[`web-bootstrap-recipes.md`](../../skills/martix-dotnet-csharp/references/web-bootstrap-recipes.md)
shows real bootstrap shapes,
[`web-stack-map.md`](../../skills/martix-dotnet-csharp/references/web-stack-map.md)
gives a useful `IOptions<T>` vs `IOptionsSnapshot<T>` vs
`IOptionsMonitor<T>` table, and
[`anti-patterns-quick-reference.md`](../../skills/martix-dotnet-csharp/references/anti-patterns-quick-reference.md)
flags missing startup validation directly.

Aaronontheweb is still stronger when the request is specifically about
configuration patterns. The stored `Configuration` finding is right that MartiX
needs deeper examples for `IValidateOptions` with dependencies, named options,
`PostConfigure`, live reload, and option-validator tests. The right adaptation
is a focused configuration recipe page and richer trigger terms, not a new
separate MartiX configuration skill.

#### 7. Dependency injection

MartiX covers DI indirectly but usefully. The package ties DI choices to API
shape in
[`design-api-type-design.md`](../../skills/martix-dotnet-csharp/rules/design-api-type-design.md),
to common lifetime mistakes in
[`anti-patterns-quick-reference.md`](../../skills/martix-dotnet-csharp/references/anti-patterns-quick-reference.md),
to host overrides in
[`testing-bootstrap-recipes.md`](../../skills/martix-dotnet-csharp/references/testing-bootstrap-recipes.md),
and to cross-domain review routes in
[`AGENTS.md`](../../skills/martix-dotnet-csharp/AGENTS.md).

That integrated stance is valuable, but the stored `Dependency injection`
finding is still fair: MartiX lacks a first-class DI decision aid for service
lifetimes, registration composition, keyed services, conditional or factory
registrations, and repeatable test override patterns. Aaronontheweb is stronger
for users who want a DI-only answer. MartiX should add a DI quick reference
instead of widening the skill into specialized container theory.

#### 8. Serialization

MartiX keeps serialization aligned with the rest of the app. The core evidence
is
[`data-serialization.md`](../../skills/martix-dotnet-csharp/rules/data-serialization.md),
the source trail in
[`data-stack-map.md`](../../skills/martix-dotnet-csharp/references/data-stack-map.md),
typed result and problem-details examples in
[`web-bootstrap-recipes.md`](../../skills/martix-dotnet-csharp/references/web-bootstrap-recipes.md),
and contract assertions in
[`testing-bootstrap-recipes.md`](../../skills/martix-dotnet-csharp/references/testing-bootstrap-recipes.md).
That structure is one of MartiX's advantages: payload guidance stays tied to
HTTP contracts, tests, and EF adjacency.

The stored `Serialization` finding still shows where Aaronontheweb is stronger:
source generation, polymorphism, discriminators, tolerant-reader patterns,
Newtonsoft migration, and format-selection trade-offs are not yet surfaced in a
compact MartiX reference. MartiX should deepen this lane with an appendix and
keep `System.Text.Json` as the default instead of making alternate formats look
like the normal path.

#### 9. Project structure and testing adjacency

MartiX intentionally keeps project structure and test infrastructure adjacent to
the core router. The package covers SDK and repository layout in
[`sdk-project-system.md`](../../skills/martix-dotnet-csharp/rules/sdk-project-system.md),
documents package shape and maintainer inventory in
[`README.md`](../../skills/martix-dotnet-csharp/README.md) and
[`metadata.json`](../../skills/martix-dotnet-csharp/metadata.json), and
offers strong ASP.NET Core test bootstrapping in
[`testing-unit-integration.md`](../../skills/martix-dotnet-csharp/rules/testing-unit-integration.md)
and
[`testing-bootstrap-recipes.md`](../../skills/martix-dotnet-csharp/references/testing-bootstrap-recipes.md).

Aaronontheweb's collection is broader around the edges. The inventory shows a
direct-overlap `project-structure` skill plus adjacent `package-management`,
`local-tools`, `snapshot-testing`, `testcontainers`, and `crap-analysis`
surfaces. That makes the external collection stronger when the task is
specifically operational or test-infrastructure focused. MartiX should expose
those adjacencies more clearly, but it should still keep them secondary to the
main router rather than turn every support topic into a separate core lane.

### Where MartiX already leads

- One coherent package architecture with a single trigger surface, 19 rules,
  13 references, and explicit package metadata instead of many loosely related
  entrypoints
- Better source traceability through
  [`doc-source-index.md`](../../skills/martix-dotnet-csharp/references/doc-source-index.md)
  and the shared rule contract in
  [`rules/_sections.md`](../../skills/martix-dotnet-csharp/rules/_sections.md)
- Stronger cross-domain routing between language, web, data, testing,
  diagnostics, and security via
  [`SKILL.md`](../../skills/martix-dotnet-csharp/SKILL.md) and
  [`AGENTS.md`](../../skills/martix-dotnet-csharp/AGENTS.md)
- Better first-party MartiX maintainer support through
  [`README.md`](../../skills/martix-dotnet-csharp/README.md),
  [`metadata.json`](../../skills/martix-dotnet-csharp/metadata.json), and
  [`comparison-matrix-template.md`](../../skills/martix-dotnet-csharp/templates/comparison-matrix-template.md)
- A more measured Microsoft-first posture that resists absolutist rules, narrow
  ecosystem bias, and scope creep
- Existing quick-start defaults, anti-pattern references, bootstrap recipes, and
  library catalog mean MartiX no longer has the thin-entrypoint weakness it had
  earlier in the project

### Where the Aaronontheweb collection is stronger

- Narrower discoverability because each overlap lane already has its own skill
  name
- Denser one-screen heuristics for language/style, type design, and concurrency
- Deeper copy-ready recipes for EF Core, configuration, DI, and serialization
- Stronger adjacent operational coverage through project-structure, package
  management, local tools, snapshot testing, and Testcontainers-oriented paths
- Easier pick-and-install behavior for teams that want only one specialized lane
  instead of a broader review router

### Recommended reuse and adaptation pattern

MartiX should reuse the Aaronontheweb collection as a packaging and density
benchmark, not as a reason to fragment the MartiX skill.

Borrow these ideas:

- add compact appendices for language and type heuristics, concurrency choice,
  EF Core operations, configuration patterns, DI patterns, and serialization
  specifics
- expand trigger wording only with high-signal terms already validated by the
  overlap inventory
- keep recipe-style content in `references/*.md` so the rule files stay compact
  and the package keeps its layered architecture
- use adjacent skills such as `snapshot-testing` or `testcontainers` as
  inspiration for optional routes, not as evidence that MartiX needs more
  top-level domains

Do not borrow these traits:

- splitting MartiX into many narrow top-level skills just to mirror the external
  collection
- adopting absolute guidance such as universal result types, universal structs,
  or universal sealing rules
- widening the main router toward specialized non-core ecosystems or transport
  formats without evidence that MartiX users need that scope
- replacing the current rule-and-map structure with a flat tutorial bundle

### Highest-value improvement targets

| Improvement target | Why it matters | Best fit in MartiX |
| --- | --- | --- |
| Add a language and type quick reference | Closes the biggest language-style density gap without touching the stable rule library | Add a focused `references/*.md` appendix and link it from `SKILL.md`, `AGENTS.md`, and the language or design rules |
| Add a stronger concurrency selector | Makes primitive choice faster for `Task.WhenAll`, `Parallel.ForEachAsync`, channels, concurrent collections, and synchronization primitives | Extend `references/async-map.md` or add a small concurrency quick-reference page |
| Add an EF Core recipes appendix | Supplies the copy-ready depth still missing for tracking mode, split queries, migration runners, bulk updates, and concurrency handling | Add a dedicated `references/*.md` EF Core recipes file linked from `data-efcore.md` and testing docs |
| Add configuration and DI quick references | Makes host wiring, options lifetime, validation, service lifetime, and test override patterns easy to find | Add focused `references/*.md` pages linked from `web-stack-map.md`, `design-map.md`, and the bootstrap recipes |
| Add a serialization appendix | Covers `JsonSerializerContext`, polymorphism, tolerant-reader guidance, and migration choices without bloating the core rule | Add a compact `references/*.md` serialization recipes file linked from `data-serialization.md` |
| Add an API compatibility appendix | Fills the current gap around versioning, deprecation, and approval-style surface checks | Add a small `references/*.md` appendix and route to it from `design-api-type-design.md` and `testing-unit-integration.md` |
| Surface project-structure and testing adjacencies more clearly | Makes package management, local tools, snapshot testing, and Testcontainers easier to discover without widening the core taxonomy | Expand `AGENTS.md`, `README.md`, or a new adjacency note in `references/*.md` |

### Conclusion

MartiX is already the stronger maintained package and the safer default when the
work crosses language, web, data, and testing boundaries. Aaronontheweb
`dotnet-skills` remains the stronger benchmark for narrow, high-density topic
guides.

The next pass should keep MartiX integrated and move the improvement work into
the
[`dotnet-skills improvement plan`](./dotnet-skills-improvement-plan.md),
focusing on compact appendices, stronger trigger wording, and deeper recipes in
the lanes above.
