# MartiX Git release verification

Use this checklist before a release publish operation:

- Confirm the configured semantic-release analyzer preset and release rules.
- Confirm the current branch is an approved protected release branch.
- Confirm the repository has the full history required by the analyzer.
- Run `release-plan.ps1` and review the calculated decision.
- Run `release-publish.ps1 -DryRun` and inspect its output.
- Confirm the tag format is separate from the SemVer value.
- Confirm credentials are provided by the release runtime and are not stored in
  `.martix-git.json`.
- Never publish from pull-request validation.
