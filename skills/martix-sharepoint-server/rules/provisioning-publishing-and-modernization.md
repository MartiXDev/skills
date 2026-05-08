## SharePoint server provisioning — classic rollout, publishing, and modernization boundaries

Use this rule for classic site provisioning decisions and modernization-aware on-prem delivery guidance.

### Purpose

- Tie provisioning, publishing, and modernization notes together so the package does not pretend legacy assets are future-proof.
- Keep classic rollout guidance useful for current on-prem delivery while still identifying where later change is likely.

### Default guidance

- Describe classic rollout using the artifact families the farm actually deploys today, then call out which parts are preservation choices versus preferred future-state patterns.
- Keep publishing, branding, and information architecture decisions connected to the provisioning flow.
- Use modernization notes to clarify boundaries, not to derail an on-prem task into unrelated cloud redesign advice.

### Avoid

- Giving modernization advice so abstract that it does not help the current on-prem delivery.
- Pretending a classic provisioning stack has no upgrade or migration consequences.

### Review checklist

- Confirm current-state rollout steps are documented for the on-prem target.
- Confirm modernization notes identify concrete boundaries rather than generic aspirations.
- Confirm branding, packaging, and site-artifact dependencies are cross-linked from the provisioning discussion.

### Related files

- [Provisioning and modernization map](../references/provisioning-modernization-map.md)
- [Site and branding map](../references/site-and-branding-map.md)

### Source anchors

- [SharePoint site provisioning solutions](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/solution-guidance/sharepoint-site-provisioning-solutions.md)
- [Modernize publishing portals](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/transform/modernize-publishing-portal.md)
- [Transforming farm solutions](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/transform/farm-solution-guidance.md)
