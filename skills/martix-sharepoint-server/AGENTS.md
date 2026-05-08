---
description: 'Long-form companion guide for the martix-sharepoint-server standalone skill package'
---

## MartiX SharePoint server companion

- This file is the long-form companion to [SKILL.md](./SKILL.md).
- The package follows a layered standalone-first split: `SKILL.md` routes
  activation, `AGENTS.md` explains how to apply the library, `rules\*.md`
  carries atomic guidance, `references\*.md` maps those decisions to approved
  sources, and `templates\*.md` plus `assets\*.json` keep the package
  maintainable.
- Start with the closest bundled workstream and widen only when the scenario
  genuinely crosses packaging, branding, extensibility, or modernization lanes.

## Package inventory

| Layer | Purpose | Key files |
| --- | --- | --- |
| Discovery | Quick activation and workstream routing | [SKILL.md](./SKILL.md) |
| Companion | Cross-workstream guidance, review routes, and maintainer notes | [AGENTS.md](./AGENTS.md) |
| Rules | Six atomic decision guides across six workstreams | [Rule section contract](./rules/_sections.md) |
| References | Six reference files covering source boundaries, maps, and anti-patterns | [Platform and boundaries map](./references/platform-and-boundaries-map.md) |
| Templates | Authoring, research, and comparison scaffolds | [Rule template](./templates/rule-template.md) |
| Assets | Preferred taxonomy and ordering data | [taxonomy.json](./assets/taxonomy.json) and [section-order.json](./assets/section-order.json) |
| Metadata | Package identity, inventory, and distribution intent | [metadata.json](./metadata.json) |

## Working stance

- Treat SharePoint 2019 and Subscription Edition as the primary delivery
  targets. Pull in SharePoint 2013 and 2010 material only when a legacy
  artifact, migration path, or compatibility discussion requires it.
- Assume farm or WSP deployment is an explicit architectural choice with
  operational, packaging, and rollback consequences.
- Route browser-facing or cloud-first customization work to SPFx or PnP
  guidance instead of stretching classic patterns too far.
- Keep branding, provisioning, feature wiring, and extensibility decisions
  aligned instead of reviewing them as isolated cleanup passes.

### Critical package facts — front-load in every review

- Farm-solution guidance is valid only for on-prem SharePoint surfaces; never
  present it as a default for SharePoint Online.
- Feature framework, event receivers, and classic branding choices have
  deployment and upgrade consequences that must be surfaced early.
- Master pages, page layouts, Design Manager, and composed looks are classic
  publishing-era tools and should be called out as such.
- Modernization advice should identify when an artifact should be retained for
  on-prem delivery versus replaced for future compatibility.

## Workstream playbook

### Foundation and boundaries

- Open this workstream when validating the actual platform target and whether
  the task still belongs in classic server-side guidance.
- Start with
  [SharePoint server foundation — platform boundaries and version targets](./rules/foundation-platform-and-boundaries.md).
- Pair with
  [Platform and boundaries map](./references/platform-and-boundaries-map.md).
- Review questions:
  - Is the target really SharePoint 2019 or Subscription Edition, or is the
    work SharePoint Online-first?
  - Are SharePoint 2010 and 2013 references being used as context rather than
    the default implementation path?
  - Should this requirement be redirected to SPFx or PnP guidance instead of
    remaining in the classic server-side lane?

### Packaging and feature framework

- Open this workstream for WSP composition, feature layout, activation
  strategy, and packaging choices for classic artifacts.
- Start with
  [SharePoint server packaging — WSPs, features, and upgrade shape](./rules/packaging-features-and-wsp.md).
- Pair with
  [Packaging and extensibility map](./references/packaging-and-extensibility-map.md).
- Review questions:
  - Does the solution package have a clear feature and upgrade story?
  - Are modules, list definitions, and stapled features wired with an explicit
    activation order?
  - Has the team called out how rollback, upgrade, and dependency handling
    will work?

### Extensibility

- Open this workstream for event receivers, remote event receivers, timer
  jobs, and related classic extension points.
- Start with
  [SharePoint server extensibility — event receivers, remote receivers, and jobs](./rules/extensibility-event-receivers-and-jobs.md).
- Pair with
  [Packaging and extensibility map](./references/packaging-and-extensibility-map.md).
- Review questions:
  - Is the extensibility point running in-process, remotely, or as a
    supporting job pattern?
  - Have operational and debugging consequences been called out for
    receiver-heavy designs?
  - Has the design been checked against later modernization or webhook
    alternatives?

### Site artifacts and information architecture

- Open this workstream for site definitions, list definitions, modules,
  managed metadata, navigation, and publishing-era site composition.
- Start with
  [SharePoint server site artifacts — definitions, modules, metadata, and navigation](./rules/site-artifacts-and-information-architecture.md).
- Pair with [Site and branding map](./references/site-and-branding-map.md).
- Review questions:
  - Which artifact owns the site shape: a definition, a feature, a module, or
    a provisioning step?
  - Are metadata, navigation, and publishing dependencies surfaced explicitly?
  - Does the review explain how the site artifact interacts with branding and
    provisioning choices?

### Branding

- Open this workstream for master pages, page layouts, Design Manager assets,
  themes, and composed-look-era branding decisions.
- Start with
  [SharePoint server branding — master pages, Design Manager, and themes](./rules/branding-master-pages-design-manager-and-themes.md).
- Pair with [Site and branding map](./references/site-and-branding-map.md).
- Review questions:
  - Is the branding model tied to classic publishing or another site
    experience that justifies these assets?
  - Do page layouts, master pages, and theme assets have a clean ownership and
    deployment story?
  - Has the package documented the maintenance cost of staying on classic
    branding primitives?

### Provisioning and modernization

- Open this workstream for classic site provisioning, publishing rollouts, and
  the modernization boundary when classic assets still exist.
- Start with
  [SharePoint server provisioning — classic rollout, publishing, and modernization boundaries](./rules/provisioning-publishing-and-modernization.md).
- Pair with
  [Provisioning and modernization map](./references/provisioning-modernization-map.md).
- Review questions:
  - Is the provisioning story tied cleanly to packaging, branding, and
    information-architecture ownership?
  - Does the recommendation explain which classic pieces should stay and which
    should move to newer approaches later?
  - Is publishing or portal modernization part of the delivery plan rather
    than a vague future promise?

## Maintainer cues

- Keep the package in its named SharePoint lane and cross-link to sibling
  SharePoint packages rather than duplicating their material.
- Update [references/doc-source-index.md](./references/doc-source-index.md)
  whenever a new official or community source family becomes authoritative
  enough to affect routing.
- Add new rules only when a decision keeps showing up in user tasks or
  reviews; reference maps should absorb the broader glossary and link
  inventory.
