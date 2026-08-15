[CmdletBinding()]
param(
  [Parameter(Position = 0, Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string] $BranchName,

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
  $errors = [System.Collections.Generic.List[string]]::new()
  $branchPolicy = $config.branch

  if ($BranchName -match '[\x00-\x1F\x7F]' -or $BranchName -match '\s') {
    [void] $errors.Add('Branch names cannot contain whitespace or control characters.')
  }
  if ($null -ne $branchPolicy.maxLength -and $BranchName.Length -gt [int] $branchPolicy.maxLength) {
    [void] $errors.Add("Branch name is $($BranchName.Length) characters; policy allows $($branchPolicy.maxLength).")
  }

  $trunkBranches = @($branchPolicy.trunkBranches)
  $isTrunk = $BranchName -in $trunkBranches
  if (-not $isTrunk -and @($branchPolicy.prefixes).Count -gt 0) {
    $separator = $BranchName.IndexOf('/')
    $prefix = if ($separator -gt 0) { $BranchName.Substring(0, $separator) } else { '' }
    $description = if ($separator -ge 0 -and $separator + 1 -lt $BranchName.Length) {
      $BranchName.Substring($separator + 1)
    }
    else {
      ''
    }
    if ($prefix -notin @($branchPolicy.prefixes)) {
      [void] $errors.Add("Prefix '$prefix' is not allowed by repository policy.")
    }
    if ([string]::IsNullOrWhiteSpace($description)) {
      [void] $errors.Add('A non-empty branch description is required after the prefix.')
    }
  }

  $gitCheck = $null
  if ($errors.Count -eq 0) {
    $gitCheck = Invoke-MartixNative -FilePath 'git' `
      -Arguments @('check-ref-format', '--branch', $BranchName) `
      -WorkingDirectory $root
    if ($gitCheck.ExitCode -ne 0) {
      [void] $errors.Add("Git rejected the branch ref: $($gitCheck.StandardError.Trim())")
    }
  }

  $result = [pscustomobject]@{
    Valid         = $errors.Count -eq 0
    Repository    = $root
    BranchName    = $BranchName
    SpecVersion   = $branchPolicy.specVersion
    IsTrunk       = $isTrunk
    GitRefChecked = $null -ne $gitCheck
    Errors        = @($errors)
  }
  Write-MartixResult -Result $result -Json:$Json
  exit ([int] ($errors.Count -gt 0))
}
catch {
  $result = [pscustomobject]@{
    Valid      = $false
    Repository = $RepositoryPath
    BranchName = $BranchName
    Errors     = @($_.Exception.Message)
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 2
}
