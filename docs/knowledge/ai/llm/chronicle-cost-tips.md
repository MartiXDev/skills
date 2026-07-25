# Chronicle research - Tips and Cost Tips

## Tips

**Biggest gap:** you already use advanced features a lot — skills, subagents, research flows, repo-local skill packs — but you still inline too much durable context and you default to heavyweight agent shapes more often than you need.

1. **Move repeated lane/repo rules out of prompts and into repo instructions**
   - In recent `pnj-demo` sessions, your `/implement` openers were long and repetitive: the issue #6/#7 prompts repeated the same lane path, branch, “don’t touch other worktrees,” validation, and commit rules across 1.6K–3.5K character messages.
   - Your `skills` repo already uses `.github/copilot-instructions.md` and `.github/instructions/*.instructions.md`, but `pnj-demo` has no `.github` instruction layer.
   - **Use that same pattern in `pnj-demo`**: put stable lane/worktree safety rules in `.github/copilot-instructions.md`, and split backend/frontend/docs behavior into path-scoped `.instructions.md` files. Then keep the live prompt to the issue number, acceptance criteria delta, and any one-off constraint.

2. **Stop pasting large static artifacts when a file reference would do**
   - You already sometimes work this way (`@file:README.md` showed up in a recent session), but it’s inconsistent.
   - Two recent sessions show the cost of inlining: one pasted **14.3K chars** of orchestrate skill context into *“Designing fleet prompt”*; another pasted **35.4K chars** of verbatim Markdown just to create one docs file.
   - **Default to references, not pastes**: if the content already exists in the repo, point to `@file:` or the path and tell the agent what to do with it. Reserve inline pastes for genuinely new content that is not already stored anywhere.

3. **Use `task` and `explore` agents more aggressively; save `general-purpose` for real ambiguity**
   - Your recent subagent launches were heavily skewed: **62 `general-purpose`**, **8 `research`**, **4 `task`**, and effectively no `explore`.
   - That doesn’t match the actual workload mix, which included huge amounts of command/search/read behavior: **1,141 `view`**, **748 `powershell`**, **314 `web_fetch`**, **128 `rg`** calls.
   - **Tighten the match between work and agent type**: use `explore` for reconnaissance and cross-file reading, `task` for build/test/lint/command-heavy runs, and keep `general-purpose` for implementation, debugging, and orchestration logic. You’ll get cleaner outputs and less main-session sprawl.

4. **Add a pre-edit “environment handshake” to lane prompts**
   - One `/implement` session started in the wrong worktree, then immediately needed an abort turn and a separate status-report turn.
   - That’s a prompt-shape problem more than a coding problem.
   - **Front-load a 4-line self-check** before any edits: repo path, branch, issue number, allowed write scope. Instruct the agent to stop and report mismatch instead of proceeding. This is especially worth it in your multi-lane `pnj-demo-fleet` workflow.

5. **Turn your recurring meta-work into scheduled workflows**
   - You have **no saved workflows**, but your recent sessions clearly repeat the same meta tasks: `/chronicle cost-tips`, LLM-routing/cost-strategy research, branch/PR chores, and repo sweeps.
   - That’s exactly the kind of work that benefits from recurring automation instead of ad hoc sessions.
   - **Create 1–2 scheduled workflows**: for example, a weekly cost/usage coaching run on your `skills` repo, and a nightly docs/routing drift check. This is a better fit than re-prompting the same maintenance task manually.

A useful pattern across all five: keep **stable rules in repo artifacts**, keep **session prompts short and delta-focused**, and choose the **smallest capable agent shape** for the job. That matches how you already work with skills, but removes the remaining repetition.

## Cost Tips v1

### Ranked recommendations

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

### Facts about your session data

