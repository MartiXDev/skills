# Tests

The [MartixGitAutomation.Tests.ps1](./MartixGitAutomation.Tests.ps1) suite
requires Pester 5+. It covers deterministic adapters, command safety, refusal
paths, remote evidence degradation, hook lifecycle, release guards, and
cleanup selection. Test fixtures use temporary repositories and never mutate
the working repository.

Run it from the repository root with:

```powershell
Invoke-Pester .\plugins\martix-git-automation\tests
```

The current environment has Pester 3.4.0, which cannot execute this suite;
the test file declares the Pester 5+ prerequisite rather than silently
reporting incomplete coverage.
