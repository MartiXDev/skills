## SharePoint PnP auth — app registration, permissions, and connection flow

Use this rule for connection strategy, app registration, and permission planning.

### Purpose

- Make auth and connection choices a first-class design decision instead of a last-minute script patch.
- Keep PnP PowerShell, CLI, and PnPjs connection advice aligned with current platform expectations.

### Default guidance

- Model the executing identity, permission scope, and app registration before prescribing cmdlets, commands, or libraries.
- Assume custom app registration is the preferred path for PnP PowerShell and explain the connection flow that matches the scenario.
- Keep connection advice tied to the environment that will run the automation or application.

### Avoid

- Writing scripts first and discovering the auth model later.
- Recommending credential or device-login patterns without checking whether the environment and current documentation still support them cleanly.

### Review checklist

- Confirm the connection model matches the execution environment and permission boundary.
- Confirm app registration and consent expectations are explicit.
- Confirm the chosen tool's connection flow is current and documented.

### Related files

- [Authentication and connection map](../references/auth-connection-map.md)
- [Automation recipes](../references/automation-recipes.md)

### Source anchors

- [PnP PowerShell](https://pnp.github.io/powershell/)
- [CLI for Microsoft 365](https://pnp.github.io/cli-microsoft365/)
- [PnPjs authentication guidance](https://pnp.github.io/pnpjs/concepts/authentication/)
