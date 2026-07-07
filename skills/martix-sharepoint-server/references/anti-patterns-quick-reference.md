## Anti-patterns quick reference

### Purpose

- Use this file as a fast review aid when the package is already relevant but the answer is drifting toward risky shortcuts.

### Common anti-patterns

| Anti-pattern | Preferred correction |
| --- | --- |
| Defaulting to farm solutions for cloud-first work | Route SharePoint Online-facing customization work to SPFx or PnP guidance first. |
| Using SharePoint 2010-era samples as the default recommendation | Start from SharePoint 2019 or Subscription Edition and treat older docs as legacy context. |
| Treating master pages or Design Manager as a universal branding answer | Confirm the site type, publishing model, and long-term maintenance expectations first. |
| Mixing provisioning, branding, and feature activation without rollback planning | Model package, activation, and upgrade paths together. |
| Recommending receiver-heavy designs without covering operations and diagnostics | Call out deployment, retry, and diagnostic behavior before recommending event receivers or remote timer jobs. |
| Deploying classic provisioning artifacts without an upgrade and rollback story | Document the upgrade receiver, rollback approach, and feature dependency order before finalizing any provisioning design. |
