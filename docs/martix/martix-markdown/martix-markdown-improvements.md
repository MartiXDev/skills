# MartiX Markdown automation recommendation

## Prompt reviewed

AI Agents, Skills, Plugins, Instructions, Prompts, Hooks.

What is the best way to organize my custom Markdown "Skill" to achieve automatic
check every time any agent creates or updates any Markdown file? It should be
easy to install in future projects, and it likely needs an instruction file that
applies to every Markdown file touch.

## Recommendation

Keep `skills\martix-markdown` as the standalone Markdown guidance package and
add a companion plugin named `martix-markdown-automation` for automatic
enforcement.

Do not convert `martix-markdown` itself into a plugin. The Markdown rules,
markdownlint triage, config-versus-content decisions, accessibility review, and
tooling guidance are reusable across many project families, so they should stay
in the standalone skill. Automatic "run when Markdown changes" behavior needs
workspace-level instructions and hook execution, so it belongs in a plugin.

## Implemented repository shape

```text
skills/
  martix-markdown/
    SKILL.md
    rules/
    references/
    templates/
    assets/
    evals/

plugins/
  martix-markdown-automation/
    plugin.json
    README.md
    instructions/
      markdown-policy.md
    hooks/
      markdown-check.ps1
    hooks.json
```

## Default automation behavior

The automation plugin should:

1. Detect changed Markdown files.
2. Auto-fix supported markdownlint issues.
3. Rerun markdownlint checks.
4. Report remaining issues.
5. Leave complex config-versus-content decisions to `martix-markdown`.

Use check-only mode for CI, dry runs, or conservative projects.

## Why this split is best

- Markdown rule knowledge belongs in the `martix-markdown` skill because it is
  reusable and installable without project hooks.
- Workspace enforcement belongs in `martix-markdown-automation` because it
  requires plugin-scoped instructions and hook metadata.
- Auto-fix workflow belongs in `martix-markdown-automation` because executable
  validation belongs in plugin hooks.
- Manual lint triage belongs in `martix-markdown` because agents need the rule
  library to decide content versus config.

## Maintenance guidance

- Keep rule content in `skills\martix-markdown`.
- Keep hook behavior and automatic enforcement policy in
  `plugins\martix-markdown-automation`.
- Do not duplicate the Markdown rule library inside the plugin.
- Keep plugin docs pointing back to the standalone skill for deeper guidance.
- Keep eval coverage in `martix-markdown` for routing automatic enforcement
  requests to the companion plugin.
