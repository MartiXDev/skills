## SharePoint PnP provisioning composition map

### Purpose

- Separate runtime code from environment and site provisioning work.
- Connect PnPjs, site scripts, site designs, and PnP provisioning guidance without flattening their differences.

### Quick matrix

| Layer | Best-fit tool | Why |
| --- | --- | --- |
| JavaScript runtime inside app or SPFx | PnPjs | It lives with the application logic and type-safe SharePoint access. |
| Repeatable site configuration | Provisioning-oriented automation | It belongs in tooling and deployment, not runtime code. |
| Lightweight declarative site setup | Site scripts and site designs | Good fit when the SharePoint-native declarative surface matches the need. |
| Broader provisioning composition | PnP provisioning engine plus automation | Useful when the site setup story is richer than the declarative native surface alone. |

### Source families

- [PnPjs](https://pnp.github.io/pnpjs/)
- [Site templates and site scripts overview](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/declarative-customization/site-design-overview.md)
- [PnP provisioning engine](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/declarative-customization/site-design-pnp-provisioning.md)

### Review cues

- Provisioning choices should explain repeatability and environment ownership.
- PnPjs belongs in runtime code only when the application truly needs it there.
