**Ranked recommendations**

1. **Make `SKILL.md` a router, not a handbook**
   - **Context:** Reusable technical guidance belongs in the skill, but only the narrow route for the current task should enter the active context.
   - **Problem:** The largest sessions grew from 52.0K to 120.1K average input tokens in late calls, and the existing package still repeats routing and application guidance across `SKILL.md`, `AGENTS.md`, and reference material.
   - **Recommended action:** Keep `SKILL.md` to activation, compatibility, the domain table, two handoffs, and a short universal guardrail list; keep `AGENTS.md` as the deep companion; load one map and its linked rule by default; move only truly universal repository conventions to a narrowly scoped C# instruction file, while putting task-specific requirements in the prompt or planner contract.
   - **Expected impact:** **High.** This reduces repeated fresh context on the sessions with the clearest growth signal; the measured late-call input increase is exact usage, although the profile cannot separate cache reads from cache misses.

2. **Use a max planner, a medium skill-guided implementer, and targeted verification**
   - **Context:** Max effort has the highest leverage when it resolves ambiguity and defines invariants; bounded implementation work does not need the entire planning history.
   - **Problem:** The 4+4 static review showed that the medium skill-guided implementation was the best medium result, while additional LSP or hybrid aids did not prevent simple defects such as missing uniqueness invariants, mutable snapshots, or permissive ISBN normalization. The measured profile also shows 83.6% of tokens concentrated in six sessions.
   - **Recommended action:** Have `gpt-5.6-luna` max produce a short implementation contract containing the target baseline, file manifest, API/error matrix, concurrency invariants, non-goals, and acceptance cases; give only that contract plus the selected skill route to a `gpt-5.6-luna` medium implementer; use C# LSP after concrete symbols exist; run build/tests directly; reserve a second max review for public API, concurrency, security, or failed verification.
   - **Expected impact:** **High.** It replaces repeated full-context generation with one bounded planning pass and a smaller implementation context, targeting the majority of measured usage concentrated in the top sessions; savings depend on keeping the contract short.

3. **Add a compact web/API invariant gate instead of adding more prose to the skill**
   - **Context:** The benchmark defects were mostly missed acceptance conditions, not a lack of framework vocabulary.
   - **Problem:** Across the 4+4 artifacts, the important misses were concrete: atomic uniqueness and deletion decisions, immutable read snapshots, valid ISBN normalization, exact response statuses, and testable cancellation/concurrency behavior. The benchmark intentionally skipped compilation and tests, and one large session also showed 201 PowerShell calls, which is useful proxy evidence for avoidable iteration.
   - **Recommended action:** Add one short, web-route-only checklist or template that requires the planner and implementer to map each invariant to code and a focused test; run `dotnet build` plus those tests before asking max to review, and send the reviewer the contract, diff, and diagnostics rather than the whole history.
   - **Expected impact:** **Medium to high.** It prevents expensive retry and review loops by catching high-impact defects before another large-model pass; the tool-churn signal is proxy evidence, so treat it as supporting rather than causal.

**Facts about your session data**

- **Data source:** Mixed analysis: hosted synced token/model usage plus local exact per-call usage from `assistant_usage_events`.
- **Exact usage availability:** Available for 15 of 80 recent candidate sessions, totaling 184.7M exact tokens across about 2.0K usage rows; 182.8M were input tokens and 1.9M were output tokens.
- **Scope:** The last 14 days, bounded to the 80 most recently active candidate sessions; the run was unscoped, with no `--org` or `--repo` filter and therefore no repository-specific breakdown.
- **Confidence:** Token and model totals are exact for the measured candidate sessions, while session discovery is bounded and behavioral explanations such as tool churn are correlational proxies.
- **Top-session concentration:** The six largest labeled sessions account for 154.3M tokens, or 83.6% of the measured total; this is exact usage and is why workflow shape matters more than micro-optimizing small sessions.
- **Context growth:** The two `Designing fleet prompt` sessions grew from 52.0K to 120.1K average input tokens in late calls; this is the strongest direct evidence for reducing repeated active context.
- **Model mix:** `gpt-5.6-luna` accounts for 135.0M tokens, or 73.1%, across 15 sessions; it is already in the lowest listed price tier, so the evidence supports effort/task routing rather than claiming savings from a cheaper model switch.
- **Tool churn:** `Designing fleet prompt` included 201 PowerShell calls and touched 17 files in one session; this is proxy evidence and may include legitimate exploration, so it supports a narrower working set and deterministic gates rather than a blanket ban on tools.
- **Implementation review:** The last four xhigh/max-requested and four medium C# API artifacts were reviewed statically. Medium skill-guided was the strongest medium result; the earlier xhigh skill-guided result was strongest overall as delivered, but neither effort level eliminated the need for invariant review.
- **Saved report:** `C:\Users\marti\.copilot\session-state\d29b6c6f-ea75-425b-bec9-1aa06860731c\files\martix-dotnet-csharp-cost-and-workflow-recommendations.md`

**Profile limitations**

- **Coverage limitation:** Exact usage was available for only 15 of the 80 recent candidates, and the candidate pool was recent-session-pruned; usage outside that pool is not counted.
- **Pricing limitation:** The profile has no currency conversion, AI-credit price, cache-hit/miss breakdown, or request multiplier, so token reductions cannot be translated into a dollar estimate.
- **Quality limitation:** The 4+4 implementation comparison is a static artifact review. The benchmark did not compile or test the generated APIs, so the recommended verification gate is necessary before treating quality rankings as production evidence.
