## SharePoint PnP authentication and connection map

### Purpose

- Keep auth and connection decisions current, explicit, and tied to the execution environment.
- Prevent scripts and apps from discovering permission gaps only after implementation.

### Quick matrix

| Context | Primary concern | What to capture |
| --- | --- | --- |
| PnP PowerShell automation | App registration and connection flow | Identity, permissions, consent, and non-interactive expectations. |
| CLI for Microsoft 365 | Setup and login model | Environment bootstrapping and repeatable auth flow. |
| PnPjs inside app or SPFx | Runtime auth model | How the app acquires and scopes permissions. |

### Source families

- [PnP PowerShell](https://pnp.github.io/powershell/)
- [CLI for Microsoft 365](https://pnp.github.io/cli-microsoft365/)
- [PnPjs authentication guidance](https://pnp.github.io/pnpjs/concepts/authentication/)

### Review cues

- Connection advice is incomplete if it does not name the executing identity and permission boundary.
- The package should reflect the current guidance around custom app registration for PnP PowerShell.
