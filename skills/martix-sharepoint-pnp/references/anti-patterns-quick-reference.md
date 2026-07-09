## Anti-patterns quick reference

### Purpose

- Use this file as a fast review aid when the package is already relevant but the answer is drifting toward risky shortcuts.

### Common anti-patterns

| Anti-pattern | Preferred correction |
| --- | --- |
| Picking a tool purely from personal preference | Choose PnP PowerShell, CLI for Microsoft 365, or PnPjs from hosting, auth, and delivery constraints. |
| Ignoring auth and app registration until after the script is written | Model connection and permission requirements first. |
| Writing non-idempotent provisioning scripts for repeatable environments | Design for reruns, partial failure, and recovery from the start. |
| Forcing SPFx implementation details into a tooling or automation answer | Cross-link to the SPFx package when the task becomes component-centric. |
| Treating WSPs, Feature Framework artifacts, or master pages as PnP tooling work | Hand off to the SharePoint server-side package when the request is classic farm-solution implementation. |
