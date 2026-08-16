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
  if ([string]::IsNullOrWhiteSpace($config.hooks.prePushCommand)) {
    $result = [pscustomobject]@{
      Valid = $true
      Repository = $root
      Skipped = $true
      Reason = 'No bounded pre-push command is configured.'
      Errors = @()
    }
    Write-MartixResult -Result $result -Json:$Json
    exit 0
  }

  $command = ConvertFrom-MartixCommandText -CommandText $config.hooks.prePushCommand
  $run = Invoke-MartixNative -FilePath $command.FilePath -Arguments $command.Arguments -WorkingDirectory $root
  $result = [pscustomobject]@{
    Valid = $run.ExitCode -eq 0
    Repository = $root
    Skipped = $false
    Command = $config.hooks.prePushCommand
    ExitCode = $run.ExitCode
    Output = ($run.StandardOutput + $run.StandardError).Trim()
    Errors = if ($run.ExitCode -eq 0) { @() } else { @("Hook check exited with code $($run.ExitCode).") }
  }
  Write-MartixResult -Result $result -Json:$Json
  exit ([int] ($run.ExitCode -ne 0))
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