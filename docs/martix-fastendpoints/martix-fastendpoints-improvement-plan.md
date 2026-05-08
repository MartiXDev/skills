## MartiX FastEndpoints improvement plan

### Goal

Make `martix-fastendpoints` easier to trigger, easier to apply in the first few
minutes, and safer to extend without weakening the package traits that already
work well:

- layered standalone-first package structure
- atomic, source-backed rule files
- clear workstream routing
- FastEndpoints-specific scope
- metadata and asset files that keep the package maintainable

### Current strengths to preserve

| Strength | Evidence in the current package | Why it should stay |
| --- | --- | --- |
| Layered package architecture | `SKILL.md`, `AGENTS.md`, `README.md`, `metadata.json` | Keeps activation, companion guidance, rules, references, templates, and assets from collapsing into one file |
| Stable rule contract | `rules/_sections.md`, `assets/section-order.json` | Keeps the six-section review shape stable across the rule library |
| Focused workstream routing | `SKILL.md`, `AGENTS.md` | Lets users open only the rules that match the current FastEndpoints concern |
| Official-doc-backed references | `references/foundation-map.md`, `references/transport-docs-map.md`, `references/cookbook-index.md` | Keeps the package traceable to approved FastEndpoints sources |
| Standalone-first distribution model | `README.md`, `metadata.json` | Preserves one canonical source package for direct install and marketplace registration |
| Scoped FastEndpoints posture | `AGENTS.md` | Prevents the package from turning into a generic ASP.NET Core or broad .NET skill |

### Planning principles

- Preserve the layered package architecture instead of flattening it.
- Add operational depth mostly through `references/` before making individual
  rule files much longer.
- Keep FastEndpoints-specific behavior separate from broader ASP.NET Core
  guidance unless FastEndpoints adds framework-specific constraints.
- Make startup ordering, NSwag/OpenAPI behavior, and Native AOT constraints
  explicit where mistakes are expensive.
- Keep cookbook material secondary to official docs. Use recipes to help with
  implementation, not to replace policy.
- Treat `metadata.json` and `assets/section-order.json` as package contracts
  that must stay in sync with future reference additions.

### Main gaps and improvement opportunities

| Gap | Current situation | Best improvement surface |
| --- | --- | --- |
| Activation and quick defaults | `SKILL.md` routes well, but it does not yet give a compact first-pass defaults table or stronger trigger coverage for common FastEndpoints prompts | Update `SKILL.md` and `AGENTS.md` |
| Anti-pattern visibility | The package has strong `Avoid` sections, but the warnings are scattered across 20 rule files | Add a new quick-reference file under `references/` |
| Startup ordering | Ordering guidance is split across startup, configuration, Swagger, and AOT rules, so users must reconstruct the full pipeline manually | Add a dedicated startup checklist reference and cross-link the existing rules |
| NSwag and OpenAPI depth | `rules/docs-swagger-openapi.md` covers the basics, but release-group-aware docs, client export, converter caveats, and AOT export trade-offs are still thin | Update the rule and add a supporting playbook if needed |
| Native AOT and trimming depth | `rules/foundation-source-generation-aot.md` is solid, but trimming review, multi-assembly generator wiring, and validation flow still feel terse | Update the rule and add an AOT-focused supporting reference |
| Recipe-style bootstrap help | The package has a cookbook index for testing and versioning, but no compact first-pass bootstrap recipes for new FastEndpoints services | Add a small bootstrap recipe reference |
| Reference and cookbook maintenance | The package has maps and a cookbook index, but no central source-coverage index, and future additions will need inventory/order maintenance | Add a source index and update maintainer-facing files |

### Priority overview

| Priority | Theme | Outcome |
| --- | --- | --- |
| P1 | Improve entrypoints and anti-pattern discovery | Easier skill activation and faster review of common mistakes |
| P2 | Make startup ordering and NSwag/OpenAPI flows explicit | Fewer middleware and documentation mistakes in real projects |
| P3 | Deepen Native AOT/trimming guidance and bootstrap examples | Better support for advanced hosting scenarios and greenfield setup |
| P4 | Tighten reference maintenance and validation | Lower drift risk as the package grows |

