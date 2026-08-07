# Repository context

MartiX Skills builds evidence-backed capabilities that remain reliable across
model tiers, then uses the cheapest model that clears explicit quality and
safety floors.

## Core concepts

- **Agent:** Model-driven task executor that gathers context, chooses actions,
  invokes tools, and iterates toward a goal.
- **Agentic loop:** Gather context, act, observe results, verify, and correct.
- **Agentic harness:** Runtime around the model that supplies context, tools,
  permissions, execution, and lifecycle behavior.
- **Context window:** Bounded working input available to a model, including
  instructions, files, tool results, skills, and conversation history.
- **Compaction:** Summarization of older conversation material to continue work
  within the context window.
- **Prompt:** Input presented to a model for a response or action.
- **Instruction:** Guidance that shapes model behavior; it is not enforcement.
- **Model:** Inference component that interprets input and produces text,
  structured output, reasoning, or tool calls.
- **Token:** Model-processing unit; it is not equivalent to a word or the full
  context window.
- **Context engineering:** Selecting, ordering, compressing, retrieving,
  isolating, and validating information supplied to a model.
- **Prompt caching:** Reuse of an identical prompt prefix for lower repeated
  processing cost and latency. It is not memory or semantic learning.

## Artifacts and execution

- **Skill:** Reusable instructions, knowledge, and optional resources. Agent
  Skills uses `SKILL.md` and progressive disclosure.
- **Progressive disclosure:** Load metadata first, instructions when activated,
  and supporting resources only when needed.
- **Standalone skill:** MartiX implementation under `skills/martix-*`. Its
  behavior lives in `SKILL.md`, package docs, rules, references, templates,
  assets, metadata, and evals.
- **Plugin:** Distributable bundle that may contain skills, agents, hooks, MCP,
  LSP, settings, and related components.
- **Plugin bundle:** MartiX implementation under `plugins/martix-*`; it composes
  workflow assets while reusable domain knowledge stays in skills.
- **Router:** MartiX pattern: a compact `SKILL.md` entrypoint that decides
  activation and points to the smallest relevant detail.
- **Workflow:** Repeatable task sequence controlled by orchestration logic;
  skills provide guidance, while workflows control phases and branching.
- **Hook:** Automation triggered by a lifecycle event, such as before or after
  a tool call. Hooks can enforce deterministic checks.
- **Tool:** Callable capability that retrieves information or performs an
  external action.
- **MCP:** Model Context Protocol, an open protocol for connecting AI
  applications to tools, data, resources, and prompts.
- **MCP server:** MCP participant that exposes tools, resources, or prompts;
  it is not the same thing as one exposed tool.
- **Subagent:** Delegated model-driven worker with an isolated context that
  reports a result to a parent agent.
- **Verification loop:** Inspect results, run focused checks, compare with
  requirements, and correct failures.

## Evaluation and governance

- **Eval:** Structured test of activation and expected behavior for an agent or
  skill.
- **Canonical eval:** The one committed `skills/<package>/evals/evals.json`,
  containing behavior and positive/negative activation cases.
- **Trigger scenario:** Eval prompt testing whether a skill should activate; it
  belongs in canonical evals.
- **Benchmark input:** Temporary tool input; it does not redefine repository
  eval conventions.
- **Model eval wave:** Dated comparison using the same commit, fixtures, tools,
  scoring, and repeated trials.
- **Capability gate:** Required model capability, such as context, tools, or
  structured output.
- **Quality floor:** Minimum repeated task-quality result for a lane.
- **Safety floor:** Non-compensable safety requirement. Cost cannot offset
  failure.
- **Cheapest capable model:** Lowest-total-cost model that clears capability,
  quality, safety, and variance gates for a dated lane.
- **Package:** One standalone skill or plugin bundle. Keep package edits within
  its directory when possible.
- **Coordinator-owned:** Shared surface whose concurrent edits affect packages
  or worktrees; serialize changes.
- **Completion signal:** `powershell -ExecutionPolicy Bypass -File
  .\\scripts\\validate-repository.ps1`, plus focused checks.
- **Document role:** `normative`, `operational`, `reference`, `research`,
  `roadmap`, or `historical`.
- **Research snapshot:** Immutable dated evidence; newer findings belong in a
  new snapshot or labeled errata.

## MartiX integrations

- **MartiX Skills:** This GitHub Copilot CLI marketplace.
- **Matt Skills:** External planning workflow for specifications,
  dependency-aware tickets, implementation, and review.
- **Sandcastle:** External sandboxed orchestrator for isolated ticket
  execution.
- **Integration adapter:** Thin translator from ticket metadata to skill
  selection, model requirements, sandbox inputs, validation, and result
  metadata.

## Sources

- [Claude Code glossary](https://code.claude.com/docs/en/glossary)
- [Claude Code context window](https://code.claude.com/docs/en/context-window)
- [Claude Code skills](https://code.claude.com/docs/en/skills)
- [Claude Code plugins](https://code.claude.com/docs/en/plugins)
- [Claude Code subagents](https://code.claude.com/docs/en/sub-agents)
- [Claude Code hooks](https://code.claude.com/docs/en/hooks)
- [Claude Code MCP](https://code.claude.com/docs/en/mcp)
- [Agent Skills specification](https://agentskills.io/specification)
- [MCP specification](https://modelcontextprotocol.io/specification/latest)
- [MartiX artifact rules](./docs/policy/custom-ai-artifact-rules.md)
