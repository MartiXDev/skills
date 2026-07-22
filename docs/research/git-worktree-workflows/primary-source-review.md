# Primary source review: Git worktree cleanup automation

<!-- markdownlint-disable MD013 MD032 MD060 -->

Date: 2026-07-22
Status: Research complete, implementation not started

> **Erratum recorded 2026-07-22**: Later local observation showed that
> archiving sessions in the Copilot app can deregister their clean worktrees,
> delete the directories or leave an empty orphan directory, and preserve the associated
> local branches. The original section 3.5 statement that no automatic cleanup
> behavior exists is retained below as part of this dated snapshot, but it is
> superseded by the branch audit and `martix-git-plugin-plan.md`. This observed
> client behavior is not treated as a documented or stable API contract.

---

## 1. Executive summary

This document reviews the existing Git worktree cleanup research in this
repository, validates its claims against primary sources, identifies gaps, and
proposes a detailed phased implementation plan. The key architectural insight is
that **remote GitHub Actions cannot remove local developer worktrees** and
therefore a layered approach is required: remote actions handle remote branch
cleanup and notifications, while a local PowerShell command handles worktree
lifecycle on the developer machine.

---

## 2. Review of existing research documents

### 2.1 Strengths

- The existing research correctly identifies the conservative-first approach.
- Protection of `main`, current branch, and locked worktrees is appropriate.
- The operational checklist provides a workable manual procedure.
- The branch audit captures a concrete repository snapshot.

### 2.2 Weaknesses and inaccuracies

| Document | Issue | Recommended fix |
|----------|-------|-----------------|
| `automation-notes.md` | Suggests `git branch --merged main` as the branch metadata collector. This only detects fast-forward or true merge commits and misses squash-merged or rebased PRs entirely. | Add note: `--merged` uses reachability only; squash/rebase merges require GitHub API or `git cherry` heuristics. |
| `automation-notes.md` | Lists `pull_request: closed` as a trigger option but does not distinguish `merged == true` from closed-without-merge. | Add conditional filter: `github.event.pull_request.merged == true`. |
| `automation-notes.md` | States the `delete` event reacts to branch deletion but does not note it only fires on the default branch and only when the workflow file exists there. | Add note per GitHub docs constraint. |
| `git-worktree-cleanup-plan.md` | No mention of squash/rebase merge detection, porcelain parsing, locked/prunable states, or the remote/local lifecycle gap. | Expand or supersede with this document's implementation plan. |
| `git-worktree-branch-audit.md` | States "worktrees attached to branches that are no longer tracking a remote branch" but does not define what "no longer tracking" means operationally. | Clarify: the remote tracking branch ref (`refs/remotes/origin/X`) is gone after `git fetch --prune`, which indicates the remote branch was deleted. |
| `operational-checklist.md` | Uses `git branch --merged main` without caveats about squash merges. | Add warning block. |
| All docs | No mention of `--porcelain -z` for machine-safe parsing, no mention of security (shell injection via branch names), no mention of TOCTOU. | Address in implementation plan. |

### 2.3 Missing coverage in existing docs

- VS Code Copilot CLI session lifecycle and worktree ownership.
- Concurrent session safety and idempotency.
- Dirty/detached worktree handling.
- Open PR detection before branch deletion.
- Security analysis for automation.
- Machine-readable output and exit codes.
- Dry-run/apply semantics.
- Integration with the existing `martix-afk-factory` plugin.

---

## 3. Primary source findings

### 3.1 Git worktree behavior (from official docs)

