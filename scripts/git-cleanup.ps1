<#
.SYNOPSIS
Audits and removes clean local Git worktrees and branches merged into a base branch.

.DESCRIPTION
Inspects local branch-attached worktrees and local branches. Audit mode is the
default. When -Apply is supplied, the script removes clean, unlocked worktrees
whose branches are merged into the selected base, then deletes those local
branches. The current branch, local main, the selected local base branch, dirty
worktrees, locked worktrees, and worktrees whose state cannot be verified are
always retained.

Missing worktree paths are retained by default because an unavailable volume
cannot be distinguished safely from abandoned metadata. Use
-PruneWorktreeMetadata to opt into Git's configured expiry policy.

By default, merge evidence is Git ancestry. -GitHubMerged additionally recognizes
squash and rebase merges when a merged pull request's recorded head object ID
exactly matches the current local branch tip.

.PARAMETER RepositoryPath
Repository or worktree path to inspect. Defaults to the current directory.

.PARAMETER Fetch
Fetches all remotes without pruning remote-tracking refs before resolving the
base branch. A fetched short -Base value prefers origin/<name>.

.PARAMETER Apply
Enables worktree and local branch removal. Without this switch, the script only
audits and returns the actions it would take.

.PARAMETER Base
Local branch, remote-tracking branch, or fully qualified branch ref used as the
merge base. When omitted, origin/HEAD, origin/main, local main, origin/master,
and local master are tried in that order.

.PARAMETER GitHubMerged
Also recognizes squash or rebase merges by querying merged GitHub pull requests.
The pull request head object ID must exactly match the local branch tip. Requires
an authenticated GitHub CLI.

.PARAMETER PruneWorktreeMetadata
Allows Git to prune missing worktree registrations that have reached its
configured expiry. Without this switch, missing paths and their branches are
retained even when -Apply is supplied.

.EXAMPLE
./git-cleanup.ps1 -RepositoryPath . -Fetch

Refreshes remote-tracking refs and returns an audit without deleting anything.

.EXAMPLE
./git-cleanup.ps1 -RepositoryPath C:\src\project -Fetch -Apply -GitHubMerged -Confirm:$false

Performs unattended cleanup using ancestry and exact GitHub pull-request head
matches while suppressing confirmation prompts explicitly.

.EXAMPLE
./git-cleanup.ps1 -RepositoryPath . -Apply -WhatIf

Shows each mutation PowerShell would perform without changing the repository.

.EXAMPLE
./git-cleanup.ps1 -RepositoryPath . -PruneWorktreeMetadata

Audits the cleanup that would follow Git's configured worktree metadata expiry.

.OUTPUTS
System.Management.Automation.PSCustomObject. Returns one cleanup result containing
base selection, worktree states, candidates, removals, retained branches, and
failures.

.NOTES
Requires PowerShell 7+, Git, and optionally GitHub CLI for -GitHubMerged. Remote
branches, remote-tracking refs, and unreachable Git objects are never removed.
#>
#Requires -Version 7.0

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
[OutputType([System.Management.Automation.PSCustomObject])]
param(
  [Parameter()]
  [ValidateNotNullOrEmpty()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [switch] $Fetch,

  [Parameter()]
  [switch] $Apply,

  [Parameter()]
  [ValidateNotNullOrEmpty()]
  [string] $Base,

  [Parameter()]
  [switch] $GitHubMerged,

  [Parameter()]
  [switch] $PruneWorktreeMetadata
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptCmdlet = $PSCmdlet
$failures = [System.Collections.Generic.List[System.Management.Automation.ErrorRecord]]::new()
$candidates = [System.Collections.Generic.List[object]]::new()
$deletedBranches = [System.Collections.Generic.List[string]]::new()
$removedWorktrees = [System.Collections.Generic.List[string]]::new()

function New-CleanupErrorRecord {
  [CmdletBinding()]
  [OutputType([System.Management.Automation.ErrorRecord])]
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Message,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $ErrorId,

    [Parameter(Mandatory)]
    [System.Management.Automation.ErrorCategory] $Category,

    [Parameter()]
    [AllowNull()]
    [object] $TargetObject
  )

  $exception = [System.InvalidOperationException]::new($Message)
  [System.Management.Automation.ErrorRecord]::new(
    $exception,
    $ErrorId,
    $Category,
    $TargetObject
  )
}

function Add-CleanupFailure {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Message,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $ErrorId,

    [Parameter(Mandatory)]
    [System.Management.Automation.ErrorCategory] $Category,

    [Parameter()]
    [AllowNull()]
    [object] $TargetObject
  )

  $record = New-CleanupErrorRecord `
    -Message $Message `
    -ErrorId $ErrorId `
    -Category $Category `
    -TargetObject $TargetObject
  [void] $failures.Add($record)
  $previousErrorActionPreference = $ErrorActionPreference
  $ErrorActionPreference = 'Continue'
  try {
    $PSCmdlet.WriteError($record)
  }
  finally {
    $ErrorActionPreference = $previousErrorActionPreference
  }
}

