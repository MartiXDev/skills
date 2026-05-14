# Automated AI DEV Factory with GitHub Issues

## Copilot Prompts

### Prompt 1

There is a new VS Code Agents window - see <https://code.visualstudio.com/docs/copilot/agents/agents-window>

I like the to work on several features in parallel.

I also like the way the work is prepared using GitHub SpecKit or Matt Pocock Sandcastle <https://github.com/mattpocock/sandcastle> or Skills <https://github.com/mattpocock/skills>

My goal or idea is to prepare several features in GitHub, what would be the best way to prepare hierarchical issues and then let single agent or multiple agens work on implementation. So I can imagine something like each issue or sub-issu is marked with specific label by triage workflow, so we know if it's frontend, backend, test, documentation or other type of task. So then "something" can run multiple agents to pickup own issues to work on. How to achieve this using Copilot CLI or new Agents window?

### Prompt 2

To be more specific, Microsoft and Anthropic are going to make LLMs much more expensive soon, so I need to optimize the context window, token usage, premium requests, choose proper LLM multiplier for specific  task, etc.
One of the ideas is to create for complex Root Issue many very small sub-tasks which are very focused on easy tasks or list of easy tasks so it then can be implemente using cheap or even fre LLM.
Recommend me next steps, what to do, what to configure, what to prepare, which tools and how to use, etc.

## Copilot Responses

### Response 1

