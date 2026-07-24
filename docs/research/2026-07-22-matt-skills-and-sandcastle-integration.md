# Matt Skills and Sandcastle Integration Research

<!-- markdownlint-disable MD013 MD025 -->

## Document metadata

- **Role**: research
- **Verified**: 2026-07-22
- **Refresh**: After major Matt Skills or Sandcastle releases, or within six months

## Executive summary

This research snapshot establishes the current (2026-07-22) division of responsibilities between Matt Pocock Skills (planning and delivery workflow), Sandcastle (sandboxed ticket execution orchestrator), and MartiX Skills (reusable domain capabilities). It documents their respective release states, extension surfaces, integration seams, and identifies evidence gaps for a future thin MartiX integration adapter without specifying or implementing the adapter itself.

## Primary sources

All sources verified 2026-07-22:

| Source | Version/Commit | License | URL |
| --- | --- | --- | --- |
| Matt Pocock Skills | v1.1.0 | MIT | <https://github.com/mattpocock/skills> |
| Sandcastle | v0.12.0 (published npm package) | MIT | <https://github.com/mattpocock/sandcastle> |
| MartiX Skills `.sandcastle/` | commit 2b2f3fb | — | Local repository configuration |

- Matt Skills README: <https://github.com/mattpocock/skills/blob/ed37663cc5fbef691ddfecd080dff42f7e7e350d/README.md>
- Sandcastle README: <https://github.com/mattpocock/sandcastle/blob/e99f832f26dc9d245c019a9ddd19fa5dee792427/README.md>
- Sandcastle npm package: `@ai-hero/sandcastle@0.12.0`

## Responsibility boundaries

### Matt Pocock Skills

**Planning and delivery workflow**. Matt Skills provides composable, model-agnostic agent skills for real engineering tasks rather than speculative "vibe coding." Key characteristics:

- **User-invoked orchestration skills**: `/grill-with-docs`, `/triage`, `/to-spec`, `/to-tickets`, `/implement`, `/wayfinder`
- **Model-invoked discipline skills**: `/tdd`, `/code-review`, `/diagnosing-bugs`, `/research`, `/domain-modeling`, `/codebase-design`
- **Domain model and shared language**: Builds `CONTEXT.md` and ADRs to reduce agent verbosity and improve naming consistency
- **Issue tracker integration**: Supports GitHub, Linear, or local files for ticket management
- **Installation modes**: skills.sh (editable copies) or native Claude Code plugin (managed bundle)

**Responsibilities owned by Matt Skills**:

- Grilling sessions to align user and agent intent
- Breaking work into dependency-aware tickets
- Maintaining domain terminology and architecture decision records
- Triage state machines
- Specifications and planning artifacts

**Does NOT own**:

- Container or sandbox lifecycle
- Worktree creation or cleanup
- Agent process execution or isolation
- Concurrency orchestration across parallel agents

### Sandcastle

**Sandboxed ticket-execution orchestrator**. Sandcastle is a TypeScript library (`@ai-hero/sandcastle@0.12.0`) for orchestrating AI coding agents in isolated sandbox environments.

**Core APIs**:

- `run()` — one-shot agent invocation with automatic sandbox lifecycle
- `createSandbox()` — reusable sandbox for multiple agent runs (implement-then-review pattern)
- `createWorktree()` — independent worktree as first-class concept, separate from sandbox
- `interactive()` — launch interactive agent sessions with TUI

**Branch strategies**:

- `{ type: "head" }` — bind-mount current HEAD, no worktree
- `{ type: "branch", branch: "name" }` — explicit branch in git worktree
- `{ type: "merge-to-head" }` — temp branch merged back to current HEAD after each run

**Sandbox providers** (interchangeable):

- `docker()` — Docker Desktop, bind-mount provider
- `podman()` — rootless Docker alternative, bind-mount
- `vercel()` — Vercel Firecracker microVMs, isolated provider
- `daytona()` — Daytona cloud workspaces
- `noSandbox()` — run directly on host, no isolation

