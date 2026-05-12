---
name: martix-powershell
description: Standalone-first PowerShell cmdlet developer guidance for compiled C# cmdlet authoring and cmdlet-style advanced functions that declare [CmdletBinding()]. Covers base class selection (Cmdlet vs PSCmdlet), [CmdletBinding()] declaration, parameter declaration and validation, parameter sets, pipeline input/output streaming via Begin/ProcessRecord/End, error handling (terminating vs non-terminating), confirmation and safety patterns (ShouldProcess/Force/WhatIf), dynamic parameters, and attribute validators. Use when authoring or reviewing compiled PowerShell cmdlets in C#, authoring advanced functions that declare [CmdletBinding()] and follow the cmdlet contract, selecting the right base class, designing parameter sets, implementing pipeline processing methods, handling errors with ErrorRecord, wiring ShouldProcess/Force/WhatIf safety patterns, or packaging a cmdlet module. Does not apply to generic PowerShell scripts or functions without [CmdletBinding()].
license: Complete terms in LICENSE.txt
---

# MartiX PowerShell cmdlet router

- Standalone-first skill package focused on compiled PowerShell cmdlet
  development decisions for C# authors targeting PowerShell 7+.
- Keep decisions grounded in the bundled rule files and reference maps.
- Use [AGENTS.md](./AGENTS.md) when the task crosses multiple workstreams or
  needs the long-form review routes, package inventory, or maintainer guidance.

## When to use this skill

- Author a new compiled PowerShell cmdlet class in C# from scratch.
- Choose between `Cmdlet` and `PSCmdlet` as the base class.
- Author a PowerShell advanced function that declares `[CmdletBinding()]` and
  follows the cmdlet contract (`Begin`/`Process`/`End`, `WriteObject`,
  `$PSCmdlet.ThrowTerminatingError`, `ShouldProcess`, etc.).
- Declare parameters with `[Parameter]`, mandatory flags, position, and
  validation attributes.
- Design parameter sets for mutually exclusive argument groups.
- Implement `BeginProcessing` / `Begin`, `ProcessRecord` / `Process`, and
  `EndProcessing` / `End` for correct pipeline input handling and object
  streaming.
- Wire `ShouldProcess`, `ShouldContinue`, and the `Force` parameter for
  safe destructive operations.
- Handle terminating and non-terminating errors using `ErrorRecord` and
  `WriteError` / `ThrowTerminatingError`.
- Author dynamic parameters via `IDynamicParameters` (compiled) or
  `DynamicParam` blocks (advanced function).
- Package a cmdlet as a binary module (`.dll` + `.psd1` manifest).
- Add validation attributes (`ValidateSet`, `ValidateRange`, `ValidatePattern`,
  etc.) or `OutputType` declarations.
- Author comment-based help blocks (`.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER`,
  `.EXAMPLE`, `.OUTPUTS`, `.NOTES`) or MAML/PlatyPS help for compiled cmdlets.
- Align `.OUTPUTS` help-block text with `[OutputType]` declarations.
- Avoid script-body aliases, enforce `Write-Host` / `Read-Host` scope rules, or
  apply the Tier-5 repo style overlay for `.ps1` / `.psm1` files.

## Not for this skill

- Generic PowerShell scripts or functions **without** `[CmdletBinding()]`.
- Pipeline-only scripts that do not follow the cmdlet contract.
- Automation scripts, runbooks, or DSC resources.
- For broader C# or .NET guidance, use `martix-dotnet-csharp`.

## Start with the closest workstream

1. Pick the closest workstream below.
2. Read only the linked rules needed for the current change.
3. Pull reference maps in only after the core workstream is chosen.
4. Open [AGENTS.md](./AGENTS.md) for cross-workstream review routes, package
   inventory, and maintainer guidance.

## Rule library by workstream

## Foundation and base class selection

- Use for base class choice (`Cmdlet` vs `PSCmdlet`), `[Cmdlet]` attribute
  declaration (verb, noun, `SupportsShouldProcess`, `SupportsTransactions`),
  `OutputType`, assembly structure, project file shape, `.psd1` module
  manifest, and `Import-Module` wiring.
- Rules:
  - [PowerShell cmdlet foundation — base class and attribute](./rules/foundation-base-class-attribute.md)
  - [PowerShell cmdlet foundation — project and module shape](./rules/foundation-project-module-shape.md)
- Map: [Foundation map](./references/foundation-map.md)

## Naming and conventions

- Use for approved verb selection from `Verbs*` typed constants, verb group
  semantics, paired inverse verb patterns (`Add`/`Remove`, `Start`/`Stop`),
  vendor noun prefix conventions, the standard parameter name table (`Path`,
  `Name`, `Force`, `Credential`, `PassThru`, `InputObject`), common parameter
  injection rules, and the `[Credential]` attribute pattern.
- Rules:
  - [PowerShell naming — approved verbs and cmdlet name contract](./rules/naming-approved-verbs-cmdlet-contract.md)
  - [PowerShell naming — parameter and common names](./rules/naming-parameter-and-common-names.md)
- Map: [Naming and conventions map](./references/naming-map.md)

## Parameters, validation, and sets

- Use for `[Parameter]` attribute options (`Mandatory`, `Position`,
  `ParameterSetName`, `HelpMessage`), validation attribute stacking,
  standard parameter names, parameter set design, the default parameter set,
  uniqueness requirement per set, and `IDynamicParameters` for runtime-declared
  parameters.
