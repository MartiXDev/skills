## MartiX vs dotnet-10-csharp-14 comparison

### Scope

This comparison reviews the current repo-local copies of:

- `src/skills/martix-dotnet-csharp`
- `.agents/skills/dotnet-10-csharp-14`

The comparison is intentionally limited to the approved MartiX source boundary in
[`references/doc-source-index.md`](../../src/skills/martix-dotnet-csharp/references/doc-source-index.md)
plus the tagged 3rd-party skill files that were requested for review.

### Key files reviewed

- MartiX:
  [`SKILL.md`](../../src/skills/martix-dotnet-csharp/SKILL.md),
  [`AGENTS.md`](../../src/skills/martix-dotnet-csharp/AGENTS.md),
  [`README.md`](../../src/skills/martix-dotnet-csharp/README.md),
  [`metadata.json`](../../src/skills/martix-dotnet-csharp/metadata.json),
  [`templates/comparison-matrix-template.md`](../../src/skills/martix-dotnet-csharp/templates/comparison-matrix-template.md),
  and
  [`references/doc-source-index.md`](../../src/skills/martix-dotnet-csharp/references/doc-source-index.md)
- 3rd-party:
  [`SKILL.md`](../../.agents/skills/dotnet-10-csharp-14/SKILL.md),
  [`anti-patterns.md`](../../.agents/skills/dotnet-10-csharp-14/anti-patterns.md),
  [`infrastructure.md`](../../.agents/skills/dotnet-10-csharp-14/infrastructure.md),
  [`testing.md`](../../.agents/skills/dotnet-10-csharp-14/testing.md),
  and
  [`libraries.md`](../../.agents/skills/dotnet-10-csharp-14/libraries.md)

### Executive summary

- MartiX is stronger as a layered, maintainable, source-traceable skill package.
- `dotnet-10-csharp-14` is stronger as an immediately usable field guide for
  day-one implementation work.
- The best improvement path is not to flatten MartiX into one large tutorial.
  Instead, MartiX should keep its rule-and-map architecture and add a thin
  action layer on top of it.

### Current-state snapshot

| Dimension | MartiX | `dotnet-10-csharp-14` | Takeaway |
| --- | --- | --- | --- |
| Package shape | Layered router with rules, references, templates, assets, and metadata | Flat quick-reference bundle with topic guides | MartiX is easier to maintain; 3rd-party is faster to consume |
| Triggering style | Broad, task-oriented, review-first | Concrete, feature-oriented, build-first | MartiX is flexible; 3rd-party is easier to auto-trigger for common web/API tasks |
| Quick start | No copy-ready starter in the entrypoint | Includes `.csproj` and `Program.cs` setup in `SKILL.md` | 3rd-party wins for first-use experience |
| Prescriptive defaults | Guidance is distributed across rule files | Entry file has mandatory patterns and quick-reference card | 3rd-party is more actionable for less experienced users |
| Anti-patterns | Present in `Avoid` sections across rules | Dedicated anti-pattern guide plus quick table | 3rd-party makes "what not to do" easier to find |
| Infrastructure help | Spread across atomic rules | Deep, code-heavy infrastructure guide | 3rd-party is stronger for app bootstrap tasks |
| Testing help | High-level guidance in one focused rule | Ready-to-copy `WebApplicationFactory` patterns | 3rd-party is stronger for test scaffolding |
| Ecosystem guidance | No central package catalog | Dedicated libraries reference | 3rd-party is stronger for package selection |
| Source traceability | Strong, explicit, and documented | Present, but lighter and less structured | MartiX is stronger for maintenance and trust |
| Authoring support | Comparison template, rule template, taxonomy, ordering metadata | No equivalent authoring layer | MartiX is stronger for long-term growth |

### Detailed findings

#### 1. Skill model and package structure

MartiX is built as a standalone-first package that routes the reader into a
layered library:

- [`SKILL.md`](../../src/skills/martix-dotnet-csharp/SKILL.md) acts as the
  router.
- [`AGENTS.md`](../../src/skills/martix-dotnet-csharp/AGENTS.md) explains
  cross-domain review routes.
- `rules/*.md` holds 19 atomic decision guides.
- `references/*.md` holds the source-backed map layer.
- `templates/*.md`, `assets/*.json`, and
  [`metadata.json`](../../src/skills/martix-dotnet-csharp/metadata.json)
  support maintainers.

The 3rd-party skill is much flatter. Its
[`SKILL.md`](../../.agents/skills/dotnet-10-csharp-14/SKILL.md) carries a large
part of the immediate value itself, then links into a short set of topic files.

Implication:

- MartiX scales better for maintenance and future expansion.
- `dotnet-10-csharp-14` scales better for a reader who wants a solution within
  the first screen or two of content.

#### 2. Triggering and discoverability

MartiX already has a solid description:

> "Standalone-first .NET 10+ and C# 14+ guidance for code review,
> modernization, refactoring, and scaffolding..."

That description is broad and task-centric, which is useful for code review,
refactoring, and architecture work. The 3rd-party description is narrower, but
it names concrete triggers such as:

- minimal APIs
- modular monolith patterns
- options pattern
- channels
- validation
- outdated extension method syntax

Implication:

- MartiX is easier to justify for broad .NET work.
- The 3rd-party skill is easier to trigger for specific implementation tasks
  because its description contains more of the words real users are likely to
  type.

#### 3. First-use experience and immediate actionability

The biggest difference is how quickly a user can act after the skill triggers.

`dotnet-10-csharp-14` gives the user immediate copy-ready content in
[`SKILL.md`](../../.agents/skills/dotnet-10-csharp-14/SKILL.md):

