## SharePoint PnP automation — CLI for Microsoft 365 and tenant operations

Use this rule for CLI for Microsoft 365 workflows and cross-platform tenant automation.

### Purpose

- Keep CLI-driven workflows intentional instead of using them as a vague substitute for every admin task.
- Surface where CLI fits better than PowerShell or where it should complement another tool.

### Default guidance

- Use CLI for Microsoft 365 when the workflow benefits from cross-platform command-line automation and its command surface matches the task cleanly.
- Keep setup, login, and environment expectations explicit so the command flow is reproducible outside a single developer machine.
- Combine CLI and PnP PowerShell only when each tool clearly owns part of the workflow.

### Avoid

- Using CLI commands only because they are available, without checking whether another tool owns the scenario more cleanly.
- Hiding environment setup assumptions behind a copy-pasted command sequence.

### Review checklist

- Confirm the CLI workflow matches the runtime and cross-platform requirement.
- Confirm login/setup expectations are documented.
- Confirm mixed-tool workflows justify why each tool remains in the chain.

### Related files

- [Tool selection map](../references/tool-selection-map.md)
- [Automation recipes](../references/automation-recipes.md)

### Source anchors

- [CLI for Microsoft 365](https://pnp.github.io/cli-microsoft365/)
- [CLI for Microsoft 365 commands for site designs](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/declarative-customization/site-design-o365cli.md)
