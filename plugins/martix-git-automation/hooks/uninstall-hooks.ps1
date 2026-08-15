[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [ValidateSet('commit-msg', 'pre-commit', 'pre-push')]
  [string[]] $Hook,

  [Parameter()]
  [switch] $RestoreBackup,

  [Parameter()]
  [switch] $Apply,

  [Parameter()]
  [switch] $Json
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

try {
  $root = Get-MartixRepositoryRoot -RepositoryPath $RepositoryPath
  $statePath = Join-Path $root '.martix-git\hooks-state.json'
  if (-not (Test-Path -LiteralPath $statePath -PathType Leaf)) {
    throw 'No MartiX Git hook state file exists; no hooks were selected for removal.'
  }
  $state = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
  $selected = if ($Hook) { @($Hook) } else { @($state.Hooks | Select-Object -ExpandProperty Hook) }
  $entries = [System.Collections.Generic.List[object]]::new()
  foreach ($stateHook in @($state.Hooks)) {
    if ($stateHook.Hook -notin $selected) { continue }
    $target = [string] $stateHook.Target
    $exists = Test-Path -LiteralPath $target -PathType Leaf
    $owned = $exists -and (Get-Content -LiteralPath $target -Raw).Contains('MartiX Git Automation hook')
    $decision = if (-not $exists) { 'skip' } elseif (-not $owned) { 'block' } elseif ($Apply) { 'perform' } else { 'ask' }
    $reason = if (-not $exists) { 'Installed hook is already absent.' } elseif (-not $owned) {
      'Hook content changed after installation; it is retained for manual review.'
    } else { 'Installed MartiX hook can be removed.' }
    [void] $entries.Add([pscustomobject]@{
        Hook = $stateHook.Hook
        Target = $target
        Backup = $stateHook.Backup
        Decision = $decision
        Reason = $reason
        Result = if ($decision -eq 'skip') { 'skipped' } elseif ($decision -eq 'block') { 'blocked' } elseif ($Apply) { 'pending' } else { 'unresolved' }
      })
  }
  $result = [pscustomobject]@{
    Valid = $true
    Repository = $root
    ApplyRequested = [bool] $Apply
    RestoreBackup = [bool] $RestoreBackup
    Hooks = @($entries)
    Result = if ($Apply) { 'pending' } else { 'unresolved' }
  }
  if (@($entries | Where-Object { $_.Decision -eq 'block' }).Count -gt 0) {
    $result.Result = 'blocked'
  }
  elseif ($Apply -and $PSCmdlet.ShouldProcess($root, 'Uninstall the reviewed MartiX Git hooks')) {
    foreach ($entry in $entries) {
      if ($entry.Decision -notin @('perform')) { continue }
      Remove-Item -LiteralPath $entry.Target -Force
      if ($RestoreBackup -and $entry.Backup -and (Test-Path -LiteralPath $entry.Backup -PathType Leaf)) {
        Move-Item -LiteralPath $entry.Backup -Destination $entry.Target -Force
        $entry.Result = 'restored'
      }
      else {
        $entry.Result = 'removed'
      }
    }
    $remaining = @($state.Hooks | Where-Object { $_.Hook -notin $selected })
    if ($remaining.Count -eq 0) {
      Remove-Item -LiteralPath $statePath -Force
    }
    else {
      $state.Hooks = $remaining
      $state | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $statePath -Encoding utf8NoBOM
    }
    $result.Result = 'completed'
  }
  elseif ($Apply) {
    foreach ($entry in $entries) { if ($entry.Result -eq 'pending') { $entry.Result = 'skipped' } }
    $result.Result = 'skipped'
  }
  Write-MartixResult -Result $result -Json:$Json
  exit ([int] ($result.Result -eq 'blocked'))
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