function Invoke-NativeCommand {
  [CmdletBinding()]
  [OutputType([System.Management.Automation.PSCustomObject])]
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $FilePath,

    [Parameter()]
    [AllowEmptyCollection()]
    [string[]] $ArgumentList = @(),

    [Parameter()]
    [AllowNull()]
    [string] $WorkingDirectory,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [int[]] $AllowedExitCode = @(0),

    [Parameter()]
    [switch] $IgnoreExitCode
  )

  $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
  $startInfo.FileName = $FilePath
  $startInfo.UseShellExecute = $false
  $startInfo.RedirectStandardOutput = $true
  $startInfo.RedirectStandardError = $true
  $startInfo.StandardOutputEncoding = [System.Text.UTF8Encoding]::new($false)
  $startInfo.StandardErrorEncoding = [System.Text.UTF8Encoding]::new($false)
  if (-not [string]::IsNullOrWhiteSpace($WorkingDirectory)) {
    $startInfo.WorkingDirectory = $WorkingDirectory
  }

  foreach ($argument in $ArgumentList) {
    [void] $startInfo.ArgumentList.Add($argument)
  }

  try {
    $process = [System.Diagnostics.Process]::Start($startInfo)
    $standardOutputTask = $process.StandardOutput.ReadToEndAsync()
    $standardErrorTask = $process.StandardError.ReadToEndAsync()
    $process.WaitForExit()
    $standardOutput = $standardOutputTask.GetAwaiter().GetResult()
    $standardError = $standardErrorTask.GetAwaiter().GetResult()
  }
  catch {
    $record = [System.Management.Automation.ErrorRecord]::new(
      $_.Exception,
      'GitCleanup.NativeCommandStartFailed',
      [System.Management.Automation.ErrorCategory]::ResourceUnavailable,
      $FilePath
    )
    $PSCmdlet.ThrowTerminatingError($record)
  }

  $result = [pscustomobject]@{
    FilePath       = $FilePath
    ArgumentList   = @($ArgumentList)
    ExitCode       = $process.ExitCode
    StandardOutput = $standardOutput
    StandardError  = $standardError
  }

  if (-not $IgnoreExitCode -and $result.ExitCode -notin $AllowedExitCode) {
    $detail = $result.StandardError.Trim()
    if ([string]::IsNullOrWhiteSpace($detail)) {
      $detail = $result.StandardOutput.Trim()
    }
    if ([string]::IsNullOrWhiteSpace($detail)) {
      $detail = 'The command did not provide diagnostic output.'
    }

    $target = [pscustomobject]@{
      FilePath     = $FilePath
      ArgumentList = @($ArgumentList)
      ExitCode     = $result.ExitCode
    }
    $record = New-CleanupErrorRecord `
      -Message "Native command failed with exit code $($result.ExitCode): $detail" `
      -ErrorId 'GitCleanup.NativeCommandFailed' `
      -Category ([System.Management.Automation.ErrorCategory]::InvalidResult) `
      -TargetObject $target
    $PSCmdlet.ThrowTerminatingError($record)
  }

  return $result
}

function ConvertTo-NativeLineArray {
  [CmdletBinding()]
  [OutputType([string[]])]
  param(
    [Parameter()]
    [AllowEmptyString()]
    [string] $Text
  )

  $lines = [System.Collections.Generic.List[string]]::new()
  if ([string]::IsNullOrEmpty($Text)) {
    return $lines.ToArray()
  }

  foreach ($line in [regex]::Split($Text, '\r?\n')) {
    if (-not [string]::IsNullOrWhiteSpace($line)) {
      [void] $lines.Add($line)
    }
  }

  return $lines.ToArray()
}

$gitCommand = Get-Command -Name git -CommandType Application -ErrorAction SilentlyContinue |
Select-Object -First 1
if ($null -eq $gitCommand) {
  $scriptCmdlet.ThrowTerminatingError((New-CleanupErrorRecord `
        -Message 'Git executable was not found on PATH.' `
        -ErrorId 'GitCleanup.GitNotFound' `
        -Category ([System.Management.Automation.ErrorCategory]::ResourceUnavailable) `
        -TargetObject 'git'))
}
$gitPath = $gitCommand.Source

try {
  $repositoryInputPath = (Resolve-Path -LiteralPath $RepositoryPath -ErrorAction Stop).Path
}
catch {
  $scriptCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(
      $_.Exception,
      'GitCleanup.RepositoryPathNotFound',
      [System.Management.Automation.ErrorCategory]::ObjectNotFound,
      $RepositoryPath
    ))
}

$repositoryProbe = Invoke-NativeCommand `
  -FilePath $gitPath `
  -ArgumentList @('-C', $repositoryInputPath, 'rev-parse', '--show-toplevel')
$repositoryRoot = $repositoryProbe.StandardOutput.Trim()
if ([string]::IsNullOrWhiteSpace($repositoryRoot)) {
  $scriptCmdlet.ThrowTerminatingError((New-CleanupErrorRecord `
        -Message "Git did not return a repository root for '$repositoryInputPath'." `
        -ErrorId 'GitCleanup.RepositoryRootMissing' `
        -Category ([System.Management.Automation.ErrorCategory]::InvalidData) `
        -TargetObject $repositoryInputPath))
}

function Invoke-Git {
  [CmdletBinding()]
  [OutputType([System.Management.Automation.PSCustomObject])]
  param(
    [Parameter(Mandatory)]
    [AllowEmptyCollection()]
    [string[]] $ArgumentList,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [int[]] $AllowedExitCode = @(0),

    [Parameter()]
    [switch] $IgnoreExitCode
  )

  $nativeArguments = @('-C', $repositoryRoot) + $ArgumentList
  Invoke-NativeCommand `
    -FilePath $gitPath `
    -ArgumentList $nativeArguments `
    -AllowedExitCode $AllowedExitCode `
    -IgnoreExitCode:$IgnoreExitCode
}

function Test-GitRef {
  [CmdletBinding()]
  [OutputType([bool])]
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Ref
  )

  $result = Invoke-Git `
    -ArgumentList @('show-ref', '--verify', '--quiet', $Ref) `
    -AllowedExitCode @(0, 1)
  return ($result.ExitCode -eq 0)
}

