[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
  [Parameter()]
  [string] $Remote = 'origin',

  [Parameter()]
  [string] $BranchName,

  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [string] $ExpectedHead,

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

try {
  $root = Get-MartixRepositoryRoot -RepositoryPath $RepositoryPath
  $gitCommand = Get-Command -Name git -CommandType Application -ErrorAction Stop |
  Select-Object -First 1
  $remoteResult = Invoke-MartixGit -GitPath $gitCommand.Source -RepositoryRoot $root `
    -Arguments @('remote', 'get-url', $Remote) -AllowedExitCode @(0, 2)
  if ($remoteResult.ExitCode -ne 0) {
    throw "Remote '$Remote' does not exist."
  }
  $resolvedBranch = $BranchName
  if ([string]::IsNullOrWhiteSpace($resolvedBranch)) {
    $branchResult = Invoke-MartixGit -GitPath $gitCommand.Source -RepositoryRoot $root `
      -Arguments @('symbolic-ref', '--quiet', '--short', 'HEAD') -AllowedExitCode @(0, 1)
    if ($branchResult.ExitCode -ne 0 -or [string]::IsNullOrWhiteSpace($branchResult.StandardOutput)) {
      throw 'Cannot push a detached HEAD without an explicit branch name.'
    }
    $resolvedBranch = $branchResult.StandardOutput.Trim()
  }
  $headResult = Invoke-MartixGit -GitPath $gitCommand.Source -RepositoryRoot $root -Arguments @('rev-parse', 'HEAD')
  $head = $headResult.StandardOutput.Trim()
  if (-not [string]::IsNullOrWhiteSpace($ExpectedHead) -and $head -cne $ExpectedHead) {
    throw "HEAD changed from expected '$ExpectedHead' to '$head'; recompute the push plan."
  }

  $upstreamResult = Invoke-MartixGit -GitPath $gitCommand.Source -RepositoryRoot $root `
    -Arguments @('rev-parse', '--abbrev-ref', '--symbolic-full-name', '@{upstream}') `
    -AllowedExitCode @(0, 1)
  $upstream = if ($upstreamResult.ExitCode -eq 0) { $upstreamResult.StandardOutput.Trim() } else { $null }
  $ahead = $null
  $behind = $null
  if (-not [string]::IsNullOrWhiteSpace($upstream)) {
    $divergence = Invoke-MartixGit -GitPath $gitCommand.Source -RepositoryRoot $root `
      -Arguments @('rev-list', '--left-right', '--count', "HEAD...$upstream")
    $parts = @($divergence.StandardOutput.Trim() -split '\s+')
    if ($parts.Count -eq 2) {
      $ahead = [int] $parts[0]
      $behind = [int] $parts[1]
    }
    if ($behind -gt 0) {
      throw "The upstream '$upstream' is ahead by $behind commit(s); push would require a merge or rebase decision."
    }
    if ($ahead -eq 0) {
      $result = [pscustomobject]@{
        Valid      = $true
        Repository = $root
        Decision   = 'skip'
        Result     = 'skipped'
        Reason     = 'The upstream already contains the current HEAD.'
        Remote     = $Remote
        Branch     = $resolvedBranch
        Upstream   = $upstream
        Head       = $head
        Ahead      = $ahead
        Behind     = $behind
      }
      Write-MartixResult -Result $result -Json:$Json
      exit 0
    }
  }

  $pushArguments = if ([string]::IsNullOrWhiteSpace($upstream)) {
    @('push', '--set-upstream', $Remote, $resolvedBranch)
  }
  else {
    @('push', $Remote, $resolvedBranch)
  }
  $result = [pscustomobject]@{
    Valid        = $true
    Repository   = $root
    Decision     = if ($Apply) { 'perform' } else { 'ask' }
    Result       = if ($Apply) { 'pending' } else { 'unresolved' }
    Action       = "git $($pushArguments -join ' ')"
    Confirmation = if ($Apply) { 'requested by -Apply; ShouldProcess still applies' } else { 'required' }
    Remote       = $Remote
    Branch       = $resolvedBranch
    Upstream     = $upstream
    Head         = $head
    Ahead        = $ahead
    Behind       = $behind
    ForcePush    = $false
  }

  if ($Apply) {
    if (-not $PSCmdlet.ShouldProcess("$Remote/$resolvedBranch", 'Publish the confirmed branch without force')) {
      $result.Confirmation = 'declined'
      $result.Result = 'skipped'
    }
    else {
      $pushResult = Invoke-MartixNative -FilePath $gitCommand.Source `
        -Arguments $pushArguments -WorkingDirectory $root
      if ($pushResult.ExitCode -ne 0) {
        throw "Git push failed: $($pushResult.StandardError.Trim())"
      }
      $result.Confirmation = 'received'
      $result.Result = 'completed'
      $result.Output = ($pushResult.StandardOutput + $pushResult.StandardError).Trim()
    }
  }

  Write-MartixResult -Result $result -Json:$Json
  exit 0
}
catch {
  $result = [pscustomobject]@{
    Valid      = $false
    Repository = $RepositoryPath
    Result     = 'failed'
    Errors     = @($_.Exception.Message)
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 2
}