- **Data source:** mixed analysis from hosted token/model usage and local per-call token usage.
- **Exact usage availability:** available — 148.6M exact tokens across 1.7K usage rows from 14 recent sessions.
- **Scope:** last 14 days; 80 recent candidate sessions, with exact usage for 14.
- **Confidence:** high for measured token and model totals, with bounded coverage because sessions outside the recent candidate pool were not included.
- **Usage concentration:** the top six sessions consumed 137.1M tokens, or 92.3% of the 148.6M measured total; exact usage.
- **Input-token dominance:** 147.4M input versus 1.1M output tokens (130:1); exact usage, though raw input includes cheaper cache reads.
- **Largest session:** *“Fluent UI Skill…”* used 58.9M tokens across 646 usage rows and three models; exact usage.
- **Late context growth:** *“Review all the main docs…”* rose from 93.3K to 142.4K average input tokens late in the session; *“prepare a prompt…”* rose from 61.9K to 144.2K; exact usage.
- **Model concentration:** `gpt-5.6-sol` represented 62.5% of measured tokens; exact usage.

### Profile limitations

The figures are exact for the 14 measured sessions, but discovery was limited to 80 recently active candidates. Large-message and file-churn explanations are correlational proxies, so they indicate useful scope-management opportunities rather than proven waste.

## Cost Tips v2

### Ranked recommendations

1. **Compact long fleet-design sessions at a real milestone**
   - **Context:** Compaction can prevent a long, single-topic history from being resent on every later turn, though it resets the cache once.
   - **Problem:** The two *“Designing fleet prompt”* sessions grew from roughly 50K to 120K average input tokens late in the session and together used 55.6M tokens.
   - **Recommended action:** After the model list, orchestration contract, and lane rules are settled, run `/compact` before continuing with implementation or refinement; avoid it near the session’s end.
   - **Expected impact:** **High** — targets 34.2% of measured usage by reducing repeated late-session context; exact usage supports the growth signal.

2. **Use a two-pass working set for fleet prompts**
   - **Context:** Separating discovery from authoring keeps exploratory command output from becoming permanent context for later prompt edits.
   - **Problem:** *“Designing fleet prompt”* included 167 PowerShell calls and touched 13 files, indicating substantial exploration around what was ultimately a prompt-design task; this is proxy evidence.
   - **Recommended action:** First ask for a bounded inventory of only the orchestrator, model configuration, and relevant skill files; then start the authoring pass from that inventory with an explicit “do not inspect beyond this set” boundary.
   - **Expected impact:** **Medium** — can reduce repeated exploration in a 27.6M-token session, though the churn signal is proxy-based and may reflect legitimate orchestration work.

3. **Keep exact-content file creation out of the conversational context**
   - **Context:** Large inline payloads are resent as conversation context, while a checked-in source file or concise patch instruction is easier to reuse.
   - **Problem:** The session *“Create exactly one new file: docs/knowledge/llm-cost-strategy.md…”* contained a 35.4K-character message; although the verbatim content was legitimate, it is a sizable one-turn input.
   - **Recommended action:** For future exact document transfers, place the source content in a file or attachment first and ask the agent to copy it byte-for-byte into the target path.
   - **Expected impact:** **Low to medium** — reduces oversized prompt payloads for similar documentation tasks; this is primarily proxy evidence and the current artifact may have required the inline form.

### Facts about your session data

- **Data source:** mixed analysis from hosted token/model usage and local per-call token usage.
- **Exact usage availability:** available — 162.6M exact tokens across 1.9K usage rows and 35 measured sessions.
- **Scope:** last 14 days; 80 recent candidate sessions, unscoped by repository.
- **Confidence:** high for measured token, session, and model totals, with bounded coverage because older or less recently active sessions may be excluded.
- **Usage concentration:** the top six sessions consumed 121.4M tokens, or 74.7% of measured usage; exact usage.
- **Model mix:** GPT-5.4 mini and MAI-Code-1-Flash together accounted for 108.1M tokens (66.4%); exact usage, so there is no lower price tier available to recommend as a broad model switch.
- **Context growth:** both *“Designing fleet prompt”* sessions reached approximately 120K average input tokens late in their runs; exact usage.
- **Tool churn:** one *“Designing fleet prompt”* session made 167 PowerShell calls and touched 13 files; proxy evidence.
- **Input dominance:** 160.6M input versus 2.0M output tokens (80:1); exact usage, but raw input includes cheaper cache reads.

### Profile limitations

The measured totals are exact for the discovered candidate sessions, but the candidate pool is bounded to 80 recently active sessions. Tool-call churn and large-message observations are correlational proxies, so they identify workflow opportunities rather than proving avoidable waste.
