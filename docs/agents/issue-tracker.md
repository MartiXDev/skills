# Issue tracker: GitHub

Issues and PRDs for this repo live as GitHub issues. Use the `gh` CLI for all
operations.

## Conventions

- **Create an issue**:
  `gh issue create --title "..." --body-file <path>`.
- **Read an issue**: `gh issue view <number> --comments` includes labels. For
  structured data:
  `gh issue view <number> --json labels,comments`.
- **List issues**:
  `gh issue list --state open --json number,title,body,labels,commentsCount`.
  Use `gh issue view <n> --json comments` when comment bodies are required.
- **Comment on an issue**:
  `gh issue comment <number> --body "..."`.
- **Apply or remove labels**:
  `gh issue edit <number> --add-label "..."` or `--remove-label "..."`.
- **Close**: `gh issue close <number> --comment "..."`.

Infer the repo from `git remote -v`; `gh` does this automatically inside a
clone.

## Pull requests as a triage surface

**PRs as a request surface: no.** Set this to `yes` only if the repository
treats external PRs as feature requests; `/triage` reads this flag.

When set to `yes`, PRs use the same labels and states as issues through the
`gh pr` equivalents:

- **Read a PR**: use `gh pr view <number> --comments` and
  `gh pr diff <number>`.
- **List external PRs for triage**:
  `gh pr list --state open --json number,title,body,labels,author,authorAssociation,comments`.
  Keep `CONTRIBUTOR`, `FIRST_TIME_CONTRIBUTOR`, and `NONE`; exclude `OWNER`,
  `MEMBER`, and `COLLABORATOR`.
- **Comment, label, or close**: use `gh pr comment`, `gh pr edit`, or
  `gh pr close`.

GitHub shares one number space across issues and PRs. Resolve a bare `#42` with
`gh pr view 42`, then fall back to `gh issue view 42`.

## When a skill says "publish to the issue tracker"

Create a GitHub issue.

## When a skill says "fetch the relevant ticket"

Run `gh issue view <number> --comments`.

## Wayfinding operations

Used by `/wayfinder`. The **map** is one issue whose **child** issues are
tickets.

- **Map**: one issue labelled `wayfinder:map`, holding the Notes,
  Decisions-so-far, and Fog sections.
  `gh issue create --label wayfinder:map`.
- **Child ticket**: an issue linked to the map as a GitHub sub-issue. If
  sub-issues are unavailable, add it to a task list in the map and put
  `Part of #<map>` at the top of its body. Label it with
  `wayfinder:<type>` (`research`, `prototype`, `grilling`, or `task`).
  Assign the ticket to the driving developer when it is claimed.
- **Blocking**: GitHub's native issue dependencies are canonical. Add an edge
  with:

  ```powershell
  gh api --method POST `
    "repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by" `
    -F "issue_id=<blocker-db-id>"
  ```

  where `<blocker-db-id>` is the blocker's numeric database ID from
  `gh api repos/<owner>/<repo>/issues/<n> --jq .id`, not its issue number or
  node ID. If dependencies are unavailable, use a
  `Blocked by: #<n>, #<n>` line at the top of the child body.
- **Frontier query**: list the map's open children, then drop tickets with an
  open blocker (`issue_dependencies_summary.blocked_by > 0`, or an open issue
  in the fallback `Blocked by` line) or an assignee. First in map order wins.
- **Claim**: `gh issue edit <n> --add-assignee @me` is the session's first
  write.
- **Resolve**: comment with the answer, close the ticket, then append a context
  pointer to the map's Decisions-so-far section.
