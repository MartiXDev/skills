# MartiX Skills documentation and ecosystem review

<!--
role: research
snapshot: 2026-07-22
-->

<!-- markdownlint-disable MD013 -->

- Research date: 2026-07-22
- Repository: `MartiXDev/skills`
- Reviewed commit: `a8cc28b` (`feat(fluent-ui): adopt CSS-first styling policy`)
- Branch state: synchronized with `origin/main` at the time of review

> [!NOTE]
> This is a dated research snapshot, not a normative repository contract.
> Revalidate volatile upstream claims before using them in current guidance.
> **Review trigger:** After a major model or agent-platform wave, or within six
> months (by 2027-01-22).

## Executive summary

The repository's core architecture is sound and increasingly aligned with the
open Agent Skills ecosystem: standalone, progressively disclosed skills;
thin plugin bundles; deterministic scripts and hooks; canonical eval files;
and generic cost tiers rather than vendor model names.

The main problem is documentation drift caused by rapid package growth:

- The marketplace currently contains 12 standalone skills and 4 plugins, but
  the root README and repository overview omit `martix-essl` and
  `martix-afk-factory` in several catalog and install sections.
- `docs/repo-overview.md` still describes completed work as future work. It
  omits `martix-fluent-ui`, `martix-essl`,
  `martix-markdown-automation`, and `martix-afk-factory` from parts of its
  current-state catalog, says plugin folders are placeholders, and questions
  whether evals should be mandatory even though the repository contract now
  requires them.
- `docs/plugin-bundle-strategy.md` still calls React/TypeScript skills future
  dependencies even though `martix-typescript` and `martix-fluent-ui` now
  exist.
- `docs/README.md` omits `docs/afk-dev-factory.md` and the TypeScript research
  folder.
- `docs/recommended-skills.md` is a 667-line manually copied ecosystem
  snapshot. It mixes a curated shortlist, volatile inventories, install
  guidance, and third-party discovery sources. This format will drift quickly.
- The source index is strong for GitHub, VS Code, and Agent Skills, but lacks
  first-party Anthropic, OpenAI, Microsoft Foundry, Ollama, MCP security, and
  prompt-caching references.
- `docs/custom-ai-artifact-rules.md` has a good decision model but now trails
  current Copilot CLI plugin and hook capabilities, including plugin
  `commands`, `extensions`, `lspServers`, policy hooks, HTTP hooks, prompt
  hooks, current hook events, and the CLI's direct skill installation modes.

The highest-value change is not a single large rewrite. It is a documentation
architecture refactor that separates:

1. Stable mission and terminology.
2. Current generated inventory.
3. Normative repository contracts.
4. Fast-moving upstream capability references.
5. Dated research snapshots and historical plans.
6. A provider-neutral model evaluation playbook.

The long-term mission should be explicit in `README.md`, `CONTEXT.md`, and
`AGENTS.md`:

> Build best-in-class, evidence-backed Agent Skills that produce reliable
> results across model tiers, with particular emphasis on making the cheapest
> capable hosted or local model safe to use for each implementation task.

This mission should be operationalized through cross-model eval waves, not
through static claims that one provider or model is "best."

## Scope and method

### Repository evidence reviewed

The review covered:

- `README.md`
- `CONTEXT.md`
- `AGENTS.md`
- `docs/README.md`
- Every Markdown file directly under `docs/`
- Current `skills/`, `plugins/`, and marketplace inventories
- Recent history for TypeScript, Fluent UI, ESSL, and AFK Factory additions
- Representative package metadata, SKILL descriptions, and eval inventories

Direct `docs/` Markdown files reviewed:

- `docs/afk-dev-factory.md`
- `docs/custom-ai-artifact-resources.md`
- `docs/custom-ai-artifact-rules.md`
- `docs/execution-profiles.md`
- `docs/llm-routing-strategy.md`
- `docs/parallel-worktree-guidance.md`
- `docs/plugin-bundle-strategy.md`
- `docs/README.md`
- `docs/recommended-skills.md`
- `docs/repo-overview.md`
- `docs/skill-portfolio-coordination-plan.md` **Errata (2026-07-22):** This file has been moved to `docs/archive/plans/skill-portfolio-coordination-plan.md`.

### External evidence standard

Primary sources were preferred: official specifications, product docs,
first-party engineering posts, changelogs, and source repositories. Preview,
experimental, deprecated, and uncertain claims are called out explicitly.
Provider pricing should remain linked rather than copied because it changes
too quickly.

## Current repository inventory

The machine-readable marketplace is the most reliable current inventory:
`.github/plugin/marketplace.json:11-261`.

### Standalone skills

1. `martix-dotnet-csharp`
2. `martix-essl`
3. `martix-fastendpoints`
4. `martix-fluent-ui`
5. `martix-fluentvalidation`
6. `martix-markdown`
7. `martix-powershell`
8. `martix-sharepoint-pnp`
9. `martix-sharepoint-server`
10. `martix-sharepoint-spfx`
11. `martix-tunit`
12. `martix-typescript`

### Plugins