function New-BaseInfo {
  [CmdletBinding()]
  [OutputType([System.Management.Automation.PSCustomObject])]
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Ref
  )

  $resolvedRef = $Ref
  $visitedRefs = [System.Collections.Generic.HashSet[string]]::new(
    [System.StringComparer]::Ordinal
  )
  while ($true) {
    if (-not $visitedRefs.Add($resolvedRef)) {
      $PSCmdlet.ThrowTerminatingError((New-CleanupErrorRecord `
            -Message "Symbolic base branch contains a reference cycle: $Ref" `
            -ErrorId 'GitCleanup.SymbolicBaseCycle' `
            -Category ([System.Management.Automation.ErrorCategory]::InvalidData) `
            -TargetObject $Ref))
    }

    $symbolicResult = Invoke-Git `
      -ArgumentList @('symbolic-ref', '--quiet', $resolvedRef) `
      -AllowedExitCode @(0, 1)
    if ($symbolicResult.ExitCode -eq 1) {
      break
    }

    $symbolicTarget = $symbolicResult.StandardOutput.Trim()
    if ([string]::IsNullOrWhiteSpace($symbolicTarget)) {
      $PSCmdlet.ThrowTerminatingError((New-CleanupErrorRecord `
            -Message "Symbolic base branch has no target: $resolvedRef" `
            -ErrorId 'GitCleanup.SymbolicBaseTargetMissing' `
            -Category ([System.Management.Automation.ErrorCategory]::InvalidData) `
            -TargetObject $Ref))
    }
    $resolvedRef = $symbolicTarget
  }

  if ($resolvedRef.StartsWith('refs/heads/', [System.StringComparison]::Ordinal)) {
    $branchName = $resolvedRef.Substring('refs/heads/'.Length)
    return [pscustomobject]@{
      Ref               = $resolvedRef
      BranchName        = $branchName
      ProtectedLocalRef = $resolvedRef
    }
  }

  $remoteMatch = [regex]::Match($resolvedRef, '^refs/remotes/[^/]+/(?<branch>.+)$')
  if ($remoteMatch.Success) {
    $branchName = $remoteMatch.Groups['branch'].Value
    return [pscustomobject]@{
      Ref               = $resolvedRef
      BranchName        = $branchName
      ProtectedLocalRef = "refs/heads/$branchName"
    }
  }

  $PSCmdlet.ThrowTerminatingError((New-CleanupErrorRecord `
        -Message "Base must resolve to a local or remote-tracking branch: $Ref" `
        -ErrorId 'GitCleanup.InvalidBaseRef' `
        -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
        -TargetObject $Ref))
}

function Resolve-CleanupBase {
  [CmdletBinding()]
  [OutputType([System.Management.Automation.PSCustomObject])]
  param(
    [Parameter()]
    [AllowNull()]
    [string] $InputRef,

    [Parameter()]
    [switch] $PreferOrigin
  )

  if (-not [string]::IsNullOrWhiteSpace($InputRef)) {
    if ($InputRef.StartsWith('refs/heads/', [System.StringComparison]::Ordinal) -or
      $InputRef.StartsWith('refs/remotes/', [System.StringComparison]::Ordinal)) {
      if (-not (Test-GitRef -Ref $InputRef)) {
        $PSCmdlet.ThrowTerminatingError((New-CleanupErrorRecord `
              -Message "Base branch does not exist: $InputRef" `
              -ErrorId 'GitCleanup.BaseRefNotFound' `
              -Category ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
              -TargetObject $InputRef))
      }
      return New-BaseInfo -Ref $InputRef
    }

    $candidatesToTry = [System.Collections.Generic.List[string]]::new()
    [void] $candidatesToTry.Add("refs/remotes/$InputRef")
    if ($PreferOrigin) {
      [void] $candidatesToTry.Add("refs/remotes/origin/$InputRef")
    }
    [void] $candidatesToTry.Add("refs/heads/$InputRef")
    if (-not $PreferOrigin) {
      [void] $candidatesToTry.Add("refs/remotes/origin/$InputRef")
    }

    foreach ($candidateRef in $candidatesToTry) {
      if (Test-GitRef -Ref $candidateRef) {
        return New-BaseInfo -Ref $candidateRef
      }
    }

    $PSCmdlet.ThrowTerminatingError((New-CleanupErrorRecord `
          -Message "Base branch does not exist: $InputRef" `
          -ErrorId 'GitCleanup.BaseRefNotFound' `
          -Category ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
          -TargetObject $InputRef))
  }

  $originHeadResult = Invoke-Git `
    -ArgumentList @('symbolic-ref', '--quiet', 'refs/remotes/origin/HEAD') `
    -AllowedExitCode @(0, 1)
  $originHead = $originHeadResult.StandardOutput.Trim()
  if (-not [string]::IsNullOrWhiteSpace($originHead) -and (Test-GitRef -Ref $originHead)) {
    return New-BaseInfo -Ref $originHead
  }

  foreach ($candidateRef in @(
      'refs/remotes/origin/main',
      'refs/heads/main',
      'refs/remotes/origin/master',
      'refs/heads/master'
    )) {
    if (Test-GitRef -Ref $candidateRef) {
      return New-BaseInfo -Ref $candidateRef
    }
  }

  $PSCmdlet.ThrowTerminatingError((New-CleanupErrorRecord `
        -Message 'Could not detect a base branch; use -Base <branch-or-ref>.' `
        -ErrorId 'GitCleanup.BaseRefNotDetected' `
        -Category ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
        -TargetObject $repositoryRoot))
}

