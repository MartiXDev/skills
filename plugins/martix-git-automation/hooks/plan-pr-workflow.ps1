[CmdletBinding()]
param(
  [Parameter()]
  [string] $RepositoryPath = (Get-Location).Path,

  [Parameter()]
  [string] $BranchName,

  [Parameter()]
  [string] $BaseBranch,

  [Parameter()]
  [string] $WorktreePath,

  [Parameter()]
  [string] $Remote = 'origin',

  [Parameter()]
  [AllowEmptyCollection()]
  [string[]] $Paths = @(),

  [Parameter()]
  [string] $CommitMessageFile,

  [Parameter()]
  [string] $Title,

  [Parameter()]
  [string] $BodyFile,

  [Parameter()]
  [switch] $Ready,

  [Parameter()]
  [switch] $Json
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

function Invoke-MartixGitPlan {
  param(
    [Parameter(Mandatory)] [string] $GitPath,
    [Parameter(Mandatory)] [string] $RepositoryRoot,
    [Parameter(Mandatory)] [string[]] $Arguments,
    [Parameter()] [int[]] $AllowedExitCode = @(0)
  )

  $result = Invoke-MartixNative -FilePath $GitPath -Arguments $Arguments -WorkingDirectory $RepositoryRoot
  if ($result.ExitCode -notin $AllowedExitCode) {
    $detail = $result.StandardError.Trim()
    if ([string]::IsNullOrWhiteSpace($detail)) { $detail = $result.StandardOutput.Trim() }
    throw "git $($Arguments -join ' ') failed with exit code $($result.ExitCode): $detail"
  }
  return $result
}

function Invoke-MartixAdapterJson {
  param(
    [Parameter(Mandatory)] [string] $ScriptName,
    [Parameter(Mandatory)] [string] $RepositoryRoot,
    [Parameter()] [string[]] $Arguments = @(),
    [Parameter()] [int[]] $AllowedExitCode = @(0)
  )

  $pwsh = Get-Command -Name pwsh -CommandType Application -ErrorAction Stop |
  Select-Object -First 1
  $scriptPath = Join-Path $PSScriptRoot $ScriptName
  $adapterArguments = @('-NoProfile', '-File', $scriptPath) + @($Arguments) + @('-Json')
  $result = Invoke-MartixNative -FilePath $pwsh.Source `
    -Arguments $adapterArguments -WorkingDirectory $RepositoryRoot
  if ($result.ExitCode -notin $AllowedExitCode) {
    $detail = @($result.StandardError.Trim(), $result.StandardOutput.Trim()) |
    Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    throw "$ScriptName failed with exit code $($result.ExitCode): $($detail -join '; ')"
  }
  if ([string]::IsNullOrWhiteSpace($result.StandardOutput)) {
    throw "$ScriptName did not return structured JSON output."
  }
  try {
    return ($result.StandardOutput | ConvertFrom-Json)
  }
  catch {
    throw "Unable to parse $ScriptName JSON output: $($_.Exception.Message)"
  }
}

function New-MartixPhase {
  param(
    [Parameter(Mandatory)] [string] $Phase,
    [Parameter(Mandatory)] [ValidateSet('perform', 'skip', 'ask', 'block')] [string] $Decision,
    [Parameter(Mandatory)] [string] $Evidence,
    [Parameter(Mandatory)] [string] $Action,
    [Parameter(Mandatory)] [string] $Confirmation,
    [Parameter(Mandatory)] [ValidateSet('completed', 'skipped', 'blocked', 'failed', 'unresolved')] [string] $Result,
    [Parameter()] [string] $Adapter,
    [Parameter()] [string[]] $Arguments = @()
  )

  return [pscustomobject][ordered]@{
    Phase        = $Phase
    Decision     = $Decision
    Evidence     = $Evidence
    Action       = $Action
    Confirmation = $Confirmation
    Result       = $Result
    Adapter      = $Adapter
    Arguments    = @($Arguments)
  }
}

function Get-MartixBranchRemote {
  param(
    [Parameter(Mandatory)] [string] $GitPath,
    [Parameter(Mandatory)] [string] $RepositoryRoot,
    [Parameter(Mandatory)] [string] $Branch
  )

  $result = Invoke-MartixGitPlan -GitPath $GitPath -RepositoryRoot $RepositoryRoot `
    -Arguments @('config', '--get', "branch.$Branch.remote") -AllowedExitCode @(0, 1)
  if ($result.ExitCode -eq 0 -and -not [string]::IsNullOrWhiteSpace($result.StandardOutput)) {
    return $result.StandardOutput.Trim()
  }
  return $null
}

function Get-MartixRemoteHead {
  param(
    [Parameter(Mandatory)] [string] $GitPath,
    [Parameter(Mandatory)] [string] $RepositoryRoot,
    [Parameter(Mandatory)] [string] $Remote,
    [Parameter(Mandatory)] [string] $Branch
  )

  $reference = "refs/heads/$Branch"
  $result = Invoke-MartixGitPlan -GitPath $GitPath -RepositoryRoot $RepositoryRoot `
    -Arguments @('ls-remote', '--heads', $Remote, $reference) -AllowedExitCode @(0, 1, 2, 128)
  if ($result.ExitCode -ne 0) {
    $detail = $result.StandardError.Trim()
    if ([string]::IsNullOrWhiteSpace($detail)) { $detail = $result.StandardOutput.Trim() }
    return [pscustomobject][ordered]@{
      Available = $false
      Head      = $null
      Error     = if ([string]::IsNullOrWhiteSpace($detail)) { "git ls-remote exited with code $($result.ExitCode)." } else { $detail }
    }
  }

  $line = @($result.StandardOutput -split '\r?\n' |
    Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
    Select-Object -First 1)
  if ($line.Count -eq 0) {
    return [pscustomobject][ordered]@{
      Available = $true
      Head      = $null
      Error     = $null
    }
  }

  $parts = @($line[0].Trim() -split '\s+')
  if ($parts.Count -lt 2 -or $parts[1] -cne $reference) {
    return [pscustomobject][ordered]@{
      Available = $false
      Head      = $null
      Error     = "Unexpected ls-remote response for '$reference'."
    }
  }

  return [pscustomobject][ordered]@{
    Available = $true
    Head      = $parts[0]
    Error     = $null
  }
}

try {
  $root = Get-MartixRepositoryRoot -RepositoryPath $RepositoryPath
  $gitCommand = Get-Command -Name git -CommandType Application -ErrorAction Stop |
  Select-Object -First 1
  $repository = Invoke-MartixAdapterJson -ScriptName 'inspect-repository.ps1' `
    -RepositoryRoot $root -Arguments @('-RepositoryPath', $root, '-Remote', $Remote)
  if (-not $repository.Valid) {
    throw "Repository inspection failed: $(@($repository.Errors) -join '; ')"
  }

  $currentBranch = if ($repository.Detached) { $null } else { [string] $repository.Branch }
  if ([string]::IsNullOrWhiteSpace($currentBranch)) { $currentBranch = $null }
  $head = [string] $repository.Head
  $resolvedBase = [string] $repository.BaseBranch
  if ([string]::IsNullOrWhiteSpace($resolvedBase)) { $resolvedBase = $null }
  $stagedPaths = @($repository.StagedPaths | ForEach-Object { [string] $_ })
  $unstagedPaths = @($repository.UnstagedPaths | ForEach-Object { [string] $_ })
  $remotes = @($repository.Remotes | ForEach-Object { [string] $_ })
  $explicitPaths = @($Paths | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
  $requestedBranch = if ([string]::IsNullOrWhiteSpace($BranchName)) { $null } else { $BranchName }
  $requestedBase = if ([string]::IsNullOrWhiteSpace($BaseBranch)) { $null } else { $BaseBranch }
  $isDirty = [bool] $repository.Dirty
  $hasStaged = $stagedPaths.Count -gt 0
  $hasUnstaged = $unstagedPaths.Count -gt 0

  $baseArguments = @('-RepositoryPath', $root)
  if ($null -ne $requestedBase) { $baseArguments += @('-BaseBranch', $requestedBase) }
  $baseForPr = if ($null -ne $requestedBase) { $requestedBase } else { $resolvedBase }
  if ($null -ne $requestedBase) { $resolvedBase = $requestedBase }

  $protectedBranches = @(
    $resolvedBase,
    'main',
    'master',
    @($repository.Policy.branch.trunkBranches),
    @($repository.Policy.worktree.protectedBranches)
  ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) -and $_ -ne '@default' } |
  Select-Object -Unique

  $currentBranchValidation = $null
  if ($null -ne $currentBranch) {
    $currentBranchValidation = Invoke-MartixAdapterJson -ScriptName 'validate-branch-name.ps1' `
      -RepositoryRoot $root -Arguments @($currentBranch, '-RepositoryPath', $root) `
      -AllowedExitCode @(0, 1)
  }
  $currentIsTopic = $null -ne $currentBranch -and
  [bool] $currentBranchValidation.Valid -and $currentBranch -notin $protectedBranches

  $branchDecision = 'skip'
  $branchEvidence = ''
  $branchAction = 'No branch mutation.'
  $branchConfirmation = 'n/a'
  $branchResult = 'skipped'
  $branchArguments = @()
  $effectiveBranch = $currentBranch
  $branchCreationBase = $resolvedBase

  if ($currentIsTopic -and ($null -eq $requestedBranch -or $requestedBranch -eq $currentBranch)) {
    $branchEvidence = "Current branch '$currentBranch' is a valid non-protected topic branch."
  }
  elseif ($null -eq $requestedBranch) {
    $branchDecision = 'ask'
    $branchEvidence = if ($null -eq $currentBranch) {
      'HEAD is detached and no topic branch candidate was supplied.'
    }
    elseif ($currentBranch -in $protectedBranches) {
      "Current branch '$currentBranch' is protected or a trunk branch."
    }
    else {
      "Current branch '$currentBranch' does not satisfy the configured topic-branch policy."
    }
    $branchAction = 'Ask for a validated topic branch name and optional base/worktree target.'
    $branchConfirmation = 'required before branch creation'
    $branchResult = 'unresolved'
  }
  else {
    $effectiveBranch = $requestedBranch
    $branchValidation = Invoke-MartixAdapterJson -ScriptName 'validate-branch-name.ps1' `
      -RepositoryRoot $root -Arguments @($requestedBranch, '-RepositoryPath', $root) `
      -AllowedExitCode @(0, 1)
    $collision = Invoke-MartixGitPlan -GitPath $gitCommand.Source -RepositoryRoot $root `
      -Arguments @('show-ref', '--verify', '--quiet', "refs/heads/$requestedBranch") -AllowedExitCode @(0, 1)
    $branchErrors = @($branchValidation.Errors)
    if (-not $branchValidation.Valid) {
      $branchDecision = 'block'
      $branchEvidence = "Requested branch '$requestedBranch' failed branch validation: $($branchErrors -join '; ')"
      $branchAction = 'No branch is created.'
      $branchConfirmation = 'n/a'
      $branchResult = 'blocked'
    }
    elseif ($collision.ExitCode -eq 0 -and $requestedBranch -ne $currentBranch) {
      $branchDecision = 'block'
      $branchEvidence = "Requested local branch '$requestedBranch' already exists."
      $branchAction = 'Use an explicit switch workflow or choose a new branch name.'
      $branchConfirmation = 'n/a'
      $branchResult = 'blocked'
    }
    elseif ($null -eq $resolvedBase) {
      $branchDecision = 'block'
      $branchEvidence = 'No local base branch could be resolved for branch creation.'
      $branchAction = 'Specify an existing local base branch.'
      $branchConfirmation = 'n/a'
      $branchResult = 'blocked'
    }
    elseif ($null -eq $currentBranch -and [string]::IsNullOrWhiteSpace($WorktreePath)) {
      $branchDecision = 'block'
      $branchEvidence = 'A detached HEAD cannot be changed in place by the branch adapter.'
      $branchAction = 'Provide a separate worktree path or switch to a branch first.'
      $branchConfirmation = 'n/a'
      $branchResult = 'blocked'
    }
    elseif (-not [string]::IsNullOrWhiteSpace($WorktreePath) -and $isDirty) {
      $branchDecision = 'block'
      $branchEvidence = 'The requested separate worktree would not contain the current dirty changes.'
      $branchAction = 'Use in-place branch creation for these changes or rerun from the new worktree.'
      $branchConfirmation = 'n/a'
      $branchResult = 'blocked'
    }
    else {
      if ($currentIsTopic -and $requestedBranch -ne $currentBranch) {
        $branchCreationBase = $currentBranch
      }
      $branchArguments = @('-RepositoryPath', $root, '-BranchName', $requestedBranch,
        '-BaseBranch', $branchCreationBase)
      if (-not [string]::IsNullOrWhiteSpace($WorktreePath)) {
        $branchArguments += @('-WorktreePath', $WorktreePath)
      }
      $branchArguments += @('-Apply', '-Confirm:$false', '-Json')
      $branchDecision = 'perform'
      $branchEvidence = "A new validated topic branch '$requestedBranch' is required."
      $branchAction = "Run create-branch.ps1 from '$branchCreationBase' and re-read branch, HEAD, and status."
      $branchConfirmation = 'required'
      $branchResult = 'unresolved'
    }
  }

  $branchPhase = New-MartixPhase -Phase 'branch' -Decision $branchDecision `
    -Evidence $branchEvidence -Action $branchAction -Confirmation $branchConfirmation `
    -Result $branchResult -Adapter $(if ($branchDecision -eq 'perform') { 'create-branch.ps1' } else { $null }) `
    -Arguments $branchArguments

  $branchReady = $branchDecision -in @('skip', 'perform')
  $selectedUnstagedPaths = @($explicitPaths | Where-Object { $_ -in $unstagedPaths })
  $stageDecision = 'skip'
  $stageEvidence = ''
  $stageAction = 'No staging mutation.'
  $stageConfirmation = 'n/a'
  $stageResult = 'skipped'
  $stageArguments = @()

  if (-not $branchReady -and $hasUnstaged) {
    $stageDecision = if ($branchDecision -eq 'block') { 'block' } else { 'ask' }
    $stageEvidence = if ($branchDecision -eq 'block') {
      'Staging depends on a blocked branch phase.'
    }
    else {
      'Unstaged changes are present, but branch selection is unresolved.'
    }
    $stageAction = 'Resolve the branch phase before selecting explicit paths or hunks.'
    $stageConfirmation = if ($stageDecision -eq 'block') { 'n/a' } else { 'required' }
    $stageResult = if ($stageDecision -eq 'block') { 'blocked' } else { 'unresolved' }
  }
  elseif (-not $hasUnstaged) {
    $stageEvidence = if ($hasStaged) { 'All current changes are already staged.' } else { 'No staged or unstaged changes exist.' }
  }
  elseif ($selectedUnstagedPaths.Count -eq 0 -and $hasStaged) {
    $stageEvidence = 'The supplied path set has no unstaged paths; the staged selection is retained.'
  }
  elseif ($explicitPaths.Count -eq 0) {
    $stageDecision = 'ask'
    $stageEvidence = "Unstaged paths require an explicit selection: $($unstagedPaths -join ', ')"
    $stageAction = 'Ask which paths or hunks belong to the reviewable change; never stage the whole worktree implicitly.'
    $stageConfirmation = 'required'
    $stageResult = 'unresolved'
  }
  else {
    $stageArguments = @('-RepositoryPath', $root, '-Paths') + $explicitPaths + @('-Apply', '-Confirm:$false', '-Json')
    $stageDecision = 'perform'
    $stageEvidence = "Explicit path selection supplied for unstaged changes: $($selectedUnstagedPaths -join ', ')"
    $stageAction = 'Run stage-paths.ps1 for the displayed explicit paths and re-read the index.'
    $stageConfirmation = 'required'
    $stageResult = 'unresolved'
  }

  $stagePhase = New-MartixPhase -Phase 'stage' -Decision $stageDecision `
    -Evidence $stageEvidence -Action $stageAction -Confirmation $stageConfirmation `
    -Result $stageResult -Adapter $(if ($stageDecision -eq 'perform') { 'stage-paths.ps1' } else { $null }) `
    -Arguments $stageArguments

  $reviewableCount = $null
  if ($null -ne $resolvedBase -and $null -ne $head) {
    $range = Invoke-MartixGitPlan -GitPath $gitCommand.Source -RepositoryRoot $root `
      -Arguments @('rev-list', '--count', "$resolvedBase..$head")
    $reviewableCount = [int] $range.StandardOutput.Trim()
  }
  $futureStaged = $hasStaged -or ($stageDecision -eq 'perform')
  $commitDecision = 'skip'
  $commitEvidence = ''
  $commitAction = 'No commit mutation.'
  $commitConfirmation = 'n/a'
  $commitResult = 'skipped'
  $commitArguments = @()

  if (-not $branchReady -or $stageDecision -in @('ask', 'block')) {
    if ($futureStaged -or $hasUnstaged) {
      $commitDecision = if ($branchDecision -eq 'block' -or $stageDecision -eq 'block') { 'block' } else { 'ask' }
      $commitEvidence = 'Commit depends on unresolved branch or staging choices.'
      $commitAction = 'Re-read the staged diff after the dependent phase and provide one reviewed commit message.'
      $commitConfirmation = if ($commitDecision -eq 'block') { 'n/a' } else { 'required' }
      $commitResult = if ($commitDecision -eq 'block') { 'blocked' } else { 'unresolved' }
    }
    else {
      $commitEvidence = 'No staged changes require a commit.'
    }
  }
  elseif (-not $futureStaged) {
    $commitEvidence = 'No staged changes exist; existing commits are left unchanged.'
  }
  elseif ([string]::IsNullOrWhiteSpace($CommitMessageFile)) {
    $commitDecision = 'ask'
    $commitEvidence = 'A staged reviewable diff exists but no reviewed commit message file was supplied.'
    $commitAction = 'Draft and validate one commit message, then rerun the planner with its temporary file.'
    $commitConfirmation = 'required'
    $commitResult = 'unresolved'
  }
  elseif (-not (Test-Path -LiteralPath $CommitMessageFile -PathType Leaf)) {
    $commitDecision = 'block'
    $commitEvidence = "Commit message file does not exist: $CommitMessageFile"
    $commitAction = 'Provide an existing reviewed message file.'
    $commitConfirmation = 'n/a'
    $commitResult = 'blocked'
  }
  else {
    $commitArguments = @('-RepositoryPath', $root, '-MessageFile', $CommitMessageFile,
      '-ExpectedHead', $head, '-Apply', '-Confirm:$false', '-Json')
    $commitDecision = 'perform'
    $commitEvidence = 'A staged reviewable diff and an explicit message file are present.'
    $commitAction = 'Run commit-staged.ps1 and re-read HEAD, status, and hook results.'
    $commitConfirmation = 'required'
    $commitResult = 'unresolved'
  }

  $commitPhase = New-MartixPhase -Phase 'commit' -Decision $commitDecision `
    -Evidence $commitEvidence -Action $commitAction -Confirmation $commitConfirmation `
    -Result $commitResult -Adapter $(if ($commitDecision -eq 'perform') { 'commit-staged.ps1' } else { $null }) `
    -Arguments $commitArguments

  $remoteExists = $Remote -in $remotes
  $upstream = if ($null -ne $currentBranch -and $null -ne $repository.Upstream) { [string] $repository.Upstream } else { $null }
  if ([string]::IsNullOrWhiteSpace($upstream)) { $upstream = $null }
  $pushRemote = if ($null -ne $upstream) {
    Get-MartixBranchRemote -GitPath $gitCommand.Source -RepositoryRoot $root -Branch $currentBranch
  }
  else {
    $Remote
  }
  if ([string]::IsNullOrWhiteSpace($pushRemote)) { $pushRemote = $Remote }
  $remoteInspection = $null
  $remoteHead = $null
  $remoteComparison = $null
  $remoteComparisonError = $null
  $remoteTargetExplicit = $PSBoundParameters.ContainsKey('Remote')
  $hasReviewableChange = $commitDecision -eq 'perform' -or
  ($null -ne $reviewableCount -and $reviewableCount -gt 0)
  if ($branchReady -and $commitDecision -notin @('ask', 'block') -and
    $null -eq $upstream -and $remoteTargetExplicit -and $remoteExists -and
    $hasReviewableChange -and -not [string]::IsNullOrWhiteSpace($effectiveBranch)) {
    $remoteInspection = Get-MartixRemoteHead -GitPath $gitCommand.Source -RepositoryRoot $root `
      -Remote $pushRemote -Branch $effectiveBranch
    if (-not $remoteInspection.Available) {
      $remoteComparisonError = $remoteInspection.Error
    }
    elseif ([string]::IsNullOrWhiteSpace($remoteInspection.Head)) {
      $remoteComparison = 'absent'
    }
    elseif ($remoteInspection.Head -ceq $head) {
      $remoteHead = $remoteInspection.Head
      $remoteComparison = 'same'
    }
    else {
      $remoteHead = $remoteInspection.Head
      $remoteIsAncestor = Invoke-MartixGitPlan -GitPath $gitCommand.Source -RepositoryRoot $root `
        -Arguments @('merge-base', '--is-ancestor', $remoteHead, $head) -AllowedExitCode @(0, 1, 128)
      if ($remoteIsAncestor.ExitCode -eq 0) {
        $remoteComparison = 'behind'
      }
      elseif ($remoteIsAncestor.ExitCode -eq 1) {
        $localIsAncestor = Invoke-MartixGitPlan -GitPath $gitCommand.Source -RepositoryRoot $root `
          -Arguments @('merge-base', '--is-ancestor', $head, $remoteHead) -AllowedExitCode @(0, 1, 128)
        if ($localIsAncestor.ExitCode -eq 0) {
          $remoteComparison = 'ahead'
        }
        elseif ($localIsAncestor.ExitCode -eq 1) {
          $remoteComparison = 'diverged'
        }
        else {
          $remoteComparisonError = $localIsAncestor.StandardError.Trim()
        }
      }
      else {
        $remoteComparisonError = $remoteIsAncestor.StandardError.Trim()
      }
      if ([string]::IsNullOrWhiteSpace($remoteComparisonError)) {
        $remoteComparisonError = "Unable to compare remote HEAD '$remoteHead' with local HEAD '$head'."
      }
    }
  }
  $pushDecision = 'skip'
  $pushEvidence = ''
  $pushAction = 'No push mutation.'
  $pushConfirmation = 'n/a'
  $pushResult = 'skipped'
  $pushArguments = @()

  if (-not $branchReady -or $commitDecision -in @('ask', 'block')) {
    $pushDecision = if ($branchDecision -eq 'block' -or $commitDecision -eq 'block') { 'block' } else { 'ask' }
    $pushEvidence = 'Push depends on unresolved branch or commit state.'
    $pushAction = 'Re-read HEAD and upstream after dependent phases before publishing.'
    $pushConfirmation = if ($pushDecision -eq 'block') { 'n/a' } else { 'required' }
    $pushResult = if ($pushDecision -eq 'block') { 'blocked' } else { 'unresolved' }
  }
  elseif (($null -eq $reviewableCount -or $reviewableCount -eq 0) -and $commitDecision -ne 'perform') {
    $pushEvidence = 'No reviewable commits exist between the current branch and its base.'
  }
  elseif ($null -ne $repository.Behind -and [int] $repository.Behind -gt 0) {
    $pushDecision = 'block'
    $pushEvidence = "The tracked upstream is ahead by $($repository.Behind) commit(s); publishing would require a merge or rebase decision."
    $pushAction = 'Do not push. Resolve divergence explicitly, then recompute the plan.'
    $pushConfirmation = 'n/a'
    $pushResult = 'blocked'
  }
  elseif ($null -ne $upstream -and [int] $repository.Ahead -eq 0) {
    $pushEvidence = "Upstream '$upstream' already contains HEAD '$head'."
  }
  elseif ($null -eq $upstream -and -not $remoteExists) {
    $pushDecision = 'block'
    $pushEvidence = "Remote '$Remote' is not configured and no upstream exists."
    $pushAction = 'Specify an existing remote and ref target.'
    $pushConfirmation = 'n/a'
    $pushResult = 'blocked'
  }
  elseif ($null -eq $upstream -and -not $PSBoundParameters.ContainsKey('Remote')) {
    $pushDecision = 'ask'
    $pushEvidence = "No upstream exists; the default remote '$Remote' was not explicitly confirmed."
    $pushAction = "Confirm publishing '$currentBranch' to '$Remote/$currentBranch'."
    $pushConfirmation = 'required'
    $pushResult = 'unresolved'
  }
  elseif ($null -eq $upstream -and $null -ne $remoteComparisonError) {
    $pushDecision = 'block'
    $pushEvidence = "Unable to verify remote '$pushRemote/$effectiveBranch': $remoteComparisonError"
    $pushAction = 'Resolve remote access and recompute the plan before publishing.'
    $pushConfirmation = 'n/a'
    $pushResult = 'blocked'
  }
  elseif ($null -eq $upstream -and $remoteComparison -eq 'same') {
    $remoteHead = [string] $remoteHead
    $pushEvidence = "Remote '$pushRemote/$effectiveBranch' already contains HEAD '$head'."
  }
  elseif ($null -eq $upstream -and $remoteComparison -in @('ahead', 'diverged')) {
    $pushDecision = 'block'
    $pushEvidence = "Remote '$pushRemote/$effectiveBranch' differs from HEAD '$head' ($remoteComparison at '$remoteHead'); publishing requires an explicit merge or rebase decision."
    $pushAction = 'Do not push. Resolve remote divergence explicitly, then recompute the plan.'
    $pushConfirmation = 'n/a'
    $pushResult = 'blocked'
  }
  else {
    $pushArguments = @('-RepositoryPath', $root, '-Remote', $pushRemote,
      '-BranchName', $effectiveBranch, '-ExpectedHead', $head,
      '-Apply', '-Confirm:$false', '-Json')
    $pushDecision = 'perform'
    $pushEvidence = if ($null -eq $upstream) {
      if ($remoteComparison -eq 'behind') {
        "HEAD '$head' can fast-forward the explicit target '$pushRemote/$effectiveBranch', which is currently '$remoteHead'."
      }
      else {
        "HEAD '$head' has reviewable commits and no upstream; the explicit target '$pushRemote/$effectiveBranch' has no branch head."
      }
    }
    else {
      "HEAD '$head' is ahead of upstream '$upstream' by $($repository.Ahead) commit(s)."
    }
    $pushAction = 'Run push-ref.ps1 without force options and re-read the remote tracking state.'
    $pushConfirmation = 'required'
    $pushResult = 'unresolved'
  }

  $pushPhase = New-MartixPhase -Phase 'push' -Decision $pushDecision `
    -Evidence $pushEvidence -Action $pushAction -Confirmation $pushConfirmation `
    -Result $pushResult -Adapter $(if ($pushDecision -eq 'perform') { 'push-ref.ps1' } else { $null }) `
    -Arguments $pushArguments

  $prInspection = $null
  if ($branchReady -and $null -ne $effectiveBranch -and $null -ne $baseForPr) {
    $prInspectArguments = @('-RepositoryPath', $root, '-HeadBranch', $effectiveBranch,
      '-BaseBranch', $baseForPr)
    $prInspection = Invoke-MartixAdapterJson -ScriptName 'inspect-pr.ps1' `
      -RepositoryRoot $root -Arguments $prInspectArguments -AllowedExitCode @(0, 2)
  }

  $prDecision = 'skip'
  $prEvidence = ''
  $prAction = 'No pull-request mutation.'
  $prConfirmation = 'n/a'
  $prResult = 'skipped'
  $prArguments = @()

  if (-not $branchReady -or $null -eq $effectiveBranch -or $null -eq $baseForPr) {
    $prDecision = if ($branchDecision -eq 'block' -or $pushDecision -eq 'block') { 'block' } else { 'ask' }
    $prEvidence = 'A valid branch and resolved base are required before PR inspection and creation.'
    $prAction = 'Resolve the branch and base phases, then rerun the PR planner.'
    $prConfirmation = if ($prDecision -eq 'block') { 'n/a' } else { 'required' }
    $prResult = if ($prDecision -eq 'block') { 'blocked' } else { 'unresolved' }
  }
  elseif ($null -eq $prInspection -or $prInspection.RemoteEvidence -ne 'available') {
    $prDecision = 'block'
    $prEvidence = if ($null -eq $prInspection) {
      'PR inspection was deferred because a prerequisite phase is unresolved.'
    }
    else {
      @($prInspection.Errors) -join '; '
    }
    $prAction = 'Install and authenticate gh, then rerun remote PR inspection.'
    $prConfirmation = 'n/a'
    $prResult = 'blocked'
  }
  elseif ([bool] $prInspection.DuplicateOpenPullRequest) {
    $existing = @($prInspection.OpenPullRequests)[0]
    $prEvidence = "An open PR already exists for '$effectiveBranch' -> '$baseForPr': $($existing.url)"
  }
  elseif ($pushDecision -in @('ask', 'block') -or $commitDecision -in @('ask', 'block')) {
    $prDecision = if ($pushDecision -eq 'block' -or $commitDecision -eq 'block') { 'block' } else { 'ask' }
    $prEvidence = 'PR creation depends on a pushed, reviewable branch.'
    $prAction = 'Complete and revalidate the dependent commit and push phases.'
    $prConfirmation = if ($prDecision -eq 'block') { 'n/a' } else { 'required' }
    $prResult = if ($prDecision -eq 'block') { 'blocked' } else { 'unresolved' }
  }
  elseif (($null -eq $reviewableCount -or $reviewableCount -eq 0) -and $commitDecision -ne 'perform') {
    $prDecision = 'block'
    $prEvidence = 'The branch has no reviewable commits relative to its base.'
    $prAction = 'Create or select a reviewed commit before opening a PR.'
    $prConfirmation = 'n/a'
    $prResult = 'blocked'
  }
  elseif ([string]::IsNullOrWhiteSpace($Title) -or [string]::IsNullOrWhiteSpace($BodyFile)) {
    $prDecision = 'ask'
    $prEvidence = 'No duplicate PR exists, but separate title and body fields are still required.'
    $prAction = 'Draft a title and body file, preserving head, base, and draft state as separate fields.'
    $prConfirmation = 'required'
    $prResult = 'unresolved'
  }
  elseif (-not (Test-Path -LiteralPath $BodyFile -PathType Leaf)) {
    $prDecision = 'block'
    $prEvidence = "PR body file does not exist: $BodyFile"
    $prAction = 'Provide an existing reviewed body file.'
    $prConfirmation = 'n/a'
    $prResult = 'blocked'
  }
  else {
    $prArguments = @('-RepositoryPath', $root, '-Title', $Title,
      '-BodyFile', $BodyFile, '-BaseBranch', $baseForPr,
      '-HeadBranch', $effectiveBranch, '-ExpectedHead', $head)
    if ($Ready) { $prArguments += '-Ready' }
    $prArguments += @('-Apply', '-Confirm:$false', '-Json')
    $prDecision = 'perform'
    $prEvidence = "No matching open PR exists; '$effectiveBranch' is reviewable and its remote state is available."
    $prAction = if ($Ready) {
      'Run create-pr.ps1 with separate title, body, head, base, and ready fields.'
    }
    else {
      'Run create-pr.ps1 with separate title, body, head, base, and draft fields.'
    }
    $prConfirmation = 'required'
    $prResult = 'unresolved'
  }

  $prPhase = New-MartixPhase -Phase 'pr' -Decision $prDecision `
    -Evidence $prEvidence -Action $prAction -Confirmation $prConfirmation `
    -Result $prResult -Adapter $(if ($prDecision -eq 'perform') { 'create-pr.ps1' } else { $null }) `
    -Arguments $prArguments

  $phases = @(
    (New-MartixPhase -Phase 'inspect' -Decision 'perform' `
      -Evidence "Repository '$root' inspected at HEAD '$head'." `
      -Action 'Read local Git state and, when prerequisites allow, structured PR state.' `
      -Confirmation 'n/a' -Result 'completed' -Adapter 'inspect-repository.ps1' `
      -Arguments @('-RepositoryPath', $root, '-Remote', $Remote, '-Json')),
    $branchPhase,
    $stagePhase,
    $commitPhase,
    $pushPhase,
    $prPhase
  )
  $actionPhases = @($phases | Where-Object { $_.Phase -ne 'inspect' })
  $blocking = @($actionPhases | Where-Object { $_.Decision -eq 'block' }).Count
  $asking = @($actionPhases | Where-Object { $_.Decision -eq 'ask' }).Count
  $performing = @($actionPhases | Where-Object { $_.Decision -eq 'perform' }).Count
  $overallDecision = if ($blocking -gt 0) { 'block' } elseif ($asking -gt 0) { 'ask' } elseif ($performing -gt 0) { 'perform' } else { 'skip' }
  $overallResult = if ($blocking -gt 0) { 'blocked' } elseif ($asking -gt 0 -or $performing -gt 0) { 'unresolved' } else { 'completed' }

  $result = [pscustomobject][ordered]@{
    Valid                      = $true
    Repository                 = $root
    Workflow                   = 'pr'
    Decision                   = $overallDecision
    Result                     = $overallResult
    Branch                     = $effectiveBranch
    CurrentBranch              = $currentBranch
    Head                       = $head
    BaseBranch                 = $baseForPr
    Remote                     = $Remote
    RemoteHead                 = $remoteHead
    RemoteInspection           = $remoteInspection
    Upstream                   = $upstream
    ReviewableCommitCount      = $reviewableCount
    StagedPaths                = @($stagedPaths)
    UnstagedPaths              = @($unstagedPaths)
    Phases                     = @($phases)
    RecomputeAfterEachMutation = $true
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 0
}
catch {
  $result = [pscustomobject]@{
    Valid      = $false
    Repository = $RepositoryPath
    Workflow   = 'pr'
    Decision   = 'block'
    Result     = 'failed'
    Errors     = @($_.Exception.Message)
  }
  Write-MartixResult -Result $result -Json:$Json
  exit 2
}