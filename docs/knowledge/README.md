# Knowledge and research map

This directory is the canonical home for reusable knowledge, source registries,
and dated research. It replaces the former split between knowledge and research
trees without requiring every existing document to be renamed at once.

## Topic contract

Each topic should have a landing page and, where applicable, these roles:

| File or folder | Role |
| --- | --- |
| `README.md` | Scope, navigation, ownership, and refresh instructions. |
| `resources.md` | One canonical list of links to original sources. |
| `knowledge.md` | Current synthesis, decisions, or reusable guidance. |
| `research/YYYY-MM-DD-*.md` | Dated source-backed evidence and proposals. |

Older descriptive filenames remain valid until their next refresh; the topic
README must identify their role and link them. Keep dated research snapshots
immutable when possible, and create a new snapshot instead of silently
rewriting historical evidence.

## Domains

| Domain | Start here | Scope |
| --- | --- | --- |
| AI-assisted development | [AI map](./ai/README.md) | AI usage, hooks, LLMs, plugins, skills, tools, and Copilot. |
| Matt Pocock | [Matt Pocock map](./matt-pocock/README.md) | Matt Skills, Sandcastle, and related workflow research. |
| Repository | [Repository map](./repository/README.md) | Repository architecture, maintenance, and Git workflow research. |

## Related documentation

- [Root documentation index](../README.md) — maintainer guides and package
  source-document map.
- [`docs/martix/`](../martix/) — package-specific domain research and plans.
- [Custom AI artifact rules](../policy/custom-ai-artifact-rules.md) — artifact
  contracts that take precedence over research notes.
