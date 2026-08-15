# Branch policy template

Use this scaffold for repository policy, not as a replacement for the pinned
Conventional Branch specification or Git ref validation.

```yaml
specVersion: "1.1.0"
trunkBranches:
  - main
prefixes:
  - feature
  - bugfix
  - hotfix
  - chore
aliases: {}
description:
  lowercase: true
  maxLength: null
  issuePattern: null
```

## Policy decisions

- Which branch is the default trunk?
- Which prefixes are allowed for this repository?
- Are aliases such as `feat` and `fix` accepted?
- Are issue identifiers required, optional, or forbidden?
- What description normalization is visible and reversible?
- Which branches are protected from creation, switching, or deletion?

Validate the resulting candidate with the pinned policy and
`git check-ref-format --branch` before mutation. See
[conventional-branches.md](../rules/conventional-branches.md).
