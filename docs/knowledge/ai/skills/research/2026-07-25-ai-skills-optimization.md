# AI Skills Optimization Research

<!-- markdownlint-disable MD013 -->

- **Role**: research
- **Verified**: 2026-07-25
- **Status**: dated research snapshot; implementation not started
- **Scope**: Agent Skills, VS Code customizations, GitHub Copilot SDK skills, and directly useful first-party creator guidance

> [!NOTE]
> This note optimizes context and execution efficiency, not a vendor billing
> model. Revalidate platform behavior, preview features, model availability,
> and pricing before implementation or procurement decisions.

## Executive summary

The highest-confidence optimization is progressive disclosure: keep always-visible
metadata and always-on instructions small; load a skill body only when relevant;
load references, assets, and scripts only when needed. The Agent Skills sources
explicitly describe this three-tier design and recommend a small `SKILL.md`.
[Agent Skills specification](https://agentskills.io/specification#progressive-disclosure)

For MartiX, the practical order is: audit always-on context; make descriptions
precise; keep `SKILL.md` as a router; move branch-specific detail to focused
references; replace repeated deterministic reasoning with tested scripts; and
measure quality, activation accuracy, retries, and tokens before and after each
change. These are recommendations inferred from the source behavior, not claims
about guaranteed dollar savings.

The main composition hazard is eager loading. GitHub Copilot SDK skills listed
in a custom agent's `skills` field are preloaded, while ordinary session skill
directories are loaded when used. Treat custom-agent composition as an explicit
cost and quality decision.
[GitHub Copilot SDK custom skills](https://docs.github.com/en/copilot/how-tos/copilot-sdk/features/skills#combining-with-other-features)

## Source-backed facts

### Agent Skills standard

- A skill requires a directory with `SKILL.md`; `scripts/`, `references/`, and
  `assets/` are optional. `name` and `description` are required front matter;
  `name` is constrained to lowercase letters, numbers, and hyphens, and
  `description` is limited to 1,024 characters.
  [Specification](https://agentskills.io/specification)
- The standard's progressive-disclosure model is: metadata at startup, the
  full `SKILL.md` after activation, and supporting resources as needed. It
  recommends fewer than 5,000 tokens and fewer than 500 lines for the main
  file, with focused references and one-level links.
  [Progressive disclosure](https://agentskills.io/specification#progressive-disclosure)
- The description is the activation signal: it should say what the skill does,
  when to use it, and include useful task keywords. The creator guidance says
  to optimize both relevant and near-miss prompts, repeat runs because behavior
  is nondeterministic, and use a held-out validation set to limit overfitting.
  [Description field](https://agentskills.io/specification#description-field),
  [Description optimization](https://agentskills.io/skill-creation/optimizing-descriptions)
- Skill guidance should add what the agent lacks and omit generic knowledge;
  coherent units and moderate detail are preferred over exhaustive coverage.
  [Context spending](https://agentskills.io/skill-creation/best-practices#spending-context-wisely)
- Scripts should be referenced with relative paths, avoid interactive prompts,
  expose concise `--help`, produce structured output where practical, and use
  idempotent, bounded, safe behavior for retries and large outputs.
  [Using scripts](https://agentskills.io/skill-creation/using-scripts#designing-scripts-for-agentic-use)
- Skill evaluation uses realistic prompts, expected outcomes, optional input
  files, assertions, and human review. The documented comparison pattern runs
  with-skill and baseline cases, records tokens and duration, then examines
  pass-rate, cost, variance, and failure patterns.
  [Evaluating skill quality](https://agentskills.io/skill-creation/evaluating-skills)

### VS Code

- VS Code distinguishes task-specific, on-demand Agent Skills from custom
  instructions that are always-on or file-scoped. Skills can include scripts
  and resources; instructions are guidance only.
  [Skills versus instructions](https://code.visualstudio.com/docs/agent-customization/agent-skills#_agent-skills-vs-custom-instructions)
- Skills support `user-invocable`, `disable-model-invocation`, and experimental
  `context: fork`. A forked skill runs in a dedicated subagent and returns only
  its result, which can keep the parent context smaller.
  [Skill front matter](https://code.visualstudio.com/docs/agent-customization/agent-skills#_skillmd-file-format),
  [Forked context](https://code.visualstudio.com/docs/agent-customization/agent-skills#_run-a-skill-in-a-forked-context-experimental)
- `.github/copilot-instructions.md` and `AGENTS.md` apply broadly; `.instructions.md`
  files can use narrow `applyTo` globs. Multiple instruction files are combined,
  with no guaranteed order, so overlapping rules can create conflict and load.
  [Custom instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions#_types-of-instruction-files)
- Prompt files are manually invoked slash commands. Their front matter can
  select an agent, model, and tools; prompt-file tools take priority over the
  referenced agent's tools. Prompts can link to shared instructions instead of
  duplicating them.
  [Prompt files](https://code.visualstudio.com/docs/agent-customization/prompt-files#_prompt-file-format),
  [Tool priority](https://code.visualstudio.com/docs/agent-customization/prompt-files#_tool-list-priority)
- Custom agents can constrain tools, select models, expose subagents, and define
  handoffs. VS Code recommends least privilege for security-sensitive work.
  [Custom agents](https://code.visualstudio.com/docs/agent-customization/custom-agents#_why-use-custom-agents)
- Hooks are deterministic shell automation, currently documented as Preview.
  They receive JSON on stdin and can return JSON or exit codes that warn or
  block. Hook commands run with VS Code permissions, so inputs and scripts must
  be reviewed and sanitized.
  [Hooks](https://code.visualstudio.com/docs/agent-customization/hooks)

### GitHub Copilot SDK

- SDK sessions receive skill directories explicitly; the SDK can disable named
  skills. The documentation describes skills as context injected when loaded.
  [Loading and disabling skills](https://docs.github.com/en/copilot/how-tos/copilot-sdk/features/skills#loading-skills)
- Skills listed in a custom agent's `skills` field are eagerly preloaded. SDK
  subagents do not inherit parent skills unless they list them explicitly.
  [Skills and custom agents](https://docs.github.com/en/copilot/how-tos/copilot-sdk/features/skills#combining-with-other-features)
- The SDK page documents its own `skillDirectories` loading surface and
  immediate-subdirectory layout. Do not assume that SDK loading, VS Code
  discovery, Copilot CLI packaging, and the open standard have identical paths
  or activation semantics.
  [Skill directory structure](https://docs.github.com/en/copilot/how-tos/copilot-sdk/features/skills#skill-directory-structure)

### Directly useful creator guidance

- Anthropic's first-party `skill-creator` workflow captures intent, triggers,
  outputs, and test cases before writing; it emphasizes progressive disclosure,
  clear pointers, trace review, lean prompts, and token/duration comparison.
  [Anthropic skill-creator](https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md)
- OpenAI's first-party guidance calls the context window a shared resource:
  include only information the model needs, keep references on demand, and use
  scripts for deterministic or repeatedly rewritten work because they can be
  executed without loading their implementation into context.
  [OpenAI skill-creator](https://github.com/openai/skills/blob/main/skills/.system/skill-creator/SKILL.md)
- Matt Pocock's first-party guidance is practical rather than normative: keep
  skills small, adaptable, and composable; use shared language to reduce
  repeated explanation; and rely on tight feedback loops. It also frames
  model-invoked descriptions as context load and user-invoked skills as a
  deliberate tradeoff between context load and discoverability.
  [Writing great skills](https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/writing-great-skills/SKILL.md),
  [Matt Pocock skills README](https://raw.githubusercontent.com/mattpocock/skills/main/README.md)

## Optimization levers ranked

Priority is a repository hypothesis to validate, not a measured universal
ranking.

| Rank | Lever | Why it likely matters | Guardrail |
| --- | --- | --- | --- |
| 1 | Reduce always-on context | Broad instructions, agents, and duplicated metadata affect many requests. | Preserve genuinely universal safety and repository rules. |
| 2 | Improve routing descriptions | Better activation precision avoids both missed specialized help and unnecessary body loads. | Test positive and near-miss prompts; do not keyword-stuff. |
| 3 | Enforce progressive disclosure | Move branch-specific rules, examples, and references out of routers. | Keep the decision and the pointer in `SKILL.md`. |
| 4 | Remove eager preloads | Agent composition can inject complete skills before they are needed. | Preload only skills required for every run; use explicit activation otherwise. |
| 5 | Replace repeated deterministic work with scripts | A tested script can reduce model reasoning, retries, and output size. | Pin dependencies, bound output, validate exit codes, and keep a manual fallback. |
| 6 | Narrow tools and workflow surfaces | Smaller tool lists and clear agents reduce choice burden and accidental actions. | Do not remove tools needed for the acceptance criteria. |
| 7 | Make hooks selective and cheap | Deterministic checks can prevent retries, but post-tool hooks may run often. | Prefer targeted changed-file checks; measure latency and avoid prose in hooks. |
| 8 | Measure every refactor | Token reduction without quality measurement is not an optimization. | Compare baseline, candidate, and previous version on fixed evals. |

## Implications for MartiX

- Keep `.github/copilot-instructions.md` and root `AGENTS.md` limited to rules
  that truly apply to every request. Keep package-specific detail in package
  docs and skill references; this matches both the repository contract and VS
  Code's scope model. [Repository instructions](../../../../../AGENTS.md),
  [VS Code instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions#_tips-for-writing-effective-instructions)
- Keep each standalone `SKILL.md` as a compact router: trigger boundary,
  core procedure, completion check, and exact relative pointers. Put detailed
  domain rules, compatibility facts, examples, and variant branches in
  `rules/`, `references/`, or `templates/`. The repository's required README,
  metadata, assets, and eval files are packaging contracts; the open standard
  does not make all of them runtime-loaded skill content.
  [Repository rules](../../../../../docs/policy/custom-ai-artifact-rules.md),
  [Agent Skills structure](https://agentskills.io/specification#directory-structure)
- Deduplicate repeated guidance across skills, prompts, instructions, and
  plugin bundles. Keep one authoritative rule and link to it. This is a
  recommendation supported by the creator guidance on concise context and
  single-purpose references, not a claim that all links are free.
  [OpenAI guidance](https://github.com/openai/skills/blob/main/skills/.system/skill-creator/SKILL.md),
  [VS Code prompt references](https://code.visualstudio.com/docs/agent-customization/prompt-files#_prompt-file-format)
- Use `.github/instructions/` for narrow, file-scoped conventions; use prompts
  for intentional workflows; use custom agents only when a role, tool boundary,
  model choice, or handoff is materially useful; use hooks for deterministic
  enforcement and evidence collection. Do not move reusable domain knowledge
  into hooks or repeat it in every prompt.
  [VS Code customization concepts](https://code.visualstudio.com/docs/copilot/concepts/customization)
- Treat plugin-local prompts, instructions, hooks, MCP, and LSP as bundle
  surfaces. Keep the plugin thin and compose standalone skills rather than
  copying their rule libraries. Verify each target runtime's discovery and
  loading behavior independently.
  [VS Code plugins](https://code.visualstudio.com/docs/agent-customization/agent-plugins),
  [Repository artifact rules](../../../../../docs/policy/custom-ai-artifact-rules.md#repository-source-boundaries)
- For SDK or custom-agent integrations, make eager preloading explicit in the
  package design and evaluation matrix. For VS Code, test both automatic and
  slash-command invocation; for Copilot CLI and other clients, document the
  client-specific path and activation assumptions.
  [GitHub SDK composition](https://docs.github.com/en/copilot/how-tos/copilot-sdk/features/skills#combining-with-other-features),
  [VS Code skill invocation](https://code.visualstudio.com/docs/agent-customization/agent-skills#_use-skills-as-slash-commands)

## Phased implementation checklist

1. **Baseline**: inventory every always-on, model-invoked, user-invoked,
   file-scoped, eagerly preloaded, and hook-loaded artifact. Freeze a small
   representative eval set with positive, negative, edge, and multi-artifact
   tasks. Record available token, duration, activation, retry, and quality data.
2. **Classify**: assign each artifact one owner and one role: instruction,
   prompt, agent, skill router, reference, script, asset, or hook. Record client
   support and whether loading is automatic, on demand, or eager.
3. **Slim routers**: prune generic prose and duplicate rules; rewrite
   descriptions around capabilities and real triggers; add exact pointers and
   completion criteria. Keep a held-out trigger set.
4. **Split by branch**: move variant-specific and rarely needed material to
   focused references. Keep links one level deep and verify all paths.
5. **Automate repetition**: bundle only repeated deterministic work as scripts;
   add bounded structured output, `--help`, safe defaults, and tests. Add hooks
   only for deterministic checks that justify their recurring runtime cost.
6. **Validate composition**: test standalone skills, plugin bundles, VS Code
   sessions, and SDK/custom-agent sessions separately. Include an eager-preload
   lane and a disabled-skill lane.
7. **Promote or revert**: retain a change only when it clears the quality and
   safety gates below and improves successful-task efficiency. Record dated
   results; do not treat a cheaper model or smaller prompt as permanently best.

## Measurement and evaluation gates

Track, where the client exposes them: catalog size, activated skills, loaded
instruction/reference tokens, script and hook invocations, tool calls, total
tokens, duration, retries, failures, and successful-task cost. The sources
document token/duration capture as useful evaluation data, but they do not
define one cross-client billing formula.
[Evaluation timing](https://agentskills.io/skill-creation/evaluating-skills#capturing-timing-data)

Required gates for a refactor:

- **Routing**: positive trigger recall and near-miss false-activation rate are
  measured over repeated runs; description changes use a fixed train/validation
  split. [Description evaluation](https://agentskills.io/skill-creation/optimizing-descriptions#avoiding-overfitting-with-trainvalidation-splits)
- **Quality**: expected-output assertions, human review for hard-to-assert
  qualities, and regression coverage for known failure modes.
  [Assertions and human review](https://agentskills.io/skill-creation/evaluating-skills#writing-assertions)
- **Efficiency**: compare median and variance for tokens, duration, retries,
  and successful-task rate against the old version and a no-skill or baseline
  lane. Do not claim savings from prompt length alone.
- **Safety**: no lower activation cost compensates for a safety-floor failure;
  hook and tool changes receive a least-privilege review.
  [Hook security](https://code.visualstudio.com/docs/agent-customization/hooks#_security-considerations)
- **Portability**: validate the same package under each supported client; mark
  client-specific or Preview behavior in the package documentation.

## Risks and tradeoffs

- Over-pruning can remove the non-obvious rule that produces quality; retain
  measured gotchas and completion checks in the router when every branch needs
  them. [Best practices](https://agentskills.io/skill-creation/best-practices#gotchas-sections)
- Splitting too aggressively adds descriptions, activation decisions, and
  possible conflicts; split only when branches genuinely need different
  context. [Skill granularity](https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/writing-great-skills/SKILL.md)
- Broad descriptions increase false activations; narrow descriptions miss
  useful work. Use near-miss and repeated trigger tests rather than intuition.
  [Description optimization](https://agentskills.io/skill-creation/optimizing-descriptions)
- Eager preloading, duplicated plugin content, and overlapping always-on
  instructions can negate progressive disclosure. Client behavior differs, so
  do not generalize SDK results to VS Code or Copilot CLI.
  [GitHub SDK preloading](https://docs.github.com/en/copilot/how-tos/copilot-sdk/features/skills#combining-with-other-features)
- Scripts reduce repeated reasoning but introduce dependencies, platform
  differences, stale output contracts, and security surface. Hooks add similar
  execution and trust risk because they run with editor permissions.
  [Script design](https://agentskills.io/skill-creation/using-scripts),
  [Hook safety](https://code.visualstudio.com/docs/agent-customization/hooks#_safety)
- Forked or subagent execution can keep parent context smaller, but it may add
  orchestration and repeated setup. Measure end-to-end task efficiency rather
  than assuming isolation is cheaper.
  [VS Code forked skills](https://code.visualstudio.com/docs/agent-customization/agent-skills#_run-a-skill-in-a-forked-context-experimental)

## Unavailable or uncertain facts

- No reviewed source establishes current vendor pricing, premium-request
  multipliers, or a universal conversion from tokens to dollars. This note
  intentionally does not invent them.
- No reviewed source guarantees that all clients expose identical token counts,
  activation traces, cache behavior, or hook latency. Build measurement adapters
  per client and label missing telemetry.
- VS Code documents forked skills and hooks as experimental or Preview; their
  behavior and configuration may change.
  [Forked skills](https://code.visualstudio.com/docs/agent-customization/agent-skills#_run-a-skill-in-a-forked-context-experimental),
  [Hooks](https://code.visualstudio.com/docs/agent-customization/hooks)
- The resource index's original Matt Pocock URL ended in
  `writing-great-skillscatalog` and returned 404 on 2026-07-25. The corrected
  first-party path used here is
  `skills/productivity/writing-great-skills/SKILL.md`.

## Primary sources

- [Agent Skills specification](https://agentskills.io/specification)
- [Agent Skills quickstart](https://agentskills.io/skill-creation/quickstart)
- [Agent Skills best practices](https://agentskills.io/skill-creation/best-practices)
- [Optimizing skill descriptions](https://agentskills.io/skill-creation/optimizing-descriptions)
- [Evaluating skill output quality](https://agentskills.io/skill-creation/evaluating-skills)
- [Using scripts in skills](https://agentskills.io/skill-creation/using-scripts)
- [Adding Skills support to an agent](https://agentskills.io/client-implementation/adding-skills-support)
- [VS Code Agent Skills](https://code.visualstudio.com/docs/agent-customization/agent-skills)
- [VS Code custom instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions)
- [VS Code prompt files](https://code.visualstudio.com/docs/agent-customization/prompt-files)
- [VS Code custom agents](https://code.visualstudio.com/docs/agent-customization/custom-agents)
- [VS Code hooks](https://code.visualstudio.com/docs/agent-customization/hooks)
- [GitHub Copilot SDK custom skills](https://docs.github.com/en/copilot/how-tos/copilot-sdk/features/skills)
- [Anthropic first-party skill-creator](https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md)
- [OpenAI first-party skill-creator](https://github.com/openai/skills/blob/main/skills/.system/skill-creator/SKILL.md)
- [Matt Pocock first-party writing-great-skills](https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/writing-great-skills/SKILL.md)
- [Matt Pocock skills README page](https://raw.githubusercontent.com/mattpocock/skills/main/README.md)
