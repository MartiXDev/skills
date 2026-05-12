## MartiX dotnet-csharp improvement plan

### Goal

The first comparison-driven upgrade pass is already implemented in
`skills\martix-dotnet-csharp`. This plan now tracks only genuine
second-phase work: validate the upgraded package with real evals, tune trigger
and discovery behavior, tighten compatibility and metadata notes, and make only
targeted refinements that are justified by evidence.

For the source-backed comparison that started this work, see the
[`dotnet-10-csharp-14 comparison`](./dotnet-10-csharp-14-comparison.md).

### Planning principles

- Preserve the layered package architecture instead of flattening it.
- Treat quick-start, anti-pattern, recipe, and navigation work as delivered
  unless evals show a real gap.
- Prefer empirical tuning over another broad content-expansion pass.
- Keep compatibility, installation, and discovery notes consistent across the
  package.
- Add new examples or references only when repeated usage shows a missing path.

### Current-state snapshot

| Area | Current state | Evidence | Plan impact |
| --- | --- | --- | --- |
| `SKILL.md` first impression | Implemented | `SKILL.md` now includes a trigger-rich description, `Quick-start defaults`, and a `Default patterns` table | Remove as active content work |
| Anti-pattern visibility | Implemented | `references/anti-patterns-quick-reference.md`, linked from `SKILL.md` and `AGENTS.md` | Keep maintained; do not plan another consolidation pass |
| Recipe-style references | Implemented | `references/web-bootstrap-recipes.md`, `references/testing-bootstrap-recipes.md`, and `references/libraries-catalog.md` | Remove as active content work |
| Navigation and decision aids | Implemented | `AGENTS.md`, `references/async-map.md`, `references/design-map.md`, and `references/web-stack-map.md` | Downgrade to tune-only follow-up |
| Rule example deepening | Partially implemented and intentionally limited | Selected rules now include compact examples, while recipes carry most copy-ready material | Limit to targeted polish only |
| Metadata and distribution baseline | Implemented | `metadata.json` and `README.md` now describe package structure and install surfaces | Shift from creation to validation and cleanup |

### Removed or downgraded from the original plan

- Do not schedule new work for quick-start defaults, default-patterns tables,
  anti-pattern consolidation, recipe creation, or first-pass navigation tables.
  Those are already present.
- Downgrade broad `deepen high-value rule examples` work to targeted follow-up
  only.
- Keep `metadata.json` and `README.md` in maintenance mode unless validation
  shows inconsistencies.

### Phase-two priority overview

| Priority | Theme | Outcome |
| --- | --- | --- |
| P1 | Validate activation and usefulness | Confirm that the upgraded skill triggers well and helps on realistic .NET tasks |
| P1 | Tune trigger wording and routing | Reduce under-triggering and overlapping-skill confusion using eval evidence |
| P2 | Tighten compatibility and metadata notes | Align baseline, modernization, installation, and maturity notes across the package |
| P2 | Apply targeted polish from eval findings | Improve only the routes, examples, or references that users still struggle with |
| P3 | Verify marketplace-facing alignment | Ensure package docs and repository registration metadata stay consistent after validation |

### P1 - Validate the upgraded skill with `skill-creator`

#### What to do

- Use the `skill-creator` workflow against the current package, not a
  pre-upgrade draft.
- Build eval prompts around the tasks the package now claims to help with:
  1. web or API bootstrap
  2. anti-pattern review
  3. async and concurrency design
  4. `WebApplicationFactory` testing setup
  5. package and library selection
  6. modernization of an existing SDK-style project
- Compare the current skill against a no-skill baseline, and optionally against
  `dotnet-10-csharp-14` when trigger overlap needs investigation.
- Keep generated eval workspaces outside the package root and do not treat them
  as maintained package content.

#### Why this is first

The remaining questions are now about effectiveness, not missing scaffolding.
Further content changes should be driven by evidence.

#### Likely future file changes

| Path | Action | Purpose |
| --- | --- | --- |
| `skills/martix-dotnet-csharp/SKILL.md` | Maybe update | Tune description and opening routes if evals show trigger or onboarding gaps |
| `skills/martix-dotnet-csharp/AGENTS.md` | Maybe update | Tighten route tables if reviewers still hesitate on first-file choice |
| eval workspace outside `skills\martix-dotnet-csharp` | Generate during evals | Capture iteration results without turning test artifacts into package content |

### P1 - Tune trigger wording and discovery boundaries

