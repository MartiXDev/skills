[CmdletBinding()]
param(
  [Parameter(Position = 0, Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string] $MessageFile,

  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path
)

$validator = Join-Path $PSScriptRoot 'validate-commit-message.ps1'
& $validator -RepositoryPath $RepositoryPath -MessageFile $MessageFile
exit $LASTEXITCODE
