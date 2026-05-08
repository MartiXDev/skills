## SharePoint PnP composition — PnPjs, site scripts, and provisioning workflows

Use this rule for JavaScript-side SharePoint access and provisioning-oriented composition decisions.

### Purpose

- Clarify when PnPjs belongs inside an app or SPFx solution and when provisioning should stay in a tooling lane.
- Connect site scripts, site designs, and PnP provisioning guidance without pretending they are identical mechanisms.

### Default guidance

- Use PnPjs when SharePoint or Graph access belongs inside a JavaScript or SPFx implementation.
- Use provisioning-oriented tools and flows when the goal is repeatable environment or site setup rather than embedded runtime logic.
- Treat site scripts, site designs, and PnP provisioning as complementary tools whose strengths vary by scenario.

### Avoid

- Stuffing provisioning behavior into application runtime logic when it should stay in deployment tooling.
- Treating site scripts, site designs, and the PnP provisioning engine as one interchangeable feature set.

### Review checklist

- Confirm runtime code and provisioning automation responsibilities are separated cleanly.
- Confirm the provisioning mechanism matches the required repeatability and environment story.
- Confirm PnPjs use is tied to an application or SPFx need rather than generic tool preference.

### Related files

- [Provisioning composition map](../references/provisioning-composition-map.md)
- [Tool selection map](../references/tool-selection-map.md)

### Source anchors

- [PnPjs](https://pnp.github.io/pnpjs/)
- [Site templates and site scripts overview](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/declarative-customization/site-design-overview.md)
- [PnP provisioning engine](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/declarative-customization/site-design-pnp-provisioning.md)