### P1 - Improve entrypoints and fast review routes

**What to change**

1. Expand the `SKILL.md` frontmatter description with high-signal trigger terms
   such as:
   - `AddFastEndpoints(...)`
   - `UseFastEndpoints(...)`
   - `Configure()`
   - validators
   - preprocessors and postprocessors
   - `FastEndpoints.Swagger`
   - NSwag
   - release groups
   - `AllowAnonymous()`
   - Native AOT
   - SSE
   - file uploads and downloads
2. Add a compact `Quick defaults` table to `SKILL.md` so first-pass guidance is
   visible before users dive into the rules:
   - endpoint base type choice
   - auth posture
   - versioning default
   - docs default
   - test default
3. Tighten `AGENTS.md` review routes so startup bugs, docs/export issues, and
   versioning or security reviews can be routed faster.

**Why this is first**

This is the lowest-risk, highest-value phase. It improves skill triggering and
navigation without changing the deeper rule contract.

**Suggested file changes**

| Path | Action | Purpose |
| --- | --- | --- |
| `src/skills/martix-fastendpoints/SKILL.md` | Update | Improve trigger coverage and add first-pass defaults |
| `src/skills/martix-fastendpoints/AGENTS.md` | Update | Improve cross-workstream review routing |

### P1 - Add a centralized anti-pattern quick reference

**What to change**

Create a small, high-value quick reference that consolidates the strongest
package warnings already spread across `Avoid` sections.

Recommended content:

- a table with `anti-pattern`, `preferred alternative`, and `primary rule`
- a few `Wrong` / `Better` pairs for the highest-value mistakes
- explicit language that this file is an index, not a replacement for the rule
  library

Good seed topics:

- mixing `Configure()` and endpoint attributes
- putting `UseSwaggerGen()` before `UseFastEndpoints()`
- diverging serializer settings between FastEndpoints and `JsonOptions`
- overusing `RoutePrefixOverride()`
- treating cookbook recipes as policy
- mutating an old endpoint version in place
- using `AllowAnonymous()` as a convenience instead of a deliberate choice

**Why this belongs in P1**

The package already contains the content. This change mainly improves discovery
and reduces the time needed to find the right rule.

**Suggested file changes**

| Path | Action | Purpose |
| --- | --- | --- |
| `src/skills/martix-fastendpoints/references/anti-patterns-quick-reference.md` | New | Centralize common FastEndpoints mistakes and fixes |
| `src/skills/martix-fastendpoints/SKILL.md` | Update | Link to the quick reference from the router |
| `src/skills/martix-fastendpoints/AGENTS.md` | Update | Add a review route for anti-pattern triage |

### P2 - Make startup ordering explicit

**What to change**

Add one authoritative startup-order reference that gathers the ordering guidance
currently spread across startup, configuration, Swagger, and AOT rules.

Recommended scope:

- normal FastEndpoints startup flow
- docs-enabled flow with `UseSwaggerGen()`
- AOT/export flow where OpenAPI generation and runtime visualization split
- callouts for where auth, static files, and FastEndpoints-specific options
  belong

This reference should stay checklist-oriented, not become a long ASP.NET Core
tutorial.

**Why this is next**

Startup ordering affects every real FastEndpoints service and directly supports
the later NSwag/OpenAPI and Native AOT improvements.

**Suggested file changes**

| Path | Action | Purpose |
| --- | --- | --- |
| `src/skills/martix-fastendpoints/references/startup-pipeline-checklist.md` | New | Give users one place to verify startup sequence |
| `src/skills/martix-fastendpoints/rules/foundation-startup-registration.md` | Update | Point startup rule readers to the shared checklist |
| `src/skills/martix-fastendpoints/rules/foundation-configuration-options.md` | Update | Clarify where configuration choices affect ordering |
| `src/skills/martix-fastendpoints/AGENTS.md` | Update | Add a startup-order review route |
| `src/skills/martix-fastendpoints/references/foundation-map.md` | Update | Surface the new checklist from the foundation map |

