# Final cost-effective LLM strategy

<!-- markdownlint-configure-file { "MD013": { "tables": false } } -->

**Status:** Consolidated strategy  
**Synthesis date:** 2026-07-23  
**Updated:** 2026-07-24 with personalized Chronicle usage evidence  
**Review by:** 2026-08-25, before Claude Sonnet 5 promotional pricing ends  
**Inputs:** [Claude Sonnet 5 research](./llm-cost-strategy-by-sonnet-5.md)
and [GPT-5.6 Sol research](./llm-cost-strategy-by-gpt-5-6-sol.md)  
**Empirical input:** [Chronicle cost profile](./chronicle-cost-tips.md)

This document reconciles the two independent research reports. The original
reports remain immutable evidence snapshots. This strategy is the current
decision layer. Personalized Chronicle data adds a bounded view of actual recent
usage; use this strategy until a refresh trigger in this document is reached.

## Executive strategy

1. **Optimize accepted work per AI credit, not model price in isolation.**
   Copilot Max is already a $100 monthly commitment with 20,000 included AI
   credits. The practical objective is to maximize verified, accepted changes
   inside that allowance while avoiding retries, duplicated context, and
   overages.
2. **Use deterministic tools before any model.** Compilers, tests, analyzers,
   linters, formatters, and security scans are the cheapest reliable reviewers.
3. **Treat input context as a first-order cost driver.** Recent measured usage
   was 130:1 input to output tokens, with 92.3% of measured tokens concentrated
   in six sessions. Stage broad research, keep phase inputs narrow, and optimize
   the high-consumption tail first.
4. **Use Auto or GPT-5 mini for routine interactive work.** Auto receives a 10%
   discount and preserves cache boundaries. Manual selection is preferable in
   measured batch workflows where predictability matters.
5. **Use Claude Sonnet 5 for consequential planning while its promotion lasts.**
   Re-evaluate before 2026-08-31. Do not assume it remains the best value after
   the price changes.
6. **Use GPT-5 mini as the baseline implementation model.** Promote Kimi K2.7
   Code, GPT-5.4 mini, or MAI-Code-1-Flash for scoped agentic work only when
   repository telemetry shows fewer retries or lower total credits per accepted
   result.
7. **Use GPT-5.3-Codex or Sonnet 5 for complex multi-file implementation and
   substantive review.** Reserve Opus 4.6 for unresolved, exceptional-risk work.
8. **Treat Luna, Terra, and Raptor as qualification candidates, not universal
   defaults.** Their current price or positioning is attractive, but public
   evidence or client availability is incomplete.
9. **Use one agent by default.** Use `/fleet` for two or three genuinely
   independent, interactive slices. Use Sandcastle for durable, isolated,
   issue-sized batch work. Never nest both parallelism layers.
10. **Keep local Ollama as a scoped privacy/offline fallback.** On the current
   laptop, 7B-9B models can assist with small tasks but cannot economically
   replace cloud agents for repository-scale coding.
11. **Do not buy hardware yet.** Measure 30 days of usage first. If privacy,
   overages, or a plan downgrade creates a real return, a used RTX 3090 24 GB
   system is the value path.

## 1. How the two reports were reconciled

### Evidence policy

The final decision order is:

1. Current GitHub billing, availability, and product documentation.
2. Provider model cards and first-party source code.
3. Reproducible benchmark methodology and comparable raw results.
4. Aggregated or vendor-reported benchmarks as qualification signals only.
5. Inference, always labelled and paired with a measurement gate.

No available benchmark compares all candidate models under one current,
repository-representative agent harness. Exact universal rankings would
therefore imply precision the evidence does not support.

### Agreement and disagreement matrix

