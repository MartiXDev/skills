## Data and integration map

### Purpose

Use this map when the answer must choose the right runtime client for data
access or explain where permissions live.

### Client comparison table

| Client | Use when | Auth and permissions | Strengths | Avoid |
| --- | --- | --- | --- | --- |
| `SPHttpClient` | The API is SharePoint REST and the call shape is straightforward | Uses the current user's SharePoint auth cookies; no extra dependency | Built in, lightweight, clear SharePoint context | Replacing it with plain `HttpClient` for SharePoint REST |
| PnPjs | SharePoint REST becomes verbose, batched, or hard to maintain | Still runs as client-side code; package only what you need | Fluent, typed, convenient wrapper | Treating it as a substitute for admin provisioning guidance |
| `MSGraphClientV3` | The API is Microsoft Graph and the project is on SPFx v1.15+ | SharePoint Online SSO is the happy path; on-prem can prompt for sign-in again | Graph client ergonomics without hand-rolled auth | Using it for SharePoint-only REST endpoints |
| `AadHttpClient` | The API is secured by Entra ID and is not satisfied by `MSGraphClientV3` | Requires explicit `webApiPermissionRequests`; never assume approval | Clean token acquisition for custom or third-party APIs | Hiding permission-grant requirements or embedding secrets in browser code |

### Permission reminders

- Use the resource display name in `webApiPermissionRequests`.
- Keep scopes minimal and explicit.
- Deployment can succeed even if permission requests are denied.
- Multitenant APIs can require `appId` plus `replyUrl` in modern SPFx
  permission-request flows.

### Related files

- [Data rule](../rules/data-sharepoint-graph-and-aad-clients.md)
- [Deployment rule](../rules/deployment-packaging-and-tenant-rollout.md)
- [Teams and Viva rule](../rules/hosts-teams-and-viva-integration.md)
- [Cookbook index](./cookbook-index.md)

### Source anchors

- [Connect to SharePoint APIs](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/connect-to-sharepoint)
- [Use MSGraphClientV3](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/use-msgraph)
- [Use AadHttpClient](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/use-aadhttpclient)
