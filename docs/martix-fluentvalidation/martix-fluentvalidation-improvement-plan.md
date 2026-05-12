## MartiX FluentValidation improvement plan

### Goal

Make `martix-fluentvalidation` feel easier to trigger and faster to use for the
most common FluentValidation tasks without giving up the package strengths that
already make it maintainable and trustworthy.

This plan is grounded in the current package shape:

- [SKILL.md](../../skills/martix-fluentvalidation/SKILL.md)
- [AGENTS.md](../../skills/martix-fluentvalidation/AGENTS.md)
- [README.md](../../skills/martix-fluentvalidation/README.md)
- [metadata.json](../../skills/martix-fluentvalidation/metadata.json)
- key rules such as
  [integration-aspnet-core.md](../../skills/martix-fluentvalidation/rules/integration-aspnet-core.md),
  [integration-async-validation.md](../../skills/martix-fluentvalidation/rules/integration-async-validation.md),
  [testing-validator-testhelper.md](../../skills/martix-fluentvalidation/rules/testing-validator-testhelper.md),
  and
  [runtime-severity-error-codes-state.md](../../skills/martix-fluentvalidation/rules/runtime-severity-error-codes-state.md)

### Current strengths to preserve

- **Layered package architecture**: the current split between `SKILL.md`,
  `AGENTS.md`, atomic rules, reference maps, templates, and metadata is clear
  and maintainable.
- **Strong source traceability**: the rule contract in
  [`rules/_sections.md`](../../skills/martix-fluentvalidation/rules/_sections.md)
  keeps every rule anchored to official FluentValidation sources.
- **Wide workstream coverage**: the package already covers authoring,
  composition, integration, async behavior, runtime metadata, testing, and
  upgrades across 23 rules and 10 references.
- **Good cross-workstream review routes**:
  [AGENTS.md](../../skills/martix-fluentvalidation/AGENTS.md) already gives
  reviewers a solid scenario-to-file route table.
- **Strong upgrade and compatibility guidance**:
  [compatibility-matrix.md](../../skills/martix-fluentvalidation/references/compatibility-matrix.md)
  and the upgrade workstream make version decisions explicit.
- **Registration-ready package inventory**:
  [metadata.json](../../skills/martix-fluentvalidation/metadata.json)
  already records the current package structure in a way that future updates can
  extend.

### Planning principles

- Preserve the layered package structure instead of flattening the rules into a
  single tutorial.
- Improve the first-use path before adding deeper content.
- Add action-oriented references where they help, rather than bloating every
  rule file.
- Keep recommendations FluentValidation-specific and do not widen into general
  ASP.NET Core guidance unless validation behavior requires it.
- Keep official FluentValidation documentation as the default authority and
  treat ecosystem packages as clearly labeled opt-in context.

### Priority overview

| Priority | Theme | Outcome |
| --- | --- | --- |
| P1 | Improve activation and first-use guidance | Common prompts trigger the skill more reliably and `SKILL.md` becomes actionable |
| P1 | Add anti-pattern visibility | Common mistakes become easy to find in one place |
| P2 | Add recipe-style references | Users get copy-ready integration and testing help without weakening the atomic rules |
| P2 | Improve navigation and decision aids | Users can choose the right validation path faster |
| P3 | Deepen selected rule examples | High-value rules become more concrete where current guidance is still abstract |
| P4 | Validate and tune later | The improved package can be evaluated and iterated with `skill-creator` |

### P1 - Improve `SKILL.md` activation and first-use path

The current
[SKILL.md](../../skills/martix-fluentvalidation/SKILL.md) is a strong router,
but it still behaves mostly like a table of contents. That keeps it clean, but
it also means the user has to decide where to go before getting a usable default
path.

Recommended edits:

1. Expand the frontmatter description with more concrete trigger terms that are
   already covered by the package:
   - `AbstractValidator<T>`
   - `RuleSets`
   - `ValidateAsync`
   - `ValidationProblem`
   - `FluentValidation.TestHelper`
   - error codes, severity, and custom state
   - FluentValidation 11/12 upgrade planning
2. Add a compact `Quick-start defaults` section that answers the first few
   common tasks:
   - writing a new validator
   - validating at an API boundary
   - testing a validator
   - reviewing an async validation bug
   - planning an upgrade
3. Add a small `Default patterns` table so the preferred defaults are visible
   without opening multiple rules:
   - manual validation before legacy MVC auto-validation
   - `ValidateAsync(...)` for async rules
   - built-in validators before `Must` or custom validators
   - validator black-box tests before framework-boundary tests

