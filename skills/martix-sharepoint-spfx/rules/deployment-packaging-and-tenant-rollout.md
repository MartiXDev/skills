## SPFx deployment — packaging and tenant rollout

Use this rule when the answer needs to shape `package-solution.json`, app
catalog deployment, asset hosting, or tenant-wide rollout behavior.

### Purpose

- Treat packaging as an architectural decision instead of a final publish step.
- Keep tenant-wide deployment and feature packaging choices explicit and safe.

### Default guidance

- Treat `config/package-solution.json` as the deployment contract for the
  solution. Keep `name`, `id`, `version`, `features`, and output paths
  deliberate.
- Distinguish code and asset rollout from Feature Framework versioning. New
  JavaScript and CSS become available when the new package is deployed, even
  when no site-level feature upgrade step exists.
- Use `skipFeatureDeployment = true` only when tenant-wide availability is the
  goal and the solution does not rely on Feature Framework assets that must be
  activated per site.
- Remember that feature definitions are ignored when tenant-wide deployment is
  used, so do not combine that mode with feature-driven provisioning casually.
- Keep asset hosting explicit. Whether assets stay in SharePoint, ride through
  included client-side assets, or are served from a CDN affects rollout,
  caching, and host integration.
- Treat centrally deployed extension updates carefully. Re-selecting the
  tenant-wide checkbox during updates can create duplicate Tenant Wide
  Extensions entries.
- Use developer-provided Teams packaging only when you need manifest control
  beyond the automatic Add to Teams flow.

### Avoid

- Treating tenant-wide deployment as the default because it looks easier.
- Hiding feature or asset-hosting implications behind generic build steps.
- Mixing feature-based provisioning and `skipFeatureDeployment` without naming
  the consequences.
- Talking about packaging as if it were independent of host surface and
  rollout scope.

### Review checklist

- [ ] The package contract and app catalog path are explicit.
- [ ] `skipFeatureDeployment` is justified, not assumed.
- [ ] Feature-driven provisioning needs are accounted for before choosing a
  tenant-wide rollout.
- [ ] Asset hosting and update side effects are visible in the answer.

### Related files

- [Toolchain and deployment map](../references/toolchain-deployment-map.md)
- [Teams and Viva rule](./hosts-teams-and-viva-integration.md)
- [Data rule](./data-sharepoint-graph-and-aad-clients.md)
- [Component selection map](../references/component-selection-map.md)

### Source anchors

- [Solution packaging](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/web-parts/basics/notes-on-solution-packaging)
- [Tenant-scoped deployment](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/tenant-scoped-deployment)
- [Teams deployment options](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/deployment-spfx-teams-solutions)
