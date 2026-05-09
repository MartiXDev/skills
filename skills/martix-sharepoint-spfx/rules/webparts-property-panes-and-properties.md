## SPFx web parts — property panes, properties, and page hosting

Use this rule when the task is really about a client-side web part, its
property model, or how the component behaves on SharePoint pages.

### Purpose

- Keep web parts focused on page content and page-hosted app experiences.
- Make property pane and stored-property decisions explicit instead of treating
  them as a late implementation detail.

### Default guidance

- Use a web part when the solution belongs in page content, a configurable
  page widget, or a single-part app page.
- Design the property pane around the smallest stable set of user-configurable
  inputs. Use the default reactive behavior first and switch to
  `disableReactivePropertyChanges` only when changes are expensive or should
  be explicitly applied.
- Organize property panes into pages, headers, and groups so the UI mirrors
  how users think about the settings. Reach for custom controls only when the
  built-in property pane fields cannot express the scenario cleanly.
- Validate values before they are stored. Use `propertiesMetadata` when a
  modern-page web part needs searchable plain text, sanitized HTML, link
  fix-up, or image-source handling.
- Remember that SPFx web part configuration is shared for all viewers of the
  instance; do not assume classic personalization behavior exists.
- Use `supportedHosts` and preconfigured entries deliberately when the same
  web part is meant to surface in SharePoint and Teams.

### Avoid

- Using a web part when the real requirement is page chrome, list commands,
  cell rendering, or form replacement.
- Treating the property pane as a place to stash secrets or opaque admin-only
  state.
- Assuming `propertiesMetadata` behavior on classic pages matches modern pages.
- Building a custom property-pane control for every field out of habit.

### Review checklist

- [ ] A web part is actually the right surface for the scenario.
- [ ] Property pane fields and interaction mode fit the expected user flow.
- [ ] Stored values are validated and `propertiesMetadata` is used only where
  it adds real value.
- [ ] Teams or page-hosting assumptions are expressed through supported hosts,
  not implied.

### Related files

- [Component selection map](../references/component-selection-map.md)
- [UI and theming map](../references/ui-theming-map.md)
- [Teams and Viva rule](./hosts-teams-and-viva-integration.md)
- [Migration rule](./migration-classic-to-modern-spfx.md)

### Source anchors

- [Web parts overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/web-parts/overview-client-side-web-parts)
- [Property pane basics](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/web-parts/basics/integrate-with-property-pane)
- [Web part properties with SharePoint](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/web-parts/guidance/integrate-web-part-properties-with-sharepoint)
- [Expose web parts in Teams](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/build-for-teams-expose-webparts-teams)
