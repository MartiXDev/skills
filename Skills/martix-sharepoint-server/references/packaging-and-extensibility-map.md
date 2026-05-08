## SharePoint server packaging and extensibility map

### Purpose

- Connect classic packaging choices to the extensibility points they need to deploy and manage.
- Keep WSP, feature, and receiver guidance organized around ownership and operations.

### Quick matrix

| Topic | Key artifact | Review focus |
| --- | --- | --- |
| WSP packaging | Solution package and feature structure | Ownership, activation order, rollback, and upgrade behavior. |
| Feature stapling | Stapled feature set | Where site rollout depends on predictable feature activation. |
| Event receivers and jobs | Receiver class or remote endpoint | Hosting, diagnostics, retries, and modernization boundary. |

### Source families

- [Build farm solutions in SharePoint](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/general-development/build-farm-solutions-in-sharepoint.md)
- [Feature stapling](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/solution-guidance/feature-stapling-sharepoint-add-in.md)
- [Event receivers and list event receivers](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/solution-guidance/event-receiver-and-list-event-receiver-sharepoint-add-in.md)

### Review cues

- Packaging is incomplete if it does not also explain deployment order and upgrade handling.
- Receiver-heavy designs should always describe diagnostics, retries, and operational ownership.