### P2 - Deepen NSwag and OpenAPI guidance

**What to change**

Keep `rules/docs-swagger-openapi.md` as the policy file, but make the most
error-prone operational details more explicit.

Recommended additions:

- make the FastEndpoints-first NSwag registration path more explicit
- clarify release-group-aware Swagger document strategy
- call out System.Text.Json converter and schema/example caveats more directly
- separate runtime docs, `swagger.json` export, and client-generation concerns
- explain how AOT changes the recommended OpenAPI flow

If these additions would make the rule too dense, move the longer operational
examples into a supporting reference instead of bloating the rule.

**Special attention**

This is the highest-value documentation gap in the package after startup
ordering. The current rule is good, but it still expects users to do too much
source synthesis for NSwag-heavy workflows.

**Suggested file changes**

| Path | Action | Purpose |
| --- | --- | --- |
| `src/skills/martix-fastendpoints/rules/docs-swagger-openapi.md` | Update | Strengthen NSwag, export, and converter guidance |
| `src/skills/martix-fastendpoints/references/nswag-openapi-playbook.md` | New | Hold concrete client-export and document-shaping examples if needed |
| `src/skills/martix-fastendpoints/references/transport-docs-map.md` | Update | Route readers from the map to the deeper OpenAPI playbook |
| `src/skills/martix-fastendpoints/rules/versioning-release-groups.md` | Update | Align release-group guidance with Swagger document strategy |

### P3 - Deepen Native AOT and trimming guidance

**What to change**

The AOT rule already covers the right topics, but it should become more
operationally explicit around trimming and generator ownership.

Recommended additions:

- trimming-warning review as part of the rule checklist
- clearer multi-assembly `DiscoveredTypes` merge guidance
- explicit reminder that every FastEndpoints assembly with endpoints or DTOs
  needs generator coverage
- stronger explanation of generated serializer context ownership
- a compact Release AOT verification flow

Use a supporting reference if the detailed trimming and publish flow would make
the rule too long.

**Why this is P3 instead of P2**

It is important, but it affects fewer teams than entrypoint quality, startup
ordering, and Swagger/OpenAPI behavior.

**Suggested file changes**

| Path | Action | Purpose |
| --- | --- | --- |
| `src/skills/martix-fastendpoints/rules/foundation-source-generation-aot.md` | Update | Make trimming and generator review more explicit |
| `src/skills/martix-fastendpoints/references/aot-trimming-playbook.md` | New | Hold multi-assembly, trimming, and publish examples |
| `src/skills/martix-fastendpoints/references/foundation-map.md` | Update | Route readers to the deeper AOT reference |
| `src/skills/martix-fastendpoints/references/startup-pipeline-checklist.md` | Update | Add or refine the AOT-specific startup branch |

### P3 - Add recipe-style bootstrap references where policy-only guidance slows adoption

**What to change**

Add one compact bootstrap recipe reference for the most common greenfield or
migration scenarios.

Recommended scope:

- minimal `Program.cs` baseline
- simple endpoint + DTO + validator slice
- basic group or processor example
- auth-enabled variant
- OpenAPI-enabled variant
- AOT-aware note that points back to the AOT rule and playbook

Keep this file short and explicit that it exists to reduce synthesis cost, not
to replace the rules.

**Suggested file changes**

| Path | Action | Purpose |
| --- | --- | --- |
| `src/skills/martix-fastendpoints/references/bootstrap-recipes.md` | New | Add copy-ready bootstrap examples |
| `src/skills/martix-fastendpoints/SKILL.md` | Update | Link to the recipes after the default routing guidance |
| `src/skills/martix-fastendpoints/AGENTS.md` | Update | Route greenfield setup reviews toward the recipe plus rules |

