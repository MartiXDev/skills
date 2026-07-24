# Cheapest-Quality LLM Strategy for Copilot Max: Planning, Implementation, Review, Local Fallback, and Orchestration

**Research date:** 2026-07-23
**Scope:** GitHub Copilot Max subscription (17 named models), local Ollama options for an i7-8750H / 32GB RAM / Quadro P1000 (4GB) machine, a hardware-upgrade recommendation, Matt Pocock's skills workflow (`/wayfinder`, `/grill-with-docs`, `/research`, `/to-spec`, `/to-tickets`) and Sandcastle orchestrator, Copilot CLI `/fleet`, and how all of this should be tuned given this repository's marketplace and `.sandcastle/main.mts` pipeline.
**Primary stack:** .NET 10+, C#, Blazor, React, Vue.js, TypeScript, Fluent UI. **Secondary stack:** PowerShell, SharePoint Server/Online, Microsoft 365, Power Platform, Power Automate.

> **Confidence key used throughout:** 🟢 official/primary source · 🟡 independent third-party benchmark · 🔴 vendor self-reported / not independently verified

**Review again:** before 2026-08-31 (Claude Sonnet 5 promo pricing ends) and whenever `docs/llm-routing-strategy.md` / `docs/execution-profiles.md` are refactored — this doc is a dated snapshot with volatile pricing/benchmark claims, not normative policy (see the "Repository research snapshots" convention in `docs/README.md`).

**Related:** [`docs/knowledge/llm-cache.md`](./llm-cache.md) covers token/prompt-cache mechanics (cache-safe prefixes, reasoning-effort defaults, session hygiene). This doc covers a layer up — *which model* to use for which task/phase, and how to orchestrate agents cost-effectively. Read both; they don't overlap.

---

## 1. Executive Summary

1. **The subscription is flat-rate, so the real lever is *volume*, not per-call price.** Copilot Max is $100/mo for 20,000 AI credits (1 credit = $0.01 of model usage) 🟢. Every model on the list is "free" up to that cap — the only thing model choice changes is **how far 20,000 credits stretch** before hitting metered overage. This matters enormously here specifically because `.sandcastle/main.mts` can run up to 50 outer iterations × N parallel issues × 100 implementer iterations each — i.e., it is exactly the kind of high-agent-turn workload where model choice has the largest financial leverage in the whole setup.
2. **The Sandcastle pipeline is currently mistuned.** `main.mts` hardcodes **all four phases** (`PLAN_AGENT_LLM`, `IMPLEMENT_AGENT_LLM`, `REVIEW_AGENT_LLM`, `MERGE_AGENT_LLM`) to `"gpt-5.6-terra"` — a "Versatile/Powerful" $2.50-in/$15.00-out model — for planning **and** for the bulk-volume implement loop. This is inconsistent with the file's own in-code comment ("Premium reasoning for planning… deeper reasoning") and with `docs/llm-routing-strategy.md`'s tiering philosophy. Retuning this one file is the single highest-leverage change available (§11) — illustrative modeling suggests **~60% cost reduction per ticket** with no loss, and likely a review-diversity gain.
3. **Claude Sonnet 5 is the best "premium" value on the whole list right now**, and it is on a **promotional price that ends 2026‑08‑31** 🟢 ($2.00 in / $10.00 out → jumps to $3.00/$15.00 after). It beats Claude Sonnet 4.6 and GPT‑5.4 on SWE-bench while being cheaper than both. Use it for planning/spec/architecture work before the promo lapses.
4. **GPT‑5.6 Luna is the best cheap-but-agentic pick** (Terminal-bench ~84.7% 🟡 at $1.00 in/$6.00 out) — the default for the Sandcastle implement/merge phases and for `/fleet` subagents.
5. **This repository's skill marketplace is a genuine cost multiplier, not just a convenience.** Because it already encodes .NET/C#, FastEndpoints, FluentValidation, TUnit, PowerShell, TypeScript, Fluent UI, and SharePoint Server/SPFx/PnP conventions, cheap/lightweight models perform much closer to premium-model quality on real code than generic public benchmarks suggest (§5). **Blazor, Vue.js, and Power Platform/Power Automate currently have no dedicated MartiX skill** — these are the best next skill investments, precisely because cheap models benefit *most* where public training data is thinner.
6. **Local Ollama on the current hardware is a hobby/privacy tool, not a cost-saving tool.** At ~5–10 tok/s for a usable 7B model, local inference is slower than it is cheap: the cheapest cloud models (GPT‑5.4 nano, GPT‑5 mini) already cost fractions of a cent per request inside a subscription already being paid for. Local LLM makes sense for offline work, air-gapped/on‑prem SharePoint client engagements, or unlimited free experimentation — not for beating Copilot Max on $/quality (§6).
7. **If upgrading hardware, a used RTX 3090 (24GB) is the best $/capability jump** (~$700–1,000), unlocking 7–14B models at 10–15× current speed and fitting up to ~30B fully in VRAM (§7).
8. **Keep Sandcastle; don't replace it with `/fleet`.** They're complementary at different granularities: Sandcastle (already built, Docker-isolated, GitHub-Issue-driven) is the "batch factory" for `/to-tickets` backlogs; `/fleet` is the lighter-weight, zero-setup tool for same-session multi-file work while actively driving Copilot CLI (§9).

