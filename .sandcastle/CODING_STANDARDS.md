# MartiX Skills Coding Standards

These standards apply to Sandcastle implementation and review agents. Preserve
repository conventions and the smallest change that satisfies the issue.

## Repository boundaries

- Keep reusable domain knowledge in `skills\martix-*`.
- Keep bundled agents, prompts, instructions, hooks, MCP, and LSP assets in
  `plugins\martix-*`.
- Keep repository policy and research in `docs\`.
- Treat `.github\plugin\marketplace.json`, root README files, shared templates,
  and `scripts\validate-repository.ps1` as coordinator-owned files.
- Do not modify unrelated worktree changes, generated files, or secrets.

## Documentation and Markdown

- Use concise, direct Markdown with descriptive headings and links.
- Keep `SKILL.md` files compact and routing-oriented; put detailed guidance in
  `rules\` and supporting facts in `references\`.
- Keep package identity synchronized across `plugin.json`, `metadata.json`,
  package documentation, and marketplace metadata when those surfaces change.
- Keep research snapshots dated and evidence-oriented; do not silently rewrite
  historical conclusions.
- Run the repository Markdown hook for changed Markdown files.

## PowerShell

- Use `Set-StrictMode -Version Latest` when adding standalone scripts.
- Use `$ErrorActionPreference = 'Stop'` and explicit exit codes for failures.
- Prefer typed parameters, `CmdletBinding`, `SupportsShouldProcess`, and
  argument arrays over interpolated shell commands.
- Validate paths, refs, and external command results before destructive actions.
- Never hide errors with broad catches or success-shaped fallbacks.

## TypeScript

- Use strict, explicit types and preserve the existing module style.
- Validate external and agent-generated data at boundaries with the existing
  schema validation approach.
- Prefer small functions with one responsibility and clear names.
- Avoid `any`, unsafe casts, nested ternaries, and unchecked assumptions.
- Keep asynchronous cleanup in `finally` blocks and preserve failures.

## Testing and validation

- Add or update focused tests when behavior changes.
- For repository changes, run:

  ```powershell
  powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1
  ```

- For changed Markdown, also run the Markdown hook in `-CheckOnly` mode.
- Do not invent `npm run test` or `npm run typecheck` commands; use commands
  that exist in the repository or the package being changed.
- Report unrelated baseline failures separately from failures caused by the task.

## Git and Sandcastle workflow

- Use one branch and worktree per issue or vertical slice.
- Do not commit secrets, `.env` files, credentials, or tokens.
- Use Conventional Commits, for example:
  `docs(skill): clarify evaluation guidance`.
- Do not force-push, force-delete, reset, or discard work unless explicitly
  authorized.
- Leave issue closure and branch merging to the later orchestration phase.
- Preserve dirty, locked, detached, or owner-unknown worktrees.
