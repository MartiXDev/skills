# Git worktree workflows

This folder collects notes and guidance for managing Git worktrees and related
branch hygiene in this repository.

## What belongs here

- Worktree inventory and audit notes
- Cleanup plans, policies, and operator guidance
- Notes about Copilot/VS Code agent worktree behavior
- Safe automation design for branch and worktree cleanup
- Git and GitHub developer-workflow plugin research

## Current documents

- [Branch audit](./git-worktree-branch-audit.md)
- [Cleanup automation plan](./git-worktree-cleanup-plan.md)
- [Operational checklist](./operational-checklist.md)
- [Automation notes](./automation-notes.md)
- [Primary-source review](./primary-source-review.md)
- [Sandcastle-aligned plugin plan](./sandcastle-aligned-plugin-plan.md)
- [MartiX Git plugin plan](./martix-git-plugin-plan.md)

The MartiX Git plugin plan is the current implementation direction. It absorbs
the safe worktree-maintenance capability into a broader but bounded Git and
GitHub workflow plugin. Earlier plans remain as research history and may
describe the retiring `martix-afk-factory` architecture.

The branch audit also records an observed Copilot app lifecycle transition:
archiving sessions may deregister their clean worktrees, remove the directories
or leave an empty orphan, and preserve the local branches. The current plugin
plan treats this as external cleanup to reconcile, not as a stable ownership
API or permission to delete a branch.