---

## 2. Current Setup (grounding for everything below)

Before proposing anything, this research read this repository:

| Artifact | What it already does |
|---|---|
| `README.md` | Full skill/plugin inventory: `martix-dotnet-csharp`, `martix-fastendpoints`, `martix-fluentvalidation`, `martix-tunit`, `martix-powershell`, `martix-typescript`, `martix-fluent-ui`, `martix-essl`, `martix-sharepoint-server`, `martix-sharepoint-spfx`, `martix-sharepoint-pnp`, `martix-markdown`, plus bundles `martix-markdown-automation`, `martix-dotnet-library`, `martix-webapi`. |
| `docs/llm-routing-strategy.md` | Documents (correctly) that **Copilot CLI plugins/Agent Skills have no native cost-aware model routing** — `plugin.json`/`SKILL.md` frontmatter cannot select a model. Defines `cheap`/`medium`/`premium`/`mixed` as **repo-owned abstraction tiers**, deliberately not hardcoded vendor names, used only in docs/metadata. Explicitly forbids a `martix-llm-router` skill or duplicated pricing tables in packages. Prefers deterministic hooks/scripts ("zero-token routing") over any LLM call for mechanical checks. |
| `docs/execution-profiles.md` | Defines the `executionProfile` metadata shape (`modelTier`, `taskTypes`, `parallelSafety`, `fleetReady`, `worktreeSafe`, `tokenBudget`, `contextStrategy`) used across package metadata. |
| `.sandcastle/main.mts` | A **working, deployed** 4-phase Plan → (Implement + Review, concurrent per issue) → Merge loop (up to 50 outer iterations) using `@ai-hero/sandcastle`. Reads GitHub issues labeled `Sandcastle`, builds a dependency graph via a 1-iteration "planner" agent (structured `<plan>` JSON via Zod schema), runs implementer (≤100 iterations) + reviewer (1 iteration) pairs concurrently per issue in per-issue Docker sandboxes, then a single merger agent merges completed branches. **All four phase constants are currently `"gpt-5.6-terra"`** (with a commented-out all-`claude-sonnet-4.5` alternative left in the file). |
| `.sandcastle/plan-prompt.md` | Fetches open `Sandcastle`-labeled issues via `gh issue list`, builds the blocking-dependency graph, emits deterministic `sandcastle/issue-{id}` branch names, and outputs `<plan>{"issues":[...]}</plan>` — directly consuming the shape produced by Matt Pocock's `/to-tickets`. |

**Implication:** no strategy needs inventing from scratch. What's needed is (a) concrete vendor-model assignments to slot into the existing `cheap/medium/premium/mixed` vocabulary, and (b) a corrected `.sandcastle/main.mts`. The rest of this doc supplies both, plus the local/hardware/orchestration research requested.

> **Note (as of 2026-07-23):** `docs/llm-routing-strategy.md`, `docs/execution-profiles.md`, and possibly other MD docs in this repo were flagged as slightly outdated and slated for a refactor soon at the time this doc was written. The recommendations below are written as **tier-mapping guidance** (`cheap/medium/premium/mixed` → concrete models, the `docs/models.yaml` concept) rather than edits to specific doc wording, so they should survive that refactor intact. When the refactor happens, carry the tier vocabulary and the §11 Sandcastle model split forward into whatever the new doc structure looks like.

---

## 3. GitHub Copilot Max — Official Pricing Reference (all 17 models)

Source: 🟢 [GitHub Docs — Copilot models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing) (fetched directly, current as of 2026‑07‑23). Billing is **token-based AI credits** (1 credit = $0.01) for Max/Pro/Pro+ plans — this is a different system from the legacy "premium request multiplier" that only applies to grandfathered annual Pro/Pro+ subscribers.