1. `martix-afk-factory`
2. `martix-dotnet-library`
3. `martix-markdown-automation`
4. `martix-webapi`

All 12 skills currently have execution-profile metadata and canonical
`evals/evals.json` files. All also contain negative activation coverage.
This means older roadmap language about optional evals or incomplete package
contracts is no longer current.

## Repository documentation drift

### Root `README.md`

Strengths:

- Clear marketplace-first positioning and install order
  (`README.md:6-23`).
- Correct standalone-first distinction (`README.md:88-92`).
- Good low-friction links to maintainer guides (`README.md:94-109`).

Required updates:

- Add `martix-essl` to quick install and repository structure.
- Add `martix-afk-factory` to quick install and plugin structure.
- Add `martix-essl`, `martix-typescript`, and AFK-related research to the
  documentation map where relevant.
- Add a short "Quality and model efficiency" section that states the
  best-in-class/cheapest-capable-model mission and links to the proposed
  model evaluation playbook.
- Generate the catalog table from marketplace metadata rather than editing it
  manually.
- Add "Commands verified on YYYY-MM-DD" beside fast-moving Copilot CLI install
  examples.

### `CONTEXT.md`

The glossary is concise and useful, but it only defines current repository
terms. It does not state the outcome the repository is optimizing.

Add:

- A `Mission` section before the glossary.
- Definitions for `model eval wave`, `capability floor`, `quality tier`,
  `cost tier`, `reference model`, and `cheapest capable model`.
- A rule that model rankings are dated benchmark results, not durable package
  facts.
- A rule that vendor-specific model names belong in benchmark configurations
  and dated reports, not reusable skill behavior.

### Root `AGENTS.md`

Strengths:

- Good preflight router and ownership model (`AGENTS.md:7-20`).
- Correct progressive-disclosure contract (`AGENTS.md:27-35`).
- Clear canonical eval schema (`AGENTS.md:37-53`).

Required updates:

- Add the repository mission in one compact paragraph.
- Add a "Model evaluation contract" pointer to the proposed playbook.
- State that package changes affecting routing, tool use, output shape, or
  validation must be evaluated across the current reference model set.
- State that a cheaper model may be promoted only from measured results, not
  anecdotal success.
- Add explicit boundaries in the GitHub-recommended form: always allowed,
  ask/coordinate first, and never.

GitHub's analysis of more than 2,500 `AGENTS.md` files recommends putting
commands early, using examples, declaring exact stack versions, and covering
commands, tests, structure, style, git workflow, and boundaries:
<https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/>

### `docs/README.md`

Required updates:

- Add `afk-dev-factory.md` to active or package-specific guides.
- Add `martix-typescript/` and `martix-essl/` to domain research folders.
- Classify each linked document as `normative`, `operational`, `research`,
  `roadmap`, or `historical`.
- Link the proposed model evaluation playbook.
- Link an archive index for superseded plans.

### `docs/repo-overview.md`

This file has the largest concentration of stale current-state claims.

Examples:

- The layout omits current packages (`docs/repo-overview.md:56-79`).
- The current catalog omits `martix-essl` and `martix-fluent-ui` in parts of
  the standalone skill list (`docs/repo-overview.md:159-181`).
- The plugin catalog omits `martix-markdown-automation` and
  `martix-afk-factory` (`docs/repo-overview.md:176-181`).
- It says plugin asset folders are placeholders
  (`docs/repo-overview.md:217-225`), which is false for the AFK Factory and
  Markdown automation plugins.
- It asks whether evals should be required
  (`docs/repo-overview.md:198-215`), although the root `AGENTS.md` and
  repository validator already define a mandatory canonical eval contract.
- Several roadmap items describe validation and templates that now exist.

Refactor:

- Keep only purpose, install surfaces, package types, source boundaries,
  machine-generated inventory, and stable maintenance rules.
- Move all remaining roadmap content to a dated roadmap file.
- Remove "recommended implementation order" once completed.
- Add a generated "repository facts" block with package counts and validation
  status.

### `docs/plugin-bundle-strategy.md`

Required updates:

- Add `martix-afk-factory` to existing bundles.
- Replace "future React/TypeScript skill" references
  (`docs/plugin-bundle-strategy.md:40-43`, `60-68`) with current
  `martix-typescript` and `martix-fluent-ui` capabilities.
- Reassess `martix-webapp`: its previously missing dependencies now exist.
- Replace readiness prose with a small status table sourced from actual
  package existence and manifest validity.
- Document new plugin components from the current CLI reference:
  `commands`, `extensions`, and `lspServers`, in addition to skills, agents,
  hooks, and MCP servers.

Official plugin schema:
<https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference>

### `docs/custom-ai-artifact-rules.md`

The document is valuable but too large for one frequently changing normative
surface. It should become a compact decision router plus artifact-specific
files.

Correct current principles:

- Use the narrowest artifact that satisfies the requirement.
- Prefer skills for reusable, task-specific capability.
- Prefer instructions for persistent behavior.
- Prefer hooks/scripts for deterministic enforcement.
- Prefer MCP only when external tools or data are necessary.
- Keep `SKILL.md` as a progressive-disclosure router.

