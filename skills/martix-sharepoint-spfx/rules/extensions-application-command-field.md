## SPFx extensions — application, command, and field surfaces

Use this rule when the real decision is which extension surface owns the
customization: Application Customizer, Command Set, Field Customizer, or a
more specialized extension type.

### Purpose

- Route extension work to the correct supported surface instead of reproducing
  DOM hacks from classic customization models.
- Keep extension scope tied to supported placeholders, command surfaces, and
  list-view rendering points.

### Default guidance

- Use an Application Customizer for supported placeholder-driven page chrome,
  banners, notifications, or other page-level additions on modern pages.
- Use a ListView Command Set when the requirement is a custom command bar or
  ECB action on a list or library view.
- Use a Field Customizer when the requirement is custom rendering of a list
  field value inside the list view.
- Treat Search Query Modifier as a specialized extension choice only when
  search-query mutation itself is the requirement.
- Use extension APIs and known extensibility points instead of scraping page
  DOM structure or reaching into unsupported CSS classes.
- When modernizing UserCustomAction, ECB, or JSLink-era customizations, map
  them to Application Customizer, Command Set, or Field Customizer instead of
  preserving the old mechanism literally.

### Avoid

- Picking Application Customizer because it feels like a general-purpose DOM
  hook.
- Using a Command Set for page content or using a Field Customizer for page
  chrome.
- Treating classic page assumptions as valid on modern pages.
- Hiding tenant-wide extension activation or update effects from the answer.

### Review checklist

- [ ] The chosen extension surface matches the UI placement and lifecycle.
- [ ] The answer stays inside supported placeholders or command or field
  rendering points.
- [ ] Any migration from classic UI customizations names the modern SPFx
  replacement explicitly.
- [ ] Tenant-wide activation or rollout effects are mentioned when relevant.

### Related files

- [Component selection map](../references/component-selection-map.md)
- [Deployment rule](./deployment-packaging-and-tenant-rollout.md)
- [Migration map](../references/migration-map.md)
- [Foundation rule](./foundation-scope-and-support-boundaries.md)

### Source anchors

- [Extensions overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/extensions/overview-extensions)
- [UserCustomAction migration](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/extensions/guidance/migrate-user-customactions-to-spfx-extensions)
- [Supported extensibility platforms](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/supported-extensibility-platforms-overview)