**Short answer:** **Prepare a hierarchical issue tree in GitHub, triage with deterministic labels, and run Copilot agents either from the VS Code *Agents window* (interactive multi‑session orchestration) or from the *Copilot CLI* (background, isolated sessions).** Use GitHub Actions to automate triage/labeling and a small orchestrator (script or CI job) to spawn Copilot‑CLI sessions per label; use the Agents window when you want visual monitoring and hand‑offs.   [Github](https://github.com/microsoft/vscode-docs/blob/main/docs/copilot/agents/agents-window.md)  [Visual Studio Code](https://code.visualstudio.com/docs/copilot/agents/copilot-cli)

#### Quick comparison (decision table)

| **Approach** | **Best for** | **How sessions run** | **Isolation / safety** | **Visibility / control** |
| --- | ---: | --- | --- | --- |
| **Agents window (VS Code)** | Interactive orchestration across workspaces | VS Code manages sessions and shared sessions list | Runs inside VS Code; good for manual approvals | High — GUI, session list, chat, hand‑offs.   [Github](https://github.com/microsoft/vscode-docs/blob/main/docs/copilot/agents/agents-window.md) |
| **Copilot CLI (background)** | Autonomous, long‑running tasks (many parallel jobs) | Local background sessions via Copilot CLI harness | Worktree or Workspace isolation modes available.   [Visual Studio Code](https://code.visualstudio.com/docs/copilot/agents/copilot-cli) | Medium — chat + status; designed for background runs.   [Visual Studio Code](https://code.visualstudio.com/docs/copilot/agents/copilot-cli) |
| **Hybrid (orchestrator + labels)** | Scale many small issues/features in parallel | Orchestrator starts CLI sessions per labeled issue | Orchestrator controls concurrency; use worktrees for safety | High if you add logging + PR review gates (recommended) |

---

#### Recommended workflow (step‑by‑step)

1. **Design hierarchical issues**  
   - Create a parent “feature” issue with a checklist of **sub‑issues** (frontend, backend, tests, docs). Use GitHub issue templates to enforce structure. **Label each sub‑issue** with type: `triage/ready`, `area/frontend`, `area/backend`, `task/test`, `task/docs`, `priority/high`.  
2. **Automated triage**  
   - Use a GitHub Action to run on new issues/PRs: apply labels based on templates or keywords, add `triage/ready` when complete. This keeps the queue deterministic.  
3. **Agent assignment rules** *(mapping labels → agent)*  
   - `area/frontend` → frontend agent skill; `area/backend` → backend agent; `task/test` → test agent; `task/docs` → docs agent. Store these mappings in a repo config file.  
4. **Orchestration options**  
   - **Interactive:** Open the Agents window and start sessions for each sub‑issue you want to supervise; hand off context between sessions. Use this when you want to review intermediate edits.   [Github](https://github.com/microsoft/vscode-docs/blob/main/docs/copilot/agents/agents-window.md)  
   - **Autonomous:** Run a small orchestrator (node/python) that polls GitHub issues with `triage/ready` and launches a Copilot CLI session per issue. Use **Worktree isolation** so each agent edits in a separate git worktree. Copilot CLI supports background sessions and slash commands for auto‑approval.   [Visual Studio Code](https://code.visualstudio.com/docs/copilot/agents/copilot-cli)  
5. **Review & merge**  
   - Agents create branches/PRs. Keep human review gates: CI tests, code owners, and PR approvals before merging.

#### Practical tips and risks

- **Use Worktree isolation** to avoid corrupting your main workspace.   [Visual Studio Code](https://code.visualstudio.com/docs/copilot/agents/copilot-cli)  
- **Keep labels deterministic** and small in number; use a config file so the orchestrator can map labels to agent prompts/skills.  
- **Risk:** Autonomous agents can produce incorrect code; always require CI and human PR review.  
- **Suggestion:** Start with the Agents window for a few parallel sessions to refine prompts and skills, then scale with Copilot CLI + orchestrator.   [Github](https://github.com/microsoft/vscode-docs/blob/main/docs/copilot/agents/agents-window.md)  [Visual Studio Code](https://code.visualstudio.com/docs/copilot/agents/copilot-cli)

#### Final note

**Based on these sources, this suggests** a two‑phase rollout: prototype with the Agents window (monitoring + hand‑offs), then automate at scale with Copilot CLI sessions launched by a small orchestrator that reads labeled issues.   [Github](https://github.com/microsoft/vscode-docs/blob/main/docs/copilot/agents/agents-window.md)  [Visual Studio Code](https://code.visualstudio.com/docs/copilot/agents/copilot-cli)  [getbeam.dev](https://getbeam.dev/blog/vscode-multi-agent-orchestration-tutorial.html)

If you want, I can **produce** (1) a sample GitHub issue template + label mapping file, and (2) a minimal orchestrator script that polls issues and starts Copilot CLI sessions using worktrees.

### Response 2

**Short answer:** **Break the root feature into many tiny, single‑purpose issues, triage them with deterministic labels, and run small agent sessions per label—using the interactive Agents UI for prototyping and a CLI‑based orchestrator for scale.** Prioritize *very focused prompts*, *worktree isolation*, and *context budgeting* so cheap models can handle most subtasks.

### Quick comparison — response 2

| **Option** | **When to use** | **How it helps token cost** |
| --- | ---: | --- |
| **Interactive Agents UI** | Prototype, supervise hand‑offs, refine prompts | Human in loop prevents wasted retries; easier to keep context small. |
| **CLI orchestrator (background agents)** | Scale many tiny tasks automatically | Spawn isolated sessions per issue; choose cheaper models per task. |
| **Hybrid (UI + orchestrator)** | Tune prompts in UI, then scale with orchestrator | Best balance of quality control and cost efficiency. |

---

## Concrete next steps (what to prepare and configure)

1. **Design micro‑issues**  
   - For each root feature create a parent issue and many **atomic sub‑issues** (one clear goal per issue). **Label** each sub‑issue by *area* (`frontend`, `backend`, `tests`, `docs`) and *cost tier* (`cheap`, `standard`, `premium`).  
   - Use issue templates that force: acceptance criteria, required files/paths, and a short context snippet (max 3–5 lines).  

2. **Automated triage and label mapping**  
   - Add a repo config file mapping labels → agent role → model tier (e.g., `cheap` → small LLM; `premium` → large LLM). Have CI/GitHub Actions apply labels from templates and move issues to `ready` when structured.  

3. **Orchestrator design**  
   - Build a small orchestrator that polls `ready` issues, creates a branch/worktree per issue, selects the model tier from the mapping, and launches an isolated agent session to implement the change and open a PR. Use **worktree isolation** so each agent edits a separate git tree.  

4. **Context and token budgeting (critical)**  
   - **Measure first**: instrument sessions to report context usage and token breakdown. Use the session `/context` diagnostic to see *System/Tools*, *Messages*, and *Free Space*. This reveals the fixed overhead vs per‑message cost.   [dfberry.github.io](https://dfberry.github.io/2026-05-06-tuning-up-copilot-context)  [GitHub Docs](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management)  
   - **Minimize always‑loaded content**: move large tool definitions, memories, and nonessential system text off the always‑loaded system prompt; load them on‑demand. This reduces the fixed System/Tools bucket.   [dfberry.github.io](https://dfberry.github.io/2026-05-06-tuning-up-copilot-context)  
   - **Keep prompts tiny**: each sub‑issue should include only the minimal context needed (file paths, one short example, acceptance tests). Shorter conversation history and smaller tool outputs save tokens.   [DEV Community](https://dev.to/stevengonsalvez/token-optimisation-101-stop-burning-money-on-ai-coding-agents-4mce)

5. **Model selection & multipliers**  
   - Map trivial tasks (formatting, small refactors, docs, unit tests) to **cheaper models**; reserve large models for design, architecture, or complex algorithm work. Batch many tiny tasks into a single session only when they share context to avoid repeated overhead.   [DEV Community](https://dev.to/stevengonsalvez/token-optimisation-101-stop-burning-money-on-ai-coding-agents-4mce)

6. **Safety & quality gates**  
   - Always require CI, unit tests, and human PR review before merging. Log token usage per PR so you can refine label→model mappings.

---

## Risks and mitigations

- **Agents can hallucinate or introduce subtle bugs** — mitigate with tests, code owners, and human review.  
- **Token waste from bloated system/tool definitions** — audit and move large definitions to on‑demand loading.   [dfberry.github.io](https://dfberry.github.io/2026-05-06-tuning-up-copilot-context)

---

**If you want, I will generate** a sample issue template + label→model mapping file and a minimal orchestrator script that: polls issues, creates worktrees, selects model tiers, and opens PRs.
