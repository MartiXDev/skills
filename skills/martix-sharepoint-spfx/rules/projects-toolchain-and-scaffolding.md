## SPFx projects — toolchain and scaffolding

Use this rule for project creation, generator choice, global prerequisites,
and day-one developer-environment setup.

### Purpose

- Keep scaffolding aligned with the intended SPFx component type and version
  family.
- Prevent build, serve, and debug instructions from drifting away from the
  project's supported toolchain.

### Default guidance

- Scaffold with the official SharePoint Framework generator and select the
  exact component type you need instead of creating a nearby type and
  reshaping it later.
- For current SharePoint Online projects, use the current environment-setup
  guidance and Heft-based toolchain. For older or on-premises projects, stay
  on the legacy gulp-era toolchain path.
- Keep generator-produced dependency versions, scripts, and folder structure
  unless there is a specific supported reason to change them.
- After creating a modern Heft project, install dependencies and trust the
  development certificate with `heft trust-dev-cert` before debugging.
- Use `SPFX_SERVE_TENANT_DOMAIN` or the project `serve.json` file to make the
  hosted workbench or target site explicit.
- For Form Customizers or other list-specific debugging, use `serve.json`
  configurations that point to the real list, form, and component context.

### Avoid

- Mixing Heft and gulp commands in the same troubleshooting path without first
  proving which toolchain the project uses.
- Hand-editing large sets of SPFx package versions after scaffold as a way to
  create a "custom baseline."
- Assuming a web part scaffold can be cheaply reshaped into an extension or
  Form Customizer without generator-specific structure.
- Leaving debug URLs implicit when the experience depends on a specific site,
  list, or form surface.

### Review checklist

- [ ] The scaffolded component type matches the requirement.
- [ ] The global prerequisites and commands match the SPFx version family.
- [ ] The debug or serve target is explicit.
- [ ] Package installation, build, and trust-dev-cert steps are placed on the
  correct toolchain branch.

### Related files

- [Versioning and compatibility rule](./tooling-versioning-and-compatibility.md)
- [Toolchain and deployment map](../references/toolchain-deployment-map.md)
- [Component selection map](../references/component-selection-map.md)
- [Form Customizer rule](./components-form-customizers-and-library-components.md)

### Source anchors

- [Set up your development environment](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/set-up-your-development-environment)
- [Tools and libraries](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/tools-and-libraries)
- [Form Customizer](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/extensions/get-started/building-form-customizer)
