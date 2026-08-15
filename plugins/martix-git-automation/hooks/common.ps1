Set-StrictMode -Version Latest

function Limit-MartixText {
  param(
    [AllowNull()]
    [string] $Text,
    [int] $Maximum = 32768
  )

  if ($null -eq $Text) {
    return ''
  }

  if ($Text.Length -le $Maximum) {
    return $Text
  }

  return $Text.Substring(0, $Maximum) + "`n[output truncated]"
}

function Invoke-MartixNative {
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $FilePath,

    [Parameter()]
    [AllowEmptyCollection()]
    [string[]] $Arguments = @(),

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string] $WorkingDirectory = (Get-Location).Path
  )

  $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
  $startInfo.FileName = $FilePath
  $startInfo.UseShellExecute = $false
  $startInfo.RedirectStandardOutput = $true
  $startInfo.RedirectStandardError = $true
  $startInfo.StandardOutputEncoding = [System.Text.UTF8Encoding]::new($false)
  $startInfo.StandardErrorEncoding = [System.Text.UTF8Encoding]::new($false)
  $startInfo.WorkingDirectory = $WorkingDirectory

  foreach ($argument in $Arguments) {
    [void] $startInfo.ArgumentList.Add([string] $argument)
  }

  try {
    $process = [System.Diagnostics.Process]::Start($startInfo)
    $stdoutTask = $process.StandardOutput.ReadToEndAsync()
    $stderrTask = $process.StandardError.ReadToEndAsync()
    $process.WaitForExit()
    $stdout = $stdoutTask.GetAwaiter().GetResult()
    $stderr = $stderrTask.GetAwaiter().GetResult()

    return [pscustomobject]@{
      FilePath       = $FilePath
      Arguments      = @($Arguments)
      ExitCode       = $process.ExitCode
      StandardOutput = Limit-MartixText -Text $stdout
      StandardError  = Limit-MartixText -Text $stderr
      Started        = $true
    }
  }
  catch {
    return [pscustomobject]@{
      FilePath       = $FilePath
      Arguments      = @($Arguments)
      ExitCode       = -1
      StandardOutput = ''
      StandardError  = Limit-MartixText -Text $_.Exception.Message
      Started        = $false
    }
  }
}

function ConvertFrom-MartixCommandText {
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $CommandText
  )

  $tokens = $null
  $parseErrors = $null
  $ast = [System.Management.Automation.Language.Parser]::ParseInput(
    $CommandText,
    [ref] $tokens,
    [ref] $parseErrors
  )
  if ($parseErrors.Count -gt 0 -or $ast.EndBlock.Statements.Count -ne 1) {
    throw 'Configured hook commands must contain one executable command and its literal arguments.'
  }

  $pipeline = $ast.EndBlock.Statements[0]
  if ($pipeline.PipelineElements.Count -ne 1) {
    throw 'Configured hook commands cannot contain pipelines, separators, or redirections.'
  }
  $command = $pipeline.PipelineElements[0]
  $elements = @($command.CommandElements)
  if ($elements.Count -eq 0 -or $elements | Where-Object {
      $_ -isnot [System.Management.Automation.Language.StringConstantExpressionAst] -and
      $_ -isnot [System.Management.Automation.Language.CommandParameterAst]
    }) {
    throw 'Configured hook commands may use only literal executable and argument values.'
  }

  return [pscustomobject]@{
    FilePath  = [string] $elements[0].Value
    Arguments = @($elements | Select-Object -Skip 1 | ForEach-Object { [string] $_.Value })
  }
}

