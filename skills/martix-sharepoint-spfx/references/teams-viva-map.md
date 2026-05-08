## Teams and Viva map

### Purpose

Use this map when the answer needs to pin how an SPFx component is exposed
outside a normal SharePoint page.

### Host matrix

| Host scenario | SPFx surface | Key configuration | Deployment note | Avoid |
| --- | --- | --- | --- | --- |
| Teams tab | Web part | Add `TeamsTab` to `supportedHosts` | SharePoint Online-backed deployment; Add to Teams can auto-package simple cases | Treating a tab as proof that SPFx owns the whole Teams app |
| Teams personal app | Web part | Add `TeamsPersonalApp` to `supportedHosts` | Tenant-wide deployment often matters for discoverability | Assuming a personal app and tab have identical user journeys |
| Teams messaging extension participation | Web part plus custom Teams package and supporting bot or task flow | Custom Teams manifest `composeExtensions` and hosted task URL | Developer-provided Teams package is usually required | Pretending `supportedHosts` alone creates a full messaging extension |
| Viva Connections dashboard | ACE-first host integration | Use an ACE and optional deep links to SharePoint or Teams | SharePoint Online-backed and dashboard-oriented | Using a normal web part as the default dashboard-card surface |
| Teams or Viva mixed-host solution | SPFx plus other app parts as needed | Keep SPFx-owned UI boundaries explicit | Choose automatic packaging only when the host requirements stay simple | Hiding required non-SPFx app components |

### Related files

- [Teams and Viva rule](../rules/hosts-teams-and-viva-integration.md)
- [Deployment rule](../rules/deployment-packaging-and-tenant-rollout.md)
- [Web parts rule](../rules/webparts-property-panes-and-properties.md)
- [Host support matrix](../assets/host-support-matrix.json)

### Source anchors

- [Teams overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/build-for-teams-overview)
- [Expose web parts in Teams](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/build-for-teams-expose-webparts-teams)
- [Teams considerations](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/build-for-teams-considerations)
- [Teams deployment options](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/deployment-spfx-teams-solutions)
- [Viva Connections overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/viva/overview-viva-connections)
- [ACE and Teams apps](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/viva/get-started/adaptive-card-extensions-and-teams)
