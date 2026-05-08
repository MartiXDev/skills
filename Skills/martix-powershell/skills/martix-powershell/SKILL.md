---
name: martix-powershell
description: >
  Standalone-first PowerShell cmdlet developer guidance for compiled C# cmdlet
  authoring and cmdlet-style advanced functions ([CmdletBinding()]), covering
  base class selection (Cmdlet vs PSCmdlet), parameter declaration and validation,
  pipeline input/output streaming, error handling (terminating vs non-terminating),
  confirmation and safety patterns (ShouldProcess/Force/WhatIf), dynamic
  parameters, and attribute validators.
license: MIT
---

> **Migration pending** — Full skill content will be migrated from
> [MartiXDev/ai-marketplace — src/skills/martix-powershell](https://github.com/MartiXDev/ai-marketplace/tree/main/src/skills/martix-powershell).

## MartiX PowerShell skill

This skill provides standalone-first guidance for PowerShell cmdlet development:

- Choosing between `Cmdlet` and `PSCmdlet` base classes.
- Declaring parameters with proper attributes and validation.
- Streaming pipeline input and output correctly.
- Handling terminating and non-terminating errors.
- Implementing ShouldProcess (WhatIf/Confirm) and Force patterns.
- Creating dynamic parameters.
- Writing cmdlet-style advanced functions with `[CmdletBinding()]`.

## When to use this skill

- Authoring compiled C# cmdlets for a binary PowerShell module.
- Writing advanced PowerShell functions with proper parameter validation.
- Reviewing cmdlet error handling or pipeline behavior.
- Implementing safety confirmations (ShouldProcess/Force) in cmdlets.