function Get-MartixRepositoryRoot {
  param(
    [Parameter()]
    [string] $RepositoryPath = (Get-Location).Path
  )

  $candidate = [System.IO.Path]::GetFullPath($RepositoryPath)
  if (-not (Test-Path -LiteralPath $candidate -PathType Container)) {
    throw "Repository path does not exist: $candidate"
  }

  $result = Invoke-MartixNative `
    -FilePath 'git' `
    -Arguments @('rev-parse', '--show-toplevel') `
    -WorkingDirectory $candidate

  if ($result.ExitCode -ne 0) {
    throw "Unable to find a Git repository at '$candidate': $($result.StandardError.Trim())"
  }

  $root = $result.StandardOutput.Trim()
  if ([string]::IsNullOrWhiteSpace($root)) {
    throw "Git returned an empty repository root for '$candidate'."
  }

  return [System.IO.Path]::GetFullPath($root)
}

function Get-MartixProperty {
  param(
    [Parameter(Mandatory)]
    [object] $Object,
    [Parameter(Mandatory)]
    [string] $Name,
    [AllowNull()]
    [object] $Default = $null
  )

  $property = $Object.PSObject.Properties[$Name]
  if ($null -eq $property) {
    return $Default
  }

  if ($property.Value -is [System.Collections.IEnumerable] -and
    $property.Value -isnot [string]) {
    return , $property.Value
  }

  return $property.Value
}

function Get-MartixPropertyNames {
  param([AllowNull()][object] $Object)

  if ($null -eq $Object) {
    return @()
  }

  return @(
    $Object.PSObject.Properties |
    Where-Object { $_.MemberType -eq 'NoteProperty' } |
    Select-Object -ExpandProperty Name
  )
}

function New-MartixGitDefaults {
  param([Parameter(Mandatory)][string] $ConfigPath)

  return [pscustomobject]@{
    ConfigPath         = $ConfigPath
    ConfigExists       = $false
    schemaVersion      = 1
    conventionalCommit = [pscustomobject]@{
      types           = @()
      scopes          = @()
      requireScope    = $false
      maxHeaderLength = $null
    }
    branch             = [pscustomobject]@{
      specVersion   = '1.1.0'
      prefixes      = @()
      maxLength     = $null
      trunkBranches = @()
    }
    pullRequest        = [pscustomobject]@{
      defaultDraft = $true
      titlePolicy  = 'repository'
      baseBranch   = $null
    }
    release            = [pscustomobject]@{
      enabled         = $false
      analyzerPreset  = $null
      tagFormat       = 'v${version}'
      releaseBranches = @()
    }
    hooks              = [pscustomobject]@{
      enabled         = $false
      preCommitChecks = @()
      prePushCommand  = $null
    }
    worktree           = [pscustomobject]@{
      enableRemoteEvidence = $false
      reportOnSessionStop  = $false
      protectedBranches    = @('@default')
      scanRoots            = @()
    }
  }
}

function Test-MartixStringArray {
  param(
    [AllowNull()]
    [object] $Value,
    [Parameter(Mandatory)]
    [string] $Path,
    [Parameter(Mandatory)]
    [AllowEmptyCollection()]
    [System.Collections.Generic.List[string]] $Errors
  )

  if ($null -eq $Value -or $Value -is [string] -or $Value -isnot [System.Collections.IEnumerable]) {
    [void] $Errors.Add("$Path must be an array of non-empty strings.")
    return
  }

  $index = 0
  foreach ($item in $Value) {
    if ($item -isnot [string] -or [string]::IsNullOrWhiteSpace($item)) {
      [void] $Errors.Add("$Path[$index] must be a non-empty string.")
    }
    $index++
  }
}

function Test-MartixNullablePositiveInteger {
  param(
    [AllowNull()]
    [object] $Value,
    [Parameter(Mandatory)]
    [string] $Path,
    [Parameter(Mandatory)]
    [AllowEmptyCollection()]
    [System.Collections.Generic.List[string]] $Errors
  )

  if ($null -eq $Value) {
    return
  }

  $isInteger = $Value -is [byte] -or $Value -is [short] -or
  $Value -is [int] -or $Value -is [long]
  if (-not $isInteger -or [int64] $Value -lt 1) {
    [void] $Errors.Add("$Path must be null or a positive integer.")
  }
}

function Test-MartixNullableString {
  param(
    [AllowNull()]
    [object] $Value,
    [Parameter(Mandatory)]
    [string] $Path,
    [Parameter(Mandatory)]
    [AllowEmptyCollection()]
    [System.Collections.Generic.List[string]] $Errors
  )

  if ($null -ne $Value -and $Value -isnot [string]) {
    [void] $Errors.Add("$Path must be null or a string.")
  }
}

function Test-MartixAllowedProperties {
  param(
    [Parameter(Mandatory)]
    [object] $Object,
    [Parameter(Mandatory)]
    [string] $Path,
    [Parameter(Mandatory)]
    [string[]] $Allowed,
    [Parameter(Mandatory)]
    [AllowEmptyCollection()]
    [System.Collections.Generic.List[string]] $Errors
  )

  foreach ($name in Get-MartixPropertyNames -Object $Object) {
    if ($name -notin $Allowed) {
      [void] $Errors.Add("$Path.$name is unknown. Remove it or use a supported schema property.")
    }
    if ($name -match '(?i)token|secret|password|credential|private.?key') {
      [void] $Errors.Add("$Path.$name cannot contain credentials or private keys.")
    }
  }
}

function Test-MartixGitConfigDocument {
  param(
    [Parameter(Mandatory)]
    [object] $Document
  )

  $errors = [System.Collections.Generic.List[string]]::new()
  if ($null -eq $Document -or $Document -is [string] -or $Document -isnot [pscustomobject]) {
    [void] $errors.Add('The configuration root must be a JSON object.')
    return [pscustomobject]@{ Valid = $false; Errors = @($errors) }
  }

  $rootAllowed = @('$schema', 'schemaVersion', 'conventionalCommit',
    'branch', 'pullRequest', 'release', 'hooks', 'worktree')
  Test-MartixAllowedProperties -Object $Document -Path '$' `
    -Allowed $rootAllowed -Errors $errors

  $version = Get-MartixProperty -Object $Document -Name 'schemaVersion'
  if ($null -eq $version) {
    [void] $errors.Add('$.schemaVersion is required and must be 1.')
  }
  elseif ($version -ne 1) {
    [void] $errors.Add("$.schemaVersion '$version' is unsupported; use schema version 1.")
  }

  $commit = Get-MartixProperty -Object $Document -Name 'conventionalCommit'
  if ($null -ne $commit) {
    if ($commit -isnot [pscustomobject]) {
      [void] $errors.Add('$.conventionalCommit must be an object.')
    }
    else {
      Test-MartixAllowedProperties -Object $commit -Path '$.conventionalCommit' `
        -Allowed @('types', 'scopes', 'requireScope', 'maxHeaderLength') -Errors $errors
      $types = Get-MartixProperty -Object $commit -Name 'types'
      $scopes = Get-MartixProperty -Object $commit -Name 'scopes'
      if ($null -ne $types) { Test-MartixStringArray $types '$.conventionalCommit.types' $errors }
      if ($null -ne $scopes) { Test-MartixStringArray $scopes '$.conventionalCommit.scopes' $errors }
      $requireScope = Get-MartixProperty -Object $commit -Name 'requireScope'
      if ($null -ne $requireScope -and $requireScope -isnot [bool]) {
        [void] $errors.Add('$.conventionalCommit.requireScope must be boolean.')
      }
      $maxHeaderLength = Get-MartixProperty -Object $commit -Name 'maxHeaderLength'
      if ($null -ne $maxHeaderLength) {
        Test-MartixNullablePositiveInteger $maxHeaderLength '$.conventionalCommit.maxHeaderLength' $errors
      }
    }
  }

  $branch = Get-MartixProperty -Object $Document -Name 'branch'
  if ($null -ne $branch) {
    if ($branch -isnot [pscustomobject]) {
      [void] $errors.Add('$.branch must be an object.')
    }
    else {
      Test-MartixAllowedProperties -Object $branch -Path '$.branch' `
        -Allowed @('specVersion', 'prefixes', 'maxLength', 'trunkBranches') -Errors $errors
      $specVersion = Get-MartixProperty -Object $branch -Name 'specVersion'
      if ($null -ne $specVersion -and $specVersion -ne '1.1.0') {
        [void] $errors.Add('$.branch.specVersion must be the pinned value 1.1.0.')
      }
      foreach ($name in @('prefixes', 'trunkBranches')) {
        $value = Get-MartixProperty -Object $branch -Name $name
        if ($null -ne $value) { Test-MartixStringArray $value "`$.branch.$name" $errors }
      }
      $maxLength = Get-MartixProperty -Object $branch -Name 'maxLength'
      if ($null -ne $maxLength) { Test-MartixNullablePositiveInteger $maxLength '$.branch.maxLength' $errors }
    }
  }

  $pullRequest = Get-MartixProperty -Object $Document -Name 'pullRequest'
  if ($null -ne $pullRequest) {
    if ($pullRequest -isnot [pscustomobject]) {
      [void] $errors.Add('$.pullRequest must be an object.')
    }
    else {
      Test-MartixAllowedProperties -Object $pullRequest -Path '$.pullRequest' `
        -Allowed @('defaultDraft', 'titlePolicy', 'baseBranch') -Errors $errors
      $defaultDraft = Get-MartixProperty -Object $pullRequest -Name 'defaultDraft'
      if ($null -ne $defaultDraft -and $defaultDraft -isnot [bool]) {
        [void] $errors.Add('$.pullRequest.defaultDraft must be boolean.')
      }
      $titlePolicy = Get-MartixProperty -Object $pullRequest -Name 'titlePolicy'
      if ($null -ne $titlePolicy -and $titlePolicy -notin @('repository', 'conventional-commit', 'free')) {
        [void] $errors.Add('$.pullRequest.titlePolicy must be repository, conventional-commit, or free.')
      }
      Test-MartixNullableString (Get-MartixProperty $pullRequest 'baseBranch') '$.pullRequest.baseBranch' $errors
    }
  }

  $release = Get-MartixProperty -Object $Document -Name 'release'
  if ($null -ne $release) {
    if ($release -isnot [pscustomobject]) {
      [void] $errors.Add('$.release must be an object.')
    }
    else {
      Test-MartixAllowedProperties -Object $release -Path '$.release' `
        -Allowed @('enabled', 'analyzerPreset', 'tagFormat', 'releaseBranches') -Errors $errors
      $enabled = Get-MartixProperty -Object $release -Name 'enabled'
      if ($null -ne $enabled -and $enabled -isnot [bool]) {
        [void] $errors.Add('$.release.enabled must be boolean.')
      }
      Test-MartixNullableString (Get-MartixProperty $release 'analyzerPreset') '$.release.analyzerPreset' $errors
      $tagFormat = Get-MartixProperty -Object $release -Name 'tagFormat'
      if ($null -ne $tagFormat) {
        if ($tagFormat -isnot [string] -or [string]::IsNullOrWhiteSpace($tagFormat)) {
          [void] $errors.Add('$.release.tagFormat must be a non-empty string.')
        }
        elseif ([regex]::Matches($tagFormat, '\$\{version\}').Count -ne 1) {
          [void] $errors.Add('$.release.tagFormat must contain ${version} exactly once.')
        }
      }
      $releaseBranches = Get-MartixProperty -Object $release -Name 'releaseBranches'
      if ($null -ne $releaseBranches) { Test-MartixStringArray $releaseBranches '$.release.releaseBranches' $errors }
    }
  }

  $hooks = Get-MartixProperty -Object $Document -Name 'hooks'
  if ($null -ne $hooks) {
    if ($hooks -isnot [pscustomobject]) {
      [void] $errors.Add('$.hooks must be an object.')
    }
    else {
      Test-MartixAllowedProperties -Object $hooks -Path '$.hooks' `
        -Allowed @('enabled', 'preCommitChecks', 'prePushCommand') -Errors $errors
      $enabled = Get-MartixProperty -Object $hooks -Name 'enabled'
      if ($null -ne $enabled -and $enabled -isnot [bool]) {
        [void] $errors.Add('$.hooks.enabled must be boolean.')
      }
      $checks = Get-MartixProperty -Object $hooks -Name 'preCommitChecks'
      if ($null -ne $checks) { Test-MartixStringArray $checks '$.hooks.preCommitChecks' $errors }
      Test-MartixNullableString (Get-MartixProperty $hooks 'prePushCommand') '$.hooks.prePushCommand' $errors
    }
  }

  $worktree = Get-MartixProperty -Object $Document -Name 'worktree'
  if ($null -ne $worktree) {
    if ($worktree -isnot [pscustomobject]) {
      [void] $errors.Add('$.worktree must be an object.')
    }
    else {
      Test-MartixAllowedProperties -Object $worktree -Path '$.worktree' `
        -Allowed @('enableRemoteEvidence', 'reportOnSessionStop', 'protectedBranches', 'scanRoots') -Errors $errors
      foreach ($name in @('enableRemoteEvidence', 'reportOnSessionStop')) {
        $value = Get-MartixProperty -Object $worktree -Name $name
        if ($null -ne $value -and $value -isnot [bool]) {
          [void] $errors.Add("`$.worktree.$name must be boolean.")
        }
      }
      foreach ($name in @('protectedBranches', 'scanRoots')) {
        $value = Get-MartixProperty -Object $worktree -Name $name
        if ($null -ne $value) { Test-MartixStringArray $value "`$.worktree.$name" $errors }
      }
    }
  }

  return [pscustomobject]@{
    Valid  = $errors.Count -eq 0
    Errors = @($errors)
  }
}

