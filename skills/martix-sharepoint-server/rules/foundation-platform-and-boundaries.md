## SharePoint server foundation — platform boundaries and version targets

Use this rule when deciding whether the task belongs in classic server-side SharePoint guidance or should be redirected.

### Purpose

- Anchor recommendations on SharePoint 2019 and Subscription Edition before pulling older material into the discussion.
- Separate on-prem server-side choices from SPFx, SharePoint Online, or PnP-first solutions.

### Default guidance

- Start from the newest on-prem target and pull SharePoint 2013 or 2010 guidance forward only when a legacy artifact still exists.
- Treat farm or WSP deployment as an explicit architectural commitment with packaging, deployment, and rollback implications.
- Redirect browser-first, tenant-hosted, or SharePoint Online-centric work to the SPFx or PnP packages.

### Avoid

- Presenting farm-solution patterns as a default for SharePoint Online.
- Using SharePoint 2010-era samples as if they were the preferred answer for modern on-prem farms.

### Review checklist

- Confirm the actual platform target before recommending a packaging model.
- Confirm any SharePoint 2013 or 2010 reference is there for legacy context, not default design.
- Confirm the package clearly explains why the task stays in the classic server-side lane.

### Related files

- [Rule section contract](./_sections.md)
- [Platform and boundaries map](../references/platform-and-boundaries-map.md)
- [Provisioning and modernization map](../references/provisioning-modernization-map.md)

### Source anchors

- [SharePoint development overview](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/general-development/sharepoint-development-overview.md)
- [SharePoint Server 2019 development platform](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/general-development/sharepoint-2019-development-platform.md)
- [Programming models in SharePoint](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/general-development/programming-models-in-sharepoint.md)
