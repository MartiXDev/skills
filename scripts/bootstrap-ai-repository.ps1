<#
.SYNOPSIS
Creates a layered, template-driven AI development scaffold in a repository.

.DESCRIPTION
Reads all generated file content from an external template root. Selects base,
profile, technology and exact-combination layers from manifest.json. Normal
template files replace a destination; files ending in .prepend or .append are
composed around the selected replacement template.

Existing destination files are skipped unless -Force is supplied. Every write
and optional Git initialization is guarded by ShouldProcess, so -WhatIf has no
side effects.

.PARAMETER RepositoryPath
Target repository directory. The directory is created when it does not exist.

.PARAMETER Profile
Scaffold breadth: Minimal, Standard or Full.

.PARAMETER Technology
Zero or more technology layer names declared in the template manifest, for
example dotnet or node-pnpm.

.PARAMETER TemplateRoot
Directory containing manifest.json and all template layers. Defaults to the
bootstrap-ai-repository.templates directory next to this script.

.PARAMETER InitializeGit
Initializes a Git repository when the target does not already contain .git.

.PARAMETER Force
Allows selected templates to overwrite existing destination files. Force never
bypasses ShouldProcess, so -Force -WhatIf remains side-effect free.

.PARAMETER ListTechnology
Lists technology and combination layers from the manifest without changing a
repository.

.EXAMPLE
./bootstrap-ai-repository.ps1 -ListTechnology

Lists supported technologies and predefined combinations.

.EXAMPLE
./bootstrap-ai-repository.ps1 -RepositoryPath C:\src\App -Profile Standard -Technology dotnet -InitializeGit -WhatIf

Shows which .NET scaffold files would be created without changing the target.

.EXAMPLE
./bootstrap-ai-repository.ps1 -RepositoryPath C:\src\Portal -Profile Full -Technology dotnet,node-pnpm -InitializeGit

Applies the base, Standard, Full, both technology and exact combination layers.

.OUTPUTS
System.Management.Automation.PSCustomObject. Emits technology descriptions in
list mode or one scaffold result object after generation.

.NOTES
Template schema version: 1. The orchestrator intentionally contains no generated
file bodies; those are independently versioned under the template root.
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
[OutputType([System.Management.Automation.PSCustomObject])]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string] $RepositoryPath = (Get-Location).Path,

    [Parameter()]
    [ValidateSet('Minimal', 'Standard', 'Full')]
    [string] $Profile = 'Standard',

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string[]] $Technology = @(),

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string] $TemplateRoot = (Join-Path -Path $PSScriptRoot -ChildPath 'bootstrap-ai-repository.templates'),

    [Parameter()]
    [switch] $InitializeGit,

    [Parameter()]
    [switch] $Force,

    [Parameter()]
    [switch] $ListTechnology
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function New-BootstrapErrorRecord {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.ErrorRecord])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Message,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $ErrorId,

        [Parameter(Mandatory)]
        [System.Management.Automation.ErrorCategory] $Category,

        [Parameter()]
        [AllowNull()]
        [object] $TargetObject
    )

    $exception = [System.InvalidOperationException]::new($Message)
    [System.Management.Automation.ErrorRecord]::new(
        $exception,
        $ErrorId,
        $Category,
        $TargetObject
    )
}

function Get-NormalizedTechnologySet {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter()]
        [AllowEmptyCollection()]
        [string[]] $Name = @()
    )

    @(
        $Name |
            ForEach-Object { $_ -split ',' } |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
            ForEach-Object { $_.Trim().ToLowerInvariant() } |
            Sort-Object -Unique
    )
}

function Test-ExactSetMatch {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter()]
        [AllowEmptyCollection()]
        [string[]] $Left = @(),

        [Parameter()]
        [AllowEmptyCollection()]
        [string[]] $Right = @()
    )

    $normalizedLeft = @(Get-NormalizedTechnologySet -Name $Left)
    $normalizedRight = @(Get-NormalizedTechnologySet -Name $Right)
    if ($normalizedLeft.Count -ne $normalizedRight.Count) {
        return $false
    }

    foreach ($item in $normalizedLeft) {
        if ($item -notin $normalizedRight) {
            return $false
        }
    }

    return $true
}

function Test-AllSetMembersPresent {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter()]
        [AllowEmptyCollection()]
        [string[]] $Required = @(),

        [Parameter()]
        [AllowEmptyCollection()]
        [string[]] $Actual = @()
    )

    $normalizedActual = @(Get-NormalizedTechnologySet -Name $Actual)
    foreach ($item in (Get-NormalizedTechnologySet -Name $Required)) {
        if ($item -notin $normalizedActual) {
            return $false
        }
    }

    return $true
}

