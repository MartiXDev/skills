# TASK

Merge the following branches into the current branch:

{{BRANCHES}}

For each branch:

1. Run `git merge <branch> --no-edit`
2. If there are merge conflicts, stop and inspect both sides before resolving
   them. Preserve unrelated work and repository contracts.
3. After each merge, run:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1
   ```

   Also run the Markdown hook for changed Markdown and package-specific tests
   only when they exist.
4. If validation fails, fix the issue before proceeding to the next branch

After all branches are merged and validation passes, make a single Conventional
Commit summarizing the merge. Never force-push, reset, or discard changes.

# CLOSE ISSUES

For each branch that was merged, close its issue using the following command:

`gh issue close <ID> --comment "Completed by Sandcastle"`

Here are all the issues:

{{ISSUES}}

Once you've merged everything you can, output <promise>COMPLETE</promise>.
