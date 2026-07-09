## SharePoint server platform and boundaries map

### Purpose

- Route classic SharePoint work into the on-prem server-side lane only when the artifact families actually require it.
- Keep SharePoint 2019 and Subscription Edition as the primary targets while treating 2010 and 2013 material as legacy context.

### Quick matrix

| Scenario | Preferred package | Reason |
| --- | --- | --- |
| Farm solution, WSP, feature XML, feature receiver, delegate control, application page, or event receiver | `martix-sharepoint-server` | These are classic server-side/on-prem artifact families. |
| SPFx web part or extension | `martix-sharepoint-spfx` | Client-side SharePoint Framework work belongs in the modern package. |
| PnP PowerShell or CLI automation | `martix-sharepoint-pnp` | Tooling, automation, and provisioning choices belong in the PnP package. |

### Version stance

- Default to SharePoint 2019 and Subscription Edition when the user says "on-prem" without extra precision.
- Use SharePoint 2013 and 2010 sources to interpret legacy implementations or migration questions, not as the preferred build target.

### First-pass cues

- Words like `WSP`, `feature receiver`, `delegate control`, `application page`, `site definition`, or `master page` are strong signals for this package.
- Words like `SPFx`, `React`, `property pane`, `Form Customizer`, or `web part` should redirect to `martix-sharepoint-spfx` unless the user is explicitly modernizing a classic artifact.
- Words like `PnP PowerShell`, `CLI for Microsoft 365`, `PnPjs`, `site script`, or `tenant provisioning` should redirect to `martix-sharepoint-pnp` unless the automation is inseparable from a classic farm artifact already owned here.