$templateRootPath = [System.IO.Path]::GetFullPath($TemplateRoot)
$manifestPath = Join-Path -Path $templateRootPath -ChildPath 'manifest.json'
if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
    $PSCmdlet.ThrowTerminatingError((New-BootstrapErrorRecord `
        -Message "Template manifest was not found: $manifestPath" `
        -ErrorId 'BootstrapAiRepository.ManifestNotFound' `
        -Category ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
        -TargetObject $manifestPath))
}

try {
    $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
}
catch {
    $PSCmdlet.ThrowTerminatingError((New-BootstrapErrorRecord `
        -Message "Template manifest is not valid JSON: $($_.Exception.Message)" `
        -ErrorId 'BootstrapAiRepository.InvalidManifestJson' `
        -Category ([System.Management.Automation.ErrorCategory]::InvalidData) `
        -TargetObject $manifestPath))
}

if ($manifest.schemaVersion -ne 1) {
    $PSCmdlet.ThrowTerminatingError((New-BootstrapErrorRecord `
        -Message "Unsupported template manifest schema version '$($manifest.schemaVersion)'." `
        -ErrorId 'BootstrapAiRepository.UnsupportedManifestSchema' `
        -Category ([System.Management.Automation.ErrorCategory]::InvalidData) `
        -TargetObject $manifest.schemaVersion))
}

if ($ListTechnology) {
    foreach ($technologyLayer in $manifest.technologyLayers) {
        [pscustomobject]@{
            Type = 'Technology'
            Name = [string] $technologyLayer.name
            Description = [string] $technologyLayer.description
            Match = $null
            Members = @([string] $technologyLayer.name)
        }
    }

    foreach ($combinationLayer in $manifest.combinationLayers) {
        [pscustomobject]@{
            Type = 'Combination'
            Name = [string] $combinationLayer.name
            Description = [string] $combinationLayer.description
            Match = [string] $combinationLayer.match
            Members = @($combinationLayer.technologies)
        }
    }
    return
}

$profileProperty = $manifest.profileLayers.PSObject.Properties[$Profile]
if ($null -eq $profileProperty) {
    $PSCmdlet.ThrowTerminatingError((New-BootstrapErrorRecord `
        -Message "Profile '$Profile' is not declared in the template manifest." `
        -ErrorId 'BootstrapAiRepository.UnknownProfile' `
        -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
        -TargetObject $Profile))
}

