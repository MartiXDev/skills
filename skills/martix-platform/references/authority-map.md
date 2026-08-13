# Platform authority map

Use this map before answering any question that could depend on Platform
version, capability support, generated topology, or a future migration.

## Authority order

| Order | Source | What it proves |
| --- | --- | --- |
| 1 | Consuming repository source, project files, package references, manifest, and tests | What this application actually uses |
| 2 | Platform `README.md`, `AGENTS.md`, `CONTEXT.md`, `martix.platform.json`, source READMEs, fixtures, and quality gates | Current repository behavior and vocabulary |
| 3 | `docs\wayfinder\martix-platform\platform-blueprint.md` and `migration-roadmap.md` | Approved target architecture and sequencing |
| 4 | Wayfinder ticket files and historical notes | Rationale and provenance only |

## Status labels

- **Current**: verified in the current checkout or package surface.
- **Fixture evidence**: demonstrated by an acceptance fixture, but not
  necessarily a supported public API.
- **Target**: approved direction that still needs implementation and gates.
- **Deferred**: intentionally not part of the current profile.
- **Unknown**: not established; inspect the source or stop.

When a current source and target blueprint differ, state both and choose the
current verified behavior unless the user explicitly asks to design the target.

## Source paths

- `C:\Git\MartiXDev\Platform\README.md`
- `C:\Git\MartiXDev\Platform\AGENTS.md`
- `C:\Git\MartiXDev\Platform\CONTEXT.md`
- `C:\Git\MartiXDev\Platform\martix.platform.json`
- `C:\Git\MartiXDev\Platform\eng\quality-gates.json`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\map.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\platform-blueprint.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\migration-roadmap.md`
