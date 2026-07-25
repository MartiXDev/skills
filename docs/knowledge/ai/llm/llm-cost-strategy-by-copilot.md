# LLM cost strategy by Copilot

## Optimization plan for cutting input/output tokens in Copilot agentic tasks (dotnet / C# / React / TypeScript)

Below is a **practical, prioritized, and technical plan** you can implement immediately. It focuses on **reducing token volume**, **keeping developer productivity**, and **minimizing risk**. I start with a compact comparison table of strategies, then give a step‑by‑step implementation roadmap, concrete tactics per stack, automation and CI integration ideas, monitoring and measurement, and a rollout checklist.

---

| **Strategy** | **Estimated token savings** | **Implementation effort** | **Impact on dev workflow** |
|---|---:|---:|---:|
| **Prompt templating + variable injection** | High | Low–Medium | Minimal friction; repeatable |
| **Local pre/post processing (diffs, summaries)** | High | Medium | Slight tooling overhead; big savings |
| **Chunking + retrieval augmentation** | Medium–High | Medium–High | Changes prompt flow; scalable |
| **Model selection & response length caps** | Medium | Low | Easy to apply; may need tuning |
| **Caching & memoization of outputs** | High (for repeated tasks) | Medium | Reduces repeated calls; needs cache invalidation |
| **Use structured compact formats (JSON/YAML)** | Medium | Low | Slight learning curve; deterministic parsing |
| **Offload to local tools (linters, formatters, compilers)** | Medium | Low–Medium | Faster iteration; fewer LLM calls |
| **Batching requests & streaming** | Medium | Medium | Requires orchestration; reduces overhead |

---

## 1. Quick principles (apply these first)

- **Always prefer compact, structured prompts**: use short keys, JSON or YAML payloads, and avoid verbose natural language when the task is deterministic.
- **Avoid sending full files**: send diffs, function signatures, or minimal context needed to perform the task.
- **Cache and reuse**: store model outputs for identical inputs (e.g., code generation for the same component template).
- **Limit response length**: set explicit max tokens and require concise outputs (e.g., "Return only a JSON patch").

---

## 2. Implementation roadmap (phased, prioritized)

### Phase A — Low friction, high ROI (days)

1. **Create prompt templates** for common tasks (scaffold component, add API endpoint, write unit tests). Templates accept only the minimal variables (name, props, route, DTO). Use placeholders and a small schema.
2. **Enforce compact formats**: require the model to return machine‑readable JSON patches or unified diffs instead of full files. Example instruction: **"Return only a unified diff in git format."**
3. **Set strict token/length limits** in API calls and fail fast if the model would exceed them.
4. **Add a local preprocessor** that extracts only changed functions, signatures, and relevant imports from files before sending.

### Phase B — Medium effort, big savings (1–3 weeks)

1. **Implement a content-addressable cache** keyed by (task template + input hash + model/version). Reuse outputs for repeated tasks (scaffolding, refactors).
2. **Introduce summarization step**: for large contexts, run a short summarizer (or a lightweight local heuristic) to produce a 1–3 line summary of the file or PR, then send that summary plus the minimal diff. This reduces tokens vs sending full file.
3. **Adopt retrieval-augmented generation (RAG) for large codebases**: index code and docs; retrieve only the most relevant snippets (function signatures, interfaces) and include them in prompts. Use similarity search with small context windows.

### Phase C — Advanced (3–8 weeks)

1. **Chunking + progressive refinement**: for big tasks, break into steps (analyze, propose, implement, test). Each step sends only the minimal context and uses the previous step’s compact artifact (e.g., a plan id).
2. **Hybrid pipeline**: offload deterministic tasks to local tools (formatters, compilers, static analyzers). Use the model only for creative or ambiguous tasks.
3. **Model routing**: use smaller/cheaper models for simple tasks (lint fixes, small refactors) and reserve larger models for architecture or complex logic.

---

## 3. Concrete tactics per stack

### dotnet / C# backend

