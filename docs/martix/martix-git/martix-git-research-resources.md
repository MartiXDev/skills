# MartiX Git Research Resources

I'd like to create Skill or Plugin (probably better solution) with name martix-git or similar, which will combine the best practices and script(s) for:

- using **Conventional Commits** messages in branch names, commits, pull requests
  - <https://www.conventionalcommits.org/en/v1.0.0/>
- follow the Semantic Versioning (semver) and Semantic Release practices
  - <https://semver.org/> | <https://github.com/semver/semver>
  - <https://semantic-release.org/> | <https://github.com/semantic-release/semantic-release>
  - <https://github.com/marketplace/actions/git-automatic-semantic-versioning>
  - <https://github.com/marketplace/actions/semver-conventional-commits>
- using git best practices
- using GitHub best practices for PR, creating, managing and linking issues
  - <https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue>
  - <https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/autolinked-references-and-urls#issues-and-pull-requests>
- use inspiration from existing Skills
  - <https://github.com/github/awesome-copilot/blob/main/skills/conventional-commit/SKILL.md>
  - <https://github.com/github/awesome-copilot/blob/main/skills/conventional-branch/SKILL.md> | <https://conventionalbranch.org/>
- use script to cleanup repo after ai agents finished their work in branches and worktrees, it might be automted after PR succesfully closed, or manually invoked, or scheduled on weekly/daily basis
  - scripts\git-cleanup.ps1
- recommend hooks to automate linting, check rules, pre-commit check, etc.

Tasks:

- research all the topics mentioned above
- propose a new skill/plugin to fulfill my requirements and add any new ideas which helps improve my goal
