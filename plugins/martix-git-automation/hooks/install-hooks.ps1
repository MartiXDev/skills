[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [ValidateSet('commit-msg', 'pre-commit', 'pre-push')]
  [string[]] $Hook = @('commit-msg', 'pre-commit'),

  [Parameter()]
  [switch] $IncludePrePush,

  [Parameter()]
  [switch] $ReplaceExisting,

  [Parameter()]
  [switch] $Apply,

  [Parameter()]
  [switch] $Json
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

function ConvertTo-MartixShellLiteral {
  param([Parameter(Mandatory)][string] $Value)
  return "'" + $Value.Replace("'", "'\''") + "'"
}

function Get-MartixHookLauncher {
  param(
    [Parameter(Mandatory)][string] $HookName,
    [Parameter()][string] $BackupName
  )

  $runtimeScript = "$HookName.ps1"
  $backupBlock = if ([string]::IsNullOrWhiteSpace($BackupName)) { '' } else {
    $backupLiteral = ConvertTo-MartixShellLiteral -Value $BackupName
    @"
martix_original="`$hook_dir/$backupLiteral"
if [ -f "`$martix_original" ]; then
  "`$martix_original" "`$@"
  martix_status=`$?
  if [ "`$martix_status" -ne 0 ]; then
    exit "`$martix_status"
  fi
fi
"@
  }
  @"
#!/bin/sh
set -eu
# MartiX Git Automation hook
hook_dir=`$(CDPATH= cd -- "`$(dirname -- "`$0")" && pwd)
repo_root=`$(git rev-parse --show-toplevel)
$backupBlock
exec pwsh -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "`$repo_root/.martix-git/hooks/$runtimeScript" "`$@"
"@
}

try {
  $root = Get-MartixRepositoryRoot -RepositoryPath $RepositoryPath
  $config = Read-MartixGitConfig -RepositoryRoot $root
  if (-not $config.hooks.enabled) {
    throw 'Hook installation is disabled. Set hooks.enabled to true in .martix-git.json after reviewing the policy.'
  }
  $requestedHooks = [System.Collections.Generic.List[string]]::new()
  foreach ($hookName in @($Hook)) { if ($hookName -notin $requestedHooks) { [void] $requestedHooks.Add($hookName) } }
  if ($IncludePrePush -and 'pre-push' -notin $requestedHooks) { [void] $requestedHooks.Add('pre-push') }

  $hooksPathResult = Invoke-MartixNative -FilePath 'git' `
    -Arguments @('rev-parse', '--git-path', 'hooks') -WorkingDirectory $root
  if ($hooksPathResult.ExitCode -ne 0) { throw "Unable to resolve the Git hooks path: $($hooksPathResult.StandardError.Trim())" }
  $hooksPath = $hooksPathResult.StandardOutput.Trim()
  if (-not [System.IO.Path]::IsPathRooted($hooksPath)) { $hooksPath = Join-Path $root $hooksPath }
  $hooksPath = [System.IO.Path]::GetFullPath($hooksPath)
  $runtimePath = Join-Path $root '.martix-git\hooks'
  $runtimeSourceFiles = @('common.ps1', 'validate-commit-message.ps1', 'commit-msg.ps1', 'pre-commit.ps1', 'pre-push.ps1')
  $statePath = Join-Path $root '.martix-git\hooks-state.json'
  $entries = [System.Collections.Generic.List[object]]::new()
  foreach ($hookName in $requestedHooks) {
    $target = Join-Path $hooksPath $hookName
    $exists = Test-Path -LiteralPath $target -PathType Leaf
    $owned = $false
    $existingContent = ''
    if ($exists) {
      $existingContent = Get-Content -LiteralPath $target -Raw
      $owned = $existingContent.Contains('MartiX Git Automation hook')
    }
    $backupName = $null
    $decision = if ($exists -and -not $owned -and -not $ReplaceExisting) { 'block' } elseif ($Apply) { 'perform' } else { 'ask' }
    $reason = if ($exists -and -not $owned -and -not $ReplaceExisting) {
      'An existing user-owned hook is present; use -ReplaceExisting only after reviewing its backup and chain behavior.'
    }
    elseif ($owned) { 'MartiX-owned hook can be refreshed idempotently.' }
    else { 'Hook will be installed after explicit confirmation.' }
    if ($exists -and -not $owned -and $ReplaceExisting) {
      $backupName = "$hookName.martix-original"
    }
    [void] $entries.Add([pscustomobject]@{
        Hook = $hookName
        Target = $target
        Exists = $exists
        Owned = $owned
        Backup = if ($null -eq $backupName) { $null } else { Join-Path $hooksPath $backupName }
        Decision = $decision
        Reason = $reason
        Result = if ($decision -eq 'block') { 'blocked' } elseif ($Apply) { 'pending' } else { 'unresolved' }
      })
  }

  $result = [pscustomobject]@{
    Valid = $true
    Repository = $root
    HooksPath = $hooksPath
    RuntimePath = $runtimePath
    ApplyRequested = [bool] $Apply
    ReplaceExisting = [bool] $ReplaceExisting
    Hooks = @($entries)
    Result = if ($Apply) { 'pending' } else { 'unresolved' }
  }
  if (@($entries | Where-Object { $_.Decision -eq 'block' }).Count -gt 0) {
    $result.Result = 'blocked'
  }
  elseif ($Apply -and $PSCmdlet.ShouldProcess($root, 'Install the reviewed MartiX Git hooks')) {
    if (-not (Test-Path -LiteralPath $runtimePath -PathType Container)) {
      New-Item -ItemType Directory -Path $runtimePath -Force | Out-Null
    }
    foreach ($sourceName in $runtimeSourceFiles) {
      Copy-Item -LiteralPath (Join-Path $PSScriptRoot $sourceName) `
        -Destination (Join-Path $runtimePath $sourceName) -Force
    }
    if (-not (Test-Path -LiteralPath $hooksPath -PathType Container)) {
      New-Item -ItemType Directory -Path $hooksPath -Force | Out-Null
    }
    foreach ($entry in $entries) {
      if ($entry.Decision -eq 'block') { continue }
      if ($entry.Backup) {
        Copy-Item -LiteralPath $entry.Target -Destination $entry.Backup -Force
      }
      $backupName = if ($entry.Backup) { [System.IO.Path]::GetFileName($entry.Backup) } else { $null }
      $content = Get-MartixHookLauncher -HookName $entry.Hook -BackupName $backupName
      Set-Content -LiteralPath $entry.Target -Value $content -Encoding utf8NoBOM
      $entry.Result = 'completed'
    }
    $state = [pscustomobject]@{
      Marker = 'MartiX Git Automation hooks'
      Repository = $root
      HooksPath = $hooksPath
      RuntimePath = $runtimePath
      Hooks = @($entries | Where-Object { $_.Result -eq 'completed' } | Select-Object Hook, Target, Backup)
    }
    $stateDirectory = Split-Path -Parent $statePath
    if (-not (Test-Path -LiteralPath $stateDirectory -PathType Container)) {
      New-Item -ItemType Directory -Path $stateDirectory -Force | Out-Null
    }
    $state | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $statePath -Encoding utf8NoBOM
    $result.Result = 'completed'
  }
  elseif ($Apply) {
    foreach ($entry in $entries) {
      if ($entry.Result -eq 'pending') { $entry.Result = 'skipped' }
    }
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