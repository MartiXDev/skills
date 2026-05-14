<#
.SYNOPSIS
    AFK Dev Factory — local Copilot CLI orchestrator.

.DESCRIPTION
    Fetches GitHub issues labeled 'afk/ready', creates a git worktree per issue,
    opens VS Code at the worktree so the Copilot CLI session can be started from
    the Agents Window, and tracks session state in .worktrees/sessions.json.

    Prerequisites:
      - gh CLI authenticated (gh auth login)
      - git with worktree support
      - VS Code installed (code command in PATH)
      - .github/agent-config.json present

.PARAMETER MaxSessions
    Maximum number of parallel sessions to start in one run. Default: 3.

.PARAMETER DryRun
    Print what would be done without creating worktrees or opening VS Code.

.PARAMETER Monitor
    Print the current session state from .worktrees/sessions.json and exit.

.EXAMPLE
    .\scripts\start-afk-sessions.ps1
    .\scripts\start-afk-sessions.ps1 -MaxSessions 5
    .\scripts\start-afk-sessions.ps1 -DryRun
    .\scripts\start-afk-sessions.ps1 -Monitor
#>

[CmdletBinding()]
param(
  [int]$MaxSessions = 3,
  [switch]$DryRun,
  [switch]$Monitor
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ── Paths ──────────────────────────────────────────────────────────────────────
$repoRoot = Split-Path $PSScriptRoot -Parent
$configPath = Join-Path $repoRoot '.github\agent-config.json'
$worktreeRoot = Join-Path $repoRoot '.worktrees'
$sessionsFile = Join-Path $worktreeRoot 'sessions.json'

# ── Load config ────────────────────────────────────────────────────────────────
if (-not (Test-Path $configPath)) {
  Write-Error "agent-config.json not found at $configPath"
  exit 1
}
$config = Get-Content $configPath -Raw | ConvertFrom-Json

# ── Monitor mode ───────────────────────────────────────────────────────────────
if ($Monitor) {
  if (-not (Test-Path $sessionsFile)) {
    Write-Host 'No sessions file found. No sessions have been started yet.'
    exit 0
  }
  $sessions = Get-Content $sessionsFile -Raw | ConvertFrom-Json
  if ($sessions.Count -eq 0) {
    Write-Host 'No active sessions.'
    exit 0
  }
  Write-Host "`nAFK sessions:`n"
  foreach ($s in $sessions) {
    $worktreeExists = Test-Path $s.worktreePath
    $status = if ($worktreeExists) { 'worktree present' } else { 'worktree removed' }
    Write-Host "  Issue #$($s.issueNumber)  branch=$($s.branch)  started=$($s.startedAt)  $status"
    Write-Host "    Prompt: $($s.promptPreview)"
    Write-Host ''
  }
  exit 0
}

# ── Prerequisite checks ────────────────────────────────────────────────────────
function Assert-Command($name) {
  if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
    Write-Error "Required command '$name' not found in PATH. Install it and re-run."
    exit 1
  }
}
Assert-Command 'gh'
Assert-Command 'git'
Assert-Command 'code'

