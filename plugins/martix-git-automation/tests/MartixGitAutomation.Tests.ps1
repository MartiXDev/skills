#requires -Version 7.0
#requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }

BeforeAll {
  $script:PluginRoot = Split-Path -Parent $PSScriptRoot
  $script:HookRoot = Join-Path $script:PluginRoot 'hooks'
  $script:TestRepositories = [System.Collections.Generic.List[string]]::new()

  function Invoke-TestGit {
    param(
      [Parameter(Mandatory)] [string] $RepositoryPath,
      [Parameter(Mandatory)] [string[]] $Arguments,
      [switch] $AllowFailure
    )

    $output = @(& git -C $RepositoryPath @Arguments 2>&1)
    $exitCode = $LASTEXITCODE
    if (-not $AllowFailure -and $exitCode -ne 0) {
      throw "git $($Arguments -join ' ') failed with exit code ${exitCode}: $($output -join [Environment]::NewLine)"
    }
    return [pscustomobject]@{
      Output   = $output
      ExitCode = $exitCode
    }
  }

  function New-TestRepository {
    $repositoryPath = Join-Path ([System.IO.Path]::GetTempPath()) ("martix-git-" + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $repositoryPath -Force | Out-Null
    [void] $script:TestRepositories.Add($repositoryPath)
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('init', '-b', 'main'))
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('config', 'user.name', 'MartiX Test'))
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('config', 'user.email', 'martix-test@example.invalid'))
    Set-Content -LiteralPath (Join-Path $repositoryPath 'README.md') -Value '# Fixture' -Encoding utf8NoBOM
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('add', '--', 'README.md'))
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('commit', '-m', 'chore: initialize'))
    return $repositoryPath
  }

  function New-TestBareRemote {
    $remotePath = Join-Path ([System.IO.Path]::GetTempPath()) `
    ("martix-remote-" + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $remotePath -Force | Out-Null
    [void] $script:TestRepositories.Add($remotePath)
    [void] (Invoke-TestGit -RepositoryPath $remotePath -Arguments @('init', '--bare'))
    return $remotePath
  }

  function Write-TestConfig {
    param(
      [Parameter(Mandatory)] [string] $RepositoryPath,
      [Parameter()] [hashtable] $Overrides = @{}
    )

    $document = [ordered]@{ schemaVersion = 1 }
    foreach ($key in $Overrides.Keys) { $document[$key] = $Overrides[$key] }
    $document | ConvertTo-Json -Depth 20 | Set-Content `
      -LiteralPath (Join-Path $RepositoryPath '.martix-git.json') -Encoding utf8NoBOM
  }

  function New-TestCommandShim {
    param(
      [Parameter(Mandatory)] [string] $Directory,
      [Parameter(Mandatory)] [string] $Name,
      [Parameter(Mandatory)] [string[]] $Lines
    )

    $path = Join-Path $Directory "$Name.cmd"
    Set-Content -LiteralPath $path -Value $Lines -Encoding ascii
    return $path
  }

  function Invoke-MartixScript {
    param(
      [Parameter(Mandatory)] [string] $ScriptName,
      [Parameter(Mandatory)] [string[]] $Arguments
    )

    $parameters = @{}
    for ($index = 0; $index -lt $Arguments.Count; $index++) {
      $token = [string] $Arguments[$index]
      if ($token -notmatch '^-(?<name>[^:]+)(?::(?<value>.*))?$') {
        throw "Test arguments must use named parameters: $token"
      }
      $name = $Matches.name
      if ($Matches.ContainsKey('value')) {
        $value = $Matches.value
        if ($value -ieq '$false') { $parameters[$name] = $false }
        elseif ($value -ieq '$true') { $parameters[$name] = $true }
        else { $parameters[$name] = $value }
        continue
      }
      if ($index + 1 -lt $Arguments.Count -and
        [string] $Arguments[$index + 1] -notmatch '^-[^/\\]') {
        $parameters[$name] = $Arguments[$index + 1]
        $index++
      }
      else {
        $parameters[$name] = $true
      }
    }
    $parameters.Json = $true
    $scriptPath = Join-Path $script:HookRoot $ScriptName
    $output = @(& $scriptPath @parameters 2>&1)
    $exitCode = $LASTEXITCODE
    $text = ($output | ForEach-Object { $_.ToString() }) -join [Environment]::NewLine
    try {
      $json = $text | ConvertFrom-Json
    }
    catch {
      throw "Unable to parse $ScriptName output with exit code ${exitCode}: $text"
    }
    return [pscustomobject]@{
      ExitCode = $exitCode
      Json     = $json
      Raw      = $text
    }
  }

  function Remove-TestRepositories {
    foreach ($repositoryPath in @($script:TestRepositories)) {
      if (Test-Path -LiteralPath $repositoryPath) {
        Remove-Item -LiteralPath $repositoryPath -Recurse -Force -ErrorAction SilentlyContinue
      }
    }
    $script:TestRepositories.Clear()
  }
}