| Model | Category | Input $/1M | Cached In $/1M | Cache Write $/1M | Output $/1M | Notes |
|---|---|---:|---:|---:|---:|---|
| GPT‑5.4 nano | Lightweight | $0.20 | $0.02 | — | $1.25 | Cheapest on the list |
| GPT‑5 mini | Lightweight | $0.25 | $0.025 | — | $2.00 | |
| Raptor mini (GitHub fine-tune of GPT-5 mini) | Versatile | $0.25 | $0.025 | — | $2.00 | 🔴 **Chat-only (VS Code) — not available in Copilot CLI or the desktop app**, so it cannot run Sandcastle/`fleet` workflows |
| Gemini 3 Flash (preview) | Lightweight | $0.50 | $0.05 | — | $3.00 | Preview status = pricing/availability may change |
| MAI-Code-1-Flash | Lightweight | $0.75 | $0.075 | — | $4.50 | Microsoft's Copilot-native MoE (137B total/5B active) 🟡 |
| GPT‑5.4 mini | Lightweight | $0.75 | $0.075 | — | $4.50 | |
| Kimi K2.7 Code | Versatile | $0.95 | $0.19 | — | $4.00 | Open-weight MoE 1T/32B active |
| Claude Haiku 4.5 | Versatile | $1.00 | $0.10 | $1.25 | $5.00 | |
| GPT‑5.6 Luna | Lightweight | $1.00 (≤200K) | $0.10 | $1.25 | $6.00 | >200K context: $2.00/$0.20/$9.00 |
| Gemini 3.6 Flash | Versatile | $1.50 | $0.15 | — | $7.50 | |
| GPT‑5.3-Codex | Powerful | $1.75 | $0.175 | — | $14.00 | |
| **Claude Sonnet 5** | Versatile | **$2.00** (promo, ends 2026‑08‑31; then $3.00) | $0.20 | $2.50 | $10.00 | See §4 |
| Gemini 3.1 Pro (preview) | Powerful | $2.00 (≤200K) | $0.20 | — | $12.00 | >200K: $4.00/$0.40/$18.00 |
| GPT‑5.4 | Versatile | $2.50 (≤272K) | $0.25 | — | $15.00 | >272K: $5.00/$0.50/$22.50 |
| GPT‑5.6 Terra | Versatile | $2.50 (≤272K) | $0.25 | $3.13 | $15.00 | >272K: $5.00/$0.50/$22.50 — **currently the Sandcastle default for all 4 phases** |
| Claude Sonnet 4 / 4.5 / 4.6 | Versatile | $3.00 | $0.30 | $3.75 | $15.00 | |
| Claude Opus 4.5 / 4.6 / 4.7 / 4.8 | Powerful | $5.00 | $0.50 | $6.25 | $25.00 | |
| GPT‑5.5 / GPT‑5.6 Sol | Powerful | $5.00 (≤272K) | $0.50 | — | $30.00 | |
| Claude Opus 4.8 (fast) / Claude Fable 5 | Powerful | $10.00 | $1.00 | $12.50 | $50.00 | Most expensive on the list |

