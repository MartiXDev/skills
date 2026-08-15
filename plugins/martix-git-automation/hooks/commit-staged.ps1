[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
  [Parameter(Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string] $MessageFile,

  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [string] $ConfigPath,

  [Parameter()]
  [string] $ExpectedHead,

  [Parameter()]
  [switch] $Apply,

  [Parameter()]
  [switch] $Json
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

function Invoke-MartixGit {
  param(
    [Parameter(Mandatory)] [string] $GitPath,
    [Parameter(Mandatory)] [string] $RepositoryRoot,
    [Parameter(Mandatory)] [string[]] $Arguments,
    [Parameter()] [int[]] $AllowedExitCode = @(0)
  )

  $result = Invoke-MartixNative -FilePath $GitPath -Arguments $Arguments -WorkingDirectory $RepositoryRoot
  if ($result.ExitCode -notin $AllowedExitCode) {
    $detail = $result.StandardError.Trim()
    if ([string]::IsNullOrWhiteSpace($detail)) { $detail = $result.StandardOutput.Trim() }
    throw "git $($Arguments -join ' ') failed with exit code $($result.ExitCode): $detail"
  }
  return $result
}

try {
  $root = Get-MartixRepositoryRoot -RepositoryPath $RepositoryPath
  $gitCommand = Get-Command -Name git -CommandType Application -ErrorAction Stop |
  Select-Object -First 1
  if (-not (Test-Path -LiteralPath $MessageFile -PathType Leaf)) {
    throw "Commit message file does not exist: $MessageFile"
  }
  $config = Read-MartixGitConfig -RepositoryRoot $root -ConfigPath $ConfigPath
  $headResult = Invoke-MartixGit -GitPath $gitCommand.Source -RepositoryRoot $root -Arguments @('rev-parse', 'HEAD')
  $head = $headResult.StandardOutput.Trim()
  if (-not [string]::IsNullOrWhiteSpace($ExpectedHead) -and $head -cne $ExpectedHead) {
    throw "HEAD changed from expected '$ExpectedHead' to '$head'; review the staged diff again."
  }
  $cachedResult = Invoke-MartixGit -GitPath $gitCommand.Source -RepositoryRoot $root `
    -Arguments @('diff', '--cached', '--quiet') -AllowedExitCode @(0, 1)
  if ($cachedResult.ExitCode -eq 0) {
    $result = [pscustomobject]@{
      Valid        = $true
      Repository   = $root
      Decision     = 'skip'
      Result       = 'skipped'
      Reason       = 'No staged changes exist; an empty commit is not created.'
      Head         = $head
      ConfigExists = $config.ConfigExists
    }
    Write-MartixResult -Result $result -Json:$Json
    exit 0
  }

  $validator = Join-Path $PSScriptRoot 'validate-commit-message.ps1'
  $validatorArguments = @('-NoProfile', '-File', $validator, $MessageFile,
    '-RepositoryPath', $root, '-Json')
  if (-not [string]::IsNullOrWhiteSpace($ConfigPath)) {
    $validatorArguments += @('-ConfigPath', $ConfigPath)
  }
  $pwsh = Get-Command -Name pwsh -CommandType Application -ErrorAction Stop |
  Select-Object -First 1
  $validationResult = Invoke-MartixNative -FilePath $pwsh.Source `
    -Arguments $validatorArguments -WorkingDirectory $root
  if ($validationResult.ExitCode -ne 0) {
    $validation = $null
    try { $validation = $validationResult.StandardOutput | ConvertFrom-Json } catch { }
    $errors = if ($null -ne $validation -and $validation.PSObject.Properties.Name -contains 'Errors') {
      @($validation.Errors)
    }
    else {
      @($validationResult.StandardError.Trim(), $validationResult.StandardOutput.Trim()) |
      Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    }
    throw "Commit message validation failed: $($errors -join '; ')"
  }

  $result = [pscustomobject]@{
    Valid        = $true
    Repository   = $root
    Decision     = if ($Apply) { 'perform' } else { 'ask' }
    Action       = 'git commit --file <reviewed message file>'
    Confirmation = if ($Apply) { 'requested by -Apply; ShouldProcess still applies' } else { 'required' }
    Result       = if ($Apply) { 'pending' } else { 'unresolved' }
    HeadBefore   = $head
    HeadAfter    = $null
    GitOutput    = $null
    MessageFile  = [System.IO.Path]::GetFullPath($MessageFile)
  }

  if ($Apply) {
    if (-not $PSCmdlet.ShouldProcess($root, 'Create one commit from the reviewed staged diff')) {
      $result.Confirmation = 'declined'
      $result.Result = 'skipped'
    }
    else {
      $commitResult = Invoke-MartixNative -FilePath $gitCommand.Source `
        -Arguments @('commit', '--file', [System.IO.Path]::GetFullPath($MessageFile)) `
        -WorkingDirectory $root
      if ($commitResult.ExitCode -ne 0) {
        throw "Git commit failed; hooks or policy may have rejected it: $($commitResult.StandardError.Trim())"
      }
      $newHead = Invoke-MartixGit -GitPath $gitCommand.Source -RepositoryRoot $root -Arguments @('rev-parse', 'HEAD')
      $result.Confirmation = 'received'
      $result.Result = 'completed'
      $result.HeadAfter = $newHead.StandardOutput.Trim()
      $result.GitOutput = ($commitResult.StandardOutput + $commitResult.StandardError).Trim()
    }
  }

  Write-MartixResult -Result $result -Json:$Json
  exit 0
}
catch {
  $result = [pscustomobject]@{
    Valid      = $false
    Repository = $RepositoryPath
    Result     = 'failed'
    Errors     = @($_.Exception.Message)
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 2
}
