## Skill portfolio coordination plan

### Scope and boundaries

This plan coordinates the portfolio behavior of
[`martix-fastendpoints`](../src/skills/martix-fastendpoints/SKILL.md),
[`martix-fluentvalidation`](../src/skills/martix-fluentvalidation/SKILL.md),
[`martix-markdown`](../src/skills/martix-markdown/SKILL.md),
and [`martix-dotnet-csharp`](../src/skills/martix-dotnet-csharp/SKILL.md).

It is intentionally limited to:

- cross-skill routing and hand-offs
- metadata and package-contract alignment
- documentation-quality support
- coordinated release sequencing

It does not restate package-specific expansion work that already belongs in each
skill's own plan.

### Style baseline

This plan follows the concise docs style already used in
[`martix-dotnet-csharp.md`](./martix-dotnet-csharp/martix-dotnet-csharp.md),
[`martix-dotnet-csharp-improvement-plan.md`](./martix-dotnet-csharp/martix-dotnet-csharp-improvement-plan.md),
and
[`dotnet-10-csharp-14-comparison.md`](./martix-dotnet-csharp/dotnet-10-csharp-14-comparison.md).

### Minimum files reviewed

| Package or baseline | Files reviewed | Why |
| --- | --- | --- |
| `martix-fastendpoints` | `SKILL.md`, `metadata.json`, `AGENTS.md`, and `references/request-pipeline-map.md` | Enough to map package shape, routing, and validation or pipeline hand-offs. |
| `martix-fluentvalidation` | `SKILL.md`, `metadata.json`, `AGENTS.md`, and `references/integration-map.md` | Enough to map validator ownership, ASP.NET Core integration, and ecosystem or upgrade boundaries. |
| `martix-markdown` | `SKILL.md`, `README.md`, `.markdownlint.json`, `references/default-rule-profile.md`, `references/install-and-validation.md`, and `templates/markdownlint-cli2-config.template.jsonc` | Enough to define the shared Markdown support workflow, fallback config, and install or validation guidance. |
| `martix-dotnet-csharp` | `SKILL.md`, `metadata.json`, `README.md`, `AGENTS.md`, and `references/libraries-catalog.md` | Enough to map the umbrella .NET role, package conventions, and the current FluentValidation touchpoint. |
| Docs style baseline | `docs/martix-dotnet-csharp/martix-dotnet-csharp.md`, `docs/martix-dotnet-csharp/martix-dotnet-csharp-improvement-plan.md`, and `docs/martix-dotnet-csharp/dotnet-10-csharp-14-comparison.md` | Enough to keep this plan aligned with the existing docs presentation style. |

### Portfolio role split

| Skill | Primary role | Portfolio hand-off role |
| --- | --- | --- |
| `martix-dotnet-csharp` | Umbrella .NET and ASP.NET Core baseline | First stop for generic SDK, host, API, testing, diagnostics, and design questions before a framework-specific or library-specific hand-off. |
| `martix-fastendpoints` | FastEndpoints-specific endpoint and pipeline guidance | Takes over when the HTTP surface is explicitly FastEndpoints and returns to `martix-dotnet-csharp` when the concern becomes general host or platform guidance. |
| `martix-fluentvalidation` | Validator authoring, validation behavior, and upgrade guidance | Takes over when validation becomes library-specific, reusable, async, localized, or migration-sensitive. |
| `martix-markdown` | Shared Markdown authoring and repair support | Supports all other packages whenever maintainers touch authored Markdown or need repo-aware lint decisions. |

### Cross-skill strengths to preserve

- Keep the standalone-first package contract and `npx skills add <source>` install
  wording across the portfolio.
- Keep the layered package shape: router, maintainer docs, focused rules, map or
  reference layer, templates, and machine-readable support files where they add
  value.
- Keep the shared decision-oriented rule contract in the three domain skills:
  `Purpose`, `Default guidance`, `Avoid`, `Review checklist`, `Related files`,
  and `Source anchors`.
- Keep clear source boundaries:
  - `martix-dotnet-csharp` owns broad .NET and ASP.NET Core guidance.
  - `martix-fastendpoints` stays FastEndpoints-specific.
  - `martix-fluentvalidation` stays official-doc-first and validator-specific.
  - `martix-markdown` stays a support workflow that defers to repo-local
    policy before bundled defaults.
- Keep the current maintainer-friendly emphasis on maps, inventories, templates,
  and distribution notes instead of flattening everything into large tutorial
  files.

### Inter-skill navigation and reference opportunities

Use short hand-off notes such as "Stay here when..." and "Open companion skill
when..." rather than copying another package's guidance.