Updates required from current upstream docs:

- Agent Skills:
  - Cite the canonical specification at
    <https://agentskills.io/specification>.
  - Add the official recommendation: full `SKILL.md` under 500 lines and
    under 5,000 tokens.
  - Mark `allowed-tools` as experimental and client-dependent.
  - Add `skills-ref validate` as an upstream compatibility check.
- Copilot custom agents:
  - Reconcile current `infer` behavior and current supported frontmatter with
    the live GitHub custom agent reference.
- Plugins:
  - Add `commands`, `extensions`, `lspServers`, `homepage`, `category`, and
    `tags` where applicable.
  - Distinguish stable Copilot CLI support from VS Code Agent Plugins, which
    remains Preview:
    <https://code.visualstudio.com/docs/agent-customization/agent-plugins>.
- Hooks:
  - Document policy, user, repository, settings, and plugin hook sources.
  - Document command, HTTP, and session-start prompt hooks.
  - Document current events and CLI/cloud-agent differences.
  - Preserve a Preview warning for the VS Code surface.
  - Use the current GitHub reference:
    <https://docs.github.com/en/copilot/reference/hooks-reference>.
- MCP:
  - Add current authorization/security requirements and tool annotations.
  - Require input validation, output sanitization, least privilege, explicit
    consent, exact redirect validation, token audience validation, and SSRF
    controls.
  - Cite
    <https://modelcontextprotocol.io/docs/tutorials/security/security_best_practices.md>.

Recommended split:

```text
docs/
  standards/
    artifact-selection.md
    agent-skills.md
    agents-and-instructions.md
    plugins-and-marketplaces.md
    hooks-and-scripts.md
    mcp-and-lsp.md
    eval-contract.md
```

`custom-ai-artifact-rules.md` can remain as a compatibility entrypoint that
links to these smaller normative files.

### `docs/custom-ai-artifact-resources.md`

Expand the primary-source index with dated verification fields and these
sections:

- Anthropic Agent Skills and prompt caching.
- OpenAI prompt caching, evals/datasets, agents, tools, and structured output.
- Microsoft Foundry prompt caching, evaluation, and agent framework.
- GitHub Copilot CLI changelog and command reference.
- Ollama API compatibility, tool calling, and structured output.
- MCP specification, security, extensions, and roadmap.
- AGENTS.md first-party GitHub guidance.

Store source metadata in a machine-readable file so stale links can be found:

```yaml
- id: agentskills-spec
  url: https://agentskills.io/specification
  authority: primary
  area: agent-skills
  last_verified: 2026-07-22
  volatility: medium
```

### `docs/execution-profiles.md` and `docs/llm-routing-strategy.md`

These documents duplicate the same tier table. Consolidate stable tier and
context policy into one normative document, tentatively:
`docs/model-and-context-strategy.md`.

Keep:

- Generic tiers: `cheap`, `medium`, `premium`, `mixed`.
- Hooks/scripts as zero-token routing.
- No model aliases in `SKILL.md` or `plugin.json`.
- Vendor names only where a runtime explicitly supports model selection.
- Small context by default and progressive disclosure.

Add:

- `local` as a deployment/provider attribute, not a quality tier.
- Capability requirements: tool use, structured output, context size,
  reasoning, vision, language, and platform compatibility.
- A benchmark-derived "cheapest capable model" rule.
- Prompt-cache-friendly artifact ordering.
- A link to the model evaluation playbook.

### `docs/skill-portfolio-coordination-plan.md`

**Errata (2026-07-22):** This file has been archived to `docs/archive/plans/skill-portfolio-coordination-plan.md`.

This is a useful historical plan, but it only covers four skills and therefore
should not be presented as the current portfolio map.

Choose one:

1. ~~Archive it as a dated historical plan~~; or (completed: archived to `docs/archive/plans/skill-portfolio-coordination-plan.md`)
2. Replace it with a generated portfolio relationship map covering all skills.

Do not continuously expand the existing 230-line plan. Package metadata should
own companion relationships; a generated report should render them.

### `docs/recommended-skills.md`

This file should be substantially refactored.

Problems:

- It copies large volatile inventories from `github/awesome-copilot`.
- It mixes personal recommendations, registry discovery, vendor catalogs,
  exact item listings, and installation scripts.
- It presents third-party directories as if they were equivalent in authority.
- The dated status says 2026-03-25 while much of the content was updated later.
- The manual clone-and-copy approach can bypass normal package provenance,
  update, and review workflows.

Recommended replacement:

```text
docs/ecosystem/
  recommended-sources.md        # Small, curated, durable shortlist
  evaluation-criteria.md        # How external packages are assessed
  snapshots/
    2026-07-22.md               # Dated ecosystem findings
```

The curated file should rank sources by:

- First-party or community ownership.
- License.
- Last release/activity.
- Agent Skills spec compatibility.
- Presence of scripts and executable risk.
- Eval evidence.
- Trigger precision.
- Token footprint.
- Portability.
- Provenance and update mechanism.

