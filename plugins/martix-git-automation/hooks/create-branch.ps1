[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
  [Parameter(Position = 0, Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string] $BranchName,

  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [string] $BaseBranch,

  [Parameter()]
  [string] $WorktreePath,

  [Parameter()]
  [string] $ExpectedHead,

  [Parameter()]
  [string] $ConfigPath,

  [Parameter()]
  [switch] $Apply,

  [Parameter()]
  [switch] $Json
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

function Invoke-MartixGit {
  param(
    [Parameter(Mandatory)] [string] $GitPath,
    [Parameter(Mandatory)] [string] $RepositoryRoot,
    [Parameter(Mandatory)] [string[]] $Arguments,
    [Parameter()] [int[]] $AllowedExitCode = @(0)
  )

  $result = Invoke-MartixNative -FilePath $GitPath -Arguments $Arguments -WorkingDirectory $RepositoryRoot
  if ($result.ExitCode -notin $AllowedExitCode) {
    $detail = $result.StandardError.Trim()
    if ([string]::IsNullOrWhiteSpace($detail)) { $detail = $result.StandardOutput.Trim() }
    throw "git $($Arguments -join ' ') failed with exit code $($result.ExitCode): $detail"
  }
  return $result
}

function Get-MartixCurrentBranch {
  param(
    [Parameter(Mandatory)] [string] $GitPath,
    [Parameter(Mandatory)] [string] $RepositoryRoot
  )

  $result = Invoke-MartixGit -GitPath $GitPath -RepositoryRoot $RepositoryRoot `
    -Arguments @('symbolic-ref', '--quiet', '--short', 'HEAD') -AllowedExitCode @(0, 1)
  if ($result.ExitCode -eq 0 -and -not [string]::IsNullOrWhiteSpace($result.StandardOutput)) {
    return $result.StandardOutput.Trim()
  }
  return $null
}

function Get-MartixHead {
  param(
    [Parameter(Mandatory)] [string] $GitPath,
    [Parameter(Mandatory)] [string] $RepositoryRoot
  )

  $result = Invoke-MartixGit -GitPath $GitPath -RepositoryRoot $RepositoryRoot -Arguments @('rev-parse', 'HEAD')
  return $result.StandardOutput.Trim()
}

function Test-MartixLocalBranch {
  param(
    [Parameter(Mandatory)] [string] $GitPath,
    [Parameter(Mandatory)] [string] $RepositoryRoot,
    [Parameter(Mandatory)] [string] $Name
  )

  $result = Invoke-MartixGit -GitPath $GitPath -RepositoryRoot $RepositoryRoot `
    -Arguments @('show-ref', '--verify', '--quiet', "refs/heads/$Name") -AllowedExitCode @(0, 1)
  return $result.ExitCode -eq 0
}

function Get-MartixBranchHead {
  param(
    [Parameter(Mandatory)] [string] $GitPath,
    [Parameter(Mandatory)] [string] $RepositoryRoot,
    [Parameter(Mandatory)] [string] $Name
  )

  $result = Invoke-MartixGit -GitPath $GitPath -RepositoryRoot $RepositoryRoot `
    -Arguments @('rev-parse', '--verify', "refs/heads/$Name^{commit}")
  return $result.StandardOutput.Trim()
}

function Resolve-MartixBaseBranch {
  param(
    [Parameter(Mandatory)] [string] $GitPath,
    [Parameter(Mandatory)] [string] $RepositoryRoot,
    [Parameter(Mandatory)] [object] $Config,
    [AllowNull()] [string] $RequestedBase
  )

  if (-not [string]::IsNullOrWhiteSpace($RequestedBase)) {
    if (-not (Test-MartixLocalBranch -GitPath $GitPath -RepositoryRoot $RepositoryRoot -Name $RequestedBase)) {
      throw "Base branch '$RequestedBase' does not exist as a local branch."
    }
    return $RequestedBase
  }

  $configuredBase = $Config.pullRequest.baseBranch
  if (-not [string]::IsNullOrWhiteSpace($configuredBase)) {
    if (-not (Test-MartixLocalBranch -GitPath $GitPath -RepositoryRoot $RepositoryRoot -Name $configuredBase)) {
      throw "Configured base branch '$configuredBase' does not exist as a local branch."
    }
    return $configuredBase
  }

  $originHead = Invoke-MartixGit -GitPath $GitPath -RepositoryRoot $RepositoryRoot `
    -Arguments @('symbolic-ref', '--quiet', '--short', 'refs/remotes/origin/HEAD') -AllowedExitCode @(0, 1)
  if ($originHead.ExitCode -eq 0 -and -not [string]::IsNullOrWhiteSpace($originHead.StandardOutput)) {
    $originName = $originHead.StandardOutput.Trim() -replace '^origin/', ''
    if (Test-MartixLocalBranch -GitPath $GitPath -RepositoryRoot $RepositoryRoot -Name $originName) {
      return $originName
    }
  }

  $candidates = [System.Collections.Generic.List[string]]::new()
  foreach ($candidate in @($Config.branch.trunkBranches) + @('main', 'master')) {
    if ([string]::IsNullOrWhiteSpace($candidate) -or $candidate -in $candidates) { continue }
    if (Test-MartixLocalBranch -GitPath $GitPath -RepositoryRoot $RepositoryRoot -Name $candidate) {
      [void] $candidates.Add($candidate)
    }
  }
  if ($candidates.Count -eq 1) { return $candidates[0] }
  if ($candidates.Count -gt 1) {
    throw "Base branch is ambiguous; local candidates are: $($candidates -join ', '). Specify -BaseBranch."
  }
  throw 'Unable to determine a local base branch. Specify -BaseBranch explicitly.'
}

function Get-MartixBranchValidationResult {
  param(
    [Parameter(Mandatory)] [string] $PowerShellPath,
    [Parameter(Mandatory)] [string] $RepositoryRoot,
    [Parameter(Mandatory)] [string] $BranchName,
    [AllowNull()] [string] $ConfigPath
  )

  $arguments = @('-NoProfile', '-File', (Join-Path $PSScriptRoot 'validate-branch-name.ps1'),
    $BranchName, '-RepositoryPath', $RepositoryRoot, '-Json')
  if (-not [string]::IsNullOrWhiteSpace($ConfigPath)) {
    $arguments += @('-ConfigPath', $ConfigPath)
  }
  $result = Invoke-MartixNative -FilePath $PowerShellPath -Arguments $arguments -WorkingDirectory $RepositoryRoot
  $document = $null
  if (-not [string]::IsNullOrWhiteSpace($result.StandardOutput)) {
    try { $document = $result.StandardOutput | ConvertFrom-Json } catch { }
  }
  if ($null -eq $document) {
    $detail = @($result.StandardError.Trim(), $result.StandardOutput.Trim()) |
    Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    throw "Branch validation did not return structured output: $($detail -join '; ')"
  }
  return $document
}

function Get-MartixStatusText {
  param(
    [Parameter(Mandatory)] [string] $GitPath,
    [Parameter(Mandatory)] [string] $RepositoryRoot
  )

  $result = Invoke-MartixGit -GitPath $GitPath -RepositoryRoot $RepositoryRoot `
    -Arguments @('status', '--porcelain=v1', '-z', '--untracked-files=all')
  return $result.StandardOutput
}

try {
  $root = Get-MartixRepositoryRoot -RepositoryPath $RepositoryPath
  $gitCommand = Get-Command -Name git -CommandType Application -ErrorAction Stop |
  Select-Object -First 1
  $pwshCommand = Get-Command -Name pwsh -CommandType Application -ErrorAction Stop |
  Select-Object -First 1
  $config = Read-MartixGitConfig -RepositoryRoot $root -ConfigPath $ConfigPath
  $branchValidation = Get-MartixBranchValidationResult `
    -PowerShellPath $pwshCommand.Source -RepositoryRoot $root -BranchName $BranchName -ConfigPath $ConfigPath
  $errors = [System.Collections.Generic.List[string]]::new()
  if (-not $branchValidation.Valid) {
    foreach ($errorMessage in @($branchValidation.Errors)) { [void] $errors.Add([string] $errorMessage) }
  }

  $currentBranch = Get-MartixCurrentBranch -GitPath $gitCommand.Source -RepositoryRoot $root
  $headBefore = Get-MartixHead -GitPath $gitCommand.Source -RepositoryRoot $root
  $statusBefore = Get-MartixStatusText -GitPath $gitCommand.Source -RepositoryRoot $root
  $localCollision = Test-MartixLocalBranch -GitPath $gitCommand.Source -RepositoryRoot $root -Name $BranchName
  if ($localCollision) { [void] $errors.Add("Local branch '$BranchName' already exists.") }

  $resolvedWorktreePath = $null
  if (-not [string]::IsNullOrWhiteSpace($WorktreePath)) {
    $resolvedWorktreePath = [System.IO.Path]::GetFullPath($WorktreePath)
    if (Test-Path -LiteralPath $resolvedWorktreePath) {
      [void] $errors.Add("Worktree path already exists and is retained: $resolvedWorktreePath")
    }
    else {
      $parentPath = Split-Path -Parent $resolvedWorktreePath
      if (-not (Test-Path -LiteralPath $parentPath -PathType Container)) {
        [void] $errors.Add("Worktree parent directory does not exist: $parentPath")
      }
    }
  }
  elseif ([string]::IsNullOrWhiteSpace($currentBranch)) {
    [void] $errors.Add('The current repository is detached; provide a worktree path or switch to a branch before creating an in-place branch.')
  }
  $base = $null
  $baseHead = $null
  try {
    $base = Resolve-MartixBaseBranch -GitPath $gitCommand.Source -RepositoryRoot $root `
      -Config $config -RequestedBase $BaseBranch
    $baseHead = Get-MartixBranchHead -GitPath $gitCommand.Source -RepositoryRoot $root -Name $base
  }
  catch {
    [void] $errors.Add($_.Exception.Message)
  }

  if (-not [string]::IsNullOrWhiteSpace($ExpectedHead) -and $headBefore -cne $ExpectedHead) {
    [void] $errors.Add("HEAD '$headBefore' does not match expected '$ExpectedHead'.")
  }

  $arguments = if ($resolvedWorktreePath) {
    @('worktree', 'add', '-b', $BranchName, $resolvedWorktreePath, $base)
  }
  else {
    @('switch', '-c', $BranchName, $base)
  }
  $target = if ($resolvedWorktreePath) { $resolvedWorktreePath } else { $root }
  $result = [ordered]@{
    Valid            = $errors.Count -eq 0
    Repository       = $root
    CurrentBranch    = $currentBranch
    HeadBefore       = $headBefore
    BranchName       = $BranchName
    BranchValidation = $branchValidation
    BaseBranch       = $base
    BaseHead         = $baseHead
    WorktreePath     = $resolvedWorktreePath
    Command          = 'git'
    Arguments        = @($arguments)
    Decision         = if ($errors.Count -gt 0) { 'block' } elseif ($Apply) { 'perform' } else { 'ask' }
    Confirmation     = if ($errors.Count -gt 0) { 'not applicable' } elseif ($Apply) { 'requested by -Apply; ShouldProcess still applies' } else { 'required' }
    Result           = if ($errors.Count -gt 0) { 'blocked' } elseif ($Apply) { 'pending' } else { 'unresolved' }
    Errors           = @($errors)
  }

  if ($errors.Count -gt 0) {
    Write-MartixResult -Result ([pscustomobject] $result) -Json:$Json
    exit 1
  }
  if (-not $Apply) {
    Write-MartixResult -Result ([pscustomobject] $result) -Json:$Json
    exit 0
  }
  if (-not $PSCmdlet.ShouldProcess($target, "Create branch '$BranchName' from '$base'")) {
    $result.Confirmation = 'declined'
    $result.Result = 'skipped'
    Write-MartixResult -Result ([pscustomobject] $result) -Json:$Json
    exit 0
  }

  $headAtConfirmation = Get-MartixHead -GitPath $gitCommand.Source -RepositoryRoot $root
  $baseHeadAtConfirmation = Get-MartixBranchHead -GitPath $gitCommand.Source -RepositoryRoot $root -Name $base
  if ($headAtConfirmation -cne $headBefore) {
    throw "HEAD changed from '$headBefore' to '$headAtConfirmation'; review the branch plan again."
  }
  if ($baseHeadAtConfirmation -cne $baseHead) {
    throw "Base branch '$base' changed from '$baseHead' to '$baseHeadAtConfirmation'; review the branch plan again."
  }

  $createResult = Invoke-MartixGit -GitPath $gitCommand.Source -RepositoryRoot $root -Arguments $arguments
  $verifyRoot = if ($resolvedWorktreePath) {
    Get-MartixRepositoryRoot -RepositoryPath $resolvedWorktreePath
  }
  else {
    $root
  }
  $verifyBranch = Get-MartixCurrentBranch -GitPath $gitCommand.Source -RepositoryRoot $verifyRoot
  $verifyHead = Get-MartixHead -GitPath $gitCommand.Source -RepositoryRoot $verifyRoot
  $verifyStatus = Get-MartixStatusText -GitPath $gitCommand.Source -RepositoryRoot $verifyRoot
  if ($verifyBranch -cne $BranchName) {
    throw "Post-mutation branch verification failed: expected '$BranchName', found '$verifyBranch'."
  }
  if ($verifyHead -cne $baseHead) {
    throw "Post-mutation HEAD verification failed: expected '$baseHead', found '$verifyHead'."
  }

  if ($resolvedWorktreePath) {
    $statusAfter = Get-MartixStatusText -GitPath $gitCommand.Source -RepositoryRoot $root
    if ($statusAfter -cne $statusBefore) {
      throw 'Post-mutation worktree status changed unexpectedly; the created branch is retained for review.'
    }
    if (-not [string]::IsNullOrEmpty($verifyStatus)) {
      throw 'Post-mutation worktree is not clean; the created branch is retained for review.'
    }
  }
  elseif ($verifyStatus -cne $statusBefore) {
    throw 'Post-mutation worktree status changed unexpectedly; the created branch is retained for review.'
  }

  $result.Confirmation = 'received'
  $result.Result = 'completed'
  $result.WorktreePath = if ($resolvedWorktreePath) { $verifyRoot } else { $null }
  $result.HeadAfter = $verifyHead
  $result.BranchAfter = $verifyBranch
  $result.GitOutput = ($createResult.StandardOutput + $createResult.StandardError).Trim()
  Write-MartixResult -Result ([pscustomobject] $result) -Json:$Json
  exit 0
}
catch {
  $result = [pscustomobject]@{
    Valid      = $false
    Repository = $RepositoryPath
    BranchName = $BranchName
    Decision   = 'block'
    Result     = 'failed'
    Errors     = @($_.Exception.Message)
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 2
}
