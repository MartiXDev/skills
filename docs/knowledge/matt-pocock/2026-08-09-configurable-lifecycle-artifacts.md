# Configurable lifecycle artifacts: primary-source research

> **Date:** 2026-08-09  
> **Role:** Research snapshot  
> **Runtime policy:** This research informs MartiX design only. MartiX does not
> install, invoke, copy, or depend on the researched workflow artifacts.

## Findings

1. **Compact metadata and progressive disclosure** keep an entrypoint small while
   supporting references, templates, and scripts on demand. This supports an
   `mx-*` router with `workflow_ref`, invocation metadata, and pointers to
   configuration-selected resources.
   - [Agent Skills specification](https://agentskills.io/specification)
   - [`research/SKILL.md`](https://github.com/mattpocock/skills/blob/84fdeffd12f2ee307994d1eb6feb48173b6e0502/skills/engineering/research/SKILL.md)
   - [Claude Code skills](https://code.claude.com/docs/en/skills)

2. **Invocation policy is explicit.** User-invoked orchestration and
   model-invoked reusable discipline are represented separately rather than
   inferred from a name. MartiX can expose this as `user`, `model`, or
   `user-or-model` configuration.
   - [Engineering catalog](https://github.com/mattpocock/skills/blob/84fdeffd12f2ee307994d1eb6feb48173b6e0502/skills/engineering/README.md)
   - [Productivity catalog](https://github.com/mattpocock/skills/blob/84fdeffd12f2ee307994d1eb6feb48173b6e0502/skills/productivity/README.md)
   - [`triage/SKILL.md`](https://github.com/mattpocock/skills/blob/84fdeffd12f2ee307994d1eb6feb48173b6e0502/skills/engineering/triage/SKILL.md)

3. **Repository setup is shared configuration work.** The setup workflow
   gathers tracker, label, and document-layout decisions once so later triage,
   specification, and ticket workflows consume the same repository facts.
   - [`setup-matt-pocock-skills/SKILL.md`](https://github.com/mattpocock/skills/blob/84fdeffd12f2ee307994d1eb6feb48173b6e0502/skills/engineering/setup-matt-pocock-skills/SKILL.md)

4. **Artifact templates describe lifecycle outputs.** Specification templates
   separate problem, solution, stories, decisions, tests, scope, and notes;
   ticket templates preserve tracer-bullet scope, acceptance criteria, and
   blocking relationships. MartiX should configure template paths and permitted
   variables, not embed all templates in every prompt.
   - [`to-spec/SKILL.md`](https://github.com/mattpocock/skills/blob/84fdeffd12f2ee307994d1eb6feb48173b6e0502/skills/engineering/to-spec/SKILL.md)
   - [`to-tickets/SKILL.md`](https://github.com/mattpocock/skills/blob/84fdeffd12f2ee307994d1eb6feb48173b6e0502/skills/engineering/to-tickets/SKILL.md)

5. **Planning artifacts preserve uncertainty explicitly.** A wayfinding map
   records destination, decisions, unresolved work, and out-of-scope work.
   Child work can be classified as research, prototype, grilling, or task, with
   native dependency relationships where available.
   - [`wayfinder/SKILL.md`](https://github.com/mattpocock/skills/blob/84fdeffd12f2ee307994d1eb6feb48173b6e0502/skills/engineering/wayfinder/SKILL.md)

6. **Prompts are parameterized.** Sandcastle accepts a prompt file plus
   structured prompt arguments such as issue and branch context. MartiX should
   centralize prompt paths and declare allowed arguments in `mx.config.json`.
   - [Sandcastle README](https://github.com/mattpocock/sandcastle/blob/v0.12.0/README.md)
   - [Parallel planner template](https://github.com/mattpocock/sandcastle/blob/v0.12.0/src/templates/parallel-planner-with-review/main.mts)

7. **Deterministic orchestration belongs outside prompt prose.** The planner
   template uses structured output, bounded phases, isolated branches,
   implement-then-review sequencing, and an explicit merge phase. MartiX should
   configure these policies while keeping enforcement in local scripts and
   hooks.
   - [Parallel planner template](https://github.com/mattpocock/sandcastle/blob/v0.12.0/src/templates/parallel-planner-with-review/main.mts)
   - [Sandcastle package manifest](https://github.com/mattpocock/sandcastle/blob/v0.12.0/package.json)

8. **Hooks and completion signals are first-class.** Host and sandbox hooks,
   copied files, timeouts, logging, and completion behavior are configured
   around the model rather than trusted to a prompt.
   - [Sandcastle README](https://github.com/mattpocock/sandcastle/blob/v0.12.0/README.md)

9. **Branch safety is explicit.** Isolated branches or sandboxes, per-task
   implementation and review, then a controlled merge phase provide a useful
   model for configurable `mx-orchestrate`.
   - [Sandcastle README](https://github.com/mattpocock/sandcastle/blob/v0.12.0/README.md)
   - [Merge prompt](https://github.com/mattpocock/sandcastle/blob/v0.12.0/src/templates/parallel-planner-with-review/merge-prompt.md)
   - [Review prompt](https://github.com/mattpocock/sandcastle/blob/v0.12.0/src/templates/parallel-planner-with-review/review-prompt.md)

10. **Small deterministic inventory and version checks are preferable to a
    large runtime framework.** MartiX can use focused inventory, schema,
    generated-manifest, and package-consistency checks.
    - [`scripts/list-skills.sh`](https://github.com/mattpocock/skills/blob/84fdeffd12f2ee307994d1eb6feb48173b6e0502/scripts/list-skills.sh)
    - [`package.json`](https://github.com/mattpocock/skills/blob/84fdeffd12f2ee307994d1eb6feb48173b6e0502/package.json)

11. **Completion criteria are behavior-oriented.** TDD, diagnosis, and
    implementation workflows require observable feedback, regression checks,
    cleanup, review, and completion evidence. These belong in lifecycle gates
    and deterministic validation rather than only in prompt prose.
    - [`tdd/SKILL.md`](https://github.com/mattpocock/skills/blob/84fdeffd12f2ee307994d1eb6feb48173b6e0502/skills/engineering/tdd/SKILL.md)
    - [`diagnosing-bugs/SKILL.md`](https://github.com/mattpocock/skills/blob/84fdeffd12f2ee307994d1eb6feb48173b6e0502/skills/engineering/diagnosing-bugs/SKILL.md)
    - [`implement/SKILL.md`](https://github.com/mattpocock/skills/blob/84fdeffd12f2ee307994d1eb6feb48173b6e0502/skills/engineering/implement/SKILL.md)

12. **Context pointers reduce token use.** Descriptions and links to
    supporting documents can route an agent to the smallest relevant context
    instead of preloading the complete knowledge tree.
    - [`writing-for-agents/SKILL.md`](https://github.com/mattpocock/skills/blob/84fdeffd12f2ee307994d1eb6feb48173b6e0502/skills/productivity/writing-for-agents/SKILL.md)

## MartiX adaptation

These findings support a central `.github/martix/mx.config.json` containing
workflow metadata, invocation policy, stack and tracker mappings, template paths,
permitted prompt arguments, branch and context-pack policy, deterministic
commands, hooks, completion signals, redaction, and validation gates. The
configuration is a MartiX design adaptation, not a runtime dependency on the
researched projects.
