## SharePoint PnP tool selection map

### Purpose

- Route SharePoint automation and provisioning work to the right PnP tool before implementation details pile up.
- Keep PnP tooling separate from adjacent SPFx and classic server-side package responsibilities.

### Quick matrix

| Need | Likely tool or package | Reason |
| --- | --- | --- |
| PowerShell automation workflow | PnP PowerShell | Best fit when the delivery surface is PowerShell-centric and SharePoint-aware. |
| Cross-platform command automation | CLI for Microsoft 365 | Clean fit for shell workflows that need the Microsoft 365 command surface. |
| JavaScript or SPFx runtime access | PnPjs | Best fit inside application or SPFx code. |
| Classic farm or WSP artifact | `martix-sharepoint-server` | That work belongs in the classic server-side package. |
| Pure SPFx component implementation | `martix-sharepoint-spfx` | That work belongs in the modern client-side package. |

### Source families

- [PnP PowerShell](https://pnp.github.io/powershell/)
- [CLI for Microsoft 365](https://pnp.github.io/cli-microsoft365/)
- [PnPjs](https://pnp.github.io/pnpjs/)

### Front-load these checks

- Choose the tool from the runtime and maintenance model, not from whichever sample the team saw last.
- Move out of this package when the work becomes component implementation or classic packaging rather than automation and provisioning.
