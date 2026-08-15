[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
  [Parameter(Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string] $Title,

  [Parameter(Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string] $BodyFile,

  [Parameter()]
  [string] $BaseBranch,

  [Parameter()]
  [string] $HeadBranch,

  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [string] $ExpectedHead,

  [Parameter()]
  [switch] $Ready,

  [Parameter()]
  [switch] $Apply,

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
  if (-not (Test-Path -LiteralPath $BodyFile -PathType Leaf)) {
    throw "PR body file does not exist: $BodyFile"
  }
  $git = Get-Command -Name git -CommandType Application -ErrorAction Stop |
    Select-Object -First 1
  $config = Read-MartixGitConfig -RepositoryRoot $root
  $branchResult = Invoke-MartixNative -FilePath $git.Source `
    -Arguments @('symbolic-ref', '--quiet', '--short', 'HEAD') -WorkingDirectory $root
  if ($branchResult.ExitCode -ne 0 -or [string]::IsNullOrWhiteSpace($branchResult.StandardOutput)) {
    throw 'A pull request cannot be created from a detached HEAD.'
  }
  $headBranch = if ([string]::IsNullOrWhiteSpace($HeadBranch)) {
    $branchResult.StandardOutput.Trim()
  }
  else {
    $HeadBranch
  }
  $headResult = Invoke-MartixNative -FilePath $git.Source `
    -Arguments @('rev-parse', 'HEAD') -WorkingDirectory $root
  if ($headResult.ExitCode -ne 0) { throw 'Unable to resolve the current HEAD.' }
  $head = $headResult.StandardOutput.Trim()
  if (-not [string]::IsNullOrWhiteSpace($ExpectedHead) -and $head -cne $ExpectedHead) {
    throw "HEAD changed from expected '$ExpectedHead' to '$head'; recompute the PR plan."
  }

  $ghCommand = Get-Command -Name gh -CommandType Application -ErrorAction SilentlyContinue |
    Select-Object -First 1
  if ($null -eq $ghCommand) {
    throw 'GitHub CLI (gh) is required for PR creation but is not installed.'
  }
  $auth = Invoke-MartixNative -FilePath $ghCommand.Source -Arguments @('auth', 'status') -WorkingDirectory $root
  if ($auth.ExitCode -ne 0) {
    throw 'GitHub CLI is not authenticated; PR creation is blocked.'
  }

  $repoView = Invoke-MartixGh -GhPath $ghCommand.Source -RepositoryRoot $root `
    -Arguments @('repo', 'view', '--json', 'nameWithOwner,defaultBranchRef')
  $repoInfo = $repoView.StandardOutput | ConvertFrom-Json
  $repository = $repoInfo.nameWithOwner
  $base = if (-not [string]::IsNullOrWhiteSpace($BaseBranch)) {
    $BaseBranch
  }
  elseif (-not [string]::IsNullOrWhiteSpace($config.pullRequest.baseBranch)) {
    $config.pullRequest.baseBranch
  }
  else {
    $repoInfo.defaultBranchRef.name
  }
  if ([string]::IsNullOrWhiteSpace($base)) { throw 'The PR base branch is unresolved.' }

  $openResult = Invoke-MartixGh -GhPath $ghCommand.Source -RepositoryRoot $root `
    -Arguments @(
      'pr', 'list', '--repo', $repository, '--state', 'open',
      '--head', $headBranch, '--base', $base,
      '--json', 'number,url,title,isDraft,headRefOid,headRefName,baseRefName'
    )
  $openPullRequests = if ([string]::IsNullOrWhiteSpace($openResult.StandardOutput)) {
    @()
  }
  else {
    @($openResult.StandardOutput | ConvertFrom-Json)
  }
  if (@($openPullRequests).Count -gt 0) {
    $result = [pscustomobject]@{
      Valid = $true
      Repository = $root
      GitHubRepository = $repository
      Decision = 'skip'
      Result = 'skipped'
      Reason = 'An open pull request already exists for the confirmed head and base.'
      PullRequest = $openPullRequests[0]
      Head = $head
      Base = $base
      Draft = -not $Ready
    }
    Write-MartixResult -Result $result -Json:$Json
    exit 0
  }

  $createArguments = @(
    'pr', 'create', '--repo', $repository,
    '--title', $Title, '--body-file', [System.IO.Path]::GetFullPath($BodyFile),
    '--base', $base, '--head', $headBranch
  )
  if (-not $Ready) { $createArguments += '--draft' }
  $result = [pscustomobject]@{
    Valid = $true
    Repository = $root
    GitHubRepository = $repository
    Decision = if ($Apply) { 'perform' } else { 'ask' }
    Result = if ($Apply) { 'pending' } else { 'unresolved' }
    Action = 'gh pr create with explicit title, body file, head, base, and draft state'
    Confirmation = if ($Apply) { 'requested by -Apply; ShouldProcess still applies' } else { 'required' }
    Head = $head
    Base = $base
    Branch = $headBranch
    Draft = -not $Ready
    DuplicateOpenPullRequest = $false
    PullRequest = $null
    Reconciled = $null
    Url = $null
    Output = $null
  }

  if ($Apply) {
    if (-not $PSCmdlet.ShouldProcess("$repository/$headBranch -> $base", 'Create the reviewed pull request')) {
      $result.Confirmation = 'declined'
      $result.Result = 'skipped'
    }
    else {
      $freshHead = Invoke-MartixNative -FilePath $git.Source `
        -Arguments @('rev-parse', 'HEAD') -WorkingDirectory $root
      if ($freshHead.ExitCode -ne 0 -or $freshHead.StandardOutput.Trim() -cne $head) {
        throw 'HEAD changed after confirmation; PR creation was aborted.'
      }
      $freshOpen = Invoke-MartixGh -GhPath $ghCommand.Source -RepositoryRoot $root `
        -Arguments @(
          'pr', 'list', '--repo', $repository, '--state', 'open',
          '--head', $headBranch, '--base', $base,
          '--json', 'number,url,title,isDraft,headRefOid,headRefName,baseRefName'
        )
      $freshPullRequests = if ([string]::IsNullOrWhiteSpace($freshOpen.StandardOutput)) {
        @()
      }
      else {
        @($freshOpen.StandardOutput | ConvertFrom-Json)
      }
      if (@($freshPullRequests).Count -gt 0) {
        $result.Confirmation = 'received'
        $result.Result = 'skipped'
        $result.Reconciled = 'An open PR appeared during confirmation.'
        $result.PullRequest = $freshPullRequests[0]
      }
      else {
        $created = Invoke-MartixGh -GhPath $ghCommand.Source -RepositoryRoot $root `
          -Arguments $createArguments
        $url = $created.StandardOutput.Trim().Split([char]10) |
          Where-Object { $_ -match '^https?://' } |
          Select-Object -Last 1
        $result.Confirmation = 'received'
        $result.Result = 'completed'
        $result.Url = $url
        $result.Output = ($created.StandardOutput + $created.StandardError).Trim()
      }
    }
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
