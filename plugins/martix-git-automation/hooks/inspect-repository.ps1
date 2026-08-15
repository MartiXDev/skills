[CmdletBinding()]
param(
  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [string] $BaseBranch,

  [Parameter()]
  [string] $Remote = 'origin',

  [Parameter()]
  [switch] $Json
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

function Invoke-MartixGit {
  param(
    [Parameter(Mandatory)]
    [string] $GitPath,
    [Parameter(Mandatory)]
    [string] $RepositoryRoot,
    [Parameter(Mandatory)]
    [string[]] $Arguments,
    [Parameter()]
    [int[]] $AllowedExitCode = @(0)
  )

  $result = Invoke-MartixNative -FilePath $GitPath -Arguments $Arguments -WorkingDirectory $RepositoryRoot
  if ($result.ExitCode -notin $AllowedExitCode) {
    $detail = $result.StandardError.Trim()
    if ([string]::IsNullOrWhiteSpace($detail)) { $detail = $result.StandardOutput.Trim() }
    throw "git $($Arguments -join ' ') failed with exit code $($result.ExitCode): $detail"
  }
  return $result
}

function ConvertTo-MartixNulList {
  param([AllowNull()][string] $Text)

  if ([string]::IsNullOrEmpty($Text)) { return @() }
  return @(
    $Text.Split([char] 0, [System.StringSplitOptions]::RemoveEmptyEntries)
  )
}

function ConvertTo-MartixStatusEntries {
  param([AllowNull()][string] $Text)

  $tokens = @(ConvertTo-MartixNulList -Text $Text)
  $entries = [System.Collections.Generic.List[object]]::new()
  for ($index = 0; $index -lt $tokens.Count; $index++) {
    $token = $tokens[$index]
    if ($token.Length -lt 4) { continue }
    $status = $token.Substring(0, 2)
    $path = $token.Substring(3)
    $originalPath = $null
    if ($status[0] -in @('R', 'C') -or $status[1] -in @('R', 'C')) {
      if ($index + 1 -lt $tokens.Count) {
        $originalPath = $tokens[$index + 1]
        $index++
      }
    }
    [void] $entries.Add([pscustomobject]@{
        Index        = $status[0]
        Worktree     = $status[1]
        Status       = $status
        Path         = $path
        OriginalPath = $originalPath
      })
  }
  return $entries.ToArray()
}

function Get-MartixBranchRef {
  param(
    [Parameter(Mandatory)]
    [string] $GitPath,
    [Parameter(Mandatory)]
    [string] $RepositoryRoot
  )

  $symbolic = Invoke-MartixGit -GitPath $GitPath -RepositoryRoot $RepositoryRoot `
    -Arguments @('symbolic-ref', '--quiet', '--short', 'HEAD') -AllowedExitCode @(0, 1)
  if ($symbolic.ExitCode -eq 0 -and -not [string]::IsNullOrWhiteSpace($symbolic.StandardOutput)) {
    return $symbolic.StandardOutput.Trim()
  }
  return $null
}

function Resolve-MartixBaseBranch {
  param(
    [Parameter(Mandatory)]
    [string] $GitPath,
    [Parameter(Mandatory)]
    [string] $RepositoryRoot,
    [AllowNull()]
    [string] $RequestedBase
  )

  if (-not [string]::IsNullOrWhiteSpace($RequestedBase)) {
    return $RequestedBase
  }

  $originHead = Invoke-MartixGit -GitPath $GitPath -RepositoryRoot $RepositoryRoot `
    -Arguments @('symbolic-ref', '--quiet', '--short', 'refs/remotes/origin/HEAD') `
    -AllowedExitCode @(0, 1)
  if ($originHead.ExitCode -eq 0 -and -not [string]::IsNullOrWhiteSpace($originHead.StandardOutput)) {
    return ($originHead.StandardOutput.Trim() -replace '^origin/', '')
  }

  foreach ($candidate in @('main', 'master')) {
    $exists = Invoke-MartixGit -GitPath $GitPath -RepositoryRoot $RepositoryRoot `
      -Arguments @('show-ref', '--verify', '--quiet', "refs/heads/$candidate") `
      -AllowedExitCode @(0, 1)
    if ($exists.ExitCode -eq 0) { return $candidate }
  }
  return $null
}

try {
  $root = Get-MartixRepositoryRoot -RepositoryPath $RepositoryPath
  $gitCommand = Get-Command -Name git -CommandType Application -ErrorAction Stop |
  Select-Object -First 1
  $gitPath = $gitCommand.Source
  $config = Read-MartixGitConfig -RepositoryRoot $root
  $branch = Get-MartixBranchRef -GitPath $gitPath -RepositoryRoot $root
  $head = Invoke-MartixGit -GitPath $gitPath -RepositoryRoot $root -Arguments @('rev-parse', 'HEAD')
  $base = Resolve-MartixBaseBranch -GitPath $gitPath -RepositoryRoot $root -RequestedBase $BaseBranch
  $statusResult = Invoke-MartixGit -GitPath $gitPath -RepositoryRoot $root `
    -Arguments @('status', '--porcelain=v1', '-z', '--untracked-files=all')
  $statusEntries = @(ConvertTo-MartixStatusEntries -Text $statusResult.StandardOutput)
  $upstreamResult = Invoke-MartixGit -GitPath $gitPath -RepositoryRoot $root `
    -Arguments @('rev-parse', '--abbrev-ref', '--symbolic-full-name', '@{upstream}') `
    -AllowedExitCode @(0, 1, 128)
  $upstream = if ($upstreamResult.ExitCode -eq 0) { $upstreamResult.StandardOutput.Trim() } else { $null }
  $ahead = $null
  $behind = $null
  if (-not [string]::IsNullOrWhiteSpace($upstream)) {
    $divergence = Invoke-MartixGit -GitPath $gitPath -RepositoryRoot $root `
      -Arguments @('rev-list', '--left-right', '--count', "HEAD...$upstream")
    $parts = @($divergence.StandardOutput.Trim() -split '\s+')
    if ($parts.Count -eq 2) {
      $ahead = [int] $parts[0]
      $behind = [int] $parts[1]
    }
  }
  $remotes = @(Invoke-MartixGit -GitPath $gitPath -RepositoryRoot $root -Arguments @('remote')).StandardOutput |
  Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
  ForEach-Object { $_.Trim() }

  $result = [pscustomobject]@{
    Valid          = $true
    Repository     = $root
    Branch         = $branch
    Detached       = [string]::IsNullOrWhiteSpace($branch)
    Head           = $head.StandardOutput.Trim()
    BaseBranch     = $base
    Remote         = $Remote
    Remotes        = @($remotes)
    Upstream       = $upstream
    Ahead          = $ahead
    Behind         = $behind
    Status         = @($statusEntries)
    StagedPaths    = @($statusEntries | Where-Object { $_.Index -ne ' ' } | Select-Object -ExpandProperty Path)
    UnstagedPaths  = @($statusEntries | Where-Object { $_.Worktree -ne ' ' } | Select-Object -ExpandProperty Path)
    UntrackedPaths = @($statusEntries | Where-Object { $_.Status -eq '??' } | Select-Object -ExpandProperty Path)
    Dirty          = $statusEntries.Count -gt 0
    ConfigExists   = $config.ConfigExists
    ConfigPath     = $config.ConfigPath
    SchemaVersion  = $config.schemaVersion
    Policy         = $config
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 0
}
catch {
  $result = [pscustomobject]@{
    Valid      = $false
    Repository = $RepositoryPath
    Errors     = @($_.Exception.Message)
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 2
}
