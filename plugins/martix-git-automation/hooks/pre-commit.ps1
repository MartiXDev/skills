[CmdletBinding()]
param(
  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [switch] $Json
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

try {
  $root = Get-MartixRepositoryRoot -RepositoryPath $RepositoryPath
  $config = Read-MartixGitConfig -RepositoryRoot $root
  $checks = @($config.hooks.preCommitChecks)
  $results = [System.Collections.Generic.List[object]]::new()
  foreach ($check in $checks) {
    $command = ConvertFrom-MartixCommandText -CommandText $check
    $run = Invoke-MartixNative -FilePath $command.FilePath -Arguments $command.Arguments -WorkingDirectory $root
    $passed = $run.ExitCode -eq 0
    [void] $results.Add([pscustomobject]@{
        Command = $check
        ExitCode = $run.ExitCode
        Passed = $passed
        Output = ($run.StandardOutput + $run.StandardError).Trim()
      })
    if (-not $passed) { break }
  }
  $failed = @($results | Where-Object { -not $_.Passed })
  $result = [pscustomobject]@{
    Valid = $failed.Count -eq 0
    Repository = $root
    ChecksConfigured = $checks.Count
    Checks = @($results)
    Errors = @($failed | ForEach-Object { "Hook check '$($_.Command)' exited with code $($_.ExitCode)." })
  }
  Write-MartixResult -Result $result -Json:$Json
  exit ([int] ($failed.Count -gt 0))
}
catch {
  $result = [pscustomobject]@{
    Valid = $false
    Repository = $RepositoryPath
    Errors = @($_.Exception.Message)
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 2
}