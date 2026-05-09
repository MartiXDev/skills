param(
    [switch]$CheckOnly,
    [switch]$All,
    [string[]]$Path
)

$ErrorActionPreference = 'Stop'

function Get-RepoRoot {
    param([switch]$AllowFallback)

    $root = git rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($root)) {
        return [System.IO.Path]::GetFullPath($root.Trim())
    }

    if ($AllowFallback) {
        return [System.IO.Path]::GetFullPath((Get-Location).Path)
    }

    throw 'Unable to determine repository root using git. Run from a git repository or invoke the script with explicit Markdown targets.'
}

function Convert-ToRepoRelativePath {
    param(
        [string]$RepoRoot,
        [string]$InputPath
    )

    $normalizedRepoRoot = $RepoRoot.TrimEnd('\', '/')

    $fullPath = if ([System.IO.Path]::IsPathRooted($InputPath)) {
        [System.IO.Path]::GetFullPath($InputPath)
    }
    else {
        [System.IO.Path]::GetFullPath((Join-Path $normalizedRepoRoot $InputPath))
    }

    if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
        return $null
    }

    if (-not $fullPath.EndsWith('.md', [System.StringComparison]::OrdinalIgnoreCase)) {
        return $null
    }

    $runningOnWindows = [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Windows)
    $comparison = if ($runningOnWindows) { [System.StringComparison]::OrdinalIgnoreCase } else { [System.StringComparison]::Ordinal }
    $hasRepoPrefixSeparator = $fullPath.Length -gt $normalizedRepoRoot.Length -and (
        $fullPath[$normalizedRepoRoot.Length] -eq [System.IO.Path]::DirectorySeparatorChar -or
        $fullPath[$normalizedRepoRoot.Length] -eq [System.IO.Path]::AltDirectorySeparatorChar
    )

    $matchesRepoPrefix = $fullPath.StartsWith($normalizedRepoRoot, $comparison)
    $isExactRepoPath = $fullPath.Length -eq $normalizedRepoRoot.Length
    if ($matchesRepoPrefix -and ($isExactRepoPath -or $hasRepoPrefixSeparator)) {
        return $fullPath.Substring($normalizedRepoRoot.Length).TrimStart('\', '/') -replace '\\', '/'
    }

    return $fullPath
}

function Get-ChangedMarkdownFiles {
    param([string]$RepoRoot)

    $paths = New-Object System.Collections.Generic.List[string]

    $gitCommands = @(
        @('diff', '--name-only', '--diff-filter=ACMR', 'HEAD', '--', '*.md'),
        @('diff', '--cached', '--name-only', '--diff-filter=ACMR', '--', '*.md'),
        @('ls-files', '--others', '--exclude-standard', '--', '*.md')
    )

    foreach ($arguments in $gitCommands) {
        $output = & git @arguments 2>$null
        if ($LASTEXITCODE -eq 0 -and $output) {
            foreach ($line in $output) {
                if (-not [string]::IsNullOrWhiteSpace($line)) {
                    $paths.Add($line.Trim()) | Out-Null
                }
            }
        }
    }

    return $paths
}

$hasExplicitTargets = $All -or ($null -ne $Path -and $Path.Count -gt 0)
$repoRoot = Get-RepoRoot -AllowFallback:$hasExplicitTargets
Push-Location $repoRoot
try {
    $candidatePaths = if ($Path) {
        $Path |
            ForEach-Object { $_ -split ',' } |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
            ForEach-Object { $_.Trim() }
    }
    elseif ($All) {
        Get-ChildItem -Recurse -File -Filter *.md |
            Where-Object { $_.FullName -notmatch '\\.git\\' } |
            ForEach-Object { $_.FullName }
    }
    else {
        Get-ChangedMarkdownFiles -RepoRoot $repoRoot
    }

    $markdownFiles = @(
        $candidatePaths |
            ForEach-Object { Convert-ToRepoRelativePath -RepoRoot $repoRoot -InputPath $_ } |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
            Sort-Object -Unique
    )

    if ($markdownFiles.Count -eq 0) {
        Write-Host 'No Markdown files to check.'
        exit 0
    }

    Write-Host "Markdown files: $($markdownFiles.Count)"

    if (-not $CheckOnly) {
        Write-Host 'Running markdownlint-cli2 auto-fix...'
        & npx --yes markdownlint-cli2 --fix @markdownFiles
        $fixExitCode = $LASTEXITCODE
        if ($fixExitCode -ne 0) {
            Write-Warning "Auto-fix completed with exit code $fixExitCode; rerunning check to report remaining issues."
        }
    }

    Write-Host 'Running markdownlint-cli2 check...'
    & npx --yes markdownlint-cli2 @markdownFiles
    $checkExitCode = $LASTEXITCODE

    if ($checkExitCode -ne 0) {
        Write-Error "Markdown check failed. Fix the remaining issues or document a narrow exception."
        exit $checkExitCode
    }

    Write-Host 'Markdown check passed.'
}
finally {
    Pop-Location
}
