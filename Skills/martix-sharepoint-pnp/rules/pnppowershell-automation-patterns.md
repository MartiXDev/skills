## SharePoint PnP automation — PnP PowerShell patterns and safety

Use this rule for PnP PowerShell-centric automation shape, repeatability, and operational safety.

### Purpose

- Keep SharePoint automation scripts grounded in the realities of connection setup, reruns, and operational ownership.
- Avoid scripts that only succeed once in a developer shell and then fail in shared environments.

### Default guidance

- Design PnP PowerShell automation around explicit connection setup, parameterization, and repeatable execution.
- Treat reruns, partial failure, and idempotency as part of the script design, not as afterthought cleanup.
- Document when the script hands off to other tools, services, or SPFx deployment steps.

### Avoid

- Embedding fragile, one-off assumptions about identity, environment, or object existence.
- Treating a successful manual run as proof that the automation is operationally ready.

### Review checklist

- Confirm connection setup, input shape, and rerun behavior are explicit.
- Confirm the script can explain partial failure and recovery expectations.
- Confirm adjacent tool boundaries are visible when the workflow is not PowerShell-only.

### Related files

- [Automation recipes](../references/automation-recipes.md)
- [Provisioning composition map](../references/provisioning-composition-map.md)

### Source anchors

- [PnP PowerShell](https://pnp.github.io/powershell/)
- [Site templates and site scripts overview](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/declarative-customization/site-design-overview.md)
