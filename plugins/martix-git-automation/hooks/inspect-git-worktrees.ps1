[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [string] $BaseBranch,

  [Parameter()]
  [AllowEmptyCollection()]
  [string[]] $SelectedBranch = @(),

  [Parameter()]
  [switch] $Fetch,

  [Parameter()]
  [switch] $RemoteEvidence,

  [Parameter()]
  [switch] $PruneWorktreeMetadata,

  [Parameter()]
  [switch] $Apply,

  [Parameter()]
  [switch] $Json
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

function Get-MartixPathKey {
  param([Parameter(Mandatory)][string] $Path)

  try { return [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/') }
  catch { return $Path.TrimEnd('\', '/') }
}

function Get-MartixOrphanReport {
  param(
    [Parameter(Mandatory)] [string] $RepositoryRoot,
    [Parameter(Mandatory)] [object] $Config,
    [Parameter(Mandatory)] [object[]] $RegisteredWorktrees
  )

  $registered = [System.Collections.Generic.HashSet[string]]::new(
    [System.StringComparer]::OrdinalIgnoreCase
  )
  foreach ($worktree in @($RegisteredWorktrees)) {
    if ($null -ne $worktree.Path) {
      [void] $registered.Add((Get-MartixPathKey -Path ([string] $worktree.Path)))
    }
  }

  $reports = [System.Collections.Generic.List[object]]::new()
  foreach ($configuredRoot in @($Config.worktree.scanRoots)) {
    $scanRoot = if ([System.IO.Path]::IsPathRooted($configuredRoot)) {
      [System.IO.Path]::GetFullPath($configuredRoot)
    }
    else {
      [System.IO.Path]::GetFullPath((Join-Path $RepositoryRoot $configuredRoot))
    }
    if (-not (Test-Path -LiteralPath $scanRoot -PathType Container)) {
      [void] $reports.Add([pscustomobject]@{
          Path = $scanRoot
          State = 'Unknown'
          Candidate = $false
          Reason = 'Configured scan root does not exist.'
        })
      continue
    }
    $rootItem = Get-Item -LiteralPath $scanRoot -Force
    if ($rootItem.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
      [void] $reports.Add([pscustomobject]@{
          Path = $scanRoot
          State = 'RetainedReparseRoot'
          Candidate = $false
          Reason = 'Configured scan root is a reparse point.'
        })
      continue
    }

    foreach ($directory in @(Get-ChildItem -LiteralPath $scanRoot -Directory -Force -ErrorAction SilentlyContinue)) {
      $pathKey = Get-MartixPathKey -Path $directory.FullName
      if ($registered.Contains($pathKey)) { continue }
      $isReparse = [bool] ($directory.Attributes -band [System.IO.FileAttributes]::ReparsePoint)
      $hasGitEntry = $false
      $isEmpty = $false
      try {
        $children = @(Get-ChildItem -LiteralPath $directory.FullName -Force -ErrorAction Stop)
        $hasGitEntry = @($children | Where-Object { $_.Name -eq '.git' }).Count -gt 0
        $isEmpty = $children.Count -eq 0
      }
      catch {
        [void] $reports.Add([pscustomobject]@{
            Path = $directory.FullName
            State = 'Unknown'
            Candidate = $false
            Reason = 'Directory contents could not be inspected.'
          })
        continue
      }
      if ($isEmpty -and -not $isReparse -and -not $hasGitEntry) {
        [void] $reports.Add([pscustomobject]@{
            Path = $directory.FullName
            State = 'EmptyOrphanCandidate'
            Candidate = $false
            Reason = 'Empty, non-reparse, non-Git directory below a configured scan root; removal remains a separate explicit operation.'
          })
      }
      else {
        $reason = if ($isReparse) { 'Reparse point retained.' }
        elseif ($hasGitEntry) { 'Directory contains a .git entry.' }
        else { 'Directory is non-empty.' }
        [void] $reports.Add([pscustomobject]@{
            Path = $directory.FullName
            State = 'RetainedOrphan'
            Candidate = $false
            Reason = $reason
          })
      }
    }
  }
  return $reports.ToArray()
}

try {
  $root = Get-MartixRepositoryRoot -RepositoryPath $RepositoryPath
  $config = Read-MartixGitConfig -RepositoryRoot $root
  $cleanupScript = Join-Path $root 'scripts\git-cleanup.ps1'
  if (-not (Test-Path -LiteralPath $cleanupScript -PathType Leaf)) {
    throw "The authoritative cleanup engine was not found: $cleanupScript"
  }
  if ($Apply -and @($SelectedBranch).Count -eq 0) {
    throw 'Apply requires one or more explicitly selected branch names or refs.'
  }

  $cleanupArguments = @{
    RepositoryPath = $root
    ErrorAction = 'Continue'
    Confirm = $false
  }
  if (-not [string]::IsNullOrWhiteSpace($BaseBranch)) { $cleanupArguments.Base = $BaseBranch }
  if (@($SelectedBranch).Count -gt 0) { $cleanupArguments.CandidateBranch = @($SelectedBranch) }
  if ($Fetch) { $cleanupArguments.Fetch = $true }
  if ($RemoteEvidence) { $cleanupArguments.GitHubMerged = $true }
  if ($PruneWorktreeMetadata) { $cleanupArguments.PruneWorktreeMetadata = $true }
  if ($Apply) { $cleanupArguments.Apply = $true }
  if ($WhatIfPreference) { $cleanupArguments.WhatIf = $true }

  $invocationErrors = [System.Collections.Generic.List[string]]::new()
  $cleanupOutput = @()
  try {
    $cleanupOutput = @(& $cleanupScript @cleanupArguments 2>&1)
  }
  catch {
    [void] $invocationErrors.Add($_.Exception.Message)
  }
  $cleanupResult = @(
    $cleanupOutput |
      Where-Object { $_.PSTypeNames -contains 'MartiX.GitCleanupResult' } |
      Select-Object -Last 1
  ) | Select-Object -First 1
  foreach ($errorRecord in @($cleanupOutput | Where-Object { $_ -is [System.Management.Automation.ErrorRecord] })) {
    [void] $invocationErrors.Add($errorRecord.ToString())
  }
  if ($null -eq $cleanupResult) {
    throw "Cleanup engine returned no structured result. $($invocationErrors -join ' ')"
  }

  $orphans = @(Get-MartixOrphanReport -RepositoryRoot $root -Config $config `
      -RegisteredWorktrees @($cleanupResult.Worktrees))
  $result = [pscustomobject]@{
    Valid = $true
    Repository = $root
    Mode = if ($Apply) { 'apply' } else { 'audit' }
    Decision = if ($Apply) { 'perform' } else { 'ask' }
    Confirmation = if ($Apply) { 'requested by -Apply; selected branches only' } else { 'required for any mutation' }
    SelectedBranches = @($SelectedBranch)
    Cleanup = $cleanupResult
    Orphans = $orphans
    InvocationErrors = @($invocationErrors)
    Result = if ($Apply) { 'completed' } else { 'unresolved' }
  }

  if (-not $Apply) {
    $result.Result = 'completed'
  }
  elseif (-not $PSCmdlet.ShouldProcess(($SelectedBranch -join ', '), 'Apply selected cleanup candidates')) {
    $result.Result = 'skipped'
    $result.Confirmation = 'declined'
    $result.Cleanup = $null
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 0
}
catch {
  $result = [pscustomobject]@{
    Valid = $false
    Repository = $RepositoryPath
    Result = 'blocked'
    Errors = @($_.Exception.Message)
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 2
}
