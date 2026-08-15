[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [switch] $DryRun,

  [Parameter()]
  [switch] $Apply,

  [Parameter()]
  [switch] $Json
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

try {
  $root = Get-MartixRepositoryRoot -RepositoryPath $RepositoryPath
  $planScript = Join-Path $PSScriptRoot 'release-plan.ps1'
  $plan = & $planScript -RepositoryPath $root -Json 2>$null
  $planExit = $LASTEXITCODE
  $planObject = $plan | ConvertFrom-Json
  if ($planExit -ne 0 -or -not $planObject.Valid) {
    $result = [pscustomobject]@{
      Valid      = $false
      Repository = $root
      Decision   = 'block'
      Result     = 'blocked'
      Reason     = 'Release preflight did not pass.'
      Plan       = $planObject
    }
    Write-MartixResult -Result $result -Json:$Json
    exit 2
  }

  $semanticRelease = Get-Command -Name semantic-release -CommandType Application -ErrorAction SilentlyContinue |
  Select-Object -First 1
  if ($null -eq $semanticRelease) {
    throw 'semantic-release is not installed; release publishing is blocked.'
  }
  $isDryRun = [bool] ($DryRun -or -not $Apply)
  $arguments = if ($isDryRun) { @('--dry-run') } else { @() }
  $result = [pscustomobject]@{
    Valid        = $true
    Repository   = $root
    Decision     = if ($isDryRun) { 'perform' } else { 'ask' }
    Result       = 'pending'
    Action       = if ($isDryRun) { 'semantic-release --dry-run' } else { 'semantic-release' }
    Confirmation = if ($isDryRun) { 'not required for dry run' } else { 'required' }
    DryRun       = $isDryRun
    Plan         = $planObject
    Output       = $null
  }
  if (-not $DryRun -and -not $Apply) {
    $result.Decision = 'ask'
    $result.Result = 'unresolved'
  }
  elseif ($isDryRun -or $PSCmdlet.ShouldProcess($root, 'Publish semantic-release release')) {
    $releaseResult = Invoke-MartixNative -FilePath $semanticRelease.Source `
      -Arguments $arguments -WorkingDirectory $root
    if ($releaseResult.ExitCode -ne 0) {
      throw "semantic-release failed with exit code $($releaseResult.ExitCode): $($releaseResult.StandardError.Trim())"
    }
    $result.Result = 'completed'
    $result.Confirmation = if ($isDryRun) { 'not required for dry run' } else { 'received' }
    $result.Output = ($releaseResult.StandardOutput + $releaseResult.StandardError).Trim()
  }
  else {
    $result.Result = 'skipped'
    $result.Confirmation = 'declined'
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 0
}
catch {
  $result = [pscustomobject]@{
    Valid      = $false
    Repository = $RepositoryPath
    Result     = 'blocked'
    Errors     = @($_.Exception.Message)
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 2
}