Why this is first:

- It is the lowest-effort, highest-value improvement.
- It strengthens triggering and first-use experience without changing the rest
  of the package structure.
- The package already has good depth; the missing piece is a faster path into
  that depth.

Suggested file changes:

| Path | Action | Purpose |
| --- | --- | --- |
| `skills/martix-fluentvalidation/SKILL.md` | Update | Improve trigger coverage and first-use guidance |

### P1 - Add a centralized anti-pattern quick reference

Important warnings already exist, but they are distributed across many rule
files. For example:

- `integration-aspnet-core.md` warns against new use of MVC pipeline
  auto-validation.
- `integration-async-validation.md` warns against sync-over-async validation.
- `testing-validator-testhelper.md` warns against testing internals instead of
  observable failures.
- `runtime-severity-error-codes-state.md` warns against treating error codes as
  display text.

That is good rule-local guidance, but it is harder to discover when a user asks
for a review of "common mistakes" or wants a fast smell test.

Recommended change:

- Add a new supporting reference:
  `skills/martix-fluentvalidation/references/anti-patterns-quick-reference.md`

Recommended shape:

- Start with a table of `Anti-pattern`, `Prefer instead`, and `Primary rule`
- Group entries by the existing workstreams: integration, async, testing,
  runtime metadata, and upgrade
- Link back to the owning rules instead of copying the full rule content
- Keep examples short and focused on the highest-value mistakes

Suggested file changes:

| Path | Action | Purpose |
| --- | --- | --- |
| `skills/martix-fluentvalidation/references/anti-patterns-quick-reference.md` | New | Centralize repeated `Avoid` guidance from the rule library |
| `skills/martix-fluentvalidation/SKILL.md` | Update | Link to the new quick reference |
| `skills/martix-fluentvalidation/AGENTS.md` | Update | Route common review tasks to the quick reference |

### P2 - Add recipe-style integration and testing references

The current rules are good decision documents, but some of the most common
questions still need copy-ready examples. This is most noticeable in the areas
where users usually want a working skeleton rather than a principle-only review:

- ASP.NET Core integration
- async boundary handling
- validator testing
- application-boundary testing

The current rules in these areas explain the preferred behavior well, but they
stop short of giving a compact bootstrap recipe.

Recommended new references:

1. `skills/martix-fluentvalidation/references/web-bootstrap-recipes.md`
   - DI registration examples
   - controller or Minimal API manual validation examples
   - `ValidationProblem` / `Results.ValidationProblem(...)` mapping
   - async validation with `CancellationToken`
   - legacy MVC auto-validation called out as migration or legacy-only
2. `skills/martix-fluentvalidation/references/testing-bootstrap-recipes.md`
   - direct validator tests with `TestValidate` and `TestValidateAsync`
   - boundary tests for controllers, Minimal APIs, or filters
   - `InlineValidator<T>` as a boundary stub
   - examples that keep validator tests and integration tests separate

Why this fits the current package:

- It keeps the rules atomic.
- It gives users copy-ready help for the most common implementation shapes.
- It matches the existing package pattern of keeping deeper material in
  `references/` rather than overloading rules.

Suggested file changes:

| Path | Action | Purpose |
| --- | --- | --- |
| `skills/martix-fluentvalidation/references/web-bootstrap-recipes.md` | New | Common web integration scaffolds |
| `skills/martix-fluentvalidation/references/testing-bootstrap-recipes.md` | New | Common validator and boundary test scaffolds |
| `skills/martix-fluentvalidation/SKILL.md` | Update | Link recipe docs from the router |
| `skills/martix-fluentvalidation/AGENTS.md` | Update | Point common routes to the new recipes |

### P2 - Strengthen navigation and decision aids in existing maps

The current maps are already useful, but they mostly answer "which sources back
this rule?" They could also help with the next question users usually ask:
"which choice should I make first?"

Recommended updates:

- Update
  [`references/integration-map.md`](../../skills/martix-fluentvalidation/references/integration-map.md)
  with a quick decision table for:
  - manual validation
  - async-capable filter integration
  - legacy MVC auto-validation
- Update
  [`references/testing-map.md`](../../skills/martix-fluentvalidation/references/testing-map.md)
  with a compact `Use this test layer when...` table.
- Update
  [`references/runtime-metadata-map.md`](../../skills/martix-fluentvalidation/references/runtime-metadata-map.md)
  with a quick `message vs error code vs severity vs custom state` summary.
