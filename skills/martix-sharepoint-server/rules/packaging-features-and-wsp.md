## SharePoint server packaging — WSPs, features, and upgrade shape

Use this rule for feature-based packaging, WSP layout, and activation planning.

### Purpose

- Keep classic packaging decisions explicit instead of allowing feature XML, modules, and provisioning assets to drift into an unreviewable bundle.
- Make feature scope, dependency order, and upgrade expectations visible before deployment.

### Default guidance

- Group artifacts by deployment and lifecycle boundaries so the WSP reflects how the farm will actually be activated and upgraded.
- Model feature dependencies, stapling, and any upgrade receiver behavior before finalizing packaging.
- Keep provisioning, branding, and extensibility assets mapped back to the feature that owns them.

### Avoid

- Dumping unrelated artifacts into one WSP without a feature ownership model.
- Treating feature activation order as an afterthought discovered only during deployment.

### Review checklist

- Confirm the package documents which feature owns each major artifact family.
- Confirm stapling or upgrade behavior is explicit when site rollout depends on it.
- Confirm the rollback and upgrade story is described at the same time as packaging.

### Related files

- [Rule section contract](./_sections.md)
- [Packaging and extensibility map](../references/packaging-and-extensibility-map.md)
- [Provisioning and modernization map](../references/provisioning-modernization-map.md)

### Source anchors

- [Build farm solutions in SharePoint](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/general-development/build-farm-solutions-in-sharepoint.md)
- [Feature stapling](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/solution-guidance/feature-stapling-sharepoint-add-in.md)
- [Use Feature upgrade to apply new master pages](https://github.com/SharePoint/sp-dev-docs/blob/main/docs/general-development/use-feature-upgrade-to-apply-new-sharepoint-master-pages-when-upgrading-fro.md)
