## SPFx components — Form Customizers and library components

Use this rule when the task is about list or library form replacement or
about separately deployed reusable SPFx code.

### Purpose

- Keep Form Customizer decisions tied to form lifecycle and content-type
  association rather than generic page customization.
- Keep library components reserved for truly reusable, separately deployed
  client code.

### Default guidance

- Use a Form Customizer when you need to replace the new, edit, or display
  form experience for a list or library through a supported client-side
  component.
- Treat Form Customizers as SharePoint Online guidance and verify version
  support explicitly before using them in any constrained environment.
- Use `onInit()`, `render()`, and `onDispose()` as the lifecycle contract, and
  keep debug configuration in `serve.json` aligned with the real list, form,
  and content type context.
- Use a library component only when multiple SPFx solutions genuinely need a
  separately deployed shared client package.
- Keep library components small, stable, and versioned deliberately. Only one
  version can be active in a tenant at a time, so treat breaking changes as a
  tenant-wide coordination problem.
- Prefer normal shared code inside a single solution when cross-solution
  independent deployment is not actually required.

### Avoid

- Using a Form Customizer as a generic page app or a replacement for a web
  part.
- Assuming Form Customizer support exists in older or on-premises baselines
  without proving it.
- Creating a library component just to avoid an import path inside one
  solution.
- Hiding shared-library breaking changes behind a minor packaging decision.

### Review checklist

- [ ] Form lifecycle and target list or library context are explicit.
- [ ] The chosen SPFx version and environment support the Form Customizer path.
- [ ] Library component use is justified by cross-solution reuse, not local
  convenience.
- [ ] Separate deployment and upgrade impact are called out clearly.

### Related files

- [Component selection map](../references/component-selection-map.md)
- [Projects and scaffolding rule](./projects-toolchain-and-scaffolding.md)
- [Deployment rule](./deployment-packaging-and-tenant-rollout.md)
- [Host support matrix](../assets/host-support-matrix.json)

### Source anchors

- [Form Customizer](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/extensions/get-started/building-form-customizer)
- [Library component overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/library-component-overview)
- [Supported extensibility platforms](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/supported-extensibility-platforms-overview)
