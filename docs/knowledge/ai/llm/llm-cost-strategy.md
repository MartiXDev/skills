# Cost-effective LLM strategy

<!-- markdownlint-configure-file { "MD013": { "tables": false } } -->

**Status:** Consolidated decision layer
**Synthesis date:** 2026-07-25
**Review by:** 2026-08-25, and before Claude Sonnet 5 promotion expiry on
2026-08-31
**Purpose:** Guide the reimplementation of repositories, skills, prompts,
instructions, hooks, and orchestration for the lowest total cost that still
meets explicit quality and safety floors.

**Inputs:**

- [Copilot strategy snapshot](./llm-cost-strategy-by-copilot.md)
- [Sonnet 5 strategy snapshot](./llm-cost-strategy-by-sonnet-5.md)
- [GPT-5.6 Sol strategy snapshot](./llm-cost-strategy-by-gpt-5-6-sol.md)
- [LLM cache strategy](./llm-cache.md)
- [Chronicle cost profile](./chronicle-cost-tips.md)

The input documents are dated evidence snapshots. This document is the active
decision layer; it should record new conclusions without rewriting the
snapshots.

## Executive decision

1. Optimize **accepted work per AI credit**, not token price alone. Include
   retries, duplicated context, validation, review, waiting, and human repair
   time in the comparison.
2. Run deterministic tools first: compilers, tests, analyzers, formatters,
   security checks, schema validation, and repository hooks.
3. Use **Auto or GPT-5 mini** for routine interactive work. Use **Claude Sonnet
   5** for consequential planning while its promotion lasts. Qualify Kimi K2.7
   Code, GPT-5.4 mini, MAI-Code-1-Flash, and Luna for scoped implementation
   before promoting them.
4. Keep expensive reasoning at low-volume leverage points: architecture,
   specifications, difficult debugging, and unresolved review. Use the cheapest
   qualified model for bounded implementation and exploration.
5. Keep one agent as the default. Use `/fleet` for two independent slices and
   Sandcastle for durable, isolated issue batches. Never nest the two forms of
   parallelism.
6. Treat prompt context as a budget. Reference files instead of pasting them,
   send diffs and evidence packs instead of whole repositories, and use fresh
   phase sessions when the task or model changes.
7. Do not create an LLM model-router skill. Use Auto, explicit orchestrator
   configuration, dated model aliases, deterministic gates, and telemetry.
8. Do not buy local hardware yet. Measure overages, local quality, latency,
   privacy value, and downgrade potential first.

## 1. Economics and evidence policy

### Current Copilot Max model

The current individual Max plan is documented as $100/month with 10,000 base
and 10,000 flex AI credits. One credit represents $0.01 of model usage. Credits
do not roll over; additional usage draws from the configured budget. Paid code
completions and next-edit suggestions are separate from this model-usage
budget. Auto model selection has a 10% model-cost discount.

The relevant objective is:

```text
effective task cost = model credits + retry credits + context duplication
                      + validation/review credits + human waiting/repair value
```

A more expensive model is economical when it prevents failed attempts. A strong
model is wasteful when a deterministic check or a lightweight qualified model
can pass the same acceptance test.

### Evidence rules

Use evidence in this order:

1. Current GitHub billing, availability, and product documentation.
2. Provider model cards and first-party technical documentation.
3. Comparable, reproducible benchmarks using the repository harness.
4. Vendor or aggregator benchmarks as qualification signals only.
5. Inference only when paired with a measurement gate.

No current public benchmark compares every candidate under one
repository-representative agent harness. Do not present universal model
rankings as fact.

### Known usage baseline

The Chronicle samples are bounded but actionable:

- v1 measured 148.6M tokens across 14 sessions, with 130:1 input/output and
  92.3% of tokens in the six largest sessions.
- v2 measured 162.6M tokens across 35 sessions; the largest six consumed 74.7%.
- Long sessions reached approximately 120K to 144K average late-turn input.
- The model mix changed between samples; therefore, preserve the measurement
  method, not a permanent model conclusion.

These figures indicate that large-session context and repeated exploration are
higher-priority cost targets than micro-optimizing short prompts. They are not
proof that every large research session was wasteful.

## 2. Model routing by task

These are initial routes, not permanent winners. A model enters a lane only if
it is available in the target client, supports required tools and context,
passes quality and safety floors, and has acceptable repeated-run variance.

