[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('Quick', 'Stop', 'CI')]
    [string] $Phase,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string] $ConfigPath = (Join-Path -Path $PSScriptRoot -ChildPath '../../ai/project.json')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$resolvedConfig = (Resolve-Path -LiteralPath $ConfigPath).Path
$repositoryRoot = Split-Path -Parent (Split-Path -Parent $resolvedConfig)
$config = Get-Content -Raw -LiteralPath $resolvedConfig | ConvertFrom-Json
$phaseName = $Phase.ToLowerInvariant()
$checks = @($config.phases.$phaseName)

if ($checks.Count -eq 0) {
    $exception = [System.InvalidOperationException]::new("No checks configured for phase '$Phase'.")
    $record = [System.Management.Automation.ErrorRecord]::new(
        $exception,
        'Invoke-AiChecks.EmptyPhase',
        [System.Management.Automation.ErrorCategory]::InvalidData,
        $resolvedConfig
    )
    $PSCmdlet.ThrowTerminatingError($record)
}

$executed = 0
Push-Location -LiteralPath $repositoryRoot
try {
    foreach ($checkName in $checks) {
        $property = $config.commands.PSObject.Properties[$checkName]
        if ($null -eq $property) {
            $exception = [System.InvalidOperationException]::new("Phase '$Phase' references unknown check '$checkName'.")
            $record = [System.Management.Automation.ErrorRecord]::new(
                $exception,
                'Invoke-AiChecks.UnknownCheck',
                [System.Management.Automation.ErrorCategory]::InvalidData,
                $checkName
            )
            $PSCmdlet.ThrowTerminatingError($record)
        }

        $command = @($property.Value)
        if ($command.Count -eq 0) {
            Write-Warning "Skipping unconfigured check '$checkName'."
            continue
        }

        $executable = [string] $command[0]
        $arguments = @($command | Select-Object -Skip 1)
        Write-Verbose "[$Phase] $checkName -> $executable $($arguments -join ' ')"
        & $executable @arguments
        if ($LASTEXITCODE -ne 0) {
            $exception = [System.InvalidOperationException]::new("Check '$checkName' failed with exit code $LASTEXITCODE.")
            $record = [System.Management.Automation.ErrorRecord]::new(
                $exception,
                'Invoke-AiChecks.CheckFailed',
                [System.Management.Automation.ErrorCategory]::InvalidResult,
                $checkName
            )
            $PSCmdlet.ThrowTerminatingError($record)
        }
        $executed++
    }
}
finally {
    Pop-Location
}

if ($executed -eq 0) {
    $exception = [System.InvalidOperationException]::new("All checks for phase '$Phase' are unconfigured. Update ai/project.json.")
    $record = [System.Management.Automation.ErrorRecord]::new(
        $exception,
        'Invoke-AiChecks.AllChecksUnconfigured',
        [System.Management.Automation.ErrorCategory]::InvalidData,
        $resolvedConfig
    )
    $PSCmdlet.ThrowTerminatingError($record)
}

[pscustomobject]@{
    Phase = $Phase
    ExecutedChecks = $executed
    Succeeded = $true
}