- Update
  [`AGENTS.md`](../../skills/martix-fluentvalidation/AGENTS.md) so the
  `Common review routes` section points users to recipe docs and quick
  references sooner.

Why this is P2 instead of P1:

- The package is already navigable.
- The bigger early win is improving `SKILL.md` and anti-pattern visibility.
- Once those exist, the map layer is the right place to reduce hesitation on
  multi-file decisions.

Suggested file changes:

| Path | Action | Purpose |
| --- | --- | --- |
| `skills/martix-fluentvalidation/references/integration-map.md` | Update | Add a quick boundary-selection aid |
| `skills/martix-fluentvalidation/references/testing-map.md` | Update | Add a quick test-layer aid |
| `skills/martix-fluentvalidation/references/runtime-metadata-map.md` | Update | Add a quick metadata-selection aid |
| `skills/martix-fluentvalidation/AGENTS.md` | Update | Make route selection faster for common tasks |

### P3 - Deepen selected high-value rules with small examples

Some rules are already clear, but they would become more actionable with a few
small examples. This should stay selective. The package does not need every rule
to become a tutorial.

Best candidates:

- `rules/integration-aspnet-core.md`
  - small Minimal API or controller example that shows manual validation and
    `ValidationProblem`
- `rules/integration-async-validation.md`
  - small end-to-end async example that passes `CancellationToken`
- `rules/testing-validator-testhelper.md`
  - one synchronous and one async example with `Only()`
- `rules/runtime-severity-error-codes-state.md`
  - short example that shows stable `ErrorCode` and structured `CustomState`

Why this is not earlier:

- Better entrypoints and supporting references will unlock more value first.
- If the router remains too abstract, deeper examples inside rules will still be
  harder to discover.

Suggested file changes:

| Path | Action | Purpose |
| --- | --- | --- |
| `skills/martix-fluentvalidation/rules/integration-aspnet-core.md` | Update | Add a compact preferred integration example |
| `skills/martix-fluentvalidation/rules/integration-async-validation.md` | Update | Add a compact async call-path example |
| `skills/martix-fluentvalidation/rules/testing-validator-testhelper.md` | Update | Add focused test examples |
| `skills/martix-fluentvalidation/rules/runtime-severity-error-codes-state.md` | Update | Add a compact metadata-contract example |

### P4 - Metadata updates and evaluation follow-up

After the content work is done, the package should be validated rather than
assumed to be better.

Recommended follow-up:

1. Update
   [`metadata.json`](../../skills/martix-fluentvalidation/metadata.json)
   to reflect any new reference files and counts.
2. Use the loaded `skill-creator` workflow to compare the current package
   against the improved package with prompts such as:
   - "help me wire FluentValidation into a Minimal API"
   - "review this validator for async validation bugs"
   - "show me the right way to test a validator with TestHelper"
   - "should I use error codes or custom state here?"
   - "plan a FluentValidation 11 to 12 upgrade"
3. Evaluate both trigger quality and first-use usefulness, not just raw content
   depth.
4. Tune the `SKILL.md` description after the content stabilizes.

Suggested file changes:

| Path | Action | Purpose |
| --- | --- | --- |
| `skills/martix-fluentvalidation/metadata.json` | Update | Keep the package inventory accurate after content changes |
| `skills/martix-fluentvalidation/SKILL.md` | Update later | Tune description after evaluation results |

### Recommended implementation order

1. Update `SKILL.md` description and opening sections
2. Add the anti-pattern quick reference
3. Add the integration and testing recipe references
4. Strengthen `AGENTS.md` routes and the selected maps
5. Deepen the selected high-value rules with small examples
6. Update `metadata.json`
7. Run a later evaluation loop with `skill-creator`

### What should not change

- Do not collapse the rule library into one large tutorial file.
- Do not remove the section contract in `rules/_sections.md`.
- Do not weaken the official-docs-first source boundary.
- Do not turn ecosystem packages into default guidance unless FluentValidation
  itself points there or the task is explicitly about ecosystem choices.
- Do not widen the package into general ASP.NET Core architecture guidance.
- Do not rewrite `README.md` first; its current install and package-identity
  role is already strong and does not appear to be the main usability gap.

### Definition of done for a future package update

The improvement work should be considered complete when:

- `SKILL.md` is easier to trigger for common FluentValidation prompts
- a new user can find a quick starting route without opening several files first
- the most common mistakes are discoverable from one place
- integration and testing recipes exist for the most common bootstrap tasks
- the current layered rule-and-map structure still feels intact
- metadata is updated to match the new package contents
- follow-up evaluation confirms the package is easier to use, not just longer