| Task | Default | Qualified alternatives | Escalation |
| --- | --- | --- | --- |
| Mechanical formatting, renames, extraction | Deterministic tool; GPT-5.4 nano for judgment-free steps | Local 3B-7B model | GPT-5 mini if validation fails |
| Routine interactive coding | Auto or GPT-5 mini | Gemini 3 Flash, MAI-Code-1-Flash | GPT-5.4 mini |
| Codebase exploration | GPT-5.4 mini with a bounded evidence pack | GPT-5 mini | Sonnet 5 when ambiguity remains |
| Small C#/TypeScript/PowerShell change | GPT-5 mini | MAI, Gemini 3 Flash | Kimi or GPT-5.4 mini |
| Scoped multi-file feature | Kimi K2.7 Code or GPT-5.4 mini after qualification | MAI, Luna | GPT-5.3-Codex or Sonnet 5 |
| Consequential planning or migration | Claude Sonnet 5 during promotion | GPT-5.4, Gemini 3.1 Pro, qualified Terra | Opus only for unresolved exceptional risk |
| Routine review | Deterministic checks, then different-family Haiku or GPT-5 mini | Kimi | Sonnet 5 or Codex for unresolved/high-risk findings |
| Long-running or difficult agentic work | GPT-5.3-Codex | Sonnet 5 | Opus 4.6 only after cheaper failure |
| Offline/private scoped work | Qwen2.5-Coder 7B baseline | Ornith 9B, after local qualification | Cloud strong model when policy permits |

Current price references per million tokens are approximately:

| Model | Input | Cached input | Output | Initial role |
| --- | ---: | ---: | ---: | --- |
| GPT-5.4 nano | $0.20 | $0.02 | $1.25 | Mechanical work |
| GPT-5 mini | $0.25 | $0.025 | $2.00 | Baseline |
| GPT-5.4 mini / MAI-Code-1-Flash | $0.75 | $0.075 | $4.50 | Exploration and scoped agents |
| Kimi K2.7 Code | $0.95 | $0.19 | $4.00 | Scoped implementation |
| Claude Haiku 4.5 | $1.00 | $0.10 | $5.00 | Fast independent review |
| GPT-5.3-Codex | $1.75 | $0.175 | $14.00 | Difficult agentic work |
| Claude Sonnet 5 | $2.00 promotion | $0.20 | $10.00 | Consequential planning |
| GPT-5.4 / Terra | $2.50 | $0.25 | $15.00 | Deep reasoning/challenger |
| Claude Opus 4.6 | $5.00 | $0.50 | $25.00 | Exceptional escalation |

Prices, availability, and long-context tiers are volatile. Keep them in a
dated model alias map, not inside reusable skills or prompts. Raptor mini is a
client-availability experiment until the target CLI confirms support.

## 3. Cache and context discipline

Prompt caching requires a byte-identical prefix. Put stable content first and
variable content last:

```text
system rules -> repository instructions -> tool/MCP schemas -> task contract
-> selected evidence -> current diff/question
```

For each session:

- Fix the model, reasoning level, enabled tools, MCP servers, and context policy
  before the first call. Changing them can invalidate the cached prefix.
- Use auto/medium reasoning by default; reserve high reasoning for architecture,
  difficult debugging, and risky multi-file changes.
- Use low/minimal reasoning for formatting, extraction, documentation mechanics,
  and other deterministic tasks.
- Keep enabled tools narrow. Unused tool schemas still add fixed per-turn
  context overhead.
- Prefer `@file:` or paths over pasted artifacts.
- Send a file map, signatures, relevant snippets, errors, API versions, and
  acceptance commands before sending full files.
- Return a unified diff or validated JSON Patch for edits when the workflow can
  apply it safely; cap response length and reject malformed output.
- Use content-addressable caching for repeated generation, keyed at minimum by
  repository/commit, task template, input hash, model/version, and output
  contract. Invalidate on relevant source or instruction changes.
- Start a fresh session when changing task, phase, model, reasoning, or toolset.
- Use `/compact` once at a real milestone when the same work must continue and
  context has grown materially. It resets cache once, so do not compact near
  completion or repeatedly.
- Run `/context` during long work and `/chronicle cost-tips` after major waves
  or monthly.

The initial compaction trigger is approximately 100K tokens, derived from the
observed 120K-144K late-turn inputs, not a universal product limit.

## 4. Repository and AI-artifact architecture

