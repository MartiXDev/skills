## Migration map

### Purpose

Use this map when a legacy customization pattern needs a modern SPFx
replacement or a clear handoff.

### Legacy-to-modern matrix

| Legacy artifact or pattern | Modern direction | Notes |
| --- | --- | --- |
| Script Editor or Content Editor page customization | Web part for page content, Application Customizer for page chrome | Start from the user need, not from the old script location |
| UserCustomAction page customization | Application Customizer | Use supported placeholders instead of classic page injection |
| ECB menu item | ListView Command Set | Keep the action attached to supported command surfaces |
| JSLink or CSR field rendering | Field Customizer | Modern list-view rendering should stay in field-level surfaces |
| List or library form override | Form Customizer | Treat as SharePoint Online-first guidance |
| JSOM-heavy client logic | REST, PnPjs, `SPHttpClient`, or Graph clients | JSOM is not the default modern path |
| `spPageContextInfo` dependency | SPFx `pageContext` and component context | Modern pages should not rely on classic global context objects |
| Master-page or structural classic branding | Usually out of scope for this package | Re-evaluate the requirement or hand off to the server-side package |

### Reuse versus rewrite cues

- Reuse code only when it works in an async, modular SPFx bundle.
- Rewrite when old page events, global libraries, or DOM dependencies are a
  core part of the old solution.
- Keep no-script support and app-catalog governance explicit.

### Related files

- [Migration rule](../rules/migration-classic-to-modern-spfx.md)
- [Extensions rule](../rules/extensions-application-command-field.md)
- [Web parts rule](../rules/webparts-property-panes-and-properties.md)
- [Data and integration map](./data-integration-map.md)

### Source anchors

- [Script Editor migration](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/web-parts/guidance/migrate-script-editor-web-part-customizations)
- [UserCustomAction migration](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/extensions/guidance/migrate-user-customactions-to-spfx-extensions)
- [SharePoint Framework overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/sharepoint-framework-overview)