function Get-GitWorktree {
  [CmdletBinding()]
  [OutputType([System.Management.Automation.PSCustomObject[]])]
  param()

  $result = Invoke-Git -ArgumentList @('worktree', 'list', '--porcelain', '-z')
  $tokens = $result.StandardOutput.Split(
    [char[]] @([char] 0),
    [System.StringSplitOptions]::None
  )
  $items = [System.Collections.Generic.List[object]]::new()
  $path = $null
  $head = $null
  $branchRef = $null
  $locked = $false
  $lockReason = $null
  $prunable = $false
  $prunableReason = $null
  $detached = $false

  foreach ($token in $tokens) {
    if ($token.Length -eq 0) {
      if ($null -ne $path) {
        [void] $items.Add([pscustomobject]@{
            Path           = $path
            Head           = $head
            BranchRef      = $branchRef
            Locked         = $locked
            LockReason     = $lockReason
            Prunable       = $prunable
            PrunableReason = $prunableReason
            Detached       = $detached
          })
      }
      $path = $null
      $head = $null
      $branchRef = $null
      $locked = $false
      $lockReason = $null
      $prunable = $false
      $prunableReason = $null
      $detached = $false
      continue
    }

    if ($token.StartsWith('worktree ', [System.StringComparison]::Ordinal)) {
      $path = $token.Substring('worktree '.Length)
    }
    elseif ($token.StartsWith('HEAD ', [System.StringComparison]::Ordinal)) {
      $head = $token.Substring('HEAD '.Length)
    }
    elseif ($token.StartsWith('branch ', [System.StringComparison]::Ordinal)) {
      $branchRef = $token.Substring('branch '.Length)
    }
    elseif ($token -eq 'detached') {
      $detached = $true
    }
    elseif ($token.StartsWith('locked', [System.StringComparison]::Ordinal)) {
      $locked = $true
      if ($token.Length -gt 'locked'.Length) {
        $lockReason = $token.Substring('locked'.Length).TrimStart()
      }
    }
    elseif ($token.StartsWith('prunable', [System.StringComparison]::Ordinal)) {
      $prunable = $true
      if ($token.Length -gt 'prunable'.Length) {
        $prunableReason = $token.Substring('prunable'.Length).TrimStart()
      }
    }
  }

  if ($null -ne $path) {
    [void] $items.Add([pscustomobject]@{
        Path           = $path
        Head           = $head
        BranchRef      = $branchRef
        Locked         = $locked
        LockReason     = $lockReason
        Prunable       = $prunable
        PrunableReason = $prunableReason
        Detached       = $detached
      })
  }

  return $items.ToArray()
}

function Get-WorktreeStatus {
  [CmdletBinding()]
  [OutputType([System.Management.Automation.PSCustomObject])]
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Path
  )

  if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
    return [pscustomobject]@{
      State  = 'Missing'
      Detail = $null
    }
  }

  $result = Invoke-NativeCommand `
    -FilePath $gitPath `
    -ArgumentList @('-C', $Path, 'status', '--porcelain=v1', '--untracked-files=all') `
    -IgnoreExitCode
  if ($result.ExitCode -ne 0) {
    $detail = $result.StandardError.Trim()
    if ([string]::IsNullOrWhiteSpace($detail)) {
      $detail = $result.StandardOutput.Trim()
    }
    return [pscustomobject]@{
      State  = 'Error'
      Detail = $detail
    }
  }

  return [pscustomobject]@{
    State  = if ([string]::IsNullOrEmpty($result.StandardOutput)) { 'Clean' } else { 'Changed' }
    Detail = $result.StandardOutput
  }
}

function New-WorktreeMap {
  [CmdletBinding()]
  [OutputType([System.Collections.Generic.Dictionary[string, object]])]
  param(
    [Parameter()]
    [AllowEmptyCollection()]
    [object[]] $Worktree = @()
  )

  $map = [System.Collections.Generic.Dictionary[string, object]]::new(
    [System.StringComparer]::Ordinal
  )
  foreach ($item in $Worktree) {
    if (-not [string]::IsNullOrWhiteSpace([string] $item.BranchRef)) {
      $map[$item.BranchRef] = $item
    }
  }
  return $map
}

function Test-ProtectedBranch {
  [CmdletBinding()]
  [OutputType([bool])]
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $BranchRef
  )

  return (
    $BranchRef -ceq 'refs/heads/main' -or
    $BranchRef -ceq $baseInfo.ProtectedLocalRef
  )
}

$fetchPerformed = $false
if ($Fetch) {
  if ($scriptCmdlet.ShouldProcess($repositoryRoot, 'Fetch all remotes without pruning')) {
    [void] (Invoke-Git -ArgumentList @('fetch', '--all', '--no-prune'))
    $fetchPerformed = $true
  }
}

$baseInfo = Resolve-CleanupBase -InputRef $Base -PreferOrigin:$fetchPerformed
$baseCommitResult = Invoke-Git `
  -ArgumentList @('rev-parse', '--verify', '--quiet', "$($baseInfo.Ref)^{commit}")
$baseObjectId = $baseCommitResult.StandardOutput.Trim()
if ([string]::IsNullOrWhiteSpace($baseObjectId)) {
  $scriptCmdlet.ThrowTerminatingError((New-CleanupErrorRecord `
        -Message "Base branch did not resolve to a commit: $($baseInfo.Ref)" `
        -ErrorId 'GitCleanup.BaseCommitMissing' `
        -Category ([System.Management.Automation.ErrorCategory]::InvalidData) `
        -TargetObject $baseInfo.Ref))
}
$currentBranchResult = Invoke-Git `
  -ArgumentList @('symbolic-ref', '--quiet', 'HEAD') `
  -AllowedExitCode @(0, 1)
$currentBranchRef = $currentBranchResult.StandardOutput.Trim()

