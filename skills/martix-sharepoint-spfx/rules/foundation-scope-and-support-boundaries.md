## SPFx foundation — scope and support boundaries

Use this rule when validating that the task belongs in SharePoint Framework
and that the requested host, page, or product surface can actually support
the recommendation.

### Purpose

- Keep the package SharePoint Online-first while still documenting
  on-premises compatibility constraints.
- Separate supported client-side work from classic server-side or
  provisioning-only work before implementation detail takes over.

### Default guidance

- Start by naming the target host and surface: SharePoint Online page,
  Teams-hosted web part, Viva Connections dashboard, SharePoint Server 2019,
  or SharePoint Server Subscription Edition.
- Treat SPFx as the primary client-side extensibility model for modern
  SharePoint and as the delivery lane for Teams-hosted web parts or Viva
  Connections customizations.
- Route classic farm solutions, WSP packaging, Feature Framework receivers,
  master-page-first branding, and server object model code out of this
  package immediately.
- Route pure provisioning, tenant automation, or operator-run setup tasks to
  separate provisioning or automation guidance even when the end result is
  later consumed by SPFx.
- Use supported extensibility points instead of page DOM structure or
  undocumented CSS dependencies.

### Avoid

- Using SPFx as a catch-all answer for any SharePoint question.
- Treating SharePoint page DOM or CSS selectors as a stable API.
- Letting on-prem compatibility requirements drag the entire answer into
  classic or server-side territory.
- Hiding the real boundary between UI delivery, provisioning, and legacy
  maintenance.

### Review checklist

- [ ] The answer names the host, context, and component surface up front.
- [ ] The answer stays in SPFx only if the requirement is genuinely
  client-side.
- [ ] Classic/server-side and provisioning-only tasks are handed off
  explicitly.
- [ ] Any 2019 or SE note is presented as a compatibility constraint, not the
  default modern baseline.

### Related files

- [Foundation and support map](../references/foundation-scope-support-map.md)
- [Version support map](../references/version-support-map.md)
- [Migration rule](./migration-classic-to-modern-spfx.md)
- [Host support matrix](../assets/host-support-matrix.json)

### Source anchors

- [SharePoint Framework overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/sharepoint-framework-overview)
- [Supported extensibility platforms](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/supported-extensibility-platforms-overview)
- [SharePoint developer TOC](https://raw.githubusercontent.com/SharePoint/sp-dev-docs/main/docs/toc.yml)
