# Optimize LLM selection for a cost-effective coding workflow

<!-- markdownlint-configure-file { "MD013": { "tables": false } } -->

**Evidence cut-off and retrieval date:** 2026-07-23

## Executive recommendation

1. **Do not buy hardware yet.** Copilot Max's $100 subscription is a sunk
   monthly cost and currently includes 20,000 AI credits. Local hardware creates
   cash savings only if it enables a plan downgrade, avoids sustained overages,
   or provides separately valued privacy/offline benefits.
2. **Routine default:** manually select **GPT-5 mini** or trial **Raptor mini**
   with a session credit cap. Use **Auto** when convenience and its 10% discount
   outweigh the loss of routing predictability.
3. **Scoped implementation:** prefer **Kimi K2.7 Code**, **GPT-5.4 mini**, or
   **MAI-Code-1-Flash**. Kimi has the strongest published agentic evidence among
   these similarly priced options; any MAI advantage for the Microsoft stack is
   plausible but currently unverified.
4. **Non-trivial planning:** use **Claude Sonnet 5** while its Copilot
   promotional rate lasts. It is substantially cheaper than Opus 4.6, and
   Anthropic describes it as a strict improvement over Sonnet 4.6 that approaches
   newer Opus performance. Alternatives are Gemini 3.1 Pro and GPT-5.4/Terra.
5. **Complex implementation or deep review:** escalate to **GPT-5.3-Codex** or
   **Sonnet 5**. Use **Opus 4.6 only after a cheaper strong model fails**; it is
   economically dominated for most work.
6. **Concurrency:** use one orchestrator and no more than two or three genuinely
   independent `/fleet` workers. Never nest `/fleet` inside parallel Sandcastle
   jobs.
7. **Sandcastle is an escalation substrate**, not the economical default. Its
   isolation and programmable branches are valuable for risky or long-running
   work, but its sample planner-implementer-reviewer-merger workflow can multiply
   model sessions rapidly.
8. **Local default:** test `ornith:9b` and `qwen2.5-coder:7b` at approximately
   Q4-Q5 quality, one request at a time, with 8K-16K context. Treat 14B as
   occasional; do not use 30B-35B models as the normal agent on the existing
   laptop.

---

## 1. Methodology and evidence grading

### Evidence labels

- **Verified:** current GitHub billing, availability, hardware specification, or
  source-code behavior.
- **Benchmark:** measured result, always labelled with its owner and harness.
- **Inference:** routing or performance conclusion derived from verified facts.
- **Unknown:** no public card, comparable benchmark, or disclosed
  implementation.