**Lifecycle hooks**:

- `host.onWorktreeReady` — runs on host after worktree created, before container starts
- `host.onSandboxReady` — runs on host after container running
- `sandbox.onSandboxReady` — runs inside sandbox after it starts

**Container lifecycle and cleanup**:

- `run()` — automatic cleanup: clean worktree/container removed; dirty worktree preserved
- `createSandbox()` with `await using` — calls `sandbox.close()` automatically
- `sandbox.close()` — tears down container; preserves dirty worktree; returns `CloseResult.preservedWorktreePath` when applicable
- `wt.close()` — removes clean worktree or preserves dirty worktree

**Responsibilities owned by Sandcastle**:

- Git worktree creation, branch management, and cleanup
- Container image management and lifecycle
- Process isolation and sandboxing
- Commit collection and merge-back to host
- Parallel agent orchestration via `Promise.allSettled`
- Structured output extraction (`Output.object`, `Output.string`)
- Agent provider abstraction (`claudeCode()`, extensible)
- Session resume and fork capabilities

**Does NOT own**:

- Domain-specific planning workflows
- Issue decomposition or dependency graphs
- Triage or approval gates
- Domain terminology or shared language
- Long-term worktree ownership manifests (no persistent session registry)

### MartiX Skills

**Reusable domain capabilities**. MartiX Skills packages standalone domain knowledge (e.g., `martix-dotnet-csharp`, `martix-markdown`) and plugin bundles that compose workflow assets (agents, prompts, instructions, hooks, MCP/LSP configuration).

**Current integration with Sandcastle** (as of commit 2b2f3fb):

- `.sandcastle/main.mts` — parallel planner with implement-review loop
- `.sandcastle/Dockerfile` — custom agent container image definition
- `.sandcastle/plan-prompt.md`, `implement-prompt.md`, `review-prompt.md`, `merge-prompt.md` — phase-specific prompts
- `.sandcastle/CODING_STANDARDS.md` — MartiX repository standards for Sandcastle agents

**Responsibilities**:

- Providing reusable domain-specific skills and validation rules
- Repository-specific coding standards and completion signals
- Custom container image definitions
- Prompt templates for each orchestration phase

**Does NOT own** (delegates to Sandcastle):

- Container lifecycle, branch creation, worktree cleanup
- Agent process execution or concurrency coordination
- Sandbox provider selection or configuration

## Integration surfaces and extension points

### Sandcastle extension points

#### 1. Agent providers

**Public API**: `AgentProvider` interface

```typescript
interface AgentProvider {
  type: string;
  invoke(options: {
    prompt: string;
    cwd: string;
    env: Record<string, string>;
    // ...other options
  }): AsyncIterable<AgentEvent>;
}
```

**Shipped providers**:

- `claudeCode(model, options?)` — Claude Code CLI agent
  - Models: `claude-opus-4-8`, `claude-sonnet-4-6`, `claude-haiku-4-5`, etc.
  - Options: `effort` level (e.g., `{ effort: "high" }`)
  - Requires `CLAUDE_CODE_OAUTH_TOKEN` or `ANTHROPIC_API_KEY`

**Extension seam**: Custom agent providers can be implemented by conforming to the `AgentProvider` interface. This is a public, documented API.

#### 2. Sandbox providers

**Public API**: `SandboxProvider` (bind-mount) and `IsolatedSandboxProvider`

Two provider types:

- **Bind-mount providers** (`docker`, `podman`) — mount host worktree into container
- **Isolated providers** (`vercel`, `daytona`) — copy worktree content into isolated environment

**Extension helpers**:

- `createBindMountSandboxProvider` — factory for custom bind-mount providers
- `createIsolatedSandboxProvider` — factory for custom isolated providers

**Documented extension seam**: Yes, README explicitly documents custom provider creation.

#### 3. Lifecycle hooks

**Public API**: `SandboxHooks`

