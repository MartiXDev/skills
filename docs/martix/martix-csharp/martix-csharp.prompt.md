---
description: 'Generate or refresh a detailed source-driven implementation plan for the martix-csharp skill.'
name: 'martix-csharp-plan'
agent: 'agent'
tools:
  - read
  - search
  - web
argument-hint: 'Describe specific constraints or emphasis areas for C# 14+ guidance.'
---

# Build the martix-csharp skill plan

## Mission

Create or refresh `docs/martix-csharp/martix-csharp-skill-plan.md` so it becomes
an execution-ready plan for building a best-in-class `martix-csharp` skill
focused on C# 14+ language guidance.

## Scope and preconditions

- Work only within documentation scope for this phase.
- Use `docs/martix-csharp/martix-csharp.md` as the governing brief.
- Prioritize official `dotnet/docs` C# content over secondary material.
- Keep guidance language-centric and avoid framework-heavy expansion.

## Inputs

- Baseline brief:
  `docs/martix-csharp/martix-csharp.md`
- Main upstream source index:
  `https://github.com/dotnet/docs/blob/main/docs/csharp/toc.yml`
- Comparative reference assets listed in the baseline brief.
- Optional user-provided focus areas (for example async, docs quality, testing).

If required inputs are missing, request the missing path or URL and stop.

## Workflow

1. Read the baseline brief and extract scope constraints, quality gates, and
   non-goals.
2. Build a source inventory split into:
   - MUST collect pages
   - SHOULD collect pages
   - Optional deep-dive pages
3. Add comparative analysis tasks for existing C# skills, prompts, and
   instructions.
4. Define synthesis rules for turning collected material into reusable skill
   sections (language features, best practices, testing, docs quality).
5. Add acceptance criteria and validation checkpoints for completeness and
   consistency.
6. Save the final result to
   `docs/martix-csharp/martix-csharp-skill-plan.md`.

## Output expectations

The output plan must include:

- Objective and scope boundaries.
- A prioritized source collection matrix.
- A phased execution workflow with clear deliverables per phase.
- Quality gates and explicit non-goals.
- Risks and mitigation notes.
- A final readiness checklist for using `skill-creator`.

## Quality assurance

- Ensure every major recommendation references at least one concrete source.
- Avoid unsupported claims about C# features.
- Keep language concise, imperative, and actionable.
- Verify all internal file references are valid before finishing.
