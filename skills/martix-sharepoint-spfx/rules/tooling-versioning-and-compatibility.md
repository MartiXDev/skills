## SPFx tooling — versioning and compatibility

Use this rule when the first real decision is which SPFx, Node, React,
TypeScript, or build-tool baseline the answer is allowed to assume.

### Purpose

- Keep guidance anchored to the official compatibility matrix instead of
  generic modern JavaScript instincts.
- Make SharePoint Server 2019 and Subscription Edition notes conservative and
  explicit.

### Default guidance

- For SharePoint Online, align recommendations to the actual SPFx version in
  the project and the current compatibility table rather than assuming that
  the latest runtime or package version is automatically valid.
- Use Heft guidance only for SPFx v1.22+ projects. Use the legacy gulp-based
  toolchain guidance for SPFx v1.0-v1.21.1 and for all on-premises projects.
- Keep React pinned to the exact version required by the chosen SPFx release.
  Do not upgrade React independently of SPFx, and prefer `--save-exact` when
  installing React packages in an SPFx project.
- Treat SharePoint Server 2019 as a fixed SPFx v1.4.1 baseline.
- Treat SharePoint Server Subscription Edition conservatively. The current
  compatibility page lists support through SPFx v1.5, while the supported
  platforms page and the detailed 2019/SE article describe SE as sharing the
  same dependencies or requirements as SharePoint Server 2019. Call out that
  mismatch instead of flattening it into certainty.
- Determine the real project baseline from `package.json`, `.yo-rc.json`, and
  installed `@microsoft/*` packages before recommending upgrades or fixes.

### Avoid

- Recommending the newest Node.js, React, TypeScript, or Fluent package by
  default.
- Mixing Heft commands into 2019 or other gulp-era projects.
- Treating the Subscription Edition support ambiguity as settled when the docs
  still conflict.
- Assuming an old project can be upgraded safely by bumping one dependency at
  a time without checking the SPFx release train.

### Review checklist

- [ ] The answer states the project or target SPFx version family clearly.
- [ ] The answer keeps Node, TypeScript, and React aligned to that family.
- [ ] The answer uses Heft only where the chosen SPFx version supports it.
- [ ] Any Subscription Edition note explicitly mentions the conflicting current
  documentation.

### Related files

- [Foundation rule](./foundation-scope-and-support-boundaries.md)
- [Projects and scaffolding rule](./projects-toolchain-and-scaffolding.md)
- [Version support map](../references/version-support-map.md)
- [Host support matrix](../assets/host-support-matrix.json)

### Source anchors

- [SPFx compatibility](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/compatibility)
- [Set up your development environment](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/set-up-your-development-environment)
- [Supported extensibility platforms](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/supported-extensibility-platforms-overview)
- [SharePoint 2019 and Subscription Edition support](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/sharepoint-2019-and-subscription-edition-support)
