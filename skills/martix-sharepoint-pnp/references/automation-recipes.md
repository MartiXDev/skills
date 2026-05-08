## SharePoint PnP automation recipes

### Purpose

- Collect the repeatable patterns the package should favor for operational automation.
- Keep PowerShell and CLI workflows grounded in connection, rerun, and environment expectations.

### Quick matrix

| Recipe | Use when | Watch out for |
| --- | --- | --- |
| PnP PowerShell site automation | The workflow is PowerShell-centric and SharePoint-aware | Connection setup, reruns, and object existence checks. |
| CLI for Microsoft 365 command flow | The workflow needs cross-platform command automation | Environment setup and mixed-tool boundaries. |
| Mixed-tool workflow | One tool clearly owns provisioning and another owns runtime code | Make the handoff explicit instead of ad hoc. |

### Recipe stance

- A recipe is useful only if it can explain reruns, partial failure, and ownership.
- Mixed-tool flows should justify why each tool remains in the chain.

### Primary references

- [PnP PowerShell](https://pnp.github.io/powershell/)
- [CLI for Microsoft 365](https://pnp.github.io/cli-microsoft365/)
