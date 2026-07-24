# Chronicle cost tips

## Ranked recommendations

1. **Use `/compact` during genuinely long, continuing research**
   - **Context:** Compaction can stop an oversized history from being sent on every later turn, but resets the prompt cache once.
   - **Problem:** Two extended research/planning sessions reached late-call averages of 142K–144K input tokens, notably *“Review all the main docs…”* and *“prepare a prompt to clean-up worktrees and branches…”*.
   - **Recommended action:** If the investigation remains active after a major milestone, run `/compact` once; avoid it when you are near completion or need the exact prior detail.
   - **Expected impact:** **High** — it targets two sessions totaling 25.3M measured tokens whose late-turn context grew substantially; exact usage supports the pattern.

2. **Match the model to the phase of the work**
   - **Context:** Use the strongest model for ambiguous reasoning and debugging, then switch for mechanical exploration, bulk reading, formatting, and summaries.
   - **Problem:** `gpt-5.6-sol` accounts for 92.8M tokens (62.5%) across measured usage, including research-heavy work with a meaningful mechanical component.
   - **Recommended action:** Start hard reasoning with `gpt-5.6-sol`, but use an available lighter option such as `gpt-5.6-luna`, `claude-haiku-4.5`, or `mai-code-1-flash-picker` for bounded read/search and synthesis phases.
   - **Expected impact:** **High** — changing model selection affects the 92.8M-token majority of measured usage; exact model-use data supports this.

3. **Bound broad research inputs before starting**
   - **Context:** Early pasted material and broad file scope remain available to later turns, so unnecessary material compounds across a long session.
   - **Problem:** *“Fluent UI Skill…”* consumed 58.9M tokens, included seven large messages (up to 34.8K characters), and touched 52 files; this appears to be legitimate deep research, but its scope is large enough to benefit from staging.
   - **Recommended action:** Split future research into a first pass with a named file set or question list, then open a follow-up session only for the selected findings rather than supplying all source material at once.
   - **Expected impact:** **High** — this applies to the single largest session, representing 39.6% of measured tokens; explanation signals are proxy-based.

## Facts about your session data

- **Data source:** mixed analysis from hosted token/model usage and local per-call token usage.
- **Exact usage availability:** available — 148.6M exact tokens across 1.7K usage rows from 14 recent sessions.
- **Scope:** last 14 days; 80 recent candidate sessions, with exact usage for 14.
- **Confidence:** high for measured token and model totals, with bounded coverage because sessions outside the recent candidate pool were not included.
- **Usage concentration:** the top six sessions consumed 137.1M tokens, or 92.3% of the 148.6M measured total; exact usage.
- **Input-token dominance:** 147.4M input versus 1.1M output tokens (130:1); exact usage, though raw input includes cheaper cache reads.
- **Largest session:** *“Fluent UI Skill…”* used 58.9M tokens across 646 usage rows and three models; exact usage.
- **Late context growth:** *“Review all the main docs…”* rose from 93.3K to 142.4K average input tokens late in the session; *“prepare a prompt…”* rose from 61.9K to 144.2K; exact usage.
- **Model concentration:** `gpt-5.6-sol` represented 62.5% of measured tokens; exact usage.

## Profile limitations

The figures are exact for the 14 measured sessions, but discovery was limited to 80 recently active candidates. Large-message and file-churn explanations are correlational proxies, so they indicate useful scope-management opportunities rather than proven waste.
