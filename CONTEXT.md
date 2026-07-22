# Repository glossary

<!--
role: normative
verified: 2026-07-22
-->

MartiX Skills exists to build evidence-backed domain capabilities that remain
reliable across model tiers, then use the lowest-cost model that clears explicit
quality and safety requirements for each task.

## MartiX Skills

The GitHub Copilot CLI marketplace maintained by this repository. It contains
standalone skills and plugin bundles; it is not itself one installable package.

## Standalone skill

A reusable, independently installable domain capability under
`skills/martix-*`. Its canonical behavior lives in its `SKILL.md`, `AGENTS.md`,
rules, references, templates, assets, metadata, and `evals/evals.json`.

## Plugin bundle

An installable package under `plugins/martix-*` that composes workflow assets
such as skills, agents, prompts, instructions, hooks, or MCP/LSP configuration.
Reusable domain guidance remains in standalone skills.

## Package

One standalone skill or one plugin bundle. Package-local work changes files
inside a single package and avoids shared coordinator surfaces.

## Router

The compact `SKILL.md` entrypoint that decides when a skill applies and points
to the smallest relevant rule or reference. It is not the complete knowledge
base.

## Canonical eval file

The single committed evaluation definition for a standalone skill:
`skills/<package>/evals/evals.json`. It contains behavior, positive activation,
and negative activation scenarios in the repository schema.

## Trigger scenario

An eval prompt that tests whether a skill should or should not activate. Trigger
scenarios are rows in the canonical eval file, not a separate package artifact.

## Benchmark input

A temporary file used by an external optimization or evaluation tool. It may
use a tool-specific schema, but it is not a canonical package artifact and does
not redefine repository conventions.

## Model eval wave

A frozen, dated comparison run triggered by a meaningful model or platform
change. It compares candidate models using the same skill commit, fixtures,
tools, scoring rules, and repeated trials.

## Capability gate

A binary requirement a model must support before entering an evaluation lane,
such as the required context size, tool calling, or structured output.

## Quality floor

The minimum repeated task-quality result a model must achieve for a specific
skill and task type.

## Safety floor

A non-compensable safety requirement. Lower cost or stronger results in another
dimension cannot offset its failure.

## Cheapest capable model

The lowest-total-cost model for a specific skill and task type that repeatedly
clears its capability gates, quality floor, safety floor, and variance limits.
It is a dated benchmark result, not a permanent model label.

## Document role

The declared purpose of a maintainer document: `normative`, `operational`,
`reference`, `research`, `roadmap`, or `historical`.

## Research snapshot

An immutable, dated evidence record. It may receive labeled errata, but newer
findings belong in a new snapshot rather than silently replacing its conclusions.
See [Document roles and archive policy](./docs/document-roles.md).

## Historical document

A superseded record retained for context and excluded from active guidance.
Historical is a document role; archive is its repository location. See
[Document roles and archive policy](./docs/document-roles.md).

## Matt Pocock Skills

The external planning and delivery workflow used to turn ideas into
specifications, dependency-aware tickets, implementations, and reviews.
Use `Matt Skills` after the first full-name mention.

## Sandcastle

The external sandboxed ticket-execution orchestrator used to run implementation
work in isolated containers.

## Integration adapter

A thin boundary that translates ticket metadata into MartiX skill selection,
model requirements, sandbox inputs, validation commands, and result metadata
without taking ownership of planning or container orchestration.

## Coordinator-owned surface

A shared file whose concurrent modification can affect multiple packages or
worktrees. Changes to these surfaces are serialized by the repository
coordinator.

## Completion signal

The repository-wide validation command
`powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1`.
A task is not complete until relevant focused checks and this command pass, or
an unrelated blocker is reported explicitly.