| From | Link to | Use when | Best portfolio-level insertion points |
| --- | --- | --- | --- |
| `martix-dotnet-csharp` | `martix-fastendpoints` | The API surface is explicitly FastEndpoints rather than generic ASP.NET Core, Minimal APIs, or controllers. | `SKILL.md` web section and `AGENTS.md` common review routes for endpoint work. |
| `martix-dotnet-csharp` | `martix-fluentvalidation` | Validation becomes a first-class design topic with reusable validators, RuleSets, async rules, localization, or upgrade concerns. | `references/libraries-catalog.md`, `AGENTS.md` common review routes, and validation or testing-oriented rule links. |
| `martix-fastendpoints` | `martix-dotnet-csharp` | The issue widens from FastEndpoints conventions to general host setup, options, resilience, diagnostics, or generic testing practice. | `SKILL.md` foundation and testing routes, `AGENTS.md` common review routes, and `references/request-pipeline-map.md` maintenance notes. |
| `martix-fastendpoints` | `martix-fluentvalidation` | Validator authoring, async validation behavior, error metadata, or validator reuse becomes more important than endpoint plumbing. | `SKILL.md` request-pipeline route, `AGENTS.md` DTO-binding or validation scenarios, and `references/request-pipeline-map.md`. |
| `martix-fluentvalidation` | `martix-dotnet-csharp` | The question expands into API failure contracts, Minimal API host shape, DI patterns, or host-level test harnesses. | `SKILL.md` integration route, `AGENTS.md` ASP.NET Core or Minimal API scenarios, and `references/integration-map.md`. |
| `martix-fluentvalidation` | `martix-fastendpoints` | Validation executes inside FastEndpoints endpoints and endpoint pipeline behavior matters as much as the validator itself. | `SKILL.md` integration route, `AGENTS.md` ASP.NET Core or Minimal API scenarios, and `references/integration-map.md`. |
| All three domain skills | `martix-markdown` | Maintainers edit `SKILL.md`, `README.md`, `AGENTS.md`, rules, maps, or templates, or hit markdownlint findings during content work. | `SKILL.md` package conventions, `AGENTS.md` authoring or maintenance sections, and `README.md` verification or troubleshooting sections. |

### Recommended hand-off pattern

| Pattern | Recommendation |
| --- | --- |
| Reader-facing hand-off | Link to the companion skill entrypoint or the closest map, not to a deep file tree. |
| Maintainer-facing hand-off | Put the cross-link in `Package conventions`, `Authoring contract`, `Verification`, or `Troubleshooting`, where it helps future edits without cluttering the main router. |
| Repeated overlap | Add one stable `Companion skills` or `See also` block in high-traffic entrypoints instead of many inline references. |
| Boundary protection | Use cross-links to route work, not to justify duplicating another skill's rules. |

### Metadata normalization opportunities

| Opportunity | Current signal | Recommended action |
| --- | --- | --- |
| Common manifest presence | `metadata.json` now exists in `martix-dotnet-csharp`, `martix-fastendpoints`, `martix-fluentvalidation`, and `martix-markdown`, but the fields are not yet normalized. | Keep the manifest present in every package and align only the shared field vocabulary that improves portfolio navigation. |
| Shared status vocabulary | `preview`, `authoring`, `registration-ready`, and `direct-registration` are used, but not as a clearly controlled set. | Define allowed maturity and distribution status values once, then reuse them across all packages. |
| Cross-skill relationship data | Cross-links are implied in prose, not exposed as package metadata. | Add a small field such as `relatedSkills`, `companionSkills`, or `handoffScenarios` for portfolio navigation. |
| Documentation policy visibility | Markdown guidance lives mostly in prose and in the `martix-markdown` package. | Add a `documentationProfile` or similar pointer so maintainers can discover the expected Markdown policy from package metadata. |
| Install and validation wording | `npx skills add <source>` and validation notes are repeated by hand across packages. | Normalize the wording and optionally capture `validationCommands` or `verificationNotes` in the manifest. |
| Discovery and conflict notes | Same-name conflict and validation warnings are already present, but phrasing varies. | Standardize the wording so support and troubleshooting stay consistent across packages. |

Keep package-specific taxonomies, rule prefixes, and domain counts local. Those
differences are a strength, not a normalization bug.

### Versioning and release strategy considerations

| Concern | Recommendation | Why |
| --- | --- | --- |
| Package version numbers | Keep independent preview-semver versions per skill. | The four packages will not evolve at exactly the same pace. |
| Coordination changes | Treat metadata schema changes, cross-link additions, and Markdown policy changes as a shared release wave. | These changes only pay off when the touched packages move together. |
| Compatibility signaling | Add a small portfolio compatibility note when one package assumes sections or files added by another package. | Prevents broken hand-offs during staggered preview releases. |
| Release checklist | For shared waves, update package manifests, entrypoint links, install notes, validation wording, and marketplace registration metadata in the same pass. | Keeps standalone and marketplace surfaces aligned. |
| Markdown support timing | Ship the markdownlint support track before broad doc rewrites in the other packages. | It reduces churn and makes later cleanup more mechanical. |

A practical release model is:

1. keep content versions per package independent,
2. group cross-skill contract changes into named preview waves, and
3. document the wave once at the portfolio level instead of repeating the same
   release explanation in every package.

### Documentation-quality alignment work

