## Approved source index

### Purpose

- Use this file to keep the package grounded in the source families it is allowed to route through first.
- Prefer the sources below before expanding into older or adjacent SharePoint guidance.

### Primary source list

| Source | How to use it |
| --- | --- |
| [SharePoint development overview](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/general-development/sharepoint-development-overview.md) | Top-level archive entry point for classic development topics. |
| [SharePoint Server 2019 development platform](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/general-development/sharepoint-2019-development-platform.md) | Primary version anchor for current on-prem guidance. |
| [Build farm solutions in SharePoint](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/general-development/build-farm-solutions-in-sharepoint.md) | Core reference for classic server-side packaging and deployment. |
| [Branding and site provisioning solutions for SharePoint](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/solution-guidance/Branding-and-site-provisioning-solutions-for-SharePoint.md) | Authoritative overview for classic branding and provisioning patterns. |
| [Event receivers and list event receivers](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/solution-guidance/event-receiver-and-list-event-receiver-sharepoint-add-in.md) | Useful legacy context for event receiver design decisions. |
| [Feature stapling](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/solution-guidance/feature-stapling-sharepoint-add-in.md) | Legacy artifact reference for feature-bound site rollout. |

### Source boundary notes

- Start with the package's primary Microsoft or PnP sources before borrowing from adjacent SharePoint surfaces.
- Use older or neighboring docs only when the current task clearly needs migration context, compatibility notes, or cross-surface comparison.
- Document any first-pass gaps honestly rather than silently stretching a source beyond its scope.

### Explicit exclusions for first-pass routing

- Modern SPFx-first SharePoint Online customizations.
- React or TypeScript implementation details inside client-side web parts.
- PnP PowerShell, CLI for Microsoft 365, or PnPjs automation decisions that are not tied to classic server-side artifacts.
