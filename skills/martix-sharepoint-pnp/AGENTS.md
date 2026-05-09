---
description: 'Long-form companion guide for the martix-sharepoint-pnp standalone skill package'
---

## MartiX SharePoint PnP companion

- This file is the long-form companion to [SKILL.md](./SKILL.md).
- The package follows a layered, standalone-first split: `SKILL.md` routes activation, `AGENTS.md` explains how to apply the library, `rules\*.md` holds atomic guidance, `references\*.md` maps guidance to approved sources, and `templates\*.md` plus `assets\*.json` keep the package maintainable.
- Start with the closest bundled workstream map and expand to cross-workstream routes when the scenario spans multiple domains.

## Package inventory

| Layer | Purpose | Key files |
| --- | --- | --- |
| Discovery | Quick activation and workstream routing | [SKILL.md](./SKILL.md) |
| Companion | Cross-workstream guidance, review routes, and maintainer notes | [AGENTS.md](./AGENTS.md) |
| Rules | 6 atomic decision guides across 5 domains | [Rule section contract](./rules/_sections.md) |
| References | 6 reference files (maps, source index, and review quick reference) | [Tool selection map](./references/tool-selection-map.md) |
| Templates | Authoring, research, and comparison scaffolds | [Rule template](./templates/rule-template.md) |
| Assets | Preferred taxonomy and ordering data | [taxonomy.json](./assets/taxonomy.json) and [section-order.json](./assets/section-order.json) |
| Metadata | Package identity, inventory, and distribution intent | [metadata.json](./metadata.json) |

## Working stance

- Treat tool selection as an architectural decision: PnP PowerShell, CLI for Microsoft 365, and PnPjs each imply different hosting, auth, and maintenance trade-offs.
- Keep auth, connection, provisioning, and operational safety connected so the package does not optimize a script while ignoring how it will run in production.
- Use provisioning and automation guidance to reduce repeated setup work, not to hide ownership or idempotency concerns.
- Cross-link to the SPFx or server-side packages when the task leaves tooling and becomes component implementation or classic artifact maintenance.

### Critical package facts — front-load in every review

- Recent PnP PowerShell guidance assumes you register your own Entra ID application; auth and connection advice must reflect that reality.
- CLI for Microsoft 365 and PnP PowerShell overlap, but they are not interchangeable by default; the environment and workflow shape should drive the choice.
- PnPjs is strongest when SharePoint or Graph access is part of a JavaScript or SPFx solution rather than a shell-automation story.
- Provisioning guidance should emphasize repeatability, idempotency, and rollback awareness instead of one-off script success.

## Workstream playbook

### Tool selection and boundaries

- Use for first-pass routing between PnP PowerShell, CLI for Microsoft 365, PnPjs, and the adjacent SPFx or server-side packages.
- Start with [SharePoint PnP foundation — tool selection and package boundaries](./rules/tool-selection-and-boundaries.md).
- Pair with [Tool selection map](./references/tool-selection-map.md) when the scenario spans multiple topics.
- Review questions:
  - Is the task a shell automation, tenant admin, or JavaScript/SPFx integration problem?
  - Which tool best matches the runtime and delivery model?
  - Does the request really belong in the PnP package, or has it become SPFx implementation or classic artifact work?

### Authentication and connections

- Use for app registration, permissions, connection flow, and environment-specific auth decisions.
- Start with [SharePoint PnP auth — app registration, permissions, and connection flow](./rules/auth-app-registration-and-connections.md).
- Pair with [Authentication and connection map](./references/auth-connection-map.md) when the scenario spans multiple topics.
- Review questions:
  - Which Entra ID app or connection model will the automation use?
  - Are permission and connection choices grounded in the actual execution environment?
  - Has the package acknowledged the post-2024 PnP PowerShell registration reality?

### Automation patterns

- Use for PowerShell and CLI automation shapes, repeatable operational routines, and scripting safety.
- Start with [SharePoint PnP automation — PnP PowerShell patterns and safety](./rules/pnppowershell-automation-patterns.md).
- Add [SharePoint PnP automation — CLI for Microsoft 365 and tenant operations](./rules/cli-m365-and-tenant-automation.md) when the scenario widens.
- Pair with [Automation recipes](./references/automation-recipes.md) when the scenario spans multiple topics.
- Review questions:
  - Is the automation better expressed in PowerShell or a CLI workflow?
  - Does the script design account for reruns, failure handling, and operational clarity?
  - Are provisioning and auth choices reflected in the automation design?

### Provisioning and composition

- Use for provisioning engines, site scripts, site designs, and PnPjs composition inside broader SharePoint delivery flows.
- Start with [SharePoint PnP composition — PnPjs, site scripts, and provisioning workflows](./rules/pnpjs-and-provisioning-composition.md).
- Pair with [Provisioning composition map](./references/provisioning-composition-map.md) when the scenario spans multiple topics.
- Review questions:
  - Is the provisioning flow repeatable and idempotent?
  - Which pieces belong in provisioning tooling versus inside an application or SPFx solution?
  - Are site scripts, designs, and PnP provisioning guidance being combined intentionally?

### Operations and integration

- Use for idempotency, governance, rollback awareness, and SPFx handoff boundaries in PnP-heavy workflows.
- Start with [SharePoint PnP operations — idempotency, governance, and SPFx integration boundaries](./rules/governance-idempotency-and-spfx-integration.md).
- Pair with [Provisioning composition map](./references/provisioning-composition-map.md) when the scenario spans multiple topics.
- Review questions:
  - Can the workflow be rerun safely across environments?
  - Where are rollback, recovery, and ownership documented?
  - If SPFx is involved, which work belongs in the application and which belongs in automation?

## Maintainer cues

- Keep the package in its named SharePoint lane and cross-link to sibling SharePoint packages rather than duplicating their material.
- Update `references/doc-source-index.md` whenever a new official or community source family becomes authoritative enough to affect routing.
- Add new rules only when a decision keeps showing up in user tasks or reviews; reference maps should absorb the broader glossary and link inventory.
