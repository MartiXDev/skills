# LLM Cache Strategy

## The physics: prompt caching works the same way everywhere

Claude (Copilot's default), OpenAI (Codex/GPT models), all bill a **cached prefix** far cheaper than fresh tokens (~90% off on Claude/Copilot, ~50-90% on OpenAI) — but *only* if the prefix is byte-identical to a prior call. That single fact drives most of the strategy below.

**Rules that follow directly:**

- Static stuff first (system prompt, instructions, tool/MCP schemas), variable stuff last (your question, file diffs).
- **Never change model, reasoning level, or enabled tools/MCP servers mid-session** — each is a cache-buster that forces a full re-bill of the whole context. Decide these before you start, keep them fixed for the session.
- Don't let sessions sit idle too long (cache TTL ≈1h most models, 24h OpenAI) — resume soon or start fresh instead of reviving a cold session.

## Reasoning effort

- Default to **auto/medium**. Reserve high/xhigh for architecture, gnarly debugging, multi-file refactors.
- Use low/minimal for boilerplate, formatting, docs, mechanical fixes.
- Best pattern: **plan once with high reasoning, then implement with a cheap/mid model** (Copilot CLI: `/plan`; separate the phases into different sessions so the expensive reasoning doesn't get resent every turn).

## Model choice

- "Auto" model selection (Copilot) routes to the cheapest sufficient model, only swaps at cache-safe boundaries, and gets a 10% discount.
- Run sub-agents/exploration on cheap models — they don't inherit the parent's cache anyway, so there's no downside.

## Skills & MCP — same principle: only load what you'll use

- Each enabled skill/MCP tool schema is resent on **every turn**, whether you use it or not. That's pure fixed overhead.
- Enable narrow toolsets, not `all` (e.g., GitHub MCP defaults to `repos, issues, pull_requests` — leave it there unless a task needs more).
- Prefer several small, focused skills over one giant catch-all skill; disable MCP servers not needed for the current repo/task.

## Yes — template your repeating tasks

Don't retype long instructions each time. Bake recurring work into **stable, reusable artifacts** instead of prose you rewrite per-session:

- `AGENTS.md` / `.github/copilot-instructions.md`: build/test/lint commands, conventions, known pitfalls — short and concrete, not generic filler (it's resent every turn, so bloat costs you forever).
- Custom slash-commands/skills for repeated flows (commit-message format, PR-description template, test-writing checklist, review checklist).
- This also *helps* caching — a short, stable instructions file is a perfect cacheable prefix; a different hand-written paragraph each time is not.

## Session hygiene

- New session per unrelated task (`/new`/`/clear`), not one giant thread.
- `/compact` a long-but-still-relevant thread instead of letting it grow forever.
- Add tests/linters as guardrails — the biggest silent cost is an agent compounding errors across retries; deterministic checks cut that off early.
- Copilot CLI: `/context` to see what's eating tokens, `/chronicle cost-tips` to get personalized waste reports.

## Combined strategy (in order)

1. Write a tight AGENTS.md/copilot-instructions.md once.
2. Enable only needed skills/MCP toolsets for this repo.
3. Pick model + reasoning per phase: high reasoning to plan (short, rare) → cheap/auto model to implement (bulk of tokens) → verify with tests.
4. Keep model/reasoning/tools **fixed** for the whole session.
5. New session per task; `/compact` instead of infinite scrollback.
6. Template recurring prompts instead of freehand retyping.
7. Periodically check `/chronicle cost-tips` and prune what it flags.

This combination (stable cacheable context + right-sized model/reasoning + lean tools + short reusable prompts) compounds — each piece alone saves 10-30%, together they're the difference between cheap and expensive agentic usage.