$requestedTechnologies = @(Get-NormalizedTechnologySet -Name $Technology)
$supportedTechnologies = @(
    $manifest.technologyLayers |
        ForEach-Object { ([string] $_.name).ToLowerInvariant() } |
        Sort-Object -Unique
)
$unknownTechnologies = @($requestedTechnologies | Where-Object { $_ -notin $supportedTechnologies })
if ($unknownTechnologies.Count -gt 0) {
    $PSCmdlet.ThrowTerminatingError((New-BootstrapErrorRecord `
        -Message "Unknown technology layer(s): $($unknownTechnologies -join ', '). Use -ListTechnology to inspect supported values." `
        -ErrorId 'BootstrapAiRepository.UnknownTechnology' `
        -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
        -TargetObject $unknownTechnologies))
}

$selectedLayers = [System.Collections.Generic.List[object]]::new()
foreach ($profileLayer in @($profileProperty.Value)) {
    $selectedLayers.Add([pscustomobject]@{
        Name = "profile:${Profile}:$($profileLayer.path)"
        RelativePath = [string] $profileLayer.path
        Priority = [int] $profileLayer.priority
    })
}

foreach ($technologyLayer in $manifest.technologyLayers) {
    $normalizedName = ([string] $technologyLayer.name).ToLowerInvariant()
    if ($normalizedName -in $requestedTechnologies) {
        $selectedLayers.Add([pscustomobject]@{
            Name = "technology:$normalizedName"
            RelativePath = [string] $technologyLayer.path
            Priority = [int] $technologyLayer.priority
        })
    }
}

foreach ($combinationLayer in $manifest.combinationLayers) {
    $matchMode = [string] $combinationLayer.match
    $members = @($combinationLayer.technologies)
    $matches = switch ($matchMode) {
        'Exact' { Test-ExactSetMatch -Left $members -Right $requestedTechnologies }
        'All' { Test-AllSetMembersPresent -Required $members -Actual $requestedTechnologies }
        default {
            $PSCmdlet.ThrowTerminatingError((New-BootstrapErrorRecord `
                -Message "Combination '$($combinationLayer.name)' has unsupported match mode '$matchMode'." `
                -ErrorId 'BootstrapAiRepository.UnsupportedCombinationMatch' `
                -Category ([System.Management.Automation.ErrorCategory]::InvalidData) `
                -TargetObject $combinationLayer.name))
        }
    }

    if ($matches) {
        $selectedLayers.Add([pscustomobject]@{
            Name = "combination:$($combinationLayer.name)"
            RelativePath = [string] $combinationLayer.path
            Priority = [int] $combinationLayer.priority
        })
    }
}

$root = [System.IO.Path]::GetFullPath($RepositoryPath)
$rootPrefix = $root.TrimEnd(
    [System.IO.Path]::DirectorySeparatorChar,
    [System.IO.Path]::AltDirectorySeparatorChar
) + [System.IO.Path]::DirectorySeparatorChar
$templatePrefix = $templateRootPath.TrimEnd(
    [System.IO.Path]::DirectorySeparatorChar,
    [System.IO.Path]::AltDirectorySeparatorChar
) + [System.IO.Path]::DirectorySeparatorChar

$contributions = [System.Collections.Generic.List[object]]::new()
foreach ($layer in $selectedLayers) {
    $layerPath = [System.IO.Path]::GetFullPath((Join-Path -Path $templateRootPath -ChildPath $layer.RelativePath))
    if (-not $layerPath.StartsWith($templatePrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        $PSCmdlet.ThrowTerminatingError((New-BootstrapErrorRecord `
            -Message "Template layer escapes the template root: $($layer.RelativePath)" `
            -ErrorId 'BootstrapAiRepository.LayerOutsideTemplateRoot' `
            -Category ([System.Management.Automation.ErrorCategory]::SecurityError) `
            -TargetObject $layer.RelativePath))
    }
    if (-not (Test-Path -LiteralPath $layerPath -PathType Container)) {
        $PSCmdlet.ThrowTerminatingError((New-BootstrapErrorRecord `
            -Message "Selected template layer does not exist: $layerPath" `
            -ErrorId 'BootstrapAiRepository.LayerNotFound' `
            -Category ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
            -TargetObject $layerPath))
    }

    foreach ($sourceFile in (Get-ChildItem -LiteralPath $layerPath -File -Recurse -Force)) {
        $relativePath = [System.IO.Path]::GetRelativePath($layerPath, $sourceFile.FullName)
        $operation = 'Replace'
        $targetRelativePath = $relativePath
        if ($relativePath.EndsWith('.append', [System.StringComparison]::OrdinalIgnoreCase)) {
            $operation = 'Append'
            $targetRelativePath = $relativePath.Substring(0, $relativePath.Length - '.append'.Length)
        }
        elseif ($relativePath.EndsWith('.prepend', [System.StringComparison]::OrdinalIgnoreCase)) {
            $operation = 'Prepend'
            $targetRelativePath = $relativePath.Substring(0, $relativePath.Length - '.prepend'.Length)
        }

        if ([string]::IsNullOrWhiteSpace($targetRelativePath) -or [System.IO.Path]::IsPathRooted($targetRelativePath)) {
            $PSCmdlet.ThrowTerminatingError((New-BootstrapErrorRecord `
                -Message "Template maps to an invalid target path: $relativePath" `
                -ErrorId 'BootstrapAiRepository.InvalidTargetPath' `
                -Category ([System.Management.Automation.ErrorCategory]::InvalidData) `
                -TargetObject $sourceFile.FullName))
        }

        $resolvedTarget = [System.IO.Path]::GetFullPath((Join-Path -Path $root -ChildPath $targetRelativePath))
        if (-not $resolvedTarget.StartsWith($rootPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
            $PSCmdlet.ThrowTerminatingError((New-BootstrapErrorRecord `
                -Message "Template target escapes the repository root: $targetRelativePath" `
                -ErrorId 'BootstrapAiRepository.TargetOutsideRepository' `
                -Category ([System.Management.Automation.ErrorCategory]::SecurityError) `
                -TargetObject $targetRelativePath))
        }

        $contributions.Add([pscustomobject]@{
            Target = $targetRelativePath.Replace([System.IO.Path]::AltDirectorySeparatorChar, [System.IO.Path]::DirectorySeparatorChar)
            Source = $sourceFile.FullName
            Operation = $operation
            Priority = [int] $layer.Priority
            Layer = [string] $layer.Name
        })
    }
}

