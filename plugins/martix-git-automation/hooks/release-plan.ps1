[CmdletBinding()]
param(
  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [string] $BranchName,

  [Parameter()]
  [switch] $Json
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

try {
  $root = Get-MartixRepositoryRoot -RepositoryPath $RepositoryPath
  $config = Read-MartixGitConfig -RepositoryRoot $root
  $git = Get-Command -Name git -CommandType Application -ErrorAction Stop |
    Select-Object -First 1
  $branchResult = Invoke-MartixNative -FilePath $git.Source `
    -Arguments @('symbolic-ref', '--quiet', '--short', 'HEAD') -WorkingDirectory $root
  $branch = if (-not [string]::IsNullOrWhiteSpace($BranchName)) {
    $BranchName
  }
  elseif ($branchResult.ExitCode -eq 0) {
    $branchResult.StandardOutput.Trim()
  }
  else {
    $null
  }
  $release = $config.release
  $errors = [System.Collections.Generic.List[string]]::new()
  if (-not $release.enabled) { [void] $errors.Add('Release integration is disabled in .martix-git.json.') }
  if ([string]::IsNullOrWhiteSpace($release.analyzerPreset)) {
    [void] $errors.Add('release.analyzerPreset must name an explicit analyzer preset.')
  }
  if (@($release.releaseBranches).Count -eq 0) {
    [void] $errors.Add('release.releaseBranches must contain an approved protected release branch.')
  }
  elseif ($branch -notin @($release.releaseBranches)) {
    [void] $errors.Add("Current branch '$branch' is not an approved release branch.")
  }
  if ($env:GITHUB_EVENT_NAME -eq 'pull_request' -or
    $env:GITHUB_HEAD_REF -or $env:CHANGE_ID) {
    [void] $errors.Add('Release publishing is refused from pull-request validation context.')
  }
  $semanticRelease = Get-Command -Name semantic-release -CommandType Application -ErrorAction SilentlyContinue |
    Select-Object -First 1
  $result = [pscustomobject]@{
    Valid = $errors.Count -eq 0
    Repository = $root
    Branch = $branch
    Decision = if ($errors.Count -eq 0) { 'perform' } else { 'block' }
    Result = if ($errors.Count -eq 0) { 'unresolved' } else { 'blocked' }
    AnalyzerPreset = $release.analyzerPreset
    TagFormat = $release.tagFormat
    ReleaseBranches = @($release.releaseBranches)
    SemanticReleaseAvailable = $null -ne $semanticRelease
    DryRunAction = 'semantic-release --dry-run'
    Errors = @($errors)
  }
  Write-MartixResult -Result $result -Json:$Json
  exit ([int] ($errors.Count -gt 0))
}
catch {
  $result = [pscustomobject]@{
    Valid = $false
    Repository = $RepositoryPath
    Result = 'failed'
    Errors = @($_.Exception.Message)
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 2
}
