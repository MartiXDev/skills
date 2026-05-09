## UI and theming map

### Purpose

Use this map when property configuration, UI package posture, or theme-aware
styling needs to be made explicit.

### Property and theming matrix

| Concern | Default | Notes |
| --- | --- | --- |
| Property pane interaction | Reactive first | Switch to non-reactive only when changes are expensive or must be explicitly applied |
| Searchable text property | `isSearchablePlainText` | Modern pages only; still escape plain text before rendering |
| Rich HTML property | `isHtmlString` | Modern pages only; SharePoint sanitizes unsafe HTML and supports link fix-up |
| Image URL property | `isImageSource` | Modern pages only; supports link fix-up and image handling |
| Link property | `isLink` | Modern pages only; use when the property is just a link |
| Site color alignment | Theme tokens with defaults | Hardcoded colors should be the exception, not the default |
| Section background alignment | Theme variants or section-background support | Needed when the component should blend into modern page backgrounds |
| UI library posture | Use the SPFx-compatible Fluent or Fabric package family | Do not upgrade independently from the SPFx baseline |
| CSS strategy | Module-scoped styles and supported Sass references | Avoid global CSS collisions and undocumented SharePoint classes |

### Related files

- [Web parts rule](../rules/webparts-property-panes-and-properties.md)
- [UI rule](../rules/ui-react-typescript-and-theming.md)
- [Version support map](./version-support-map.md)
- [Migration map](./migration-map.md)

### Source anchors

- [Property pane basics](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/web-parts/basics/integrate-with-property-pane)
- [Web part properties with SharePoint](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/web-parts/guidance/integrate-web-part-properties-with-sharepoint)
- [Theme colors](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/use-theme-colors-in-your-customizations)
- [Office UI Fabric integration](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/office-ui-fabric-integration)