| Topic | Sonnet 5 report | GPT-5.6 Sol report | Final decision |
| --- | --- | --- | --- |
| Billing | Max is a fixed $100 allowance with 20,000 credits | Max uses token-priced AI credits; allowance is sunk until overage | Measure accepted work per credit and treat overage or downgrade as the cash lever |
| Planning | Sonnet 5 is the best current premium value | Sonnet 5 is the best supported strong-plan value during promotion | Use Sonnet 5 for consequential plans until the promotion is re-evaluated |
| Routine implementation | Luna is the preferred cheap agentic model | GPT-5 mini is the verified baseline; Kimi/GPT-5.4 mini/MAI are scoped candidates | Start with GPT-5 mini; qualify Kimi, GPT-5.4 mini, MAI, and Luna against it |
| Terra | Better than GPT-5.4 at equal cost based on aggregate benchmarks | Public card is unavailable; treat as an unproven GPT-5.4 peer | Do not claim dominance; use Terra only when telemetry beats the current route |
| Raptor mini | Not usable in CLI/Sandcastle workflows | Same low price as GPT-5 mini but no public card | Treat as Chat-only for this workflow unless `copilot model list` proves the target client supports it |
| Review | Use Haiku as a different-family reviewer | Use a cheap first pass, then Codex or Sonnet 5 for substantive review | Cross-family cheap review first; strong independent review only for risk or unresolved findings |
| Sandcastle and `/fleet` | Complementary batch and interactive orchestrators | One agent is cheapest; Sandcastle is an isolation escalation | Keep both, but make one agent the default and require a concrete parallelism or isolation benefit |
| Local inference | Qwen 7B is the mature fallback; local is not the main cost lever | Ornith 9B and Qwen 7B are viable only for tightly scoped work | Use Qwen 7B as the baseline and Ornith 9B as a challenger; never trust vendor scores without local qualification |
| Hardware | Used RTX 3090 is the best value upgrade | No purchase until the ROI denominator is positive | Measure first; buy a 3090-class system only after an explicit financial or privacy gate |
| Routing artifact | Use dated tier aliases and Sandcastle constants | Suggested a router skill and telemetry artifacts | Do not spend tokens on an LLM router; use Auto, deterministic policy, orchestration config, and telemetry |

### Important source-quality resolution

The Sonnet 5 report contributes valuable repository-specific analysis,
Sandcastle phase mapping, skill-coverage gaps, and the Raptor client caveat. Its
precise cross-model benchmark percentages rely heavily on aggregators and mixed
harnesses, so this strategy does not use those numbers to declare winners.

The GPT-5.6 Sol report contributes a primary-source-first evidence policy,
current pricing, explicit uncertainty for undocumented models, local memory
analysis, and a hardware break-even model. Its conservative treatment of Luna
and Terra is retained until repository telemetry supplies comparable evidence.

The Chronicle profile contributes exact usage totals for 14 recent sessions and
high-confidence concentration patterns. Its explanations based on message size
and file churn are correlational, so this strategy uses them to prioritize
experiments rather than to label individual sessions as wasteful.

