## SharePoint server provisioning and modernization map

### Purpose

- Keep classic provisioning useful for current on-prem delivery while still calling out modernization boundaries honestly.
- Avoid turning every legacy question into a generic cloud rewrite recommendation.

### Quick matrix

| Situation | Current-state guidance | Boundary note |
| --- | --- | --- |
| Classic publishing portal still in service | Document current packaging, branding, and publishing rollout accurately. | Call out modernization only where it changes future planning. |
| Legacy event receiver or farm artifact must stay | Explain operational safeguards and ownership. | Identify migration candidates without blocking current support work. |
| Provisioning redesign request | Model feature, branding, and site artifact ownership together. | Escalate to SPFx or PnP only when the target surface truly changes. |

### Source families

- [SharePoint site provisioning solutions](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/solution-guidance/sharepoint-site-provisioning-solutions.md)
- [Modernize publishing portals](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/transform/modernize-publishing-portal.md)
- [Transforming farm solutions](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/transform/farm-solution-guidance.md)

### Review cues

- If the answer needs a cloud-first tooling recommendation, move the task into the SPFx or PnP package instead of stretching this one.
- If the artifact must remain on-prem, keep the package honest about support and upgrade consequences.
