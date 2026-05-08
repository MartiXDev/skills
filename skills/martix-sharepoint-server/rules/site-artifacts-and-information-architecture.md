## SharePoint server site artifacts — definitions, modules, metadata, and navigation

Use this rule for classic site-shape artifacts and information-architecture decisions.

### Purpose

- Keep site definitions, list definitions, modules, and information-architecture decisions aligned instead of scattering them across packaging and branding discussions.
- Make metadata, navigation, and publishing dependencies reviewable before rollout.

### Default guidance

- Model site composition from the artifact that actually owns the experience, then map dependent modules, content types, and navigation settings around it.
- Treat managed metadata and publishing navigation as first-class architectural choices, not decorative follow-up work.
- Cross-link site artifact decisions to packaging and branding guidance so activation order remains coherent.

### Avoid

- Mixing site definitions, modules, and metadata behavior without a clear ownership model.
- Treating navigation and publishing dependencies as content-entry details rather than architecture.

### Review checklist

- Confirm the primary artifact that shapes the site is identified.
- Confirm metadata, navigation, and publishing dependencies are explicit.
- Confirm related packaging and branding files are linked for the full rollout story.

### Related files

- [Site and branding map](../references/site-and-branding-map.md)
- [Packaging and extensibility map](../references/packaging-and-extensibility-map.md)

### Source anchors

- [Build sites for SharePoint](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/general-development/build-sites-for-sharepoint.md)
- [Managed metadata and navigation in SharePoint](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/general-development/managed-metadata-and-navigation-in-sharepoint.md)
- [List definition/list template](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/solution-guidance/list-definition-template-sharepoint-add-in.md)
