## SharePoint PnP operations — idempotency, governance, and SPFx integration boundaries

Use this rule for operational quality, repeatability, and the line between automation and application code.

### Purpose

- Keep provisioning and automation guidance useful in shared environments instead of as one-off local scripts.
- Clarify which responsibilities stay in automation and which move into SPFx or application code.

### Default guidance

- Design scripts and provisioning flows to tolerate reruns, partial completion, and environment differences.
- Document rollback, recovery, and operational ownership alongside the automation steps.
- Use the SPFx package when the task becomes component implementation; keep this package focused on tooling and delivery composition.

### Avoid

- Calling a workflow production-ready when it only succeeds in a clean dev environment.
- Letting automation accumulate application responsibilities that belong in SPFx or another runtime surface.

### Review checklist

- Confirm idempotency and rerun behavior are explicit.
- Confirm rollback or recovery expectations are described.
- Confirm SPFx boundaries stay clear when automation and application work meet.

### Related files

- [Provisioning composition map](../references/provisioning-composition-map.md)
- [Anti-patterns quick reference](../references/anti-patterns-quick-reference.md)

### Source anchors

- [PnP PowerShell](https://pnp.github.io/powershell/)
- [CLI for Microsoft 365](https://pnp.github.io/cli-microsoft365/)
- [PnPjs](https://pnp.github.io/pnpjs/)
