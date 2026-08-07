# AI-Assisted Development Practices: Detailed Research

**Research date:** 2026-07-25

> Role: dated research snapshot
> Current companion: [knowledge.md](../knowledge.md)
> Resource registry: [resources.md](../resources.md)

## Scope and reading rules

This report expands the concise companion for planning AI-assisted work in
MartiX Skills. It uses only the first-party VS Code, GitHub, Microsoft Learn,
and OpenAI pages listed in the source inventory.

`[Fact]` means the claim is documented by the cited source key.
`[Recommendation]` is a MartiX choice derived from documented facts.
Provider-specific facts remain separate; citations do not imply identical
features or pricing.

## Source keys

- [VSC-BP](https://code.visualstudio.com/docs/agents/best-practices)
- [VSC-CTX](https://code.visualstudio.com/docs/agents/guides/context-engineering-guide)
- [VSC-USG](https://code.visualstudio.com/docs/agents/guides/optimize-usage)
- [VSC-CONTEXT](https://code.visualstudio.com/docs/chat/copilot-chat-context)
- [VSC-MEM](https://code.visualstudio.com/docs/agents/memory)
- [VSC-CACHE](https://code.visualstudio.com/docs/agents/agent-troubleshooting/cache-explorer)
- [VSC-SEC](https://code.visualstudio.com/docs/agents/security)
- [GH-USG](https://docs.github.com/en/copilot/tutorials/optimize-ai-usage)
- [MS-AGENT](https://learn.microsoft.com/en-us/partner-center/marketplace-offers/artificial-intelligence-app-agent-best-practices)
- [OA-LAT](https://developers.openai.com/api/docs/guides/latency-optimization)
- [OA-PRED](https://developers.openai.com/api/docs/guides/predicted-outputs)
- [OA-ACC](https://developers.openai.com/api/docs/guides/optimizing-llm-accuracy)
- [OA-COST](https://developers.openai.com/api/docs/guides/cost-optimization)
- [OA-FLEX](https://developers.openai.com/api/docs/guides/flex-processing)
- [OA-PC](https://developers.openai.com/api/docs/guides/prompt-caching)
- [OA-BATCH](https://developers.openai.com/api/docs/guides/batch)

## Documented facts

### Context engineering and progressive disclosure

- VS Code describes a three-step flow: curate project context, generate and
  review a plan, then implement from it. Context can include concise product,
  architecture, and contribution docs referenced by instructions. [VSC-CTX]
- VS Code says to start small, add detail when errors justify it, and avoid
  context dumping, inconsistent guidance, and over-engineered agent chains.
  Separate context for planning, implementation, and review where useful.
  [VSC-CTX]
- VS Code custom instructions are automatically included in applicable chats.
  Keep them concise and limited to facts the agent cannot infer from code;
  scoped files are preferred for narrower concerns. [VSC-BP] [VSC-CTX]
- VS Code supports project indexing and recommends excluding generated or noisy
  paths. Multi-root workspaces can define clearer boundaries. [VSC-BP] [VSC-USG]
- GitHub says a repository map in `AGENTS.md` or
  `.github/copilot-instructions.md` reduces orientation work. Persistent
  instructions should be short, specific, observed, and current. [GH-USG]

### Prompts and context attachment

- VS Code recommends stating inputs, outputs, constraints, language, framework,
  examples, and acceptance tests. Break complex work into smaller steps,
  iterate with follow-up prompts, and clarify ambiguous requests. [VSC-BP]
- VS Code indexing supplies relevant files; `#`-mentions, the context picker,
  drag and drop, and `#codebase` add files, symbols, tools, terminal output,
  source control, tests, and other context. [VSC-CONTEXT]
- VS Code can attach web pages, images, browser elements, CSS, screenshots, and
  console logs. Browser tools may require settings and page or URL trust.
  [VSC-CONTEXT]
- The VS Code context control reports token and session-credit usage.
  Automatic compaction summarizes older history; `/compact` is manual, and a
  new chat resets context. [VSC-CONTEXT]
- GitHub recommends giving the agent the relevant files, errors, logs, and a
  clear stopping condition up front. A stopping condition helps prevent extra
  commits, unrelated refactoring, and scope growth. [GH-USG]

### Memory and session hygiene

- VS Code local memory has user, repository, and session scopes. User memory
  persists across workspaces, repository memory is workspace-scoped, and
  session memory is temporary. The first 200 lines of user memory are loaded at
  session start. [VSC-MEM]
- VS Code distinguishes its local memory tool from GitHub Copilot Memory.
  Copilot Memory is a separate preview feature, hosted by GitHub, repository
  scoped, shared across several Copilot surfaces, opt-in, and automatically
  expired after 28 days. [VSC-MEM]
- VS Code and GitHub both recommend a new session for unrelated work. For a
  relevant long task, compaction reduces repeated history and keeps the active
  context focused. [VSC-BP] [VSC-USG] [VSC-CONTEXT] [GH-USG]
- VS Code says subagents can isolate research and exploration from the parent
  prompt. GitHub says subagents do not inherit the main conversation and can
  therefore use a cheaper model for a focused task. [VSC-BP] [GH-USG]

### Models, tools, and cost

- VS Code maps lighter models to simple edits and boilerplate, and reasoning
  models to planning, architecture, debugging, and complex refactoring. It
  documents auto model selection, preferred models in agents or prompt files,
  thinking-effort controls, and model cost tiers. [VSC-BP] [VSC-USG]
- GitHub recommends using reasoning models for architecture and complex
  debugging, mid-tier models for execution from a clear plan, and lighter
  models for routine work. It says higher reasoning levels consume more tokens
  and credits. [GH-USG]
- GitHub's auto model selection routes requests based on intent, protects cache
  boundaries by avoiding mid-task model changes, and can route around degraded
  or busy models. Paid plans may receive a documented 10% model-cost discount
  when using that feature. [GH-USG]
- VS Code and GitHub both warn that enabled tools, MCP servers, attachments,
  open tabs, and long histories add context and cost. Both recommend enabling
  only tools relevant to the current task. [VSC-USG] [GH-USG]
- GitHub documents session credit limits as soft per-session controls. They stop
  the agent cleanly at the limit and do not replace account-level budgets or
  spending limits. [GH-USG]

### Prompt caching and Cache Explorer

- VS Code Cache Explorer compares consecutive model requests. It reports cache
  hit percentage, reused input tokens, model and timing, prompt components, and
  the first prefix divergence. [VSC-CACHE]
- VS Code says model, reasoning effort, context size, enabled tools, MCP
  servers, instruction files, or agent definitions changed mid-session can
  rebuild the cache. It recommends stable early instructions and tools, volatile
  attachments later, and subagents for isolated exploration. [VSC-CACHE]
- GitHub documents cached input as typically billed at 10% of normal input price
  and says model, reasoning, context-size, or tool changes can invalidate a
  cache. Its documented cache-expiry examples are 24 hours for OpenAI models
  and one hour for most others. [GH-USG]
- OpenAI Prompt Caching applies automatically to eligible prompts of at least
  1,024 tokens. It matches exact prefixes, including identical tools and image
  details, so static instructions and examples belong before variable content.
  OpenAI reports `cached_tokens` in usage. [OA-PC]
- OpenAI documents `prompt_cache_key` for shared long prefixes and, for GPT-5.6
  and later families, recommends or requires it for more reliable matching.
  OpenAI also documents explicit breakpoints, a default 30-minute minimum TTL
  for that newer family, and model-specific retention controls. These API
  details do not define VS Code's cache behavior. [OA-PC]
- OpenAI says cached prompts do not change output generation, do not guarantee
  identical nondeterministic responses, and still count toward TPM limits.
  Cache writes on GPT-5.6 and later are billed at 1.25 times the uncached input
  rate; earlier-model write fees differ. [OA-PC]

### Latency, Predicted Outputs, Batch, and Flex

- OpenAI's latency guidance groups the main levers as processing tokens faster,
  generating fewer tokens, using fewer input tokens, making fewer requests,
  parallelizing independent work, streaming progress, and replacing an LLM
  with deterministic logic when suitable. [OA-LAT]
- OpenAI notes that output-token reduction usually has a larger latency effect
  than ordinary prompt reduction, while large contexts can make input reduction
  more important. It recommends testing whether combining requests, splitting
  them, or parallelizing them improves the real workload. [OA-LAT]
- OpenAI Predicted Outputs target mostly unchanged regenerated text or code.
  Rejected prediction tokens remain billable, and function calling, audio,
  non-text modalities, `max_completion_tokens`, and several other parameters
  have documented limitations. Supported model families are explicitly listed
  by OpenAI and must be checked before adoption. [OA-PRED]
- OpenAI Batch is asynchronous, supports documented API endpoints, requires
  JSONL input with unique `custom_id` values, and has a 50% discount relative to
  synchronous APIs. The completion window is currently 24 hours; a batch can
  contain up to 50,000 requests and a 200 MB input file. [OA-BATCH]
- Batch results can finish out of input order, so consumers must join by
  `custom_id`. Completed output files are deleted after 30 days, and expired
  batches still charge completed requests. [OA-BATCH]
- OpenAI Flex lowers cost in exchange for slower processing and occasional
  unavailability. It is positioned for evaluations, enrichment, and other
  non-production or lower-priority asynchronous work. A `429 Resource
  Unavailable` response is not charged; clients can retry with backoff or
  standard processing. [OA-FLEX]

### Accuracy, evaluation, and verification

- VS Code says generated code remains a starting point: review edits, inspect
  edge cases and assumptions, run tests, and check for security issues. It
  recommends including expected outputs or tests in the prompt. [VSC-BP]
- GitHub describes tests, linters, and security scans as deterministic signals
  that prevent small agent errors from compounding. [GH-USG]
- OpenAI recommends starting with a simple prompt and expected output, then
  evaluating a representative set of questions and ground-truth answers before
  moving to more complex optimization. It describes evaluation as a repeated
  cycle of hypothesis, change, evaluation, and reassessment. [OA-ACC]
- OpenAI separates context problems from behavior problems. Retrieval or other
  context optimization addresses missing, stale, proprietary, or wrong
  knowledge; prompt engineering or fine-tuning addresses inconsistent behavior,
  style, format, or reasoning adherence. Retrieval can fail by returning wrong
  or excessive context, so it needs its own evaluation. [OA-ACC]
- Microsoft Learn recommends grounding responses, filtering incorrect output,
  and enforcing required tool flows programmatically rather than relying only
  on instructions. It also recommends automated tests, security analysis, and
  AI-safety checks in CI. [MS-AGENT]
- Microsoft Learn recommends prompt and model versioning with rollback,
  resilient API calls, observability, staged deployment, and tests for outage or
  slow-service scenarios in AI marketplace applications. [MS-AGENT]

### Hooks, deterministic automation, and trust

- VS Code agent hooks run shell commands at lifecycle points and are described
  as deterministic enforcement, unlike instructions and prompts. `PreToolUse`
  hooks can allow, deny, or ask before a tool invocation, block dangerous
  commands, and create audit trails. [VSC-SEC]
- VS Code's security baseline is to use Restricted Mode for untrusted projects,
  review diffs before accepting edits, protect sensitive-file globs, scope
  auto-approval to the session, and review MCP servers before trusting them.
  [VSC-SEC]
- VS Code identifies workspace, extension publisher, MCP server, and network
  domain trust as distinct boundaries. Built-in agents are workspace-limited;
  background agents use a separate worktree; and MCP credentials use the secure
  credentials store. [VSC-SEC]
- VS Code states that sandboxing provides stronger protection against malicious
  terminal commands than auto-approval rules, whose command parsing is
  best-effort and limited by shell syntax. The documented agent terminal
  sandbox is available on macOS and Linux, including WSL2, not native Windows.
  [VSC-SEC]
- VS Code calls prompt injection a security risk and recommends isolation or
  sandboxing when untrusted content may influence an agent. It also documents
  enterprise controls that can disable agents, restrict MCP sources, disable
  global auto-approval, or require manual approval for selected tools. [VSC-SEC]

## MartiX recommendations

These are repository choices, not claims that every listed provider supports
identical implementation mechanisms.

1. **Keep context layered.** Keep root instructions and package `SKILL.md`
   files short and routing-oriented. Put durable detail in package-local rules,
   references, and templates; attach only the slice needed for the task.
   [VSC-CTX] [VSC-BP] [GH-USG]
2. **Use explicit phases.** Separate research, plan, implementation, and
   verification. Pass a compact plan into implementation and use a fresh or
   compacted session when the previous phase has accumulated noise. [VSC-CTX]
   [VSC-USG] [GH-USG]
3. **Make memory conservative.** Store stable repository facts in repository
   memory and temporary decisions in session notes. Avoid secrets, stale
   incident detail, and duplicate copies of package rules. [VSC-MEM]
4. **Design prompts for verification.** Every implementation request should
   name the owned files, expected behavior, stopping condition, and focused
   validation command. Treat the resulting diff and test output as evidence.
   [VSC-BP] [GH-USG]
5. **Use model and tool budgets.** Reserve stronger reasoning for architecture,
   planning, and difficult diagnosis. Use cheaper focused subagents for search,
   routine documentation, or deterministic cleanup. Keep MCP/tool exposure
   task-scoped. [VSC-USG] [GH-USG]
6. **Measure before optimizing cache.** Keep stable instructions, tool sets, and
   model settings at the front of repeated sessions. Use VS Code Cache Explorer
   for Copilot sessions; use OpenAI usage fields only for OpenAI API workloads.
   [VSC-CACHE] [OA-PC]
7. **Choose async economics deliberately.** Use Batch or Flex only for work
   that tolerates delayed results and provider-specific failure handling. Use
   Predicted Outputs only for mostly unchanged OpenAI text or code and measure
   rejected prediction tokens. [OA-BATCH] [OA-FLEX] [OA-PRED]
8. **Keep enforcement outside the model.** Add Markdown, manifest, schema,
   eval, security, and repository checks to hooks or CI. Use programmatic
   allowlists and approvals for risky tool paths; instructions alone are not a
   security boundary. [VSC-SEC] [GH-USG] [MS-AGENT]
9. **Treat external content as untrusted.** Review MCP configuration and tools,
   limit network and file access, isolate background work, and require human
   review for changes affecting hooks, prompts, MCP, credentials, or release
   automation. [VSC-SEC]

## Prioritized MartiX implementation backlog

Priority is ordered by risk reduction and reuse across packages.

- **P0: Context contract.** Define a compact root map, package routing rules,
  phase handoff, stopping condition, and validation checklist.
  Measure prompt size and repeated corrections on representative tasks.
- **P0: Deterministic repository gate.** Expand validation with
  focused checks for Markdown, package identity, links, eval schema, and changed
  artifact boundaries. Make the pass/fail output easy for agents to consume.
- **P0: Trust baseline.** Document MCP review, sensitive-file approval, hook
  review, external-content handling, and Windows-specific isolation limits.
  Keep destructive operations behind explicit approval and deterministic checks.
- **P1: Evidence-backed eval lane.** Create small positive, negative, and
  regression cases for skill activation and expected behavior. Keep a holdout
  set, record model and prompt versions, and compare failures before changing
  instructions. [OA-ACC] [MS-AGENT]
- **P1: Session and memory hygiene.** Define what belongs in repository memory,
  session notes, package docs, and research snapshots. Add a lightweight stale
  context review instead of growing always-on instructions. [VSC-MEM]
- **P1: Usage observability.** Record task class, model choice, tool count,
  validation result, latency, and rework without recording secrets. For Copilot,
  inspect Agent Debug Logs and Cache Explorer; do not infer OpenAI API pricing
  from Copilot metrics. [VSC-CACHE] [VSC-USG]
- **P2: Async research pipeline.** Prototype Batch for offline eval or link
  classification and Flex for explicitly low-priority experiments only after
  result joining, retries, expiration, and budget behavior are tested.
  [OA-BATCH] [OA-FLEX]
- **P2: Controlled regeneration.** Evaluate Predicted Outputs only in an OpenAI
  API adapter for near-regeneration tasks. Gate it on model support, measure
  accepted versus rejected tokens, and retain a normal path for unsupported
  tool-calling workflows. [OA-PRED]

## Planning cautions

- A VS Code cache hit, a GitHub Copilot cached-input charge, and OpenAI Prompt
  Caching are related concepts but different provider surfaces. Do not use one
  metric or retention rule as a universal cost model. [VSC-CACHE] [GH-USG]
  [OA-PC]
- Microsoft Learn's marketplace guidance is application architecture advice;
  it does not define VS Code hook semantics, GitHub Copilot credit accounting,
  or OpenAI API parameters. [MS-AGENT]
- Model names, availability, pricing, cache retention, and preview status can
  change. Re-check the keyed official pages before implementation and record
  the retrieval date in any decision record.