$ghPath = $null
$githubRepository = $null
if ($GitHubMerged) {
  $ghCommand = Get-Command -Name gh -CommandType Application -ErrorAction SilentlyContinue |
  Select-Object -First 1
  if ($null -eq $ghCommand) {
    $scriptCmdlet.ThrowTerminatingError((New-CleanupErrorRecord `
          -Message '-GitHubMerged requires GitHub CLI (gh).' `
          -ErrorId 'GitCleanup.GitHubCliNotFound' `
          -Category ([System.Management.Automation.ErrorCategory]::ResourceUnavailable) `
          -TargetObject 'gh'))
  }
  $ghPath = $ghCommand.Source
  $repositoryResult = Invoke-NativeCommand `
    -FilePath $ghPath `
    -ArgumentList @('repo', 'view', '--json', 'nameWithOwner', '--jq', '.nameWithOwner') `
    -WorkingDirectory $repositoryRoot
  $githubRepository = $repositoryResult.StandardOutput.Trim()
  if ([string]::IsNullOrWhiteSpace($githubRepository)) {
    $scriptCmdlet.ThrowTerminatingError((New-CleanupErrorRecord `
          -Message 'GitHub CLI did not identify a repository.' `
          -ErrorId 'GitCleanup.GitHubRepositoryMissing' `
          -Category ([System.Management.Automation.ErrorCategory]::InvalidData) `
          -TargetObject $repositoryRoot))
  }
}

$worktrees = @(Get-GitWorktree)
$worktreeStates = [System.Collections.Generic.List[object]]::new()
$worktreeStateByPath = [System.Collections.Generic.Dictionary[string, object]]::new(
  [System.StringComparer]::OrdinalIgnoreCase
)
$worktreeInspectionFailed = $false
foreach ($worktree in $worktrees) {
  if ($worktree.Locked) {
    $status = [pscustomobject]@{
      State  = 'Locked'
      Detail = $worktree.LockReason
    }
  }
  else {
    $status = Get-WorktreeStatus -Path $worktree.Path
  }

  if ($status.State -eq 'Error') {
    $worktreeInspectionFailed = $true
    Add-CleanupFailure `
      -Message "Could not inspect worktree '$($worktree.Path)': $($status.Detail)" `
      -ErrorId 'GitCleanup.WorktreeInspectionFailed' `
      -Category ([System.Management.Automation.ErrorCategory]::InvalidData) `
      -TargetObject $worktree.Path
  }

  $stateRecord = [pscustomobject]@{
    Path      = $worktree.Path
    BranchRef = $worktree.BranchRef
    Head      = $worktree.Head
    State     = $status.State
    Locked    = $worktree.Locked
    Prunable  = $worktree.Prunable
    Detail    = $status.Detail
  }
  [void] $worktreeStates.Add($stateRecord)
  $worktreeStateByPath[$worktree.Path] = $stateRecord
}

$metadataAction = 'Audit'
$metadataOutput = $null
if (-not $PruneWorktreeMetadata) {
  $metadataAction = 'RetainedByDefault'
}
elseif ($worktreeInspectionFailed) {
  $metadataAction = 'SkippedInspectionFailure'
}
elseif ($Apply) {
  if ($scriptCmdlet.ShouldProcess($repositoryRoot, 'Prune expired worktree metadata')) {
    $pruneResult = Invoke-Git `
      -ArgumentList @('worktree', 'prune', '--verbose') `
      -IgnoreExitCode
    $metadataOutput = ($pruneResult.StandardOutput + $pruneResult.StandardError).Trim()
    if ($pruneResult.ExitCode -eq 0) {
      $metadataAction = 'PrunedEligible'
      $worktrees = @(Get-GitWorktree)
    }
    else {
      $metadataAction = 'Failed'
      Add-CleanupFailure `
        -Message "Could not prune expired worktree metadata: $metadataOutput" `
        -ErrorId 'GitCleanup.WorktreePruneFailed' `
        -Category ([System.Management.Automation.ErrorCategory]::InvalidResult) `
        -TargetObject $repositoryRoot
    }
  }
  else {
    $metadataAction = 'SkippedByShouldProcess'
  }
}
else {
  $pruneResult = Invoke-Git `
    -ArgumentList @('worktree', 'prune', '--dry-run', '--verbose') `
    -IgnoreExitCode
  $metadataOutput = ($pruneResult.StandardOutput + $pruneResult.StandardError).Trim()
  if ($pruneResult.ExitCode -ne 0) {
    $metadataAction = 'AuditFailed'
    Add-CleanupFailure `
      -Message "Could not inspect expired worktree metadata: $metadataOutput" `
      -ErrorId 'GitCleanup.WorktreePruneAuditFailed' `
      -Category ([System.Management.Automation.ErrorCategory]::InvalidResult) `
      -TargetObject $repositoryRoot
  }
  else {
    $metadataAction = 'WouldPruneEligible'
    $worktrees = @(
      $worktrees |
      Where-Object { -not ($_.Prunable -and -not $_.Locked) }
    )
  }
}

$worktreeByBranch = New-WorktreeMap -Worktree $worktrees

function Remove-VerifiedLocalBranch {
  [CmdletBinding()]
  [OutputType([System.Management.Automation.PSCustomObject])]
  param(
    [Parameter(Mandatory)]
    [ValidatePattern('^refs/heads/.+')]
    [string] $BranchRef,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $ExpectedObjectId
  )

  $deleteResult = Invoke-Git `
    -ArgumentList @('update-ref', '-d', $BranchRef, $ExpectedObjectId) `
    -IgnoreExitCode
  if ($deleteResult.ExitCode -eq 0) {
    return [pscustomobject]@{
      Status = 'Deleted'
      Detail = $null
    }
  }

  $currentRefResult = Invoke-Git `
    -ArgumentList @('show-ref', '--verify', '--hash', $BranchRef) `
    -IgnoreExitCode
  if ($currentRefResult.ExitCode -eq 1) {
    return [pscustomobject]@{
      Status = 'Missing'
      Detail = 'The branch was deleted by another process.'
    }
  }

  $currentObjectId = $currentRefResult.StandardOutput.Trim()
  if ($currentRefResult.ExitCode -eq 0 -and $currentObjectId -cne $ExpectedObjectId) {
    return [pscustomobject]@{
      Status = 'Changed'
      Detail = "The branch moved from $ExpectedObjectId to $currentObjectId before deletion."
    }
  }

  $detail = $deleteResult.StandardError.Trim()
  if ([string]::IsNullOrWhiteSpace($detail)) {
    $detail = $deleteResult.StandardOutput.Trim()
  }
  if ([string]::IsNullOrWhiteSpace($detail)) {
    $detail = 'Git could not atomically delete the verified branch ref.'
  }
  return [pscustomobject]@{
    Status = 'Error'
    Detail = $detail
  }
}

function Invoke-BranchCleanup {
  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  [OutputType([void])]
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $BranchRef,

    [Parameter(Mandatory)]
    [ValidateSet('Ancestry', 'GitHub')]
    [string] $Evidence,

    [Parameter()]
    [AllowNull()]
    [string] $ExpectedObjectId
  )

  $branchName = $BranchRef.Substring('refs/heads/'.Length)
  $candidate = [pscustomobject]@{
    Branch           = $branchName
    Ref              = $BranchRef
    VerifiedObjectId = $null
    MergeEvidence    = $Evidence
    WorktreePath     = $null
    State            = 'Pending'
    Action           = 'Retained'
    Reason           = $null
  }
  [void] $candidates.Add($candidate)

  if ($BranchRef -ceq $currentBranchRef) {
    $candidate.State = 'Current'
    $candidate.Reason = 'Currently checked out by the invoking worktree.'
    return
  }

  $tipResult = Invoke-Git `
    -ArgumentList @('rev-parse', '--verify', "$BranchRef^{commit}") `
    -IgnoreExitCode
  $verifiedObjectId = $tipResult.StandardOutput.Trim()
  if ($tipResult.ExitCode -ne 0 -or [string]::IsNullOrWhiteSpace($verifiedObjectId)) {
    $candidate.State = 'VerificationError'
    $candidate.Reason = $tipResult.StandardError.Trim()
    Add-CleanupFailure `
      -Message "Could not verify the current tip of '$branchName'." `
      -ErrorId 'GitCleanup.BranchTipVerificationFailed' `
      -Category ([System.Management.Automation.ErrorCategory]::InvalidResult) `
      -TargetObject $BranchRef
    return
  }
  $candidate.VerifiedObjectId = $verifiedObjectId

  if ($Evidence -eq 'Ancestry') {
    $mergeResult = Invoke-Git `
      -ArgumentList @('merge-base', '--is-ancestor', $verifiedObjectId, $baseObjectId) `
      -IgnoreExitCode
    if ($mergeResult.ExitCode -eq 1) {
      $candidate.State = 'Unmerged'
      $candidate.Reason = 'The branch is no longer an ancestor of the selected base.'
      return
    }
    if ($mergeResult.ExitCode -ne 0) {
      $candidate.State = 'VerificationError'
      $candidate.Reason = $mergeResult.StandardError.Trim()
      Add-CleanupFailure `
        -Message "Could not verify whether '$branchName' is merged into '$($baseInfo.BranchName)'." `
        -ErrorId 'GitCleanup.MergeVerificationFailed' `
        -Category ([System.Management.Automation.ErrorCategory]::InvalidResult) `
        -TargetObject $BranchRef
      return
    }
  }
  else {
    if ([string]::IsNullOrWhiteSpace($ExpectedObjectId) -or
      $verifiedObjectId -cne $ExpectedObjectId) {
      $candidate.State = 'ChangedAfterVerification'
      $candidate.Reason = 'The branch changed after GitHub merge verification.'
      return
    }
  }

  $worktree = $null
  if ($worktreeByBranch.TryGetValue($BranchRef, [ref] $worktree)) {
    $candidate.WorktreePath = $worktree.Path
  }

  if ($null -eq $worktree) {
    $candidate.State = 'MergedNoWorktree'
    $candidate.Reason = 'Merged branch has no registered worktree.'
    if (-not $Apply) {
      $candidate.Action = 'WouldDeleteBranch'
      return
    }

    if (-not $PSCmdlet.ShouldProcess($branchName, 'Delete merged local branch')) {
      $candidate.Action = 'SkippedByShouldProcess'
      return
    }

    $freshWorktreeByBranch = New-WorktreeMap -Worktree @(Get-GitWorktree)
    $freshWorktree = $null
    if ($freshWorktreeByBranch.TryGetValue($BranchRef, [ref] $freshWorktree)) {
      $candidate.WorktreePath = $freshWorktree.Path
      $candidate.State = 'WorktreeRegisteredAfterVerification'
      $candidate.Reason = 'The branch became attached to a worktree before deletion.'
      return
    }

    $deleteOutcome = Remove-VerifiedLocalBranch `
      -BranchRef $BranchRef `
      -ExpectedObjectId $verifiedObjectId
    switch ($deleteOutcome.Status) {
      'Deleted' {
        $candidate.Action = 'DeletedBranch'
        [void] $deletedBranches.Add($branchName)
      }
      'Missing' {
        $candidate.State = 'AlreadyDeleted'
        $candidate.Action = 'BranchAlreadyAbsent'
        $candidate.Reason = $deleteOutcome.Detail
      }
      'Changed' {
        $candidate.State = 'ChangedAfterVerification'
        $candidate.Reason = $deleteOutcome.Detail
      }
      default {
        $candidate.State = 'DeleteError'
        $candidate.Reason = $deleteOutcome.Detail
        Add-CleanupFailure `
          -Message "Could not delete local branch '$branchName': $($candidate.Reason)" `
          -ErrorId 'GitCleanup.BranchDeleteFailed' `
          -Category ([System.Management.Automation.ErrorCategory]::WriteError) `
          -TargetObject $BranchRef
      }
    }
    return
  }

  if ($worktree.Locked) {
    $candidate.State = 'Locked'
    $candidate.Reason = 'The registered worktree is locked.'
    return
  }

  $initialState = $null
  if ($worktreeStateByPath.TryGetValue($worktree.Path, [ref] $initialState) -and
    $initialState.State -eq 'Error') {
    $candidate.State = 'InspectionError'
    $candidate.Reason = $initialState.Detail
    return
  }

  $status = Get-WorktreeStatus -Path $worktree.Path
  switch ($status.State) {
    'Missing' {
      $candidate.State = 'Missing'
      $candidate.Reason = 'The registered worktree path is missing and its metadata is not eligible for pruning.'
      return
    }
    'Changed' {
      $candidate.State = 'Changed'
      $candidate.Reason = 'The worktree contains tracked or untracked changes.'
      return
    }
    'Error' {
      $candidate.State = 'InspectionError'
      $candidate.Reason = $status.Detail
      Add-CleanupFailure `
        -Message "Could not inspect worktree '$($worktree.Path)': $($status.Detail)" `
        -ErrorId 'GitCleanup.WorktreeInspectionFailed' `
        -Category ([System.Management.Automation.ErrorCategory]::InvalidData) `
        -TargetObject $worktree.Path
      return
    }
  }

  $candidate.State = 'MergedCleanWorktree'
  $candidate.Reason = 'Merged branch has a clean, unlocked worktree.'
  if (-not $Apply) {
    $candidate.Action = 'WouldRemoveWorktreeAndBranch'
    return
  }

  if (-not $PSCmdlet.ShouldProcess($worktree.Path, "Remove clean worktree for merged branch '$branchName'")) {
    $candidate.Action = 'SkippedByShouldProcess'
    return
  }

  $freshWorktreeByBranch = New-WorktreeMap -Worktree @(Get-GitWorktree)
  $freshWorktree = $null
  if (-not $freshWorktreeByBranch.TryGetValue($BranchRef, [ref] $freshWorktree)) {
    $candidate.State = 'WorktreeChangedAfterVerification'
    $candidate.Reason = 'The branch is no longer attached to the verified worktree.'
    return
  }
  if (-not [System.StringComparer]::OrdinalIgnoreCase.Equals(
      $worktree.Path,
      $freshWorktree.Path
    )) {
    $candidate.State = 'WorktreeChangedAfterVerification'
    $candidate.Reason = 'The branch moved to a different worktree path before removal.'
    return
  }
  if ($freshWorktree.Locked) {
    $candidate.State = 'Locked'
    $candidate.Reason = 'The worktree became locked before removal.'
    return
  }
  if ($freshWorktree.Head -cne $verifiedObjectId) {
    $candidate.State = 'ChangedAfterVerification'
    $candidate.Reason = 'The worktree branch changed after merge verification.'
    return
  }

  $status = Get-WorktreeStatus -Path $freshWorktree.Path
  switch ($status.State) {
    'Missing' {
      $candidate.State = 'Missing'
      $candidate.Reason = 'The registered worktree path became unavailable before removal.'
      return
    }
    'Changed' {
      $candidate.State = 'Changed'
      $candidate.Reason = 'The worktree changed after confirmation and was retained.'
      return
    }
    'Error' {
      $candidate.State = 'InspectionError'
      $candidate.Reason = $status.Detail
      Add-CleanupFailure `
        -Message "Could not re-inspect worktree '$($freshWorktree.Path)': $($status.Detail)" `
        -ErrorId 'GitCleanup.WorktreeReinspectionFailed' `
        -Category ([System.Management.Automation.ErrorCategory]::InvalidData) `
        -TargetObject $freshWorktree.Path
      return
    }
  }

  $worktree = $freshWorktree
  $removeResult = Invoke-Git `
    -ArgumentList @('worktree', 'remove', $worktree.Path) `
    -IgnoreExitCode
  if ($removeResult.ExitCode -ne 0) {
    $candidate.State = 'RemoveError'
    $candidate.Reason = $removeResult.StandardError.Trim()
    Add-CleanupFailure `
      -Message "Could not remove worktree for '$branchName': $($candidate.Reason)" `
      -ErrorId 'GitCleanup.WorktreeRemoveFailed' `
      -Category ([System.Management.Automation.ErrorCategory]::WriteError) `
      -TargetObject $worktree.Path
    return
  }

  [void] $removedWorktrees.Add($worktree.Path)
  [void] $worktreeByBranch.Remove($BranchRef)
  $candidate.Action = 'RemovedWorktree'

  $remainingWorktreeByBranch = New-WorktreeMap -Worktree @(Get-GitWorktree)
  $remainingWorktree = $null
  if ($remainingWorktreeByBranch.TryGetValue($BranchRef, [ref] $remainingWorktree)) {
    $candidate.State = 'WorktreeRegisteredAfterRemoval'
    $candidate.WorktreePath = $remainingWorktree.Path
    $candidate.Reason = 'The branch became attached to another worktree and was retained.'
    return
  }

  if ($PSCmdlet.ShouldProcess($branchName, 'Delete merged local branch')) {
    $deleteOutcome = Remove-VerifiedLocalBranch `
      -BranchRef $BranchRef `
      -ExpectedObjectId $verifiedObjectId
    switch ($deleteOutcome.Status) {
      'Deleted' {
        $candidate.Action = 'RemovedWorktreeAndDeletedBranch'
        [void] $deletedBranches.Add($branchName)
      }
      'Missing' {
        $candidate.State = 'AlreadyDeleted'
        $candidate.Action = 'RemovedWorktreeBranchAlreadyAbsent'
        $candidate.Reason = $deleteOutcome.Detail
      }
      'Changed' {
        $candidate.State = 'ChangedAfterVerification'
        $candidate.Reason = $deleteOutcome.Detail
      }
      default {
        $candidate.State = 'DeleteError'
        $candidate.Reason = $deleteOutcome.Detail
        Add-CleanupFailure `
          -Message "Removed worktree but could not delete local branch '$branchName': $($candidate.Reason)" `
          -ErrorId 'GitCleanup.BranchDeleteFailedAfterWorktreeRemoval' `
          -Category ([System.Management.Automation.ErrorCategory]::WriteError) `
          -TargetObject $BranchRef
      }
    }
  }
}

$mergedResult = Invoke-Git `
  -ArgumentList @('for-each-ref', "--merged=$baseObjectId", '--format=%(refname)', 'refs/heads/')
foreach ($branchRef in (ConvertTo-NativeLineArray -Text $mergedResult.StandardOutput)) {
  if (Test-ProtectedBranch -BranchRef $branchRef) {
    continue
  }
  Invoke-BranchCleanup -BranchRef $branchRef -Evidence Ancestry
}

if ($GitHubMerged) {
  $nonAncestorResult = Invoke-Git `
    -ArgumentList @('for-each-ref', "--no-merged=$baseObjectId", '--format=%(refname)', 'refs/heads/')
  foreach ($branchRef in (ConvertTo-NativeLineArray -Text $nonAncestorResult.StandardOutput)) {
    if ((Test-ProtectedBranch -BranchRef $branchRef) -or $branchRef -ceq $currentBranchRef) {
      continue
    }

    $branchName = $branchRef.Substring('refs/heads/'.Length)
    $tipResult = Invoke-Git `
      -ArgumentList @('rev-parse', '--verify', "$branchRef^{commit}") `
      -IgnoreExitCode
    if ($tipResult.ExitCode -ne 0) {
      Add-CleanupFailure `
        -Message "Could not read branch tip for '$branchName'." `
        -ErrorId 'GitCleanup.BranchTipReadFailed' `
        -Category ([System.Management.Automation.ErrorCategory]::InvalidResult) `
        -TargetObject $branchRef
      continue
    }
    $branchTip = $tipResult.StandardOutput.Trim()

    $pullRequestResult = Invoke-NativeCommand `
      -FilePath $ghPath `
      -ArgumentList @(
      'pr', 'list',
      '--repo', $githubRepository,
      '--state', 'merged',
      '--base', $baseInfo.BranchName,
      '--head', $branchName,
      '--limit', '100',
      '--json', 'headRefOid',
      '--jq', '.[].headRefOid'
    ) `
      -WorkingDirectory $repositoryRoot `
      -IgnoreExitCode
    if ($pullRequestResult.ExitCode -ne 0) {
      $detail = $pullRequestResult.StandardError.Trim()
      Add-CleanupFailure `
        -Message "Could not query merged GitHub pull requests for '$branchName': $detail" `
        -ErrorId 'GitCleanup.GitHubQueryFailed' `
        -Category ([System.Management.Automation.ErrorCategory]::ConnectionError) `
        -TargetObject $branchRef
      continue
    }

    $mergedHeadObjectIds = @(ConvertTo-NativeLineArray -Text $pullRequestResult.StandardOutput)
    if ($branchTip -cin $mergedHeadObjectIds) {
      Invoke-BranchCleanup `
        -BranchRef $branchRef `
        -Evidence GitHub `
        -ExpectedObjectId $branchTip
    }
  }
}