Describe 'MartiX Git deterministic adapters' {
  AfterEach {
    Remove-TestRepositories
  }

  It 'validates Conventional Commit breaking-change messages' {
    $repositoryPath = New-TestRepository
    $messagePath = Join-Path $repositoryPath 'message.txt'
    Set-Content -LiteralPath $messagePath -Value @(
      'feat(parser)!: accept nested input'
      ''
      'The parser now accepts nested input.'
      ''
      'BREAKING CHANGE: callers must pass a nested input object.'
    ) -Encoding utf8NoBOM

    $result = Invoke-MartixScript -ScriptName 'validate-commit-message.ps1' `
      -Arguments @('-RepositoryPath', $repositoryPath, '-MessageFile', $messagePath)

    $result.ExitCode | Should -Be 0
    $result.Json.Valid | Should -BeTrue
    $result.Json.Breaking | Should -BeTrue
    $result.Json.Type | Should -Be 'feat'
  }

  It 'accepts the shipped configuration template with one-item arrays' {
    $repositoryPath = New-TestRepository
    Copy-Item -LiteralPath (Join-Path $script:PluginRoot 'templates\martix-git.json') `
      -Destination (Join-Path $repositoryPath '.martix-git.json')

    $result = Invoke-MartixScript -ScriptName 'validate-config.ps1' `
      -Arguments @('-RepositoryPath', $repositoryPath)

    $result.ExitCode | Should -Be 0
    $result.Json.Valid | Should -BeTrue
    $result.Json.ConfigExists | Should -BeTrue
  }

  It 'rejects invalid branch refs before Git mutation' {
    $repositoryPath = New-TestRepository

    $result = Invoke-MartixScript -ScriptName 'validate-branch-name.ps1' `
      -Arguments @('-RepositoryPath', $repositoryPath, '-BranchName', 'feature/invalid name')

    $result.ExitCode | Should -Be 1
    $result.Json.Valid | Should -BeFalse
    @($result.Json.Errors) | Should -Contain 'Branch names cannot contain whitespace or control characters.'
  }

  It 'plans and creates an in-place branch only after explicit apply' {
    $repositoryPath = New-TestRepository

    $plan = Invoke-MartixScript -ScriptName 'create-branch.ps1' `
      -Arguments @('-RepositoryPath', $repositoryPath, '-BranchName', 'feature/created')
    $planBranch = Invoke-TestGit -RepositoryPath $repositoryPath `
      -Arguments @('symbolic-ref', '--short', 'HEAD')

    $apply = Invoke-MartixScript -ScriptName 'create-branch.ps1' `
      -Arguments @('-RepositoryPath', $repositoryPath, '-BranchName', 'feature/created', '-Apply', '-Confirm:$false')
    $createdBranch = Invoke-TestGit -RepositoryPath $repositoryPath `
      -Arguments @('symbolic-ref', '--short', 'HEAD')

    $plan.ExitCode | Should -Be 0
    $plan.Json.Decision | Should -Be 'ask'
    $plan.Json.Result | Should -Be 'unresolved'
    ($planBranch.Output -join '').Trim() | Should -Be 'main'
    $apply.ExitCode | Should -Be 0
    $apply.Json.Result | Should -Be 'completed'
    ($createdBranch.Output -join '').Trim() | Should -Be 'feature/created'
  }

  It 'plans dirty current changes without mutating and asks for a commit message' {
    $repositoryPath = New-TestRepository
    Set-Content -LiteralPath (Join-Path $repositoryPath 'change.txt') `
      -Value 'changed' -Encoding utf8NoBOM
    $originalPath = $env:PATH
    $gitDirectory = Split-Path (Get-Command git -CommandType Application | Select-Object -First 1).Source
    $pwshDirectory = Split-Path (Get-Command pwsh -CommandType Application | Select-Object -First 1).Source
    $messagePath = Join-Path ([System.IO.Path]::GetTempPath()) `
    ("martix-message-" + [guid]::NewGuid().ToString('N') + '.txt')
    try {
      $env:PATH = "$gitDirectory;$pwshDirectory"
      $result = Invoke-MartixScript -ScriptName 'plan-pr-workflow.ps1' `
        -Arguments @('-RepositoryPath', $repositoryPath, '-BranchName', 'feature/change', '-Paths', 'change.txt')
      Set-Content -LiteralPath $messagePath -Value 'feat: plan change' -Encoding utf8NoBOM
      $withMessage = Invoke-MartixScript -ScriptName 'plan-pr-workflow.ps1' `
        -Arguments @('-RepositoryPath', $repositoryPath, '-BranchName', 'feature/change',
        '-Paths', 'change.txt', '-CommitMessageFile', $messagePath)
    }
    finally {
      $env:PATH = $originalPath
      Remove-Item -LiteralPath $messagePath -Force -ErrorAction SilentlyContinue
    }

    $phases = @($result.Json.Phases)
    $branch = Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('symbolic-ref', '--short', 'HEAD')
    $status = Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('status', '--porcelain')
    $result.ExitCode | Should -Be 0
    $result.Json.Decision | Should -Be 'block'
    $phases[1].Decision | Should -Be 'perform'
    $phases[2].Decision | Should -Be 'perform'
    $phases[3].Decision | Should -Be 'ask'
    $phases[3].Evidence | Should -Match 'message file'
    @($withMessage.Json.Phases)[3].Decision | Should -Be 'perform'
    @($withMessage.Json.Phases)[4].Decision | Should -Be 'block'
    @($withMessage.Json.Phases)[4].Evidence | Should -Not -Match 'No reviewable commits'
    ($branch.Output -join '').Trim() | Should -Be 'main'
    ($status.Output -join '').Trim() | Should -Be '?? change.txt'
  }

  It 'skips completed local phases and asks before publishing without an upstream' {
    $repositoryPath = New-TestRepository
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('switch', '-c', 'feature/ready'))
    Set-Content -LiteralPath (Join-Path $repositoryPath 'ready.txt') `
      -Value 'ready' -Encoding utf8NoBOM
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('add', '--', 'ready.txt'))
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('commit', '-m', 'feat: prepare review'))
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath `
        -Arguments @('remote', 'add', 'origin', 'https://example.invalid/martix.git'))
    $originalPath = $env:PATH
    $gitDirectory = Split-Path (Get-Command git -CommandType Application | Select-Object -First 1).Source
    $pwshDirectory = Split-Path (Get-Command pwsh -CommandType Application | Select-Object -First 1).Source
    try {
      $env:PATH = "$gitDirectory;$pwshDirectory"
      $result = Invoke-MartixScript -ScriptName 'plan-pr-workflow.ps1' `
        -Arguments @('-RepositoryPath', $repositoryPath, '-BranchName', 'feature/ready')
    }
    finally {
      $env:PATH = $originalPath
    }

    $phases = @($result.Json.Phases)
    $result.ExitCode | Should -Be 0
    $phases[1].Decision | Should -Be 'skip'
    $phases[2].Decision | Should -Be 'skip'
    $phases[3].Decision | Should -Be 'skip'
    $phases[4].Decision | Should -Be 'ask'
    $phases[4].Evidence | Should -Match 'No upstream'
    $phases[5].Decision | Should -Be 'block'
  }

  It 'skips PR creation when the planner finds a matching open PR' {
    $repositoryPath = New-TestRepository
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('switch', '-c', 'feature/duplicate'))
    Set-Content -LiteralPath (Join-Path $repositoryPath 'duplicate.txt') `
      -Value 'duplicate' -Encoding utf8NoBOM
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('add', '--', 'duplicate.txt'))
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('commit', '-m', 'feat: duplicate review'))
    $remotePath = New-TestBareRemote
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath `
        -Arguments @('remote', 'add', 'origin', $remotePath))
    $shimDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ("martix-gh-" + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $shimDirectory -Force | Out-Null
    [void] $script:TestRepositories.Add($shimDirectory)
    $pullRequestJson = '[{"number":7,"url":"https://github.com/example/repo/pull/7","title":"Existing","isDraft":true,"headRefOid":"abc123","headRefName":"feature/duplicate","baseRefName":"main"}]'
    New-TestCommandShim -Directory $shimDirectory -Name 'gh' -Lines @(
      '@echo off'
      'if "%~1"=="auth" if "%~2"=="status" exit /b 0'
      'if "%~1"=="repo" if "%~2"=="view" ('
      '  echo {"nameWithOwner":"example/repo","defaultBranchRef":{"name":"main"}}'
      '  exit /b 0'
      ')'
      'if "%~1"=="pr" if "%~2"=="list" ('
      "  echo $pullRequestJson"
      '  exit /b 0'
      ')'
      'exit /b 1'
    ) | Out-Null
    $originalPath = $env:PATH
    $gitDirectory = Split-Path (Get-Command git -CommandType Application | Select-Object -First 1).Source
    $pwshDirectory = Split-Path (Get-Command pwsh -CommandType Application | Select-Object -First 1).Source
    try {
      $env:PATH = "$shimDirectory;$gitDirectory;$pwshDirectory"
      $result = Invoke-MartixScript -ScriptName 'plan-pr-workflow.ps1' `
        -Arguments @('-RepositoryPath', $repositoryPath, '-BranchName', 'feature/duplicate', '-Remote', 'origin')
    }
    finally {
      $env:PATH = $originalPath
    }

    $phases = @($result.Json.Phases)
    $result.ExitCode | Should -Be 0
    $phases[4].Decision | Should -Be 'perform'
    $phases[5].Decision | Should -Be 'skip'
    $phases[5].Evidence | Should -Match 'pull/7'
  }

  It 'skips push when an explicit remote already contains the current head without an upstream' {
    $repositoryPath = New-TestRepository
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('switch', '-c', 'feature/synced'))
    Set-Content -LiteralPath (Join-Path $repositoryPath 'synced.txt') `
      -Value 'synced' -Encoding utf8NoBOM
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('add', '--', 'synced.txt'))
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('commit', '-m', 'feat: synchronize review'))
    $remotePath = New-TestBareRemote
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath `
        -Arguments @('remote', 'add', 'origin', $remotePath))
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath `
        -Arguments @('push', 'origin', 'HEAD:refs/heads/feature/synced'))
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath `
        -Arguments @('config', '--unset', 'branch.feature/synced.remote') -AllowFailure)
    [void] (Invoke-TestGit -RepositoryPath $repositoryPath `
        -Arguments @('config', '--unset', 'branch.feature/synced.merge') -AllowFailure)
    $originalPath = $env:PATH
    $gitDirectory = Split-Path (Get-Command git -CommandType Application | Select-Object -First 1).Source
    $pwshDirectory = Split-Path (Get-Command pwsh -CommandType Application | Select-Object -First 1).Source
    try {
      $env:PATH = "$gitDirectory;$pwshDirectory"
      $result = Invoke-MartixScript -ScriptName 'plan-pr-workflow.ps1' `
        -Arguments @('-RepositoryPath', $repositoryPath, '-BranchName', 'feature/synced', '-Remote', 'origin')
    }
    finally {
      $env:PATH = $originalPath
    }

    $phases = @($result.Json.Phases)
    $result.ExitCode | Should -Be 0
    $phases[4].Decision | Should -Be 'skip'
    $phases[4].Evidence | Should -Match 'already contains HEAD'
  }

  It 'stages only an explicit path containing spaces' {
    $repositoryPath = New-TestRepository
    $path = 'change with spaces.txt'
    Set-Content -LiteralPath (Join-Path $repositoryPath $path) -Value 'changed' -Encoding utf8NoBOM

    $result = Invoke-MartixScript -ScriptName 'stage-paths.ps1' `
      -Arguments @('-RepositoryPath', $repositoryPath, '-Paths', $path, '-Apply', '-Confirm:$false')
    $staged = Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('diff', '--cached', '--name-only')

    $result.ExitCode | Should -Be 0
    $result.Json.Result | Should -Be 'completed'
    ($staged.Output -join '').Trim() | Should -Be $path
  }

  It 'rejects shell syntax in configured hook commands' {
    $repositoryPath = New-TestRepository
    Write-TestConfig -RepositoryPath $repositoryPath -Overrides @{
      hooks = [ordered]@{
        enabled         = $true
        preCommitChecks = @('Write-Output allowed; Write-Output unexpected')
        prePushCommand  = $null
      }
    }

    $result = Invoke-MartixScript -ScriptName 'pre-commit.ps1' `
      -Arguments @('-RepositoryPath', $repositoryPath)

    $result.ExitCode | Should -Be 2
    $result.Json.Valid | Should -BeFalse
    @($result.Json.Errors)[0] | Should -Match 'one executable command|literal executable and argument values'
  }

  It 'degrades to unknown remote evidence when gh is unavailable' {
    $repositoryPath = New-TestRepository
    $originalPath = $env:PATH
    $gitDirectory = Split-Path (Get-Command git -CommandType Application | Select-Object -First 1).Source
    try {
      $env:PATH = $gitDirectory
      $result = Invoke-MartixScript -ScriptName 'inspect-pr.ps1' `
        -Arguments @('-RepositoryPath', $repositoryPath, '-BaseBranch', 'main')
    }
    finally {
      $env:PATH = $originalPath
    }

    $result.ExitCode | Should -Be 0
    $result.Json.Valid | Should -BeTrue
    $result.Json.Capability | Should -Be 'gh-missing'
    $result.Json.RemoteEvidence | Should -Be 'unavailable'
    $result.Json.DuplicateOpenPullRequest | Should -BeNullOrEmpty
  }

  It 'uses authenticated gh evidence and skips duplicate pull-request creation' {
    $repositoryPath = New-TestRepository
    $shimDirectory = Join-Path $repositoryPath 'command shims'
    New-Item -ItemType Directory -Path $shimDirectory -Force | Out-Null
    $pullRequestJson = '[{"number":42,"url":"https://github.com/example/repo/pull/42","title":"Existing PR","isDraft":true,"headRefOid":"abc123","headRefName":"feature/pr","baseRefName":"main"}]'
    New-TestCommandShim -Directory $shimDirectory -Name 'gh' -Lines @(
      '@echo off'
      'if "%~1"=="auth" if "%~2"=="status" exit /b 0'
      'if "%~1"=="repo" if "%~2"=="view" ('
      '  echo {"nameWithOwner":"example/repo","defaultBranchRef":{"name":"main"}}'
      '  exit /b 0'
      ')'
      'if "%~1"=="pr" if "%~2"=="list" ('
      "  echo $pullRequestJson"
      '  exit /b 0'
      ')'
      'if "%~1"=="pr" if "%~2"=="create" exit /b 43'
      'exit /b 1'
    ) | Out-Null
    $bodyPath = Join-Path $repositoryPath 'body.md'
    Set-Content -LiteralPath $bodyPath -Value 'Reviewed body.' -Encoding utf8NoBOM
    $originalPath = $env:PATH
    try {
      $env:PATH = "$shimDirectory;$originalPath"
      $inspection = Invoke-MartixScript -ScriptName 'inspect-pr.ps1' `
        -Arguments @('-RepositoryPath', $repositoryPath, '-BaseBranch', 'main')
      $creation = Invoke-MartixScript -ScriptName 'create-pr.ps1' `
        -Arguments @('-RepositoryPath', $repositoryPath, '-Title', 'Duplicate title', '-BodyFile', $bodyPath, '-BaseBranch', 'main')
    }
    finally {
      $env:PATH = $originalPath
    }

    $inspection.ExitCode | Should -Be 0
    $inspection.Json.Capability | Should -Be 'gh-authenticated'
    $inspection.Json.RemoteEvidence | Should -Be 'available'
    $inspection.Json.DuplicateOpenPullRequest | Should -BeTrue
    @($inspection.Json.OpenPullRequests).Count | Should -Be 1
    $creation.ExitCode | Should -Be 0
    $creation.Json.Decision | Should -Be 'skip'
    $creation.Json.Result | Should -Be 'skipped'
    $creation.Json.PullRequest.number | Should -Be 42
  }

  It 'blocks release planning when the default policy is disabled' {
    $repositoryPath = New-TestRepository

    $result = Invoke-MartixScript -ScriptName 'release-plan.ps1' `
      -Arguments @('-RepositoryPath', $repositoryPath)

    $result.ExitCode | Should -Be 1
    $result.Json.Valid | Should -BeFalse
    $result.Json.Decision | Should -Be 'block'
    @($result.Json.Errors) | Should -Contain 'Release integration is disabled in .martix-git.json.'
  }

  It 'separates release preflight, dry-run, and explicit apply' {
    $repositoryPath = New-TestRepository
    Write-TestConfig -RepositoryPath $repositoryPath -Overrides @{
      release = [ordered]@{
        enabled         = $true
        analyzerPreset  = 'conventionalcommits'
        tagFormat       = 'v${version}'
        releaseBranches = @('main')
      }
    }
    $plan = Invoke-MartixScript -ScriptName 'release-plan.ps1' `
      -Arguments @('-RepositoryPath', $repositoryPath)
    $shimDirectory = Join-Path $repositoryPath 'release shims'
    New-Item -ItemType Directory -Path $shimDirectory -Force | Out-Null
    $logPath = Join-Path $shimDirectory 'semantic-release.log'
    New-TestCommandShim -Directory $shimDirectory -Name 'semantic-release' -Lines @(
      '@echo off'
      "if `"%~1`"==`"`" (>`"$logPath`" echo NO_ARGS) else (>`"$logPath`" echo %*)"
      'echo semantic-release fixture'
      'exit /b 0'
    ) | Out-Null
    $originalPath = $env:PATH
    try {
      $env:PATH = "$shimDirectory;$originalPath"
      $dryRun = Invoke-MartixScript -ScriptName 'release-publish.ps1' `
        -Arguments @('-RepositoryPath', $repositoryPath, '-DryRun')
      $dryRunLog = Get-Content -LiteralPath $logPath -Raw
      Remove-Item -LiteralPath $logPath -Force
      $apply = Invoke-MartixScript -ScriptName 'release-publish.ps1' `
        -Arguments @('-RepositoryPath', $repositoryPath, '-Apply', '-Confirm:$false')
      $applyLog = Get-Content -LiteralPath $logPath -Raw
    }
    finally {
      $env:PATH = $originalPath
    }

    $plan.ExitCode | Should -Be 0
    $plan.Json.Valid | Should -BeTrue
    $plan.Json.Decision | Should -Be 'perform'
    $dryRun.ExitCode | Should -Be 0
    $dryRun.Json.Result | Should -Be 'completed'
    $dryRun.Json.DryRun | Should -BeTrue
    $dryRunLog.Trim() | Should -Be '--dry-run'
    $apply.ExitCode | Should -Be 0
    $apply.Json.Result | Should -Be 'completed'
    $apply.Json.DryRun | Should -BeFalse
    $applyLog.Trim() | Should -Be 'NO_ARGS'
  }

  It 'delegates worktree audit and filters unmatched selections' {
    $repositoryPath = New-TestRepository
    $cleanupDirectory = Join-Path $repositoryPath 'scripts'
    New-Item -ItemType Directory -Path $cleanupDirectory -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path (Split-Path -Parent $script:PluginRoot) '..\scripts\git-cleanup.ps1') `
      -Destination (Join-Path $cleanupDirectory 'git-cleanup.ps1')

    $result = Invoke-MartixScript -ScriptName 'inspect-git-worktrees.ps1' `
      -Arguments @('-RepositoryPath', $repositoryPath, '-SelectedBranch', '__unmatched__')

    $result.ExitCode | Should -Be 0
    $result.Json.Valid | Should -BeTrue
    @($result.Json.Cleanup.CandidateBranchesRequested) | Should -Contain '__unmatched__'
    @($result.Json.Cleanup.Candidates).Count | Should -Be 0
  }
}