```typescript
interface SandboxHooks {
  host?: {
    onWorktreeReady?: Hook[];
    onSandboxReady?: Hook[];
  };
  sandbox?: {
    onSandboxReady?: Hook[];
  };
}

type Hook = { command: string };
```

**Usage**:

- Passed to `run()`, `createSandbox()`, `createWorktree()`
- `host.*` hooks run on the host machine
- `sandbox.*` hooks run inside the sandbox
- Common use case: `sandbox.onSandboxReady` with `npm install`

**Stability**: Documented public API, stable extension point.

#### 4. Structured output

**Public API**: `Output.object({ tag, schema })`, `Output.string({ tag })`

```typescript
import { Output } from "@ai-hero/sandcastle";
import { z } from "zod";

const result = await run({
  agent: claudeCode("claude-opus-4-8"),
  sandbox: docker(),
  maxIterations: 1, // required for structured output
  promptFile: "prompt.md",
  output: Output.object({
    tag: "plan",
    schema: z.object({ issues: z.array(z.object({ id: z.string() })) }),
  }),
});

console.log(result.output); // typed object
```

**Validation**: Zod, Valibot, ArkType, or any Standard Schema validator (<https://standardschema.dev>)

**Stability**: Documented public API. Requires agent to emit `<tag>JSON</tag>` in stdout.

#### 5. Commit collection and merge-back

**Behavior**:

- Sandcastle collects commits made on the agent's branch
- `run()` returns `{ commits: [{ sha }], branch }`
- Merge strategies: `head` (no merge), `branch` (explicit branch persists), `merge-to-head` (temp branch merged and deleted)

**CloseResult**:

```typescript
const closeResult = await sandbox.close();
if (closeResult.preservedWorktreePath) {
  console.log(`Dirty worktree preserved at ${closeResult.preservedWorktreePath}`);
}
```

**Explicit ownership evidence**: `CloseResult.preservedWorktreePath` is the only durable ownership signal. Sandcastle does not maintain a persistent session registry.

**Integration requirement for MartiX**: A future adapter must consume `CloseResult.preservedWorktreePath` explicitly, not infer ownership from directory names or branch prefixes.

#### 6. Concurrency and parallelization

**Pattern**: Parallel agent execution via `Promise.allSettled`

```typescript
const settled = await Promise.allSettled(
  issues.map(async (issue) => {
    const sandbox = await createSandbox({
      branch: issue.branch,
      sandbox: docker(),
    });
    try {
      return await sandbox.run({ agent, prompt });
    } finally {
      await sandbox.close();
    }
  }),
);
```

**Error handling**: Individual agent failures do not cancel other agents.

**Stability**: Standard JavaScript concurrency, not a Sandcastle-specific API.

#### 7. Cancellation and signals

**Public API**: `signal: AbortSignal` accepted by `run()`, `createSandbox()`, `interactive()`, `wt.run()`, `wt.interactive()`

```typescript
const controller = new AbortController();

const result = await run({
  agent: claudeCode("claude-opus-4-8"),
  sandbox: docker(),
  prompt: "...",
  signal: controller.signal,
});

// Cancel from elsewhere:
controller.abort(new Error("User requested cancellation"));
```

**Behavior**:

- Kills in-flight agent subprocess
- Worktree preserved on disk (not removed)
- Promise rejects with `signal.reason`

**Stability**: Documented public API.

#### 8. Environment variables and secrets

**Public API**: `env` option on `run()`, `createSandbox()`, `interactive()`, and their worktree variants

```typescript
await run({
  agent: claudeCode("claude-opus-4-8"),
  sandbox: docker({
    env: { DOCKER_SPECIFIC: "value" },
  }),
  env: { API_KEY: "secret" },
  prompt: "...",
});
```

**Environment variable precedence** (highest to lowest):

1. `run()` / `createSandbox()` `env` option
2. Provider-level `env` (e.g., `docker({ env })`)
3. `.sandcastle/.env` file (loaded via `--env-file`)
4. Host environment variables

**Security note**: Sandcastle loads `.env` files but does not enforce secrets isolation. The responsibility for network access, credential scoping, and artifact export belongs to the container image and provider configuration.

#### 9. Logging and observability

**Public API**: `logging` option on `run()`, `createSandbox()`, `interactive()`

```typescript
await run({
  agent: claudeCode("claude-opus-4-8"),
  sandbox: docker(),
  prompt: "...",
  logging: {
    type: "file",
    path: ".sandcastle/logs/my-run.log",
    verbose: true, // include raw stdout lines
    onAgentStreamEvent: (event) => {
      // event: { type: "text" | "toolCall" | "raw", iteration, timestamp, ... }
      myLogger.info(event);
    },
  },
});
```

**Observability hook**: `onAgentStreamEvent` callback fires for each text chunk, tool call, and raw stdout line. Errors thrown by the callback are swallowed to prevent broken forwarders from killing the run.

**Stability**: Documented public API.

#### 10. Session resume and fork

**Public API**: `resumeSession` option on `run()` and `sandbox.run()`

```typescript
const firstRun = await run({
  agent: claudeCode("claude-opus-4-8"),
  sandbox: docker(),
  prompt: "...",
});

// Resume from the captured session (if provider supports it)
if (firstRun.resume) {
  const resumedRun = await firstRun.resume("Continue with ...");
}
```

**Fork API**: `result.fork(prompt)` — fork the session (parent left intact)

**Stability**: Documented in README. Session file must exist on host. Incompatible with `maxIterations > 1`.

**Provider support**: Claude Code captures session IDs; other providers may not. Check `result.resume` existence.

### Matt Skills extension points

#### 1. Installation modes

**skills.sh** (editable copies):

```bash
npx skills@latest add mattpocock/skills
```

Copies skill files into the repository for local customization.

**Native plugin** (managed bundle):

```bash
claude plugin marketplace add mattpocock/skills
claude plugin install mattpocock-skills@mattpocock
```

Read-only bundle that updates when the author ships new versions.

**Portability**: Skills.sh installer supports Codex and other Agent-Skills-standard harnesses. Native Codex plugin is on the roadmap (see ADR 0002 in Matt Skills repo).

#### 2. Issue tracker integration

**Configured via** `/setup-matt-pocock-skills`:

- GitHub Issues
- Linear
- Local files

**Ticket format**: Determined by selected tracker. Dependency edges expressed as native blocking links or text references in a local file.

**Extension seam**: Issue tracker abstraction is internal to Matt Skills. No public API for custom trackers documented in README.

#### 3. Domain modeling and shared language

**Artifacts**:

- `CONTEXT.md` — domain glossary and terminology
- ADRs (Architecture Decision Records) — hard-to-explain decisions

**Built by**: `/grill-with-docs` and `/domain-modeling`

**Purpose**: Reduce agent verbosity, improve variable/function naming consistency, provide concise shared language.

**Stability**: User-facing workflow, not a programmatic API.

#### 4. Triage labels

**Configured via** `/setup-matt-pocock-skills`:

- User selects labels applied during `/triage`
- Triage state machine moves issues through roles

**Extension seam**: Label configuration is internal. No public API for custom triage flows.

### MartiX current integration

**Container image** (`.sandcastle/Dockerfile`):

- Based on custom agent runtime
- Includes repository-specific tools and dependencies
- Defines working user, Git configuration, entrypoint

**Orchestration script** (`.sandcastle/main.mts`):

- Four-phase loop: Plan → Execute + Review → Merge
- Uses `sandcastle.run()` for planner and merger
- Uses `createSandbox()` for parallel implement-review pipelines
- `Promise.allSettled` for concurrent issue execution
- Structured output extraction with Zod schema for plan

**Prompts**:

- `plan-prompt.md` — instructs premium reasoning agent to build dependency graph and select unblocked issues
- `implement-prompt.md` — instructs implementer to complete a ticket
- `review-prompt.md` — instructs reviewer to fix issues in completed work
- `merge-prompt.md` — instructs merger to integrate all completed branches

**Coding standards** (`.sandcastle/CODING_STANDARDS.md`):

- Repository boundaries (skills vs plugins)
- Documentation and Markdown rules
- PowerShell and TypeScript conventions
- Testing and validation requirements
- Git workflow and commit message format

**Completion signal**: `<promise>COMPLETE</promise>` (default)

## Evidence gaps and future integration seams

### Thin adapter boundaries

A future MartiX integration adapter should translate ticket metadata into:

1. **Skill selection** — map ticket labels or content to MartiX skill routing
2. **Model requirements** — select model tier, reasoning effort, token budget
3. **Sandbox inputs** — environment variables, mounted directories, hooks
4. **Validation commands** — repository-specific completion signal, linting, testing
5. **Result metadata** — commit SHA, log file path, preserved worktree path, success/failure

### What the adapter must NOT own

- **Planning workflows** — delegate to Matt Skills
- **Ticket decomposition** — delegate to Matt Skills
- **Container orchestration** — delegate to Sandcastle
- **Sandbox lifecycle** — delegate to Sandcastle `run()` and `createSandbox()`
- **Worktree cleanup** — consume `CloseResult.preservedWorktreePath`; do not implement independent discovery

### Evidence gaps identified

#### 1. Matt Skills programmatic API

**Gap**: Matt Skills README documents user-facing workflows (`/grill-with-docs`, `/to-tickets`, `/implement`) but does not expose a programmatic TypeScript API for external orchestrators.

**Open questions**:

- Can an orchestrator invoke Matt Skills programmatically, or only via agent skills?
- Is there a published schema for ticket formats, dependency edges, or triage state?
- Can MartiX consume Matt Skills artifacts (specs, tickets, CONTEXT.md) without reimplementing their generation?

**Recommendation**: Review Matt Skills source code (`skills/engineering/*/`) and CHANGELOG for programmatic entry points. If none exist, propose an adapter boundary that treats Matt Skills output as immutable artifacts to be consumed, not generated.

#### 2. Sandcastle persistent ownership manifests

**Gap**: Sandcastle `CloseResult.preservedWorktreePath` signals a retained worktree, but there is no persistent manifest or API for tracking worktree ownership across process restarts.

**Current evidence**:

- `CloseResult.preservedWorktreePath` — ephemeral, returned in-process only
- No `.sandcastle/sessions.json` or similar ownership registry
- No public API for listing or claiming abandoned worktrees

**Recommendation**: A MartiX adapter must either:

- Consume `CloseResult` inline and persist its own ownership records, or
- Propose a Sandcastle extension for durable ownership evidence (manifest file, database, or API)

**Do not**: Infer ownership from directory names, branch prefixes, or missing upstreams.

#### 3. Sandcastle network and secrets isolation

**Gap**: Sandcastle README does not document default network isolation, secrets scoping, or artifact export restrictions.

**Current evidence**:

- `docker()` provider accepts `network` option to attach container to Docker networks
- Environment variables passed via `env` option
- No documented default deny for network access, host Docker socket, or undeclared artifact export

**Open questions**:

- Does Sandcastle deny network access by default, or is that the container image's responsibility?
- How should credentials be scoped per ticket?
- Can an agent expand its own sandbox privileges (e.g., mount host Docker socket)?

**Recommendation**: Treat network, credential, and artifact isolation as container-image and provider responsibilities. A future MartiX adapter should document a secure baseline image and declare permissions explicitly per ticket.

#### 4. Concurrency and failure recovery

**Gap**: README documents `Promise.allSettled` for parallel agents but does not specify:

- Maximum concurrency limits
- Retry policies for transient failures
- Partial failure handling (some agents succeed, others fail)
- Deadlock detection for circular dependencies

**Current evidence**:

- `Promise.allSettled` allows individual failures without canceling others
- No built-in retry, backoff, or dependency resolution beyond what the planner emits

**Recommendation**: Concurrency policy and retry logic belong in the orchestration layer (e.g., `.sandcastle/main.mts`), not Sandcastle core. A MartiX adapter should implement these as application logic.

#### 5. Preview and unstable features

**Labeled explicitly**:

- **Session resume/fork**: Documented in README, requires provider support, incompatible with `maxIterations > 1`
- **Structured output**: Documented, requires `maxIterations === 1` and `<tag>` in prompt
- **Daytona provider**: Labeled as peer dependency, optional
- **Custom providers**: Public helpers (`createBindMountSandboxProvider`, `createIsolatedSandboxProvider`) but not widely documented with examples

**Not labeled as preview/unstable**: Core APIs (`run()`, `createSandbox()`, `createWorktree()`, `interactive()`, `claudeCode()`, `docker()`, `podman()`, `vercel()`)

**Recommendation**: Treat labeled features as preview; treat unlabeled core APIs as stable. Monitor CHANGELOG for breaking changes.

## Licensing and attribution

Both Matt Skills and Sandcastle are MIT-licensed (Copyright 2026 Matt Pocock). MartiX Skills may freely use, modify, and distribute adaptations under MIT license terms, provided copyright notices are retained.

**Commercial use**: Permitted under MIT.

**Derivative works**: Permitted; must retain license and copyright.

**Attribution**: Required in source code and documentation.

## Recommendations for MartiX integration

### 1. Treat Matt Skills as a separate planning tool

- Do not embed Matt Skills inside MartiX packages
- Consume Matt Skills artifacts (specs, tickets, CONTEXT.md, ADRs) as immutable inputs
- Document Matt Skills as the recommended external planning workflow
- Publish a roadmap for optional integration, not replacement

### 2. Treat Sandcastle as the execution engine

- Use Sandcastle `run()`, `createSandbox()`, and `createWorktree()` as public APIs
- Do not reimplement container lifecycle, worktree management, or commit collection
- Extend via custom agent providers, sandbox providers, and hooks
- Consume `CloseResult.preservedWorktreePath` explicitly; persist ownership records if needed

### 3. Build a thin adapter, not an orchestrator

A future MartiX integration adapter should:

- Translate ticket metadata into Sandcastle `run()` options
- Select MartiX skills based on ticket labels or content
- Inject repository-specific validation commands
- Forward observability events to external systems
- Preserve Sandcastle's ownership of container and worktree lifecycle

### 4. Define security and isolation policies

- Deny network, credentials, host Docker access, and undeclared artifact export by default
- Grant permissions explicitly per ticket
- Document a secure baseline container image
- Use provider-level `env` and `mounts` for controlled access

### 5. Monitor upstream changes

- Review Matt Skills and Sandcastle CHANGELOGs regularly
- Revalidate integration assumptions after major releases
- Publish a new dated research snapshot within six months or after a breaking change

### 6. Propose upstream enhancements cautiously

Before proposing changes to Matt Skills or Sandcastle:

- Validate that the need cannot be solved in the adapter layer
- Check if the capability already exists but is undocumented
- Engage with upstream maintainers before designing against assumed APIs

## Conclusion

This research snapshot establishes the current (2026-07-22) responsibilities, extension points, and integration seams for Matt Skills and Sandcastle. It identifies evidence gaps (programmatic Matt Skills API, persistent ownership manifests, network/secrets isolation) that a future MartiX adapter must address. The recommended approach is a thin adapter that translates ticket metadata into Sandcastle execution parameters and MartiX skill selection, without reimplementing planning or orchestration.

## Related research

- [Sandcastle-aligned worktree maintenance plugin plan](../git-worktree-workflows/sandcastle-aligned-plugin-plan.md)
- [2026-07 AI agent ecosystem and documentation review](./2026-07-22-ai-agent-ecosystem-and-documentation-review.md)

---

*This research snapshot may receive labeled errata. New findings belong in a new dated snapshot.*
