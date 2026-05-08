## Toolchain and deployment map

### Purpose

Use this map when build, serve, package, and rollout choices need to stay
aligned.

### Decision matrix

| Scenario | Default files or commands to inspect | Notes |
| --- | --- | --- |
| New SharePoint Online project | generator prompt answers, `package.json`, `config/package-solution.json` | Keep the scaffold aligned to the exact component type and SPFx release family |
| Existing Heft-based project | `package.json`, `heft trust-dev-cert`, `heft build`, `heft start`, `heft package-solution` | Do not mix in gulp-era commands without proving the project is still on the legacy toolchain |
| Existing gulp-era or on-prem project | `package.json`, legacy build scripts, older environment guidance | Treat the project as legacy until the SPFx version is upgraded deliberately |
| Form Customizer or list-specific debug session | `config/serve.json` plus named serve configurations | Keep `pageUrl`, list path, and component context explicit |
| Tenant-wide rollout | `config/package-solution.json` with `skipFeatureDeployment` | Use only when feature-based provisioning is not required |
| Teams package with custom manifest control | `teams/TeamsSPFxApp.zip` inside the solution package | Use this only when the automatic Add to Teams path is not sufficient |

### Build and rollout checkpoints

- Confirm the project toolchain before giving commands.
- Confirm whether the solution depends on Feature Framework assets.
- Confirm where assets are hosted and how updates flow.
- Confirm whether Teams or extension rollout introduces extra tenant-wide side
  effects.

### Related files

- [Projects and scaffolding rule](../rules/projects-toolchain-and-scaffolding.md)
- [Deployment rule](../rules/deployment-packaging-and-tenant-rollout.md)
- [Version support map](./version-support-map.md)
- [Teams and Viva map](./teams-viva-map.md)

### Source anchors

- [Set up your development environment](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/set-up-your-development-environment)
- [Solution packaging](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/web-parts/basics/notes-on-solution-packaging)
- [Tenant-scoped deployment](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/tenant-scoped-deployment)
- [Teams deployment options](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/deployment-spfx-teams-solutions)