The implementation target is a small, stable control plane with volatile
choices outside domain knowledge.

| Surface | Keep there | Cost rule |
| --- | --- | --- |
| `AGENTS.md` and `.github/copilot-instructions.md` | Short repo identity, safety, commands, ownership, and stable conventions | Never paste repeated lane rules into every request |
| `.github/instructions/*.instructions.md` | Narrow path-scoped backend, frontend, docs, and artifact behavior | Keep `applyTo` precise; avoid loading unrelated guidance |
| `.github/prompts/*.prompt.md` | Repeatable workflows with inputs, outputs, and validation | Accept issue/file IDs and deltas, not large static context |
| `skills/*/SKILL.md` | Compact routing entrypoint | Point to the smallest relevant rule/reference |
| `skills/*/rules` and `references` | Durable domain detail, evidence, and versioned facts | Load only the selected route |
| Plugin agents and prompts | Composition and orchestration-specific behavior | Keep reusable domain knowledge in standalone skills |
| Hooks and local scripts | Deterministic lint, format, schema, diff, and safety checks | Use zero-token enforcement before model calls |
| Model alias/config file | Dated tier-to-model mapping and client availability | Update without rewriting skills or prompts |
| Evidence-pack generator | File map, relevant symbols, errors, versions, constraints, acceptance commands | Replace broad repository reads with bounded inputs |
| Telemetry | Phase, model, credits, fresh/cached input, retries, outcome, latency | Support promotion decisions with measured data |

Use compact templates with variable injection for recurring work. Prefer a
small structured task contract, for example:

```text
TASK: refactor method
INPUT: {"file":"src/Service.cs","symbol":"Calculate","diff":"<git diff>"}
RETURN: unified git diff only
VALIDATE: dotnet test <focused project>
MAX_OUTPUT: 400 tokens
```

For deterministic transformations, a local codemod, Roslyn transform, ts-morph
script, or formatter is preferable to an LLM rewrite. For large repositories,
use staged inventory plus retrieval of only the relevant symbols; add RAG only
when simpler file maps and search are insufficient.

## 5. Orchestration defaults

### One agent first

One focused agent minimizes duplicated context, reconciliation, merge risk, and
credits. Use it for coherent work within one ownership boundary.

### `/fleet`

Use `/fleet` only for two, at most three, genuinely independent slices with
explicit file ownership and a pre-approved acceptance contract. Workers have
separate contexts and can consume more credits. Never use it merely to reduce
wall-clock time.

### Sandcastle

Use Sandcastle for isolated, unattended, issue-sized work where worktrees,
branch lifecycle, retries, and validation justify orchestration overhead.
The initial qualification profile is:

| Phase | Initial model | Rule |
| --- | --- | --- |
| Plan | Sonnet 5 | Low-volume, high-leverage reasoning |
| Implement | GPT-5 mini | Promote Kimi/GPT-5.4 mini only after qualification |
| Review | Haiku 4.5 for GPT-family implementers | Use a different family; escalate unresolved risk |
| Merge | GPT-5 mini or GPT-5.4 mini | Sonnet 5 for semantic cross-branch conflicts |

Every batch needs a total credit budget, worker and retry caps, deterministic
validation before review, concurrency cap of two, and an explicit outer-loop
stop condition. Never nest `/fleet` inside Sandcastle workers.

## 6. Qualification and escalation

### Quality gates

The cheapest capable model is the lowest-total-cost model that repeatedly:

- passes capability and client-availability gates;
- meets the lane quality floor and safety floor;
- passes deterministic validation;
- produces acceptable variance over at least three repeated tasks;
- does not require more total credits than the baseline after retries and review.

Use a representative evaluation set spanning .NET/C#, TypeScript/React,
PowerShell, SharePoint/M365, Markdown, prompt/instruction authoring, and
orchestration. Record accepted-result rate, critical-defect recall, retries,
fresh/cached input, credits, wall time, and human repair time.

### Escalate when

- two cheaper attempts fail the same acceptance test;
- requirements remain ambiguous after one evidence pass;
- authentication, authorization, cryptography, concurrency, or destructive
  migration is involved;
- the change crosses three or more architectural layers without a specification;
- a volatile API/version cannot be supported by current evidence;
- one stronger pass costs less than another expected retry;
- the agent claims success without reproducible validation.

### Downgrade when

