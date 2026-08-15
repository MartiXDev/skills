[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
  [Parameter(Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string[]] $Paths,

  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [switch] $Apply,

  [Parameter()]
  [switch] $Json
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

try {
  $root = Get-MartixRepositoryRoot -RepositoryPath $RepositoryPath
  $gitCommand = Get-Command -Name git -CommandType Application -ErrorAction Stop |
  Select-Object -First 1
  $invalidPaths = @($Paths | Where-Object {
      [string]::IsNullOrWhiteSpace($_) -or $_ -eq '--' -or $_ -match '[*?\[\]]'
    })
  if ($invalidPaths.Count -gt 0) {
    throw "Paths must be explicit, non-empty path names without wildcard syntax: $($invalidPaths -join ', ')"
  }
  if (@($Paths | Where-Object { $_ -in @('.', './', '.\') }).Count -gt 0) {
    throw 'The current-directory path is not accepted; provide the intended files or directories explicitly.'
  }

  $dryRun = Invoke-MartixNative -FilePath $gitCommand.Source `
    -Arguments (@('add', '--dry-run', '--') + @($Paths)) -WorkingDirectory $root
  if ($dryRun.ExitCode -ne 0) {
    throw "Git could not resolve the requested paths: $($dryRun.StandardError.Trim())"
  }

  $result = [pscustomobject]@{
    Valid        = $true
    Repository   = $root
    Paths        = @($Paths)
    Decision     = if ($Apply) { 'perform' } else { 'ask' }
    Action       = if ($Apply) { 'git add -- <explicit paths>' } else { 'git add -- <explicit paths> after confirmation' }
    Confirmation = if ($Apply) { 'requested by -Apply; ShouldProcess still applies' } else { 'required' }
    Result       = if ($Apply) { 'pending' } else { 'unresolved' }
    DryRunOutput = $dryRun.StandardOutput.Trim()
  }

  if ($Apply) {
    if (-not $PSCmdlet.ShouldProcess(($Paths -join ', '), 'Stage explicitly selected paths')) {
      $result.Confirmation = 'declined'
      $result.Result = 'skipped'
    }
    else {
      $applyResult = Invoke-MartixNative -FilePath $gitCommand.Source `
        -Arguments (@('add', '--') + @($Paths)) -WorkingDirectory $root
      if ($applyResult.ExitCode -ne 0) {
        throw "Git staging failed: $($applyResult.StandardError.Trim())"
      }
      $result.Result = 'completed'
      $result.Confirmation = 'received'
    }
  }

  Write-MartixResult -Result $result -Json:$Json
  exit 0
}
catch {
  $result = [pscustomobject]@{
    Valid      = $false
    Repository = $RepositoryPath
    Paths      = @($Paths)
    Result     = 'failed'
    Errors     = @($_.Exception.Message)
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 2
}
