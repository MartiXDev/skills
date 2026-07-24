[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string] $RepositoryPath = (Get-Location).Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = [System.IO.Path]::GetFullPath($RepositoryPath)
$git = Get-Command -Name git -ErrorAction SilentlyContinue
$branch = $null
$status = @()
$changedFiles = @()

if ($git -and (Test-Path -LiteralPath (Join-Path -Path $root -ChildPath '.git'))) {
    $branch = (& git -C $root branch --show-current 2>$null | Select-Object -First 1)
    $status = @(& git -C $root status --porcelain=v1 2>$null)
    $changedFiles = @(
        $status |
            ForEach-Object {
                if ($_.Length -gt 3) {
                    $_.Substring(3)
                }
            } |
            Select-Object -First 200
    )
}

$tools = [ordered]@{}
foreach ($name in @('git', 'dotnet', 'node', 'npm', 'pnpm', 'python', 'python3', 'docker')) {
    $command = Get-Command -Name $name -ErrorAction SilentlyContinue
    if ($command) {
        $tools[$name] = $command.Source
    }
}

[ordered]@{
    repositoryPath = $root
    branch = $branch
    dirty = ($status.Count -gt 0)
    changedFiles = $changedFiles
    availableTools = $tools
} | ConvertTo-Json -Depth 5 -Compress

