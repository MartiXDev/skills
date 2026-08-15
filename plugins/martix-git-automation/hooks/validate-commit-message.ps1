[CmdletBinding()]
param(
  [Parameter(Position = 0, Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string] $MessageFile,

  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [string] $ConfigPath,

  [Parameter()]
  [switch] $Json
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

function Test-MartixCommitMessage {
  param(
    [Parameter(Mandatory)]
    [string] $Message,
    [Parameter(Mandatory)]
    [object] $Config
  )

  $errors = [System.Collections.Generic.List[string]]::new()
  $normalized = $Message.TrimStart([char]0xFEFF)
  $lines = @($normalized -split "`r?`n") |
  Where-Object { -not $_.TrimStart().StartsWith('#') }
  $headerIndex = -1
  for ($index = 0; $index -lt $lines.Count; $index++) {
    if (-not [string]::IsNullOrWhiteSpace($lines[$index])) {
      $headerIndex = $index
      break
    }
  }

  if ($headerIndex -lt 0) {
    [void] $errors.Add('The commit message has no subject header.')
    return [pscustomobject]@{
      Valid       = $false
      Errors      = @($errors)
      Type        = $null
      Scope       = $null
      Breaking    = $false
      Header      = $null
      Description = $null
    }
  }

  $header = $lines[$headerIndex]
  $match = [regex]::Match(
    $header,
    '^(?<type>[A-Za-z0-9-]+)(?:\((?<scope>[^()\r\n]+)\))?(?<breaking>!)?: (?<description>\S.*)$'
  )
  if (-not $match.Success) {
    [void] $errors.Add('The subject must match <type>[optional scope][!]: <description>.')
    return [pscustomobject]@{
      Valid       = $false
      Errors      = @($errors)
      Type        = $null
      Scope       = $null
      Breaking    = $false
      Header      = $header
      Description = $null
    }
  }

  $type = $match.Groups['type'].Value
  $scope = $match.Groups['scope'].Value
  $breaking = $match.Groups['breaking'].Success
  $description = $match.Groups['description'].Value
  $policy = $Config.conventionalCommit

  if (@($policy.types).Count -gt 0 -and $type -notin @($policy.types)) {
    [void] $errors.Add("Type '$type' is not allowed by repository policy.")
  }
  if ($policy.requireScope -and [string]::IsNullOrWhiteSpace($scope)) {
    [void] $errors.Add('A scope is required by repository policy.')
  }
  if (@($policy.scopes).Count -gt 0 -and -not [string]::IsNullOrWhiteSpace($scope) -and $scope -notin @($policy.scopes)) {
    [void] $errors.Add("Scope '$scope' is not allowed by repository policy.")
  }
  if ($null -ne $policy.maxHeaderLength -and $header.Length -gt [int] $policy.maxHeaderLength) {
    [void] $errors.Add("The subject is $($header.Length) characters; policy allows $($policy.maxHeaderLength).")
  }

  if ($headerIndex + 1 -lt $lines.Count -and
    -not [string]::IsNullOrWhiteSpace($lines[$headerIndex + 1])) {
    [void] $errors.Add('Body or footers must start after a blank line.')
  }

  foreach ($line in $lines | Select-Object -Skip ($headerIndex + 1)) {
    if ($line -match '^(?i:breaking[ -]change):') {
      if ($line -notmatch '^BREAKING(?: CHANGE|-CHANGE):\s+\S') {
        [void] $errors.Add('The breaking-change footer must use uppercase BREAKING CHANGE: or BREAKING-CHANGE:.')
      }
      elseif ($line -match '^BREAKING(?: CHANGE|-CHANGE):\s*$') {
        [void] $errors.Add('The breaking-change footer must explain the migration impact.')
      }
      continue
    }

    if ($line -match '^[A-Za-z0-9-]+(?:\s+#|:\s)\S') {
      continue
    }
  }

  [pscustomobject]@{
    Valid       = $errors.Count -eq 0
    Errors      = @($errors)
    Type        = $type
    Scope       = if ([string]::IsNullOrWhiteSpace($scope)) { $null } else { $scope }
    Breaking    = $breaking -or ($normalized -match '(?m)^BREAKING(?: CHANGE|-CHANGE):\s+\S')
    Header      = $header
    Description = $description
  }
}

try {
  $root = Get-MartixRepositoryRoot -RepositoryPath $RepositoryPath
  $config = Read-MartixGitConfig -RepositoryRoot $root -ConfigPath $ConfigPath
  if (-not (Test-Path -LiteralPath $MessageFile -PathType Leaf)) {
    throw "Commit message file does not exist: $MessageFile"
  }
  $message = Get-Content -LiteralPath $MessageFile -Raw
  $validation = Test-MartixCommitMessage -Message $message -Config $config
  $result = [pscustomobject]@{
    Valid       = $validation.Valid
    Repository  = $root
    MessageFile = [System.IO.Path]::GetFullPath($MessageFile)
    Type        = $validation.Type
    Scope       = $validation.Scope
    Breaking    = $validation.Breaking
    Header      = $validation.Header
    Errors      = @($validation.Errors)
  }
  Write-MartixResult -Result $result -Json:$Json
  exit ([int] (-not $validation.Valid))
}
catch {
  $result = [pscustomobject]@{
    Valid       = $false
    Repository  = $RepositoryPath
    MessageFile = $MessageFile
    Errors      = @($_.Exception.Message)
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 2
}