- a minimal `.csproj`
- a bootstrapped `Program.cs`
- middleware ordering
- a default module registration shape
- a mandatory patterns table
- a quick-reference card

MartiX deliberately routes the reader toward the right rule cluster, but it does
not yet offer the same "start here" shortcut in its entrypoint. The result is a
better long-term architecture, but a weaker first two minutes of use.

#### 4. Anti-pattern coverage

MartiX rules consistently include `Avoid` sections, which is a strong authoring
contract. However, those warnings are distributed across many files.

The 3rd-party skill centralizes these mistakes in
[`anti-patterns.md`](../../.agents/skills/dotnet-10-csharp-14/anti-patterns.md),
with a quick-reference table and short `WRONG` / `CORRECT` examples for issues
such as:

- `new HttpClient()`
- blocking async
- exceptions for flow control
- singleton-to-scoped injection
- missing `ValidateOnStart()`

Implication:

- MartiX already knows many of the right cautions.
- The 3rd-party skill presents those cautions in a faster, more memorable way.

#### 5. Infrastructure and bootstrap guidance

The 3rd-party
[`infrastructure.md`](../../.agents/skills/dotnet-10-csharp-14/infrastructure.md)
is a strong implementation guide because it combines:

- `IOptions<T>` selection
- `ValidateOnStart()` patterns
- built-in HTTP resilience
- channels
- health checks
- caching
- logging
- EF Core guidance

MartiX covers many of the same topics, but the guidance is spread across atomic
rules and maps. That improves precision, but it makes full app bootstrapping
feel more fragmented.

#### 6. Testing guidance

MartiX includes
[`rules/testing-unit-integration.md`](../../src/skills/martix-dotnet-csharp/rules/testing-unit-integration.md),
which fits the rule-library design. The 3rd-party
[`testing.md`](../../.agents/skills/dotnet-10-csharp-14/testing.md) goes much
further on immediate implementation support with:

- `WebApplicationFactory<Program>` setup
- test auth handler patterns
- database replacement for tests
- filter and validation examples

Implication:

- MartiX is currently better at telling the reader what to think about.
- The 3rd-party skill is better at showing the reader what to paste and adapt.

#### 7. Package and ecosystem guidance

MartiX does not currently expose a single package-selection guide.

The 3rd-party
[`libraries.md`](../../.agents/skills/dotnet-10-csharp-14/libraries.md)
provides quick guidance for libraries such as MediatR, FluentValidation,
Mapster, ErrorOr, Polly, and Serilog.

Implication:

- MartiX keeps the core package cleaner and less opinionated.
- The 3rd-party skill reduces user uncertainty when the task includes package
  selection.

#### 8. Traceability and maintainability

This is where MartiX clearly leads.

MartiX has:

- an explicit approved-source boundary in
  [`references/doc-source-index.md`](../../src/skills/martix-dotnet-csharp/references/doc-source-index.md)
- a rule contract in
  [`rules/_sections.md`](../../src/skills/martix-dotnet-csharp/rules/_sections.md)
- a comparison template in
  [`templates/comparison-matrix-template.md`](../../src/skills/martix-dotnet-csharp/templates/comparison-matrix-template.md)
- machine-readable taxonomy and ordering assets
- package identity and structure in
  [`metadata.json`](../../src/skills/martix-dotnet-csharp/metadata.json)

The 3rd-party skill is effective, but it does not provide the same maintainable
authoring framework. It is better as a polished field guide than as a structured
knowledge base.

### Where MartiX already leads

- Better separation of concerns between routing, rule content, references, and
  maintainer assets
- Clearer source provenance and safer scope boundaries
- Reusable templates for future comparisons and rule additions
- More balanced coverage across language, SDK, runtime, async, design, web,
  data, diagnostics, testing, and security
- Stronger long-term package growth model

### Where `dotnet-10-csharp-14` is currently stronger

- Faster onboarding from the entrypoint
- More visible defaults and "do this, not that" guidance
- More copy-ready bootstrap examples for web/API projects
- Better centralized anti-pattern and testing references
- Better package-selection guidance for common architectural stacks

### Recommended reuse pattern

MartiX should borrow the following ideas:

- a compact quick-start section
- a short default-patterns table
- a centralized anti-pattern quick reference
- recipe-style reference docs for infrastructure and testing
- stronger trigger keywords in the frontmatter description

MartiX should not blindly copy these traits:

- flattening the package into one monolithic guide
- replacing its rule-and-map structure with tutorial-only content
- turning every guideline into an all-caps command
- biasing the skill too heavily toward Minimal APIs at the expense of its wider
  .NET remit

### Highest-value improvement targets

| Improvement target | Why it matters | Best fit in MartiX |
| --- | --- | --- |
| Add quick-start defaults to `SKILL.md` | Improves the first-use experience without changing the whole architecture | Update `src/skills/martix-dotnet-csharp/SKILL.md` |
| Add centralized anti-pattern reference | Makes repeated `Avoid` guidance easy to discover | Add a new `references/*.md` quick-reference file |
| Add recipe-style bootstrap docs | Gives users concrete code without bloating the atomic rules | Add new `references/*.md` recipe docs |
| Add package catalog guidance | Helps with package-selection tasks that users ask often | Add a new ecosystem or libraries reference |
| Add decision aids to maps | Makes common choices easier without losing traceability | Extend existing map files or add a focused decision reference |

### Conclusion

MartiX already has the stronger package architecture. The 3rd-party skill is
currently stronger as an operator-facing field guide. The right next step is to
give MartiX a better action layer while keeping its layered rule library and
source-backed structure intact.

The detailed follow-up is captured in the
[`martix-dotnet-csharp improvement plan`](./martix-dotnet-csharp-improvement-plan.md).
