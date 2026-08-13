# Quality gates and release policy

## Purpose

Keep Platform support, capability maturity, and release claims tied to
machine-verifiable evidence rather than confidence or generated output alone.

## Default guidance

- Classify capabilities and providers as Supported, Experimental, or Deferred
  according to the current quality policy. The bootstrap manifest's empty
  `supportClaims` means the repository has not yet made broad support promises.
- Make gates fail closed on invalid manifests, unsupported combinations,
  missing security evidence, missing migration evidence, failed tests, or
  unverified performance/AOT claims.
- Keep quality-gate profiles explicit for the chosen preset and provider. A
  capability is not complete until its positive path, negative path, failure
  behavior, observability, and recovery evidence exist.
- Treat release evidence as an artifact: source/version, manifest, commands,
  environment, provider, test results, generated diff, and known limitations.
- Distinguish a package upgrade from a Platform Migration when generated source,
  schema, configuration, dependencies, or operational contracts change.

## Avoid

- Do not describe an Experimental or Deferred capability as production-ready.
- Do not weaken a failing gate to make generation or release green.
- Do not use a benchmark from a different runner, provider, or feature profile
  as evidence for the current claim.
- Do not promise universal rollback for destructive data migrations.

## Review checklist

- [ ] Support state and exact profile are named.
- [ ] Gates reject invalid combinations before generation or release.
- [ ] Evidence includes positive, negative, failure, and recovery paths.
- [ ] Known limitations and irreversible operations are documented.
- [ ] Release or migration records are immutable and reproducible.

## Related files

- [Authority and status](./foundation-authority-and-status.md)
- [Preset capabilities](./foundation-preset-capabilities.md)
- [Migrations and AOT](./delivery-migrations-aot.md)
- [Migration and support model](../references/migration-and-support-model.md)

## Source anchors

- `C:\Git\MartiXDev\Platform\eng\quality-gates.json`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\platform-blueprint.md`
- `C:\Git\MartiXDev\Platform\docs\wayfinder\martix-platform\migration-roadmap.md`
