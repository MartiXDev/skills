# Matt Pocock Skills v1.2 refresh research

**Prepared:** 2026-08-07  
**Scope:** Refresh `docs/knowledge/matt-pocock/matt-pocock-skills-kompletni-mapa.md`
from the source index in
`docs/knowledge/matt-pocock/matt-pocock-resources.md`, with special attention to
the v1.2 release line and the linked Sandcastle project.

## Executive findings

The local map was anchored to `mattpocock/skills` v1.1.0 and described 22
promoted Engineering/Productivity skills: 13 user-invoked and 9
model-invoked (`docs/knowledge/matt-pocock/matt-pocock-skills-kompletni-mapa.md:5-14`).
The current upstream package/plugin is v1.2.3. Its promoted catalog contains 25
skills: 14 user-invoked and 11 model-invoked.

The v1.2 release line adds three promoted skills, renames and reclassifies one
skill, changes several existing workflows, adds Codex metadata alongside each
skill, and ships a native Claude Code plugin:

| Change | Result |
|---|---|
| New skills | `wizard` (model-invoked), `to-questionnaire` (user-invoked), `wait-what` (user-invoked) |
| Rename/reclassification | `writing-great-skills` (user-invoked) is replaced by `writing-for-agents` (model-invoked); the old path is gone |
| Workflow changes | `grilling` now asks a dependency frontier in rounds; `prototype` retains a shareable HTML result on a `prototype/<name>` branch; `wayfinder` uses decision tickets and parallel research subagents |
| v1.2.3 patches | `wizard` no longer estimates time remaining; `diagnosing-bugs` redacts secrets in captured evidence; several dispatch descriptions are harness-neutral |
| Tooling | Every skill has `agents/openai.yaml`; `AGENTS.md` mirrors `CLAUDE.md`; Claude Code can install the managed plugin with `claude plugins install mattpocock-skills` |

The three links in the local source index are still live. The AI Hero skills
page is now a multi-page pillar/hub rather than the old flat count comparison.
Sandcastle is now a broader TypeScript orchestration library at v0.12.0, with
Docker, Podman, Vercel, and no-sandbox providers, while the branch and merge
templates used by the map still exist and retain the important
integration-branch behavior.

## 1. Source index and evidence strategy

The user-provided source index contains:

1. AI Hero and its Skills hub:
   `docs/knowledge/matt-pocock/matt-pocock-resources.md:5`
2. The first-party `mattpocock/skills` repository:
   `docs/knowledge/matt-pocock/matt-pocock-resources.md:6`
3. The first-party Sandcastle repository:
   `docs/knowledge/matt-pocock/matt-pocock-resources.md:8-10`

The exact catalog and invocation counts were taken from the upstream plugin
manifest and the Engineering/Productivity READMEs, not inferred from an
AI Hero article:

