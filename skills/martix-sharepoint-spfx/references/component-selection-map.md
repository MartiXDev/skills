## Component selection map

### Purpose

Use this map when the first useful answer is which SPFx surface should own
the experience.

### Surface matrix

| Requirement | Best fit | Why | Escalate when | Avoid |
| --- | --- | --- | --- | --- |
| Page content block, configurable widget, or single-part app page | Web part | It belongs in page content and benefits from property-pane configuration | The real need is page chrome, command bar action, or form replacement | Using an extension because it feels more flexible |
| Placeholder-driven page chrome, banner, or notification area | Application Customizer | It targets supported page-level placeholders | The task is really list UI or page content | DOM scraping from unsupported page structure |
| Custom list or library command action | ListView Command Set | It owns command bar and ECB actions | The task is really field rendering or form replacement | Replacing commands with generic page script |
| Custom list cell rendering | Field Customizer | It owns field-level list-view display | The requirement affects more than cell rendering | Using JSLink-era assumptions on modern pages |
| New, edit, or display form replacement for a list or library | Form Customizer | It is the supported form-lifecycle surface | The target environment cannot support Form Customizer | Rebuilding a form as a generic web part without lifecycle fit |
| Shared client code across separately deployed SPFx solutions | Library component | It can be versioned and deployed independently | The code only needs to be reused inside one solution | Creating tenant-wide shared code for local convenience |
| SharePoint page experience reused in Teams | Web part plus supported hosts | The same web part can surface as a Teams tab or personal app | The solution needs broader Teams app capabilities | Treating every Teams scenario as a web-part-only problem |
| Viva Connections dashboard card | ACE-oriented host integration | Viva dashboard extensibility is ACE-first | The requirement is actually a page-level SharePoint web part | Forcing a normal web part into a dashboard-card role |

### Related files

- [Web parts rule](../rules/webparts-property-panes-and-properties.md)
- [Extensions rule](../rules/extensions-application-command-field.md)
- [Form Customizers and library components rule](../rules/components-form-customizers-and-library-components.md)
- [Teams and Viva map](./teams-viva-map.md)

### Source anchors

- [Web parts overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/web-parts/overview-client-side-web-parts)
- [Extensions overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/extensions/overview-extensions)
- [Form Customizer](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/extensions/get-started/building-form-customizer)
- [Library component overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/library-component-overview)
- [Viva Connections overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/viva/overview-viva-connections)
