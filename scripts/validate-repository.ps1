param(
    [switch]$AllowMissingEvals,
    [switch]$AllowIncompletePlugins
)

$ErrorActionPreference = 'Stop'

$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$issues = New-Object System.Collections.Generic.List[object]
$warnings = New-Object System.Collections.Generic.List[object]

function Get-RelativePath {
    param([string]$Path)

    $resolved = (Resolve-Path -LiteralPath $Path).Path
    if ($resolved.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $resolved.Substring($root.Length).TrimStart('\')
    }

    return $resolved
}

function Add-Issue {
    param(
        [string]$File,
        [string]$Message
    )

    $issues.Add([pscustomobject]@{
        File = $File
        Message = $Message
    }) | Out-Null
}

function Add-Warning {
    param(
        [string]$File,
        [string]$Message
    )

    $warnings.Add([pscustomobject]@{
        File = $File
        Message = $Message
    }) | Out-Null
}

function Read-JsonFile {
    param([string]$Path)

    try {
        return Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        Add-Issue -File (Get-RelativePath $Path) -Message "Invalid JSON: $($_.Exception.Message)"
        return $null
    }
}

Push-Location $root
try {
    $jsonFiles = Get-ChildItem -Recurse -File -Include *.json |
        Where-Object { $_.FullName -notmatch '\\.git\\' }

    foreach ($file in $jsonFiles) {
        [void](Read-JsonFile -Path $file.FullName)
    }

    $yamlFiles = Get-ChildItem -Recurse -File -Include *.yml,*.yaml |
        Where-Object { $_.FullName -notmatch '\\.git\\' }

    if ($yamlFiles) {
        $pythonCommand = Get-Command python -ErrorAction SilentlyContinue
        $hasPyYaml = $false

        if ($pythonCommand) {
            $previousErrorActionPreference = $ErrorActionPreference
            $ErrorActionPreference = 'Continue'
            try {
                $yamlProbe = & $pythonCommand.Source -c "import yaml" 2>$null
                $hasPyYaml = ($LASTEXITCODE -eq 0)
            }
            catch {
                $hasPyYaml = $false
            }
            finally {
                $ErrorActionPreference = $previousErrorActionPreference
            }
        }

        if ($hasPyYaml) {
            foreach ($file in $yamlFiles) {
                $output = & $pythonCommand.Source -c "import sys,yaml; yaml.safe_load(open(sys.argv[1], encoding='utf-8'))" $file.FullName 2>&1
                if ($LASTEXITCODE -ne 0) {
                    Add-Issue -File (Get-RelativePath $file.FullName) -Message "Invalid YAML: $($output -join ' ')"
                }
            }
        }
        else {
            foreach ($file in $yamlFiles) {
                $content = Get-Content -LiteralPath $file.FullName -Raw
                if ($content -match "`t") {
                    Add-Issue -File (Get-RelativePath $file.FullName) -Message 'YAML contains tab indentation.'
                }
            }

            Add-Warning -File 'YAML parser' -Message 'PyYAML is not available; performed only lightweight YAML checks.'
        }
    }

    $marketplacePath = Join-Path $root '.github\plugin\marketplace.json'
    $marketplace = Read-JsonFile -Path $marketplacePath

    if ($marketplace) {
        foreach ($entry in @($marketplace.plugins)) {
            $source = [string]$entry.source
            if ([string]::IsNullOrWhiteSpace($source)) {
                Add-Issue -File '.github\plugin\marketplace.json' -Message "Entry '$($entry.name)' has no source."
                continue
            }

            $sourcePath = Join-Path $root ($source -replace '/', '\')
            $manifestPath = Join-Path $sourcePath 'plugin.json'

            if (-not (Test-Path -LiteralPath $manifestPath)) {
                Add-Issue -File '.github\plugin\marketplace.json' -Message "Entry '$($entry.name)' points to missing manifest '$source\plugin.json'."
                continue
            }

            $manifest = Read-JsonFile -Path $manifestPath
            if (-not $manifest) {
                continue
            }

            if ($entry.name -ne $manifest.name) {
                Add-Issue -File '.github\plugin\marketplace.json' -Message "Entry '$($entry.name)' name does not match source manifest name '$($manifest.name)'."
            }

            if ($entry.version -ne $manifest.version) {
                Add-Issue -File '.github\plugin\marketplace.json' -Message "Entry '$($entry.name)' version '$($entry.version)' does not match source manifest version '$($manifest.version)'."
            }

            if ($entry.description -ne $manifest.description) {
                Add-Issue -File '.github\plugin\marketplace.json' -Message "Entry '$($entry.name)' description does not match source manifest description."
            }
        }
    }

    $requiredSkillItems = @(
        'plugin.json',
        'metadata.json',
        'README.md',
        'SKILL.md',
        'AGENTS.md',
        'LICENSE.txt',
        'rules',
        'references',
        'templates',
        'assets\taxonomy.json',
        'assets\section-order.json',
        'evals\evals.json'
    )

    $allowedModelTiers = @('cheap', 'medium', 'balanced', 'premium', 'mixed')
    $allowedTokenBudgets = @('small', 'medium', 'large')
    $allowedParallelSafety = @(
        'single-package',
        'multi-package-readonly',
        'shared-file-coordinator',
        'not-parallel-safe'
    )

    Get-ChildItem -LiteralPath (Join-Path $root 'skills') -Directory | ForEach-Object {
        foreach ($item in $requiredSkillItems) {
            $candidate = Join-Path $_.FullName $item
            if (-not (Test-Path -LiteralPath $candidate)) {
                $message = "Missing required skill item '$item'."
                if ($item -eq 'evals\evals.json' -and $AllowMissingEvals) {
                    Add-Warning -File (Get-RelativePath $_.FullName) -Message $message
                }
                else {
                    Add-Issue -File (Get-RelativePath $_.FullName) -Message $message
                }
            }
        }

        $metadataPath = Join-Path $_.FullName 'metadata.json'
        if (Test-Path -LiteralPath $metadataPath) {
            $metadataRaw = Get-Content -LiteralPath $metadataPath -Raw
            if ($metadataRaw -match 'ai-marketplace') {
                Add-Issue -File (Get-RelativePath $metadataPath) -Message "metadata.json contains stale 'ai-marketplace' reference."
            }

            if ($metadataRaw -match 'src[\\/]+skills') {
                Add-Issue -File (Get-RelativePath $metadataPath) -Message "metadata.json contains stale 'src\skills' reference."
            }

            $metadata = Read-JsonFile -Path $metadataPath
            if ($metadata) {
                if (-not $metadata.executionProfile) {
                    Add-Issue -File (Get-RelativePath $metadataPath) -Message "metadata.json must define executionProfile."
                }
                else {
                    $modelTier = [string]$metadata.executionProfile.modelTier
                    if ([string]::IsNullOrWhiteSpace($modelTier) -or $modelTier -notin $allowedModelTiers) {
                        Add-Issue -File (Get-RelativePath $metadataPath) -Message "executionProfile.modelTier must be one of: $($allowedModelTiers -join ', ')."
                    }

                    $tokenBudget = [string]$metadata.executionProfile.tokenBudget
                    if ([string]::IsNullOrWhiteSpace($tokenBudget) -or $tokenBudget -notin $allowedTokenBudgets) {
                        Add-Issue -File (Get-RelativePath $metadataPath) -Message "executionProfile.tokenBudget must be one of: $($allowedTokenBudgets -join ', ')."
                    }

                    $parallelSafety = [string]$metadata.executionProfile.parallelSafety
                    if ([string]::IsNullOrWhiteSpace($parallelSafety) -or $parallelSafety -notin $allowedParallelSafety) {
                        Add-Issue -File (Get-RelativePath $metadataPath) -Message "executionProfile.parallelSafety must be one of: $($allowedParallelSafety -join ', ')."
                    }
                }
            }
        }

        $skillMdPath = Join-Path $_.FullName 'SKILL.md'
        if (Test-Path -LiteralPath $skillMdPath) {
            $skillMdRaw = Get-Content -LiteralPath $skillMdPath -Raw
            if ($skillMdRaw -match 'ai-marketplace|src[\\/]+skills') {
                Add-Issue -File (Get-RelativePath $skillMdPath) -Message "SKILL.md contains stale repository or src\skills path reference."
            }

            $skillMdLineCount = (Get-Content -LiteralPath $skillMdPath).Count
            if ($skillMdLineCount -gt 200) {
                Add-Warning -File (Get-RelativePath $skillMdPath) -Message "SKILL.md has $skillMdLineCount lines. Keep entrypoints compact and move durable detail to rules or references."
            }
        }

        $evalPath = Join-Path $_.FullName 'evals\evals.json'
        if (Test-Path -LiteralPath $evalPath) {
            $evalDoc = Read-JsonFile -Path $evalPath
            if ($evalDoc) {
                if ([string]::IsNullOrWhiteSpace($evalDoc.skill)) {
                    Add-Issue -File (Get-RelativePath $evalPath) -Message "Eval file must declare a top-level 'skill' value."
                }
                elseif ($evalDoc.skill -ne $_.Name) {
                    Add-Issue -File (Get-RelativePath $evalPath) -Message "Eval skill '$($evalDoc.skill)' does not match package '$($_.Name)'."
                }

                if (-not $evalDoc.evals -or @($evalDoc.evals).Count -eq 0) {
                    Add-Issue -File (Get-RelativePath $evalPath) -Message "Eval file must contain at least one eval."
                }

                $hasNegativeActivation = $false
                foreach ($eval in @($evalDoc.evals)) {
                    if ([string]::IsNullOrWhiteSpace([string]$eval.id)) {
                        Add-Issue -File (Get-RelativePath $evalPath) -Message "Every eval must have a non-empty string id."
                    }
                    elseif ($eval.id -isnot [string]) {
                        Add-Issue -File (Get-RelativePath $evalPath) -Message "Eval id '$($eval.id)' must be a string."
                    }

                    if ([string]::IsNullOrWhiteSpace($eval.prompt)) {
                        Add-Issue -File (Get-RelativePath $evalPath) -Message "Eval '$($eval.id)' must have a prompt."
                    }

                    if (-not $eval.expected_output -and -not $eval.expected_sections) {
                        Add-Issue -File (Get-RelativePath $evalPath) -Message "Eval '$($eval.id)' must define expected_output or expected_sections."
                    }

                    $evalModelTier = [string]$eval.model_tier
                    if ([string]::IsNullOrWhiteSpace($evalModelTier) -or $evalModelTier -notin $allowedModelTiers) {
                        Add-Issue -File (Get-RelativePath $evalPath) -Message "Eval '$($eval.id)' model_tier must be one of: $($allowedModelTiers -join ', ')."
                    }

                    if ($null -eq $eval.parallel_safe) {
                        Add-Issue -File (Get-RelativePath $evalPath) -Message "Eval '$($eval.id)' must declare parallel_safe."
                    }
                    elseif ($eval.parallel_safe -isnot [bool]) {
                        Add-Issue -File (Get-RelativePath $evalPath) -Message "Eval '$($eval.id)' parallel_safe must be a boolean."
                    }

                    $evalTokenBudget = [string]$eval.token_budget
                    if (-not [string]::IsNullOrWhiteSpace($evalTokenBudget) -and $evalTokenBudget -notin $allowedTokenBudgets) {
                        Add-Issue -File (Get-RelativePath $evalPath) -Message "Eval '$($eval.id)' token_budget must be one of: $($allowedTokenBudgets -join ', ')."
                    }

                    if ($evalModelTier -eq 'cheap' -and $evalTokenBudget -eq 'large') {
                        Add-Issue -File (Get-RelativePath $evalPath) -Message "Eval '$($eval.id)' cannot combine model_tier 'cheap' with token_budget 'large'."
                    }

                    foreach ($evalFile in @($eval.files)) {
                        if ([string]::IsNullOrWhiteSpace([string]$evalFile)) {
                            continue
                        }

                        $resolvedEvalFile = [System.IO.Path]::GetFullPath(
                            (Join-Path $_.FullName ([string]$evalFile -replace '/', '\'))
                        )
                        if (-not (Test-Path -LiteralPath $resolvedEvalFile)) {
                            Add-Issue -File (Get-RelativePath $evalPath) -Message "Eval '$($eval.id)' references missing file '$evalFile'."
                        }
                    }

                    if ($eval.negative_activation -eq $true) {
                        $hasNegativeActivation = $true
                    }
                }

                if (-not $hasNegativeActivation) {
                    Add-Warning -File (Get-RelativePath $evalPath) -Message "Eval file has no negative_activation eval for scope-boundary routing."
                }
            }
        }
    }

    $requiredPluginItems = @('plugin.json', 'agents', 'skills', 'prompts', 'instructions', 'hooks')
    Get-ChildItem -LiteralPath (Join-Path $root 'plugins') -Directory | ForEach-Object {
        foreach ($item in $requiredPluginItems) {
            $candidate = Join-Path $_.FullName $item
            if (-not (Test-Path -LiteralPath $candidate)) {
                $message = "Missing required plugin item '$item'."
                if ($AllowIncompletePlugins) {
                    Add-Warning -File (Get-RelativePath $_.FullName) -Message $message
                }
                else {
                    Add-Issue -File (Get-RelativePath $_.FullName) -Message $message
                }
            }
        }
    }

    $markdownFiles = Get-ChildItem -Recurse -File -Include README*.md,readme*.md,repo-overview.md |
        Where-Object { $_.FullName -notmatch '\\.git\\' }

    foreach ($file in $markdownFiles) {
        $text = Get-Content -LiteralPath $file.FullName -Raw
        $fenceCount = ([regex]::Matches($text, '(?m)^```')).Count
        if ($fenceCount % 2 -ne 0) {
            Add-Issue -File (Get-RelativePath $file.FullName) -Message "Unbalanced Markdown code fences: $fenceCount fences found."
        }

        foreach ($match in [regex]::Matches($text, '\[[^\]]+\]\(([^)]+)\)')) {
            $target = $match.Groups[1].Value
            if ($target -match '^(https?:|mailto:|#)' -or [string]::IsNullOrWhiteSpace($target)) {
                continue
            }

            $pathPart = ($target -split '#')[0]
            if ([string]::IsNullOrWhiteSpace($pathPart)) {
                continue
            }

            $candidate = Join-Path $file.DirectoryName ([Uri]::UnescapeDataString($pathPart) -replace '/', '\')
            if (-not (Test-Path -LiteralPath $candidate)) {
                Add-Issue -File (Get-RelativePath $file.FullName) -Message "Relative link target does not exist: $target"
            }
        }
    }

    $pathPattern = '(rules|references|templates|assets|evals)[\\/][^"'']+'
    Get-ChildItem -LiteralPath (Join-Path $root 'skills') -Directory | ForEach-Object {
        $skillDir = $_.FullName
        foreach ($assetPath in @('assets\taxonomy.json', 'assets\section-order.json')) {
            $fullAssetPath = Join-Path $skillDir $assetPath
            if (-not (Test-Path -LiteralPath $fullAssetPath)) {
                continue
            }

            $content = Get-Content -LiteralPath $fullAssetPath -Raw
            foreach ($match in [regex]::Matches($content, $pathPattern)) {
                $relativeReference = $match.Value -replace '/', '\'
                $candidate = Join-Path $skillDir $relativeReference
                if (-not (Test-Path -LiteralPath $candidate)) {
                    Add-Issue -File (Get-RelativePath $fullAssetPath) -Message "Referenced package path does not exist: $relativeReference"
                }
            }
        }
    }
}
finally {
    Pop-Location
}

foreach ($warning in $warnings) {
    Write-Warning "$($warning.File): $($warning.Message)"
}

if ($issues.Count -gt 0) {
    $issueTable = $issues | Format-Table -AutoSize | Out-String -Width 240
    Write-Host $issueTable
    exit 1
}

Write-Host "Repository validation passed."
exit 0