- **Send method/class signatures, not whole files**: include only the method body to change and its signature + relevant DTOs.
- **Use Roslyn locally** to compute AST diffs and send only the AST nodes that need modification. Return patches as C# code snippets or Roslyn-style edits. This avoids sending entire projects.
- **Cache generated controllers/services** for repeated scaffolding patterns.

### React / TypeScript frontend

- **Send component props + minimal JSX**: for changes, send only the component file’s changed function and prop types.
- **Prefer code transforms (codemods)**: ask the model to output a codemod script (jscodeshift/ts-morph) rather than full rewritten files. Codemods are compact and deterministic.
- **Return only the changed AST or patch**; apply locally and run tests/formatters.

### Cross-cutting

- **Use JSON patch (RFC 6902)** as the canonical response format for edits. It’s compact and machine-applyable.
- **Require strict schema validation** on model outputs to avoid verbose clarifications.

---

## 4. Automation, CI, and tooling

- **Pre-commit hooks**: run local analyzers and only call Copilot for tasks that fail local rules or need generation.
- **CI caching layer**: store model outputs per commit hash; reuse for repeated CI runs.
- **Request batching**: group multiple small generation tasks into a single prompt that returns a structured array of results. This reduces per-request overhead.
- **Telemetry**: log tokens used per request, per task type, and per repo area. Use this to prioritize further optimizations.

---

## 5. Monitoring, metrics, and KPIs

- **Track these KPIs weekly**:
  - **Tokens per task type** (scaffold, refactor, test generation).
  - **Calls per developer per day**.
  - **Cache hit rate**.
  - **Average response size (tokens)**.
- **Set targets**: e.g., reduce tokens per scaffold by 50% in 4 weeks; achieve cache hit rate >40% for scaffolding tasks.
- **Alerting**: flag tasks with token spikes and inspect prompts for verbosity.

---

## 6. Example prompt patterns and templates

- **Scaffold component (compact)**

  ```text
  TASK: scaffold React component
  TEMPLATE: {"name":"<Name>","props":[{"name":"x","type":"string"}],"style":"css-module"}
  RETURN: JSONPatch array only
  MAX_TOKENS: 400
  ```

- **Refactor method (diff)**

  ```text
  TASK: refactor method
  CONTEXT: method signature + 10 lines before/after
  INPUT: { "file":"src/Service.cs", "method":"Calculate", "diff":"<unified diff>" }
  RETURN: unified git diff only
  ```

---

## 7. Rollout checklist (practical steps)

1. **Week 0**: Implement token telemetry and set baseline.
2. **Week 1**: Deploy prompt templates and response length caps; add preprocessor to strip irrelevant context.
3. **Week 2–3**: Add caching for scaffolding and codemod outputs; integrate Roslyn/ts-morph for AST diffs.
4. **Week 4–6**: Implement RAG index for large repos; route tasks to smaller models where safe.
5. **Ongoing**: Monitor KPIs, iterate templates, and expand cache coverage.

---

## 8. Risks and mitigations

- **Risk**: Over‑trimming context causes incorrect outputs. **Mitigation**: add quick local unit tests and schema validation before applying patches.
- **Risk**: Cache staleness. **Mitigation**: key cache by repo+commit+template; invalidate on relevant file changes.
- **Risk**: Developer friction from stricter prompts. **Mitigation**: provide CLI helpers and IDE snippets to auto-fill templates.

---

## Final recommendations (prioritized)

1. **Start with telemetry + prompt templates** — fastest wins.
2. **Add caching for repeated generation tasks** — biggest long-term savings.
3. **Switch to structured outputs (JSON patch / codemods)** — reduces tokens and automates application.
4. **Index and retrieve only relevant snippets** for large codebases (RAG).
5. **Route to smaller models for deterministic tasks** and reserve large models for complex reasoning.

---

If you want, I can now:

- **Generate a set of ready-to-use prompt templates** for scaffolding, refactors, and tests tailored to your dotnet/React/TS stacks.
- **Produce a sample preprocessor script** (Roslyn and ts-morph examples) that extracts minimal context and produces unified diffs.

Tell me which of those two you want first and I’ll produce the artifacts ready to drop into your CI/IDE.