Do not copy entire upstream inventories. Link to their generated indexes.

### `docs/afk-dev-factory.md`

The guide needs immediate upstream revalidation.

- The statement that Copilot CLI cannot run headlessly
  (`docs/afk-dev-factory.md:122-126`) conflicts with current non-interactive CLI
  modes and should be retested against the current command reference.
- Token scope, cloud-agent task API, model names, and subscription claims are
  high-volatility operational facts.
- The guide duplicates plugin README content.

Move stable setup and usage into
`plugins/martix-afk-factory/README.md`. Keep only architecture, operating
model, and dated API limitations in `docs/`.

## External ecosystem findings

### Agent Skills

The canonical open specification is now
<https://agentskills.io/specification>. Important verified requirements:

- `SKILL.md` is required.
- `name` and `description` are required.
- The name must match the parent directory.
- `allowed-tools` is experimental.
- Progressive disclosure is explicit:
  metadata first, full instructions on activation, supporting resources only
  when required.
- `SKILL.md` should stay under 500 lines and under 5,000 tokens.
- References should be shallow and loaded for explicit reasons.
- The upstream validator is `skills-ref validate`.

The best-practices guide says useful skills should be extracted from real
execution, corrections, incidents, schemas, code review history, and actual
failure cases, not generated from generic "best practices":
<https://agentskills.io/skill-creation/best-practices.md>.

This strongly validates MartiX's router/rules/references/templates design.

### GitHub Copilot and VS Code customization

The official Copilot CLI comparison defines:

- Instructions: persistent behavior.
- Skills: task-specific just-in-time workflows.
- Tools: abilities.
- MCP: external tool collections.
- Hooks: deterministic lifecycle logic.
- Subagents: isolated delegated contexts.
- Custom agents: specialized role/tool profiles.
- Plugins: installable bundles of these surfaces.

Source:
<https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features>

The current plugin reference adds direct skill installs using
`copilot plugins install --skill`, project scope, plugin enable/disable/update,
`commands`, `extensions`, MCP, and LSP component fields:
<https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference>.

VS Code Agent Plugins remain Preview and can execute local code through hooks
or MCP servers. The repository should publish explicit trust and provenance
guidance:
<https://code.visualstudio.com/docs/agent-customization/agent-plugins>.

### MCP

MCP is now a significant security and distribution boundary, not merely a
configuration file.

Official security guidance requires or recommends:

- Per-client consent for proxy authorization.
- Exact redirect URI checks.
- OAuth state validation.
- No token passthrough; tokens must be issued for the MCP server.
- SSRF protections for metadata discovery and redirects.
- Input validation, access control, rate limiting, and sanitized tool output.
- Explicit user authorization for executable tools.

Source:
<https://modelcontextprotocol.io/docs/tutorials/security/security_best_practices.md>.

Current tool metadata also supports `readOnlyHint`, `destructiveHint`,
`idempotentHint`, and `openWorldHint`; these should be used as helpful
annotations, never as a substitute for enforcement:
<https://github.com/modelcontextprotocol/modelcontextprotocol/blob/main/schema/draft/schema.ts>.

New technology to watch:

- MCP Apps: interactive sandboxed UI resources provided by MCP servers.
- MCP Server Cards: roadmap-level discovery metadata, not yet a durable
  repository requirement.
- Tasks and enterprise-managed authorization: active MCP roadmap areas.

Do not document roadmap items as shipped until the relevant specification
version is published.

### Prompt and context caching

Caching deserves one central, dated reference because it materially affects
cost, but implementations differ.

#### OpenAI

Verified from
<https://developers.openai.com/api/docs/guides/prompt-caching>:

- Automatic caching applies to eligible prompts at least 1,024 tokens long.
- Exact shared prefixes matter; static content should be first.
- `prompt_cache_key` improves routing for shared prefixes.
- GPT-5.6 and later support explicit breakpoints and a current 30-minute
  minimum TTL.
- Older models use `prompt_cache_retention`; that field is deprecated for
  GPT-5.6 and later.
- Cache reads and writes are observable through `cached_tokens` and
  `cache_write_tokens`.
- GPT-5.6-era write billing makes cache-write churn a cost risk.
- Tool definitions, images, messages, and structured-output schemas can
  participate in cached prefixes.

#### Azure OpenAI in Microsoft Foundry

Verified from the Microsoft Learn page updated 2026-07-17:
<https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/prompt-caching>.

- Prompt caching is automatic for supported models.
- The request needs at least 1,024 tokens and an identical initial prefix.
- Cache hits continue in 128-token increments.
- `prompt_cache_key` is supported for GPT-5.6.
- Azure does not currently support OpenAI's
  `prompt_cache_options` or explicit breakpoint fields.
- In-memory and extended retention behavior differs by model.
- Cache reads are reported in `cached_tokens`.

#### Anthropic

Verified from
<https://platform.claude.com/docs/en/build-with-claude/prompt-caching>:

