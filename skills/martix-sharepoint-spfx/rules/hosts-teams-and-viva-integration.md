## SPFx hosts — Teams and Viva integration

Use this rule when SPFx is being surfaced in Microsoft Teams or when Viva
Connections decisions are part of the design.

### Purpose

- Keep Teams and Viva guidance tied to supported SPFx host capabilities.
- Separate SPFx-owned UI delivery from broader Teams app capabilities that
  require other application parts.

### Default guidance

- Use SPFx host integration only when an SPFx component is the actual UI
  surface. Teams tabs and personal apps come from web parts; Viva dashboard
  experiences are ACE-first.
- Expose a web part in Teams by adding `TeamsTab` or `TeamsPersonalApp` to
  `supportedHosts` as needed.
- Treat messaging extensions as a broader solution boundary. The web part can
  participate, but a custom Teams app package and supporting bot or task
  module flow are still required.
- Use the SharePoint Online-backed Teams deployment path. Choose the automatic
  Add to Teams package for simple scenarios and a developer-provided
  `TeamsSPFxApp.zip` when you need full manifest control or richer Teams app
  features.
- Use the Teams SDK exposed by SPFx context and do not install custom Teams JS
  SDK versions.
- Treat Viva Connections customizations as ACE-first. Use ACEs for dashboard
  cards and deep link to Teams or SharePoint experiences when that is the
  best user journey.
- Keep non-UI Teams capabilities such as bots, messaging extensions, or
  meeting apps outside SPFx unless the answer explicitly includes the extra
  application pieces.

### Avoid

- Assuming SPFx alone covers every Teams app capability.
- Installing or initializing your own Teams JS SDK inside an SPFx component.
- Treating a normal web part as the default Viva dashboard component instead of
  an ACE.
- Hardcoding tenant or site URLs into custom Teams manifests when placeholders
  are supported.

### Review checklist

- [ ] The host is explicitly SharePoint Online-backed before Teams or Viva
  guidance is applied.
- [ ] `supportedHosts`, Teams packaging choice, or ACE role is explicit.
- [ ] The answer names any non-SPFx app pieces still required.
- [ ] The deployment path matches the host scenario instead of staying vague.

### Related files

- [Teams and Viva map](../references/teams-viva-map.md)
- [Deployment rule](./deployment-packaging-and-tenant-rollout.md)
- [Web parts rule](./webparts-property-panes-and-properties.md)
- [Host support matrix](../assets/host-support-matrix.json)

### Source anchors

- [Teams overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/build-for-teams-overview)
- [Expose web parts in Teams](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/build-for-teams-expose-webparts-teams)
- [Teams considerations](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/build-for-teams-considerations)
- [Teams deployment options](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/deployment-spfx-teams-solutions)
- [Viva Connections overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/viva/overview-viva-connections)
- [ACE and Teams apps](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/viva/get-started/adaptive-card-extensions-and-teams)
