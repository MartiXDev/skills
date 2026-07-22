# TASK

Fix issue {{TASK_ID}}: {{ISSUE_TITLE}}.

Read the issue with `gh issue view <ID>`. If it references a parent PRD or
related issue, read those only when they are needed to understand the task.
Work only on the specified issue and branch `{{BRANCH}}`.

Before editing, read the repository `CONTEXT.md`, `AGENTS.md`, the relevant
package `README.md`/`SKILL.md`/`AGENTS.md`, and the smallest relevant docs or
rules. Follow `.sandcastle/CODING_STANDARDS.md`.

# CONTEXT

Here are the last 10 commits:

<recent-commits>

!`git log -n 10 --format="%H%n%ad%n%B---" --date=short`

</recent-commits>

# EXPLORATION

Explore the repo enough to identify the owning package, existing patterns, and
relevant tests or validation scripts. Do not load unrelated packages or all
repository documentation.

Pay extra attention to test files that touch the relevant parts of the code.

# EXECUTION

If applicable, use RGR to complete the task:

1. RED: write one test
2. GREEN: write the implementation to pass that test
3. REPEAT until done
4. REFACTOR the code

# FEEDBACK LOOPS

Before committing, run the repository validation command:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1
```

For changed Markdown, also run the Markdown hook in `-CheckOnly` mode. Run
package-specific tests only when they exist. Do not invent missing npm scripts.

# COMMIT

If the task is complete and validation passes, make a Conventional Commit with
an imperative subject, such as `docs(skill): clarify evaluation guidance`.
Include the issue reference in the body when useful. Keep the message concise.
Do not commit secrets, `.env` files, generated dependencies, or unrelated
changes.

# THE ISSUE

If the task is not complete, leave a concise comment on the issue describing
what was done, what remains, and any blocker.

Do not close the issue - this will be done later.

Once complete, output <promise>COMPLETE</promise>.

# FINAL RULES

ONLY WORK ON A SINGLE TASK.
