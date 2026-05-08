## SPFx data — SharePoint, Graph, and AadHttpClient boundaries

Use this rule when the answer depends on selecting the right runtime client
for SharePoint REST, Microsoft Graph, or another Entra-secured API.

### Purpose

- Keep client choice explicit so runtime data access stays aligned with the
  actual API boundary.
- Separate browser-based runtime access from provisioning or operator-driven
  automation work.

### Default guidance

- Use `SPHttpClient` for straightforward SharePoint REST calls in SPFx. It is
  already available in context, carries the current user's authentication
  cookies, and avoids extra dependencies.
- Remember that `SPHttpClient` uses OData v4 semantics by default. Be explicit
  about headers if the request depends on metadata behavior.
- Use PnPjs when SharePoint REST becomes verbose, batch-heavy, or difficult to
  maintain. Keep its open-source support model and bundle-size impact
  explicit, and import only what the solution actually needs.
- Use `MSGraphClientV3` for Microsoft Graph inside SPFx v1.15+ when the task is
  truly Graph-shaped. Keep in mind that single sign-on behavior is a
  SharePoint Online strength; on-premises use may still prompt users to sign
  in again.
- Use `AadHttpClient` for custom Entra-secured APIs or other secured resources
  where SPFx should acquire the token on behalf of the current user.
- Keep `webApiPermissionRequests` minimal, use the resource display name, and
  never assume the requested permission was granted just because deployment
  succeeded.
- If the API is multitenant and its service principal must be created in the
  current tenant, document `appId` plus `replyUrl` requirements instead of
  hand-waving the approval flow.
- Route provisioning or admin API work to separate provisioning or automation
  guidance rather than forcing a runtime SPFx client into an operator
  workflow.

### Avoid

- Using plain `HttpClient` for SharePoint REST requests.
- Using Microsoft Graph by habit for endpoints that are still clearly owned by
  SharePoint REST.
- Assuming additional permission scopes are already approved.
- Embedding secrets, server tokens, or hidden elevated flows in browser code.

### Review checklist

- [ ] The answer names the owning API and the chosen client explicitly.
- [ ] SharePoint REST calls use `SPHttpClient` unless a deliberate wrapper
  choice is justified.
- [ ] Graph or external API permission requests are explicit and minimal.
- [ ] Runtime browser calls and provisioning workflows are separated.

### Related files

- [Data and integration map](../references/data-integration-map.md)
- [Deployment rule](./deployment-packaging-and-tenant-rollout.md)
- [Teams and Viva rule](./hosts-teams-and-viva-integration.md)
- [Foundation rule](./foundation-scope-and-support-boundaries.md)

### Source anchors

- [Connect to SharePoint APIs](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/connect-to-sharepoint)
- [Use MSGraphClientV3](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/use-msgraph)
- [Use AadHttpClient](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/use-aadhttpclient)
