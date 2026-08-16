# Commit message template

Use this file as a drafting scaffold. Replace every placeholder, remove
unused sections, and show the complete result before confirmation.

```text
<type>(<scope>): <short description>

<Why this change is needed and what behavior it introduces.>

<Footer-Token>: <value>
BREAKING CHANGE: <migration impact, when applicable>
```

## Drafting checks

- Use a configured type and scope only when repository policy restricts them.
- Keep the subject supported by the staged diff.
- Explain user-visible or API impact in the body.
- Preserve valid trailers and add a breaking footer when required.
- Pass the reviewed multi-line result through a temporary message file.

See [conventional-commits.md](../rules/conventional-commits.md) for the
specification and policy boundary.