function Read-MartixGitConfig {
  param(
    [Parameter(Mandatory)]
    [string] $RepositoryRoot,
    [Parameter()]
    [string] $ConfigPath
  )

  $resolvedPath = if ([string]::IsNullOrWhiteSpace($ConfigPath)) {
    Join-Path $RepositoryRoot '.martix-git.json'
  }
  else {
    [System.IO.Path]::GetFullPath((Join-Path $RepositoryRoot $ConfigPath))
  }
  $config = New-MartixGitDefaults -ConfigPath $resolvedPath
  if (-not (Test-Path -LiteralPath $resolvedPath -PathType Leaf)) {
    return $config
  }

  try {
    $document = Get-Content -LiteralPath $resolvedPath -Raw | ConvertFrom-Json
  }
  catch {
    throw "Unable to parse '$resolvedPath': $($_.Exception.Message)"
  }

  $validation = Test-MartixGitConfigDocument -Document $document
  if (-not $validation.Valid) {
    throw "Invalid MartiX Git configuration '$resolvedPath':`n- $($validation.Errors -join "`n- ")"
  }

  foreach ($name in @('conventionalCommit', 'branch', 'pullRequest', 'release', 'hooks', 'worktree')) {
    $source = Get-MartixProperty -Object $document -Name $name
    if ($null -eq $source) { continue }
    $target = Get-MartixProperty -Object $config -Name $name
    foreach ($propertyName in Get-MartixPropertyNames -Object $source) {
      $target.$propertyName = $source.$propertyName
    }
  }

  $config.ConfigExists = $true
  return $config
}

function Write-MartixResult {
  param(
    [Parameter(Mandatory)]
    [object] $Result,
    [switch] $Json
  )

  if ($Json) {
    $Result | ConvertTo-Json -Depth 20
    return
  }

  if ($Result.PSObject.Properties.Name -contains 'Valid' -and $Result.Valid) {
    Write-Output 'valid'
  }
  else {
    Write-Output 'invalid'
  }

  if ($Result.PSObject.Properties.Name -contains 'Errors') {
    foreach ($errorMessage in @($Result.Errors)) {
      Write-Output ("- " + $errorMessage)
    }
  }
}