Describe 'MartiX Git hook lifecycle' {
  AfterEach {
    Remove-TestRepositories
  }

  It 'installs a commit-msg hook, enforces it, and uninstalls it' {
    $repositoryPath = New-TestRepository
    Write-TestConfig -RepositoryPath $repositoryPath -Overrides @{
      hooks = [ordered]@{
        enabled         = $true
        preCommitChecks = @()
        prePushCommand  = $null
      }
    }

    $install = Invoke-MartixScript -ScriptName 'install-hooks.ps1' `
      -Arguments @('-RepositoryPath', $repositoryPath, '-Hook', 'commit-msg', '-Apply', '-Confirm:$false')
    $hook = @($install.Json.Hooks)[0]

    $install.ExitCode | Should -Be 0
    $install.Json.Result | Should -Be 'completed'
    Test-Path -LiteralPath (Join-Path $repositoryPath '.martix-git\hooks\commit-msg.ps1') | Should -BeTrue
    (Get-Content -LiteralPath $hook.Target -Raw) | Should -Match 'MartiX Git Automation'

    Set-Content -LiteralPath (Join-Path $repositoryPath 'change.txt') -Value 'change' -Encoding utf8NoBOM
    Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('add', '--', 'change.txt')
    $invalidCommit = Invoke-TestGit -RepositoryPath $repositoryPath `
      -Arguments @('commit', '-m', 'not valid') -AllowFailure
    $validCommit = Invoke-TestGit -RepositoryPath $repositoryPath `
      -Arguments @('commit', '-m', 'fix: validate hook lifecycle')

    $invalidCommit.ExitCode | Should -Not -Be 0
    $validCommit.ExitCode | Should -Be 0

    $uninstall = Invoke-MartixScript -ScriptName 'uninstall-hooks.ps1' `
      -Arguments @('-RepositoryPath', $repositoryPath, '-Hook', 'commit-msg', '-Apply', '-Confirm:$false')
    $uninstall.ExitCode | Should -Be 0
    $uninstall.Json.Result | Should -Be 'completed'
    Test-Path -LiteralPath $hook.Target | Should -BeFalse
  }

  It 'retains a user-owned hook unless replacement is explicit and restores its backup' {
    $repositoryPath = New-TestRepository
    Write-TestConfig -RepositoryPath $repositoryPath -Overrides @{
      hooks = [ordered]@{
        enabled         = $true
        preCommitChecks = @()
        prePushCommand  = $null
      }
    }
    $hooksPath = (Invoke-TestGit -RepositoryPath $repositoryPath -Arguments @('rev-parse', '--git-path', 'hooks')).Output -join ''
    if (-not [System.IO.Path]::IsPathRooted($hooksPath)) { $hooksPath = Join-Path $repositoryPath $hooksPath }
    $hookPath = Join-Path ([System.IO.Path]::GetFullPath($hooksPath)) 'pre-commit'
    Set-Content -LiteralPath $hookPath -Value "#!/bin/sh`necho user-owned`n" -Encoding utf8NoBOM

    $blocked = Invoke-MartixScript -ScriptName 'install-hooks.ps1' `
      -Arguments @('-RepositoryPath', $repositoryPath, '-Hook', 'pre-commit', '-Apply', '-Confirm:$false')
    $blocked.ExitCode | Should -Be 1
    (Get-Content -LiteralPath $hookPath -Raw) | Should -Match 'user-owned'

    $replaced = Invoke-MartixScript -ScriptName 'install-hooks.ps1' `
      -Arguments @('-RepositoryPath', $repositoryPath, '-Hook', 'pre-commit', '-ReplaceExisting', '-Apply', '-Confirm:$false')
    $entry = @($replaced.Json.Hooks)[0]
    $replaced.ExitCode | Should -Be 0
    Test-Path -LiteralPath $entry.Backup | Should -BeTrue

    $restored = Invoke-MartixScript -ScriptName 'uninstall-hooks.ps1' `
      -Arguments @('-RepositoryPath', $repositoryPath, '-Hook', 'pre-commit', '-RestoreBackup', '-Apply', '-Confirm:$false')
    $restored.ExitCode | Should -Be 0
    (Get-Content -LiteralPath $hookPath -Raw) | Should -Match 'user-owned'
  }
}