- Supports automatic caching or explicit `cache_control` breakpoints.
- Default cache lifetime is 5 minutes; 1-hour caching is available.
- Prompt order is tools, system, then messages up to the breakpoint.
- Cache writes cost more than normal input; cache reads are substantially
  discounted.
- All active Claude models support prompt caching at the time of review.

#### Google Gemini

Verified from <https://ai.google.dev/gemini-api/docs/caching>:

- Implicit caching is enabled by default on Gemini 2.5 and newer models.
- Model-specific minimum token thresholds apply.
- Stable common prefixes and temporally close requests improve hit rates.
- Cache hits are observable through `usage.total_cached_tokens`.

#### Repository guidance

Do not place provider pricing tables in skills. Add these stable principles:

1. Put stable instructions, tool schemas, and examples before variable input.
2. Avoid timestamps, request IDs, or user-specific data in reusable prefixes.
3. Measure cached reads and writes separately.
4. Compare warm-cache and cold-cache latency and cost.
5. Keep provider-specific cache controls in runner adapters, not skill docs.
6. Never optimize token cost by weakening safety or dropping required context.

### Cheap, free, and local model strategy

There is no durable universal "best cheap model." The correct output is a
dated capability map per skill and task type.

High-leverage practices for weaker models:

- Precise skill descriptions with positive and negative trigger language.
- Small routers with explicit defaults and explicit file-load conditions.
- Deterministic scripts for parsing, validation, formatting, and generation.
- Structured output schemas and programmatic validators.
- Few choices; provide a default and one escape hatch.
- Concrete templates and examples.
- Short validation loops with actionable errors.
- Tool schemas with narrow inputs and clear descriptions.
- Fresh-context eval runs and repeated trials.
- A stronger model only for planning, difficult review, or grading where
  deterministic grading is impossible.

GitHub Models is not a durable free-model recommendation: GitHub announced
full retirement for 2026-07-30, including the playground, catalog, inference
API, and BYOK:
<https://github.blog/changelog/2026-07-01-github-models-is-being-fully-retired-on-july-30-2026/>.

## Documentation refactor proposal

### Target information architecture

```text
README.md                         # User-facing product page and generated catalog
CONTEXT.md                        # Mission, stable glossary, durable principles
AGENTS.md                         # Contributor/agent operating contract
docs/
  README.md                       # Low-token role-based index
  architecture/
    repository.md                 # Current architecture only
    portfolio-map.md              # Generated relationships/current packages
  standards/
    artifact-selection.md
    agent-skills.md
    agents-and-instructions.md
    plugins-and-marketplaces.md
    hooks-and-scripts.md
    mcp-and-lsp.md
    eval-contract.md
  operations/
    model-evaluation-playbook.md
    parallel-worktrees.md
    afk-factory.md
  strategy/
    model-and-context-strategy.md
    plugin-bundles.md
  research/
    sources.yaml
    2026-07-ai-agent-ecosystem.md
    ecosystem-snapshots/
  roadmaps/
    current.md
  archive/
    README.md
    completed-plans/
```

This is a proposal, not a requirement to move every file immediately. The
critical principle is to distinguish normative, current, dated, and historical
content.

### Document metadata

Every maintainer document should declare:

```yaml
status: normative | current | research | roadmap | historical
owner: repository | package-name
last_verified: YYYY-MM-DD
source_of_truth: path-or-url
review_when:
  - upstream capability changes
  - package inventory changes
```

If frontmatter would interfere with a consumer, render the same fields in a
small status table.

### Generated content

Generate, then validate:

- Root README package catalog from marketplace metadata.
- Package counts.
- Documentation folder inventory.
- Portfolio companion-skill map from metadata relationships.
- Source freshness report from `docs/research/sources.yaml`.

Use markers so generated blocks are not manually edited.

## Proposed model evaluation playbook

Create `docs/operations/model-evaluation-playbook.md` and link it from
`README.md`, `CONTEXT.md`, `AGENTS.md`, `docs/README.md`,
`docs/model-and-context-strategy.md`, and the canonical eval contract.

### Purpose

The playbook should answer:

- Which models are best for each skill and task type?
- Which cheaper models are good enough for implementation?
- What is the least expensive model that still meets the quality floor?
- Which local Ollama models are viable on available hardware?
- Did a new model wave improve quality, cost, latency, or consistency?
- Did a skill change add measurable value over no skill or its prior version?

### Principles

1. Keep package eval definitions provider-neutral.
2. Keep model/provider configuration outside package eval files.
3. Compare the same skill commit, fixtures, tools, and prompts across models.
4. Run each nondeterministic case multiple times.
5. Separate activation quality from execution quality.
6. Prefer deterministic grading; use blinded LLM judges only when necessary.
7. Record quality, failures, latency, tokens, cache behavior, and cost.
8. Preserve raw outputs and runner metadata for reproducibility.
9. Do not infer capability from one successful demo.
10. Promote the cheapest model only after it clears the task-specific floor.

### Canonical data versus transient benchmark data

Keep one canonical package file:

```text
skills/<skill>/evals/evals.json
```

It remains provider-neutral and contains prompts, expected behavior, files,
assertions, negative activation, model tier, token budget, parallel safety,
and escalation expectations.

