## SPFx migration — classic to modern client-side surfaces

Use this rule when a classic or pre-SPFx customization needs a supported
modern replacement instead of a literal port.

### Purpose

- Translate legacy intent into the right modern SPFx surface.
- Keep modernization guidance future-facing instead of preserving brittle page
  hacks by default.

### Default guidance

- Start from the user need, not from the old artifact. Map Script Editor or
  Content Editor scenarios to web parts or Application Customizers depending
  on whether the requirement is page content or page chrome.
- Map UserCustomAction scenarios to Application Customizers, ECB menu items to
  Command Sets, JSLink or CSR rendering to Field Customizers, and list or
  library form overrides to Form Customizers.
- Prefer REST, PnPjs, and SPFx context over JSOM or `spPageContextInfo` when
  moving logic into modern pages.
- Decide reuse versus rewrite explicitly. Reuse only when the legacy code works
  in an async, modular SPFx bundle and still fits the long-term maintenance
  plan. Rewrite when old page events, global libraries, or DOM dependencies are
  central to the old implementation.
- Keep no-script support, app-catalog governance, and the current-user browser
  security model visible in the migration plan.
- Hand classic/server-side maintenance back to the SharePoint Server package
  when the work is really about preserving farm-solution or Feature Framework
  behavior.

### Avoid

- Porting Script Editor or UserCustomAction logic line-for-line into SPFx.
- Treating JSOM and `spPageContextInfo` as the default modern data-access
  model.
- Preserving unsupported DOM mutations because they were convenient in classic
  pages.
- Hiding the browser-shared token and storage model when the old solution was
  effectively trusted script injection.

### Review checklist

- [ ] The legacy artifact is mapped to a modern SPFx surface explicitly.
- [ ] JSOM, `spPageContextInfo`, or page-event dependencies are addressed
  rather than ignored.
- [ ] The migration path names whether code is reused or rewritten and why.
- [ ] Classic/server-side work is handed off when it remains the real target.

### Related files

- [Migration map](../references/migration-map.md)
- [Extensions rule](./extensions-application-command-field.md)
- [Web parts rule](./webparts-property-panes-and-properties.md)
- [Data rule](./data-sharepoint-graph-and-aad-clients.md)

### Source anchors

- [Script Editor migration](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/web-parts/guidance/migrate-script-editor-web-part-customizations)
- [UserCustomAction migration](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/extensions/guidance/migrate-user-customactions-to-spfx-extensions)
- [SharePoint Framework overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/sharepoint-framework-overview)
