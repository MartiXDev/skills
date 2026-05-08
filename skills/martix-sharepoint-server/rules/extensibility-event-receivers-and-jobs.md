## SharePoint server extensibility — event receivers, remote receivers, and jobs

Use this rule for classic event-driven extensibility patterns and long-running background work.

### Purpose

- Keep event-driven and background-processing choices grounded in the actual hosting, deployment, and troubleshooting consequences.
- Surface the difference between list event receivers, remote event receivers, and remote timer-job style patterns.

### Default guidance

- Choose the lightest extensibility point that still matches the lifecycle and hosting requirements of the change.
- Document how the receiver or job is deployed, observed, retried, and rolled back before implementation details pile up.
- Call out later modernization alternatives when the current choice exists only to preserve a classic on-prem integration.

### Avoid

- Recommending receiver-heavy designs without describing operations, retries, and diagnostics.
- Treating remote event receivers as a generic replacement for every legacy trigger scenario.

### Review checklist

- Confirm the selected extensibility point matches the required trigger and hosting boundary.
- Confirm deployment, diagnostics, and retry behavior are documented.
- Confirm modernization notes exist when the pattern is legacy-preserving rather than ideal-state design.

### Related files

- [Packaging and extensibility map](../references/packaging-and-extensibility-map.md)
- [Provisioning and modernization map](../references/provisioning-modernization-map.md)

### Source anchors

- [Event receivers and list event receivers](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/solution-guidance/event-receiver-and-list-event-receiver-sharepoint-add-in.md)
- [Use remote event receivers in SharePoint](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/solution-guidance/Use-remote-event-receivers-in-SharePoint.md)
- [Create remote timer jobs](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/solution-guidance/create-remote-timer-jobs-in-sharepoint.md)