Keep model matrices and run outputs outside package definitions:

```text
benchmarks/
  configs/
    providers.yaml
    model-waves/
      2026-07.yaml
  runs/
    2026-07-22T120000Z/
      manifest.json
      results.jsonl
      summary.json
      report.md
```

If benchmark output becomes too large or contains provider data, store it as a
CI artifact or release asset and commit only the compact report and manifest.
Never commit prompts or outputs containing secrets, customer data, or licensed
private content.

### Model-wave configuration

Example:

```yaml
wave: 2026-07
reason: new OpenAI, Anthropic, and local model releases
skill_commit: a8cc28b
repetitions: 3
temperature: 0
max_concurrency: 4
models:
  - id: openai/example-small
    provider: openai
    deployment: hosted
    expected_tier: cheap
  - id: anthropic/example-medium
    provider: anthropic
    deployment: hosted
    expected_tier: medium
  - id: ollama/qwen-example
    provider: ollama
    deployment: local
    expected_tier: cheap
    base_url: http://localhost:11434/v1
```

Use exact immutable model versions when providers expose them. Record aliases
only as labels. For Ollama, record the model tag, digest, quantization, context
size, Ollama version, CPU/GPU, VRAM/RAM, and relevant runtime options.

### Capability gate before quality evals

Do not run every model on every scenario. First check:

- Required context window.
- Tool/function calling.
- Parallel tool calling if required.
- Structured output or JSON-schema support.
- File/image support if required.
- System/developer message support.
- Deterministic seed or temperature support.
- Required language quality.
- Runtime compatibility and license.

A model that fails a mandatory capability is `unsupported`, not merely
low-scoring.

### Eval layers

#### Layer 1: Activation and routing

Measure:

- Positive trigger recall.
- Negative trigger specificity.
- False activation rate.
- Correct companion-skill handoff.
- Correct refusal/out-of-scope behavior.

Run descriptions alone where possible, because Agent Skills discovery initially
loads only name and description. This isolates description quality from full
skill execution.

#### Layer 2: Instruction following

Measure:

- Required files loaded.
- Prohibited files avoided.
- Defaults followed.
- Output structure followed.
- Escalation used correctly.
- No invented capabilities or sources.

#### Layer 3: Tool and workflow execution

Measure:

- Correct tool selected.
- Valid tool arguments.
- Tool-call success rate.
- Recovery after deterministic tool errors.
- Number of unnecessary calls.
- Completion without unsafe commands or scope expansion.

#### Layer 4: Artifact quality

Use package-specific assertions:

- Code builds/tests.
- JSON/YAML parses.
- Markdown passes lint.
- Generated document opens.
- Required sections exist.
- Security and accessibility constraints hold.
- Source citations resolve.

#### Layer 5: Efficiency

Record:

- Input, output, reasoning, and total tokens where available.
- Cached read and cache-write tokens.
- Time to first token and total wall-clock duration.
- Tool-call count.
- Retries and failures.
- Hosted API cost using a dated price snapshot.
- Local runtime: tokens/second, peak RAM/VRAM, energy if measurable.

Report cold-cache and warm-cache results separately.

### Baselines

For every material skill update, compare:

1. Current skill versus no skill.
2. Current skill versus previous released skill.
3. Candidate cheap model versus current reference model.
4. Local model versus hosted model at the same quality floor.

Agent Skills' official eval guide recommends with-skill and without-skill
runs, clean contexts, assertions, timing data, benchmark aggregation, and
human review:
<https://agentskills.io/skill-creation/evaluating-skills.md>.

### Repetitions and variance

Recommended defaults:

- Deterministic, exact-match cases: at least 1 run during development and
  3 runs for a model-wave report.
- Tool-using or open-ended cases: at least 3 runs.
- High-risk or flaky cases: 5-10 runs.

Publish mean, median, standard deviation, minimum, and failure count. A model
with a high average but frequent catastrophic failures should not be assigned
to AFK implementation.

### Grading order

Use this order:

1. Programmatic validators.
2. Exact/normalized match.
3. Schema checks.
4. Repository tests and linters.
5. Rubric-based human grading.
6. Blinded LLM judge.

An LLM judge must not know model identity or which output is expected to win.
Use a stronger, stable judge model and periodically calibrate it against human
ratings. Record judge model/version and rubric.

### Suggested scorecard

| Dimension | Weight | Blocking floor |
| --- | ---: | ---: |
| Task correctness | 35% | 80% |
| Safety and scope | 20% | 100% on critical assertions |
| Tool/workflow reliability | 15% | 90% |
| Output contract | 10% | 95% |
| Activation quality | 10% | 90% |
| Efficiency | 10% | None; used after quality floor |

Weights must be configurable per skill. Security-sensitive skills should give
safety a higher weight. A model cannot compensate for a blocking safety failure
with lower cost.

### Classification

Classify each model per skill and task type:

