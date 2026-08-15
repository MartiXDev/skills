[CmdletBinding()]
param(
  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [string] $BaseBranch,

  [Parameter()]
  [string] $HeadBranch,

  [Parameter()]
  [switch] $Json
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

function Invoke-MartixGh {
  param(
    [Parameter(Mandatory)] [string] $GhPath,
    [Parameter(Mandatory)] [string] $RepositoryRoot,
    [Parameter(Mandatory)] [string[]] $Arguments,
    [Parameter()] [int[]] $AllowedExitCode = @(0)
  )

  $result = Invoke-MartixNative -FilePath $GhPath -Arguments $Arguments -WorkingDirectory $RepositoryRoot
  if ($result.ExitCode -notin $AllowedExitCode) {
    $detail = $result.StandardError.Trim()
    if ([string]::IsNullOrWhiteSpace($detail)) { $detail = $result.StandardOutput.Trim() }
    throw "gh $($Arguments -join ' ') failed with exit code $($result.ExitCode): $detail"
  }
  return $result
}

try {
  $root = Get-MartixRepositoryRoot -RepositoryPath $RepositoryPath
  $git = Get-Command -Name git -CommandType Application -ErrorAction Stop |
  Select-Object -First 1
  $config = Read-MartixGitConfig -RepositoryRoot $root
  $branchResult = Invoke-MartixNative -FilePath $git.Source `
    -Arguments @('symbolic-ref', '--quiet', '--short', 'HEAD') -WorkingDirectory $root
  $headResult = Invoke-MartixNative -FilePath $git.Source `
    -Arguments @('rev-parse', 'HEAD') -WorkingDirectory $root
  $branch = if ($branchResult.ExitCode -eq 0) { $branchResult.StandardOutput.Trim() } else { $null }
  $head = if ($headResult.ExitCode -eq 0) { $headResult.StandardOutput.Trim() } else { $null }
  $base = if (-not [string]::IsNullOrWhiteSpace($BaseBranch)) {
    $BaseBranch
  }
  elseif (-not [string]::IsNullOrWhiteSpace($config.pullRequest.baseBranch)) {
    $config.pullRequest.baseBranch
  }
  else {
    $null
  }
  $resolvedHead = if (-not [string]::IsNullOrWhiteSpace($HeadBranch)) { $HeadBranch } else { $branch }
  $ghCommand = Get-Command -Name gh -CommandType Application -ErrorAction SilentlyContinue |
  Select-Object -First 1
  if ($null -eq $ghCommand) {
    $result = [pscustomobject]@{
      Valid            = $true
      Repository       = $root
      Branch           = $resolvedHead
      HeadSha          = $head
      BaseBranch       = $base
      RemoteEvidence   = 'unavailable'
      Capability       = 'gh-missing'
      OpenPullRequests = @()
      Errors           = @('GitHub CLI (gh) is not installed; remote PR state is unknown.')
    }
    Write-MartixResult -Result $result -Json:$Json
    exit 0
  }

  $auth = Invoke-MartixNative -FilePath $ghCommand.Source `
    -Arguments @('auth', 'status') -WorkingDirectory $root
  if ($auth.ExitCode -ne 0) {
    $result = [pscustomobject]@{
      Valid            = $true
      Repository       = $root
      Branch           = $resolvedHead
      HeadSha          = $head
      BaseBranch       = $base
      RemoteEvidence   = 'unavailable'
      Capability       = 'gh-unauthenticated'
      OpenPullRequests = @()
      Errors           = @('GitHub CLI is not authenticated; remote PR state is unknown.')
    }
    Write-MartixResult -Result $result -Json:$Json
    exit 0
  }

  $repoView = Invoke-MartixGh -GhPath $ghCommand.Source -RepositoryRoot $root `
    -Arguments @('repo', 'view', '--json', 'nameWithOwner,defaultBranchRef')
  $repoInfo = $repoView.StandardOutput | ConvertFrom-Json
  $repository = $repoInfo.nameWithOwner
  if ([string]::IsNullOrWhiteSpace($base)) {
    $base = $repoInfo.defaultBranchRef.name
  }
  if ([string]::IsNullOrWhiteSpace($resolvedHead) -or [string]::IsNullOrWhiteSpace($base)) {
    throw 'Both a head branch and base branch are required to query pull requests.'
  }

  $prResult = Invoke-MartixGh -GhPath $ghCommand.Source -RepositoryRoot $root `
    -Arguments @(
    'pr', 'list', '--repo', $repository, '--state', 'open',
    '--head', $resolvedHead, '--base', $base,
    '--json', 'number,url,title,isDraft,headRefOid,headRefName,baseRefName'
  )
  $pullRequests = if ([string]::IsNullOrWhiteSpace($prResult.StandardOutput)) {
    @()
  }
  else {
    @($prResult.StandardOutput | ConvertFrom-Json)
  }
  $result = [pscustomobject]@{
    Valid                    = $true
    Repository               = $root
    GitHubRepository         = $repository
    Branch                   = $resolvedHead
    HeadSha                  = $head
    BaseBranch               = $base
    RemoteEvidence           = 'available'
    Capability               = 'gh-authenticated'
    OpenPullRequests         = $pullRequests
    DuplicateOpenPullRequest = @($pullRequests).Count -gt 0
    Errors                   = @()
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 0
}
catch {
  $result = [pscustomobject]@{
    Valid          = $false
    Repository     = $RepositoryPath
    RemoteEvidence = 'error'
    Errors         = @($_.Exception.Message)
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 2
}