| Work item | Portfolio-level recommendation |
| --- | --- |
| Heading policy | Make one explicit decision for authored Markdown. Today `docs/` and `martix-dotnet-csharp` already work well without H1 headings, while `martix-fastendpoints` and `martix-fluentvalidation` still use H1 in `SKILL.md`, `README.md`, and `AGENTS.md`. Either converge on the no-H1 style or document a narrow exception profile for package entrypoints. |
| Shared section names | Reuse stable section labels such as `When to use this skill`, `Package conventions`, `Verification`, `Troubleshooting`, `Common review routes`, and `Authoring contract` so readers can move between packages faster. |
| Install wording | Standardize on `npx skills add <source>` and align path, preview, update, and conflict wording across all package READMEs. |
| Table and fence consistency | Keep tables compact and stable, surround blocks with blank lines, and specify code fence languages when practical. |
| Link text and accessibility | Use descriptive cross-link text such as "Open the FluentValidation integration map" rather than generic "see here" phrasing. |
| Review scope | Run Markdown validation on the smallest affected file set instead of linting the whole repository unless the task explicitly requires a full sweep. |

### `martix-markdown` support track

Use `martix-markdown` as the shared authoring and repair workflow for
portfolio Markdown. The operating model should be:

1. read repo-local Markdown instructions first,
2. detect any repo-local `.markdownlint*` file, markdownlint script, or IDE
   diagnostics before applying generic defaults,
3. lint only the touched Markdown files unless the task explicitly requires a
   broader sweep,
4. use autofix for mechanical issues first, typically through the existing repo
   command or `markdownlint-cli2 --fix`,
5. resolve remaining structural issues manually, especially headings, list
   spacing, tables, links, and reference fragments, and
6. re-run validation and record any justified config override or suppression.

Recommended config profiles:

| Profile | Use for | Recommended defaults |
| --- | --- | --- |
| `martix-repo-docs` | `docs/**/*.md` and other repo-authored planning docs | `MD013.line_length = 400`, `code_blocks = false`, `tables = false`, and `MD041 = false` when the repo intentionally omits H1 headings. |
| `martix-skill-packages` | `src/skills/**` Markdown maintained in this repository | Start from the same base as `martix-repo-docs`, then add only the narrowest package-entrypoint exceptions that remain necessary after the heading-policy decision. |
| `portable-starter` | Repositories that use `martix-markdown` but lack a local config | Start from the bundled `markdownlint-cli2` template, keep `line_length = 120` as the generic fallback, and enable overrides such as `MD041 = false` only when the target repo really needs them. |

Where the support track should cross-link:

| Target package | Maintainer-facing cross-link | Reader-facing cross-link | Markdownlint target |
| --- | --- | --- | --- |
| `martix-dotnet-csharp` | `AGENTS.md` maintenance section, `SKILL.md` package conventions, and `README.md` validation notes | Keep brief notes in maintainer or verification sections only, not in domain rules. | Link to `SKILL.md` for workflow, `references/default-rule-profile.md` for common rules, and `references/install-and-validation.md` for commands. |
| `martix-fastendpoints` | `AGENTS.md` `Authoring contract`, `SKILL.md` `Package conventions`, `README.md` `Verification`, and `README.md` `Troubleshooting` | Mention it when contributors extend rules, references, or templates. | Link to the same three markdownlint surfaces as the portfolio default. |
| `martix-fluentvalidation` | `AGENTS.md` `Authoring contract`, `SKILL.md` `Package conventions`, `README.md` `Verification`, and `README.md` `Troubleshooting` | Mention it when contributors extend validators, integration notes, or upgrade docs. | Link to the same three markdownlint surfaces as the portfolio default. |

The support track should stay maintainership-oriented. It should help package
authors keep Markdown clean, but it should not dominate end-user domain routing.

### Recommended sequencing order for later implementation

1. Approve the portfolio contract:
   - primary skill roles
   - hand-off vocabulary
   - heading-policy decision
   - metadata schema delta
2. Normalize the metadata surface:
   - add or confirm a manifest for `martix-markdown`
   - add companion-skill or hand-off fields
   - normalize shared status and discovery wording
3. Add maintainer-facing cross-links first:
   - `Package conventions`
   - `Authoring contract`
   - `Verification`
   - `Troubleshooting`
4. Add reader-facing routing links second:
   - `martix-dotnet-csharp` to FastEndpoints and FluentValidation
   - FastEndpoints and FluentValidation back to `martix-dotnet-csharp`
   - FastEndpoints and FluentValidation to each other only where the hand-off is
     stable and repeated
5. Apply the markdownlint support track:
   - add or align config profiles
   - use autofix on touched files
   - manually fix remaining structural issues
6. Cut a coordinated preview release wave:
   - validate links
   - validate install wording
   - validate manifests and registration metadata
   - record the portfolio-level coordination update once

### Guardrails

- Do not flatten package-specific guidance into one umbrella skill.
- Do not make `martix-markdown` the source of domain policy; it remains
  a repair and authoring support layer.
- Do not duplicate package-specific implementation plans here.
- Prefer a few high-traffic cross-links over dense cross-link spam.