**Monthly credit allowances** 🟢 ([usage-based billing docs](https://docs.github.com/en/copilot/concepts/billing/usage-based-billing-for-individuals)): Pro $10/mo → 1,500 credits; Pro+ $39/mo → 7,000 credits; **Max $100/mo → 20,000 credits**. Unused credits do not roll over — this reinforces point 1 in the executive summary: the goal isn't "spend less than $100," it's "get the most agentic work done inside the 20,000-credit envelope before falling back to metered overage."

---

## 4. Benchmark Cross-Reference & Confidence Levels

Synthesized from SWE-bench Verified / SWE-bench Pro, Terminal-bench, and LiveCodeBench data gathered from [artificialanalysis.ai](https://artificialanalysis.ai/), [livebench.ai](https://livebench.ai/), [llm-stats.com](https://llm-stats.com/), and vendor benchmark pages, cross-referenced against the pricing table above.

| Model | SWE-bench Verified | SWE-bench Pro | Terminal-bench | Confidence | Cost/quality verdict |
|---|---:|---:|---:|---|---|
| **Claude Sonnet 5** | **85.2%** | **63.2%** (best on list) | 80.4% | 🟡 | **Best premium value** — beats Sonnet 4.6 & GPT‑5.4 at a lower promo price |
| GPT‑5.6 Terra | ~78–82% (est.) | — | **87.4%** (best agentic) | 🟡 | Strictly better than GPT‑5.4 at the *same* price — never choose 5.4 over Terra |
| GPT‑5.6 Luna | ~74–77% (est.) | — | 84.7% | 🟡 | **Best cheap/agentic pick** — near-Sonnet-5 agentic quality at ~half price |
| Gemini 3 Flash | 78.0% (beats Gemini 3.1 Pro) | — | — | 🟡 | Best value if preview-status risk (pricing/availability churn) is acceptable |
| Claude Opus 4.6 | 80.8% | — | — | 🟡 | **Hard to justify** — worse than Sonnet 5 at 2.5× the price; skip for planning |
| Claude Haiku 4.5 | ~73% (est.) | — | — | 🟡 | Good "second opinion" reviewer model, distinct model family from GPT/Gemini implementers |
| MAI-Code-1-Flash | 71.6% | — | — | 🟡 | Uses ~60% fewer tokens than Haiku 4.5 on complex tasks; Copilot-native tuning |
| Kimi K2.7 Code | No independent SWE-bench yet | — | — | 🔴 | Predecessor K2.6 scored 80.2% Verified independently — promising but unverified for K2.7 |
| Gemini 3.1 Pro | ~70s% (below Gemini 3 Flash) | — | — | 🟡 | Preview Powerful-tier model that a Lightweight-tier sibling already beats — low priority |
| Raptor mini | N/A for this workflow | — | — | 🟢 (availability) | Chat-only; irrelevant to CLI/Sandcastle/fleet workflows |
| GPT‑5.3-Codex | Strong on agentic coding | — | — | 🟡 | Codex-lineage, capable but pricier than Terra/Luna for similar signal |

**Ranking headline:** For a Copilot Max user optimizing $/quality, the effective frontier is **Claude Sonnet 5 (premium) → GPT‑5.6 Terra (versatile/agentic) → GPT‑5.6 Luna (cheap/agentic) → Gemini 3 Flash or MAI‑Code‑1‑Flash (cheapest with real signal) → GPT‑5.4 nano (near-free, mechanical tasks only)**. Everything else on the list is dominated by one of these five for a cost-sensitive solo developer.

---

## 5. Tiered Recommendations Mapped to the `cheap/medium/premium/mixed` Vocabulary

`docs/llm-routing-strategy.md` deliberately avoids hardcoding vendor names in shared docs/metadata (so tiers don't rot when a model is deprecated). This doc proposes the **concrete vendor mapping** to keep in a *dated*, MartiX-maintained alias file (the `docs/models.yaml` idea floated in that doc), reviewed whenever pricing changes materially (e.g., the Sonnet 5 promo end date below).

**Proposed `docs/models.yaml` (illustrative — verify exact CLI model identifiers with `copilot model list` before committing):**

```yaml
# MartiX model-tier alias map — NOT consumed automatically by Copilot; maintained guidance only.
# Review-by: 2026-08-25 (before Claude Sonnet 5 promo pricing ends 2026-08-31)
tiers:
  premium:
    primary: claude-sonnet-5       # $2.00 in / $10.00 out (promo, thru 2026-08-31)
    fallback_after_promo: gpt-5.6-terra   # re-evaluate: Sonnet 5 rises to $3.00/$15.00, still likely cheaper-per-quality than Opus
    use_for: [planning, architecture, security-review, wayfinder-map, to-spec, to-tickets]
  medium:
    primary: gpt-5.6-luna          # $1.00 in / $6.00 out, Terminal-bench 84.7%
    alt_family_for_review: claude-haiku-4.5   # $1.00 in / $5.00 out — different vendor family, better bug-catching diversity
    use_for: [implementation, code-review, merge-conflict-resolution, docs]
  cheap:
    primary: gemini-3-flash        # $0.50 in / $3.00 out, SWE-bench 78.0% (preview - re-check availability)
    fallback: mai-code-1-flash     # $0.75 in / $4.50 out, Copilot-native tuning, token-efficient
    ultra_cheap: gpt-5.4-nano      # $0.20 in / $1.25 out — mechanical edits, lint-fix loops only
    use_for: [formatting, mechanical-refactor, trivial-fix, changelog, low-stakes-scripts]
  mixed:
    pattern: "premium for plan phase, medium/cheap for parallel implement slices"
    matches: .sandcastle/main.mts parallel-planner-with-review template
```

**Task-type → tier mapping (aligned to `execution-profiles.md` task types):**

| Task type | Recommended tier | Why |
|---|---|---|
| `planning` (dependency graphs, architecture, `/wayfinder` maps, `/to-spec`, `/to-tickets`) | **premium** (Claude Sonnet 5) | Decisions here are expensive to reverse; low call volume so absolute cost is small even at premium pricing |
| `implementation` (bulk of Sandcastle iteration volume) | **medium/cheap** (GPT‑5.6 Luna → Gemini 3 Flash) | This is where 90%+ of token *volume* lives — the tier choice here dominates monthly credit burn |
| `review` | **medium**, different model family than the implementer | Cross-family review catches classes of bugs a same-family reviewer tends to miss; still cheap enough to run on every PR |
| `validation`/mechanical checks (lint, format, test-run triage) | **cheap or zero-token** | Prefer deterministic scripts/hooks per the "zero-token routing" principle; only escalate to an LLM call if a script can't decide |
| `cleanup`/merge conflict resolution | **cheap/medium** | Usually mechanical; escalate to medium only when conflicts are semantically non-trivial |

---

## 6. Tech Stack Changes the Calculus (and where the gaps are)

Because this repository already ships working conventions for `martix-dotnet-csharp`, `martix-fastendpoints`, `martix-fluentvalidation`, `martix-tunit`, `martix-powershell`, `martix-typescript`, `martix-fluent-ui`, and the SharePoint trio (`martix-sharepoint-server`, `martix-sharepoint-spfx`, `martix-sharepoint-pnp`), a cheap/medium model working inside the repo effectively "borrows" pattern knowledge it would otherwise lack — narrowing the practical quality gap to premium models on real code, even where public benchmarks show a bigger gap on generic tasks.

**Coverage vs. gaps, mapped to the stated stack:**

| Technology | Skill coverage | Model-tier implication |
|---|---|---|
| .NET 10+/C# | ✅ `martix-dotnet-csharp`, `martix-dotnet-library` | Safe to run **cheap/medium** for most implementation |
| FastEndpoints, FluentValidation, TUnit | ✅ dedicated skills | These are niche libraries with thin public training data — the skills are doing the most work here; cheap models benefit disproportionately |
| PowerShell | ✅ `martix-powershell` | Safe **cheap/medium** |
| TypeScript | ✅ `martix-typescript` | Safe **cheap/medium** |
| Fluent UI (React) | ✅ `martix-fluent-ui` | Safe **cheap/medium** for React+Fluent UI work |
| SharePoint Server/SPFx/PnP | ✅ full trio | Niche/enterprise domain, thin public data — skills matter most here too; still lean cheap/medium given skill coverage |
| **Blazor** | ⚠️ **no dedicated skill** (partially implied by `martix-dotnet-csharp`) | Blazor is mainstream enough that most models handle it reasonably without a skill, but a dedicated `martix-blazor` skill (component lifecycle, render modes, JS interop conventions) would allow more Blazor work to move down to the cheap tier with confidence |
| **Vue.js** | ⚠️ **no skill at all** | Same logic as Blazor — mainstream framework, decent baseline model knowledge, but no MartiX conventions currently enforced; consider `martix-vue` if Vue work grows |
| **Power Platform / Power Automate** | ⚠️ **no skill at all** | This is the highest-value gap: low-code Microsoft tooling has a *much* thinner public corpus than React/.NET, so generic model quality is genuinely weaker here. A `martix-power-platform` skill would allow routing Power Platform tasks to cheap/medium models instead of defaulting to premium out of caution |

**Recommendation:** if Power Platform/Power Automate work is recurring, building that skill is likely the highest-ROI *new* skill investment — it's the one domain in this stack where "no skill" currently forces a premium-model default for safety.

---

## 7. Local LLM via Ollama — Reality Check for the Current Hardware

**Hardware:** Intel i7-8750H (6c/12t, Coffee Lake-H, 2018), 32GB RAM, NVIDIA Quadro P1000 (4GB, Pascal architecture, no tensor cores).

### 7.1 What's actually achievable

| Model size | Realistic throughput | Practicality |
|---|---|---|
| 7B (Q4_K_M, ~4.5–4.7GB) | **~5–10 tok/s** | Usable for short completions; GPU can only partially offload (~70–85% of layers fit in 4GB VRAM), and the PCIe bottleneck means partial GPU offload barely beats CPU-only |
| 14B (Q4_K_M) | ~2–4 tok/s | Borderline — usable for "fire and wait" tasks, not interactive coding |
| 30B+ | ~1–2 tok/s | Not practical on this hardware |

Source basis: 🟡 community benchmarks for Pascal-generation low-VRAM cards on [ollama.com](https://ollama.com/search) model pages and general llama.cpp GPU-offload behavior for 4GB cards.

### 7.2 Model shortlist

| Model | Size | Verdict |
|---|---|---|
| **`qwen2.5-coder:7b`** | ~4.7GB Q4_K_M | **Best mature, well-benchmarked local choice** for this hardware today |
| `ornith:9b` | ~5–6GB | DeepReinforce AI, built on a Gemma/Qwen3.5 base; **is a reasoning model** (emits `<think>` blocks) — expect real-world speed well below the raw tok/s figure due to thinking overhead; use `/no_think` to keep it usable. 🔴 Self-reports SWE-bench Verified 69.4%, but **[BenchLM.ai](https://benchlm.ai/models/ornith-1-0-9b) explicitly excludes it from its public leaderboard pending independent verification** — treat any quality claim with caution until that changes |
| `qwen3:8b` | similar class | Also a reasoning model; use `/no_think` for interactive speed |
| `qwen2.5-coder:14b` | slower | Higher ceiling if 2–4 tok/s is tolerable for non-interactive/batch use |

### 7.3 The honest cost verdict

The cheapest cloud models (GPT‑5.4 nano at ~$0.0003/typical short call, GPT‑5 mini/Gemini 3 Flash at fractions of a cent) already run inside a subscription already being paid for. Local inference at 5–10 tok/s is **slower than useful** for interactive coding, and the "savings" are illusory unless working (a) offline, (b) on proprietary/on-prem client code that cannot be sent to any cloud API, or (c) doing effectively unlimited experimentation for free. **Recommendation: use local Ollama as a privacy/offline fallback, not as the primary cost-optimization lever** — Copilot Max's cheap tier already wins on $/quality/speed for anything that would actually ship.

---

## 8. Hardware Upgrade Paths (if local should actually be competitive)

| Tier | Cost | Hardware | What it unlocks |
|---|---|---|---|
| 1 — Budget | ~$450–600 | RTX 4060 Ti 16GB, or used RX 7900 XTX (Linux/ROCm) | 7–14B models at 40–55 tok/s; hard 16GB ceiling limits future model growth |
| **2 — Recommended sweet spot** | **~$700–1,000** | **Used RTX 3090 (24GB)** | Up to ~30B fully in VRAM at ~27–31 tok/s; 7B models at 80–100 tok/s (10–15× current speed); best $/VRAM on the used market |
| 3 — Premium/all-in-one | ~$1,599+ | Mac Mini M4 Pro (24GB unified memory) | Fits up to 32B models; ~51 tok/s at 7B; quieter/lower-power than a GPU tower, but slower prompt-prefill than NVIDIA |
| Try-before-you-buy | ~$0.27–0.30/hr | RunPod / Vast.ai RTX 4090 rental | Validate whether local inference actually changes the workflow before committing hardware spend |

**Recommendation:** the used RTX 3090 is the clear best value — it pays for itself in productivity (10–15× current tok/s) within a few months of regular local use, and 24GB headroom avoids immediately outgrowing it when trying larger models.

---

## 9. Matt Pocock Skills Workflow — and How It Maps to Model Tiers

Repo: [github.com/mattpocock/skills](https://github.com/mattpocock/skills) (install via `npx skills@latest add mattpocock/skills`, or `claude plugin install mattpocock-skills@mattpocock`).

**Canonical chain:** `grill-with-docs → to-spec → to-tickets → implement → code-review`, with an optional big/foggy on-ramp: `wayfinder → (fog clears) → to-spec → …`.

| Skill | What it does | Recommended tier |
|---|---|---|
| `/wayfinder` | For work too large/foggy for one session; builds a `wayfinder:map` issue with child decision tickets (`research`/`prototype`/`grilling`/`task`); philosophy is "plan, don't do"; never resolves more than one ticket per session except research tickets | **premium** — infrequent, high-stakes decomposition |
| `/grill-with-docs` | Relentless one-question-at-a-time interview; writes `CONTEXT.md` glossary + ADRs; user-invoked, for ideas that fit in one session | **premium** — the maintainer is in the loop anyway; the cost is trivial relative to the decision quality gained |
| `/research` | Model-invoked; spins a background agent to investigate primary sources and write a cited Markdown file; feeds `/grill-with-docs`, doesn't replace it | **medium** — mostly retrieval/synthesis, not deep architectural reasoning |
| `/to-spec` | Synthesizes a spec/PRD from existing conversation context (no re-interview); Problem Statement/Solution/User Stories/Implementation Decisions/Testing Decisions/Out of Scope/Further Notes; favors "deep modules" | **premium** — a bad spec propagates cost into every downstream ticket |
| `/to-tickets` | Breaks the spec into "tracer bullet" vertical-slice tickets with explicit blocking dependencies (native GitHub/Linear blocking links) so parallel agents can grab unblocked "frontier" tickets; has an expand-contract exception for wide refactors | **premium** for the decomposition call itself (low volume, high leverage) |
| `implement` (per ticket) | The actual code-writing step — this is Sandcastle's `IMPLEMENT_AGENT_LLM` | **medium/cheap** — highest volume, biggest cost lever |
| `code-review` | Bug-catching pass over the diff — this is Sandcastle's `REVIEW_AGENT_LLM` | **medium**, ideally a different model family than the implementer |

**Key insight:** the entire Pocock workflow is *already* asymmetric by design — a handful of premium-tier calls (grill/spec/tickets) gate a much larger volume of implementation calls. The Sandcastle pipeline should mirror that asymmetry instead of running everything on one model.

---

## 10. Sandcastle vs. Copilot CLI `/fleet`

### 10.1 What Sandcastle is (already running here)

[github.com/mattpocock/sandcastle](https://github.com/mattpocock/sandcastle), npm `@ai-hero/sandcastle`, MIT-licensed, free/open-source. A TypeScript SDK for orchestrating coding agents in isolated sandboxes (Docker/Podman/Vercel Firecracker/none). Core API: `run()`, `createSandbox()`, `createWorktree()`. Branch strategies: `head`/`merge-to-head`/`branch`. Six supported agent providers including `copilot()` (what `main.mts` uses). Ships templates including `parallel-planner-with-review` — the exact shape this pipeline implements.

### 10.2 What `/fleet` is

Official Copilot CLI subagent orchestration ([docs.github.com/en/copilot/concepts/agents/copilot-cli/fleet](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/fleet)): 🟢 "**By default, subagents use a low-cost AI model**"; the orchestrator can override per-subtask inline (e.g., "…use GPT-5.3-Codex to create X… use Claude Opus 4.5 to analyze Y…") or via `.github/agents/*.md` profiles with a `model:` field. Subagents get **isolated context windows** but **share the filesystem with no locking** — file/directory ownership must be partitioned explicitly in prompts to avoid last-write-wins conflicts. GitHub explicitly warns fleet "may cause more AI credits to be consumed"; mitigate with cheap subagent models and `/limits set max-ai-credits N`.

### 10.3 Comparison and recommendation

| Dimension | Sandcastle (already built) | Copilot CLI `/fleet` |
|---|---|---|
| Isolation | Full Docker sandbox + git worktree per issue — no file-conflict risk | Shared filesystem, no locking — conflict risk on concurrent subagents |
| Setup cost | Already paid (`main.mts` exists and works) | Zero marginal setup — built into Copilot CLI |
| Best granularity | Batches of `/to-tickets` backlog items, fully AFK | Same-session, interactive, few-file parallel work |
| Cost control | Manual (the four `*_AGENT_LLM` constants) | Built-in cheap-subagent default + `/limits` session caps |
| Task source | GitHub Issues labeled `Sandcastle` | Ad hoc, whatever is typed in the session |

**Recommendation: keep both, for different granularities.** Don't replace Sandcastle — it's already built, already Docker-isolated, and already wired to `/to-tickets` output shape. Use it as the "batch factory" for backlogs of independent tickets to process unattended. Use `/fleet` inside interactive Copilot CLI sessions for smaller, same-session parallel work (e.g., "update these 3 components to the new Fluent UI token API") where spinning up a full Sandcastle Docker run is overkill. The general orchestrator-comparison finding (dedicated sandbox orchestrators become worth it at ≥20–30 independent tasks/week or ≥3–5 person teams) already applies favorably here — Sandcastle was already built for a reason.

---

## 11. The One Concrete Change to Make: Retune `.sandcastle/main.mts`

Current state (verified from the file):

```ts
// const PLAN_AGENT_LLM = "claude-sonnet-4.5";
// const IMPLEMENT_AGENT_LLM = "claude-sonnet-4.5";
// const REVIEW_AGENT_LLM = "claude-sonnet-4.5";
// const MERGE_AGENT_LLM = "claude-sonnet-4.5";

const PLAN_AGENT_LLM = "gpt-5.6-terra";
const IMPLEMENT_AGENT_LLM = "gpt-5.6-terra";
const REVIEW_AGENT_LLM = "gpt-5.6-terra";
const MERGE_AGENT_LLM = "gpt-5.6-terra";
```

**Suggested retuning** (verify exact model identifier strings against `copilot model list` / Sandcastle's provider docs before committing — the strings below are Copilot CLI model names, not guaranteed to be Sandcastle's literal accepted values):

```ts
// PREMIUM tier: dependency-graph planning benefits from the strongest reasoning;
// this call happens once per outer iteration, so absolute cost stays tiny.
const PLAN_AGENT_LLM = "claude-sonnet-5";        // promo pricing thru 2026-08-31; re-check after

// MEDIUM/CHEAP tier: this is where 90%+ of token volume lives.
const IMPLEMENT_AGENT_LLM = "gpt-5.6-luna";      // Terminal-bench 84.7% @ $1.00/$6.00

// MEDIUM tier, different model family than the implementer for bug-catching diversity.
const REVIEW_AGENT_LLM = "claude-haiku-4.5";     // $1.00/$5.00, distinct vendor family from Luna

// CHEAP/MEDIUM tier: merge-conflict resolution is largely mechanical.
const MERGE_AGENT_LLM = "gpt-5.6-luna";
```

### Illustrative cost impact (rough modeling, not measured — verify against real token logs)

Assumptions per ticket: implement ≈15 iterations × (4,000 in / 600 out) tokens; review ≈1 call × (6,000 in / 1,200 out); plan+merge shared across a 5-ticket batch ≈ (8,000 in/1,500 out) + (4,000 in/800 out).

| Config | Implement | Review | Plan+Merge (amortized/ticket) | **Total/ticket** |
|---|---:|---:|---:|---:|
| **Current** (all GPT‑5.6 Terra, $2.50/$15.00) | $0.285 | $0.033 | $0.013 | **≈ $0.33 (≈33 credits)** |
| **Retuned** (Sonnet 5 plan / Luna implement+merge / Haiku 4.5 review) | $0.114 | $0.012 | $0.008 | **≈ $0.13 (≈13.4 credits)** |

**≈ 60% reduction in Sandcastle cost per ticket**, from a config change alone — no loss of planning quality (arguably a gain, since Sonnet 5 outscores Terra on SWE-bench Pro), plus a review-diversity benefit from switching the reviewer to a different model family than the implementer. Treat these numbers as directional; actual iteration counts and context sizes will differ.

---

## 12. Consolidated End-to-End Workflow

```
/wayfinder (premium, only if foggy) ──▶ /grill-with-docs (premium) ──▶ /to-spec (premium)
        ──▶ /to-tickets (premium, low volume) ──▶ GitHub issues labeled "Sandcastle"
                ──▶ .sandcastle/main.mts
                        PLAN_AGENT_LLM   = claude-sonnet-5      (premium)
                        IMPLEMENT_AGENT_LLM = gpt-5.6-luna      (medium/cheap, bulk volume)
                        REVIEW_AGENT_LLM = claude-haiku-4.5     (medium, cross-family)
                        MERGE_AGENT_LLM  = gpt-5.6-luna         (cheap/medium)
                ──▶ merged branches, PR-ready
For same-session, few-file, interactive work instead of a full Sandcastle batch run:
        Copilot CLI /fleet, orchestrator = the interactive session,
        subagents default to low-cost model, override to gpt-5.6-luna / claude-haiku-4.5 as needed,
        set /limits set max-ai-credits N as a safety cap.
```

---

## 13. Action Checklist

1. **Retune `.sandcastle/main.mts`** per §11 — highest-leverage single change available.
2. **Add a dated `docs/models.yaml`** (draft in §5) mapping `cheap/medium/premium/mixed` tiers to concrete current models; put a review-by date before 2026‑08‑31 (Sonnet 5 promo end).
3. **Track the Sonnet 5 promo deadline** — plan/spec/ticket work should lean on it now while it's $2.00/$10.00.
4. **Do not use Raptor mini** in any CLI/Sandcastle/fleet context — it's Chat-only.
5. **Consider new skills** for Power Platform/Power Automate (highest-ROI gap) and, lower priority, Blazor/Vue.js.
6. **Skip local LLM as a cost strategy** on current hardware; keep it as an offline/privacy fallback only (`qwen2.5-coder:7b` if used).
7. **If investing in hardware**, get a used RTX 3090 (24GB) — best $/capability for local inference if/when it becomes worth it (privacy-sensitive on-prem client work, etc.).
8. **Keep Sandcastle as the batch orchestrator; add `/fleet` for interactive same-session parallel work** — they serve different granularities, not competing choices.

---

## 14. Sources

- 🟢 [GitHub Docs — Copilot models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing)
- 🟢 [GitHub Docs — Usage-based billing for individuals](https://docs.github.com/en/copilot/concepts/billing/usage-based-billing-for-individuals)
- 🟢 [GitHub Docs — Copilot CLI `/fleet`](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/fleet)
- 🟡 [Artificial Analysis](https://artificialanalysis.ai/) — cross-model benchmark aggregation
- 🟡 [LiveBench](https://livebench.ai/) — agentic/coding leaderboards
- 🟡 [LLM Stats](https://llm-stats.com/) — pricing/benchmark aggregation
- 🔴/🟡 [BenchLM.ai — Ornith 1.0 9B](https://benchlm.ai/models/ornith-1-0-9b) — flags exclusion from public leaderboard pending independent verification
- [Ollama model library](https://ollama.com/search)
- [Microsoft — MAI-Code-1-Flash](https://microsoft.ai/models/mai-code-1-flash/)
- [Kimi — K2.7 Code](https://www.kimi.com/resources/kimi-k2-7-code)
- [Matt Pocock — skills repo](https://github.com/mattpocock/skills)
- [Matt Pocock — Sandcastle](https://github.com/mattpocock/sandcastle) / [npm `@ai-hero/sandcastle`](https://www.npmjs.com/package/@ai-hero/sandcastle)
- Local repo files: `README.md`, `docs/llm-routing-strategy.md`, `docs/execution-profiles.md`, `.sandcastle/main.mts`, `.sandcastle/plan-prompt.md`

*Compiled from four parallel background research threads (pricing/benchmarks, local hardware, Pocock skills/Sandcastle, `/fleet` orchestration) plus direct inspection of this repository.*
---END FILE CONTENT---

After creating the file, commit it on a new branch with a clear commit message (e.g. 'docs: add LLM cost strategy knowledge doc'). Do not open a PR unless that's your normal default workflow; do not modify docs/README.md or any other index file. No build/lint/test is needed — this repo has no root lint script and this is a docs-only change.
