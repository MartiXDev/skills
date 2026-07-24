# Agent architecture

## Default operating model

- One general coordinator owns intent and integration.
- Skills provide on-demand specialization.
- Subagents are reserved for context isolation, different permissions/model/tool profiles, parallel independent work, or unbiased review.
- Hooks and CI perform deterministic policy and verification.

## Stable roles

| Role | Access | Purpose | Required output |
|---|---|---|---|
| Coordinator | Workspace write; network by approval | Integrate the task | Diff, checks, risks |
| Explorer | Read-only | Find relevant evidence | Files, facts, uncertainties |
| Reviewer | Read-only, fresh context | Compare spec, diff, and evidence | Findings by severity |
| Risk reviewer | Read-only | Security/data/architecture review | Threats and required gates |

## Routing

Model names are mapped centrally in `ai/routing.json`. Route by ambiguity, blast radius, novelty, verification strength, security impact, context breadth, and reversibility. Escalate after repeated failure without new evidence.

## Hook policy

Portable scripts live under `scripts/ai/`. Vendor hook manifests call these scripts and must remain thin. Protect hook scripts, manifests, MCP configuration, CI, and setup workflows with review ownership.

