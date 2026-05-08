## SharePoint server site and branding map

### Purpose

- Keep site-shape artifacts, information architecture, and branding assets connected.
- Make publishing-era dependencies explicit when master pages, layouts, and navigation all move together.

### Quick matrix

| Area | Primary artifacts | Questions to settle early |
| --- | --- | --- |
| Site shape | Site definitions, list definitions, modules | Which artifact owns the site structure and feature activation story? |
| Information architecture | Managed metadata, navigation, publishing features | What term sets or publishing dependencies shape the experience? |
| Branding | Master pages, page layouts, Design Manager, themes | Which classic assets must deploy and upgrade together? |

### Source families

- [Build sites for SharePoint](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/general-development/build-sites-for-sharepoint.md)
- [Managed metadata and navigation in SharePoint](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/general-development/managed-metadata-and-navigation-in-sharepoint.md)
- [Branding and site provisioning solutions for SharePoint](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/solution-guidance/Branding-and-site-provisioning-solutions-for-SharePoint.md)

### Front-load these checks

- Do not review branding without the site model and publishing dependencies.
- Do not review navigation or metadata as pure content work if the feature stack depends on them.
