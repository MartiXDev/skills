## Approved source index

### Purpose

- Use this file to keep the package grounded in the source families it is allowed to route through first.
- Prefer the sources below before expanding into older or adjacent SharePoint guidance.

### Primary source list

| Source | How to use it |
| --- | --- |
| [PnP PowerShell](https://pnp.github.io/powershell/) | Primary documentation for module setup, auth, and cmdlet usage. |
| [CLI for Microsoft 365](https://pnp.github.io/cli-microsoft365/) | Primary documentation for cross-platform Microsoft 365 CLI usage. |
| [PnPjs](https://pnp.github.io/pnpjs/) | Primary documentation for fluent JavaScript access to SharePoint and Graph. |
| [Site templates and site scripts](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/declarative-customization/site-design-overview.md) | SharePoint source family that intersects with provisioning workflows. |
| [PnP provisioning engine](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/declarative-customization/site-design-pnp-provisioning.md) | Bridge between SharePoint docs and PnP provisioning practices. |

### Source boundary notes

- Start with the package's primary Microsoft or PnP sources before borrowing from adjacent SharePoint surfaces.
- Use older or neighboring docs only when the current task clearly needs migration context, compatibility notes, or cross-surface comparison.
- Document any first-pass gaps honestly rather than silently stretching a source beyond its scope.

### Explicit exclusions for first-pass routing

- Classic WSP, feature framework, event receiver, or master-page-centric work.
- Pure SPFx component implementation where provisioning and automation are not the focus.
- Generic PowerShell or JavaScript advice that is not tied to SharePoint PnP tooling decisions.