- Rules:
  - [PowerShell parameters — declaration and validation](./rules/parameters-declaration-validation.md)
  - [PowerShell parameters — sets and dynamic parameters](./rules/parameters-sets-dynamic.md)
  - [PowerShell parameters — pipeline binding](./rules/parameters-pipeline-binding.md)
- Map: [Parameters and validation map](./references/parameters-validation-map.md)

## Input processing and output streaming

- Use for `BeginProcessing`, `ProcessRecord`, `EndProcessing`, and
  `StopProcessing` override patterns, correct sequencing of object streaming,
  `WriteObject` semantics, null handling, avoiding text output in pipeline
  cmdlets, and `OutputType` declarations.
- Rules:
  - [PowerShell pipeline — input processing methods](./rules/pipeline-input-processing-methods.md)
  - [PowerShell pipeline — output and streaming](./rules/pipeline-output-streaming.md)
- Map: [Pipeline map](./references/pipeline-map.md)

## Error handling

- Use for the terminating vs. non-terminating decision, `ErrorRecord`
  construction (exception, identifier, `ErrorCategory`, target object),
  `WriteError` vs. `ThrowTerminatingError`, error action preferences, and
  standard error categories.
- Rules:
  - [PowerShell error handling — terminating and non-terminating](./rules/error-handling-terminating-nonterminating.md)
  - [PowerShell error handling — ErrorRecord construction](./rules/error-handling-errorrecord-construction.md)
- Map: [Error handling and categories map](./references/error-handling-categories-map.md)

## Confirmation, safety, and transactions

- Use for `SupportsShouldProcess = true`, `ShouldProcess` call patterns,
  `ShouldContinue` for high-impact operations, `ConfirmImpact` level selection,
  `WhatIf` / `Confirm` automatic parameters, the `Force` parameter bypass
  semantics, and `SupportsTransactions` for transactional cmdlets.
- Rules:
  - [PowerShell confirmation — ShouldProcess and ShouldContinue](./rules/confirmation-shouldprocess-shouldcontinue.md)
  - [PowerShell confirmation — Force parameter and non-interactive safety](./rules/confirmation-force-parameter.md)
- Map: [Confirmation and safety map](./references/confirmation-safety-map.md)

## Advanced patterns and extensibility

- Use for `IDynamicParameters`, parameter aliases, `ScriptBlock` invocation
  from cmdlet context, `SessionState` access via `PSCmdlet`, credential
  parameters, and transaction support (`SupportsTransactions`,
  `CurrentPSTransaction`).
- Rules:
  - [PowerShell advanced patterns — dynamic parameters and aliases](./rules/advanced-dynamic-parameters-alias.md)
  - [PowerShell advanced patterns — transactions and jobs](./rules/advanced-transactions-jobs.md)
- Map: [Advanced patterns map](./references/advanced-patterns-map.md)

## Attributes and validators

- Use for `ValidateSet`, `ValidateRange`, `ValidatePattern`, `ValidateScript`,
  `ValidateLength`, `ValidateCount`, `ValidateNotNull`, `ValidateNotNullOrEmpty`,
  custom validation attributes, and `OutputType` declarations. For approved
  verb selection and naming conventions, see the Naming workstream above.
- Rule:
  - [PowerShell attributes and validators](./rules/attributes-validators-outputtype.md)
- Map: [Attributes and validators map](./references/attributes-validators-map.md)

## Documentation, help, and style

- Use for comment-based help block structure and required sections (`.SYNOPSIS`,
  `.DESCRIPTION`, `.PARAMETER`, `.EXAMPLE`, `.OUTPUTS`, `.NOTES`) for advanced
  functions, MAML/PlatyPS help for compiled cmdlets, `.OUTPUTS`/`[OutputType]`
  alignment, script-body alias avoidance, `Read-Host` prohibition, `Write-Host`
  stream semantics, and the Tier-5 repo style overlay for `.ps1`/`.psm1` files.
- Rule:
  - [PowerShell documentation, help, and style](./rules/documentation-help-style.md)
- Map: [Documentation and style map](./references/documentation-style-map.md)

## Advanced scenarios

- Use for cmdlet testing patterns, help authoring integration, formatting
  extensions, and integration examples. These are linked references, not rule
  files.
- Reference: [PowerShell cmdlet cookbook index](./references/cookbook-index.md)

## Package conventions

- Every rule follows the shared section contract in
  [rules/_sections.md](./rules/_sections.md): `Purpose`, `Default guidance`,
  `Avoid`, `Review checklist`, `Related files`, and `Source anchors`.
- Use [the rule template](./templates/rule-template.md) for new rules,
  [the research pack template](./templates/research-pack-template.md) for
  scoped source inventories, and
  [the comparison matrix template](./templates/comparison-matrix-template.md)
  for external comparisons.
- Use [metadata.json](./metadata.json) as the registration-ready inventory for
  entrypoints, workstream coverage, and distribution notes.
- The taxonomy and preferred ordering live in
  [assets/taxonomy.json](./assets/taxonomy.json) and
  [assets/section-order.json](./assets/section-order.json).

## Standalone-first note

- This skill is authored as a standalone package under `skills`.
- If you document or install the package directly, use
  `npx skills add <source>` rather than `npx skill add`.
- Keep PowerShell cmdlet-specific guidance here. Pull broader C# or .NET
  guidance from `martix-dotnet-csharp` only when the task clearly widens
  beyond compiled cmdlet development.
