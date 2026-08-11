# Platform authority and status

## Purpose

Prevent preview implementation details, fixture evidence, and approved
Wayfinder direction from being presented as one shipped API.

## Default guidance

- Inspect the consuming repository first: target framework, package references,
  `martix.platform.json`, generated manifest, and existing composition.
- Treat the consuming source and the current Platform checkout as the authority
  for what can be used now.
- Use `README.md`, `AGENTS.md`, `CONTEXT.md`, `martix.platform.json`, source
  package READMEs, tests, and `eng\quality-gates.json` for current evidence.
- Use `docs\wayfinder\martix-platform\platform-blueprint.md` and
  `migration-roadmap.md` for approved target direction. Label target-only
  guidance and propose a Platform Migration or issue rather than pretending it
  already exists.
- The current manifest is bootstrap-oriented with empty support claims. A
  generated fixture or preview package is evidence of shape, not a production
  support promise.

## Avoid

- Do not invent extension methods, capability names, providers, migrations, or
  package support from a blueprint paragraph.
- Do not use a historical Wayfinder ticket as an active issue tracker.
- Do not claim production readiness, Native AOT support, exactly-once delivery,
  or a supported capability unless the current quality policy and manifest prove
  it.

## Review checklist

- [ ] Every important claim is marked current, fixture evidence, or target.
- [ ] The target framework and package versions were checked.
- [ ] Unsupported or deferred behavior is surfaced instead of silently assumed.
- [ ] A verification command or source anchor exists for the recommendation.

## Related files

- [Authority map](../references/authority-map.md)
- [Platform surface map](../references/platform-surface-map.md)
- [Quality and release policy](./quality-gates-release-policy.md)

## Source anchors

- `C:\Git\MartiXDev\Platform\README.md`
- `C:\Git\MartiXDev\Platform\AGENTS.md`
- `C:\Git\MartiXDev\Platform\CONTEXT.md`
- `C:\Git\MartiXDev\Platform\martix.platform.json`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\`