- `reference`: best validated quality; used for difficult planning/review.
- `recommended`: clears all floors with acceptable variance.
- `implementation`: safe for normal package-local implementation.
- `mechanical-only`: usable for deterministic cleanup/validation.
- `human-supervised`: useful but too inconsistent for AFK work.
- `unsupported`: lacks a required capability.
- `failed`: has the capability but misses blocking quality/safety floors.

Then select:

> Cheapest capable model = lowest measured total cost among models classified
> for the required task type, after quality, safety, and variance floors pass.

### Cost calculation

Store dated provider prices in benchmark configuration, not skill packages.

For hosted models:

```text
run_cost =
  uncached_input_tokens * uncached_input_rate
  + cache_write_tokens * cache_write_rate
  + cached_input_tokens * cached_input_rate
  + output_tokens * output_rate
  + tool/service charges
```

For local models, report:

- Hardware amortization is optional and must be labeled.
- Electricity estimate is optional and must be labeled.
- Always report wall time, throughput, and peak RAM/VRAM.

"Free" should mean no marginal API charge, not zero operational cost.

### Prompt-cache protocol

For caching-capable providers:

1. Run one cold request.
2. Repeat the exact prefix within the provider TTL.
3. Record cache-write and cached-read tokens.
4. Change only the dynamic suffix.
5. Confirm quality is unchanged.
6. Repeat after TTL expiry when practical.

Do not compare a warm cached model with an uncached competitor without clearly
labeling the difference.

### Ollama lane

Ollama exposes OpenAI-compatible `/v1/chat/completions` and `/v1/responses`
endpoints:
<https://docs.ollama.com/api/openai-compatibility>.

It also supports tool calling:
<https://docs.ollama.com/capabilities/tool-calling>, and JSON-schema structured
outputs:
<https://docs.ollama.com/capabilities/structured-outputs>.

