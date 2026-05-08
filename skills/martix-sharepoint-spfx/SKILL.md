---
name: martix-sharepoint-spfx
description: 'Standalone-first SharePoint Framework guidance for SharePoint Online client-side work with SPFx, React, and TypeScript. Covers web parts, property panes, extensions, form customizers, library components, SharePoint and Graph API clients, packaging, deployment, Teams host exposure, Viva Connections integration, theming, toolchains, and migration from Script Editor or UserCustomAction patterns. Use this skill when the task mentions SPFx, SharePoint Framework, SharePoint Online client-side customization, web parts, extensions, Form Customizer, library components, React or TypeScript in SharePoint, supportedHosts, MSGraphClientV3, AadHttpClient, skipFeatureDeployment, Teams tabs from SPFx, or modernizing classic customizations into supported client-side solutions. Do not use it for classic farm solutions, WSPs, Feature Framework, master pages, server-side object model code, or provisioning-only work.'
license: Complete terms in LICENSE.txt
---

## MartiX SharePoint Framework router

- Standalone-first skill package focused on SharePoint Online-first SPFx
  decisions for modern client-side customization.
- Keep host surface, SPFx version, toolchain, component choice, API clients,
  deployment, and migration guidance aligned instead of treating them as
  unrelated cleanup passes.
- Use [AGENTS.md](./AGENTS.md) when the scenario crosses multiple workstreams or
  needs the longer review routes, package inventory, or maintainer cues.

## When to use this skill

- Author or review SPFx web parts, extensions, form customizers, library
  components, or Viva Connections-adjacent SPFx work.
- Set up, modernize, or verify an SPFx toolchain, scaffold, dependency
  baseline, or compatibility posture.
- Design property panes, `propertiesMetadata`, React structure, theme-aware UI,
  packaging, asset hosting, or rollout strategy for SharePoint Online
  customizations.
- Integrate SPFx code with SharePoint REST, PnPjs, Microsoft Graph,
  `MSGraphClientV3`, or `AadHttpClient`.
- Expose SPFx web parts in Teams or connect Viva Connections cards and Teams
  experiences where SPFx is the delivery vehicle.
- Translate Script Editor, Content Editor, JSLink, UserCustomAction, or ECB-era
  customizations into supported modern client-side surfaces.
- Review SharePoint 2019 or Subscription Edition compatibility notes without
  letting on-prem constraints erase the SharePoint Online-first baseline.

## Not for this skill

- Classic farm solutions, WSP packages, Feature Framework receivers, master
  pages, page layouts, or other server-side SharePoint Server work.
- Pure provisioning, tenant automation, or operator-run workflows that are
  better handled as separate provisioning or automation guidance.
- Generic React or TypeScript advice that is not materially shaped by SPFx
  constraints.
- Broad SharePoint governance, compliance, or tenant administration questions
  with no client-side implementation angle.

## Quick default choices

| Concern | Default | Escalate when |
| --- | --- | --- |
| Page content or configurable page experience | SPFx web part | The request is really page chrome, list commands, or list form replacement |
| Page chrome, placeholders, command bars, or list cells | SPFx extension | The request is really page content or a form experience |
| List or library new, edit, or display forms | SPFx Form Customizer | The requirement spans more than list or library form lifecycle |
| Reuse across multiple SPFx solutions | Local package or shared workspace code first | A separately deployed library component is truly needed across solutions |
| Runtime SharePoint data access | `SPHttpClient` or carefully scoped PnPjs | The task is actually provisioning-only or requires Graph or external API auth |
| Graph or Entra-secured API access | `MSGraphClientV3` or `AadHttpClient` with explicit permissions | The task depends on server-side processing or non-SPFx auth flows |
| SharePoint Server 2019 or SE target | Treat 2019-era constraints as the conservative baseline | Local validation and current docs prove a narrower or broader support envelope |

## Start with the closest route

1. Pick the closest workstream below.
2. Add the paired reference map before widening the answer.
3. Pull in [assets/host-support-matrix.json](./assets/host-support-matrix.json)
   whenever host or version support is part of the decision.
4. Open [AGENTS.md](./AGENTS.md) when the scenario spans setup, component
   selection, deployment, and migration together.

## Rule library by workstream

### Foundation and support boundaries

- Use for first-pass routing, SharePoint Online-first scope checks, host
  identification, classic exclusions, and conservative 2019 or Subscription
  Edition notes.
- Rule:
  [SPFx foundation — scope and support boundaries](./rules/foundation-scope-and-support-boundaries.md)
- Maps and assets:
  - [Foundation and support map](./references/foundation-scope-support-map.md)
  - [Host support matrix](./assets/host-support-matrix.json)

