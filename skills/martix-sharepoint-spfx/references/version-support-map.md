## Version support map

### Purpose

Use this map when the answer must pin an SPFx baseline or explain why a
host forces a specific toolchain and dependency set.

### Compatibility matrix for package routing

| Target | Conservative package stance | Toolchain | Key notes |
| --- | --- | --- | --- |
| New or current SharePoint Online project | Use the actual current SPFx release family in the project | Heft for v1.22+, legacy gulp for older online projects | As of the current docs, SPFx 1.22.x expects Node 22 and React 17.0.1 |
| Existing SharePoint Online project on v1.0-v1.21.1 | Match the project's actual SPFx line first | Legacy gulp path | Do not jump to Heft advice until the project is actually upgraded |
| SharePoint Server 2019 | Treat as SPFx v1.4.1 | Legacy gulp | Current compatibility table lists Node 6 or 8, TypeScript 2.4, and React 15 |
| SharePoint Server Subscription Edition | Default to the SharePoint Server 2019-era constraints unless local validation proves more | Legacy gulp | Current official docs disagree: compatibility page lists support through v1.5, but other current docs describe SE as sharing 2019 dependencies or requirements |

### Inspection order before recommending changes

1. Check the project's `package.json` for `@microsoft/*` packages and scripts.
2. Check `.yo-rc.json` for the scaffolded SPFx version family.
3. Use the official compatibility table to confirm Node, TypeScript, and React.
4. Only then recommend upgrades, downgrades, or toolchain changes.

### Related files

- [Versioning and compatibility rule](../rules/tooling-versioning-and-compatibility.md)
- [Projects and scaffolding rule](../rules/projects-toolchain-and-scaffolding.md)
- [Toolchain and deployment map](./toolchain-deployment-map.md)
- [Host support matrix](../assets/host-support-matrix.json)

### Source anchors

- [SPFx compatibility](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/compatibility)
- [Set up your development environment](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/set-up-your-development-environment)
- [SharePoint 2019 and Subscription Edition support](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/sharepoint-2019-and-subscription-edition-support)
- [Supported extensibility platforms](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/supported-extensibility-platforms-overview)
