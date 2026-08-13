# Documentation architecture

This folder contains stable repository architecture decisions that explain how
packages are composed and where responsibilities belong.

| Document | Purpose |
| --- | --- |
| [Plugin bundle strategy](./plugin-bundle-strategy.md) | Decide when reusable domain knowledge stays a standalone skill and when a plugin bundle adds workflow value. |
| [AI-assisted software delivery lifecycle](./ai-software-delivery-lifecycle.md) | Proposal for the end-to-end product lifecycle, GitHub issue graph, agent orchestration, skills, guardrails, testing, review, deployment, and operations. |
| [MX configuration schema](./mx-config.schema.json) | JSON Schema for repository-owned `mx.config.json` values, structures, and enum constraints. |

Execution tiers and worktree procedure are operational concerns; use the
[maintainer guides](../guides/README.md) instead of adding them here.
