# Skills installation

Use this guide for stable installation mechanics. For the changing list of
recommended sources, see the [AI ecosystem research catalogue](../knowledge/ai/ecosystem/research/2026-03-25-recommended-skills.md).

## Recommended target layout

For a repository that imports skills directly, use `.github/skills/`:

```text
<your-repo>/
  .github/
    skills/
      <skill-name>/
        SKILL.md
        references/
        scripts/
```

## Install one skill with `npx skills`

Prefer selecting a skill from the source repository rather than copying an
entire catalogue:

```powershell
npx skills add https://github.com/aaronontheweb/dotnet-skills --skill csharp-coding-standards
npx skills add https://github.com/anthropics/skills --skill skill-creator
npx skills add https://github.com/openai/skills --skill playwright
```

Use the source repository's current instructions when a registry page and the
repository disagree.

## Import a repository for local inspection

When a target repository needs a private or customized copy, clone into a
temporary directory, copy only the required skill folders, and remove the
temporary checkout after inspection:

```powershell
$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Force -Path '.github/skills' | Out-Null
$temporaryPath = '.tmp-dotnet-skills'
git clone --depth 1 https://github.com/aaronontheweb/dotnet-skills $temporaryPath
Copy-Item "$temporaryPath/*" '.github/skills/dotnet-skills' -Recurse -Force
Remove-Item $temporaryPath -Recurse -Force
```

For multiple sources, keep the repository URLs and destination names in a
small script such as `scripts/bootstrap-skills.ps1`. Make the script
idempotent, fail on errors, and avoid deleting an existing destination unless
replacement is intentional.

## Verify an import

After installation:

1. Confirm each imported skill has `SKILL.md` at the expected path.
2. Read the source README or installation notes for required dependencies.
3. Run the target repository's normal skill discovery command, such as
   `/skills list` where supported.
4. Recheck the source repository before updating an old import.