Current GitHub documentation confirms the billing model, recommends matching
model capability to task complexity, recommends cheaper subagent models, and
warns that switching models mid-session invalidates cache
([GitHub usage optimization](https://docs.github.com/en/copilot/tutorials/optimize-ai-usage)).

## 2. Cost model and operating objective

### Current Copilot Max economics

For current individual plans:

- Copilot Max costs $100 per month.
- It includes 10,000 base credits and a 10,000-credit flex allotment.
- One AI credit represents $0.01 of model usage.
- Included credits do not roll over.
- Additional usage draws from a user-configured dollar budget.
- Paid code completions and next-edit suggestions do not consume AI credits.
- Auto model selection receives a 10% model-cost discount.

Sources:
[GitHub individual billing](https://docs.github.com/en/copilot/concepts/billing/usage-based-billing-for-individuals),
[GitHub pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing),
and [GitHub Auto selection](https://docs.github.com/en/copilot/concepts/models/auto-model-selection).

Premium-request multipliers are relevant only to grandfathered annual Pro and
Pro+ request-based plans, not the current Max strategy.

### Measure effective cost

The useful unit is not price per prompt. Track:

```text
effective task cost =
  model AI credits
  + retry credits
  + duplicated parent/worker context
  + validation and review credits
  + valued human waiting and repair time
```

A model that costs twice as much per token can still be cheaper if it prevents
several failed attempts. Conversely, a strong model is wasteful when a
deterministic tool or lightweight model would pass the same acceptance test.

### Observed session cost profile

The personalized Chronicle analysis covered the last 14 days, discovered 80
recent candidate sessions, and had exact usage for 14 of them
([Chronicle cost profile](./chronicle-cost-tips.md)):

- 148.6 million measured tokens across about 1,700 usage rows;
- 147.4 million input tokens versus 1.1 million output tokens, about 130:1;
- 137.1 million tokens, or 92.3%, concentrated in the six largest sessions;
- 58.9 million tokens, or 39.6%, in the single largest measured session;
- 92.8 million tokens, or 62.5%, attributed to `gpt-5.6-sol`;
- late-turn average inputs reaching about 142K-144K in two long sessions.

Raw input includes cheaper cached reads, so token volume is not identical to AI
credit cost. The profile nevertheless establishes three priorities:

1. Optimize the few largest sessions before tuning every small interaction.
2. Track fresh input separately from cached input before attributing cost.
3. Move bounded reading, search, formatting, and summary phases to lighter
   models in **fresh phase sessions**, not by switching a cache-hot session.

The largest session involved broad legitimate research, large messages, and 52
files. Treat that as a staging opportunity, not proof of waste: inventory first,
select the questions and files that matter, then open a focused follow-up session
with only those inputs.

### Current shortlist pricing

Prices are Copilot dollars per one million input, cached-input, and output
tokens. Anthropic cache-write prices are omitted from the compact table but must
be included in detailed estimates
([GitHub pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing)).

| Model | Input | Cached input | Output | Strategy role |
| --- | ---: | ---: | ---: | --- |
| GPT-5.4 nano | $0.20 | $0.02 | $1.25 | Mechanical transformations with hard validation |
| GPT-5 mini | $0.25 | $0.025 | $2.00 | Routine baseline |
| Raptor mini | $0.25 | $0.025 | $2.00 | Chat-surface experiment only |
| Gemini 3 Flash | $0.50 | $0.05 | $3.00 | Lightweight preview challenger |
| GPT-5.4 mini | $0.75 | $0.075 | $4.50 | Codebase exploration and scoped agent work |
| MAI-Code-1-Flash | $0.75 | $0.075 | $4.50 | General coding challenger |
| Kimi K2.7 Code | $0.95 | $0.19 | $4.00 | Scoped implementation challenger |
| Claude Haiku 4.5 | $1.00 | $0.10 | $5.00 | Fast cross-family review |
| GPT-5.6 Luna | $1.00 | $0.10 | $6.00 | Undocumented lightweight challenger |
| GPT-5.3-Codex | $1.75 | $0.175 | $14.00 | Complex agentic implementation |
| Claude Sonnet 5 | $2.00 | $0.20 | $10.00 | Consequential planning during promotion |
| Gemini 3.1 Pro | $2.00 | $0.20 | $12.00 | Long-evidence or multimodal reasoning |
| GPT-5.4 | $2.50 | $0.25 | $15.00 | Deep general reasoning |
| GPT-5.6 Terra | $2.50 | $0.25 | $15.00 | Balanced challenger without a public card |
| Claude Sonnet 4.6 | $3.00 | $0.30 | $15.00 | Generally dominated by current Sonnet 5 pricing |
| Claude Opus 4.6 | $5.00 | $0.50 | $25.00 | Exceptional escalation only |

Claude Sonnet 5's listed promotion ends on 2026-08-31. Some models also use
higher long-context rates after documented input thresholds.

## 3. Final role rankings

These are routing tiers, not a claim that every model in one tier always beats
every model below it.

### Planning routes

| Plan type | Default | Alternatives | Escalation |
| --- | --- | --- | --- |
| Routine, architecture already decided | Auto or GPT-5 mini | GPT-5.4 mini | Sonnet 5 if assumptions remain unresolved |
| Consequential feature or migration | Claude Sonnet 5 | Gemini 3.1 Pro, GPT-5.4, Terra | Opus 4.6 only after independent plan review fails |
| Security, concurrency, destructive data work | Sonnet 5 plus independent review | GPT-5.4 or Gemini 3.1 Pro | Opus 4.6 for unresolved high-impact ambiguity |
| Foggy program of work | `/wayfinder` using a strong model | Research tickets on cheaper models | Human decision before implementation |

**Planning ranking:** Sonnet 5 is the current cost-quality default for
consequential plans. GPT-5 mini is the routine default. Opus 4.6 is not a normal
planning tier.

### Implementation routes

| Implementation type | Default | Qualified challengers | Escalation |
| --- | --- | --- | --- |
| Formatting, renames, generated scaffolds | Deterministic tool, then Nano or local | GPT-5 mini | Any scope drift or failed acceptance test |
| Small C#/TypeScript/PowerShell change | GPT-5 mini | Gemini 3 Flash, MAI | One failed repair or unclear requirement |
| Codebase exploration | GPT-5.4 mini | GPT-5 mini with an evidence pack | Missing dependencies or excessive context |
| Well-scoped multi-file feature | Kimi K2.7 Code or GPT-5.4 mini after qualification | MAI, Luna | Repeated tool failure or cross-layer inconsistency |
| Long-running or difficult agentic change | GPT-5.3-Codex | Sonnet 5 | Failed validation, unsafe action, or unresolved architecture |

**Implementation ranking:** GPT-5 mini is the baseline, not necessarily the
permanent winner. Kimi K2.7 Code and GPT-5.4 mini are the first candidates to
promote for scoped agentic work. Luna is a measured challenger because GitHub
positions it as lightweight and cost-efficient but does not publish a model
card.

### Review routes

1. Run deterministic checks before model review.
2. Use a cheap reviewer from a different provider family than the implementer.
3. Escalate only unresolved or high-risk findings to GPT-5.3-Codex or Sonnet 5.
4. Use GPT-5.4, Gemini 3.1 Pro, Terra, or Opus only when the risk and evidence
   justify their cost.

Recommended pairings:

| Implementer | Routine reviewer | Substantive reviewer |
| --- | --- | --- |
| GPT/OpenAI family | Claude Haiku 4.5 or Kimi K2.7 Code | Claude Sonnet 5 |
| Claude family | GPT-5 mini or Kimi K2.7 Code | GPT-5.3-Codex |
| Kimi or MAI | GPT-5 mini or Claude Haiku 4.5 | Sonnet 5 or GPT-5.3-Codex |
| Local model | GPT-5 mini | Sonnet 5 or GPT-5.3-Codex for high-risk diffs |

Do not use Nano for semantic, concurrency, authorization, cryptography, or
data-loss review. Built-in Copilot code review remains less cost-predictable
because GitHub does not disclose the selected model.

## 4. Routing and escalation protocol

### Capability gate

A model cannot enter a task lane unless it:

- is available in the intended client or orchestrator;
- supports the required tools, image input, context, and reasoning controls;
- can operate within the session credit cap;
- passes the task lane's quality and safety floors;
- has acceptable variance across repeated representative tasks.

This gate resolves the Raptor disagreement. GitHub lists Raptor as a supported
model and a general-purpose coding option, but current client tables do not make
it a reliable CLI/Sandcastle assignment. Treat it as Chat-only for this workflow
until the target client's `copilot model list` confirms otherwise
([GitHub supported models](https://docs.github.com/en/copilot/reference/ai-models/supported-models)).

### Default decision sequence

1. Bound the request to a named question list, file set, or evidence inventory.
2. Run deterministic discovery and validation first.
3. Classify the task by risk, ambiguity, context size, and reversibility.
4. Select the cheapest model that has passed the lane's capability gate.
5. Fix the model, reasoning level, context size, and tool set for that session.
6. Set a session AI-credit limit.
7. Execute against an explicit acceptance command or observable outcome.
8. At a major milestone, inspect `/context` and decide whether to finish,
   compact once, or hand off an artifact to a fresh phase session.
9. Start a new focused session when changing task, phase, model, reasoning, or
   tool set so the new session begins with intentionally small context.

### Context and compaction protocol

Use a **fresh session** when:

- the task or phase changes;
- a different model or reasoning level is appropriate;
- broad research has produced a focused specification or evidence pack;
- the previous session's exact conversation is no longer needed.

Use `/compact` once when all of these are true:

- the same investigation must continue;
- a major milestone has completed;
- several substantive turns remain;
- current context is approaching roughly 100K tokens or has grown materially;
- an exact verbatim history is less valuable than a focused summary.

The 100K value is an initial telemetry trigger derived from the observed
142K-144K late-turn averages, not a universal product limit. Compaction resets
the prompt cache once, so do not compact near completion or repeatedly. If exact
details matter, write them to a cited artifact and start a fresh session instead.

Run `/chronicle cost-tips` after a major work wave or monthly. Compare the new
profile with this baseline rather than treating one 14-session sample as a
permanent user profile.

### Hard escalation triggers

Escalate one tier when any trigger applies:

- Two cheaper attempts fail the same deterministic acceptance test.
- Requirements remain ambiguous after one clarification or evidence pass.
- Authentication, authorization, cryptography, concurrency, or destructive
  migration is involved.
- The change crosses three or more architectural layers without an approved
  specification.
- The model cannot cite the current API/version for Microsoft 365, SharePoint,
  Power Platform, or another volatile service.
- The expected credits of another retry exceed one stronger-model pass.
- The agent claims success without reproducible validation.

### Downgrade triggers

Move a task down one tier when:

- an approved specification removes architectural uncertainty;
- the remaining work is a vertical slice with exact file ownership;
- deterministic tests fully define success;
- an evidence pack provides the required API versions and examples;
- the task has repeated successfully under the cheaper model.

## 5. Orchestration strategy

### One agent is the default

One focused agent has the lowest context duplication, reconciliation cost, and
merge risk. Use it for coherent changes that fit one context and one ownership
boundary.

### Use `/fleet` for interactive parallel slices

Use `/fleet` when:

- there are two or three independent slices;
- each slice has explicit file or directory ownership;
- the parent has an approved plan and acceptance criteria;
- elapsed time matters enough to justify extra model interactions.

GitHub states that subagents have separate context windows, use a low-cost model
by default, and may consume more AI credits because each worker interacts with
the model independently
([GitHub fleet documentation](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/fleet)).

Default worker cap: **two**. Raise to three only when measured conflict and
credit rates remain acceptable.

### Use Sandcastle for isolated durable batch work

Use Sandcastle when:

- tasks are issue-sized and can complete in independent worktrees or sandboxes;
- filesystem and branch isolation materially reduce risk;
- execution is long-running or unattended;
- provider, model, lifecycle hook, branch, and retry control are required;
- a backlog justifies setup and merge overhead.

Sandcastle is a programmable TypeScript orchestration substrate, not a fixed
cost-saving algorithm. The repository example can use a planner, one implementer
and reviewer per task, and a merger. For `N` successful tasks, that topology
creates roughly `2N + 2` model sessions per outer iteration before retries
([Sandcastle example](https://github.com/mattpocock/sandcastle/blob/e99f832f26dc9d245c019a9ddd19fa5dee792427/.sandcastle/run.ts)).

### Never nest parallelism

Do not:

- run `/fleet` inside each Sandcastle worker;
- launch multiple Sandcastle swarms from a `/fleet` parent;
- parallelize tasks with overlapping file ownership;
- increase concurrency merely because it reduces wall-clock time.

Concurrency reduces elapsed time. It does not reduce total model work.

### Sandcastle phase defaults

Do not hard-code these assignments permanently. Treat them as the first
qualification profile:

| Phase | Initial assignment | Alternative | Escalation |
| --- | --- | --- | --- |
| Plan | Claude Sonnet 5 | GPT-5.4 or Terra after qualification | Opus 4.6 only for unresolved exceptional risk |
| Implement | GPT-5 mini baseline; Kimi or GPT-5.4 mini after qualification | MAI or Luna challenger | GPT-5.3-Codex |
| Review | Haiku 4.5 when implementer is GPT/Kimi/MAI | GPT-5 mini when implementer is Claude | Sonnet 5 or GPT-5.3-Codex |
| Merge | GPT-5 mini or GPT-5.4 mini | Kimi or MAI | Sonnet 5 for semantic cross-branch conflicts |

Every Sandcastle run should set:

- a total credit budget;
- per-worker retry and iteration limits;
- a default concurrency cap of two;
- deterministic validation before review;
- an explicit stop condition for the outer loop.

## 6. Matt Pocock skills workflow

The skills produce decision artifacts; `/fleet` or Sandcastle executes them.
Use the expensive reasoning only at the low-volume leverage points.

| Phase | Use when | Model tier |
| --- | --- | --- |
| `/wayfinder` | Work is too large or foggy for one specification | Strong planning model |
| `/grill-with-docs` | Missing requirements would cause rework | Strong model with the maintainer in the loop |
| `/research` | A blocking factual question needs primary sources | Cheapest model that can synthesize citations reliably |
| `/to-spec` | Decisions are known and need one implementation contract | Strong planning model |
| `/to-tickets` | The specification needs vertical, dependency-aware slices | Strong model for one low-volume decomposition pass |
| Implement | Ticket has exact ownership and acceptance criteria | Cheapest qualified implementation model |
| Review | Diff needs independent defect detection | Different-family cheap reviewer, then strong escalation |

Use `/wayfinder` only for genuinely foggy work. Skip interviews when a complete
specification already exists. Start a fresh session between research, planning,
implementation, and review so each phase carries only the context it needs
([GitHub phase guidance](https://docs.github.com/en/copilot/tutorials/optimize-ai-usage#6-research-plan-then-implement)).

The phase boundary is also the model boundary. A strong model should produce a
compact decision artifact; a new lighter-model session should consume that
artifact for bounded exploration or implementation. Do not switch models inside
the original long session merely to save the next call.

## 7. Local Ollama strategy

### Current hardware verdict

The i7-8750H has six cores, twelve threads, and 41.8 GB/s specified maximum
memory bandwidth
([Intel specifications](https://www.intel.com/content/www/us/en/products/sku/134906/intel-core-i78750h-processor-9m-cache-up-to-4-10-ghz/specifications.html)).
Ollama supports the Quadro P1000's compute capability with a sufficiently
recent NVIDIA driver, but 4 GB VRAM cannot fully hold the recommended 7B-9B
artifacts plus runtime and display memory
([Ollama GPU support](https://docs.ollama.com/gpu)).

The machine can load larger models into 32 GB system RAM, but loading is not the
same as useful interactive agent performance. Partial GPU offload and limited
memory bandwidth make 30B-35B models poor everyday choices.

### Local model lanes

| Lane | Model | Context | Use |
| --- | --- | ---: | --- |
| Mature baseline | `qwen2.5-coder:7b`, Q4_K_M or Q5_K_M | 8K-16K | Small functions, transformations, test skeletons |
| Challenger | `ornith:9b`, Q4-Q5 equivalent | 8K initially | Same tasks after local qualification |
| Occasional batch | Qwen2.5-Coder 14B Q4_K_M | 8K | Fire-and-wait work where latency is acceptable |
| Fast router | 3B Q5-Q8 | 4K-8K | Classification, extraction, and file triage |
| Experimental only | Qwen3-Coder 30B-A3B Q4 | 8K | One-off evaluation, not routine agents |
| Excluded default | Dense 32B and Ornith 35B | Any | Too slow or memory-constrained on this laptop |

Ornith's quality results are publisher-reported and should not displace the
Qwen baseline without a local, repeated comparison. Use
`OLLAMA_NUM_PARALLEL=1`; parallel requests multiply context memory
([Ollama concurrency guidance](https://docs.ollama.com/faq#how-does-ollama-handle-concurrent-requests)).

Ollama defaults systems under 24 GiB VRAM to 4K context, while its coding-agent
guidance recommends at least 64K. The recommended 8K-16K compromise is therefore
for scoped tasks, not repository-scale autonomy
([Ollama context guidance](https://docs.ollama.com/context-length)).

### Local qualification gate

Promote a local model only if it:

- passes at least 90% of the GPT-5-mini accepted-result rate on representative
  MartiX tasks;
- has no safety-floor regression;
- completes three repeated runs per task with acceptable variance;
- stays within an agreed latency threshold;
- produces changes that pass the same deterministic validation.

Local inference is valuable for privacy, offline operation, unlimited
experimentation, and low-risk preprocessing. It is not currently the primary
cash-saving lever while Max remains subscribed and within its allowance.

## 8. Hardware upgrade decision

### Default decision: do not purchase

Run a 30-day measurement period on the existing laptop and Copilot Max. Record:

- monthly included credits consumed and overage;
- accepted results by model and task lane;
- retry count and cost;
- wall time and human repair time;
- number of tasks that could not use cloud services;
- local throughput and acceptance rate.

### Break-even test

Use:

```text
break-even months =
  hardware cost /
  (monthly overage avoided
   + monthly plan-downgrade saving
   + measured productivity value
   - incremental electricity
   - maintenance and opportunity cost)
```

If the denominator is zero or negative, the hardware has no dollar break-even.
Keeping Max with no overage normally makes a local workstation an additional
cost, not a saving.

### Purchase gates

Consider an upgrade only if at least one gate is true:

- privacy or offline requirements have independent business value;
- sustained overages create a credible break-even;
- local quality permits a Max-to-Pro+ or Max-to-Pro downgrade;
- measured waiting time on the current laptop has material productivity cost;
- a representative local benchmark meets the quality and safety floors.

### Configuration after the gate

#### Value 7B-14B workstation

- Used RTX 3090 24 GB
- 64 GB system RAM
- Modern 8-12 core CPU
- 2 TB NVMe
- Quality 1000 W power supply and adequate cooling

#### Comfortable 32B workstation

- Prefer 32-48 GB total VRAM
- 96-128 GB system RAM
- 2-4 TB NVMe
- Single high-VRAM GPU where practical
- Dual used 3090s only when power, cooling, and multi-GPU complexity are
  acceptable

The used RTX 3090 is the value recommendation **after** the purchase gate, not a
claim that it will pay for itself under the current subscription.

## 9. MartiX skills and supporting artifacts

### Skill coverage effect

MartiX skills can reduce discovery, unsupported API use, and retries for .NET,
C#, FastEndpoints, FluentValidation, TUnit, PowerShell, TypeScript, Fluent UI,
and SharePoint work. This is a reason to benchmark cheaper models with the
skills enabled rather than importing generic leaderboard rankings directly.

Potential domain investments, only if recurring work justifies them:

1. Power Platform and Power Automate evidence-backed skill.
2. Blazor-specific lifecycle, render-mode, and interop guidance.
3. Vue-specific conventions and versioned framework evidence.

Power Platform is the highest-priority gap because its APIs and low-code
behavior are volatile and less reliably represented by generic coding data.

### Recommended artifacts

| Artifact | Purpose | Acceptance criterion |
| --- | --- | --- |
| AI-credit telemetry | Record model, phase, credits, fresh input, cached input, late-context size, compaction, retries, outcome, and wall time | At least 95% of measured sessions attributable to a task and model |
| Evidence-pack generator | Provide file map, errors, API versions, constraints, and acceptance commands | At least 25% fresh-input reduction without pass-rate loss |
| Fleet/Sandcastle budget guard | Enforce worker, retry, iteration, and total-credit caps | Default worker cap two and zero nested parallelism |
| Model qualification suite | Compare representative .NET, front-end, PowerShell, SharePoint, and M365 tasks | Three repeats per task; quality, safety, variance, cost, and latency reported |
| Cross-family review workflow | Route cheap independent review before strong escalation | Expensive review limited to high-risk or unresolved diffs without critical-defect recall loss |
| Versioned model alias map | Keep volatile model identifiers outside reusable skill logic | Has an owner, evidence date, review date, and client-availability field |
| Local qualification pack | Compare Qwen, Ornith, and cloud baseline under identical tests | Local promotion only at 90% or more of GPT-5-mini acceptance with no safety regression |

Do not create an LLM-powered model-router skill. GitHub Auto already provides a
discounted product router, while reusable skills cannot reliably force the
parent model. Model selection belongs in:

- Auto for ordinary interactive work;
- human or orchestrator configuration for measured batch work;
- a dated alias map for volatile identifiers;
- telemetry and deterministic gates for promotion decisions.

## 10. Thirty-day rollout

### Week 1: Establish the baseline

1. Enable AI-credit session limits.
2. Record GPT-5 mini, Auto, Sonnet 5, and current Sandcastle costs.
3. Define representative tasks and deterministic acceptance commands.
4. Capture current source-report hashes and leave both snapshots unchanged.
5. Preserve the Chronicle baseline: 148.6M measured tokens, 92.3% in the top six
   sessions, and 62.5% on `gpt-5.6-sol`.

### Week 2: Qualify economical challengers

1. Compare GPT-5 mini against Kimi K2.7 Code, GPT-5.4 mini, MAI, and Luna.
2. Run at least three repeats per representative task.
3. Compare accepted-result rate, credits, retries, variance, and wall time.
4. Test Raptor only on a client where it is explicitly available.
5. Compare one broad research session with a staged inventory plus focused
   follow-up using the same acceptance criteria.

### Week 3: Tune orchestration

1. Set one-agent execution as the control.
2. Compare `/fleet` with two independent workers.
3. Run one bounded Sandcastle batch with the proposed phase split.
4. Reject any configuration that reduces wall time but raises effective task
   cost without a justified throughput benefit.

### Week 4: Decide

1. Promote only models that clear capability, quality, safety, and variance
   gates.
2. Freeze a dated model alias map for the next evaluation wave.
3. Recalculate the hardware break-even denominator.
4. Refresh the Sonnet 5 planning route before its promotion expires.

## 11. Refresh triggers

Refresh this strategy when any trigger occurs:

- Claude Sonnet 5 pricing changes on or before 2026-08-31.
- GitHub changes model prices, Max allowances, Auto behavior, or client
  availability.
- A model is added, retired, or receives a public model card.
- A representative qualification wave changes cost per accepted result by 20%
  or more.
- Sandcastle or `/fleet` changes isolation, billing, concurrency, or model
  selection behavior.
- The repository's routing and execution-profile documentation is refactored.
- Hardware, privacy requirements, or cloud-usage policy changes.
- A new Chronicle sample materially changes strong-model concentration,
  high-session concentration, or late-context growth.

Keep the two model-authored reports as immutable snapshots. Add errata to this
strategy or replace it with a new dated synthesis; do not rewrite the original
evidence records.

## 12. Primary references

- [GitHub Copilot models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing)
- [GitHub individual AI-credit billing](https://docs.github.com/en/copilot/concepts/billing/usage-based-billing-for-individuals)
- [GitHub supported models and client availability](https://docs.github.com/en/copilot/reference/ai-models/supported-models)
- [GitHub model comparison](https://docs.github.com/en/copilot/reference/ai-models/model-comparison)
- [GitHub Auto model selection](https://docs.github.com/en/copilot/concepts/models/auto-model-selection)
- [GitHub AI-usage optimization](https://docs.github.com/en/copilot/tutorials/optimize-ai-usage)
- [GitHub `/fleet` documentation](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/fleet)
- [Personalized Chronicle cost profile](./chronicle-cost-tips.md)
- [Repository cache and session guidance](./llm-cache.md)
- [Matt Pocock Sandcastle source](https://github.com/mattpocock/sandcastle/tree/e99f832f26dc9d245c019a9ddd19fa5dee792427)
- [Matt Pocock engineering skills](https://github.com/mattpocock/skills/tree/ed37663cc5fbef691ddfecd080dff42f7e7e350d/skills/engineering)
- [Ollama GPU support](https://docs.ollama.com/gpu)
- [Ollama context guidance](https://docs.ollama.com/context-length)
- [Ollama runtime FAQ](https://docs.ollama.com/faq)
- [Intel i7-8750H specifications](https://www.intel.com/content/www/us/en/products/sku/134906/intel-core-i78750h-processor-9m-cache-up-to-4-10-ghz/specifications.html)
- [GPT-5.3-Codex system card](https://deploymentsafety.openai.com/gpt-5-3-codex)
- [Claude Sonnet 5 announcement](https://www.anthropic.com/news/claude-sonnet-5)
- [Kimi K2.7 Code model card](https://huggingface.co/moonshotai/Kimi-K2.7-Code)
- [MAI-Code-1-Flash model information](https://microsoft.ai/models/mai-code-1-flash/)
