# MX configuration guide

This guide explains how to configure the native `mx-*` lifecycle in a product
repository. The central file is:

```text
.github/martix/mx.config.json
```

The normative structure and enum values are defined by
[mx-config.schema.json](../architecture/mx-config.schema.json). The complete
lifecycle design is in the
[AI-assisted software delivery lifecycle](../architecture/ai-software-delivery-lifecycle.md).

## Configuration ownership

Only `.github/martix/mx.config.json` is edited as repository-wide MX
configuration. The installed MX package owns defaults, workflow contracts,
validators, and the schema. `mx-setup` generates these read-only files:

```text
.github/martix/
  mx.config.json
  mx-config.schema.json
  generated/
    resolved.json
    workflows.json
    evidence.json
```

Do not create separate configuration files inside individual `mx-*` skills,
prompts, agents, or hooks. An artifact may have metadata and templates, but it
must resolve behavior from the central file.

## Resolution order

Effective configuration is calculated in this order:

1. MX package defaults.
2. The selected `preset`.
3. Repository overrides in `mx.config.json`.
4. A non-persistent command-line override for one run.
5. Issue or specification values for work-item scope only.

Repository values may make behavior stricter or narrower. They cannot disable
required evidence, remove a human gate, grant secrets, or create a second issue
transition system. The resolved configuration receives a hash that is recorded
in workflow evidence and continuation handoffs.

## Required top-level sections

The schema requires these sections:

| Section | Purpose |
| --- | --- |
| `$schema` | Editor validation reference. |
| `schemaVersion`, `configVersion` | Compatibility and revisions. |
| `preset` | Starting defaults profile. |
| `repository` | Owner, repository, default branch, and autonomy mode. |
| `stack` | Backend, frontend, and optional MartiX.Platform profile. |
| `issueTracking` | GitHub issue types, label prefixes, and defaults. |
| `workflow` | Global limits, invocation, TDD, domain modeling, and gates. |
| `workflows` | Narrow overrides for individual `mx-*` features. |
| `naming` | Branch, symbol, commit, and namespace conventions. |
| `commands` | Named deterministic executables and argument arrays. |
| `templates` | Prompt, issue, ADR, commit, PR, and handoff paths. |
| `documentation` | Canonical topic roots and freshness command. |
| `quality` | Test, accessibility, security, compatibility, and docs gates. |
| `orchestration` | Worktrees, retries, and context-pack limits. |
| `hooks` | Preflight, completion, and timeout behavior. |
| `security` | Forbidden paths, capability limits, and evidence redaction. |

`agents` and `release` are optional sections for repositories that need
per-workflow model routing or a separate release profile.

## Allowed values

The schema is authoritative. The following values are the current supported
vocabulary.

### Presets and repository policy

| Property | Allowed values |
| --- | --- |
| `preset` | See the preset list below. |
| `repository.autonomy` | `human-gated`, `bounded-autonomy`, `fully-automated` |
| `stack.backend.architecture` | See architecture values below. |
| `stack.backend.sliceStyle` | `vertical`, `layered`, `hybrid` |

Preset values:

```text
dotnet-react-fluent-ui
dotnet-vue-fluent-ui
dotnet-react-platform
dotnet-vue-platform
existing-repository
custom
```

`modular-monolith` plus `vertical` is the MartiX default. Choosing another
architecture requires an architecture decision and may select different
skills, templates, and gates.

### Technology profile

| Property | Allowed values |
| --- | --- |
| `stack.backend.language` | `csharp` |
| `stack.backend.runtime` | `dotnet` |
| `stack.frontend.framework` | `react`, `vue`, `none` |
| `stack.frontend.language` | `typescript`, `javascript` |
| `stack.frontend.ui` | `fluent-ui`, `none`, `other` |
| `stack.frontend.buildTool` | `vite`, `webpack`, `next`, `nuxt`, `custom` |
| `stack.platform.enabled` | `true`, `false` |

When `framework` is `react`, the resolver loads React-specific rules and
component templates. When it is `vue`, it loads Vue-specific rules and
templates. The same `mx-*` workflow remains responsible for lifecycle state;
`martix-*` skills provide stack-specific implementation guidance.

### Issue types and labels

The required native GitHub issue types are exactly:

```text
Task, Bug, Feature
```

Optional native types are:

```text
Epic, Spike, Incident, Chore
```

`issueTracking.issueTypes.source` is either `github-native` or
`label-fallback`. The fallback is only for repositories that cannot use native
issue types and must never run alongside them.

The default priority is one of `priority:p0`, `priority:p1`, `priority:p2`, or
`priority:p3`. The default state and phase must use these lifecycle values:

| Kind | Allowed values |
| --- | --- |
| State | See the state list below. |
| Phase | See the phase list below. |

State values:

```text
needs-triage, needs-info, shaping, ready-for-architecture,
ready-for-spec, ready-for-decomposition, ready-for-agent, in-progress,
in-review, ready-for-human, ready-for-release, deploying,
verifying-release, monitoring, released, resolved, blocked, wontfix
```

Phase values:

```text
phase:setup, phase:intake, phase:shaping, phase:architecture,
phase:specification, phase:decomposition, phase:implementation,
phase:review, phase:release, phase:operations, phase:documentation
```

Prefix values such as `phase:` and `area:` may be changed only when the
repository can provision and validate the resulting labels. State and phase
semantics do not change with a prefix.

### Workflow policy

| Property | Allowed values or range |
| --- | --- |
| `workflow.questionLimit` | Integer from `1` to `3`; `1` is the default. |
| `workflow.defaultModelTier` | `cheap`, `medium`, `premium`. |
| `workflow.invocation.*` | `user`, `model`, `user-or-model`. |
| `workflow.structuredOutput.format` | `json`. |
| `workflow.tdd.testFirst` | `always`, `when-practical`, `disabled`. |
| `workflow.domainModeling.mode` | `always`, `complexity-gated`, `never`. |
| `workflow.domainModeling.requiredFor` | See trigger list. |
| `workflow.humanGates.*` | Boolean; security and release default to `true`. |

Domain-model triggers:

```text
multiple-invariants, cross-module-boundary, external-integration,
complex-data-model, security-critical
```

The schema limits `maxParallelAgents` to 1-32 and requires context budgets to
remain within safe bounds. A repository may lower these limits.

### Naming and templates

Commit styles are `conventional`, `gitmoji`, or `plain`. Symbol naming styles
are `PascalCase`, `camelCase`, `kebab-case`, `snake_case`,
`SCREAMING_SNAKE_CASE`, and `dot.case`.

Template paths must be repository-relative. Prompt arguments are restricted to:

```text
issue, workflow, configHash, ownedPaths, acceptanceCriteria, commands,
diff, fixedPoint, qualityProfiles, checkpoint, owner, nextStep, parentSpec,
decisions, contextPack, branch, type, scope, summary, number, slug
```

Unknown template variables are rejected. Templates must not execute code,
contain credentials, read arbitrary paths, or silently add issue labels.

### Quality and orchestration

| Property | Allowed values |
| --- | --- |
| `quality.backendTestRunner` | `tunit`, `xunit`, `nunit`, `custom` |
| `quality.frontendTestRunner` | `vitest`, `jest`, `custom`, `none` |
| `quality.e2eRunner` | `playwright`, `cypress`, `custom`, `none` |
| `quality.accessibility` | See accessibility values below. |
| `quality.securityReview` | `required`, `human-gated`, `optional`, `disabled` |
| `quality.apiCompatibility` | `required`, `optional`, `disabled` |
| `quality.docsFreshness` | `required`, `optional`, `disabled` |
| `orchestration.worktreeStrategy` | See the worktree strategy list below. |

Worktree strategies:

```text
one-per-task
shared-branch
integration-branch-per-feature
no-worktree
```

Architecture values:

```text
modular-monolith
monolith
microservices
```

Accessibility values:

```text
required
required-for-ui
optional
disabled
```

`maxRetries` is limited to 0-5. Context packs must declare maximum files and
tokens, include only named evidence categories, and exclude secrets,
generated full documents, and dependency/build folders.

### Release and hooks

Environment values are `local`, `development`, `staging`, and `production`.
Rollback values are `required`, `recommended`, and `not-applicable`.
Command references in `documentation.buildCommand`,
`hooks.preflightCommand`, `hooks.completionCommand`, and workflow overrides
must match keys in `commands`.

## Cross-field validation

JSON Schema validates shape and enums. `mx-setup` performs the checks that
require repository or GitHub state:

- `github-native` issue types must be present and selectable; `Task`, `Bug`, and
  `Feature` cannot be replaced by labels.
- `stack.frontend.framework` must match installed package manifests and route
  to the correct React or Vue skill.
- `stack.platform.enabled: true` requires verified Platform packages,
  `martix.platform.json`, and current-versus-target evidence.
- Every command reference must exist, use an approved executable, and stay
  inside the repository policy.
- Every template path must exist or be explicitly marked for setup creation.
- Default labels must exist after provisioning; state and phase labels remain
  mutually exclusive.
- `workflow.invocation` cannot grant issue-write, merge, deploy, or secret
  permissions.
- `security.allowProductionDeploy: true` requires organization approval,
  environment protection, and a release human gate.
- Generated manifests must be reproducible from the same config, preset
  version, and plugin version.

Cross-field failures stop setup and return a `needs-info`, `blocked`, or
`ready-for-human` continuation instead of silently using a fallback.

## Changing configuration

1. Run `mx-setup --configure`.
2. Edit only `.github/martix/mx.config.json`.
3. Validate JSON and the schema.
4. Review the effective configuration diff and affected workflows.
5. Approve security, architecture, autonomy, transition, or release changes at
   the configured human gate.
6. Regenerate `.github/martix/generated/`.
7. Run the example lifecycle and deterministic repository checks.
8. Commit the configuration, schema version, generated evidence, and any
   directly affected templates together.

Do not edit `generated/resolved.json`, `generated/workflows.json`, or
`generated/evidence.json` manually. If a setting is not represented in the
schema, create a versioned schema change and update the guide before using it.