All 17 model names supplied for evaluation appear in GitHub's current
supported-model catalog; they are not merely unverified UI strings. However,
GitHub provides no further-reading model card for GPT-5.6 Luna/Terra,
Gemini 3.1 Pro, Gemini 3.6 Flash, or Raptor mini
([supported models](https://docs.github.com/en/copilot/reference/ai-models/supported-models),
[model comparison](https://docs.github.com/en/copilot/reference/ai-models/model-comparison)).

### Benchmark limitation

The official LiveBench repository explains its objective, ground-truth scoring,
and contamination-mitigation design, but the checked source identifies
2025-04-25 as its current release and does not contain comparable results for
most 2026 models
([LiveBench README, lines 19-34](https://github.com/LiveBench/LiveBench/blob/4355e9b04222745ccc02a2661d1deebe767a85a2/README.md#L19-L34),
[lines 67-77](https://github.com/LiveBench/LiveBench/blob/4355e9b04222745ccc02a2661d1deebe767a85a2/README.md#L67-L77)).
Its dynamic site did not expose auditable current raw rows during this pass.

SWE-bench Verified offers a useful "bash only" mini-SWE-agent view, but warns
that harness releases are not necessarily comparable
([SWE-bench Verified methodology](https://www.swebench.com/verified.html)).
Exact cross-model quality ordering would therefore be false precision. This
report uses role tiers, current Copilot cost, first-party evidence, and explicit
uncertainty. Aggregators such as Artificial Analysis, llm-stats, BenchLM, and
whatllm are appropriate discovery or secondary cross-check sources, but they are
not the basis of the rankings below.

---

## 2. Current Copilot economics

### Max uses AI credits, not premium-request multipliers

On **June 1, 2026**, GitHub replaced request billing with token-based AI credits
for current individual plans. Copilot Max costs **$100/month** and includes:

- 10,000 base credits
- 10,000 flex credits
- **20,000 total monthly credits**
- 1 AI credit = **$0.01**

These are GitHub Copilot billing rates, not external provider API prices
([usage-based billing](https://docs.github.com/en/copilot/concepts/billing/usage-based-billing-for-individuals),
[plans](https://docs.github.com/en/copilot/get-started/plans)).

Unused credits do not roll over. Extra usage draws from the user's dollar budget
at $0.01 per credit. Paid code completions and next-edit suggestions remain
unlimited and do not consume AI credits
([models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing)).

Auto model selection receives a **10% discount**, routes at natural cache
boundaries, and avoids mid-session switching because switching invalidates the
previous model's cache
([auto selection](https://docs.github.com/en/copilot/concepts/models/auto-model-selection),
[usage optimization](https://docs.github.com/en/copilot/tutorials/optimize-ai-usage)).

### Legacy annual plans

Premium-request multipliers now apply only to existing annual Pro/Pro+
subscribers who retained legacy billing. Legacy users do not receive new models
and features
([legacy multipliers](https://docs.github.com/en/copilot/reference/copilot-billing/request-based-billing-legacy/model-multipliers-for-annual-plans)).

- Pro: $10, 300 requests/month
- Pro+: $39, 1,500 requests/month
- Additional requests: $0.04 each
- Max has no legacy request tier
  ([legacy requests](https://docs.github.com/en/copilot/reference/copilot-billing/request-based-billing-legacy/copilot-requests))

For legacy agentic use, GitHub says user prompts count while autonomous tool
actions do not. GitHub does not publish a `/fleet`-specific request-count rule.
Under current Max billing, all parent and child token consumption is charged.

### Copilot code review billing

- Legacy built-in code review: fixed **13 premium requests** per review.
- Current billing: token usage plus GitHub Actions minutes; the selected review
  model is undisclosed, making cost less predictable
  ([models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing)).

For cost control, use deterministic checks and a manually selected review model
before invoking built-in PR review.

---

## 3. Model-by-model economics and evidence

Rates below are **current Copilot dollars per million
input/cached-input/output tokens**. The "basket" is one illustrative first turn
with 20K uncached input and 4K output, converted to AI credits. It is not a
quality score. Anthropic cache-write charges are excluded from the basket.

| Model | Copilot rate I/C/O | Basket credits | Legacy multiplier | Evidence and economical role |
| --- | ---: | ---: | ---: | --- |
| Claude Haiku 4.5 | 1 / .10 / 5 | 4.0 | .33x | Anthropic says coding approached Sonnet 4 at more than twice the speed. Strong lightweight implementation/review candidate ([Anthropic](https://www.anthropic.com/news/claude-haiku-4-5)). |
| Claude Opus 4.6 | 5 / .50 / 25 | 20.0 | 27x | Strong planning, debugging, and review; Anthropic reported a Terminal-Bench 2.0 lead at release. Last-resort economics ([Anthropic](https://www.anthropic.com/news/claude-opus-4-6)). |
| Claude Sonnet 4.6 | 3 / .30 / 15 | 12.0 | 9x | First-party Claude Code preference: about 70% over Sonnet 4.5 and 59% over Opus 4.5. Good agent model, but Sonnet 5 currently dominates it ([Anthropic](https://www.anthropic.com/news/claude-sonnet-4-6)). |
| Claude Sonnet 5 | 2 / .20 / 10 | 8.0 | - | Promotional through 2026-08-31. Anthropic calls it a strict improvement over 4.6 and close to Opus 4.8. Best strong-plan value ([Anthropic](https://www.anthropic.com/news/claude-sonnet-5)). |
| Gemini 3 Flash | .50 / .05 / 3 | 2.2 | .33x | Public preview; lightweight/simple-task role. Cheap alternative where GPT-5 mini underperforms. |
| Gemini 3.1 Pro | 2 / .20 / 12 | 8.8 | 6x | Public preview. GitHub highlights edit-test loops and tool precision; Google positions Pro for complex reasoning ([Google](https://deepmind.google/models/gemini/pro/)). |
| Gemini 3.6 Flash | 1.50 / .15 / 7.50 | 6.0 | - | GA, but no public card linked by GitHub. Google positions Flash for token-efficient work; insufficient evidence to prefer it over cheaper Kimi/Haiku ([Google](https://deepmind.google/models/gemini/flash/)). |
| GPT-5 mini | .25 / .025 / 2 | 1.3 | .33x | Best verified low-cost general default. GitHub recommends it for coding, explanations, and interactive debugging. |
| GPT-5.3-Codex | 1.75 / .175 / 14 | 9.1 | 6x | OpenAI describes it as its most capable agentic coding model at release, built for long-running research/tool execution ([OpenAI](https://deploymentsafety.openai.com/gpt-5-3-codex)). |
| GPT-5.4 | 2.50 / .25 / 15 | 11.0 | 6x | General reasoning, architecture, and debugging. Long-context prices rise beyond 272K. |
| GPT-5.4 mini | .75 / .075 / 4.50 | 3.3 | 6x | GitHub recommends it for codebase exploration with grep-style tools. Excellent scoped explorer/implementer under Max, poor legacy economics. |
| GPT-5.4 nano | .20 / .02 / 1.25 | 0.9 | - | Cheapest model. No dedicated public coding evidence; restrict to classification, extraction, and mechanical edits with tests. |
| GPT-5.6 Luna | 1 / .10 / 6 | 4.4 | - | GitHub classifies it as lightweight and cost-efficient; no public OpenAI card. Use only after local telemetry. |
| GPT-5.6 Terra | 2.50 / .25 / 15 | 11.0 | - | GitHub classifies it as balanced general-purpose coding/agent model; no public OpenAI card. Treat as an unproven GPT-5.4 peer. |
| Kimi K2.7 Code | .95 / .19 / 4 | 3.5 | - | Strong value. Moonshot reports improved long-horizon coding and about 30% fewer thinking tokens than K2.6. Its self-reported Kimi Code Bench v2 score is 62.0 ([model card](https://huggingface.co/moonshotai/Kimi-K2.7-Code)). |
| MAI-Code-1-Flash | .75 / .075 / 4.50 | 3.3 | .33x promo | Microsoft positions it for end-to-end coding-task reasoning. GitHub warns checkpoints continuously evolve; no verified .NET-specific advantage ([Microsoft](https://microsoft.ai/models/mai-code-1-flash/)). |
| Raptor mini | .25 / .025 / 2 | 1.3 | .33x | GitHub fine-tuned GPT-5 mini. Same low cost, but its model card is "coming soon"; A/B test against GPT-5 mini rather than assuming superiority. |

Source for all rates, statuses, and long-context tiers:
[GitHub Copilot models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing).
Current long-context rates increase materially for GPT-5.4, Terra, Luna, and
Gemini 3.1 Pro beyond their stated thresholds.

---

## 4. Role-specific rankings

### Planning

#### Tier P1 - routine, already-understood work

1. GPT-5 mini / Raptor mini
2. GPT-5.4 mini
3. Kimi K2.7 Code / MAI-Code-1-Flash
4. Gemini 3 Flash / Haiku 4.5

Use these for file discovery, ticket refinement, and plans whose architecture is
already decided.

#### Tier P2 - recommended for consequential plans

1. **Claude Sonnet 5**
2. Gemini 3.1 Pro
3. GPT-5.4 / GPT-5.6 Terra
4. GPT-5.3-Codex

Sonnet 5 has the best current published strong-model economics. Gemini is
attractive for multimodal UI or very long evidence; GPT-5.4/Terra suit deep
general reasoning.

#### Tier P3 - exceptional escalation

- Claude Opus 4.6

Use only for ambiguous architecture, subtle concurrency, security boundaries,
destructive migrations, or after a P2 plan fails review.

**Niche or dominated:** Nano and Luna are too weak or insufficiently documented
for important planning. Sonnet 4.6 is currently more expensive and older than
Sonnet 5. Gemini 3.6 Flash lacks enough evidence to justify its premium over
Kimi or Haiku.

### Implementation

#### Tier I0 - deterministic/mechanical

- Local 7B-9B
- GPT-5.4 nano
- GPT-5 mini / Raptor mini

Require exact file scope and build/test/lint acceptance.

#### Tier I1 - economical everyday implementation

1. **GPT-5 mini / Raptor mini**
2. Gemini 3 Flash
3. **Kimi K2.7 Code**
4. GPT-5.4 mini / MAI-Code-1-Flash
5. Haiku 4.5
6. Luna or Gemini 3.6 Flash only if telemetry demonstrates fewer total
   tokens/retries

Kimi costs only slightly more than GPT-5.4 mini and has materially better
published agentic evidence.

#### Tier I2 - complex multi-file implementation

1. GPT-5.3-Codex
2. Claude Sonnet 5
3. GPT-5.4 / Terra
4. Gemini 3.1 Pro
5. Sonnet 4.6

Opus 4.6 is reserved for failed or exceptionally risky work.

### Code review

1. **Deterministic checks first:** compiler, analyzers, tests, formatter, and
   dependency/security scans.
2. **Cheap first pass:** GPT-5 mini, Raptor mini, Kimi, or Haiku.
3. **Substantive independent pass:** GPT-5.3-Codex or Sonnet 5, preferably from
   a different provider family than the implementer.
4. **Critical review:** GPT-5.4, Terra, Gemini 3.1 Pro, or Opus 4.6.

Do not use Nano for semantic, concurrency, or security review. Avoid routine
built-in Copilot PR review when predictable cost matters because its model is
undisclosed.

---

## 5. Concrete routing policy

| Work | Initial route | Escalate when |
| --- | --- | --- |
| Formatting, renames, docs, test skeletons | Local 7B-9B or Nano | Build/test failure or scope drift |
| Small C#/TS function or bug | GPT-5 mini/Raptor | One failed repair or uncertain requirements |
| Codebase exploration | GPT-5.4 mini | Missing dependencies or context exceeds focused pack |
| Well-scoped feature | Kimi or MAI | Cross-layer inconsistency or repeated tool failure |
| Front-end visual work | Kimi first; Sonnet 5 or Gemini 3.1 if needed | Screenshot mismatch or poor UX after one pass |
| Architecture/migration plan | Sonnet 5 | Security, concurrency, destructive migration, or unresolved trade-off |
| Long-running agentic implementation | GPT-5.3-Codex | Failed verification or unsafe action |
| Routine review | Different-family GPT-5 mini/Kimi | High-risk finding or conflicting assessments |
| Security/data-loss review | Sonnet 5 or GPT-5.4 | Opus only if unresolved |

### Hard escalation gate

Escalate one tier if any of these applies:

- Two cheap attempts failed the same deterministic acceptance test.
- Authentication, authorization, cryptography, concurrency, or destructive data
  migration is involved.
- The change crosses three or more architectural layers without an approved
  specification.
- The agent cannot cite the relevant API/version or relies on model memory for
  current Microsoft 365/SharePoint behavior.
- The expected cost of another cheap retry exceeds one strong-model pass.
- The diff claims success without reproducible validation.

Start a fresh session when escalating. GitHub warns that changing model or
reasoning effort mid-session invalidates cached context
([usage optimization](https://docs.github.com/en/copilot/tutorials/optimize-ai-usage)).

---

## 6. Orchestration: one agent, `/fleet`, and Sandcastle

### What `/fleet` does

The main Copilot agent decomposes an implementation plan, manages dependencies,
and runs independent subagents in parallel. Subagents default to a low-cost
model, can use custom agent profiles/models, and have separate context windows
([GitHub fleet docs, lines 20-48](https://github.com/github/docs/blob/79ca58cede78e171f80d857fc82c627a3167cd75/content/copilot/concepts/agents/copilot-cli/fleet.md#L20-L48)).

GitHub explicitly warns that each worker performs independent LLM interactions
and may therefore consume more AI credits
([fleet docs, lines 57-67](https://github.com/github/docs/blob/79ca58cede78e171f80d857fc82c627a3167cd75/content/copilot/concepts/agents/copilot-cli/fleet.md#L57-L67)).
Progress can be inspected or individual tasks killed through `/tasks`
([usage docs, lines 35-53](https://github.com/github/docs/blob/79ca58cede78e171f80d857fc82c627a3167cd75/content/copilot/how-tos/copilot-cli/use-copilot-cli/speed-up-task-completion.md#L35-L53)).

### What Sandcastle actually is

Sandcastle 0.12.0 is a TypeScript library/CLI for invoking coding-agent tools in
sandbox providers. Its exports include Docker, Podman, Vercel, Daytona, and
no-sandbox providers, while agent adapters include Claude Code, Codex, Copilot,
Cursor, OpenCode, and Pi
([package.json, lines 1-45](https://github.com/mattpocock/sandcastle/blob/e99f832f26dc9d245c019a9ddd19fa5dee792427/package.json#L1-L45),
[index.ts, lines 1-67](https://github.com/mattpocock/sandcastle/blob/e99f832f26dc9d245c019a9ddd19fa5dee792427/src/index.ts#L1-L67)).

It is **not** a model subscription or fixed orchestration algorithm. The caller
chooses:

- agent/provider and therefore billing source
- model
- concurrency
- branch strategy
- lifecycle hooks
- retry/iteration count
- review and merge topology

The library's `run()` default is one iteration, not ten
([run.ts, lines 50-58](https://github.com/mattpocock/sandcastle/blob/e99f832f26dc9d245c019a9ddd19fa5dee792427/src/run.ts#L50-L58)).

Its repository's own example is much more aggressive: an Opus 4.8 planner
selects work; up to four Opus implementers run concurrently; each successful
worker receives another Opus reviewer; then an Opus merger integrates branches,
inside an outer loop of up to ten iterations
([sample lines 4-39](https://github.com/mattpocock/sandcastle/blob/e99f832f26dc9d245c019a9ddd19fa5dee792427/.sandcastle/run.ts#L4-L39),
[lines 41-101](https://github.com/mattpocock/sandcastle/blob/e99f832f26dc9d245c019a9ddd19fa5dee792427/.sandcastle/run.ts#L41-L101),
[lines 139-159](https://github.com/mattpocock/sandcastle/blob/e99f832f26dc9d245c019a9ddd19fa5dee792427/.sandcastle/run.ts#L139-L159)).

For `N` successful tasks, that example can invoke approximately:

\[
1\ planner + N\ implementers + N\ reviewers + 1\ merger = 2N+2
\]

agent sessions per outer iteration. Concurrency changes elapsed time, not total
model work.

### Comparison

| Factor | One Copilot agent | Copilot `/fleet` | Sandcastle |
| --- | --- | --- | --- |
| Cost floor | Lowest | Parent plus child interactions | Fully configurable; can be lowest or extremely high |
| Duplicate context | One session | Common instructions/repo facts repeated in child contexts | Fresh sessions, worktrees, and setup commonly repeat context/build work |
| Concurrency | One | Automatic parallel subagents | Caller-defined |
| Control | Prompt/session controls | Automatic decomposition; custom agents/models possible | Explicit TypeScript topology, hooks, branches, and models |
| Failure isolation | Shared working tree/session | Worker task can fail or be killed; parent reconciles | Strong filesystem/branch/sandbox isolation |
| Merge conflicts | Low sequentially | Risk if ownership overlaps | Branch isolation, but explicit merge/reconciliation cost |
| Human oversight | Highest | Plan approval plus worker monitoring | Optional; AFK designs can defer substantial review |
| Best task size | One coherent change | 2-4 independent slices | Durable issue-sized risky or long-running jobs |

### Economical default

1. One strong-model planning turn.
2. Human approves a small set of vertical slices.
3. One cheap implementer, or `/fleet` with **two workers** if slices are
   independent.
4. Deterministic validation.
5. One independent review.
6. Sandcastle only where isolation, provider heterogeneity, or long-running AFK
   execution provides concrete value.

Use only one parallelism layer. Sandcastle workers should not invoke `/fleet`,
and a `/fleet` parent should not launch multiple independent Sandcastle swarms.

---

## 7. Matt Pocock skills and their proper place

- **`/wayfinder`** maps a large, unclear effort into decision tickets; it plans
  rather than implements. It permits parallel research tickets but normally
  resolves at most one decision ticket per session
  ([Wayfinder lines 8-14](https://github.com/mattpocock/skills/blob/ed37663cc5fbef691ddfecd080dff42f7e7e350d/skills/engineering/wayfinder/SKILL.md#L8-L14),
  [lines 87-118](https://github.com/mattpocock/skills/blob/ed37663cc5fbef691ddfecd080dff42f7e7e350d/skills/engineering/wayfinder/SKILL.md#L87-L118)).
- **`/grill-with-docs`** is a thin wrapper around grilling and domain modelling,
  producing ADR/glossary knowledge as discussion proceeds
  ([skill lines 1-9](https://github.com/mattpocock/skills/blob/ed37663cc5fbef691ddfecd080dff42f7e7e350d/skills/engineering/grill-with-docs/SKILL.md#L1-L9)).
- **`/research`** launches a background agent, requires primary sources, and
  writes a cited Markdown artifact
  ([skill lines 1-14](https://github.com/mattpocock/skills/blob/ed37663cc5fbef691ddfecd080dff42f7e7e350d/skills/engineering/research/SKILL.md#L1-L14)).
- **`/to-spec`** synthesizes the existing conversation and codebase knowledge
  without a new interview
  ([skill lines 1-31](https://github.com/mattpocock/skills/blob/ed37663cc5fbef691ddfecd080dff42f7e7e350d/skills/engineering/to-spec/SKILL.md#L1-L31)).
- **`/to-tickets`** creates vertical tracer-bullet slices sized for one fresh
  context, records blockers, and asks the user to approve granularity before
  publishing
  ([skill lines 18-69](https://github.com/mattpocock/skills/blob/ed37663cc5fbef691ddfecd080dff42f7e7e350d/skills/engineering/to-tickets/SKILL.md#L18-L69)).

These skills complement either execution mechanism. They produce decisions,
evidence, specifications, and tickets; Sandcastle or `/fleet` executes them.
Economically:

- Skip Wayfinder for a clear feature.
- Use grilling only where unanswered requirements would cause retries.
- Use `/research` only for a blocking factual question.
- Prefer `/to-tickets` before parallel execution because its one-context
  vertical slices reduce context duplication and merge contention.

---

## 8. Local inference viability

### Hardware facts

The i7-8750H provides six cores/twelve threads, dual-channel DDR4-2666 support,
64 GB maximum memory, and **41.8 GB/s** specified maximum memory bandwidth
([Intel specification](https://www.intel.com/content/www/us/en/products/sku/134906/intel-core-i78750h-processor-9m-cache-up-to-4-10-ghz/specifications.html)).

Ollama lists Quadro P1000 under supported compute capability 6.1, but currently
requires a sufficiently recent NVIDIA driver for pre-6.2 GPUs
([Ollama GPU support](https://docs.ollama.com/gpu)). The 4 GB card cannot fully
contain the default 7B or 9B artifacts once runtime and display memory are
included, so inference will be CPU-heavy with partial GPU offload.

Ollama defaults systems below 24 GiB VRAM to **4K context**, while its guidance
says coding tools and agents should use at least **64K**
([context documentation](https://docs.ollama.com/context-length)). That gap is
the central limitation of this laptop: an 8K-16K local setup can be useful for
tightly scoped tasks but is not a substitute for repository-scale cloud-agent
context.

### Current default artifact sizes

These are model-layer sizes, not peak RAM:

| Model | Parameters/architecture | Default artifact | Assessment |
| --- | --- | ---: | --- |
| Qwen2.5-Coder 7B | 7.61B dense | 4.36 GiB | Loads easily; plausible constrained interactive use |
| Ornith 9B | 9B dense | 5.24 GiB | Best current local candidate; cannot fit fully in 4 GB VRAM |
| Qwen2.5-Coder 14B | 14.7B dense | 8.37 GiB | Loads; occasional interactive use, slower |
| Qwen3-Coder 30B-A3B | 30.5B MoE, 3.3B active | 17.28 GiB | Loads only with substantial free RAM; agent usefulness unverified |
| Qwen2.5-Coder 32B | 32.5B dense | 18.49 GiB | Borderline once KV/runtime/IDE are added; likely too slow |
| Ornith 35B | 35B MoE | 19.71 GiB | Absolute-ceiling experiment, not a recommendation |

Artifact sources:
[Qwen 7B manifest](https://registry.ollama.ai/v2/library/qwen2.5-coder/manifests/7b),
[14B](https://registry.ollama.ai/v2/library/qwen2.5-coder/manifests/14b),
[32B](https://registry.ollama.ai/v2/library/qwen2.5-coder/manifests/32b),
[Qwen3-Coder 30B](https://registry.ollama.ai/v2/library/qwen3-coder/manifests/30b),
[Ornith 9B](https://registry.ollama.ai/v2/library/ornith/manifests/9b), and
[Ornith 35B](https://registry.ollama.ai/v2/library/ornith/manifests/35b).

### KV-cache headroom

Using the published Qwen layer/head configurations, approximate F16 KV memory
is:

| Model | 8K | 16K | 32K |
| --- | ---: | ---: | ---: |
| Qwen2.5-Coder 7B | 448 MiB | 896 MiB | 1.75 GiB |
| Qwen2.5-Coder 14B | 1.5 GiB | 3 GiB | 6 GiB |
| Qwen2.5-Coder 32B | 2 GiB | 4 GiB | 8 GiB |
| Qwen3-Coder 30B-A3B | 768 MiB | 1.5 GiB | 3 GiB |

Configurations:
[7B](https://huggingface.co/Qwen/Qwen2.5-Coder-7B-Instruct/raw/main/config.json),
[14B](https://huggingface.co/Qwen/Qwen2.5-Coder-14B-Instruct/raw/main/config.json),
[32B](https://huggingface.co/Qwen/Qwen2.5-Coder-32B-Instruct/raw/main/config.json),
and
[Qwen3-Coder](https://huggingface.co/Qwen/Qwen3-Coder-30B-A3B-Instruct/raw/main/config.json).

Ollama's Q8 KV cache approximately halves F16 memory; Q4 uses about one quarter
with more quality loss
([Ollama FAQ](https://docs.ollama.com/faq#how-can-i-set-the-quantization-type-for-the-kv-cache)).

### "Loads" versus "useful"

- **Loads:** all listed models may map into 32 GB RAM at short context if other
  applications leave enough memory.
- **Usable interactively:** 7B-9B Q4/Q5; possibly 14B Q4 for short responses.
- **Useful coding agent:** 7B-9B only for tightly scoped work with an evidence
  pack and 8K-16K context.
- **Not economical on this machine:** dense 32B and the 35B ceiling.

For dense weights, the CPU's 41.8 GB/s peak memory bandwidth implies optimistic
ceilings of roughly 7 tokens/s for a 5.6 GB model, 4.6 tokens/s for a 9 GB
model, and 2 tokens/s for a 20 GB model before overhead. This is a theoretical
bandwidth ceiling, not a measured benchmark; real sustained performance may be
lower.

### Exact local recommendation

1. **Primary:** `ornith:9b`, default artifact or Q4_K_M/Q5_K_M equivalent, 8K
   context initially.
2. **Fallback:** `qwen2.5-coder:7b`, Q4_K_M or Q5_K_M, 8K-16K context.
3. **Fast router:** 3B Q8 or Q5 for extraction, classification, and simple
   transformations.
4. **Occasional quality mode:** Qwen2.5-Coder 14B Q4_K_M, 8K context.
5. **Experimental only:** Qwen3-Coder 30B-A3B Q4 with 8K-16K and Q8 KV.
6. Set `OLLAMA_NUM_PARALLEL=1`; local fleet concurrency multiplies context
   memory
   ([Ollama FAQ](https://docs.ollama.com/faq#how-does-ollama-handle-concurrent-requests)).

Ornith's publisher reports 43.1 on Terminal-Bench 2.1 and 69.4 on SWE-bench
Verified for its 9B model, but these are first-party results and the exact
harness should be independently reproduced before relying on them
([Ornith announcement](https://deep-reinforce.com/ornith_1_0.html)).

---

## 9. Hardware-upgrade ROI

### Recommendation: no purchase yet

Run 30 days of telemetry first. The current laptop can test whether local 7B-9B
output is acceptable. A faster machine has no direct cash return while Max
remains subscribed and included credits are sufficient.

### Break-even equation

Let:

- \(H\) = hardware purchase cost
- \(O\) = monthly Copilot overages avoided
- \(D\) = monthly subscription downgrade saving
- \(P\) = monthly productivity value gained
- \(E\) = incremental electricity
- \(M\) = maintenance/opportunity cost

\[
\text{Break-even months} = \frac{H}{O + D + P - E - M}
\]

If the denominator is zero or negative, there is no dollar break-even.

### Explicit scenarios

Assume a **$1,500 value build** and $6-$10/month incremental electricity:

| Scenario | Monthly net saving | Break-even |
| --- | ---: | ---: |
| Keep Max, no overages | Negative | Never |
| Avoid $25 overages | about $19 | about 79 months |
| Downgrade Max to Pro+ ($61 difference), $8 electricity | about $53 | about 28 months |
| Avoid $100 overages, $10 electricity | about $90 | about 17 months |

A $3,000 32 GB-VRAM build avoiding $100/month with $10 electricity takes about
33 months. These are planning assumptions, not market quotes.

Even five minutes per working day lost waiting for a slow local model equals
about 1.7 hours/month. At an assumed $50/hour, that is about $83/month, enough
to erase most hardware savings. Productivity must therefore be measured, not
presumed.

### Configuration if privacy/offline use justifies purchase

#### Value 14B workstation

- Used RTX 3090 24 GB
- 64 GB system RAM
- Modern 8-12 core CPU
- 2 TB NVMe
- Quality 1000 W PSU

This comfortably supports 14B Q4-Q6 and makes short-context 32B Q4 possible but
tight.

#### Comfortable 32B workstation

- Prefer 32-48 GB total VRAM
- 96-128 GB system RAM
- 2-4 TB NVMe
- Modern high-memory-bandwidth platform
- Single 32 GB GPU preferred; dual used 3090s only if power, cooling, and
  multi-GPU complexity are acceptable

Privacy/offline operation is a separate benefit. Ollama states local prompts are
not sent to Ollama, and cloud features can be disabled with `OLLAMA_NO_CLOUD=1`
([Ollama FAQ](https://docs.ollama.com/faq#does-ollama-send-my-prompts-and-answers-back-to-ollamacom)).

---

## 10. Recommended MartiXDev artifacts

| Artifact | Purpose | Measurable acceptance criterion |
| --- | --- | --- |
| `llm-router` skill | Classify task, risk, and context, then route to the cheapest eligible tier | At least 80% of low-risk tasks accepted without escalation; at least 30% reduction in credits per accepted task |
| `escalation-gate` | Prevent reflexive frontier-model use | No expensive call on a green low-risk task; all overrides record a reason |
| Evidence-pack generator | Produce concise file map, errors, API versions, and acceptance commands | At least 25% fresh-input reduction with no pass-rate loss |
| Cross-model review skill | Cheap first pass, strong pass only on unresolved/high-risk findings | Expensive reviews on at most 20% of ordinary PRs; seeded critical-defect recall unchanged |
| AI-credit telemetry plugin | Record task, model, credits, cache ratio, retries, outcome, and wall time | At least 95% session attribution; weekly cost-per-accepted-change report |
| Fleet budget guard | Cap workers, retries, and total session credits | Default worker cap 2; zero nested-fleet runs |
| Local qualification suite | Representative .NET, C#, Blazor, TS, PowerShell, and M365 tasks with hidden tests | Promote local model only at 90% or more of GPT-5-mini accepted-result rate |
| Versioned Microsoft evidence packs | Current .NET/M365/SharePoint docs and API examples | Fewer unsupported-API errors and at least 20% fewer research escalations |

Skills should remain short and evidence-driven because persistent instructions
themselves consume input tokens on every request.

---

## 11. Risks and unresolved evidence gaps

- GitHub pricing, flex allotments, and model availability can change.
- Sonnet 5's reduced rate expires on 2026-08-31.
- Copilot code review does not disclose its current model.
- Raptor mini has no public card; GPT-5.6 Luna/Terra have no public OpenAI card.
- Gemini 3.1 Pro and Gemini 3 Flash are previews; behavior may change.
- MAI-Code-1-Flash is a continuously updated checkpoint.
- No current public benchmark compares all 17 models under one coding-agent
  harness.
- Provider benchmark claims use different scaffolds, effort settings, contexts,
  and tool budgets.
- No reliable first-party benchmark exists for the exact
  i7-8750H/P1000/Ollama combination.
- No representative public benchmark was found for .NET 10, Blazor, Fluent UI,
  SharePoint Server/Online, and Power Platform together.
- Sandcastle and Copilot SDK fleet surfaces are evolving; the SDK fleet binding
  is marked experimental
  ([GitHub SDK fleet docs, lines 14-34](https://github.com/github/docs/blob/79ca58cede78e171f80d857fc82c627a3167cd75/content/copilot/how-tos/copilot-sdk/features/fleet-mode.md#L14-L34)).

---

## 12. Source ledger

All sources retrieved **2026-07-23**.

| Owner | Source | URL | Supports |
| --- | --- | --- | --- |
| GitHub | Models and pricing for Copilot | <https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing> | Current Copilot rates, statuses, and code-review billing |
| GitHub | Usage-based billing for individuals | <https://docs.github.com/en/copilot/concepts/billing/usage-based-billing-for-individuals> | Max allowance, credits, and Auto discount |
| GitHub | Plans for Copilot | <https://docs.github.com/en/copilot/get-started/plans> | Plan prices and Max positioning |
| GitHub | Legacy model multipliers | <https://docs.github.com/en/copilot/reference/copilot-billing/request-based-billing-legacy/model-multipliers-for-annual-plans> | Legacy multipliers |
| GitHub | Legacy requests | <https://docs.github.com/en/copilot/reference/copilot-billing/request-based-billing-legacy/copilot-requests> | Prompt counting, allowances, and code review |
| GitHub | Model comparison | <https://docs.github.com/en/copilot/reference/ai-models/model-comparison> | Official task roles and missing cards |
| GitHub | Optimize AI usage | <https://docs.github.com/en/copilot/tutorials/optimize-ai-usage> | Cache, subagent, and cost guidance |
| GitHub | Fleet source docs | <https://github.com/github/docs/blob/79ca58cede78e171f80d857fc82c627a3167cd75/content/copilot/concepts/agents/copilot-cli/fleet.md> | Fleet behavior and cost warning |
| Anthropic | Haiku 4.5 | <https://www.anthropic.com/news/claude-haiku-4-5> | Speed and coding evidence |
| Anthropic | Sonnet 4.6 | <https://www.anthropic.com/news/claude-sonnet-4-6> | Claude Code preference evidence |
| Anthropic | Sonnet 5 | <https://www.anthropic.com/news/claude-sonnet-5> | Capability and promotional pricing |
| Anthropic | Opus 4.6 | <https://www.anthropic.com/news/claude-opus-4-6> | Agentic coding and review evidence |
| OpenAI | GPT-5.3-Codex system card | <https://deploymentsafety.openai.com/gpt-5-3-codex> | Agentic-model description |
| OpenAI | GPT-5.4 system card | <https://deploymentsafety.openai.com/gpt-5-4-thinking/introduction> | Reasoning-model status |
| Microsoft | Foundry model catalog | <https://learn.microsoft.com/en-us/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure> | GPT-5.4/5.6 IDs and contexts |
| Google DeepMind | Gemini Pro/Flash | <https://deepmind.google/models/gemini/pro/> | Gemini 3.1 positioning |
| Microsoft AI | MAI-Code-1-Flash | <https://microsoft.ai/models/mai-code-1-flash/> | Coding-task positioning |
| Moonshot AI | Kimi K2.7 Code card | <https://huggingface.co/moonshotai/Kimi-K2.7-Code> | Architecture and benchmarks |
| LiveBench | Official repository | <https://github.com/LiveBench/LiveBench> | Benchmark methodology and data gap |
| SWE-bench | Verified methodology | <https://www.swebench.com/verified.html> | Harness-comparability warning |
| Matt Pocock | Sandcastle source | <https://github.com/mattpocock/sandcastle/tree/e99f832f26dc9d245c019a9ddd19fa5dee792427> | Implementation, providers, and sample topology |
| Matt Pocock | Skills source | <https://github.com/mattpocock/skills/tree/ed37663cc5fbef691ddfecd080dff42f7e7e350d/skills/engineering> | Wayfinder/research/spec/tickets behavior |
| Intel | i7-8750H specifications | <https://www.intel.com/content/www/us/en/products/sku/134906/intel-core-i78750h-processor-9m-cache-up-to-4-10-ghz/specifications.html> | CPU and memory limits |
| Ollama | GPU support | <https://docs.ollama.com/gpu> | P1000 compatibility |
| Ollama | Context length | <https://docs.ollama.com/context-length> | Context defaults and agent guidance |
| Ollama | FAQ | <https://docs.ollama.com/faq> | Offload, concurrency, KV quantization, and privacy |
| Qwen | Qwen2.5-Coder family | <https://qwenlm.github.io/blog/qwen2.5-coder-family/> | Sizes, architecture, and coding evidence |
| Qwen | Qwen3-Coder card | <https://huggingface.co/Qwen/Qwen3-Coder-30B-A3B-Instruct> | MoE architecture and context |
| Deep Reinforce | Ornith 1.0 | <https://deep-reinforce.com/ornith_1_0.html> | Ornith architecture and self-reported results |

## Comparison Readiness

This report was produced independently by **GPT-5.6 Sol** from current primary
sources and is ready for side-by-side comparison with future research outputs.