$retainedResult = Invoke-Git `
  -ArgumentList @('for-each-ref', "--no-merged=$baseObjectId", '--format=%(refname:short)', 'refs/heads/')
$retainedUnmergedBranches = @(ConvertTo-NativeLineArray -Text $retainedResult.StandardOutput)

$result = [pscustomobject]@{
  PSTypeName                     = 'MartiX.GitCleanupResult'
  RepositoryPath                 = $repositoryRoot
  BaseBranch                     = $baseInfo.BranchName
  BaseRef                        = $baseInfo.Ref
  BaseObjectId                   = $baseObjectId
  ApplyRequested                 = [bool] $Apply
  FetchRequested                 = [bool] $Fetch
  FetchPerformed                 = $fetchPerformed
  GitHubMergedChecked            = [bool] $GitHubMerged
  GitHubRepository               = $githubRepository
  PruneWorktreeMetadataRequested = [bool] $PruneWorktreeMetadata
  MetadataAction                 = $metadataAction
  MetadataOutput                 = $metadataOutput
  Worktrees                      = @($worktreeStates)
  Candidates                     = @($candidates)
  RemovedWorktrees               = @($removedWorktrees)
  DeletedBranches                = @($deletedBranches)
  RetainedUnmergedBranches       = $retainedUnmergedBranches
  FailureCount                   = $failures.Count
  Succeeded                      = ($failures.Count -eq 0)
}

Write-Output -InputObject $result

if ($failures.Count -gt 0) {
  $scriptCmdlet.ThrowTerminatingError((New-CleanupErrorRecord `
        -Message "Git cleanup completed with $($failures.Count) error(s)." `
        -ErrorId 'GitCleanup.CompletedWithErrors' `
        -Category ([System.Management.Automation.ErrorCategory]::InvalidResult) `
        -TargetObject $repositoryRoot))
}