#### What to do

- Treat the current `SKILL.md` description as a strong baseline, not a finished
  trigger contract.
- Use trigger evals to decide whether the package over-triggers, under-triggers,
  or loses to adjacent skills such as:
  - `dotnet-10-csharp-14`
  - `dotnet-best-practices`
  - `csharp-async`
  - `microsoft-docs`
  - `microsoft-code-reference`
- Tune for concrete user language around options binding, `TypedResults`, HTTP
  resilience, testing, and modernization work.
- Remove trigger terms that only add noise or pull the skill into work better
  handled by narrower skills.

#### Why this is separate from general content work

The package now has the right entrypoints. The next gap is whether those
entrypoints activate at the right time.

### P2 - Tighten compatibility, maturity, and metadata notes

#### What to do

Review the package-facing metadata and docs for consistency after the first
implementation pass.

Focus areas:

- `SKILL.md`, `AGENTS.md`, `README.md`, and `metadata.json` should describe the
  same baseline and install story.
- Clarify how the skill should behave when the target repo is SDK-style but not
  yet on `.NET 10` or `C# 14`.
- Confirm whether `metadata.json` should continue to report
  `maturity: "authoring"` and `0.1.0-preview.1` after validation, or whether
  those values understate the package state.
- Re-check standalone vs marketplace install notes, same-name shadowing
  warnings, and secondary-target claims against actual validated behavior.

#### Why this matters

The content layer is much stronger now. The remaining risk is operational
confusion: versioning, target baseline, or installation guidance can still
drift even when the package itself is useful.

#### Suggested file changes

| Path | Action | Purpose |
| --- | --- | --- |
| `skills/martix-dotnet-csharp/metadata.json` | Review and possibly update | Keep maturity, compatibility, and distribution notes accurate |
| `skills/martix-dotnet-csharp/README.md` | Review and possibly update | Keep install, validation, and discovery notes aligned with reality |
| `skills/martix-dotnet-csharp/SKILL.md` | Maybe update | Add or tighten a short compatibility stance only if readers need it |
| `skills/martix-dotnet-csharp/AGENTS.md` | Maybe update | Clarify modernization vs greenfield routes if that boundary still causes friction |

### P2 - Apply only targeted content polish

#### What to do

Do not open a new broad content-expansion phase. Use eval feedback to decide
whether a small number of files still need tighter examples or cross-links.

Best candidates if data justifies it:

- `rules/web-aspnet-core.md`
- `rules/design-exceptions-validation.md`
- `rules/async-tasks-valuetasks.md`
- `rules/testing-unit-integration.md`
- `AGENTS.md` route tables

#### What not to do

- Do not add another large wave of recipe docs.
- Do not turn the atomic rules into tutorial chapters.
- Do not add examples just because a similar 3rd-party skill has them.

### P3 - Verify marketplace-facing alignment

#### What to do

After package validation, confirm that repository-level marketplace metadata
still reflects the canonical `skills\martix-dotnet-csharp` package and does
not drift from the package docs.

Likely follow-up:

- check `marketplace/catalog.yaml`
- check `.github/plugin/marketplace.json`
- confirm naming, install source, versioning strategy, and summary text stay
  aligned with `metadata.json` and `README.md`

#### Why this is later

This repo-level work matters only after the package-facing story and trigger
behavior are stable.

### Likely implementation order

1. Run `skill-creator` evals and collect qualitative and quantitative feedback.
2. Tune `SKILL.md` description and first-route wording from evidence.
3. Clean up compatibility, maturity, and install metadata across package files.
4. Apply only the smallest content polish justified by eval friction.
5. Re-check marketplace registration metadata after the package story
   stabilizes.

### What should not change

- Do not remove the approved source boundary in
  `references/doc-source-index.md`.
- Do not collapse the rule library into one tutorial file.
- Do not undo the quick-start, anti-pattern, recipe, or decision-aid additions
  that are already in place.
- Do not overfit the package only to Minimal APIs or only to greenfield
  scaffolding.
- Do not let generated eval artifacts become permanent package content.

### Definition of done for phase two

The remaining work should be considered complete when:

- the current skill has been evaluated with realistic prompts rather than only
  document comparison
- trigger behavior is tuned against real overlap and false-positive cases
- package metadata, maturity, compatibility notes, and install guidance are
  internally consistent
- any follow-up content changes are narrow and evidence-backed
- the layered rule-and-map architecture still remains intact