- a specification removes architectural uncertainty;
- ownership and acceptance commands are exact;
- deterministic tests define success;
- an evidence pack contains the required API/version facts;
- the same task has repeatedly passed under the cheaper model.

## 7. Thirty-day implementation roadmap

### Week 1: baseline and boundaries

1. Freeze the current model aliases and source-report hashes.
2. Define task lanes, quality/safety floors, acceptance commands, and credit caps.
3. Add a short repository instruction layer and path-scoped instructions where
   repeated prompts currently carry stable rules.
4. Add telemetry for model, phase, credits, fresh/cached input, retries, outcome,
   context size, and wall time.
5. Measure one-agent GPT-5 mini, Auto, Sonnet 5, and current Sandcastle routes.

### Week 2: reduce context and response waste

1. Replace repeated prompt prose with prompt templates and variable injection.
2. Build an evidence-pack/preprocessor that extracts diffs, symbols, errors,
   API versions, constraints, and validation commands.
3. Require compact structured outputs: JSON Patch or unified diff, bounded by an
   explicit response limit and local schema validation.
4. Add deterministic hooks before model calls and after model edits.
5. Add a content-addressable cache for repeated templates and invalidate it on
   relevant commits or instruction changes.

### Week 3: qualify models and orchestration

1. Run at least three repeats per representative task for GPT-5 mini, Kimi,
   GPT-5.4 mini, MAI, Luna, and the relevant cross-family reviewer.
2. Compare broad research with a two-pass inventory plus focused follow-up.
3. Compare one agent with two independent `/fleet` workers.
4. Run one bounded Sandcastle batch with the phase split above.
5. Reject configurations that save wall time but increase effective cost without
   a justified throughput benefit.

### Week 4: promote and maintain

1. Promote only aliases that clear quality, safety, variance, and cost gates.
2. Keep volatile model identifiers in a dated alias map with owner, evidence
   date, review date, and client availability.
3. Publish compact prompt, skill, instruction, and hook templates for approved
   lanes.
4. Recalculate local hardware break-even and downgrade potential.
5. Schedule monthly Chronicle cost review and a routing/artifact drift check.

## 8. Measurement schema and success criteria

At minimum, record one row per task or agent session:

```text
repo, commit, task_id, lane, phase, model_alias, client,
input_fresh_tokens, input_cached_tokens, output_tokens, ai_credits,
retry_count, worker_count, context_size, compacted, validation_status,
review_status, accepted, critical_defects, wall_seconds, repair_seconds
```

Initial success criteria:

- 95% or more of measured sessions attributable to a task and model;
- 25% less fresh input for evidence-pack workflows without pass-rate loss;
- at least 40% cache hit rate for repeated templates before expanding caching;
- two-worker `/fleet` only when accepted throughput improves at an acceptable
  effective cost;
- local model promotion only at 90% or more of GPT-5-mini acceptance with no
  safety regression;
- expensive review limited to high-risk or unresolved diffs without critical-
  defect recall loss;
- no nested parallelism and no unbounded retry/outer-loop behavior.

## 9. Refresh triggers and references

Refresh this document when:

- Copilot pricing, Max allowances, Auto behavior, model availability, or billing
  changes;
- Claude Sonnet 5 promotion ends or a new model card materially changes routing;
- a qualification wave changes cost per accepted result by 20% or more;
- Sandcastle or `/fleet` changes billing, isolation, concurrency, or model
  selection;
- repository instruction, skill, prompt, or hook architecture changes;
- a new Chronicle sample changes the high-session or late-context pattern;
- privacy, hardware, overage, or plan requirements change.

Primary references:

- [GitHub models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing)
- [GitHub individual AI-credit billing](https://docs.github.com/en/copilot/concepts/billing/usage-based-billing-for-individuals)
- [GitHub supported models](https://docs.github.com/en/copilot/reference/ai-models/supported-models)
- [GitHub Auto model selection](https://docs.github.com/en/copilot/concepts/models/auto-model-selection)
- [GitHub AI-usage optimization](https://docs.github.com/en/copilot/tutorials/optimize-ai-usage)
- [GitHub `/fleet`](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/fleet)
- [Chronicle cost profile](./chronicle-cost-tips.md)
- [LLM cache strategy](./llm-cache.md)
- [Sandcastle source](https://github.com/mattpocock/sandcastle)
- [Ollama GPU support](https://docs.ollama.com/gpu)