$renderedFiles = [System.Collections.Generic.List[object]]::new()
foreach ($targetGroup in ($contributions | Group-Object -Property Target | Sort-Object -Property Name)) {
    $replacements = @($targetGroup.Group | Where-Object Operation -eq 'Replace')
    if ($replacements.Count -eq 0) {
        $PSCmdlet.ThrowTerminatingError((New-BootstrapErrorRecord `
            -Message "Target '$($targetGroup.Name)' has fragments but no replacement template." `
            -ErrorId 'BootstrapAiRepository.FragmentWithoutBase' `
            -Category ([System.Management.Automation.ErrorCategory]::InvalidData) `
            -TargetObject $targetGroup.Name))
    }

    $maximumPriority = ($replacements | Measure-Object -Property Priority -Maximum).Maximum
    $winningReplacements = @($replacements | Where-Object Priority -eq $maximumPriority)
    if ($winningReplacements.Count -ne 1) {
        $sources = @($winningReplacements | ForEach-Object { $_.Source })
        $PSCmdlet.ThrowTerminatingError((New-BootstrapErrorRecord `
            -Message "Target '$($targetGroup.Name)' has ambiguous replacement templates at priority $maximumPriority. Add a higher-priority combination layer. Sources: $($sources -join ', ')" `
            -ErrorId 'BootstrapAiRepository.AmbiguousTemplateVariant' `
            -Category ([System.Management.Automation.ErrorCategory]::InvalidData) `
            -TargetObject $sources))
    }

    $prependContributions = @(
        $targetGroup.Group |
            Where-Object Operation -eq 'Prepend' |
            Sort-Object -Property Priority, Source
    )
    $appendContributions = @(
        $targetGroup.Group |
            Where-Object Operation -eq 'Append' |
            Sort-Object -Property Priority, Source
    )
    $orderedContributions = @(
        $prependContributions
        $winningReplacements[0]
        $appendContributions
    )

    $contentParts = @(
        $orderedContributions |
            ForEach-Object {
                ([System.IO.File]::ReadAllText($_.Source)).Trim("`r", "`n")
            }
    )
    $renderedFiles.Add([pscustomobject]@{
        Target = $targetGroup.Name
        Content = (($contentParts -join "`n`n") + "`n")
        Sources = @($orderedContributions | ForEach-Object { $_.Source })
    })
}

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$created = [System.Collections.Generic.List[string]]::new()
$skipped = [System.Collections.Generic.List[string]]::new()

foreach ($renderedFile in $renderedFiles) {
    $targetPath = [System.IO.Path]::GetFullPath((Join-Path -Path $root -ChildPath $renderedFile.Target))
    $targetExists = Test-Path -LiteralPath $targetPath -PathType Leaf
    if ($targetExists -and -not $Force) {
        $skipped.Add($renderedFile.Target)
        continue
    }

    $action = if ($targetExists) { 'Overwrite scaffold file' } else { 'Create scaffold file' }
    if ($PSCmdlet.ShouldProcess($targetPath, $action)) {
        $parent = Split-Path -Parent $targetPath
        [System.IO.Directory]::CreateDirectory($parent) | Out-Null
        [System.IO.File]::WriteAllText($targetPath, $renderedFile.Content, $utf8NoBom)
        $created.Add($renderedFile.Target)
    }
}

if ($InitializeGit -and -not (Test-Path -LiteralPath (Join-Path -Path $root -ChildPath '.git'))) {
    $git = Get-Command -Name git -ErrorAction SilentlyContinue
    if (-not $git) {
        $PSCmdlet.ThrowTerminatingError((New-BootstrapErrorRecord `
            -Message 'Git initialization was requested but git is not available on PATH.' `
            -ErrorId 'BootstrapAiRepository.GitNotFound' `
            -Category ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
            -TargetObject 'git'))
    }

    if ($PSCmdlet.ShouldProcess($root, 'Initialize Git repository')) {
        [System.IO.Directory]::CreateDirectory($root) | Out-Null
        & git -C $root init
        if ($LASTEXITCODE -ne 0) {
            $PSCmdlet.ThrowTerminatingError((New-BootstrapErrorRecord `
                -Message "git init failed with exit code $LASTEXITCODE." `
                -ErrorId 'BootstrapAiRepository.GitInitializationFailed' `
                -Category ([System.Management.Automation.ErrorCategory]::InvalidResult) `
                -TargetObject $root))
        }
    }
}

[pscustomobject]@{
    RepositoryPath = $root
    TemplateRoot = $templateRootPath
    Profile = $Profile
    Technologies = $requestedTechnologies
    SelectedLayers = @($selectedLayers | ForEach-Object { $_.Name })
    RenderedFiles = $renderedFiles.Count
    CreatedOrUpdated = $created.Count
    SkippedExisting = $skipped.Count
    CreatedFiles = $created
    SkippedFiles = $skipped
}
