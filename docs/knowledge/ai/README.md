# AI-assisted development

This is the landing page for AI-related knowledge and research. Resource files
collect primary links; `knowledge.md` files contain current synthesis; dated
documents under `research/` preserve evidence and proposals.

## Topic contract

Each AI subtopic should expose a `README.md`. Normalize older filenames toward
the following roles when a file is next refreshed:

| Role | Purpose |
| --- | --- |
| `resources.md` | Canonical links to the original sources. |
| `knowledge.md` | Current, reusable synthesis and repository decisions. |
| `research/YYYY-MM-DD-*.md` | Dated evidence snapshots. |

## Topics

| Topic | Resources | Current knowledge or research |
| --- | --- | --- |
| [Glossary](./glossary/README.md) | [resources](./glossary/resources.md) | Shared AI and repository terminology. |
| [Best practices](./best-practices/README.md) | [resources](./best-practices/resources.md) | [knowledge](./best-practices/knowledge.md) and dated research. |
| [Ecosystem](./ecosystem/README.md) | [resources](./ecosystem/resources.md) | Dated catalogues of external skills, plugins, and discovery sources. |
| [Hooks](./hooks/README.md) | [resources](./hooks/ai-hooks-resources.md) | Claude Code, VS Code, and Copilot hook references. |
| [LLM](./llm/README.md) | Topic resource links are currently distributed across the files below. | Model selection, prompt caching, cost, and session research. |
| [Plugins](./plugins/README.md) | [resources](./plugins/ai-plugins-resources.md) | [Research](./plugins/ai-plugins-research.md). |
| [Skills](./skills/README.md) | [resources](./skills/resources.md) | Dated optimization and evaluation research. |
| [Tools](./tools/README.md) | Sources are documented in each proposal. | Broader AI development environment design. |
| [Copilot](./copilot/README.md) | [resources](./copilot/copilot-resources.md) | Copilot-specific source notes and comparisons. |

## Refresh rule

When upstream guidance changes, update the topic resource registry first, add a
new dated research snapshot when evidence or recommendations change, and only
then update the current knowledge document. Do not silently rewrite a dated
research baseline.
