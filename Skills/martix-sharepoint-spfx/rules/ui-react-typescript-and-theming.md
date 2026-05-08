## SPFx UI — React, TypeScript, and theming

Use this rule when the answer depends on React package posture, TypeScript
compatibility, theming, or safe UI-library integration.

### Purpose

- Keep UI guidance aligned with the SPFx compatibility matrix and theming
  model.
- Prevent CSS and package-version decisions from breaking host integration or
  future updates.

### Default guidance

- Treat React plus TypeScript as the default package stance for this skill, but
  keep their versions aligned with the chosen SPFx release rather than current
  ecosystem trends.
- Use theme tokens with fallback defaults so the component follows the site
  palette instead of standing out with hardcoded colors.
- Support section backgrounds or theme variants where the web part should blend
  into modern page section styling.
- Use the Fluent or Office UI Fabric packages that are appropriate for the
  chosen SPFx baseline. For older documentation that still uses the Office UI
  Fabric name, treat it as the earlier package family rather than a license to
  mix arbitrary modern Fluent versions into an older SPFx project.
- Keep styles module-scoped and avoid depending on global SharePoint CSS or DOM
  structure. Use supported Sass references, mixins, and theme tokens instead.
- Keep state and component structure clear enough that property pane, host, and
  theming constraints are easy to trace.

### Avoid

- Independently upgrading React, Fluent, or TypeScript outside the SPFx
  release matrix.
- Hardcoding colors when the same result should follow site theme tokens.
- Using global CSS selectors that can collide with Microsoft-shipped styles or
  other SPFx components.
- Styling against undocumented page DOM classes to make a component "fit in."

### Review checklist

- [ ] React, TypeScript, and UI-library versions match the SPFx baseline.
- [ ] Theme tokens are used where the site theme should influence the UI.
- [ ] CSS is module-scoped and avoids unsafe global collisions.
- [ ] Theme-variant or section-background behavior is considered where needed.

### Related files

- [UI and theming map](../references/ui-theming-map.md)
- [Web parts rule](./webparts-property-panes-and-properties.md)
- [Versioning rule](./tooling-versioning-and-compatibility.md)
- [Migration rule](./migration-classic-to-modern-spfx.md)

### Source anchors

- [Theme colors](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/use-theme-colors-in-your-customizations)
- [Office UI Fabric integration](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/office-ui-fabric-integration)
- [Tools and libraries](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/tools-and-libraries)
- [SPFx compatibility](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/compatibility)
