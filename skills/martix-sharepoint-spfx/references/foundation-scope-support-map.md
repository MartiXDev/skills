## Foundation and support map

### Purpose

Use this map when the first real question is whether SPFx should own the
task at all and which host or product surface defines the constraints.

### Routing matrix

| Scenario | Keep in this package? | Start with | Hand off when |
| --- | --- | --- | --- |
| Modern SharePoint Online page content or client-side app experience | Yes | [Web parts rule](../rules/webparts-property-panes-and-properties.md) | The task is actually a list command, form, or provisioning workflow |
| Modern page chrome, placeholder content, or list command or cell UI | Yes | [Extensions rule](../rules/extensions-application-command-field.md) | The requirement becomes server-side, unsupported DOM surgery, or classic-only |
| List or library form replacement | Yes, when the environment supports Form Customizer | [Form Customizers rule](../rules/components-form-customizers-and-library-components.md) | The environment or version cannot support the Form Customizer path |
| Teams or Viva exposure where SPFx is the delivery vehicle | Yes | [Teams and Viva rule](../rules/hosts-teams-and-viva-integration.md) | The scenario mostly depends on non-SPFx Teams app capabilities |
| Provisioning, tenant automation, or operator-run setup | No | Handoff to separate provisioning or automation guidance | A client-side component still needs separate SPFx guidance after provisioning |
| Farm solution, WSP, Feature Framework, or server object model work | No | Handoff to separate server-side SharePoint guidance | The work is actually a modernization review rather than classic implementation |
| SharePoint Server 2019 or Subscription Edition compatibility review | Yes, conservatively | [Version support map](./version-support-map.md) | The task is really about classic server-side customization |

### Support stance

- SharePoint Online is the default lane.
- SharePoint Server 2019 is a fixed compatibility baseline, not the modern
  design target.
- Subscription Edition guidance remains conservative because current official
  docs describe support differently.

### Related files

- [Foundation rule](../rules/foundation-scope-and-support-boundaries.md)
- [Version support map](./version-support-map.md)
- [Host support matrix](../assets/host-support-matrix.json)
- [Migration map](./migration-map.md)

### Source anchors

- [SharePoint Framework overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/sharepoint-framework-overview)
- [Supported extensibility platforms](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/supported-extensibility-platforms-overview)
- [SharePoint 2019 and Subscription Edition support](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/sharepoint-2019-and-subscription-edition-support)
