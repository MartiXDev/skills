---
description: 'Long-form companion guide for the martix-sharepoint-spfx standalone skill package'
---

## MartiX SharePoint Framework companion

- This file is the long-form companion to [SKILL.md](./SKILL.md).
- The package follows a layered standalone-first split: `SKILL.md` routes
  activation, `AGENTS.md` explains how to apply the library, `rules\*.md`
  carries atomic guidance, `references\*.md` maps those decisions to approved
  Microsoft sources, and `templates\*.md` plus `assets\*.json` keep the package
  maintainable.
- Start with the closest bundled workstream map and expand only when the
  scenario genuinely crosses hosts, versions, component types, or migration
  lanes.

## Package inventory

| Layer | Purpose | Key files |
| --- | --- | --- |
| Discovery | Quick activation and workstream routing | [SKILL.md](./SKILL.md) |
| Companion | Cross-workstream guidance, review routes, and maintainer notes | [AGENTS.md](./AGENTS.md) |
| Rules | Eleven SPFx decision guides across ten workstreams | [Rule section contract](./rules/_sections.md) |
| References | Ten reference maps covering sources, support boundaries, toolchains, components, data access, deployment, host integration, and migration | [Cookbook index](./references/cookbook-index.md) |
| Templates | Authoring, research, and comparison scaffolds | [Rule template](./templates/rule-template.md) |
| Assets | Taxonomy, preferred ordering, and host-support data | [taxonomy.json](./assets/taxonomy.json), [section-order.json](./assets/section-order.json), and [host-support-matrix.json](./assets/host-support-matrix.json) |
| Metadata | Package identity, artifact inventory, and distribution handoff notes | [metadata.json](./metadata.json) |

## Working stance

- Treat SharePoint Online as the default lane for SPFx guidance.
- Keep SPFx version choice, Node or React alignment, component selection, data
  clients, and deployment strategy connected so one recommendation does not
  invalidate the others.
- Use SharePoint 2019 and Subscription Edition notes as compatibility
  constraints, not as a reason to collapse SharePoint Online guidance into
  classic or server-side patterns.
- Translate classic customization intent into modern SPFx surfaces instead of
  preserving old implementation shapes by default.

### Critical package facts — front-load in every review

- Version mismatch is one of the fastest ways to produce unusable SPFx advice.
- Component choice matters. Web parts, extensions, Form Customizers, library
  components, and ACE or Teams host scenarios imply different lifecycle,
  permission, and deployment choices.
- Deployment and asset hosting are part of the architecture, not post-build
  chores.
- Subscription Edition support is currently described differently across docs;
  keep the ambiguity explicit instead of flattening it into an overconfident
  promise.

## Workstream playbook

## Foundation and support boundaries

- Open this workstream when validating that the task belongs in SPFx at all and
  that the requested host or platform is one the package should own.
- Start with
  [SPFx foundation — scope and support boundaries](./rules/foundation-scope-and-support-boundaries.md).
- Pair with
  [Foundation and support map](./references/foundation-scope-support-map.md) and
  [Host support matrix](./assets/host-support-matrix.json).
- Review questions:
  - What host or product surface is in play: SharePoint Online, Teams, Viva,
    SharePoint Server 2019, or Subscription Edition?
  - Does the task really belong in SPFx rather than the server-side or PnP
    package?
  - Are unsupported classic artifacts or DOM assumptions being smuggled in?

## Versioning, compatibility, and scaffolding

- Open this workstream for Node, React, TypeScript, Heft versus gulp,
  generator, scaffold, serve, and debug choices.
- Start with
  [SPFx tooling — versioning and compatibility](./rules/tooling-versioning-and-compatibility.md)
  and
  [SPFx projects — toolchain and scaffolding](./rules/projects-toolchain-and-scaffolding.md).
- Pair with [Version support map](./references/version-support-map.md) and
  [Toolchain and deployment map](./references/toolchain-deployment-map.md).
- Review questions:
  - Does the chosen toolchain match the actual SPFx version family?
  - Are Node, React, and TypeScript pinned to the compatibility matrix instead
    of wishful upgrades?
  - If the target is 2019 or SE, are the constraints documented conservatively?

## Web parts and property panes

- Open this workstream for page content components, property pane shape,
  `propertiesMetadata`, and page-hosted experiences.
- Start with
  [SPFx web parts — property panes, properties, and page hosting](./rules/webparts-property-panes-and-properties.md).
