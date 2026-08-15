# Configuration boundary

Read this file when a request changes repository Git policy, release settings,
hook behavior, PR defaults, or worktree scan roots. The optional repository
file is `.martix-git.json`. It uses an explicit schema version and rejects
unknown versions or properties.

## Ownership

| Setting | Owner |
| --- | --- |
| Commit structure and breaking-change meaning | Conventional Commits |
| Branch grammar and Git ref validity | Conventional Branch and Git |
| Allowed types, scopes, lengths, and aliases | Repository policy |
| Draft default and base branch | Repository and workflow runtime |
| Analyzer, release rules, tag format, and release branches | Release policy |
| Hook commands and CI checks | Repository tooling and CI |
| Protected branches, scan roots, and remote evidence | Safety policy |

Configuration cannot disable retention of dirty, locked, current, protected,
detached, active, externally owned, open-PR, ambiguous, or unknown states. It
cannot enable cleanup mutation by itself, accept secrets, or silently ignore
unknown properties.

## Schema version 1

Use this as the smallest reviewable starting point:

```json
{
  "$schema": "https://raw.githubusercontent.com/MartiXDev/skills/main/plugins/martix-git-automation/schema.json",
  "schemaVersion": 1,
  "conventionalCommit": {
    "types": [],
    "scopes": [],
    "requireScope": false,
    "maxHeaderLength": null
  },
  "branch": {
    "specVersion": "1.1.0",
    "prefixes": [],
    "maxLength": null,
    "trunkBranches": []
  },
  "pullRequest": {
    "defaultDraft": true,
    "titlePolicy": "repository",
    "baseBranch": null
  },
  "release": {
    "enabled": false,
    "analyzerPreset": null,
    "tagFormat": "v${version}",
    "releaseBranches": []
  },
  "hooks": {
    "enabled": false,
    "preCommitChecks": [],
    "prePushCommand": null
  },
  "worktree": {
    "enableRemoteEvidence": false,
    "reportOnSessionStop": false,
    "protectedBranches": ["@default"],
    "scanRoots": []
  }
}
```

Empty `types` and `scopes` do not reject every value; they leave that dimension
unrestricted. `titlePolicy: "repository"` delegates PR title behavior to the
selected merge and repository policy. Release integration, remote evidence,
and session-stop reporting are disabled by default.

## Setup workflow

1. Read the existing configuration, hooks, CI, and protection evidence.
2. Validate JSON, schema version, property names, value types, paths, and
   command availability without mutation.
3. Show every file and command that would change and preserve existing hooks.
4. Ask for confirmation before writing or enabling policy.
5. Revalidate generated files and report installation, bypass, rollback, and
   uninstall behavior.

## Related files

- [branch-policy.md](../templates/branch-policy.md) is a policy scaffold.
- [martix-git.json](../templates/martix-git.json) is a starter configuration.
- [git-workflows-and-hooks.md](../rules/git-workflows-and-hooks.md) defines
  hook and CI boundaries.
