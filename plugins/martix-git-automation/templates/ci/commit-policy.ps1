[CmdletBinding()]
param(
  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [string] $BaseRef = 'HEAD~1'
)

$ErrorActionPreference = 'Stop'
$root = [System.IO.Path]::GetFullPath($RepositoryPath)
$commitMessages = @(git -C $root log --format=%H --no-merges "$BaseRef..HEAD")
if ($LASTEXITCODE -ne 0) { throw 'Unable to resolve the commit range for policy validation.' }
$validator = Join-Path $PSScriptRoot '..\..\hooks\validate-commit-message.ps1'
foreach ($commit in $commitMessages) {
  $messagePath = Join-Path ([System.IO.Path]::GetTempPath()) ("martix-commit-$commit.txt")
  try {
    git -C $root show -s --format=%B $commit | Set-Content -LiteralPath $messagePath -Encoding utf8NoBOM
    & $validator -RepositoryPath $root -MessageFile $messagePath
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  }
  finally {
    Remove-Item -LiteralPath $messagePath -Force -ErrorAction SilentlyContinue
  }
}
