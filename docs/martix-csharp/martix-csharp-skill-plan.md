# martix-csharp Skill Plan

## Objective

Create an execution-ready plan to build a high-quality `martix-csharp` skill
that focuses on modern C# language guidance (C# 14+), using official sources as
the primary reference set and existing community skills as comparative inputs.

## Scope boundaries

| Area | Decision |
| --- | --- |
| Core focus | C# language features, coding practices, and skill guidance |
| Target versions | C# 14+ (with C# 13 and C# 12 context for transitions) |
| Allowed examples | Language-focused examples with minimal framework coupling |
| Excluded themes | ASP.NET architecture, UI frameworks, deployment/CI/CD, cloud hosting |

## Deliverables

1. Curated source inventory with priority labels (MUST, SHOULD, OPTIONAL).
2. Distilled guidance map for skill sections and workflows.
3. Draft-ready `SKILL.md` outline inputs for future `skill-creator` runs.
4. Validation checklist for completeness, consistency, and source traceability.

## Phase 1 - Build the source inventory

### MUST collect

| Source | Why it matters |
| --- | --- |
| `docs/csharp/toc.yml` | Master index to avoid missing major language sections |
| `docs/csharp/whats-new/csharp-14.md` | Primary source for C# 14 additions and behavior changes |
| `docs/csharp/whats-new/csharp-13.md` | Migration context and feature continuity |
| `docs/csharp/whats-new/csharp-12.md` | Migration context and feature continuity |
| `docs/csharp/whats-new/csharp-version-history.md` | Canonical version timeline and feature tracking |
| `docs/csharp/how-to/index.md` + child pages | Practical language usage guidance |
| `docs/csharp/programming-guide/**` | Core language concepts and best-practice patterns |

### SHOULD collect

| Source area | Why it matters |
| --- | --- |
| `docs/csharp/language-reference/**` | Precision for syntax, keywords, operators, and constraints |
| `docs/csharp/fundamentals/**` | Foundational concepts that support clear skill explanations |
| `docs/csharp/tour-of-csharp/**` | Compact examples useful for teaching-oriented snippets |

### OPTIONAL collect

| Source area | Why it matters |
| --- | --- |
| Curated expert blog posts (for example DomeTrain C# 14 article) | Supplemental interpretation only after official docs are mapped |
| Additional community write-ups | Gap filling and alternate explanations, never primary authority |

## Phase 2 - Comparative asset review

Review these assets to extract reusable patterns and identify blind spots:

- Aaron Stannard .NET skills and repository
- `dotnet-10-csharp-14` skill pack
- Awesome Copilot C#/.NET plugin, agents, instructions, and C# skills:
  - `csharp-async`
  - `csharp-docs`
  - `csharp-mcp-server-generator`
  - `csharp-mstest`
  - `csharp-nunit`
  - `csharp-tunit`
  - `csharp-xunit`
  - `dotnet-best-practices`
  - `dotnet-design-pattern-review`

Capture:

- High-value workflow patterns.
- Reusable section structures.
- Missing coverage compared to official C# docs.

## Phase 3 - Distill guidance domains

Organize findings into these future skill domains:

1. C# 14 modernization and syntax guidance.
2. Async/await and concurrency correctness.
3. API design and naming conventions for C# members and types.
4. Nullability, immutability, and defensive coding.
5. Testing strategy mapping across TUnit/xUnit/NUnit/MSTest.
6. XML documentation and public API clarity.

For each domain, record:

- Canonical source pages.
- Do/avoid guidance.
- Example patterns.
- Common pitfalls.

## Phase 4 - Produce skill-ready structure

Prepare a structured `SKILL.md` blueprint containing:

- `name`, `description`, and activation cues.
- "When to use this skill" triggers.
- Step-by-step workflow blocks.
- Quality gates and non-goal reminders.
- References mapped to source inventory items.

Keep wording imperative, concise, and reusable by AI agents.

## Phase 5 - Validation and consistency checks

Run this checklist before using `skill-creator`:

- [ ] Every major section maps to at least one official source page.
- [ ] Scope boundaries are explicit and consistent across all documents.
- [ ] Guidance is language-focused and does not drift into framework design.
- [ ] Comparative insights are labeled as secondary to official documentation.
- [ ] Internal links and filenames in `docs/martix-csharp/` are valid.

## Risks and mitigations

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Scope creep into framework guidance | Skill becomes unfocused | Enforce scope table and non-goals during each phase |
| Over-reliance on secondary sources | Reduced accuracy | Treat community assets as comparative only |
| Missing important language pages | Coverage gaps | Start from TOC and track coverage explicitly |
| Inconsistent terminology across docs | Lower usability | Final cross-document consistency pass before handoff |

## Exit criteria

The planning phase is complete when:

1. Source inventory and comparative review outputs are complete.
2. Guidance domains are mapped with traceable references.
3. Skill-ready structure is documented and reviewable.
4. Validation checklist passes with no unresolved scope violations.

## Implementation artifacts

The initial implementation generated from this plan is available at:

- `src/plugins/martix-csharp/skills/martix-csharp/SKILL.md`
- `src/plugins/martix-csharp/skills/martix-csharp/references/source-inventory.md`
- `src/plugins/martix-csharp/skills/martix-csharp/evals/evals.json`
- `src/plugins/martix-csharp/prompts/martix-csharp.prompt.md`
- `src/plugins/martix-csharp/instructions/martix-csharp.instructions.md`
- `src/plugins/martix-csharp/agents/martix-csharp.agent.yaml`
- `src/plugins/martix-csharp/hooks/martix-csharp-validation.hook.yaml`
- `src/plugins/martix-csharp/plugin.yaml`
- `src/plugins/martix-csharp/plugin.json`