# ── Shared-file guard ──────────────────────────────────────────────────────────
function Test-TouchesSharedFiles([string[]]$filePaths) {
  foreach ($path in $filePaths) {
    foreach ($shared in $config.sharedFiles) {
      if ($path -like "*$shared*" -or $path.TrimStart('/\') -like "$shared*") {
        return $true
      }
    }
  }
  return $false
}

# ── Extract agent-prompt block from issue body ─────────────────────────────────
function Get-AgentPrompt([string]$body) {
  if ($body -match '<!--\s*agent-prompt\s*([\s\S]*?)-->') {
    $block = $Matches[1].Trim()
    if ($block -notlike '*REPLACE THIS BLOCK*' -and $block.Length -gt 10) {
      return $block
    }
  }
  return $null
}

# ── Load existing sessions ─────────────────────────────────────────────────────
if (-not (Test-Path $worktreeRoot)) {
  New-Item -ItemType Directory -Path $worktreeRoot | Out-Null
}

$sessions = @()
if (Test-Path $sessionsFile) {
  $sessions = Get-Content $sessionsFile -Raw | ConvertFrom-Json
}
$activeIssueNumbers = $sessions | ForEach-Object { $_.issueNumber }

# ── Fetch ready issues ─────────────────────────────────────────────────────────
Write-Host 'Fetching afk/ready issues...'
$issuesJson = gh issue list `
  --label 'afk/ready' `
  --state open `
  --json number, title, body, labels `
  --limit 20 `
  2>&1

if ($LASTEXITCODE -ne 0) {
  Write-Error "gh issue list failed: $issuesJson"
  exit 1
}

$issues = $issuesJson | ConvertFrom-Json

if ($issues.Count -eq 0) {
  Write-Host 'No afk/ready issues found.'
  exit 0
}

Write-Host "Found $($issues.Count) ready issue(s). Starting up to $MaxSessions session(s).`n"

$started = 0

foreach ($issue in $issues) {
  if ($started -ge $MaxSessions) {
    Write-Host "Reached MaxSessions ($MaxSessions). Stopping."
    break
  }

  # Skip already-tracked issues
  if ($activeIssueNumbers -contains $issue.number) {
    Write-Host "  #$($issue.number) — already tracked, skipping."
    continue
  }

  $labels = $issue.labels | ForEach-Object { $_.name }
  $tierLabel = $labels | Where-Object { $_ -like 'tier/*' } | Select-Object -First 1
  $areaLabel = $labels | Where-Object { $_ -like 'area/*' } | Select-Object -First 1
  $prompt = Get-AgentPrompt $issue.body

  # Validate required fields
  if (-not $tierLabel) {
    Write-Warning "  #$($issue.number) — missing tier/* label. Skipping."
    continue
  }
  if (-not $areaLabel) {
    Write-Warning "  #$($issue.number) — missing area/* label. Skipping."
    continue
  }
  if (-not $prompt) {
    Write-Warning "  #$($issue.number) — missing or unfilled agent-prompt block. Skipping."
    continue
  }

  # Shared-file guard — extract file paths from prompt lines that look like paths
  $promptLines = $prompt -split "`n" | ForEach-Object { $_.Trim() }
  $pathLikeLines = $promptLines | Where-Object { $_ -match '[\\/]' -or $_ -match '\.\w+$' }
  if (Test-TouchesSharedFiles $pathLikeLines) {
    Write-Warning "  #$($issue.number) — prompt references a shared coordinator file. Escalating to hitl."
    if (-not $DryRun) {
      gh issue edit $issue.number --add-label 'hitl' --remove-label 'afk/ready' 2>&1 | Out-Null
      gh issue comment $issue.number `
        --body 'AFK orchestrator: this issue references a shared coordinator file and cannot be dispatched automatically. Please handle manually (hitl).' `
        2>&1 | Out-Null
    }
    continue
  }

  # Determine branch and worktree path
  $branch = "$($config.branchPrefix)$($issue.number)"
  $worktreePath = Join-Path $worktreeRoot $issue.number.ToString()

  Write-Host "  #$($issue.number) — $($issue.title)"
  Write-Host "    Tier: $tierLabel  Area: $areaLabel  Branch: $branch"
  Write-Host "    Prompt preview: $($prompt.Substring(0, [Math]::Min(80, $prompt.Length)))..."

  if ($DryRun) {
    Write-Host "    [DRY RUN] Would create worktree at $worktreePath and open VS Code."
    $started++
    continue
  }

  # Create git worktree
  if (Test-Path $worktreePath) {
    Write-Warning "    Worktree path $worktreePath already exists. Skipping worktree creation."
  }
  else {
    Push-Location $repoRoot
    git worktree add $worktreePath -b $branch 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
      Write-Warning "    Failed to create worktree. Skipping issue #$($issue.number)."
      Pop-Location
      continue
    }
    Pop-Location
    Write-Host "    Worktree created at $worktreePath"
  }

  # Write the prompt to a start file in the worktree so the agent picks it up
  $startFile = Join-Path $worktreePath 'COPILOT_START.md'
  @"
# AFK Task — Issue #$($issue.number)

$prompt

---
*Generated by start-afk-sessions.ps1. Paste this prompt into the Copilot CLI
session started for this worktree, or enable the Agents Window and open this
folder as a new session. Use worktree isolation and enable \`/remote on\` for
remote monitoring.*
"@ | Set-Content $startFile -Encoding UTF8

  # Transition GitHub label
  gh issue edit $issue.number --add-label 'afk/in-progress' --remove-label 'afk/ready' 2>&1 | Out-Null

  # Open VS Code at the worktree — the user starts the Copilot CLI session from here
  # or it appears in the Agents Window automatically
  Start-Process 'code' -ArgumentList $worktreePath

  # Track in sessions.json
  $sessions += [PSCustomObject]@{
    issueNumber   = $issue.number
    title         = $issue.title
    branch        = $branch
    worktreePath  = $worktreePath
    tierLabel     = $tierLabel
    areaLabel     = $areaLabel
    promptPreview = $prompt.Substring(0, [Math]::Min(120, $prompt.Length))
    startedAt     = (Get-Date -Format 'o')
  }

  Write-Host "    VS Code opened. Start a Copilot CLI session in the Agents Window for this folder."
  Write-Host "    Enable remote monitoring with: /remote on"
  Write-Host ''

  $started++
}

# ── Save sessions ──────────────────────────────────────────────────────────────
if (-not $DryRun) {
  ConvertTo-Json -InputObject $sessions -Depth 5 | Set-Content $sessionsFile -Encoding UTF8
}

Write-Host ''
Write-Host "Done. $started session(s) started."
Write-Host "Run with -Monitor to check current session state."
Write-Host "Run validate-repository.ps1 after each PR merge."
