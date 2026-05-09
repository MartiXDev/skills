# Markdown automation policy

Whenever an agent creates or updates Markdown files in a project using this plugin, it should run the Markdown automation hook before finalizing the work.

Default behavior:

1. Detect changed Markdown files.
2. Auto-fix supported markdownlint issues.
3. Rerun Markdown checks.
4. Report remaining issues concisely.
5. Fix remaining issues manually or explain why they are intentionally left.

Use check-only mode when the task is CI validation, a dry run, or a conservative review.

Keep rule decisions in the standalone `martix-markdown` skill. This plugin only owns automation policy and hook execution.
