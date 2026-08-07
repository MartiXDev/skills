# AI-Assisted Development Practices

> Role: current knowledge synthesis
> Sources: [resources.md](./resources.md)
> Evidence snapshot: [2026-07-25 research](./research/2026-07-25-ai-assisted-development.md)

## Scope

Primary-source synthesis for planning AI-assisted development in MartiX Skills.
Facts summarize official guidance; recommendations adapt it to this repository.

## Source keys

- [VSC-BP] <https://code.visualstudio.com/docs/agents/best-practices>
- [VSC-CTX]
  <https://code.visualstudio.com/docs/agents/guides/context-engineering-guide>
- [VSC-USG]
  <https://code.visualstudio.com/docs/agents/guides/optimize-usage>
- [VSC-CONTEXT] <https://code.visualstudio.com/docs/chat/copilot-chat-context>
- [VSC-MEM] <https://code.visualstudio.com/docs/agents/memory>
- [VSC-CACHE]
  <https://code.visualstudio.com/docs/agents/agent-troubleshooting/cache-explorer>
- [VSC-SEC] <https://code.visualstudio.com/docs/agents/security>
- [GH-USG] <https://docs.github.com/en/copilot/tutorials/optimize-ai-usage>
- [MS-AGENT]
  <https://learn.microsoft.com/en-us/partner-center/marketplace-offers/artificial-intelligence-app-agent-best-practices>
- [OA-LAT]
  <https://developers.openai.com/api/docs/guides/latency-optimization>
- [OA-PRED]
  <https://developers.openai.com/api/docs/guides/predicted-outputs>
- [OA-ACC]
  <https://developers.openai.com/api/docs/guides/optimizing-llm-accuracy>
- [OA-COST]
  <https://developers.openai.com/api/docs/guides/cost-optimization>
- [OA-FLEX]
  <https://developers.openai.com/api/docs/guides/flex-processing>
- [OA-PC]
  <https://developers.openai.com/api/docs/guides/prompt-caching>
- [OA-BATCH] <https://developers.openai.com/api/docs/guides/batch>

## Documented facts

### Context and progressive disclosure

- VS Code recommends concise project context, a separate implementation plan,
  and code generation from that plan. [VSC-CTX] [VSC-BP]
- Start with minimal high-level context and add detail only when errors justify
  it. Context dumping and unnecessary agent chains are anti-patterns. [VSC-CTX]
- Always-on instructions should be concise, scoped, and specific to facts the
  model cannot infer from code. [VSC-BP] [GH-USG]

### Prompt, context, and memory hygiene

- Explicit context can include files, folders, symbols, terminals, source
  control, browsers, images, and web references. [VSC-CONTEXT] [VSC-BP]
- Long sessions increase cost and can degrade quality. Use a new session for
  unrelated work and compact a relevant long thread. [VSC-BP] [VSC-USG]
  [VSC-CONTEXT] [GH-USG]
- VS Code has user, repository, and session memory scopes. Keep persistent
  memory small and high-signal. [VSC-MEM]

### Models, tools, and cost

- Match model capability to task complexity: use stronger reasoning for
  planning, debugging, and architecture; lighter models for routine work.
  [VSC-BP] [VSC-USG] [GH-USG]
- GitHub documents automatic model selection and natural cache boundaries as
  cost controls. [GH-USG]
- Unnecessary tools and MCP servers increase context size and credit use.
  Expose only what an agent needs. [VSC-BP] [VSC-USG]

### Caching, latency, and batch work

- Prompt caching requires exact prefix reuse. Keep stable instructions and
  tools early and volatile content late. [VSC-CACHE] [GH-USG] [OA-PC]
- Cache Explorer shows prompt divergence and cache-hit percentages. [VSC-CACHE]
- OpenAI's latency levers include faster models, fewer tokens, fewer requests,
  parallelization, streaming, and deterministic logic instead of an LLM where
  possible. [OA-LAT]
- Predicted Outputs can reduce latency for mostly unchanged regenerated text;
  rejected prediction tokens are still billed and tool calling is unsupported.
  [OA-PRED]
- OpenAI Batch targets asynchronous workloads such as evals and classification,
  with a documented 50% cost discount. [OA-BATCH] [OA-COST]
- Flex processing trades latency and occasional `429` responses for lower cost;
  it suits lower-priority asynchronous work. [OA-FLEX] [OA-COST]
- Microsoft recommends semantic and retrieval-result caching with explicit
  invalidation where stale data is risky. [MS-AGENT]

### Accuracy and verification

- Include expected outputs or tests in prompts and review AI-generated changes.
  [VSC-BP]
- OpenAI recommends prompt engineering plus an evaluation set before retrieval
  or fine-tuning. [OA-ACC]
- Retrieval addresses missing or stale knowledge; fine-tuning addresses repeated
  behavior or format inconsistency. [OA-ACC]
- Guardrails should include grounding, hallucination filtering, and programmatic
  enforcement of required tool flows. [MS-AGENT]

### Automation and security

- Unit tests, linters, and security scans provide deterministic guardrails for
  non-deterministic agent workflows. [GH-USG]
- VS Code hooks can block dangerous operations, require approval, and create
  audit trails; use them for enforcement rather than guidance. [VSC-SEC]
- For untrusted repositories, use restricted mode or sandboxing, review edits,
  scope approvals to the session, and review MCP servers before trusting them.
  [VSC-SEC]
- Prompt injection is a first-class risk. Sandboxing is stronger protection than
  auto-approval rules, which are best-effort and shell-sensitive. [VSC-SEC]

## Recommendations for MartiX Skills

1. Keep root instructions, package guidance, and task context layered and small;
   link to deeper research instead of embedding it. [VSC-CTX] [VSC-BP]
   [GH-USG] [OA-PC]
2. Separate substantial work into research, plan, implement, and verify phases.
   Use a fresh or compacted handoff between phases when useful. [VSC-CTX]
   [VSC-USG] [GH-USG]
3. Keep persistent memory for stable repository facts. Store volatile task state
   in session notes. [VSC-MEM]
4. Keep recurring prompt prefixes stable and use Cache Explorer before changing
   models, tools, or instructions to fix unexplained cost. [VSC-CACHE] [OA-PC]
5. Expose only the tools needed for the current package slice; isolate research
   and exploration in subagents where appropriate. [VSC-BP] [VSC-USG]
6. Run focused package checks before repository validation. Keep enforcement in
   hooks and CI, not only in instructions. [GH-USG] [VSC-SEC] [MS-AGENT]
7. Default to narrow approvals and isolation for hooks, prompts, MCP configuration,
   generated automation, and external content. [VSC-SEC]
8. Reserve Batch and Flex for asynchronous automation, and Predicted Outputs for
   near-regeneration of mostly unchanged files. [OA-BATCH] [OA-FLEX] [OA-PRED]

## Planning priorities

- Keep root instructions and package `SKILL.md` files short and routing-oriented.
- Encode plan, implementation, and validation phases in agent guidance and hooks.
- Exclude generated and noisy paths from search and indexing inputs.
- Inspect expensive sessions with usage views or Cache Explorer before broad
  model or instruction changes.
- Add deterministic checks around prompts, instructions, hooks, manifests, and
  eval assets.

**Bottom line:** concise layered context, phase separation, right-sized models,
small toolsets, stable cache prefixes, deterministic checks, and strict trust
boundaries are the converging themes across the official guidance.