### P4 - Strengthen reference and cookbook maintenance

**What to change**

The package already has a solid reference layer. The next step is making future
maintenance easier and less manual.

Recommended improvements:

- add one central source-coverage index for official docs and cookbook sections
- make cookbook curation more explicit so stale recipe links are easier to spot
- update the maintainer-facing notes to point at the new source index
- keep file inventory and preferred order in sync when new references are added

This is also the right place to make later reference audits simpler without
turning every map into a maintenance checklist.

**Special attention**

Reference and cookbook maintenance is justified by the current package shape.
There are already multiple maps, a cookbook index, and explicit artifact counts
in `metadata.json`. Any future additions will be easier to manage if the
coverage and ordering contracts are made visible.

**Suggested file changes**

| Path | Action | Purpose |
| --- | --- | --- |
| `src/skills/martix-fastendpoints/references/doc-source-index.md` | New | Track official source coverage and cookbook sections in one place |
| `src/skills/martix-fastendpoints/references/cookbook-index.md` | Update | Clarify curated recipes, gaps, and maintenance notes |
| `src/skills/martix-fastendpoints/README.md` | Update | Point maintainers to the source index and upkeep flow |
| `src/skills/martix-fastendpoints/metadata.json` | Update | Keep artifact counts and reference lists accurate after future additions |
| `src/skills/martix-fastendpoints/assets/section-order.json` | Update | Keep preferred reference ordering aligned with the new files |

### Sequencing guidance for later implementation

1. Start with `SKILL.md` and `AGENTS.md` so activation and routing improve before
   deeper content is added.
2. Add `references/anti-patterns-quick-reference.md` and wire it in from both
   entrypoints.
3. Add `references/startup-pipeline-checklist.md` and connect the startup,
   configuration, and foundation-map files to it.
4. Expand `rules/docs-swagger-openapi.md` and update release-group and
   transport-docs guidance in the same pass so Swagger grouping stays coherent.
5. Expand `rules/foundation-source-generation-aot.md` only after the startup
   checklist exists, so normal and AOT branches stay aligned.
6. Add `references/bootstrap-recipes.md` after the defaults, anti-patterns, and
   deeper operational references are stable.
7. Finish each accepted phase by updating `metadata.json`,
   `assets/section-order.json`, and later source-index maintenance links in the
   same change set.

### What should not change

- Do not collapse the rule library into a tutorial-style monolith.
- Do not widen the package into generic ASP.NET Core or broad .NET guidance.
- Do not turn cookbook material into the normative policy surface.
- Do not remove the stable rule contract in
  `src/skills/martix-fastendpoints/rules/_sections.md`.
- Do not let future references bypass `metadata.json` and
  `assets/section-order.json`; those files are part of the package contract.

### Validation and eval follow-up

Later implementation work should include both content validation and practical
skill evaluation.

Recommended follow-up:

1. Re-check every new or updated `Source anchors` link and curated cookbook link.
2. Verify `metadata.json` counts and `assets/section-order.json` ordering in the
   same pull request as any new references.
3. Run scenario-based eval prompts for at least:
   - startup ordering review
   - NSwag/OpenAPI client export
   - Native AOT publish and static OpenAPI export
   - versioning with release groups and Swagger documents
   - protected endpoint setup with validator and processor coverage
4. Use a later `skill-creator` evaluation loop to compare the current package
   with the improved package on:
   - trigger quality
   - navigation speed
   - answer usefulness
   - stability of the reference layer

### Definition of done for a later skill update

The later implementation effort should be considered complete when:

- `SKILL.md` triggers more reliably for common FastEndpoints prompts
- common anti-patterns are discoverable from one place
- startup ordering is explicit for normal and AOT-aware paths
- NSwag/OpenAPI guidance is clearer about document shaping, export, and client
  generation
- Native AOT guidance is stronger about trimming, generator coverage, and
  validation flow
- the reference layer is easier to maintain without weakening the current
  package architecture
