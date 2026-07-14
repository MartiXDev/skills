<#
.SYNOPSIS
    Post-tool-use validation hook for AFK Copilot CLI sessions.

.DESCRIPTION
    Called by the Copilot CLI postToolUse hook after each tool execution.
    Runs the repository validation script to catch errors early so the
    agent can self-correct within the same session.

    Only runs validation — it does NOT create pull requests.
    PR creation is handled by the agent itself as the final step of its task,
    following the instructions in its .agent.md file.

    This script is intentionally silent on success to avoid polluting
    the agent's context window with noisy output.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'SilentlyContinue'

# Detect repository root via git
$repoRoot = git rev-parse --show-toplevel 2>$null
if (-not $repoRoot) { exit 0 }

$validationScript = Join-Path $repoRoot 'scripts\validate-repository.ps1'
if (-not (Test-Path $validationScript)) { exit 0 }

# Run validation — only report failures
$result = & powershell -ExecutionPolicy Bypass -File $validationScript 2>&1
$exitCode = $LASTEXITCODE

if ($exitCode -ne 0) {
  Write-Host ''
  Write-Host '=== Validation failed (post-tool-use hook) ==='
  Write-Host $result
  Write-Host '=============================================='
  Write-Host ''
  # Exit 0 so the hook does not terminate the agent session —
  # the output above is sufficient for the agent to self-correct.
}

exit 0
