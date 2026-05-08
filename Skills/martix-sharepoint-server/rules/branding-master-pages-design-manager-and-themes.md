## SharePoint server branding — master pages, Design Manager, and themes

Use this rule for classic branding surfaces and publishing-era page customization.

### Purpose

- Keep classic branding work grounded in the site model that actually requires it.
- Show how master pages, page layouts, Design Manager assets, and theming artifacts fit together operationally.

### Default guidance

- Start from the required site experience and publishing model before selecting a master-page or page-layout strategy.
- Treat Design Manager, themes, composed looks, and custom CSS as governed assets with packaging and upgrade implications.
- Tie branding rollout back to provisioning and feature ownership instead of treating it as a disconnected styling layer.

### Avoid

- Recommending master-page customization without checking whether the site type still depends on the classic publishing model.
- Dropping custom CSS and theme assets into deployment without an upgrade plan.

### Review checklist

- Confirm the site experience really needs classic branding primitives.
- Confirm page layouts, themes, and CSS assets map back to a deployment owner.
- Confirm upgrade and maintenance implications are called out alongside the branding recommendation.

### Related files

- [Site and branding map](../references/site-and-branding-map.md)
- [Provisioning and modernization map](../references/provisioning-modernization-map.md)

### Source anchors

- [Overview of Design Manager in SharePoint](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/general-development/overview-of-design-manager-in-sharepoint.md)
- [Master pages, the Master Page Gallery, and page layouts](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/general-development/master-pages-the-master-page-gallery-and-page-layouts-in-sharepoint.md)
- [Themes overview for SharePoint](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/general-development/themes-overview-for-sharepoint.md)
