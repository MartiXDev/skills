[CmdletBinding()]
param(
  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [string] $ConfigPath,

  [Parameter()]
  [switch] $Json
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

try {
  $root = Get-MartixRepositoryRoot -RepositoryPath $RepositoryPath
  $config = Read-MartixGitConfig -RepositoryRoot $root -ConfigPath $ConfigPath
  $result = [pscustomobject]@{
    Valid         = $true
    Repository    = $root
    ConfigPath    = $config.ConfigPath
    ConfigExists  = $config.ConfigExists
    SchemaVersion = $config.schemaVersion
    Errors        = @()
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 0
}
catch {
  $result = [pscustomobject]@{
    Valid      = $false
    Repository = $RepositoryPath
    ConfigPath = $ConfigPath
    Errors     = @($_.Exception.Message)
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 2
}