Use the same runner adapter where possible:

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:11434/v1/",
    api_key="ollama",
)
```

Ollama-specific rules:

- Pull models before timed runs.
- Warm the model once, but record both cold-load and warm inference latency.
- Pin model digest and quantization.
- Set explicit context length.
- Use temperature 0 where supported.
- Record whether the model truly supports the required tools/schema rather
  than assuming API compatibility implies model capability.
- Run models sequentially when VRAM contention would distort results.
- Record truncation and context-overflow failures.

### Runner and framework recommendation

Start with a small repository-owned adapter that reads canonical
`evals/evals.json` and writes provider-neutral JSONL. Do not bind canonical
eval definitions to one provider's service.

Useful optional frameworks:

- Inspect AI, from the UK AI Security Institute, supports tool use,
  multi-turn tasks, model-graded evals, and many model providers:
  <https://github.com/UKGovernmentBEIS/inspect_ai>.
- EleutherAI's LM Evaluation Harness is useful for standardized language-model
  benchmarks, especially local/open models:
  <https://github.com/EleutherAI/lm-evaluation-harness>.

Use these as runners/adapters, not as replacements for the repository's
skill-specific canonical eval schema.

OpenAI's current Evals platform is already scheduled to become read-only on
2026-10-31 and shut down on 2026-11-30, with Datasets recommended for new work:
<https://developers.openai.com/api/docs/guides/evals>. This is another reason
not to make provider-hosted eval storage canonical.

### Model-wave workflow

1. Select the skills and task types affected by the new model wave.
2. Freeze repository commit, fixtures, runner, rubrics, and provider prices.
3. Run capability gates.
4. Run smoke evals on all candidates.
5. Eliminate unsupported or blocking-failure candidates.
6. Run full repeated evals on remaining candidates.
7. Grade programmatically.
8. Run blinded judging/human review only for unresolved qualitative cases.
9. Aggregate quality, variance, latency, tokens, caching, cost, and local
   hardware metrics.
10. Produce per-skill and portfolio reports.
11. Update the dated model recommendation map.
12. Do not edit skill instructions merely to favor one weak model unless the
    change improves or preserves results across the reference set.

### Promotion and regression policy

Promote a cheaper model when:

- It passes every blocking assertion.
- Its repeated-run lower confidence bound clears the task floor.
- It has no new severe failure mode.
- Its total measured cost is lower.
- Its latency and tool reliability are acceptable.

Reject a skill change when:

- It improves one model but materially regresses the reference model.
- It increases tokens or runtime without meaningful quality gain.
- It overfits benchmark wording.
- It weakens negative activation or scope boundaries.

### Report format

Each wave report should include:

- Date, trigger, repository commit, and runner commit.
- Model IDs/versions and provider endpoints.
- Local hardware/runtime details.
- Skills and eval IDs included/excluded.
- Sampling parameters and repetitions.
- Capability-gate results.
- Quality and safety scorecards.
- Failure taxonomy.
- Token, cache, latency, and cost metrics.
- Cheapest-capable recommendation by skill/task.
- Uncertainty and known limitations.
- Raw artifact location.

## Prioritized implementation plan

### Priority 0: Correct current-state drift

1. Synchronize root README catalog and install examples.
2. Update repository overview inventory and remove completed roadmap language.
3. Update plugin strategy for TypeScript, Fluent UI, and AFK Factory.
4. Add missing docs-index entries.
5. Revalidate AFK Factory's headless/API/token claims.

### Priority 1: Encode the mission and eval operating model

1. Add the best-in-class/cheapest-capable-model mission to `README.md`,
   `CONTEXT.md`, and `AGENTS.md`.
2. Add `docs/operations/model-evaluation-playbook.md`.
3. Add provider-neutral benchmark config and result schemas.
4. Run a small pilot across 2 skills, 3 hosted models, and 1 Ollama model.

### Priority 2: Refactor normative docs

1. Split the large artifact rules by artifact type.
2. Consolidate execution profiles and LLM routing.
3. Add current plugin/hook/MCP fields and security rules.
4. Add source freshness metadata.

### Priority 3: Eliminate recurring drift

1. Generate README catalogs.
2. Validate docs inventory against actual folders.
3. Validate current-state claims against marketplace/package metadata.
4. Archive completed plans.
5. Add a scheduled or ad hoc source-freshness report.

### Priority 4: Establish model-wave governance

1. Define reference and candidate model sets.
2. Add repeat/variance support.
3. Add cold/warm caching measurements.
4. Publish per-skill cheapest-capable recommendations.
5. Re-run after major provider or local-model waves.

## What should not change

- Do not put vendor model names in `SKILL.md` or `plugin.json`.
- Do not replace package-specific evals with generic academic benchmarks.
- Do not copy volatile provider pricing into every package.
- Do not load all references by default.
- Do not convert deterministic validators into LLM prompts.
- Do not claim broad cross-client compatibility without testing it.
- Do not optimize only for cheap models at the expense of correctness or
  safety.

## Key sources

### Agent Skills sources

- Specification: <https://agentskills.io/specification>
- Best practices:
  <https://agentskills.io/skill-creation/best-practices.md>
- Evaluating skills:
  <https://agentskills.io/skill-creation/evaluating-skills.md>
- Anthropic engineering rationale:
  <https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills>
- Reference implementation:
  <https://github.com/agentskills/agentskills/tree/main/skills-ref>

### GitHub Copilot and VS Code

- Copilot CLI customization comparison:
  <https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features>
- CLI plugin reference:
  <https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference>
- Plugin marketplaces:
  <https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-marketplace>
- Hooks reference:
  <https://docs.github.com/en/copilot/reference/hooks-reference>
- VS Code Agent Plugins:
  <https://code.visualstudio.com/docs/agent-customization/agent-plugins>
- AGENTS.md findings:
  <https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/>
- GitHub Models retirement:
  <https://github.blog/changelog/2026-07-01-github-models-is-being-fully-retired-on-july-30-2026/>

### Prompt caching

- OpenAI:
  <https://developers.openai.com/api/docs/guides/prompt-caching>
- Anthropic:
  <https://platform.claude.com/docs/en/build-with-claude/prompt-caching>
- Microsoft Foundry:
  <https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/prompt-caching>
- Google Gemini:
  <https://ai.google.dev/gemini-api/docs/caching>

### Evaluation and local models

- OpenAI evals:
  <https://developers.openai.com/api/docs/guides/evals>
- Anthropic evaluation guidance:
  <https://platform.claude.com/docs/en/test-and-evaluate/develop-tests>
- Ollama OpenAI compatibility:
  <https://docs.ollama.com/api/openai-compatibility>
- Ollama tool calling:
  <https://docs.ollama.com/capabilities/tool-calling>
- Ollama structured outputs:
  <https://docs.ollama.com/capabilities/structured-outputs>
- Inspect AI:
  <https://github.com/UKGovernmentBEIS/inspect_ai>
- LM Evaluation Harness:
  <https://github.com/EleutherAI/lm-evaluation-harness>

### MCP sources

- Security best practices:
  <https://modelcontextprotocol.io/docs/tutorials/security/security_best_practices.md>
- Specification repository:
  <https://github.com/modelcontextprotocol/modelcontextprotocol>
- Tool schema:
  <https://github.com/modelcontextprotocol/modelcontextprotocol/blob/main/schema/draft/schema.ts>

## Uncertainty and watch list

- VS Code Agent Plugins and VS Code hooks are Preview and may change.
- Copilot CLI command syntax is evolving quickly; examples need dated
  verification.
- `allowed-tools` in Agent Skills is experimental and client-dependent.
- MCP roadmap items are not commitments.
- Model names, prices, context limits, and free tiers are dated facts.
- Provider-hosted eval products can be deprecated; canonical repository evals
  should remain portable.
- Local model results are hardware-, quantization-, and runtime-dependent.
- A future model wave can invalidate current recommendations without changing
  the underlying skill.

## Bottom line

The repository does not need a new architectural direction. It needs current
inventory, clearer document roles, dated upstream evidence, generated catalogs,
and an eval-driven mechanism for proving which model tier each skill can use.

The proposed evaluation playbook turns the long-term goal into an enforceable
engineering loop:

> Design concise, deterministic, progressively disclosed skills; evaluate them
> across hosted and local models; and assign each task to the cheapest model
> that repeatedly clears explicit quality and safety floors.
