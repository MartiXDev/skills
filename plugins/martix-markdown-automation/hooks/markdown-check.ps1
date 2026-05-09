param(
    [switch]$CheckOnly,
    [switch]$All,
    [string[]]$Path
)

$ErrorActionPreference = 'Stop'

function Get-RepoRoot {
    $root = git rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($root)) {
        return $root.Trim()
    }

    return (Get-Location).Path
}

function Convert-ToRepoRelativePath {
    param(
        [string]$RepoRoot,
        [string]$InputPath
    )

    $fullPath = if ([System.IO.Path]::IsPathRooted($InputPath)) {
        [System.IO.Path]::GetFullPath($InputPath)
    }
    else {
        [System.IO.Path]::GetFullPath((Join-Path $RepoRoot $InputPath))
    }

    if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
        return $null
    }

    if (-not $fullPath.EndsWith('.md', [System.StringComparison]::OrdinalIgnoreCase)) {
        return $null
    }

    if ($fullPath.StartsWith($RepoRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $fullPath.Substring($RepoRoot.Length).TrimStart('\') -replace '\\', '/'
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

$repoRoot = Get-RepoRoot
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
