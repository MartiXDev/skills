# Repository glossary

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

## Coordinator-owned surface

A shared file whose concurrent modification can affect multiple packages or
worktrees. Changes to these surfaces are serialized by the repository
coordinator.

## Completion signal

The repository-wide validation command
`powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1`.
A task is not complete until relevant focused checks and this command pass, or
an unrelated blocker is reported explicitly.