- Pair with [Component selection map](./references/component-selection-map.md)
  and [UI and theming map](./references/ui-theming-map.md).
- Review questions:
  - Is a web part actually the right surface?
  - Are property panes, configuration storage, and validation aligned with the
    page experience?
  - Is the design depending on modern-page-only behavior such as property
    metadata processing?

## Extensions, forms, and reusable components

- Open this workstream for Application Customizers, Command Sets, Field
  Customizers, Form Customizers, and library components.
- Start with
  [SPFx extensions — application, command, and field surfaces](./rules/extensions-application-command-field.md)
  or
  [SPFx components — Form Customizers and library components](./rules/components-form-customizers-and-library-components.md).
- Pair with [Component selection map](./references/component-selection-map.md).
- Review questions:
  - Which surface best matches the lifecycle and visual placement?
  - Is the request really a list form or list-cell experience rather than a
    page-wide customization?
  - Is a library component justified, or would normal shared code be cleaner?

## Data and API clients

- Open this workstream for `SPHttpClient`, PnPjs, Microsoft Graph,
  `MSGraphClientV3`, `AadHttpClient`, or permission-request design.
- Start with
  [SPFx data — SharePoint, Graph, and AadHttpClient boundaries](./rules/data-sharepoint-graph-and-aad-clients.md).
- Pair with [Data and integration map](./references/data-integration-map.md).
- Review questions:
  - Which client truly owns the API call?
  - Are permission requests explicit and minimal?
  - Should provisioning or operator-run API work move to separate provisioning
    or automation guidance?

## Packaging, deployment, and rollout

- Open this workstream for `package-solution.json`, feature packaging, app
  catalog strategy, asset hosting, and tenant-wide rollout posture.
- Start with
  [SPFx deployment — packaging and tenant rollout](./rules/deployment-packaging-and-tenant-rollout.md).
- Pair with [Toolchain and deployment map](./references/toolchain-deployment-map.md).
- Review questions:
  - How will the package, assets, and deployment scope be managed?
  - Is `skipFeatureDeployment` actually compatible with the solution contents?
  - Are Teams or extension side effects explicit during updates?

## Teams and Viva host integration

- Open this workstream when SPFx is being surfaced in Teams or when Viva
  Connections or ACE decisions are in play.
- Start with
  [SPFx hosts — Teams and Viva integration](./rules/hosts-teams-and-viva-integration.md).
- Pair with [Teams and Viva map](./references/teams-viva-map.md).
- Review questions:
  - Is SharePoint Online clearly established as the deployment host?
  - Are `supportedHosts`, Teams manifest choices, or ACE boundaries explicit?
  - Does the scenario require non-SPFx Teams capabilities that must be built
    elsewhere?

## React, TypeScript, and theming

- Open this workstream for UI package posture, Fluent or Office UI Fabric
  integration, CSS isolation, and theme-aware rendering.
- Start with
  [SPFx UI — React, TypeScript, and theming](./rules/ui-react-typescript-and-theming.md).
- Pair with [UI and theming map](./references/ui-theming-map.md).
- Review questions:
  - Are React and UI packages aligned with the SPFx baseline?
  - Is theming implemented with tokens and theme-variant support instead of
    hardcoded colors?
  - Are global CSS collisions being avoided?

## Migration and modernization

- Open this workstream for Script Editor, Content Editor, JSLink,
  UserCustomAction, or ECB-era migrations.
- Start with
  [SPFx migration — classic to modern client-side surfaces](./rules/migration-classic-to-modern-spfx.md).
- Pair with [Migration map](./references/migration-map.md).
- Review questions:
  - Which old artifact is being replaced, and with what modern SPFx surface?
  - Can any code be reused safely, or is a rewrite the better long-term option?
  - Is the answer translating the requirement instead of reproducing classic DOM
    hacks?

## Maintainer cues

- Keep this package in the modern SPFx lane and cross-link to sibling
  SharePoint packages instead of duplicating their material.
- Keep package-local install notes standalone-first and neutral about current
  shared marketplace registration; repository-level manifests live outside this
  folder.
- Update `references/doc-source-index.md` and
  `assets/host-support-matrix.json` when Microsoft changes current compatibility
  statements or host-support descriptions.
- Add new rules only when a design decision keeps showing up in user tasks or
  reviews; broader source inventories belong in the reference maps.
- Keep the Subscription Edition ambiguity conservative and well-cited until the
  official docs align more clearly.