Source: [git-worktree(1)](https://git-scm.com/docs/git-worktree)

**Verified facts:**

1. `git worktree remove` only removes **clean** worktrees (no untracked files,
   no modifications to tracked files). Unclean worktrees require `--force`.
   Force-removing a **locked** worktree requires `--force` twice.
2. The **main worktree** cannot be removed.
3. `git worktree list --porcelain` outputs structured records. Each record
   starts with a `worktree` line followed by attributes (`HEAD`, `branch`,
   `detached`, `locked`, `prunable`). Records are separated by blank lines.
4. The `-z` flag changes the line terminator to NUL, enabling safe parsing
   when worktree paths contain newlines.
5. A **locked** worktree has a `locked` file in `$GIT_DIR/worktrees/<id>/`.
   The lock prevents pruning and removal.
6. A **prunable** worktree is one whose working tree path no longer exists on
   disk. `git worktree prune` removes the administrative metadata for these.
7. `gc.worktreePruneExpire` controls automatic pruning of stale entries.
8. Branches checked out in a linked worktree cannot be force-reset or deleted
   by `git branch -f` from another worktree.

**Porcelain output format** (key for machine parsing):

```text
worktree /path/to/worktree
HEAD <sha>
branch refs/heads/<name>
[locked [<reason>]]
[prunable <reason>]

```

A detached HEAD worktree shows `detached` instead of `branch`.

### 3.2 Git branch merge detection

Source: [git-branch(1)](https://git-scm.com/docs/git-branch)

**Verified facts:**

1. `git branch --merged <commit>` lists branches whose tips are **reachable
   from** the named commit. This uses graph reachability only.
2. Per the NOTES section: `--merged` is for finding branches that "can be
   safely deleted, since those branches are fully contained by HEAD."
3. **Critical limitation:** Squash merges and rebase merges do NOT make the
   original branch tip reachable from `main`. The original commits are
   rewritten; only the new squashed/rebased commits land on `main`. Therefore
   `git branch --merged main` will NOT list branches that were squash-merged
   or rebase-merged.
4. `git branch -d` refuses to delete a branch unless it is fully merged into
   its upstream or `HEAD`. `-D` force-deletes regardless of merge status.

**Implication for automation:** Relying solely on `--merged` will leave
squash-merged branches as false negatives. A GitHub API check (PR merged status)
or `git cherry` heuristic is required for comprehensive detection.

### 3.3 GitHub Actions event lifecycle

Source: [Events that trigger workflows](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows)

**Verified facts:**

1. `pull_request` with type `closed` fires when a PR is closed. To detect
   merge, check `github.event.pull_request.merged == true`.
2. The `pull_request` event payload is **empty for merged PRs from forks**.
3. `pull_request_target` runs in the context of the **base repository default
   branch** and does NOT check out fork code — safer for untrusted PRs.
4. The `delete` event fires when a Git ref (branch or tag) is deleted. It
   only triggers if the workflow file exists on the default branch.
5. `GITHUB_TOKEN` with `issues: write` permission is sufficient for label
   transitions in the cleanup workflow (as the existing `cleanup-merged.yml`
   demonstrates).
6. GitHub Actions run on **remote runners** — they have no access to the
   developer's local filesystem, local worktrees, or local Git state.

**The fundamental lifecycle mismatch:**

| Action | Can be done remotely (GitHub Actions) | Requires local execution |
|--------|--------------------------------------|--------------------------|
| Delete remote branch after merge | Yes (via API or repo setting) | No |
| Close/label GitHub issue | Yes | No |
| Remove local worktree directory | **No** | Yes |
| Delete local branch ref | **No** | Yes |
| Notify developer of cleanup opportunity | Yes (issue comment, webhook) | No |

### 3.4 GitHub automatic branch deletion

Source: [GitHub repository settings — branch deletion](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-the-automatic-deletion-of-head-branches)

**Verified fact:** GitHub has a repository setting "Automatically delete head
branches" which deletes the remote branch ref when a PR is merged. This is the
recommended way to handle remote branch cleanup. When enabled, after a PR merge:
- The remote branch is deleted by GitHub.
- `git fetch --prune` on the local machine will remove the stale
  remote-tracking ref.
- The **local** branch still exists and must be cleaned up locally.

### 3.5 VS Code Copilot CLI session and worktree lifecycle

**Repository observations** (from `plugins/martix-afk-factory`):

1. The `start-afk-sessions.ps1` script creates worktrees at
   `.worktrees/<issue-number>` with branch `fix/issue-<N>`.
2. Sessions are tracked in `.worktrees/sessions.json`.
3. VS Code is opened at the worktree path via `Start-Process 'code'`.
4. **No cleanup logic exists** — there is no session teardown, no worktree
   removal after PR merge, and no stale session detection.

**VS Code behavior (observable, not officially documented for Copilot CLI):**

- When VS Code's "Agents Window" opens a folder backed by a git worktree, the
  session uses that worktree's branch context.
- Closing the VS Code window does NOT remove the worktree.
- If the worktree directory is deleted externally while VS Code is open, VS Code
  shows "folder does not exist" errors.
- There is no documented VS Code API or Copilot CLI hook for "session ended"
  that would trigger automatic worktree cleanup.

**Unknown / preview behavior:**
- Whether future Copilot CLI versions will provide a `postSessionEnd` hook.
- Whether the cloud agent tasks API provides a webhook on task completion that
  could trigger local cleanup.
- Shared session behavior when multiple VS Code windows point to the same
  worktree.

### 3.6 GitHub CLI (`gh`) branch and PR operations

Source: [GitHub CLI manual](https://cli.github.com/manual/)

**Relevant capabilities:**

- `gh pr list --state merged --head <branch>` — check if a branch has a merged
  PR (useful for squash-merge detection).
- `gh pr view <number> --json mergedAt,headRefName` — confirm merge status.
- `gh api repos/{owner}/{repo}/branches` — list remote branches.

---

## 4. Security and safety analysis

### 4.1 Shell injection via branch names

Git branch names can contain characters dangerous to shells: spaces, quotes,
backticks, `$()`, semicolons. Branch names from issue titles or user input
(as in `fix/issue-<N>`) are safe only if `<N>` is validated as numeric.

**Mitigations:**
- Always quote variables in PowerShell (`"$branch"`).
- Use `--porcelain -z` with NUL-terminated parsing.
- Validate branch names against `git check-ref-format` rules.
- Never interpolate branch names into shell strings without validation.

### 4.2 `pull_request` vs `pull_request_target`

The existing `cleanup-merged.yml` uses `pull_request: closed` which is safe
because it only transitions issue labels — it does not check out code. If the
workflow ever needs to run code from the PR branch, use `pull_request_target`
with explicit checkout protections per
[GitHub security guidance](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows#pull_request_target).

### 4.3 Token permissions

The `cleanup-merged.yml` correctly uses `permissions: issues: write` with the
default `GITHUB_TOKEN`. This follows least-privilege. The `dispatch-agent.yml`
requires a user PAT (`copilot` scope) stored as a secret — this is riskier and
should have a short expiry with rotation.

### 4.4 TOCTOU (Time-of-check-to-time-of-use)

Between checking that a worktree is clean and removing it, a concurrent process
could modify files. Mitigation: use `git worktree remove` directly, which
performs its own atomic check. Do not separate "check clean" from "remove" into
two steps.

### 4.5 Symlinks and path containment

Worktree paths should be validated to be inside the expected root
(`.worktrees/` or a configured base). A symlink attack could point a worktree
path outside the repository. Mitigation: resolve paths with
`[System.IO.Path]::GetFullPath()` and verify prefix containment.

### 4.6 Force removal risks

`git worktree remove --force` discards uncommitted work silently. The script
must NEVER force-remove unless the user explicitly opts in with a parameter.

### 4.7 Concurrent sessions

Multiple `start-afk-sessions.ps1` invocations could race on
`.worktrees/sessions.json`. Mitigation: use file locking or atomic
write-via-rename pattern.

### 4.8 Idempotency

Running cleanup twice should be safe. A worktree that was already removed
should not cause errors. Use `Test-Path` and `git worktree list` as the source
of truth, not just `sessions.json`.

---

## 5. Implementation options comparison

### Option A: Repo-local PowerShell command

| Aspect | Assessment |
|--------|-----------|
| Scope | Local worktrees + local branches |
| Trigger | Manual invocation or post-session hook |
| Capabilities | Full access to local filesystem and Git state |
| Limitations | Cannot react to remote events in real-time |
| Complexity | Low — single script |
| Safety | High — user controls invocation |

### Option B: Copilot/VS Code lifecycle hook

| Aspect | Assessment |
|--------|-----------|
| Scope | Cleanup triggered by session end |
| Trigger | `postSessionEnd` hook (does not exist today) |
| Capabilities | Same as Option A when it runs |
| Limitations | Depends on unshipped/preview Copilot CLI feature |
| Complexity | Medium — requires hook registration |
| Safety | Medium — automatic cleanup may surprise users |

### Option C: GitHub Actions / remote notification

| Aspect | Assessment |
|--------|-----------|
| Scope | Remote branch deletion + notification only |
| Trigger | `pull_request: closed` + `merged == true` |
| Capabilities | Delete remote branch, label issue, post comment |
| Limitations | CANNOT touch local worktrees or branches |
| Complexity | Low — already partially implemented |
| Safety | High for remote-only actions |

### Recommended layered architecture

```text
Layer 3: GitHub Actions (remote)
  - cleanup-merged.yml: label transition, issue close (EXISTS)
  - Repository setting: auto-delete head branches (CONFIGURE)
  - Optional: post comment listing local cleanup command

Layer 2: Post-session hook (future, optional)
  - If/when Copilot CLI provides postSessionEnd
  - Invoke Layer 1 script automatically

Layer 1: Local PowerShell command (PRIMARY — TO BUILD)
  - Cleanup-Worktrees.ps1 with dry-run/apply modes
  - Integrates with sessions.json
  - Handles all local worktree and branch cleanup
  - Invocable manually or by Layer 2
```

### What should NOT be automated

1. Removal of **locked** worktrees — always require explicit human intent.
2. Deletion of branches with **open PRs** — may have ongoing review.
3. Force-removal of **dirty** worktrees — uncommitted work would be lost.
4. Deletion of the **current branch** or worktree the user is working in.
5. Any action on worktrees outside the configured root directory.

---

## 6. Detailed implementation plan

### Phase 1: Local cleanup command (Cleanup-Worktrees.ps1)

**Location:** `plugins/martix-git/hooks/Cleanup-Worktrees.ps1`
(also symlinked/copied to `scripts/` for standalone use)

#### 6.1 Parameters

```powershell
[CmdletBinding(SupportsShouldProcess)]
param(
  [switch]$DryRun,           # Report only, do not remove anything
  [switch]$Apply,            # Actually perform removals (must be explicit)
  [switch]$IncludeNonSession, # Also clean worktrees not tracked in sessions.json
  [switch]$Force,            # Allow removal of dirty worktrees (with warning)
  [string]$WorktreeRoot,     # Override .worktrees/ root path
  [string]$SessionsFile,     # Override sessions.json path
  [int]$StaleDays = 7        # Consider worktrees stale after N days without commits
)
```

#### 6.2 Worktree classification states

| State | Definition | Action |
|-------|-----------|--------|
| `protected` | Main worktree or current branch's worktree | Skip always |
| `locked` | Has `locked` attribute in porcelain output | Skip always (report) |
| `prunable` | Has `prunable` attribute (path missing) | `git worktree prune` |
| `merged-clean` | Branch merged into main AND worktree is clean | Remove (dry-run/apply) |
| `merged-dirty` | Branch merged but worktree has modifications | Warn, skip (or force) |
| `orphaned` | Remote tracking branch gone, no open PR, clean | Candidate for removal |
| `active` | Has recent commits or open PR | Skip (report) |
| `detached` | Worktree in detached HEAD state | Warn, candidate if stale |

#### 6.3 Decision table

```text
                    Merged?  Clean?  Locked?  Open PR?  Remote exists?  --> Action
merged-clean         yes      yes     no       no        irrelevant      REMOVE
merged-dirty         yes      no      no       no        irrelevant      WARN (force: REMOVE)
orphaned-clean       no       yes     no       no        no              REMOVE (if stale)
orphaned-dirty       no       no      no       no        no              WARN
active-pr            -        -       no       YES       -               SKIP
locked               -        -       YES      -         -               SKIP
protected            -        -       -        -         -               SKIP
detached-stale       -        yes     no       no        -               REMOVE (if stale)
detached-dirty       -        no      no       no        -               WARN
```

#### 6.4 Merge detection strategy

1. **Primary:** `git branch --merged main` (catches true merge commits).
2. **Secondary:** `gh pr list --state merged --head <branch> --json number`
   (catches squash and rebase merges via GitHub API).
3. **Fallback:** If `gh` is unavailable, log a warning that squash-merge
   detection is degraded.

#### 6.5 Output format

**Human-readable (default):**

```text
Worktree cleanup report (DRY RUN)
==================================

REMOVE (merged-clean):
  .worktrees/42  branch=fix/issue-42  merged=2026-07-20

WARN (merged-dirty):
  .worktrees/55  branch=fix/issue-55  modified files: 2

SKIP (active):
  .worktrees/60  branch=fix/issue-60  open PR #60

SKIP (locked):
  .worktrees/99  branch=fix/issue-99  reason: portable device

Summary: 1 to remove, 1 dirty, 2 skipped
```

**Machine-readable (`-OutputFormat Json`):**

```json
{
  "mode": "dry-run",
  "timestamp": "2026-07-22T10:30:00Z",
  "worktrees": [
    {
      "path": ".worktrees/42",
      "branch": "fix/issue-42",
      "state": "merged-clean",
      "action": "remove"
    }
  ],
  "summary": { "remove": 1, "warn": 1, "skip": 2 }
}
```

#### 6.6 Exit codes

| Code | Meaning |
|------|---------|
| 0 | Success — all requested actions completed (or dry-run report generated) |
| 1 | Error — script failure (config missing, git error) |
| 2 | Partial — some removals failed (e.g., concurrent modification) |
| 3 | Nothing to do — no candidates found |

#### 6.7 Porcelain parsing implementation

```powershell
function Get-WorktreeList {
  $raw = git worktree list --porcelain -z 2>&1
  if ($LASTEXITCODE -ne 0) { throw "git worktree list failed" }

  # Split on double-NUL (record separator in -z mode)
  $records = $raw -split "`0`0" | Where-Object { $_.Trim() }

  foreach ($record in $records) {
    $lines = $record -split "`0" | Where-Object { $_ }
    $wt = [ordered]@{}
    foreach ($line in $lines) {
      if ($line -match '^worktree (.+)$') { $wt.Path = $Matches[1] }
      elseif ($line -match '^HEAD (.+)$') { $wt.HEAD = $Matches[1] }
      elseif ($line -match '^branch (.+)$') { $wt.Branch = $Matches[1] }
      elseif ($line -eq 'detached') { $wt.Detached = $true }
      elseif ($line -match '^locked(.*)$') { $wt.Locked = $true; $wt.LockReason = $Matches[1].Trim() }
      elseif ($line -match '^prunable(.*)$') { $wt.Prunable = $true; $wt.PrunableReason = $Matches[1].Trim() }
      elseif ($line -eq 'bare') { $wt.Bare = $true }
    }
    [PSCustomObject]$wt
  }
}
```

#### 6.8 sessions.json integration

After successful removal, update `.worktrees/sessions.json`:
- Remove the entry for the cleaned worktree.
- Add a `cleanedAt` timestamp to a separate `history` array (optional,
  for observability).

### Phase 2: Remote notification enhancement

**Location:** `plugins/martix-afk-factory/workflows/cleanup-merged.yml`

Add a step that posts a comment on the closed issue with the local cleanup
command:

```yaml
- name: Suggest local cleanup
  uses: actions/github-script@v7
  with:
    script: |
      await github.rest.issues.createComment({
        owner: context.repo.owner,
        repo: context.repo.repo,
        issue_number: issueNumber,
        body: [
          '**Local cleanup available.** Run:',
          '```powershell',
          '.\\hooks\\Cleanup-Worktrees.ps1 -DryRun',
          '.\\hooks\\Cleanup-Worktrees.ps1 -Apply',
          '```'
        ].join('\n')
      });
```

### Phase 3: Post-session hook integration (future)

If/when Copilot CLI ships a `postSessionEnd` hook:

```json
{
  "version": 1,
  "hooks": {
    "postSessionEnd": [
      {
        "type": "command",
        "powershell": "powershell -ExecutionPolicy Bypass -File hooks/Cleanup-Worktrees.ps1 -DryRun",
        "timeoutSec": 30
      }
    ]
  }
}
```

This would run in dry-run mode by default, printing candidates without removing
them, giving the developer visibility without risk.

---

## 7. Proposed file paths

| File | Purpose |
|------|---------|
| `plugins/martix-git/hooks/Cleanup-Worktrees.ps1` | Primary cleanup script |
| `plugins/martix-git/hooks/Cleanup-Worktrees.Tests.ps1` | Pester unit tests |
| `scripts/Cleanup-Worktrees.ps1` | Thin wrapper or symlink for repo-root access |
| `docs/research/git-worktree-workflows/primary-source-review.md` | This document |

---

## 8. Tests and fixtures

### 8.1 Unit test scenarios (Pester)

1. **Parse porcelain output** — mock `git worktree list --porcelain -z` with
   known output containing locked, prunable, detached, and normal entries.
2. **Classification logic** — given a worktree object + merge status + PR
   status, verify correct state assignment.
3. **Protection rules** — verify main worktree and current branch are always
   protected regardless of other signals.
4. **Dry-run mode** — verify no `git worktree remove` calls are made.
5. **Apply mode** — verify correct `git worktree remove` calls with expected
   arguments.
6. **sessions.json update** — verify entry removal after successful cleanup.
7. **Branch name validation** — verify rejection of malformed branch names.
8. **Force mode** — verify dirty worktree removal only when `-Force` is set.
9. **Concurrent safety** — verify graceful handling when worktree disappears
   between list and remove.
10. **Exit codes** — verify correct codes for each scenario.

### 8.2 Fixture data

Create `tests/fixtures/worktree-porcelain/` with sample porcelain outputs:
- `normal.txt` — two clean merged worktrees
- `locked.txt` — one locked worktree
- `dirty.txt` — one worktree with modifications
- `detached.txt` — one detached HEAD worktree
- `mixed.txt` — combination of all states

---

## 9. Observability and rollout

### 9.1 Observability

- All actions logged to stdout with timestamps.
- Machine-readable JSON output for pipeline integration.
- Exit codes enable scripted health checks.
- Optional `--Verbose` flag for detailed decision reasoning.

### 9.2 Rollout gates

| Gate | Criteria |
|------|----------|
| 1. Script authored | Passes Pester tests, handles all classification states |
| 2. Manual validation | Author runs `-DryRun` on real repository, reviews output |
| 3. Documentation | Operational checklist updated, README updated |
| 4. Integration | Remote workflow posts cleanup suggestion |
| 5. Hook integration | Only after Copilot CLI hook exists and is tested |

### 9.3 Acceptance criteria

- [ ] `Cleanup-Worktrees.ps1 -DryRun` lists all worktrees with correct states.
- [ ] `Cleanup-Worktrees.ps1 -Apply` removes only `merged-clean` worktrees.
- [ ] Locked, dirty, current-branch, and main worktrees are never removed.
- [ ] Squash-merged branches are detected via `gh` API when available.
- [ ] `sessions.json` is updated atomically after removal.
- [ ] Exit codes match specification.
- [ ] No shell injection possible via branch names.
- [ ] Pester tests pass with 100% scenario coverage.
- [ ] Works on Windows (PowerShell 7+) and optionally PowerShell 5.1.

---

## 10. Confidence classification

| Category | Items |
|----------|-------|
| **Verified facts** | Git worktree porcelain format, `--merged` reachability semantics, GitHub Actions `pull_request` closed event, `GITHUB_TOKEN` permissions, auto-delete head branches setting, `git branch -d` merge check |
| **Repository observations** | `start-afk-sessions.ps1` creates worktrees without cleanup path, `cleanup-merged.yml` handles issue labels only, no local cleanup script exists, sessions.json has no teardown logic |
| **Recommendations** | Layered architecture, PowerShell-first local command, squash-merge detection via `gh`, NUL-terminated parsing, explicit `-Apply` flag |
| **Unknowns / preview behavior** | Copilot CLI `postSessionEnd` hook (not shipped), cloud agent task completion webhook, VS Code session lifecycle for shared worktrees, future `hooks.json` schema changes |

---

## 11. Sources

### Git official documentation

- [git-worktree(1)](https://git-scm.com/docs/git-worktree) — worktree
  commands, porcelain format, lock/prune/remove semantics
- [git-branch(1)](https://git-scm.com/docs/git-branch) — `--merged`
  reachability semantics, `-d` safety check
- [git-check-ref-format(1)](https://git-scm.com/docs/git-check-ref-format) —
  valid branch name characters

### GitHub official documentation

- [Events that trigger workflows — pull_request](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows#pull_request) —
  `closed` type, `merged == true` conditional, fork behavior
- [Events that trigger workflows — pull_request_target](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows#pull_request_target) —
  security model, base branch context
- [Events that trigger workflows — delete](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows#delete) —
  fires only when workflow file exists on default branch
- [Managing automatic deletion of head branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-the-automatic-deletion-of-head-branches) —
  repository setting for remote branch cleanup
- [GitHub CLI manual](https://cli.github.com/manual/) — `gh pr list`, `gh pr
  view` for merge status queries
- [GITHUB_TOKEN permissions](https://docs.github.com/en/actions/security-for-github-actions/security-guides/automatic-token-authentication) —
  scope limitations

### Repository artifacts (observed, not upstream)

- `plugins/martix-afk-factory/hooks/start-afk-sessions.ps1` — worktree
  creation logic, sessions.json format
- `plugins/martix-afk-factory/workflows/cleanup-merged.yml` — PR-close label
  transition
- `docs/parallel-worktree-guidance.md` — worktree rules and coordinator
  ownership model
- `docs/research/git-worktree-workflows/` — existing research documents under
  review
