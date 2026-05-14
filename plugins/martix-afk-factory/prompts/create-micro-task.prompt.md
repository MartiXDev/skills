---
name: "Create AFK micro-task"
description: "Guides creation of a well-formed micro-task issue that passes AFK triage automatically."
model: gpt-4o-mini
tools:
  - githubRepo
---

# Create an AFK micro-task issue

Help me create a GitHub issue using the `micro-task (AFK)` template.

## Instructions

Ask me for the following if not already provided:

1. **Task title** — one action-oriented line.
2. **Acceptance criteria** — up to 3 independently verifiable bullets.
3. **Relevant file paths** — up to 3 paths the agent must read or modify.
4. **Tier** — choose based on complexity:
   - `tier/cheap`: formatting, link fixes, template application, simple README sync
   - `tier/medium`: package implementation, eval authoring, focused review
   - `tier/premium`: planning, ambiguous architecture, security-sensitive review
5. **Area** — choose based on the work type:
   - `area/backend`: skill packages, plugin bundles, rules, templates, metadata
   - `area/frontend`: README files, user-facing markdown
   - `area/test`: evals, eval schemas, test coverage
   - `area/docs`: architecture docs, strategy docs under `docs/`
   - `area/ops`: workflows, validation scripts, hooks, scaffolding

Then generate:
- A filled `agent-prompt` block ≤ 400 characters that is self-contained.
  Line 1: task title. Lines 2–4: acceptance criteria. Lines 5–7: file paths.
- The complete issue body using the micro-task template structure.
- The two required labels: the chosen `tier/*` and `area/*`.

Validate that:
- The agent-prompt block does not reference shared coordinator files
  (`README.md`, `docs/repo-overview.md`, `docs/execution-profiles.md`,
  `docs/llm-routing-strategy.md`, `scripts/validate-repository.ps1`, `templates/`).
- The total character count of the agent-prompt block is ≤ 400.

Present the final issue body and labels for my review before creating anything.
