## Approved source index

### Purpose

- Use this file to keep the package grounded in the Microsoft source families
  it should route through first.
- Prefer the SPFx-specific documentation lanes below before borrowing from
  classic SharePoint, generic web development, or sibling SharePoint packages.

### Primary source list

#### Foundation and compatibility

- [SharePoint developer TOC](https://raw.githubusercontent.com/SharePoint/sp-dev-docs/main/docs/toc.yml) — top-level lane map for current SharePoint developer documentation.
- [SharePoint Framework overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/sharepoint-framework-overview) — default anchor for SPFx scope, host reach, and support posture.
- [Supported extensibility platforms](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/supported-extensibility-platforms-overview) — host overview across SharePoint Online, Teams, Viva, and on-premises.
- [Compatibility](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/compatibility) — exact Node, TypeScript, React, and on-prem support matrix.
- [SharePoint 2019 and Subscription Edition support](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/sharepoint-2019-and-subscription-edition-support) — detailed on-premises constraints and caveats.

#### Tooling and scaffolding

- [Set up your development environment](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/set-up-your-development-environment) — current Heft-based environment guidance and prerequisite tooling.
- [Tools and libraries](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/tools-and-libraries) — toolchain and library overview including Heft versus legacy gulp notes.

#### Components and UI

- [Web parts overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/web-parts/overview-client-side-web-parts) — page-content surface definition and host reuse entry point.
- [Property pane basics](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/web-parts/basics/integrate-with-property-pane) — property pane structure and reactive versus non-reactive behavior.
- [Web part properties with SharePoint](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/web-parts/guidance/integrate-web-part-properties-with-sharepoint) — `propertiesMetadata` behavior and modern-page caveats.
- [Extensions overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/extensions/overview-extensions) — Application Customizer, Command Set, Field Customizer, Form Customizer, and Search Query Modifier overview.
- [Form Customizer](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/extensions/get-started/building-form-customizer) — lifecycle and debug setup for list or library form replacement.
- [Library component overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/library-component-overview) — reusable, separately deployed shared client code guidance.
- [Theme colors](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/use-theme-colors-in-your-customizations) — theme tokens and theme-aware styling.
- [Office UI Fabric integration](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/office-ui-fabric-integration) — safe UI-library integration and global CSS warnings.

#### Data and API clients

- [Connect to SharePoint APIs](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/connect-to-sharepoint) — SharePoint REST, SPHttpClient, and PnPjs trade-offs.
- [Use MSGraphClientV3](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/use-msgraph) — Microsoft Graph client guidance and SSO caveats.
- [Use AadHttpClient](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/use-aadhttpclient) — Entra-secured API access and permission-request model.

#### Deployment and host integration

- [Solution packaging](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/web-parts/basics/notes-on-solution-packaging) — `package-solution.json` schema and feature packaging behavior.
- [Tenant-scoped deployment](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/tenant-scoped-deployment) — `skipFeatureDeployment` behavior and central deployment caveats.
- [Teams overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/build-for-teams-overview) — why and when SPFx is used in Teams.
- [Expose web parts in Teams](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/build-for-teams-expose-webparts-teams) — `supportedHosts` and messaging-extension participation.
- [Teams considerations](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/build-for-teams-considerations) — hosting, auth, deployment, and Teams SDK guardrails.
- [Teams deployment options](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/deployment-spfx-teams-solutions) — automatic versus developer-provided Teams packaging.
- [Viva Connections overview](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/viva/overview-viva-connections) — ACE-first dashboard and SPFx role in Viva.
- [ACE and Teams apps](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/viva/get-started/adaptive-card-extensions-and-teams) — deep-link and mixed-host scenario guidance.

#### Migration

- [Script Editor migration](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/web-parts/guidance/migrate-script-editor-web-part-customizations) — Script or Content Editor modernization.
- [UserCustomAction migration](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/extensions/guidance/migrate-user-customactions-to-spfx-extensions) — classic extension mapping into SPFx surfaces.

### Source boundary notes

- Treat SharePoint Online as the default target for new SPFx guidance.
- Use the current compatibility table for exact version advice before giving any
  Node, React, TypeScript, or toolchain recommendation.
- Use SharePoint Server 2019 and Subscription Edition docs as compatibility
  constraints, not as the default architectural lane.
- When the current docs disagree about Subscription Edition support, call out
  the mismatch explicitly and stay conservative.
- Route classic farm-solution or WSP work to separate server-side SharePoint
  guidance.
- Route provisioning, tenant automation, or operator-run API work to the PnP
  skill.

### Explicit exclusions for first-pass routing

- Classic farm solutions, WSP packaging, Feature Framework development, or
  master-page-first customization.
- Pure provisioning or automation tasks with no client-side implementation
  angle.
- Generic React or TypeScript advice that is not materially constrained by
  SPFx.
