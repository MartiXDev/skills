## SharePoint PnP foundation — tool selection and package boundaries

Use this rule when deciding which PnP tool or adjacent package should own the task.

### Purpose

- Keep PnP PowerShell, CLI for Microsoft 365, PnPjs, and adjacent SharePoint packages from overlapping into a blurry mega-tool answer.
- Make runtime and delivery-model choices explicit before detailed scripting starts.

### Default guidance

- Choose the tool from where the automation runs, what it needs to authenticate to, and how it will be maintained.
- Use PnP PowerShell for PowerShell-centric SharePoint automation, CLI for Microsoft 365 for cross-platform command-line workflows, and PnPjs when SharePoint or Graph access belongs inside a JavaScript or SPFx solution.
- Redirect classic server-side packaging or pure SPFx component implementation into the matching package.

### Avoid

- Answering with a favorite tool before the hosting and delivery model are clear.
- Treating every SharePoint script or library question as interchangeable PnP territory.

### Review checklist

- Confirm the selected tool matches the actual runtime and maintenance model.
- Confirm adjacent package boundaries are explicit when the task could drift into SPFx or classic server-side work.
- Confirm the answer explains why the chosen tool is the best fit.

### Related files

- [Rule section contract](./_sections.md)
- [Tool selection map](../references/tool-selection-map.md)
- [Provisioning composition map](../references/provisioning-composition-map.md)

### Source anchors

- [PnP PowerShell](https://pnp.github.io/powershell/)
- [CLI for Microsoft 365](https://pnp.github.io/cli-microsoft365/)
- [PnPjs](https://pnp.github.io/pnpjs/)