- [Skills repository](https://github.com/mattpocock/skills)
- [v1.2.0 release](https://github.com/mattpocock/skills/releases/tag/v1.2.0)
- [v1.2.3 release](https://github.com/mattpocock/skills/releases/tag/v1.2.3)
- [v1.2.3 `CHANGELOG.md`](https://github.com/mattpocock/skills/blob/v1.2.3/CHANGELOG.md)
- [v1.2.3 package manifest](https://github.com/mattpocock/skills/blob/v1.2.3/package.json)
- [v1.2.3 Claude plugin manifest](https://github.com/mattpocock/skills/blob/v1.2.3/.claude-plugin/plugin.json)
- [Engineering catalog](https://github.com/mattpocock/skills/blob/v1.2.3/skills/engineering/README.md)
- [Productivity catalog](https://github.com/mattpocock/skills/blob/v1.2.3/skills/productivity/README.md)

The current `main` snapshot checked for the map is commit
[`84fdeffd12f2ee307994d1eb6feb48173b6e0502`](https://github.com/mattpocock/skills/commit/84fdeffd12f2ee307994d1eb6feb48173b6e0502).
It is two commits ahead of the v1.2.3 release tag; the post-tag changes were
documentation-only wording changes in the inspected history. The map therefore
states both the reproducible release (`v1.2.3`) and the current `main` commit.

## 2. What "v1.2" means

AI Hero's Skills hub lists the changelog entry **"v1.2: /wait-what,
/writing-for-agents, Claude Code Plugin, and more"** with an August 5, 2026
date:

- [AI Hero Skills hub](https://www.aihero.dev/skills)

The GitHub package history identifies the same release line as `1.2.0`,
followed by patch releases `1.2.2` and `1.2.3` in `CHANGELOG.md`. GitHub's
release pages confirm the published `v1.2.0` and latest patch `v1.2.3`.
Accordingly, "v1.2" is not a separate product: it is the
`mattpocock-skills` package/plugin minor release line from 1.2.0 through
1.2.3, replacing the local map's v1.1.0 baseline.

The long-form AI Hero v1.2 article linked by the hub could not be fetched at a
stable standalone URL during this research pass. The GitHub changelog, release
pages, source manifests, individual skill files, and AI Hero detail pages
provide first-party evidence for the same changes.

## 3. Current promoted inventory

### Engineering: 18 total

**User-invoked (9):**

`ask-matt`, `grill-with-docs`, `triage`,
`improve-codebase-architecture`, `setup-matt-pocock-skills`, `to-spec`,
`to-tickets`, `implement`, `wayfinder`

**Model-invoked (9):**

`prototype`, `diagnosing-bugs`, `research`, `tdd`, `domain-modeling`,
`codebase-design`, `code-review`, `resolving-merge-conflicts`, `wizard`

### Productivity: 7 total

**User-invoked (5):**

`grill-me`, `handoff`, `teach`, `to-questionnaire`, `wait-what`

**Model-invoked (2):**

`grilling`, `writing-for-agents`

Sources:

- [Engineering README at v1.2.3](https://github.com/mattpocock/skills/blob/v1.2.3/skills/engineering/README.md)
- [Productivity README at v1.2.3](https://github.com/mattpocock/skills/blob/v1.2.3/skills/productivity/README.md)
- [Claude plugin manifest at v1.2.3](https://github.com/mattpocock/skills/blob/v1.2.3/.claude-plugin/plugin.json)

### Delta from the local map

| Baseline | Current | Net change |
|---|---:|---:|
| 22 promoted skills | 25 promoted skills | +3 |
| 13 user-invoked | 14 user-invoked | +1 |
| 9 model-invoked | 11 model-invoked | +2 |

The exact v1.2 changes are:

- `wizard` graduated into the Engineering catalog as model-invoked.
- `to-questionnaire` graduated into Productivity as user-invoked.
- `wait-what` was added to Productivity as user-invoked.
- `writing-great-skills` was renamed to `writing-for-agents` and moved from
  user-invoked to model-invoked. The old name is a breaking rename, not an
  alias.

The following non-promoted skills were also removed since the older snapshot:
`ubiquitous-language`, `design-an-interface`, `qa`,
`request-refactor-plan`, `edit-article`, and `obsidian-vault`. The entire
`skills/personal/` bucket is gone. The promoted 25-count is unaffected because
these were outside the main Engineering/Productivity catalog.

## 4. Behavioral changes that affect the map

### 4.1 `grilling` is round-based

The old map called `grilling` a reusable "one-question-at-a-time loop"
(`matt-pocock-skills-kompletni-mapa.md:532`). The current skill defines a
frontier: ask every decision whose prerequisites are settled in one numbered
round, then recompute the frontier for the next round. The v1.2 changelog
describes the practical improvement as the same 13 questions landing in about
three rounds instead of 13.

- [`grilling/SKILL.md`](https://github.com/mattpocock/skills/blob/v1.2.3/skills/productivity/grilling/SKILL.md)
- [`CHANGELOG.md` v1.2.0 entry](https://github.com/mattpocock/skills/blob/v1.2.3/CHANGELOG.md)

This behavior is inherited by `grill-me`, `grill-with-docs`, `triage`, and
other flows that delegate to `grilling`.

### 4.2 `prototype` retains evidence instead of deleting it

The current prototype skill distinguishes logic and UI questions:

- logic questions produce one shareable HTML file with free-play controls and
  guided walkthrough tabs;
- UI questions produce toggleable variations on one route;
- the completed result is committed to a `prototype/<name>` branch off `main`,
  and the implementation issue receives a context pointer.

Thus "throwaway" describes production scope and branch isolation, not an
instruction to erase the primary-source evidence.

- [`prototype/SKILL.md`](https://github.com/mattpocock/skills/blob/v1.2.3/skills/engineering/prototype/SKILL.md)

### 4.3 `wayfinder` formalizes decision tickets and parallel research

`wayfinder` now names its units "decision tickets" and uses ticket labels such
as `wayfinder:research`, `wayfinder:prototype`, `wayfinder:grilling`, and
`wayfinder:task`. Research tickets are deliberately burned down in parallel by
research subagents during charting; they are the exception to the normal
one-decision-ticket-per-session guidance.

- [`wayfinder/SKILL.md`](https://github.com/mattpocock/skills/blob/v1.2.3/skills/engineering/wayfinder/SKILL.md)

### 4.4 `ask-matt` added phase-boundary routing

The router now explicitly chooses among continuing in the current context,
`/clear`, `/handoff`, a subagent, and `/compact` at phase boundaries. It also
uses a roughly 150k-token smart-zone figure on current state-of-the-art models,
adds router entries for `grilling` and `resolving-merge-conflicts`, and uses
decision-ticket terminology for Wayfinder.

- [`ask-matt/SKILL.md`](https://github.com/mattpocock/skills/blob/v1.2.3/skills/engineering/ask-matt/SKILL.md)

### 4.5 Patch-level details in v1.2.3

- `wizard` removed the time-remaining estimate; progress is now reported by
  stages.
- `diagnosing-bugs` added a mandatory redaction step: secrets in commands or
  output must be replaced with `<REDACTED>` before captured evidence is shown
  or stored.
- Several subagent-dispatch descriptions were rewritten to avoid assuming a
  particular harness.

Sources:

- [`wizard/SKILL.md`](https://github.com/mattpocock/skills/blob/v1.2.3/skills/engineering/wizard/SKILL.md)
- [`diagnosing-bugs/SKILL.md`](https://github.com/mattpocock/skills/blob/v1.2.3/skills/engineering/diagnosing-bugs/SKILL.md)
- [`CHANGELOG.md` v1.2.3 entry](https://github.com/mattpocock/skills/blob/v1.2.3/CHANGELOG.md)

## 5. Invocation and installation model

v1.2 supports both Claude Code and Codex-oriented metadata:

- every promoted `SKILL.md` has a sibling `agents/openai.yaml` with Codex UI
  metadata;
- `policy.allow_implicit_invocation: false` is the Codex-side control for
  user-invoked skills;
- `AGENTS.md` is provided alongside `CLAUDE.md` for agent-instruction
  compatibility;
- `writing-for-agents` received a patch exception so Codex can still reach it
  implicitly as a model-invoked authoring discipline.

The Claude Code distribution is now a native plugin:

```text
claude plugins install mattpocock-skills
```

The editable, harness-neutral installer remains:

```text
npx skills@latest add mattpocock/skills
```

These are different distribution surfaces. The managed plugin is convenient
for Claude Code; the `skills` installer is the editable path and remains the
relevant path for Codex until a native Codex plugin exists. Installing both
surfaces in the same environment can create duplicate or ambiguous copies.

Sources:

- [Skills README, installation](https://github.com/mattpocock/skills#installation)
- [Plugin manifest at v1.2.3](https://github.com/mattpocock/skills/blob/v1.2.3/.claude-plugin/plugin.json)
- [Codex invocation metadata example](https://github.com/mattpocock/skills/blob/v1.2.3/skills/engineering/research/agents/openai.yaml)
- [Claude/Codex compatibility files](https://github.com/mattpocock/skills/tree/v1.2.3/skills/engineering/research)

## 6. Sandcastle refresh

The linked Sandcastle repository is live and its package is v0.12.0:

- [Sandcastle repository](https://github.com/mattpocock/sandcastle)
- [Sandcastle v0.12.0 release](https://github.com/mattpocock/sandcastle/releases/tag/v0.12.0)
- [Sandcastle package manifest](https://github.com/mattpocock/sandcastle/blob/v0.12.0/package.json)

The current README frames Sandcastle as a TypeScript library for orchestrating
AI coding agents in isolated sandboxes. It documents Docker, Podman, Vercel,
and no-sandbox providers, plus programmatic `run()`, `interactive()`, and
`createSandbox()` APIs. This is broader than the older "GitHub Issues scaffold"
framing.

The map's core branch-safety claims remain supported by the first-party
templates:

- the parallel planner selects unblocked issues, creates one branch/sandbox per
  issue, runs implementer/reviewer pipelines concurrently, and merges completed
  branches into the current branch;
- the merge prompt explicitly merges each branch into the current branch,
  tests after conflict resolution, and closes the corresponding issues;
- initialization still exposes the `parallel-planner-with-review` template.

Sources:

- [Sandcastle README](https://github.com/mattpocock/sandcastle#how-it-works)
- [`InitService.ts` at v0.12.0](https://github.com/mattpocock/sandcastle/blob/v0.12.0/src/InitService.ts)
- [Planner template at v0.12.0](https://github.com/mattpocock/sandcastle/blob/v0.12.0/src/templates/parallel-planner-with-review/main.mts)
- [Merge prompt at v0.12.0](https://github.com/mattpocock/sandcastle/blob/v0.12.0/src/templates/parallel-planner-with-review/merge-prompt.md)
- [Review prompt at v0.12.0](https://github.com/mattpocock/sandcastle/blob/v0.12.0/src/templates/parallel-planner-with-review/review-prompt.md)

The `#how-it-works` anchor and top-level README prose have moved since the
older map was written. Direct template citations are more stable for the
branch-target and fan-out/fan-in claims.

## 7. Map updates applied

The map was refreshed to the v1.2.3/current-main snapshot with these changes:

1. Header date, version, counts, and the pinned current `main` commit were
   updated.
2. The obsolete AI Hero flat-count comparison was removed; the page is now
   described as a pillar/hub.
3. `wizard`, `to-questionnaire`, and `wait-what` were added to the routing,
   artifact, decision-tree, and catalog sections.
4. `writing-great-skills` was replaced by `writing-for-agents` and moved to
   model-invoked Productivity.
5. `grilling` was changed from a one-question loop to a round-based frontier
   loop.
6. `prototype` now documents the single shareable HTML artifact and
   `prototype/<name>` branch/context-pointer retention.
7. `ask-matt` context hygiene now records phase-boundary routing and the
   approximately 150k-token smart zone.
8. `wayfinder` research-ticket parallelism and decision-ticket terminology were
   made explicit.
9. v1.2 dual-harness metadata, plugin installation, and editable installation
   guidance were added.
10. The removed `Personal` bucket was removed from the side catalog; the
    `Deprecated` bucket is described as empty and the `Misc` entries remain.
11. Sandcastle's v0.12.0 broader provider/library framing was added without
    changing the map's safe integration-branch guidance.

The source-index file itself was not altered because all three user-provided
links remain live:
`docs/knowledge/matt-pocock/matt-pocock-resources.md:5-10`.

## 8. Limitations and reproducibility

- The AI Hero v1.2 changelog entry is visible on the Skills hub, but a stable
  standalone article URL could not be resolved during this pass. GitHub's
  release history and source files were used as the canonical behavioral
  evidence.
- The exact catalog is release-pinned to v1.2.3, while the map also records the
  current `main` commit because upstream continues to change.
- In-progress skills were not promoted into the 25-count. They remain a beta
  channel and should not be treated as part of the Engineering/Productivity
  operating catalog without an explicit release.
- For automation, pin a tag or commit, keep `agents/openai.yaml` and
  `CLAUDE.md`/`AGENTS.md` synchronized, and regenerate the map when upgrading.