### Versioning, compatibility, and scaffolding

- Use for Node, React, TypeScript, Heft versus gulp, generator choices, project
  baselines, and serve or debug setup.
- Rules:
  - [SPFx tooling — versioning and compatibility](./rules/tooling-versioning-and-compatibility.md)
  - [SPFx projects — toolchain and scaffolding](./rules/projects-toolchain-and-scaffolding.md)
- Maps:
  - [Version support map](./references/version-support-map.md)
  - [Toolchain and deployment map](./references/toolchain-deployment-map.md)

### Web parts, property panes, and page experiences

- Use for client-side web parts, property pane shape, reactive versus
  non-reactive configuration, `propertiesMetadata`, and page-hosted experiences.
- Rule:
  [SPFx web parts — property panes, properties, and page hosting](./rules/webparts-property-panes-and-properties.md)
- Maps:
  - [Component selection map](./references/component-selection-map.md)
  - [UI and theming map](./references/ui-theming-map.md)

### Extensions, forms, and reusable components

- Use for Application Customizers, Command Sets, Field Customizers, Form
  Customizers, and library components.
- Rules:
  - [SPFx extensions — application, command, and field surfaces](./rules/extensions-application-command-field.md)
  - [SPFx components — Form Customizers and library components](./rules/components-form-customizers-and-library-components.md)
- Map:
  [Component selection map](./references/component-selection-map.md)

### Data and API clients

- Use for `SPHttpClient`, PnPjs, Microsoft Graph, `MSGraphClientV3`,
  `AadHttpClient`, and package-solution permission decisions.
- Rule:
  [SPFx data — SharePoint, Graph, and AadHttpClient boundaries](./rules/data-sharepoint-graph-and-aad-clients.md)
- Map:
  [Data and integration map](./references/data-integration-map.md)

### Packaging, deployment, and tenant rollout

- Use for `package-solution.json`, feature packaging, app catalog deployment,
  asset hosting, `skipFeatureDeployment`, and rollout posture.
- Rule:
  [SPFx deployment — packaging and tenant rollout](./rules/deployment-packaging-and-tenant-rollout.md)
- Map:
  [Toolchain and deployment map](./references/toolchain-deployment-map.md)

### Teams and Viva host integration

- Use for `supportedHosts`, Teams tabs and personal apps, Teams deployment
  options, messaging-extension boundaries, and Viva Connections or ACE handoffs.
- Rule:
  [SPFx hosts — Teams and Viva integration](./rules/hosts-teams-and-viva-integration.md)
- Map:
  [Teams and Viva map](./references/teams-viva-map.md)

### React, TypeScript, and theming

- Use for React package posture, Fluent or Office UI Fabric integration,
  theme tokens, CSS isolation, and theme-aware UI structure.
- Rule:
  [SPFx UI — React, TypeScript, and theming](./rules/ui-react-typescript-and-theming.md)
- Map:
  [UI and theming map](./references/ui-theming-map.md)

### Migration and modernization

- Use for Script Editor, Content Editor, JSLink, UserCustomAction, ECB, or other
  pre-SPFx customizations that need modern supported replacements.
- Rule:
  [SPFx migration — classic to modern client-side surfaces](./rules/migration-classic-to-modern-spfx.md)
- Map:
  [Migration map](./references/migration-map.md)

## Quick reference surfaces

- [Source index and guardrails](./references/doc-source-index.md)
- [Foundation and support map](./references/foundation-scope-support-map.md)
- [Version support map](./references/version-support-map.md)
- [Component selection map](./references/component-selection-map.md)
- [Data and integration map](./references/data-integration-map.md)
- [Teams and Viva map](./references/teams-viva-map.md)
- [Migration map](./references/migration-map.md)
- [Cookbook index](./references/cookbook-index.md)

## Package conventions

- Every rule follows the shared section contract in
  [rules/_sections.md](./rules/_sections.md): `Purpose`, `Default guidance`,
  `Avoid`, `Review checklist`, `Related files`, and `Source anchors`.
- Use [the rule template](./templates/rule-template.md) for new rules,
  [the research pack template](./templates/research-pack-template.md) for source
  inventories, and
  [the comparison matrix template](./templates/comparison-matrix-template.md)
  for external comparisons.
- Use [metadata.json](./metadata.json) plus the assets in [assets/](./assets) as
  the package inventory for taxonomy, ordering, support notes, and distribution
  metadata.

## Standalone-first note

- This skill is authored as a standalone package under `src\skills`.
- Install or preview it directly with `npx skills add <source>`.
- Shared marketplace registration is managed in repository-level metadata
  outside this package.
- This folder remains the canonical source of truth for standalone installs,
  package-local validation, and any later shared registration.
