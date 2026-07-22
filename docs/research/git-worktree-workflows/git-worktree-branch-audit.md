# Git worktree and branch audit

## Current snapshot

This audit was taken from the repository state on 2026-07-22.

- Current branch: `main`
- `main` and `origin/main`: `5182241`
- Worktrees currently attached: 4
- Local branches present: 12, including `main`
- Clean worktrees: 1
- Dirty worktrees: 3, including the main worktree with this audit update
- Local branch tips contained directly in `main`, excluding `main`:
  - `codex/review-dotnet-csharp-docs`
  - `martinmikes-improved-goggles`
  - `martinmikes-research-doc-drift-2026`

All non-main branches associated with pull requests have merged pull requests.
Several tips are not direct ancestors of `main` because GitHub used squash
merges or because review commits remained only on the source branch. Treat the
merged pull request as lifecycle evidence rather than relying only on ancestor
checks.

The local tips for five completed branches exactly match their merged pull
request heads. The local Git research, AFK Factory, and TypeScript tips are
earlier commits already included in their respective merged pull requests; the
remote pull request heads advanced before merge. The planning branch contains
the later Git research commit that was subsequently merged through PR #56. No
reviewed branch has a local post-merge commit requiring preservation.

## Changes observed after Copilot session archival

After several sessions were archived in the Copilot app, four previously clean
Copilot worktrees disappeared from `git worktree list --porcelain`. The timing
is consistent with background cleanup by the app, but local Git state does not
record which process performed the removal.

- `martinmikes-friendly-doodle`: registration and directory removed
- `martinmikes-glowing-lamp`: registration and directory removed
- `martinmikes-upgraded-barnacle`: registration and directory removed
- `martinmikes-sturdy-winner`: registration and Git metadata removed; an empty
  directory remains at the old path

The associated local branches remain present, and all five Copilot-associated
branch tips, including the still-attached `martinmikes-improved-goggles`, are
unchanged from the earlier audit. The app did not automatically delete local
branches. Both dirty Codex worktrees and their files also remain intact. Git
reports no stale registered worktree metadata eligible for `git worktree
prune`.

## Attached worktrees

### Protected

- `C:/Git/MartiXDev/skills`
  - Branch: `main`
  - State: synchronized with `origin/main`; this audit file is modified
  - Action: keep

### Clean cleanup candidates

- `C:/Git/copilot-worktrees/skills/martinmikes-improved-goggles`
  - Branch: `martinmikes-improved-goggles`
  - Evidence: tip is contained directly in `main`

Remove this clean worktree through its owning tool when practical, then delete
the corresponding local branch.

### Blocked by uncommitted work

- `C:/Users/marti/.codex/worktrees/3617/skills`
  - Branch: `codex/review-dotnet-csharp-docs`
  - State: 15 modified and 3 untracked files
  - Evidence: branch tip is contained directly in `main`
  - Action: review, commit, move, or discard the 18 working-tree changes before
    removing the worktree
- `C:/Users/marti/.codex/worktrees/a00b/skills`
  - Branch: detached at `fb564a1`
  - State: 1 untracked file, `docs/skill-evals-quality-research.md`
  - Evidence: detached commit is retained by `main`
  - Action: preserve or discard the untracked file before removing the
    worktree

## Unattached local branches

These branches have no attached worktree. Their pull request histories account
for their local commits, so they are cleanup candidates:

- `chore/skill-planning-and-template-updates`
  - PR #38 merged; its later Git research content merged through PR #56
- `docs/git-workflow-research`
  - PR #56 merged
- `feat/add-essl-and-imported-skills`
  - PR #11 merged
- `feat/martix-afk-factory`
  - PR #10 merged and the package was later retired
- `fluent-ui-css-first`
  - PR #37 merged; Copilot removed its worktree after session archival
- `martinmikes-create-typescript-skill`
  - PR #35 merged; Copilot removed its worktree after session archival
- `martinmikes-research-fluent-ui-skill`
  - PR #36 merged
- `martinmikes-research-doc-drift-2026`
  - PR #55 merged; Copilot removed its worktree after session archival
- `martinmikes-setup-matt-pocock-skills-config`
  - PR #23 merged; Copilot removed its worktree after session archival

## Worktree findings

- The main working tree is current and protected from cleanup; its only change
  is this audit update.
- No non-main local branch currently has a confirmed live remote branch. Some
  stale remote-tracking refs remain locally and are eligible for pruning.
- One clean Copilot worktree remains and can be reviewed for owner-driven
  removal.
- Four archived Copilot sessions no longer have registered worktrees, but their
  local branches remain available for explicit cleanup.
- The old `martinmikes-sturdy-winner` path is now an empty orphan directory and
  can be removed separately from Git cleanup.
- Both Codex worktrees must be preserved until their uncommitted files are
  handled.
- The detached Codex commit itself is not at risk because `main` contains it;
  only its untracked file requires preservation.

## Cleanup priorities

1. Preserve or intentionally discard changes in both dirty Codex worktrees.
2. Remove the one remaining clean completed Copilot worktree through its owning
  tool.
3. Delete unattached completed branches.
4. Delete branches from removed worktrees only after the worktrees are closed.
5. Remove the empty orphan `martinmikes-sturdy-winner` directory after a final
  emptiness check.
6. Prune stale remote-tracking refs with `git remote prune origin --dry-run`
   followed by `git remote prune origin` after review.
7. Keep `main` protected and use dry-run mode before destructive automation.
